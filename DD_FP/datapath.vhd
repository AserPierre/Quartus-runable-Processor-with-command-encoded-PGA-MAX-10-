library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is 
port(

clk : in std_logic; 
rst : in std_logic; 

PC_en : in std_logic;
IorD  : in std_logic;
memread : in std_logic;
memwrite : in std_logic;
memtoreg : in std_logic;
irwrite  : in std_logic;
inport0en :in std_logic;
inport1en :in std_logic;
jumplink  :in std_logic;  
inport : in std_logic_vector(31 downto 0);

issigned: in std_logic;
pcsource : in std_logic_vector(1 downto 0);
aluop : in std_logic_vector(5 downto 0);
alusrcB : in std_logic_vector(1 downto 0);
alusrcA : in std_logic;
ir5to0in  : in std_logic_vector(5 downto 0);
regwrite: in std_logic;
regdst : in std_logic;
ir5to0  : out std_logic_vector(5 downto 0);
branch_taken : out std_logic;
ir31to26 : out std_logic_vector(5 downto 0);
outport  : out std_logic_vector(31 downto 0)

);
end datapath; 

architecture struct of datapath is 

	signal PC_in : std_logic_vector(31 downto 0);
	signal PC_out : std_logic_vector(31 downto 0);
	signal memory_in :std_logic_vector(31 downto 0);
	signal memory_out:std_logic_vector(31 downto 0);
	signal ir25to0 : std_logic_vector(25 downto 0);
	signal ir25to21 : std_logic_vector(4 downto 0);
	signal ir20to16 : std_logic_vector(4 downto 0);
	signal ir15to11 : std_logic_vector(4 downto 0);
	signal ir10to6 : std_logic_vector(4 downto 0);
	signal ir15to0 : std_logic_vector(15 downto 0);
	signal memory_regin : std_logic_vector(31 downto 0);
	signal memory_regout: std_logic_vector(31 downto 0);
	signal to_write_reg : std_logic_vector(4 downto 0);
	signal write_data : std_logic_vector(31 downto 0);
	signal read_data1 : std_logic_vector(31 downto 0);
	signal read_data2 : std_logic_vector(31 downto 0);
	signal rega, regb : std_logic_vector(31 downto 0);
	signal aluin1, aluin2 : std_logic_vector(31 downto 0);
	signal aluout: std_logic_vector(31 downto 0);
	signal alumuxout : std_logic_vector(31 downto 0);
	signal opselect : std_logic_vector(5 downto 0);
	signal result : std_logic_vector(31 downto 0);
	signal result_hi : std_logic_vector(31 downto 0);
	signal hi_en : std_logic;
	signal lo_en : std_logic;
	signal alu_lo_hi : std_logic_vector(1 downto 0);
    signal hi_out : std_logic_vector(31 downto 0);
	signal lo_out : std_logic_vector(31 downto 0);
	signal sign_ex : std_logic_vector(31 downto 0);
	signal shift_left_out : std_logic_vector(31 downto 0);
	signal pc_mux_in : std_logic_vector(31 downto 0);
	signal ALU_ON : std_logic;
	
	begin 
		process (ir15to0, issigned)
			begin	
				if (ir15to0(15)='1' and issigned ='1') then
					sign_ex <= x"FFFF" & ir15to0;
					else 
					sign_ex <= x"0000" & ir15to0;
				end if;
		end process; 
	
	U_PC : entity work.register1
		generic map (
		width => 32 
		)
		port map (
		input1 => PC_in,
		en =>  PC_en,
		rst => rst, 
		clk => clk,
		output => PC_out 
		);
	
	U_PCMUX2x1 : entity work.mux2x1 
	generic map (
	width => 32
	)
	port map (
	input1 => PC_out, 
	input2 => aluout,
	sel => IorD,
	output => memory_in
	);
	
	U_MEM : entity work.memory1 
	port map (
	clk 	 => clk,
    addr 	 => memory_in,
	MemWrite => memwrite,
	wdata  	 => regb,
	rdata 	 => memory_out,
	switch   => inport,
	button 	 => rst,
	input1En => inport0en,
	input2En => inport1en,
	outport  => outport
	);
	
	U_MemoryDR : entity work.register1
	generic map (
	width => 32 
	)
	port map (
		input1 => memory_out,
		en =>  '1',
		rst => rst, 
		clk => clk,
		output => memory_regout 
	);
	
	U_Instruct_reg : entity work.instruct_Reg
	port map (
	clk => clk,
	rst => rst,
	en => irwrite,
	input => memory_out,
	output1  => ir25to0,
	output2  => ir31to26,
	output3  => ir25to21,
	output4  => ir20to16,
	output5  => ir15to11,
	output6  => ir10to6,
	output7  => ir5to0,
	output8  => ir15to0
	);
	
	U_writeregMUX : entity work.mux2x1
	generic map (
	width => 5
	)
	port map (
	input1 => ir20to16,
	input2 => ir15to11,
    sel => regdst,
	output => to_write_reg
	);
	
	U_Write_data_mux : entity work.mux2x1
	generic map (
	width => 32
	)
	port map (
	input1 => alumuxout,
	input2 => memory_regout,
	sel => memtoreg,
	output => write_data
	);
	
	U_REGA : entity work.register1
	generic map (
	width => 32
	)
	port map (
		input1 => read_data1,
		en =>  '1',
		rst => rst, 
		clk => clk,
		output => rega 
	);
	
	U_REGB : entity work.register1
	generic map (
	width => 32
	)
	port map (
		input1 => read_data2,
		en =>  '1',
		rst => rst, 
		clk => clk,
		output => regb
	);
	
	U_register_file :  entity work.reg_file(sync_read_during_write)
	port map (
	clk => clk,
	rst => rst,
	rd_addr0 => ir25to21,
	rd_addr1 => ir20to16,
	wr_addr => to_write_reg,
	jumplink => jumplink,
	wr_en => regwrite,
	wr_data => write_data,
	rd_data0 => read_data1,
	rd_data1 => read_data2
	);
	
	U_ALU_OUT : entity work.register1
	generic map (
	width => 32
	)
	port map (
	input1 => result,
	en => '1',
	rst => '0',
	clk => clk, 
	output => aluout
	);
	
	U_ALU1Mux : entity work.mux2x1
	generic map (
	width => 32
	)
	port map (
	input1 => PC_out,
	input2 => rega,
	sel => ALUSrcA,
	output => aluin1
	);
	
	U_ALU4x1Mux : entity work.mux4x1
	generic map (
	width => 32
	)
	port map (
	input1 => regb,
	input2 => std_logic_vector(to_unsigned(4,32)),
	input3 => sign_ex,
	input4 => shift_left_out,
	sel => ALUSrcB,
	output => aluin2
	);
	
	U_ALU: entity work.ALU
	port map(
	input1 => aluin1, 
	input2 => aluin2,
	IR => ir10to6,
	OPsel => opselect,
	outLO => result,
	outHI => result_hi,
	BT => branch_taken
	);
	
	U_LO_REG : entity work.register1
	generic map (
	width => 32
	)
	port map (
		input1 => result,
		en =>  lo_en,
		rst => rst, 
		clk => clk,
		output => lo_out
	);
	
	U_HI_REG : entity work.register1
	generic map (
	width => 32
	)
	port map (
		input1 => result_hi,
		en =>  hi_en,
		rst => rst, 
		clk => clk,
		output => hi_out
	);
	
	U_PCMUX2 : entity work.mux3x1
	generic map (
	width => 32
	)
	port map (
	input1 => result,
	input2 => aluout,
	input3 => pc_mux_in,
	sel => pcsource,
	output => PC_in
	);
	
	U_ALUOUT_MUX : entity work.mux3x1
	generic map (
	width => 32
	)
	port map (
	input1 => aluout,
	input2 => lo_out,
	input3 => hi_out,
	sel => alu_lo_hi,
	output => alumuxout
	);
	
	U_ALU_control : entity work.ALU_control
	port map (
	clk => clk,
	rst => rst,
	ir  => ir5to0in,
	ALUOP => aluop,
	Hi_en => hi_en,
	Lo_en => lo_en,
	ALU_LO_HI => alu_lo_hi,
	OPSelect => opselect
	);

	shift_left_out <= std_logic_vector(shift_left(unsigned(sign_ex),2));
	PC_mux_in <= PC_out(31 downto 28) & "00" & std_logic_vector(shift_left(unsigned(ir25to0),2));
end struct;
	