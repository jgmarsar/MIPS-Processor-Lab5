library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instNamePackage.all;

entity EX_MEM_reg is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		--control
		wr_EX : in std_logic;
		regDst_EX : in std_logic;
		WriteDataSel_EX : in std_logic;
		jal_EX : in std_logic;
		instName_EX : in instruction_TYPE;
		
		wr_MEM : out std_logic;
		regDst_MEM : out std_logic;
		WriteDataSel_MEM : out std_logic;
		jal_MEM : out std_logic;
		instName_MEM : out instruction_TYPE;
		
		--datapath
		ALUout_EX : in std_logic_vector(31 downto 0);
		byteEnable_EX : in std_logic_vector(3 downto 0);
		PC4_EX : in std_logic_vector(31 downto 0);
		rt_EX : in std_logic_vector(4 downto 0);
		rd_EX : in std_logic_vector(4 downto 0);
		
		ALUout_MEM : out std_logic_vector(31 downto 0);
		byteEnable_MEM : out std_logic_vector(3 downto 0);
		PC4_MEM : out std_logic_vector(31 downto 0);
		rt_MEM : out std_logic_vector(4 downto 0);
		rd_MEM : out std_logic_vector(4 downto 0)
	);
end entity EX_MEM_reg;

architecture RTL of EX_MEM_reg is
	
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			wr_MEM <= '0';
			regDst_MEM <= '0';
			WriteDataSel_MEM <= '0';
			jal_MEM <= '0';
			ALUout_MEM <= (others => '0');
			byteEnable_MEM <= (others => '0');
			PC4_MEM <= (others => '0');
			rt_MEM <= (others => '0');
			rd_MEM <= (others => '0');
			instName_MEM <= NOP;
		elsif (rising_edge(clk)) then
			wr_MEM <= wr_EX;
			regDst_MEM <= regDst_EX;
			WriteDataSel_MEM <= WriteDataSel_EX;
			jal_MEM <= jal_EX;
			ALUout_MEM <= ALUout_EX;
			byteEnable_MEM <= byteEnable_EX;
			PC4_MEM <= PC4_EX;
			rt_MEM <= rt_EX;
			rd_MEM <= rd_EX;
			instName_MEM <= instName_EX;
		end if;
	end process;
end RTL;
