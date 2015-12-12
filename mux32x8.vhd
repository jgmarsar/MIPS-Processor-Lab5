library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32x8 is
	port (
		in0 : in std_logic_vector(31 downto 0);
		in1 : in std_logic_vector(31 downto 0);
		in2 : in std_logic_vector(31 downto 0);
		in3 : in std_logic_vector(31 downto 0);
		in4 : in std_logic_vector(31 downto 0);
		in5 : in std_logic_vector(31 downto 0);
		in6 : in std_logic_vector(31 downto 0);
		in7 : in std_logic_vector(31 downto 0);
		Sel : in std_logic_vector(2 downto 0);
		O : out std_logic_vector(31 downto 0)
	);
end entity mux32x8;

architecture RTL of mux32x8 is
	
begin
	with Sel select O <= 	in0	when "000",				--if Sel == 0, O = in0
							in1	when "001",				--if Sel == 1, O = in1
							in2 when "010",				--if Sel == 2, O = in2
							in3 when "011",				--if Sel == 3, O = in3
							in4 when "100",				--if Sel == 4, O = in4
							in5 when "101",				--if Sel == 5, O = in5
							in6 when "110",				--if Sel == 6, O = in6
							in7 when others;			--else, O = in7
end architecture RTL;
