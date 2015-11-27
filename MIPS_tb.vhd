library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS_tb is
end MIPS_tb;

architecture Test of MIPS_tb is
	signal clk : std_logic := '1';
	signal rst : std_logic := '1';
begin
	
	U_DATA : entity work.datapath
		port map(
			clk  => clk,
			rst  => rst,
            WBdataOut => open
		);
	
	clk <= not clk after 50 ns;
	
	process
	begin
		wait for 50 ns;
		rst <= '0';
		wait;
	end process;
	
end architecture Test;
