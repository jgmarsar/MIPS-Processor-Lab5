library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazardUnit is
	port (
		--instruction indicator signals
		jal_ID : in std_logic;
		wr_ID : in std_logic;
		WBSel_ID : in std_logic;
		regDst_ID : in std_logic;
		jump_ID : in std_logic;
		memWrite_ID : in std_logic;
		jtype_ID : in std_logic;
		branch_ID : in std_logic;
		
		jal_EX : in std_logic;
		wr_EX : in std_logic;
		WBSel_EX : in std_logic;
		regDst_EX : in std_logic;
		jump_EX : in std_logic;
		memWrite_EX : in std_logic;
		jtype_EX : in std_logic;
		branch_EX : in std_logic;
		
		jal_MEM : in std_logic;
		wr_MEM : in std_logic;
		WBSel_MEM : in std_logic;
		regDst_MEM : in std_logic;
		jump_MEM : in std_logic;
		memWrite_MEM : in std_logic;
		jtype_MEM : in std_logic;
		branch_MEM : in std_logic;
		
		jal_WB : in std_logic;
		wr_WB : in std_logic;
		WBSel_WB : in std_logic;
		regDst_WB : in std_logic;
		jump_WB : in std_logic;
		memWrite_WB : in std_logic;
		jtype_WB : in std_logic;
		branch_WB : in std_logic;
		
		--register signals
		rs_IF : in std_logic;
		rt_IF : in std_logic;
		rs_ID : in std_logic;
		rt_ID : in std_logic;
		rd_ID : in std_logic;
		rs_EX : in std_logic;
		rt_EX : in std_logic;
		rd_EX : in std_logic;
		rt_MEM : in std_logic;
		rd_MEM : in std_logic;
		
		--data forwarding control signals
		stall : out std_logic;
		ALU_srcA_sel : out std_logic_vector(1 downto 0);
		ALU_srcB_sel : out std_logic_vector(1 downto 0);
		IDEX_q0_sel : out std_logic_vector(1 downto 0);
		IDEX_q1_sel : out std_logic_vector(1 downto 0)
	);
end hazardUnit;

architecture RTL of hazardUnit is
	constant C_DEFAULT : std_logic_vector(1 downto 0) := "00";
	constant C_ALU : std_logic_vector(1 downto 0) := "01";
	constant C_REGDATA : std_logic_vector(1 downto 0) := "10";
	constant C_PC4 : std_logic_vector(1 downto 0) := "11";
begin
	
end RTL;
