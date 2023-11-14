
## Diagram
![Diagram](doc/LCD_Top.svg "Diagram")
## Ports

| Port name | Direction | Type                         | Description |
| --------- | --------- | ---------------------------- | ----------- |
| i_Clk_P   | in        | std_logic                    | clock input|
| i_Clk_N   | in        | std_logic                    |clock input|
| i_Shift   | in        | std_logic                    |shifts LCD content|
| i_Update  | in        | std_logic                    |updates LCD content|
| i_Init    | in        | std_logic                    |Initializes LCD|
| o_RS      | out       | std_logic                    |             |
| o_RW      | out       | std_logic                    |             |
| o_E       | out       | std_logic                    |             |
| io_DB     | inout     | std_logic_vector(7 downto 0) |             |

## Signals

| Name           | Type                         | Description |
| -------------- | ---------------------------- | ----------- |
| r_Lines        | t_Array                      |             |
| r_Pointer      | std_logic_vector(0 downto 0) |             |
| w_Clk_100      | std_logic                    |             |
| w_Command_Data | std_logic_vector(9 downto 0) |             |
| w_Shift        | std_logic                    |             |
| w_Update       | std_logic                    |             |
| w_Init         | std_logic                    |             |
| w_DDRAM_Addr   | std_logic_vector(5 downto 0) |             |
| w_Data         | std_logic_vector(7 downto 0) |             |
| w_ored_Addr    | std_logic                    |             |
| r_ored_Addr    | std_logic                    |             |

## Types

| Name    | Type | Description |
| ------- | ---- | ----------- |
| t_Array |      |             |

## Functions
- char2bin <font id="function_arguments">(inp  :   character)</font> <font id="function_return">return std_logic_vector</font>

## Processes
- unnamed: ( w_Clk_100 )

## Instantiations

- MMCM_100MHz: clk_wiz_0
- Debouncer_1: work.debounce
- Debouncer_2: work.debounce
- Debouncer_3: work.debounce
- LCD_Controller_Inst: work.LCD_Controller
