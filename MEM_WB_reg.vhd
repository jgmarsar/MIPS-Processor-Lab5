library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instNamePackage.all;

entity MEM_WB_reg is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		--control
		wr_MEM : in std_logic;
		regDst_MEM : in std_logic;
		WriteDataSel_MEM : in std_logic;
		jal_MEM : in std_logic;
		instName_MEM : in instruction_TYPE;
		load_MEM : in std_logic;
		Rtype_MEM : in std_logic;
		Itype_MEM : in std_logic;
		
		wr_WB : out std_logic;
		regDst_WB : out std_logic;
		WriteDataSel_WB : out std_logic;
		jal_WB : out std_logic;
		instName_WB : out instruction_TYPE;
		load_WB : out std_logic;
		Rtype_WB : out std_logic;
		Itype_WB : out std_logic;
		
		--datapath
		readDataAdj_MEM : in std_logic_vector(31 downto 0);
		ALUout_MEM : in std_logic_vector(31 downto 0);
		PC4_MEM : in std_logic_vector(31 downto 0);
		rt_MEM : in std_logic_vector(4 downto 0);
		rd_MEM : in std_logic_vector(4 downto 0);
		
		readDataAdj_WB : out std_logic_vector(31 downto 0);
		ALUout_WB : out std_logic_vector(31 downto 0);
		PC4_WB : out std_logic_vector(31 downto 0);
		rt_WB : out std_logic_vector(4 downto 0);
		rd_WB : out std_logic_vector(4 downto 0)
	);
end entity MEM_WB_reg;

architecture RTL of MEM_WB_reg is
	
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			wr_WB <= '0';
			regDst_WB <= '0';
			WriteDataSel_WB <= '0';
			jal_WB <= '0';
			readDataAdj_WB <= (others => '0');
			ALUout_WB <= (others => '0');
			PC4_WB <= (others => '0');
			rt_WB <= (others => '0');
			rd_WB <= (others => '0');
			instName_WB <= NOP;
			load_WB <= '0';
			Rtype_WB <= '0';
			Itype_WB <= '0';
		elsif (rising_edge(clk)) then
			wr_WB <= wr_MEM;
			regDst_WB <= regDst_MEM;
			WriteDataSel_WB <= WriteDataSel_MEM;
			jal_WB <= jal_MEM;
			readDataAdj_WB <= readDataAdj_MEM;
			ALUout_WB <= ALUout_MEM;
			PC4_WB <= PC4_MEM;
			rt_WB <= rt_MEM;
			rd_WB <= rd_MEM;
			instName_WB <= instName_MEM;
			load_WB <= load_MEM;
			Rtype_WB <= Rtype_MEM;
			Itype_WB <= Itype_MEM;
		end if;
	end process;
end RTL;
