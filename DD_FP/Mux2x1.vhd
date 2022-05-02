library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity MUX2x1 is
 generic(
    WIDTH         :   positive := 16);
    port (
        input1  : in  std_logic_vector(width-1 downto 0);
		input2  : in  std_logic_vector(width-1 downto 0);
        sel     : in  std_logic;
		output : out std_logic_vector(width-1 downto 0));
end MUX2x1;


architecture Mux of Mux2x1 is

begin 
  process(input1, input2, sel) -- must have sel because inputs will not change on mux2 unless reg2 cganges from zero. reg2 >> product >> mux2 input
    begin
   if (sel = '0') then   
   output <= input1;
   elsif (sel = '1') then
   output <= input2;
	else 
	output <= (others =>'0');
   end if;   
   end process;
end Mux;