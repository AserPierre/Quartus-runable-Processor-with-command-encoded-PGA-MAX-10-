library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity Mips_tb is
end Mips_tb;

architecture TB of Mips_tb is

    component top_level

        port (
		clk : in std_logic;
		rst : in std_logic;
		switch : in std_logic_vector(9 downto 0);
		button : in std_logic_vector(1 downto 0);
		led0     : out std_logic_vector(6 downto 0);
		led0_dp  : out std_logic;
		led1     : out std_logic_vector(6 downto 0);
		led1_dp  : out std_logic;
		led2     : out std_logic_vector(6 downto 0);
		led2_dp  : out std_logic;
		led3     : out std_logic_vector(6 downto 0);
		led3_dp  : out std_logic;
		led4     : out std_logic_vector(6 downto 0);
		led4_dp  : out std_logic;
		led5     : out std_logic_vector(6 downto 0);
		led5_dp  : out std_logic
----------------------------------------------------------------	
		);

    end component;
	signal clk 		: std_logic := '0';
	signal rst 		: std_logic;
    signal switch   : std_logic_vector(9 downto 0);
    signal button   : std_logic_vector(1 downto 0);
	signal led0    	: std_logic_vector(6 downto 0) := (others => '0');
    signal led0_dp  : std_logic :=  '0';
    signal led1    	: std_logic_vector(6 downto 0) := (others => '0');
    signal led1_dp  : std_logic :=  '0';
    signal led2    	: std_logic_vector(6 downto 0) := (others => '0');
    signal led2_dp  : std_logic :=  '0';
    signal led3    	: std_logic_vector(6 downto 0) := (others => '0');
    signal led3_dp  : std_logic :=  '0';
    signal led4    	: std_logic_vector(6 downto 0) := (others => '0');
    signal led4_dp  : std_logic :=  '0';
	signal led5    	: std_logic_vector(6 downto 0) := (others => '0');
    signal led5_dp  : std_logic :=  '0';
    signal counter  : std_logic_vector(9 downto 0) := (others => '0');
    
	

begin  -- TB
		clk <= not clk after 10 ns;
		
    UUT : top_level
        port map (
            clk   	=> clk,
            rst   	=> rst,
            switch 	=> switch,
			button 	=> button,
			led0   	=> led0,
            led0_dp => led0_dp,
            led1   	=> led1,
            led1_dp => led1_dp,
			led2   	=> led2,
            led2_dp => led2_dp,
			led3   	=> led3,
            led3_dp => led3_dp,
			led4   	=> led4,
            led4_dp => led4_dp,
			led5   	=> led5,
            led5_dp => led5_dp
			);

    process
    begin
     	rst <= '1';
	button <= (others => '0');
	switch <= (others => '0');
	wait for 200 ns;
	rst <= '0';
	switch <= "0000001000";
	button <= "01";
	wait for 200 ns;
	switch <= "0000000010";
	button <= "10";
	wait for 10000000 ns;
    end process;



end TB;
