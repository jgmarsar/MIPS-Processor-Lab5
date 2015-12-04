library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS_tb is
end MIPS_tb;

architecture Test of MIPS_tb is
	signal clk : std_logic := '1';
	signal rst : std_logic := '1';
	signal WBdataOut : std_logic_vector(31 downto 0);
	signal ALUoutput : std_logic_vector(31 downto 0);
	signal q0Output : std_logic_vector(31 downto 0);
	signal instructionOutput : std_logic_vector(31 downto 0);
	signal PCoutput : std_logic_vector(31 downto 0);
begin
		
	U_DATA : entity work.datapath
		port map(
			clk               => clk,
			rst               => rst,
			WBdataOut         => WBdataOut,
			ALUoutput         => ALUoutput,
			q0Output          => q0Output,
			instructionOutput => instructionOutput,
			PCoutput          => PCoutput
		);
	
	clk <= not clk after 50 ns;
	
	process
	begin
		wait for 50 ns;
		rst <= '0';
		wait;
	end process;
	
end architecture Test;
