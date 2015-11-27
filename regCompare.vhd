library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regCompare is
	port (
		q0 : in std_logic_vector(31 downto 0);
		q1 : in std_logic_vector(31 downto 0);
		
		equal : out std_logic
	);
end entity regCompare;

architecture RTL of regCompare is
	
begin
	process(q0, q1)
	begin
		if (q1 = q0) then
			equal <= '1';
		else
			equal <= '0';
		end if;
	end process;
end RTL;
