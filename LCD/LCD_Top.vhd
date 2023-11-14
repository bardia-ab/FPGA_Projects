library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
-------------------------------------
entity LCD_Top is
    port(
        i_Clk_P     :   in      std_logic;
        i_Clk_N     :   in      std_logic;
        i_Shift     :   in      std_logic;
        i_Update    :   in      std_logic;
        i_Init      :   in      std_logic;
        o_RS        :   out     std_logic;
        o_RW        :   out     std_logic;
        o_E         :   out     std_logic;
        io_DB       :   inout   std_logic_vector(7 downto 0)
    );
end entity;
-------------------------------------
architecture behavioral of LCD_Top is

    function char2bin(inp  :   character) return std_logic_vector is	
    begin
    	return std_logic_vector(to_unsigned(character'pos(inp), 8));
    end char2bin;

    component clk_wiz_0
        port(
            Clk_100         : out    std_logic;
            clk_in1_p       : in     std_logic;
            clk_in1_n       : in     std_logic
        );
    end component;

    constant    c_Function_Set      :   std_logic_vector(9 downto 0)    := "0000111100";
    constant    c_Display_On_Off    :   std_logic_vector(9 downto 0)    := "0000001100";
    constant    c_Display_Clear     :   std_logic_vector(9 downto 0)    := "0000000001";
    constant    c_Entry_Mode_Set    :   std_logic_vector(9 downto 0)    := "0000000110";
    constant    c_Shift_Display     :   std_logic_vector(9 downto 0)    := "0000011000";
    constant    c_DDRAM_Address     :   std_logic_vector(9 downto 0)    := "0010000000";

    type t_Array is array(0 to 1) of string(0 to 39);

    signal  r_Lines         :   t_Array     := ("First Line Interface Project with FPGA!!", "Second Line of LCD Interface with FPGA!!");
    signal  r_Pointer       :   std_logic_vector(0 downto 0)   := "0";
    signal  w_Clk_100       :   std_logic;
    signal  w_Command_Data  :   std_logic_vector(9 downto 0);
    signal  w_Shift         :   std_logic;
    signal  w_Update        :   std_logic;
    signal  w_Init        	:   std_logic;
    signal  w_DDRAM_Addr    :   std_logic_vector(5 downto 0);
    signal	w_Data			:	std_logic_vector(7 downto 0);
    signal  w_ored_Addr     :   std_logic;
    signal  r_ored_Addr     :   std_logic;

begin

    MMCM_100MHz : clk_wiz_0
        port map ( 
            Clk_100     => w_Clk_100,
            clk_in1_p   => i_Clk_P,
            clk_in1_n   => i_Clk_N
        );

    Debouncer_1 :   entity work.debounce
        generic map(
            clk_freq        =>  1e8,
            stable_time     =>  20
        )
        port map(
            clk             =>  w_Clk_100,
            reset_n         =>  '1',
            button          =>  i_Init,
            result          =>  w_Init
        );

    Debouncer_2 :   entity work.debounce
        generic map(
            clk_freq        =>  1e8,
            stable_time     =>  20
        )
        port map(
            clk             =>  w_Clk_100,
            reset_n         =>  '1',
            button          =>  i_Update,
            result          =>  w_Update
        );

    Debouncer_3 :   entity work.debounce
        generic map(
            clk_freq        =>  1e8,
            stable_time     =>  20
        )
        port map(
            clk             =>  w_Clk_100,
            reset_n         =>  '1',
            button          =>  i_Shift,
            result          =>  w_Shift
        );
    
    LCD_Controller_Inst   :   entity work.LCD_Controller
        generic map(g_Sys_Freq => 1e8)
        port map(
            i_Clk           =>  w_Clk_100,    
            i_Data          =>  w_Data,
            i_Init          =>  w_Init,    
            i_Update        =>  w_Update,    
            i_Shift         =>  w_Shift,    
            o_Busy          =>  open,    
            o_DDRAM_Addr    =>  w_DDRAM_Addr,    
            o_RS            =>  o_RS,    
            o_RW            =>  o_RW,    
            o_E             =>  o_E,    
            io_DB           =>  io_DB
        );


    process(w_Clk_100)
    begin
        if rising_edge(w_Clk_100) then
            r_ored_Addr <=  w_ored_Addr;

            if (w_DDRAM_Addr = std_logic_vector(to_unsigned(39, w_DDRAM_Addr'length))) then
                r_Pointer   <= not r_Pointer;
            end if;

        end if;
    end process;
    
    w_Data	        <=	char2bin(r_Lines(to_integer(unsigned(r_Pointer)))(to_integer(unsigned(w_DDRAM_Addr))));
    w_ored_Addr     <=  or_reduce(w_DDRAM_Addr);

end architecture;