library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazardUnit is
	port (
		--instruction indicator signals
		load_IF : in std_logic;
		Rtype_IF : in std_logic;
		Itype_IF : in std_logic;
		store_IF : in std_logic;
		jr_IF : in std_logic;
		jal_IF : in std_logic;
		jump_IF : in std_logic;
		branch_IF : in std_logic;
		
		load_ID : in std_logic;
		Rtype_ID : in std_logic;
		Itype_ID : in std_logic;
		store_ID : in std_logic;
		jr_ID : in std_logic;
		jal_ID : in std_logic;
		branch_ID : in std_logic;
		
		load_EX : in std_logic;
		Rtype_EX : in std_logic;
		Itype_EX : in std_logic;
		store_EX : in std_logic;
		jal_EX : in std_logic;
		
		load_MEM : in std_logic;
		Rtype_MEM : in std_logic;
		Itype_MEM : in std_logic;
		jal_MEM : in std_logic;
		
		load_WB : in std_logic;
		Rtype_WB : in std_logic;
		Itype_WB : in std_logic;
		jal_WB : in std_logic;
		
		--register signals
		rs_IF : in std_logic_vector(4 downto 0);
		rt_IF : in std_logic_vector(4 downto 0);
		rs_ID : in std_logic_vector(4 downto 0);
		rt_ID : in std_logic_vector(4 downto 0);
		rd_ID : in std_logic_vector(4 downto 0);
		rs_EX : in std_logic_vector(4 downto 0);
		rt_EX : in std_logic_vector(4 downto 0);
		rd_EX : in std_logic_vector(4 downto 0);
		rt_MEM : in std_logic_vector(4 downto 0);
		rd_MEM : in std_logic_vector(4 downto 0);
		rt_WB : in std_logic_vector(4 downto 0);
		rd_WB : in std_logic_vector(4 downto 0);
		
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
	constant C_PC4_MEM : std_logic_vector(1 downto 0) := "11";
begin
	process(all)
	begin
		ALU_srcA_sel <= C_DEFAULT;
		ALU_srcB_sel <= C_DEFAULT;
		IDEX_q0_sel <= C_DEFAULT;
		IDEX_q1_sel <= C_DEFAULT;
		stall <= '0';
---------------------------------------------------Write Back-----------------------------------------------------------------------------------------
		
		--Rtype in write-back stage and followed by data hazards
		if (Rtype_WB='1') then
			--followed by Rtype, Itype, load, or store 2 instructions later with rd=rs
			if ((Rtype_EX='1' or store_EX='1' or Itype_EX='1' or load_EX='1') and (rd_WB = rs_EX)) then
				ALU_srcA_sel <= C_REGDATA;			--(3)forward WB data to source A of the ALU
			end if;
			--followed by Rtype or store 2 instructions behind with rd=rt
			if ((Rtype_EX='1' or store_EX='1') and (rd_WB = rt_EX)) then
				ALU_srcB_sel <= C_REGDATA;			--(4)forward WB data to source B of the ALU
			end if;
			--followed by Rtype, Itype, load, store, jr or branch 3 instructions behind with rd=rs
			if ((Rtype_ID='1' or store_ID='1' or Itype_ID='1' or load_ID='1' or jr_ID='1' or branch_ID='1') and (rd_WB = rs_ID)) then
				IDEX_q0_sel <= C_REGDATA;			--(5)forward WB data to q0 of decode stage
			end if;
			--followed by Rtybe, store, or branch 3 instructions behind with rd=rt
			if ((branch_ID='1' or Rtype_ID='1' or store_ID='1') and (rd_WB = rt_ID)) then
				IDEX_q1_sel <= C_REGDATA;			--(6)forward WB data to q1 of decode stage
			end if;
		end if;
		
		--Itype in write-back stage and followed by data hazards
		if (Itype_WB='1') then
			--followed by Rtype, Itype, load, or store 2 instructions later with rd=rs
			if ((Rtype_EX='1' or store_EX='1' or Itype_EX='1' or load_EX='1') and (rt_WB = rs_EX)) then
				ALU_srcA_sel <= C_REGDATA;			--(3)forward WB data to source A of the ALU
			end if;
			--followed by Rtype or store 2 instructions behind with rd=rt
			if ((Rtype_EX='1' or store_EX='1') and (rt_WB = rt_EX)) then
				ALU_srcB_sel <= C_REGDATA;			--(4)forward WB data to source B of the ALU
			end if;
			--followed by Rtype, Itype, load, store, jr or branch 3 instructions behind with rd=rs
			if ((Rtype_ID='1' or store_ID='1' or Itype_ID='1' or load_ID='1' or jr_ID='1' or branch_ID='1') and (rt_WB = rs_ID)) then
				IDEX_q0_sel <= C_REGDATA;			--(5)forward WB data to q0 of decode stage
			end if;
			--followed by Rtybe, store, or branch 3 instructions behind with rd=rt
			if ((branch_ID='1' or Rtype_ID='1' or store_ID='1') and (rt_WB = rt_ID)) then
				IDEX_q1_sel <= C_REGDATA;			--(6)forward WB data to q1 of decode stage
			end if;
		end if;
		
		--Load in write-back stage and followed by data hazards
		if (load_WB='1') then
			--followed by Rtype, Itype, load, or store 2 instructions later with rd=rs
			if ((Rtype_EX='1' or store_EX='1' or Itype_EX='1' or load_EX='1') and (rt_WB = rs_EX)) then
				ALU_srcA_sel <= C_REGDATA;			--(3)forward WB data to source A of the ALU
			end if;
			--followed by Rtype or store 2 instructions behind with rd=rt
			if ((Rtype_EX='1' or store_EX='1') and (rt_WB = rt_EX)) then
				ALU_srcB_sel <= C_REGDATA;			--(4)forward WB data to source B of the ALU
			end if;
			--followed by Rtype, Itype, load, store, jr or branch 3 instructions behind with rd=rs
			if ((Rtype_ID='1' or store_ID='1' or Itype_ID='1' or load_ID='1' or jr_ID='1' or branch_ID='1') and (rt_WB = rs_ID)) then
				IDEX_q0_sel <= C_REGDATA;			--(5)forward WB data to q0 of decode stage
			end if;
			--followed by Rtybe, store, or branch 3 instructions behind with rd=rt
			if ((branch_ID='1' or Rtype_ID='1' or store_ID='1') and (rt_WB = rt_ID)) then
				IDEX_q1_sel <= C_REGDATA;			--(6)forward WB data to q1 of decode stage
			end if;
		end if;
		
		--jal in write-back stage and followed by data hazards
		if (jal_WB='1') then
			--followed by Rtype, Itype, load, or store 2 instructions later with 31=rs
			if ((Rtype_EX='1' or store_EX='1' or Itype_EX='1' or load_EX='1') and ("11111" = rs_EX)) then
				ALU_srcA_sel <= C_REGDATA;			--(23)forward WB data (PC+4) to source A of the ALU
			end if;
			--followed by Rtype or store 2 instructions behind with 31=rt
			if ((Rtype_EX='1' or store_EX='1') and ("11111" = rt_EX)) then
				ALU_srcB_sel <= C_REGDATA;			--(24)forward WB data (PC+4) to source B of the ALU
			end if;
			--followed by Rtype, Itype, load, store, jr or branch 3 instructions behind with 31=rs
			if ((Rtype_ID='1' or store_ID='1' or Itype_ID='1' or load_ID='1' or jr_ID='1' or branch_ID='1') and ("11111" = rs_ID)) then
				IDEX_q0_sel <= C_REGDATA;			--(25)forward WB data (PC+4) to q0 of decode stage
			end if;
			--followed by Rtybe, store, or branch 3 instructions behind with 31=rt
			if ((branch_ID='1' or Rtype_ID='1' or store_ID='1') and ("11111" = rt_ID)) then
				IDEX_q1_sel <= C_REGDATA;			--(26)forward WB data (PC+4) to q1 of decode stage
			end if;
		end if;
		
---------------------------------------------------Memory-----------------------------------------------------------------------------------------
		

		--Rtype in memory stage and followed by data hazards
		if (Rtype_MEM='1') then
			--followed by Rtype, Itype, load, or store with rd=rs
			if ((Rtype_EX='1' or store_EX='1' or Itype_EX='1' or load_EX='1') and (rd_MEM = rs_EX)) then
				ALU_srcA_sel <= C_ALU;			--(1) forward ALU output to source A of the ALU
			end if;
			--followed by Rtype or store with rd=rt
			if ((Rtype_EX='1' or store_EX='1') and (rd_MEM = rt_EX)) then
				ALU_srcB_sel <= C_ALU;			--(2)forward ALU output to source B of the ALU
			end if;
			--followed by jr or branch 2 instructions behind with rd=rs
			if ((jr_ID='1' or branch_ID='1') and (rd_MEM = rs_ID)) then
				IDEX_q0_sel <= C_ALU;			--(7)forward ALU output to q0 of decode stage
			end if;
			--followed by branch 2 instructions behind with rd=rt
			if ((branch_ID='1') and (rd_MEM = rt_ID)) then
				IDEX_q1_sel <= C_ALU;			--(8)forward ALU otuput to q1 of decode stage
			end if;
		end if;
		
		--Itype in memory stage and followed by data hazards
		if (Itype_MEM='1') then
			--followed by Rtype, Itype, load, or store with rd=rs
			if ((Rtype_EX='1' or store_EX='1' or Itype_EX='1' or load_EX='1') and (rt_MEM = rs_EX)) then
				ALU_srcA_sel <= C_ALU;			--(1) forward ALU output to source A of the ALU
			end if;
			--followed by Rtype or store with rd=rt
			if ((Rtype_EX='1' or store_EX='1') and (rt_MEM = rt_EX)) then
				ALU_srcB_sel <= C_ALU;			--(2)forward ALU output to source B of the ALU
			end if;
			--followed by jr or branch 2 instructions behind with rd=rs
			if ((jr_ID='1' or branch_ID='1') and (rt_MEM = rs_ID)) then
				IDEX_q0_sel <= C_ALU;			--(7)forward ALU output to q0 of decode stage
			end if;
			--followed by branch 2 instructions behind with rd=rt
			if ((branch_ID='1') and (rt_MEM = rt_ID)) then
				IDEX_q1_sel <= C_ALU;			--(8)forward ALU otuput to q1 of decode stage
			end if;
		end if;
		
		--jal in memory stage and followed by data hazards
		if (jal_MEM='1') then
			--followed by Rtype, Itype, load, or store with 31=rs
			if ((Rtype_EX='1' or store_EX='1' or Itype_EX='1' or load_EX='1') and ("11111" = rs_EX)) then
				ALU_srcA_sel <= C_PC4_MEM;			--(21) forward PC+4_MEM to source A of the ALU
			end if;
			--followed by Rtype or store with 31=rt
			if ((Rtype_EX='1' or store_EX='1') and ("11111" = rt_EX)) then
				ALU_srcB_sel <= C_PC4_MEM;			--(22)forward PC+4_MEM to source B of the ALU
			end if;
			--followed by jr or branch 2 instructions behind with 31=rs
			if ((jr_ID='1' or branch_ID='1') and ("11111" = rs_ID)) then
				IDEX_q0_sel <= C_PC4_MEM;			--(27)forward PC+4_MEM to q0 of decode stage
			end if;
			--followed by branch 2 instructions behind with 31=rt
			if ((branch_ID='1') and ("11111" = rt_ID)) then
				IDEX_q1_sel <= C_PC4_MEM;			--(28)forward PC+4_MEM to q1 of decode stage
			end if;
		end if;
		
---------------------------------------------------Execute-----------------------------------------------------------------------------------------

		--Load in execute stage and followed by a JR or branch data hazard 2 instructions behind; must stall!
		if (load_EX='1' and ((jr_IF='1' and (rt_EX = rs_IF)) or (branch_IF='1' and ((rt_EX = rs_IF) or (rt_EX = rt_IF))))) then
			stall <= '1';
		end if;
		
---------------------------------------------------Decode-----------------------------------------------------------------------------------------
		
		
		
		--Rtype in decode stage and followed by a JR or branch data hazard; must stall!
		if (Rtype_ID='1' and ((jr_IF='1' and (rd_ID = rs_IF)) or (branch_IF='1' and ((rd_ID = rs_IF) or (rd_ID = rt_IF))))) then
			stall <= '1';
		end if;
		

		--Itype in decode stage and followed by a JR or branch data hazard; must stall!
		if (Itype_ID='1' and ((jr_IF='1' and (rt_ID = rs_IF)) or (branch_IF='1' and ((rt_ID = rs_IF) or (rt_ID = rt_IF))))) then
			stall <= '1';
		end if;
		
		--load in decode stage and followed by an instruction with rt=rs or rt=rt; must stall!
		if (load_ID='1') then
			if ((Rtype_IF='1' or Itype_IF='1' or load_IF='1' or store_IF='1' or jr_IF='1' or branch_IF='1') and (rt_ID = rs_IF)) then
				stall <= '1';
			end if;
			if ((Rtype_IF='1' or store_IF='1' or branch_IF='1') and (rt_ID = rt_IF)) then
				stall <= '1';
			end if;
		end if;
		
		--load in decode stage and followed by a JR or branch data hazard; must stall!
		if (jal_ID='1' and ((jr_IF='1' and ("11111" = rs_IF)) or (branch_IF='1' and (("11111" = rs_IF) or ("11111" = rt_IF))))) then
			stall <= '1';
		end if;
		
	end process;
end RTL;
