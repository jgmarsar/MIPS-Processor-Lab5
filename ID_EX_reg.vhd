library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instNamePackage.all;

entity ID_EX_reg is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		--control
		ALUop_ID : in std_logic_vector(2 downto 0);
		wr_ID : in std_logic;
		ALUSrc_ID : in std_logic;
		regDst_ID : in std_logic;
		WriteDataSel_ID : in std_logic;
		MemWrite_ID : in std_logic;
		sizeSel_ID : in std_logic_vector(1 downto 0);
		jal_ID : in std_logic;
		jump_ID : in std_logic;
		branch_ID : in std_logic;
		instName_ID : in instruction_TYPE;
		
		ALUop_EX : out std_logic_vector(2 downto 0);
		wr_EX : out std_logic;
		ALUSrc_EX : out std_logic;
		regDst_EX : out std_logic;
		WriteDataSel_EX : out std_logic;
		MemWrite_EX : out std_logic;
		sizeSel_EX : out std_logic_vector(1 downto 0);
		jal_EX : out std_logic;
		jump_EX : out std_logic;
		branch_EX : out std_logic;
		instName_EX : out instruction_TYPE;
		
		--datapath
		q0_ID : in std_logic_vector(31 downto 0);
		q1_ID : in std_logic_vector(31 downto 0);
		ext_imm_ID : in std_logic_vector(31 downto 0);
		func_ID : in std_logic_vector(5 downto 0);
		shamt_ID : in std_logic_vector(4 downto 0);
		rs_ID : in std_logic_vector(4 downto 0);
		rt_ID : in std_logic_vector(4 downto 0);
		rd_ID : in std_logic_vector(4 downto 0);
		PC4_ID : in std_logic_vector(31 downto 0);
		
		q0_EX : out std_logic_vector(31 downto 0);
		q1_EX : out std_logic_vector(31 downto 0);
		ext_imm_EX : out std_logic_vector(31 downto 0);
		func_EX : out std_logic_vector(5 downto 0);
		shamt_EX : out std_logic_vector(4 downto 0);
		rs_EX : out std_logic_vector(4 downto 0);
		rt_EX : out std_logic_vector(4 downto 0);
		rd_EX : out std_logic_vector(4 downto 0);
		PC4_EX : out std_logic_vector(31 downto 0)
	);
end entity ID_EX_reg;

architecture RTL of ID_EX_reg is
	
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			ALUop_EX <= "000";
			wr_EX <= '0';
			ALUSrc_EX <= '0';
			regDst_EX <= '0';
			WriteDataSel_EX <= '0';
			MemWrite_EX <= '0';
			sizeSel_EX <= "00";
			jal_EX <= '0';
			jump_EX <= '0';
			branch_EX <= '0';
			q0_EX <= (others => '0');
			q1_EX <= (others => '0');
			ext_imm_EX <= (others => '0');
			func_EX <= (others => '0');
			shamt_EX <= (others => '0');
			rs_EX <= (others => '0');
			rt_EX <= (others => '0');
			rd_EX <= (others => '0');
			PC4_EX <= (others => '0');
			instName_EX <= NOP;
		elsif (rising_edge(clk)) then
			ALUop_EX <= ALUop_ID;
			wr_EX <= wr_ID;
			ALUSrc_EX <= ALUSrc_ID;
			regDst_EX <= regDst_ID;
			WriteDataSel_EX <= WriteDataSel_ID;
			MemWrite_EX <= MemWrite_ID;
			sizeSel_EX <= sizeSel_ID;
			jal_EX <= jal_ID;
			jump_EX <= jump_ID;
			branch_EX <= branch_ID;
			q0_EX <= q0_ID;
			q1_EX <= q1_ID;
			ext_imm_EX <= ext_imm_ID;
			func_EX <= func_ID;
			shamt_EX <= shamt_ID;
			rs_EX <= rs_ID;
			rt_EX <= rt_ID;
			rd_EX <= rd_ID;
			PC4_EX <= PC4_ID;
			instName_EX <= instName_ID;
		end if;
	end process;
end RTL;
