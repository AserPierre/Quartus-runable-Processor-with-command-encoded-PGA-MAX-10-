library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_control is 
port(
			clk   : in std_logic;
			rst   : in std_logic;
			IR    : in std_logic_vector(5 downto 0);
			ALUOP : in std_logic_vector(5 downto 0);
			Hi_en : out std_logic;
			Lo_en : out std_logic;
			ALU_LO_HI : out std_logic_vector(1 downto 0);
			OPSelect  : out std_logic_vector(5 downto 0)
			);
end ALU_control; 

architecture control of ALU_control is
signal ALH : std_logic_vector(1 downto 0);

begin

	UUT : entity work.delay(STR) 
	generic map (
	cycles => 1,
	width => 2)
	port map 
	(
	clk => clk,
	rst => rst,
	load => '1',
	input => ALH,
	output => ALU_LO_HI
	);

	process(clk, ALUOP, IR)
	begin 
		ALH <= "00";
		OPSelect <= ALUOP;
		Hi_en <= '0';
		LO_en <= '0';
		if ("000000" = ALUOP) then
		OPSelect <= IR;
		if (IR = "011000" or IR = "011001") then
		Hi_en <= '1';
		Lo_en <= '1';
		elsif (IR = "010000") then 
		ALH <= "10";
		elsif (IR = "010010") then
		ALH <= "01";
		end if;
		end if; 
	end process;
end control;