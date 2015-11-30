library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instNamePackage.all;

entity control is
	port (
		opcode : in std_logic_vector(5 downto 0);
		func : in std_logic_vector(5 downto 0);
		ALUop : out std_logic_vector(2 downto 0);
		wr : out std_logic;
		ALUSrc : out std_logic;
		regDst : out std_logic;
		ext_sel : out std_logic;
		WriteDataSel : out std_logic;
		MemWrite : out std_logic;
		sizeSel : out std_logic_vector(1 downto 0);
		jump : out std_logic;
		jtype : out std_logic;
		jal : out std_logic;
		BEQ : out std_logic;
		BNE : out std_logic;
		instName : out instruction_TYPE;
		
		--signals for hazard control
		load : out std_logic;
		Rtype : out std_logic;
		Itype : out std_logic;
		store : out std_logic;
		jr : out std_logic
	);
end entity control;

architecture BHV of control is
	--regDst select
	constant C_RT : std_logic := '0';
	constant C_RD : std_logic := '1';
	--ALUSrc select
	constant C_Q1 : std_logic := '0';
	constant C_IMM : std_logic := '1';
	--ext_sel select
	constant C_ZERO : std_logic := '0';
	constant C_SIGN : std_logic := '1';
	--WriteDataSel
	constant C_ALU : std_logic := '0';
	constant C_MEM : std_logic := '1';
	--byte sizeSel
	constant C_WORD : std_logic_vector(1 downto 0) := "10";
	constant C_HALF : std_logic_vector(1 downto 0) := "01";
	constant C_BYTE : std_logic_vector(1 downto 0) := "00";
	--jtype select
	constant C_JIMM : std_logic := '0';
	constant C_JREG : std_logic := '1';
begin
	process(opcode, func)
	begin
		ALUop <= "000";
		wr <= '0';
		ALUSrc <= '0';
		regDst <= '0';
		ext_sel <= '0';
		WriteDataSel <= '0';
		MemWrite <= '0';
		sizeSel <= "00";
		jump <= '0';
		jtype <= '0';
		jal <= '0';
		BEQ <= '0';
		BNE <= '0';
		instName <= NOP;
		
		load <= '0';
		Rtype <= '0';
		Itype <= '0';
		store <= '0';
		jr <= '0';
		case opcode is
			when "000000" =>			--R-type
				Rtype <= '1';
				ALUop <= "010";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_Q1;
				regDst <= C_RD;
				if (func = "001000") then		--JR
					Rtype <= '0'
					jr <= '1';
					jump <= '1';
					jtype <= C_JREG;
					wr <= '0';
					instName <= R_JR;
				elsif (func = "100000") then
					instName <= R_ADD;
				elsif (func = "100001") then
					instName <= R_ADDU;
				elsif (func = "100100") then
					instName <= R_AND;
				elsif (func = "100111") then
					instName <= R_NOR;
				elsif (func = "100101") then
					instName <= R_OR;
				elsif (func = "101010") then
					instName <= R_SLT;
				elsif (func = "101011") then
					instName <= R_SLTU;
				elsif (func = "000000") then
					instName <= R_SLL;
				elsif (func = "000010") then
					instName <= R_SRL;
				elsif (func = "100010") then
					instName <= R_SUB;
				elsif (func = "100011") then
					instName <= R_SUBU;
				end if;
			when "000010" =>			--J
				jump <= '1';
				jtype <= C_JIMM;
				instName <= J_J;
			when "000011" =>			--JAL
				jump <= '1';
				jtype <= C_JIMM;
				jal <= '1';
				wr <= '1';
				instName <= J_JAL;
			when "000100" =>			--BEQ
				ALUop <= "001";
				ALUSrc <= C_Q1;
				ext_sel <= C_SIGN;
				jump <= '0';
				BEQ <= '1';
				instName <= I_BEQ;
			when "000101" =>			--BNE
				ALUop <= "001";
				ALUSrc <= C_Q1;
				ext_sel <= C_SIGN;
				jump <= '0';
				BNE <= '1';
				instName <= I_BNE;
			when "001000" =>			--ADDI
				Itype <= '1';
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				instName <= I_ADDI;
			when "001001" =>			--ADDIU
				Itype <= '1';
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
				instName <= I_ADDIU;
			when "001010" =>			--SLTI
				Itype <= '1';
				ALUop <= "101";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				instName <= I_SLTI;
			when "001011" =>			--SLTIU
				Itype <= '1';
				ALUop <= "110";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
				instName <= I_SLTIU;
			when "001100" =>			--ANDI
				Itype <= '1';
				ALUop <= "011";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
				instName <= I_ANDI;
			when "001101" =>			--ORI
				Itype <= '1';
				ALUop <= "100";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
				instName <= I_ORI;
			when "001111" =>			--LUI
				Itype <= '1';
				ALUop <= "111";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
				instName <= I_LUI;
			when "100011" =>			--LW
				load <= '1';
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_MEM;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				sizeSel <= C_WORD;
				instName <= I_LW;
			when "100100" =>			--LBU
				load <= '1';
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_MEM;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				sizeSel <= C_BYTE;
				instName <= I_LBU;
			when "100101" =>			--LHU
				load <= '1';
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_MEM;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				sizeSel <= C_HALF;
				instName <= I_LHU;
			when "101000" =>			--SB
				store <= '1';
				ALUop <= "000";
				ALUSrc <= C_IMM;
				ext_sel <= C_SIGN;
				MemWrite <= '1';
				sizeSel <= C_BYTE;
				instName <= I_SB;
			when "101001" =>			--SH
				store <= '1';
				ALUop <= "000";
				ALUSrc <= C_IMM;
				ext_sel <= C_SIGN;
				MemWrite <= '1';
				sizeSel <= C_HALF;
				instName <= I_SH;
			when "101011" =>			--SW
				store <= '1';
				ALUop <= "000";
				ALUSrc <= C_IMM;
				ext_sel <= C_SIGN;
				MemWrite <= '1';
				sizeSel <= C_WORD;
				instName <= I_SW;
			when others => null;
		end case;
		
	end process;
end architecture BHV;

