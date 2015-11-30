library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instNamePackage.all;

entity IF_ID_reg is
	port (
		clk : in std_logic;
		rst : in std_logic;
		flush : in std_logic;
		
		PC4_IF : in std_logic_vector(31 downto 0);
		instruction_IF : in std_logic_vector(31 downto 0);
		ALUop_IF : in std_logic_vector(2 downto 0);
		wr_IF : in std_logic;
		ALUSrc_IF : in std_logic;
		regDst_IF : in std_logic;
		ext_sel_IF : in std_logic;
		WriteDataSel_IF : in std_logic;
		MemWrite_IF : in std_logic;
		sizeSel_IF : in std_logic_vector(1 downto 0);
		jump_IF : in std_logic;
		jtype_IF : in std_logic;
		jal_IF : in std_logic;
		BEQ_IF : in std_logic;
		BNE_IF : in std_logic;
		instName_IF : in instruction_TYPE;
		load_IF : in std_logic;
		Rtype_IF : in std_logic;
		Itype_IF : in std_logic;
		store_IF : in std_logic;
		jr_IF : in std_logic;
		rs_IF : in std_logic_vector(4 downto 0);
		rt_IF : in std_logic_vector(4 downto 0);
		rd_IF : in std_logic_vector(4 downto 0);
		
		PC4_ID : out std_logic_vector(31 downto 0);
		instruction_ID : out std_logic_vector(31 downto 0);
		ALUop_ID : out std_logic_vector(2 downto 0);
		wr_ID : out std_logic;
		ALUSrc_ID : out std_logic;
		regDst_ID : out std_logic;
		ext_sel_ID : out std_logic;
		WriteDataSel_ID : out std_logic;
		MemWrite_ID : out std_logic;
		sizeSel_ID : out std_logic_vector(1 downto 0);
		jump_ID : out std_logic;
		jtype_ID : out std_logic;
		jal_ID : out std_logic;
		BEQ_ID : out std_logic;
		BNE_ID : out std_logic;
		instName_ID : out instruction_TYPE;
		load_ID : out std_logic;
		Rtype_ID : out std_logic;
		Itype_ID : out std_logic;
		store_ID : out std_logic;
		jr_ID : out std_logic;
		rs_ID : out std_logic_vector(4 downto 0);
		rt_ID : out std_logic_vector(4 downto 0);
		rd_ID : out std_logic_vector(4 downto 0)
	);
end entity IF_ID_reg;

architecture RTL of IF_ID_reg is
	
begin
	process(clk, rst, flush)
	begin
		if (rst = '1') then
			PC4_ID <= (others => '0');
			instruction_ID <= (others => '0');
			ALUop_ID <= (others => '0');
			wr_ID <= '0';
			ALUSrc_ID <= '0';
			regDst_ID <= '0';
			ext_sel_ID <= '0';
			WriteDataSel_ID <= '0';
			MemWrite_ID <= '0';
			sizeSel_ID <= (others => '0');
			jump_ID <= '0';
			jtype_ID <= '0';
			jal_ID <= '0';
			BEQ_ID <= '0';
			BNE_ID <= '0';
			instName_ID  <= NOP;
			load_ID <= '0';
			Rtype_ID <= '0';
			Itype_ID <= '0';
			store_ID  <= '0';
			jr_ID <= '0';
			rs_ID <= (others => '0');
			rt_ID <= (others => '0');
			rd_ID <= (others => '0');
		elsif (rising_edge(clk)) then
			if (flush = '1') then
				PC4_ID <= (others => '0');
				instruction_ID <= (others => '0');
				ALUop_ID <= (others => '0');
				wr_ID <= '0';
				ALUSrc_ID <= '0';
				regDst_ID <= '0';
				ext_sel_ID <= '0';
				WriteDataSel_ID <= '0';
				MemWrite_ID <= '0';
				sizeSel_ID <= (others => '0');
				jump_ID <= '0';
				jtype_ID <= '0';
				jal_ID <= '0';
				BEQ_ID <= '0';
				BNE_ID <= '0';
				instName_ID  <= NOP;
				load_ID <= '0';
				Rtype_ID <= '0';
				Itype_ID <= '0';
				store_ID  <= '0';
				jr_ID <= '0';
				rs_ID <= (others => '0');
				rt_ID <= (others => '0');
				rd_ID <= (others => '0');
			else
				PC4_ID <= PC4_IF;
				instruction_ID <= instruction_IF;
				ALUop_ID <= ALUop_IF;
				wr_ID <= wr_IF;
				ALUSrc_ID <= ALUSrc_IF;
				regDst_ID <= regDst_IF;
				ext_sel_ID <= ext_sel_IF;
				WriteDataSel_ID <= WriteDataSel_IF;
				MemWrite_ID <= MemWrite_IF;
				sizeSel_ID <= sizeSel_IF;
				jump_ID <= jump_IF;
				jtype_ID <= jtype_IF;
				jal_ID <= jal_IF;
				BEQ_ID <= BEQ_IF;
				BNE_ID <= BNE_IF;
				instName_ID  <= instName_IF;
				load_ID <= load_IF;
				Rtype_ID <= Rtype_IF;
				Itype_ID <= Itype_IF;
				store_ID  <= store_IF;
				jr_ID <= jr_IF;
				rs_ID <= rs_IF;
				rt_ID <= rt_IF;
				rd_ID <= rd_IF;
			end if;
		end if;
	end process;
end RTL;
