library ieee;
use ieee.std_logic_1164.all;

entity mux32x4 is
	port (
		in0 : in std_logic_vector(31 downto 0);
		in1 : in std_logic_vector(31 downto 0);
		in2 : in std_logic_vector(31 downto 0);
		in3 : in std_logic_vector(31 downto 0);
		Sel : in std_logic_vector(1 downto 0);
		O : out std_logic_vector(31 downto 0)
	);
end mux32x4;

architecture BHV of mux32x4 is
begin
	with Sel select O <= 	in0	when "00",				--if Sel == 0, O = in0
							in1	when "01",				--if Sel == 1, O = in1
							in2 when "10",				--if Sel == 1, O = in1
							in3 when others;			--else, O = in3
end BHV;