library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity MUX3x1 is
 generic(
    WIDTH         :   positive := 32);
    port (
        input1  : in  std_logic_vector(width-1 downto 0);
		input2  : in  std_logic_vector(width-1 downto 0);
		input3  : in  std_logic_vector(width-1 downto 0);
        sel     : in  std_logic_vector(1 downto 0);
		output : out std_logic_vector(width-1 downto 0));
end MUX3x1;


architecture Mux of Mux3x1 is

begin 
  process(input1, input2, input3, sel) -- must have sel because inputs will not change on mux2 unless reg2 cganges from zero. reg2 >> product >> mux2 input
    begin
   if (sel = "00") then   
   output <= input1;
   elsif (sel = "01") then
   output <= input2;
   elsif(sel <= "10")then
   output <= input3;
	else 
	output <= (others =>'0');
   end if;   
   end process;
end Mux;