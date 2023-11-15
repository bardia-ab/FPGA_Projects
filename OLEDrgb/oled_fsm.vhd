library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
------------------------------------
entity OLED_FSM is
    generic (g_Sys_Freq :   integer := 1e8);
    port(
        i_Clk       :   in      std_logic;
        i_Power     :   in      std_logic;
        i_CLR_Disp  :   in      std_logic;
        i_Img_Load  :   in      std_logic;
        i_SPI_Done  :   in      std_logic;
        i_ROM_Data  :   in      std_logic_vector(7 downto 0);
        o_ROM_Addr  :   out     std_logic_vector(13 downto 0);
        o_SPI_Send  :   out     std_logic;  
        o_SPI_Din   :   out     std_logic_vector(7 downto 0);
        o_D_C       :   out     std_logic;
        o_Res       :   out     std_logic;
        o_VCCEN     :   out     std_logic;
        o_PMODEN    :   out     std_logic
    );
end entity;
------------------------------------
architecture behavioral of OLED_FSM is

    -------------- Constants ---------------------
	constant	c_Turn_On		:	std_logic_vector(7 downto 0)	:= x"AF";
	constant	c_Turn_Off		:	std_logic_vector(7 downto 0)	:= x"AE";
    constant	c_N_Commands	:	integer							:= 44;
    constant	c_BRAM_Top		:	integer							:= (96 * 64 * 2);
    -------------- Types ---------------------
	type t_ON_Type is (s_Idle, s_PMODEN, s_Delay, s_Reset, s_Reset_Wait, s_Send_Commands, s_SPI_Done, s_Decision, s_Display_On);
    type t_LOAD_Type is (s_Idle, s_Load_Init, s_Send_Commands, s_SPI_Done, s_Decision_1, s_Send_Data, s_Decision_2);
    type t_CLR_Type is (s_Idle, s_CLR_Init, s_Send_Commands, s_SPI_Done, s_Decision);
    type t_OFF_Type is (s_Idle, s_OFF_Init, s_Display_OFF, s_VCCEN, s_Wait, s_PMODEN);
        
    type t_c_memory is array (integer range <>) of std_logic_vector(7 downto 0);
    -------------- I/O Regs ---------------------
    signal  r_Power         :   std_logic;
    signal  r_CLR_Disp      :   std_logic;
    signal  r_Img_Load      :   std_logic;
    signal  r_SPI_Done      :   std_logic;
    signal  r_ROM_Addr      :   integer range 0 to c_BRAM_Top - 1;
    signal  r_SPI_Send      :   std_logic;
    signal  r_SPI_Din       :   std_logic_vector(7 downto 0);
    signal  r_D_C           :   std_logic;
    signal  r_Res           :   std_logic                       := '1';
    signal  r_VCCEN         :   std_logic                       := '0';
    signal  r_PMODEN        :   std_logic                       := '0';
    signal  r_Power_On      :   std_logic                       := '0';
    -------------- Delay ---------------------
    signal  r_En_Delay      :   std_logic                       := '0';
    signal  r_Max_Count     :   std_logic_vector(25 downto 0);
    signal  r_Done_Delay    :   std_logic;
    -------------- Counters ---------------------
	signal	r_Wait_Cntr		:	integer                         := 0;
	signal	r_Command_Index	:	integer range 0 to c_N_Commands	:= 0;
	signal	r_CLR_Index		:	integer range 0 to 4			:= 4;
	-------------- State Regs ---------------------
	signal	r_State_On		:	t_ON_Type	:= s_Idle;
	signal	r_State_CLR		:	t_CLR_Type	:= s_Idle;
	signal	r_State_Load	:	t_LOAD_Type	:= s_Idle;
	signal	r_State_Off		:	t_OFF_Type	:= s_Idle;

    signal	r_State_On_Next	    :	t_ON_Type;
    signal	r_State_Load_Next	:	t_LOAD_Type;
	-------------- Memories ---------------------
    signal	r_ON_Commands		:	t_c_memory(0 to 43)	:= (x"FD", x"12", x"AE", x"A0", x"72", x"A1", x"00", x"A2", x"00",
												            x"A4", x"A8", x"3F", x"AD", x"8E", x"B0", x"0B", x"B1", x"31",
												            x"B3", x"F0", x"8A", x"64", x"8B", x"78", x"8C", x"64", x"BB",
												            x"3A", x"BE", x"3E", x"87", x"06", x"81", x"91", x"82", x"50",
												            x"83", x"7D", x"2E", x"25", x"00", x"00", x"5F", x"3F");
    signal	r_LOAD_Commands		:	t_c_memory(0 to 5)	:= (x"15", x"00", x"5F", x"75", x"00", x"3F");
    signal	r_CLR_Commands		:	t_c_memory(0 to 4)	:= (x"25", x"00", x"00", x"5F", x"3F");

