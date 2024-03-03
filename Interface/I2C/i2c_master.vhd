library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------
entity I2C_Master is
    generic(
        g_Sys_Freq      :   integer :=  1e8; --Hz
        g_I2C_Freq      :   integer :=  4e5 --Hz
    );
    port(
        i_Clk           :   in      std_logic;
        i_CMD_Valid     :   in      std_logic;
        i_Last_Rd_Byte  :   in      std_logic;
        i_CMD           :   in      std_logic_vector(2 downto 0);
        i_Data_In       :   in      std_logic_vector(7 downto 0);
        o_Data_Out      :   out     std_logic_vector(7 downto 0);
        o_Ack           :   out     std_logic;
        o_Busy          :   out     std_logic;
        o_Done          :   out     std_logic;
        ---- I2C Lines -----
        o_SCL           :   out     std_logic;
        io_SDA          :   inout   std_logic
    );
end entity;
-----------------------------------
architecture behavioral of I2C_Master is

    ---------------------- Constants -----------------------------
    constant    c_Half_Period       :   integer := (g_Sys_Freq / (2 * g_I2C_Freq));
    constant    c_Quarter_Period    :   integer := (g_Sys_Freq / (4 * g_I2C_Freq));
    constant    c_START             :   std_logic_vector(2 downto 0)    := "000";
    constant    c_WRITE             :   std_logic_vector(2 downto 0)    := "001";
    constant    c_READ              :   std_logic_vector(2 downto 0)    := "010";
    constant    c_STOP              :   std_logic_vector(2 downto 0)    := "011";
    constant    c_RESTART           :   std_logic_vector(2 downto 0)    := "100";
    ---------------------- Types -----------------------------
    type t_States is (s_IDLE, s_START_1, s_START_2, s_HOLD, s_STOP_1, s_STOP_2, s_RESTART,
                      s_DATA_1, s_DATA_2, s_DATA_3, s_DATA_4, s_DATA_END);
    signal  r_State                 :   t_States    := s_IDLE;                      
    ---------------------- Registers -----------------------------
    signal  r_CMD_Valid             :   std_logic;
    signal  r_CMD                   :   std_logic_vector(2 downto 0);
    signal  r_Tri_Slct              :   std_logic   := '1';
    signal  r_Busy                  :   std_logic   := '0';
    signal  r_Done                  :   std_logic   := '0';
    signal  r_SCL                   :   std_logic   := '1';
    signal  r_SDA                   :   std_logic   := '1';
    ---------------------- Shift Registers -----------------------------
    signal  r_Rx_Shift_Reg          :   std_logic_vector(8 downto 0);
    signal  r_Tx_Shift_Reg          :   std_logic_vector(8 downto 0);
    ---------------------- Counters -----------------------------
    signal  r_Bit_Cntr              :   integer range 0 to 8                    := 8;
    signal  r_Bit_Width_Cntr        :   integer range 0 to c_Half_Period - 1    := c_Half_Period - 1;

