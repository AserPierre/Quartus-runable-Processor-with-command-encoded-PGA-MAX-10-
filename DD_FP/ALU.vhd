--Aser Pierre lab 2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ALU is 
generic(
WIDTH : positive := 32
);
port(
	input1 : in std_logic_vector(WIDTH-1 downto 0);
	input2 : in std_logic_vector(WIDTH-1 downto 0);
	IR     : in std_logic_vector(4 downto 0);
	OPsel  : in std_logic_vector(5 downto 0);
	outLO  : out std_logic_vector(WIDTH-1 downto 0);
	outHI  : out std_logic_vector(WIDTH-1 downto 0);
	ALU_ON : out std_logic;
	BT     : out std_logic
);
end ALU;

architecture add of ALU is

signal branch    : std_logic;
signal ALU_OUT_S : std_logic;
begin
process(OPsel, input1, input2)
variable sum       : unsigned(WIDTH downto 0);
variable difference: unsigned(WIDTH-1 downto 0);
variable product   :  signed((WIDTH*2)-1 downto 0);
variable productu  : unsigned((WIDTH*2)-1 downto 0);
variable temp      : unsigned(WIDTH-1 downto 0);

 begin
     	outLO <= std_logic_vector(to_unsigned(1, width)); 
		outHI <= std_logic_vector(to_unsigned(1, width)); 
		BT <= '0';
		
		case OPsel is 
		when "100001" => 
		sum := resize(unsigned(input1),WIDTH+1) + resize(unsigned(input2), WIDTH+1);
		outLO <= std_logic_vector(sum(WIDTH-1 downto 0));
		ALU_ON <= '0';
		
		when "001001" => 
		sum := resize(unsigned(input1),WIDTH+1) + resize(unsigned(input2), WIDTH+1);
		outLO <= std_logic_vector(sum(WIDTH-1 downto 0));
		ALU_ON <= '0';
		
		when "100011" => 
		difference := unsigned(input1) - unsigned(input2);
		outLO <= std_logic_vector(difference);
		ALU_ON <= '0';
		
	    when "010000" => 
		difference := unsigned(input1) - unsigned(input2);
		outLO <= std_logic_vector(difference);
		ALU_ON <= '0';
		
		when "011000" => 
		product := (signed(input1)*signed(input2));
		outHI   <= std_logic_vector(product(WIDTH*2-1 downto WIDTH));
		outLO	<= std_logic_vector(product(WIDTH-1 downto 0));
		ALU_ON <= '0';
		
		when "011001" => 
		productu := (unsigned(input1)*unsigned(input2));
		outHI   <= std_logic_vector(productu(WIDTH*2-1 downto WIDTH));
		outLO	<= std_logic_vector(productu(WIDTH-1 downto 0));
		ALU_ON <= '0';
		
		when "100100" => 
		outLO <=  input1 and input2;
		ALU_ON <= '0';
		
		when "001100" => 
		outLO <=  input1 and input2;
		ALU_ON <= '0';

	    when "100101" => 
		outLO <=  input1 or input2;
		ALU_ON <= '0';

		
		when "001101" => 
		outLO <=  input1 or input2;
		ALU_ON <= '0';

		
		when "100110" => 
		outLO <=  input1 xor input2;
		ALU_ON <= '0';

		
		when "001110" => 
		outLO <=  input1 xor input2;
		ALU_ON <= '0';

		
		when "000010" => 
		temp :=  unsigned(input2) srl to_integer(unsigned(IR));
		outLO <= std_logic_vector(temp);
		ALU_ON <= '0';

		
		when "000000" => 
		temp :=  unsigned(input2) sll to_integer(unsigned(IR));
		outLO <= std_logic_vector(temp);
		ALU_ON <= '0';

		
		when "000011" => 
		outLO <= std_logic_vector(shift_right(signed(input2), to_integer(unsigned(IR))));

		ALU_ON <= '0';
		
		
		when "101010" => 
		if (signed(input1) < signed(input2)) then 
		ALU_ON <= '1';
		outLO  <= std_logic_vector(to_unsigned(1, width)); 
		else
		ALU_ON <= '0';
		outLO <= (others => '0');
		end if; 
		
		
		when "001010" => 
		if (signed(input1) < signed(input2)) then 
		ALU_ON <= '1';
		outLO  <= std_logic_vector(to_unsigned(1, width)); 
		else
		ALU_ON <= '0';
		outLO <= (others => '0');
		end if; 

		
		when "101011" => 
		if (unsigned(input1) < unsigned(input2)) then 
		ALU_ON <= '1';
		outLO  <= std_logic_vector(to_unsigned(1, width)); 
		else
		ALU_ON <= '0';
		outLO <= (others => '0');
		end if; 

		
		when "001011" => 
		if (unsigned(input1) < unsigned(input2)) then 
		ALU_ON <= '1';
		outLO  <= std_logic_vector(to_unsigned(1, width)); 
		else
		ALU_ON <= '0';
		outLO <= (others => '0');
		end if; 

		
		
		when "000100" =>
		if (signed(input1) = signed(input2)) then
		BT <= '1';
		else
		BT <= '0';
		end if; 
		
		when "000101" =>
		if (signed(input1) /= signed(input2)) then
		BT <= '1';
		else
		BT <= '0';
		end if; 
		
		
		when "000110" =>
		if (signed(input1) <= to_signed(0, width)) then
		BT <= '1';
		else
		BT <= '0';
		end if; 
		
		when "000111" =>
		if (signed(input1) > to_signed(0, width)) then
		BT <= '1';
		else
		BT <= '0';
		end if; 

		when "001000" => 
		outLO <= input1;
		ALU_ON <= '0';
		
		when "110000" =>
		
		when "010010" =>
		
		when "111111" =>
		
		when others => 
		null; 
		end case;
		 
end process;
     
end add;