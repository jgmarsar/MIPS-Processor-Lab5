library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID_reg is
	port (
		clk : in std_logic;
		rst : in std_logic;
		flush : in std_logic;
		
		PC4_IF : in std_logic_vector(31 downto 0);
		instruction_IF : in std_logic_vector(31 downto 0);
		
		PC4_ID : out std_logic_vector(31 downto 0);
		instruction_ID : out std_logic_vector(31 downto 0)
	);
end entity IF_ID_reg;

architecture RTL of IF_ID_reg is
	
begin
	process(clk, rst, flush)
	begin
		if (rst = '1') then
			PC4_ID <= (others => '0');
			instruction_ID <= (others => '0');
		elsif (rising_edge(clk)) then
			if (flush = '1') then
				PC4_ID <= (others => '0');
				instruction_ID <= (others => '0');
			else
				PC4_ID <= PC4_IF;
				instruction_ID <= instruction_IF;
			end if;
		end if;
	end process;
end RTL;
