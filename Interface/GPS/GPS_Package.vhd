library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------
package GPS_Package is
    function get_ascii(inp  :   std_logic_vector) return character;
    function ascii2bin(inp  :   character) return std_logic_vector;
    function mult_10(inp    :   std_logic_vector) return std_logic_vector;
    function mult_10(inp    :   unsigned) return unsigned;
    function mult_10(inp    :   signed) return signed;
    function mult_60(inp    :   std_logic_vector) return std_logic_vector;   
    function mult_60(inp    :   unsigned) return unsigned;  
    function mult_60(inp    :   signed) return signed;                    
end Package;
---------------------------------------
package body GPS_Package is

    function get_ascii(inp  :   std_logic_vector) return character is
        variable    value   :   integer range 0 to 255  := 0;
    begin
        for i in inp'range loop
            value   :=  value * 2;
            if (inp(i) = '1') then
                value   :=  value + 1;
            end if;
        end loop;
        return character'val(value);
    end get_ascii;

    function ascii2bin(inp  :   character) return std_logic_vector is	
    begin
    	return std_logic_vector(to_unsigned(character'pos(inp), 8));
    end ascii2bin;
    
    function mult_10(inp    :   std_logic_vector) return std_logic_vector is
        variable temp   :   unsigned(inp'range)	:= unsigned(inp);
    begin
        temp    :=  (temp sll 3) + (temp sll 1);
        return std_logic_vector(temp);
    end mult_10;

    function mult_10(inp    :   unsigned) return unsigned is
        variable temp   :   unsigned(inp'range)	:= inp;
    begin
        temp    :=  (temp sll 3) + (temp sll 1);
        return temp;
    end mult_10;

    function mult_10(inp    :   signed) return signed is
        variable temp   :   signed(inp'range)	:= inp;
    begin
        temp    :=  (temp sll 3) + (temp sll 1);
        return temp;
    end mult_10;

    function mult_60(inp    :   std_logic_vector) return std_logic_vector is
        variable temp   :   unsigned(inp'range)	:= unsigned(inp);
    begin
        temp    :=  (temp sll 6) - (temp sll 2);
        return std_logic_vector(temp);
    end mult_60;

    function mult_60(inp    :   unsigned) return unsigned is
        variable temp   :   unsigned(inp'range)	:= inp;
    begin
        temp    :=  (temp sll 6) - (temp sll 2);
        return temp;
    end mult_60;

    function mult_60(inp    :   signed) return signed is
        variable temp   :   signed(inp'range)	:= inp;
    begin
        temp    :=  (temp sll 6) - (temp sll 2);
        return temp;
    end mult_60;

end package body;