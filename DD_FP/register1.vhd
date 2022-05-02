library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity register1 is 
 generic(
    WIDTH         :   positive := 32);
	PORT(
    input1  : in  std_logic_vector(width-1 downto 0);
    en  : in  std_logic;
    rst : in  std_logic;
    clk : in  std_logic; -- clock.
    output  : out std_logic_vector(width-1 downto 0) -- output
);
END register1;

ARCHITECTURE store OF register1 IS

BEGIN
    process(clk, rst)
    begin
        if rst = '1' then
            output <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                output <= input1;
            end if;
        end if;
    end process;
END store;