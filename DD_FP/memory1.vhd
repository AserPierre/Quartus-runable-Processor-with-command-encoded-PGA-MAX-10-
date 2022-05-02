library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory1 is 
port (
	clk      : in std_logic;
	addr     : in std_logic_vector(31 downto 0);
	--write port 
	MemWrite : in std_logic;
	wdata 	 : in std_logic_vector(31 downto 0);
	--I/O port 
	switch   : in  std_logic_vector(31 downto 0);
	button   : in  std_logic;
	input1En : in std_logic;
	input2En : in std_logic;
	outport  : out std_logic_vector(31 downto 0);
	--read port 
	rdata  	 : out std_logic_vector(31 downto 0)
	);
 end entity; 

 
 
 architecture data of memory1 is 
	
	component register1 
    generic(
		WIDTH         :   positive := 32);
	PORT(
    input1  : in  std_logic_vector(width-1 downto 0);
    en  : in  std_logic;
    rst : in  std_logic;
    clk : in  std_logic; -- clock.
    output  : out std_logic_vector(width-1 downto 0) -- output
);
 end component; 
 
 component mux3x1 
  generic(
		WIDTH         :   positive := 32
		);
	port (
	    input1  : in  std_logic_vector(width-1 downto 0);
		input2  : in  std_logic_vector(width-1 downto 0);
		input3  : in  std_logic_vector(width-1 downto 0);
        sel     : in  std_logic_vector(1 downto 0);
		output : out std_logic_vector(width-1 downto 0)
	);
	end component;
signal rst         :  std_logic := '0';
signal RAM_addr    :  std_logic_vector(6 downto 0);
signal wen 		   :  std_logic;
signal output 	   :  std_logic_vector(31 downto 0);
signal outportEn   :  std_logic;
signal export1 	   :  std_logic_vector(31 downto 0);
signal export2	   :  std_logic_vector(31 downto 0);
signal ram_export  :  std_logic_vector(31 downto 0);
signal seldelay    :  std_logic_vector(1 downto 0);
signal sel         :  std_logic_vector(1 downto 0);
     begin
	 
	 --component instantiation 
	 
	U_RAM : entity work.RAMGCD
		port map (
			address => addr(9 downto 2), 
			clock => clk,
			data => wdata,
			wren => wen,
			q => ram_export);
------------------------------------------------------------
	U_inport1: register1
	generic map (
	width => 32 
	)
		port map(
		input1 => switch,
		en => input1En,
		rst => '0',
		clk => clk,
		output => export1
		);
---------------------------------------------------------------
	U_inport2: register1
	generic map (
	width => 32 
	)
		port map(
		input1 => switch,
		en => input2En,
		rst => '0',
		clk => clk,
		output => export2
		);
---------------------------------------------------------------
	U_outport: register1
	generic map (
	width => 32 
	)
		port map(
		input1 => wdata,
		en => outportEn,
		rst => '0',
		clk => clk,
		output => outport
		);
---------------------------------------------------------------
	U_mux3x1: mux3x1
	generic map (
	width => 32 
	)
	port map(
	input1 => export1,
	input2 => export2,
	input3 => ram_export, 
	sel => seldelay,
	output => rdata
	);
----------------------------------------------------------------
	U_DELAY: entity work.delay(STR)
			generic map (
			cycles => 1,
			WIDTH => 2)
		port map (
			clk => clk,
			rst => '0',
			load => '1',
			input => sel,
			output => seldelay
			);
----------------------------------------------------------------
-----------------------------------------------------------------	
		
	set_select: process(MemWrite, addr) 
		begin
		outportEn <= '0';
		wen <= '0';
		sel <= "10";
		if(MemWrite = '1') then 
			if(addr = x"0000FFFC") then 
				outportEn <= '1';
			elsif (unsigned(addr) <= 1023) then 
			wen <= '1';
			end if; 
		else 
			if (addr = x"0000FFFC" ) then
				sel <="01";
			elsif(addr = x"0000FFF8") then
				sel <="00";
			elsif(unsigned(addr) <= 1023) then 
				sel <= "10";
			end if;
		end if;	
		end process; 
end data ;