begin
  
    Delay_Inst  :   entity work.delay_gen
        port map(
            i_Clk       =>  i_Clk,
            i_En        =>  r_En_Delay,
            i_Max_Count =>  r_Max_Count,
            o_Done      =>  r_Done_Delay  
        );

    process(i_Clk)
        function get_max_count(delay    :   real) return std_logic_vector is
            constant    c_Max_Count :   integer := integer(ceil(delay * real(g_Sys_Freq)));
        begin
            return std_logic_vector(to_unsigned(c_Max_Count, 26));
        end get_max_count;
    begin
        if rising_edge(i_Clk) then
            r_Power     <=  i_Power;
            r_CLR_Disp  <=  i_CLR_Disp; 
            r_Img_Load  <=  i_Img_Load; 
            r_SPI_Done  <=  i_SPI_Done; 
            r_Wait_Cntr <=  r_Wait_Cntr + 1;    
            ------ Default ------
            r_SPI_Send  <=  '0';
            r_En_Delay  <=  '0'; 

            ------- Turn_On_Sequence ------
            case r_State_On is
                when s_Idle =>
                    null;
                when s_PMODEN =>
                    r_D_C           <=  '0';
                    r_Res           <=  '1';
                    r_PMODEN        <=  '1';
                    r_VCCEN         <=  '0';
                    r_Command_Index <=  0;
                    r_Max_Count     <=  get_max_count(30.0e-3);
                    r_State_On_Next <=  s_Reset;
                    r_State_On      <=  s_Delay;
                when s_Delay =>
                    r_En_Delay  <=  '1';
                    if (r_Done_Delay = '1') then
                        r_State_On  <=  r_State_On_Next;
                    end if;

                when s_Reset =>
                    r_Res           <=  '0';
                    r_Max_Count     <=  get_max_count(4.0e-6);
                    r_State_On_Next <=  s_Reset_Wait;
                    r_State_On      <=  s_Delay;

                when s_Reset_Wait =>
                    r_Res           <=  '1';
                    r_Max_Count     <=  get_max_count(4.0e-6);
                    r_State_On_Next <=  s_Send_Commands;
                    r_State_On      <=  s_Delay;

                when s_Send_Commands =>
                    r_SPI_Din       <=  r_ON_Commands(r_Command_Index);
                    r_SPI_Send      <=  '1';
                    r_State_On      <=  s_SPI_Done;

                when s_SPI_Done =>
                    if (r_SPI_Done = '1') then
                        r_State_On  <=  s_Decision;
                    end if;

                when s_Decision =>
                    if (r_Command_Index <   r_ON_Commands'right) then
                        r_Command_Index <=  r_Command_Index + 1;
                        r_State_On      <=  s_Send_Commands;
                    else
                        r_VCCEN         <=  '1';
                        r_Command_Index <=  0;
                        r_Max_Count     <=  get_max_count(30.0e-3);
                        r_State_On_Next <=  s_Display_On;
                        r_State_On      <=  s_Delay;
                    end if;

                when s_Display_On =>
                    r_SPI_Din       <=  c_Turn_On;
                    r_SPI_Send      <=  '1';
                    r_Max_Count     <=  get_max_count(110.0e-3);
                    r_State_On_Next <=  s_Idle;
                    r_State_On      <=  s_Delay;

            end case;
            ------- Load_Sequence ------
            case r_State_Load is
                when s_Idle =>
                    null;
                when s_Load_Init =>
                    r_D_C           <=  '0';
                    r_ROM_Addr      <=  0;
                    r_Command_Index <=  0;
                    r_State_Load    <=  s_Send_Commands;

                when s_Send_Commands =>
                    r_SPI_Din           <=  r_LOAD_Commands(r_Command_Index);
                    r_SPI_Send          <=  '1';
                    r_State_Load_Next   <=  s_Decision_1;
                    r_State_Load        <=  s_SPI_Done;

                when s_SPI_Done =>
                    if (r_SPI_Done = '1') then
                        r_State_Load    <=  r_State_Load_Next;
                    end if;

                when s_Decision_1 =>
                    if (r_Command_Index < r_LOAD_Commands'right) then
                        r_Command_Index <=  r_Command_Index + 1;
                        r_State_Load    <=  s_Send_Commands;
                    else
                        r_Command_Index <=  0;
                        r_D_C           <=  '1';
                        r_State_Load    <=  s_Send_Data;
                    end if;

                when s_Send_Data =>
                    r_SPI_Din           <=  i_ROM_Data;
                    r_SPI_Send          <=  '1';
                    r_State_Load_Next   <=  s_Decision_2;
                    r_State_Load        <=  s_SPI_Done;

                when s_Decision_2 =>
                    if (r_ROM_Addr < c_BRAM_Top - 1) then
                        r_ROM_Addr      <=  r_ROM_Addr + 1;
                        r_State_Load    <=  s_Send_Data;
                    else
                        r_State_Load    <=  s_Idle;
                    end if;

            end case;
            ------- Clear_Sequence ------
            case r_State_CLR is
                when s_Idle =>
                    null;
                when s_CLR_Init =>
                    r_D_C           <=  '0';
                    r_Command_Index <=  0; 
                    r_State_CLR     <=  s_Send_Commands;

                when s_Send_Commands =>
                    r_SPI_Din   <=  r_CLR_Commands(r_Command_Index); 
                    r_SPI_Send  <=  '1';
                    r_State_CLR <=  s_SPI_Done;

                when s_SPI_Done =>
                    if (r_SPI_Done = '1') then
                        r_State_CLR    <=  s_Decision;
                    end if;

                when s_Decision =>
                    if (r_Command_Index < r_CLR_Commands'right) then
                        r_Command_Index <=  r_Command_Index + 1;
                        r_State_CLR     <=  s_Send_Commands;
                    else
                        r_State_CLR     <=  s_Idle;
                    end if;

            end case;
            ------- Turn_Off_Sequence ------
            case r_State_Off is
                when s_Idle =>
                    null;
                when s_OFF_Init =>
                    r_D_C       <=  '0';
                    r_State_Off <=  s_Display_OFF;

                when s_Display_OFF =>
                    r_SPI_Din   <=  c_Turn_Off;
                    r_SPI_Send  <=  '1';
                    r_State_Off <=  s_VCCEN;

                when s_VCCEN =>
                    if (r_SPI_Done = '1') then
                        r_VCCEN        <=  '0';
                        r_Max_Count    <= get_max_count(410.0e-3);
                        r_State_Off    <=  s_Wait;
                    end if;

                when s_Wait =>
                    r_En_Delay  <=  '1';
                    if (r_Done_Delay = '1') then
                        r_State_OFF  <=  s_PMODEN;
                    end if;

                when s_PMODEN =>
                    r_PMODEN    <=  '0';
                    r_State_Off <=  s_Idle;

            end case;

            if (r_Power = '0' and i_Power = '1') then
                r_State_On  <=  s_PMODEN;
            end if;

            if (r_Img_Load = '0' and i_Img_Load = '1') then
                r_State_Load  <=  s_Load_Init;
            end if;

            if (r_CLR_Disp = '0' and i_CLR_Disp = '1') then
                r_State_CLR <=  s_CLR_Init;
            end if;

            if (r_Power = '1' and i_Power = '0') then
                r_State_Off  <=  s_OFF_Init;
            end if;

        end if;
    end process;

    o_SPI_Send  <=  r_SPI_Send;
    o_SPI_Din   <=  r_SPI_Din;
    o_D_C       <=  r_D_C;
    o_Res       <=  r_Res;
    o_VCCEN     <=  r_VCCEN;
    o_PMODEN    <=  r_PMODEN;
    o_ROM_Addr  <=  std_logic_vector(to_unsigned(r_ROM_Addr, o_ROM_Addr'length));

end architecture;