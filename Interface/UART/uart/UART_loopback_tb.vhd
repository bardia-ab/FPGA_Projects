Library IEEE;
Use IEEE.std_logic_1164.all;
---------------------------------
Entity UART_loopback_tb is
End Entity;
---------------------------------
Architecture Behavioral of UART_loopback_tb is
	
	signal	Clk_p		:	std_logic						:=	'1';
	signal	Clk_n		:	std_logic						:=	'0';
	signal	Data_In		:	std_logic_vector(7 downto 0)	:=	(others => '0');
	signal	Send_Int	:	std_logic						:=	'0';
	signal	Rx			:	std_logic;
	signal	Busy_Int_Tx	:	std_logic;
	signal	Busy_Int_Rx	:	std_logic;
	signal	Valid_Int	:	std_logic;
	signal	Data_Out	:	std_logic_vector(7 downto 0);
	
	constant Clk_Period	:	time							:=	10ns;

begin

	UART_Tx_Inst	:	entity work.UART_Tx		
		generic map(
			g_Parity	=>	"0",
			g_N_Bits	=>	8,
		    g_Baud_Rate	=>	230400,
		    g_Frequency	=>	1e8
		)
		port map(
			i_Clk		=>	Clk_p,	
		    i_Send		=>	Send_Int,	
		    i_Data_In	=>	std_logic_vector(Data_In),	
		    o_Busy		=>	Busy_Int_Tx,	
		    o_Tx		=>	Rx	
		);

	UART_Rx_Inst	:	entity work.UART_Rx
			generic map(
			g_Parity	=>	"0",
			g_N_Bits	=>	8,
			g_Baud_Rate	=>	230400,
			g_Frequency	=>	1e8
		)
		port map(
			i_Clk		=>	Clk_p,
			i_Rx		=>	Rx,
			o_Valid		=>	Valid_Int,
			o_Busy		=> Busy_Int_Rx,
			o_Data_Out	=>	Data_Out
		);

	Clock_Generation	:	process
	
	begin
	
		wait for Clk_Period / 2;
		Clk_p	<=	not Clk_p;
		Clk_n	<=	not Clk_n;
	
	end process;
	
	-- Stimulus
	Send_Int	<=	'1' after 100 ns, '0' after 110 ns, '1' after 1.25 ms;
	Data_In		<=	"10101010", "01010111" after 500 ns;

End Architecture;