begin

    process(i_Clk)
        impure function time_elapsed (reset_value   :   integer) return boolean is
            variable    v_Result    :   boolean;
        begin
            if (r_Bit_Width_Cntr > 0) then
                r_Bit_Width_Cntr    <=  r_Bit_Width_Cntr - 1;
                v_Result            :=  False;
            else
                r_Bit_Width_Cntr    <=  reset_value;
                v_Result            :=  True;
            end if;
            return v_Result;
        end time_elapsed;
    begin

        if rising_edge(i_Clk) then

            r_CMD_Valid <=  i_CMD_Valid;
            -------- Default -------
            r_SCL   <=  '1';
            r_SDA   <=  '1';
            r_Done  <=  '0';

            case    r_State is
            when    s_IDLE      =>
                r_Busy  <=  '0';
                r_CMD   <=  i_CMD;

                if (r_CMD_Valid = '0' and i_CMD_Valid = '1' and r_CMD = c_START) then
                    r_Busy              <=  '1';
                    r_SDA               <=  '0';
                    r_Bit_Width_Cntr    <=  (c_Half_Period - 1);
                    r_State             <=  s_START_1;
                end if;
            when    s_START_1   =>
                r_SDA   <=  '0';

                if time_elapsed(c_Half_Period - 1) then
                    r_SDA               <=  '0';
                    r_SCL               <=  '0';
                    r_Bit_Cntr          <=  8;
                    r_Bit_Width_Cntr    <=  (c_Half_Period - 1);
                    r_State             <=  s_START_2;
                end if;
            when    s_START_2   =>
                r_SDA   <=  '0';
                r_SCL   <=  '0';
                
                if time_elapsed(c_Half_Period - 1) then
                    r_SDA               <=  '0';
                    r_SCL               <=  '0';
                    r_CMD               <=  i_CMD;
                    r_Bit_Width_Cntr    <=  (c_Half_Period - 1);
                    r_State             <=  s_HOLD;
                end if;
            when    s_HOLD      =>
                r_SDA           <=  '0';
                r_SCL           <=  '0';
                r_Busy          <=  '0';
                r_Tx_Shift_Reg  <=  i_Data_In & i_Last_Rd_Byte;

                if (r_CMD_Valid = '0' and i_CMD_Valid = '1') then
                    if (r_CMD = c_WRITE or r_CMD = c_READ) then
                        r_Busy              <=  '1';
                        r_SDA               <=  r_Tx_Shift_Reg(r_Bit_Cntr) and r_Tri_Slct;
                        r_SCL               <=  '0';
                        r_Bit_Width_Cntr    <=  (c_Quarter_Period - 1);
                        r_State             <=  s_DATA_1;
                    elsif (r_CMD = c_STOP) then
                        r_Busy  <=  '1';
                        r_SDA   <=  '0';
                        r_State <=  s_STOP_1;
                    elsif (r_CMD = c_RESTART) then
                        r_Busy  <=  '1';
                        r_State <=  s_RESTART;
                    end if;
                end if;
            when    s_DATA_1    =>
                r_SCL   <=  '0';
                r_SDA   <=  r_Tx_Shift_Reg(r_Bit_Cntr) and r_Tri_Slct;

                if time_elapsed(c_Quarter_Period - 1) then
                    r_SCL   <=  '1';
                    r_State <=  s_DATA_2;
                end if;
            when    s_DATA_2    =>
                r_SDA   <=  r_Tx_Shift_Reg(r_Bit_Cntr) and r_Tri_Slct;

                if time_elapsed(c_Quarter_Period - 1) then
                    r_Rx_Shift_Reg(r_Bit_Cntr)  <=  r_SDA;
                    r_State                     <=  s_DATA_3;
                end if;
            when    s_DATA_3    =>
                r_SDA   <=  r_Tx_Shift_Reg(r_Bit_Cntr) and r_Tri_Slct;

                if time_elapsed(c_Quarter_Period - 1) then
                    r_SCL   <=  '0';
                    r_State <=  s_DATA_4;
                end if;
            when    s_DATA_4    =>
                r_SCL   <=  '0';
                r_SDA   <=  r_Tx_Shift_Reg(r_Bit_Cntr) and r_Tri_Slct;

                if time_elapsed(c_Quarter_Period - 1) then
                    if (r_Bit_Cntr > 0) then
                        r_Bit_Cntr  <=  r_Bit_Cntr - 1;
                        r_State     <=  s_DATA_1;
                    else
                        r_Bit_Cntr  <=  8;
                        r_SCL       <=  '0';
                        r_SDA       <=  '0';
                        r_Done      <=  '1';
                        r_CMD       <=  i_CMD;
                        r_State     <=  s_HOLD;
                        -- r_State     <=  s_DATA_END;
                    end if;
                end if;
            -- when    s_DATA_END  =>
            --     r_Done  <=  '1';
            --     r_State <=  s_HOLD;
            when    s_STOP_1    =>
                r_SDA   <=  '0';

                if time_elapsed(c_Half_Period - 1) then
                    r_State <=  s_STOP_2;
                end if;
            when    s_STOP_2    =>
                if time_elapsed(c_Half_Period - 1) then
                    r_State <=  s_IDLE;
                end if;
            when    s_RESTART   =>
                if time_elapsed(c_Half_Period - 1) then
                    r_SDA   <=  '0';
                    r_State <=  s_START_1;
                end if;
            when    others      =>
                null;
            end case;

        end if;

    end process;
    
    r_Tri_Slct  <=  '1' when    ((r_CMD = c_WRITE and r_Bit_Cntr /= 0) or (r_CMD = c_READ and r_Bit_Cntr = 0))  else    '0';
    o_Ack       <=  r_Rx_Shift_Reg(0);
    o_Busy      <=  r_Busy;
    o_Done      <=  r_Done;
    o_Data_Out  <=  r_Rx_Shift_Reg(8 downto 1);
    o_SCL       <=  'Z'   when(r_SCL = '1')  else    '0';
    io_SDA      <=  'Z'   when(r_SDA = '1')  else    '0';

end architecture;