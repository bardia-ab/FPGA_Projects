library ieee;
use ieee.std_logic_1164.all;
-------------------------------------
entity OLED_Top is
    port(
        i_Clk_P		:	in		std_logic;
		i_Clk_N		:	in		std_logic;
		i_Power		:	in		std_logic;
		i_Img_Load	:	in		std_logic;
		i_CLR_Disp	:	in		std_logic;
		o_D_C		:	out		std_logic;
		o_Res		:	out		std_logic;
		o_VCCEN		:	out		std_logic;
		o_PMODEN	:	out		std_logic;
		o_CS		:	out		std_logic;
		o_SCK		:	out		std_logic;
		o_MOSI		:	out		std_logic
    );
end entity;
-------------------------------------
architecture behavioral of OLED_Top is

    component clk_wiz_0
		port
		(
			clk_out1          : out    std_logic;
			clk_in1_p         : in     std_logic;
			clk_in1_n         : in     std_logic
		);
	end component;

    COMPONENT vio_0
        PORT (
            clk        : IN STD_LOGIC;
            probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    END COMPONENT;

    signal	w_Clk		    :	std_logic;
	signal	w_ROM_Data		:	std_logic_vector(7 downto 0);
	signal	w_ROM_Addr		:	std_logic_vector(13 downto 0);
    signal  w_SPI_Send      :   std_logic;
    signal  w_SPI_Done      :   std_logic;
    signal  DC              :   std_logic;
    signal  w_SPI_Din       :   std_logic_vector(7 downto 0);

    signal  w_Power	        :   std_logic;    
    signal  w_Img_Load      :   std_logic;
    signal  w_CLR_Disp      :   std_logic;
    
    signal  power	        :   std_logic;    
	signal  load      :   std_logic;
    signal  clr      :   std_logic;

begin

    MMCM : clk_wiz_0
		port map ( 
			clk_out1 	=> w_Clk,
			clk_in1_p 	=> i_Clk_P,
			clk_in1_n 	=> i_Clk_N
		);

    Debounce_1  :   entity work.debounce
        generic map(
            clk_freq    =>  1e8, 
            stable_time =>  20
        )
        port map(
            clk         =>  w_Clk,
            reset_n     =>  '1',
            button      =>  i_Power,
            result      =>  w_Power
        );
    
    Debounce_2  :   entity work.debounce
        generic map(
            clk_freq    =>  1e8, 
            stable_time =>  20
        )
        port map(
            clk         =>  w_Clk,
            reset_n     =>  '1',
            button      =>  i_CLR_Disp,
            result      =>  w_CLR_Disp
        );

    Debounce_3  :   entity work.debounce
        generic map(
            clk_freq    =>  1e8, 
            stable_time =>  20
        )
        port map(
            clk         =>  w_Clk,
            reset_n     =>  '1',
            button      =>  i_Img_Load,
            result      =>  w_Img_Load
        );

    ROM_Inst    :   entity work.BRAM
        generic map(
            g_Init_File     =>  "C:\Users\t26607bb\Desktop\Interface_Course\oled\Img.txt",
            g_Data_Width    =>  8,
            g_Addr_Width    =>  14
        )
        port map(
            i_Clk           =>  w_Clk,
            i_Enable        =>  '1',
            i_RW            =>  '1',
            i_Addr          =>  w_ROM_Addr,
            i_Data_In       =>  x"00",
            o_Data_Out      =>  w_ROM_Data
        );

    SPI_Master_Inst :   entity work.SPI_Master
        generic map(
            g_Mode      =>  "11",
            g_N_Bits    =>  8,
            g_Sys_Freq  =>  1e8,
            g_SPI_Freq  =>  625e4,
            g_t_Setup   =>  80.0e-9,
            g_t_Hold    =>  70.0e-9,
            g_t_Turn    =>  200.0e-9
        )
        port map(
            i_Clk       =>  w_Clk,
            i_Send      =>  w_SPI_Send,
            i_Data_In	=>  w_SPI_Din,
            i_MISO      =>  '0',
            o_MOSI      =>  o_MOSI,
            o_SCLK      =>  o_SCK,
            o_CS        =>  o_CS,
            o_Done      =>  w_SPI_Done
        );

    OLED_FSM_Inst    :   entity work.OLED_FSM
            port map(
                i_Clk       =>  w_Clk,
                i_Power     =>  w_Power,
                i_CLR_Disp  =>  w_CLR_Disp,
                i_Img_Load  =>  w_Img_Load,
                i_SPI_Done  =>  w_SPI_Done,
                i_ROM_Data  =>  w_ROM_Data,
                o_ROM_Addr  =>  w_ROM_Addr,
                o_SPI_Send  =>  w_SPI_Send,
                o_SPI_Din   =>  w_SPI_Din,
                o_D_C       =>  o_D_C,
                o_Res       =>  o_Res,
                o_VCCEN     =>  o_VCCEN,
                o_PMODEN    =>  o_PMODEN
            );
	
end architecture;