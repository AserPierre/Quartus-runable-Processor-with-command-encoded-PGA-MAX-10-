library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is 
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
end top_level;

architecture top of top_level is 

component decoder7seg
	port(
	input : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(6 downto 0)
);

 end component;
signal 		ir31to26 	:  std_logic_vector(5 downto 0);
signal		ir5to0      :  std_logic_vector(5 downto 0);
signal		PCWriteCond :  std_logic;
signal		PCWrite 	:  std_logic; 
signal		IorD  		:  std_logic;
signal		memread 	:  std_logic;
signal		memwrite 	:  std_logic;
signal		memtoreg 	:  std_logic;
signal		irwrite  	:  std_logic;
signal		jumpandlink :  std_logic;
signal		issigned    :  std_logic;
signal		PCsource    :  std_logic_vector(1 downto 0);
signal		aluop 		:  std_logic_vector(5 downto 0);
signal		alusrcB 	:  std_logic_vector(1 downto 0);
signal		alusrcA 	:  std_logic;
signal		regwrite	:  std_logic;
signal		regdst 		:  std_logic;
signal		S_out5to0     :  std_logic_vector(5 downto 0);
signal		inport      :  std_logic_vector(31 downto 0);
signal		in0en       :  std_logic;
signal		in1en       :  std_logic;
signal		PCEn        :  std_logic;
signal      branch_taken:  std_logic;
signal  	outport     :  std_logic_vector(31 downto 0);


begin 
		
	U_controller : entity work.controller 
	port map (
		clk => clk,
		rst => rst,
		ir31to26 => ir31to26,
		ir5to0 => ir5to0,
		PCWriteCond => PCWriteCond,
		PCWrite => PCWrite,
		IorD => IorD,
		memwrite => memwrite,
		memtoreg => memtoreg,
		irwrite => irwrite,
		jumpandlink => jumpandlink,
		issigned => issigned,
		PCsource => PCsource,
		aluop   => aluop,
		alusrcA => alusrcA,
		alusrcB => alusrcB,
		regwrite => regwrite,
		regdst => regdst,
		out5to0 => S_out5to0
			);
	
	
	U_DATAPATH : entity work.datapath 
	port map(
		clk => clk,
		rst => rst,
		PC_en => PCEn,
		IorD  => IorD,
		memread => memread,
		memwrite => memwrite,
		memtoreg => memtoreg,
		irwrite  => irwrite,
		inport0en => in0en,
		inport1en => in1en,
		jumplink => jumpandlink, 
		inport    => inport,
		issigned => issigned,
		pcsource => pcsource,
		aluop => aluop,
		alusrcB => alusrcB,
		alusrcA => alusrcA,
		regwrite => regwrite,
		regdst  => regdst,
		ir5to0 => ir5to0,
		ir5to0in => S_out5to0,
		branch_taken => branch_taken,
		ir31to26 => ir31to26,
		outport  => outport 
			);
			
    U_LED0: decoder7seg 
	port map (
		input => outport(3 downto 0),
		output => led0
	 );
    U_LED1: decoder7seg 
	port map (
	input => outport(7 downto 4),
	output => led1
	);
	U_LED2: decoder7seg 
	port map (
	input => outport(11 downto 8),
	output => led2
	);
	U_LED3: decoder7seg 
	port map (
	input => outport(15 downto 12),
	output => led3
	);
	U_LED4: decoder7seg 
	port map (
	input => outport(19 downto 16),
	output => led4
	);
	U_LED5: decoder7seg 
	port map (
	input => outport(23 downto 20),
	output => led5
	);
	led0_dp <= '1';
    led1_dp <= '1';
    led2_dp <= '1';
    led3_dp <= '1';
    led4_dp <= '1';
    led5_dp <= '1';
	
	in0en <=  button(0);
	in1en <=  button(1);
	inport <= "00000000000000000000000" & switch(8 downto 0);
	PCEn <= PCWrite or (PCWriteCond and branch_taken);
end top;