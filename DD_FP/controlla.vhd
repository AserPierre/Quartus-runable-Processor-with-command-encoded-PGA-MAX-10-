library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is 
	port (
		clk 		: in std_logic; 
		rst 		: in std_logic; 
		ir31to26 	: in std_logic_vector(5 downto 0);
		ir5to0      : in std_logic_vector(5 downto 0);
		PCWriteCond : out std_logic;
		PCWrite 	: out std_logic; 
		IorD  		: out std_logic;
		memread 	: out std_logic;
		memwrite 	: out std_logic;
		memtoreg 	: out std_logic;
		irwrite  	: out std_logic;
		jumpandlink : out std_logic;
		issigned    : out std_logic;
		PCsource    : out std_logic_vector(1 downto 0);
		aluop 		: out std_logic_vector(5 downto 0);
		alusrcB 	: out std_logic_vector(1 downto 0);
		alusrcA 	: out std_logic;
		regwrite	: out std_logic;
		regdst 		: out std_logic;
		out5to0      : out std_logic_vector(5 downto 0)
		);
end controller;

architecture controlla of controller is 
	type STATE_TYPE is (S_start, S_Instruct, S_Instruct2, S_decode, S_load, S_Save, S_memRead, S_memRead2, S_readcom, S_memWrite, S_address, S_Regtype, S_Regtype2,  S_branch, S_branch2, S_jump, S_jumplink, S_jumplink2, S_skip, S_halt, S_imm, S_imm2);
    signal cur_state, next_state, temp_state : STATE_TYPE;
	
  
begin

  process (clk, rst)
  begin
    if (rst = '1') then
      cur_state <= S_Instruct;
    elsif (clk = '1' and clk'event) then
      cur_state <= next_state;
    end if;
  end process;

  process(cur_state, ir31to26, ir5to0)
  begin
											ALUSrcA <= '0';
											IorD    <= '0';
											irwrite <= '0';
											ALUOp <= "000000";
											PCwritecond <= '0';
											memwrite <= '0';
											memtoreg <= '0';
											jumpandlink <= '0';
											issigned <= '0';
											PCsource <= "00";
											regwrite <= '0';
											regdst <= '0';
											PCwrite <= '0';
											ALUsrcB <= "00";
											out5to0 <= "000000";
											next_state <= S_Instruct;
											
   case(cur_state) is
										 
										
											
									when S_Instruct =>
										    memwrite <= '0';
											PCSource <= "00";
											ALUSrcA <= '0';
											IorD    <= '0';
											ALUSrcB <= "01";
											ALUOp <= "100001";
											PCWrite <= '1';
											next_state <= S_Instruct2;
									
									
									When S_Instruct2 => 
											irwrite <= '1';
											next_state <= S_Decode;

									
									
									when S_decode =>
											
											out5to0 <= ir5to0;	
											ALUOp <= ir31to26;	   
											if (ir31to26 = "000000")then
												next_state <= S_Regtype;
											elsif (ir31to26 = "100011" or ir31to26 = "101011")then
												next_state <= S_address;
											elsif (ir31to26 = "000010")then
												next_state <= S_jump;										
											elsif (ir31to26 = "000011")then 
												next_state <= S_jumplink;
											elsif (ir31to26 = "000100" or ir31to26 = "000101" or ir31to26 = "000110" or ir31to26 = "000111")then
												next_state <= S_branch;
											elsif (ir31to26 = "111111")then
												next_state <= S_halt;									
											else 
												next_state <= S_imm;
											end if;
									
									when S_Regtype =>
											ALUsrcA <= '1';
											out5to0 <= ir5to0;
											ALUOp <= ir31to26;
											ALUsrcB <= "00";
											
											if ir5to0 = "001000" then 
											ALUsrcA <= '1';
											PCSource <= "00";
											PCWrite <= '1';
											next_state <= S_Instruct;
											else 
									        next_state <= S_Regtype2;
											end if;
											
									When S_Regtype2 =>
											memtoreg <= '0';
											regdst <= '1';
											if (ir5to0 /= "011000" and ir5to0 /= "011001") then 
											regwrite <= '1';
											end if ;
											next_state <= S_Instruct;
					
									
									When S_imm => 
										ALUsrcA <= '1';
										ALUsrcB <= "10";
										issigned <= '1';
										ALUOp <= ir31to26;
										out5to0 <= ir5to0;
										if (ir31to26 = "001100" or ir31to26 = "001101" or ir31to26 = "001110") then
											issigned <= '0';
									   end if;
										next_state <= S_imm2;
										
										
									When S_imm2 =>
									
										memtoreg <= '0';
										regwrite <= '1';
										regdst <= '0';
										next_state <= S_Instruct; 
										
									when S_address =>
								        issigned <= '0';
										ALUsrcA <= '1';
										ALUsrcB <= "10";
										ALUOp <= "100001";
										if (ir31to26 = "100011") then 
										 next_state <= S_memRead;
										elsif (ir31to26 = "101011")then 
										 next_state <= S_memWrite;
										end if;
									
									when S_memRead =>
										   IorD <= '1';
										   regdst <= '0';
										   memtoreg <= '1';
										    memwrite <= '0'; 
										   irwrite <= '0';
										   next_state <= S_memRead2;
									
									when S_memRead2 =>
											next_state <= S_readcom;
											
									when S_readcom =>
										    regdst <= '0';
											memtoreg <= '1';
											regwrite <= '1';
											next_state <= S_Instruct;
											
									when S_memWrite =>
										  IorD <='1';
										  memwrite <= '1';
										  next_state <= S_Instruct;
											
											
									when S_branch =>
										  ALUsrcA <= '0';
									      issigned <= '1';
										  ALUsrcB <= "11";
										  ALUOp <= "100001";
										  next_state <= S_branch2;
										
									when S_branch2 =>
										  ALUsrcB <= "00";
										  PCWriteCond <= '1';
										  ALUsrcA <= '1';
										  PCsource <= "01";
										  ALUOp <= ir31to26;
										  next_state <= S_Instruct;
										  
									when S_jump =>
										PCSource <= "10";
										PCWrite <= '1';
										next_state <= S_Instruct;
									
									when S_jumplink =>
									    PCSource <= "10";
									    ALUSrcA <= '0';
									    ALUOp <= "001000";
										PCWrite <= '1';
										
									    
									    next_state <= S_jumplink2;
									
									when S_jumplink2 => 
										memtoreg <= '0';
										jumpandlink <= '1';
										next_state <= S_Instruct;
										
									when S_halt =>
									      next_state <= S_halt;
									when others => null;
							  end case;	
						end process;
end controlla;
	