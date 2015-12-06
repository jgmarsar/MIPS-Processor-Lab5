library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instnamepackage.all;

entity datapath is
	port (
		clk : in std_logic;
		rst : in std_logic;
		WBdataOut : out std_logic_vector(31 downto 0);
		ALUoutput : out std_logic_vector(31 downto 0);
		q0Output : out std_logic_vector(31 downto 0);
		instructionOutput : out std_logic_vector(31 downto 0);
		PCoutput : out std_logic_vector(31 downto 0)
	);
end entity datapath;

architecture STR of datapath is
	--Program Counter signals
	signal PC : std_logic_vector(31 downto 0);
	signal PC4_IF : std_logic_vector(31 downto 0);
	signal PC4_ID : std_logic_vector(31 downto 0);
	signal PC4_EX : std_logic_vector(31 downto 0);
	signal PC4_MEM : std_logic_vector(31 downto 0);
	signal PC4_WB : std_logic_vector(31 downto 0);
	signal PC_next : std_logic_vector (31 downto 0);
	signal jump_imm : std_logic_vector (31 downto 0);
	signal jump_addr : std_logic_vector(31 downto 0);
	signal PC_no_branch : std_logic_vector(31 downto 0);
	signal PC_branch : std_logic_vector(31 downto 0);
	signal offset : std_logic_vector(33 downto 0);
	signal take_branch_ID : std_logic;
	signal branch_IF : std_logic;
	signal branch_ID : std_logic;
	signal BorJ : std_logic;
	signal PC_BorJ : std_logic_vector(31 downto 0);
	signal PC_Sel : std_logic_vector(1 downto 0);
	
	--instruction signals
	signal instruction_IF : std_logic_vector(31 downto 0);
	signal instruction_ID : std_logic_vector(31 downto 0);
	signal ext_imm_ID : std_logic_vector(31 downto 0);
	signal ext_imm_EX : std_logic_vector(31 downto 0);
	signal func_EX : std_logic_vector(5 downto 0);
	signal shamt_EX : std_logic_vector(4 downto 0);
	signal rs_ID : std_logic_vector(4 downto 0);
	signal rs_EX : std_logic_vector(4 downto 0);
	signal rt_ID : std_logic_vector(4 downto 0);
	signal rt_EX : std_logic_vector(4 downto 0);
	signal rt_MEM : std_logic_vector(4 downto 0);
	signal rt_WB : std_logic_vector(4 downto 0);
	signal rd_ID : std_logic_vector(4 downto 0);
	signal rd_EX : std_logic_vector(4 downto 0);
	signal rd_MEM : std_logic_vector(4 downto 0);
	signal rd_WB : std_logic_vector(4 downto 0);
	
	--control signals
	signal ALUop_IF : std_logic_vector(2 downto 0);
	signal ALUop_ID : std_logic_vector(2 downto 0);
	signal ALUop_EX : std_logic_vector(2 downto 0);
	signal wr_IF : std_logic;
	signal wr_ID : std_logic;
	signal wr_EX : std_logic;
	signal wr_MEM : std_logic;
	signal wr_WB : std_logic;
	signal ALUSrc_IF : std_logic;
	signal ALUSrc_ID : std_logic;
	signal ALUSrc_EX : std_logic;
	signal regDst_IF : std_logic;
	signal regDst_ID : std_logic;
	signal regDst_EX : std_logic;
	signal regDst_MEM : std_logic;
	signal regDst_WB : std_logic;
	signal ext_sel_IF : std_logic;
	signal ext_sel_ID : std_logic;
	signal WriteDataSel_IF : std_logic;
	signal WriteDataSel_ID : std_logic;
	signal WriteDataSel_EX : std_logic;
	signal WriteDataSel_MEM : std_logic;
	signal WriteDataSel_WB : std_logic;
	signal MemWrite_IF : std_logic;
	signal MemWrite_ID : std_logic;
	signal MemWrite_EX : std_logic;
	signal sizeSel_IF : std_logic_vector(1 downto 0);
	signal sizeSel_ID : std_logic_vector(1 downto 0);
	signal sizeSel_EX : std_logic_vector(1 downto 0);
	signal jump_IF : std_logic;
	signal jump_ID : std_logic;
	signal jtype_IF : std_logic;
	signal jtype_ID : std_logic;
	signal jal_IF : std_logic;
	signal jal_ID : std_logic;
	signal jal_EX : std_logic;
	signal jal_MEM : std_logic;
	signal jal_WB : std_logic;
	signal BEQ_IF : std_logic;
	signal BNE_IF : std_logic;
	signal BEQ_ID : std_logic;
	signal BNE_ID : std_logic;
	signal flush : std_logic;
	signal instName_IF : instruction_TYPE;
	signal instName_ID : instruction_TYPE;
	signal instName_EX : instruction_TYPE;
	signal instName_MEM : instruction_TYPE;
	signal instName_WB : instruction_TYPE;
	
	--register file signals
	signal inst_rw : std_logic_vector(4 downto 0);
	signal rw : std_logic_vector(4 downto 0);
	signal q0 : std_logic_vector(31 downto 0);
	signal q1 : std_logic_vector(31 downto 0);
	signal q0_ID : std_logic_vector(31 downto 0);
	signal q0_EX : std_logic_vector(31 downto 0);
	signal q1_ID : std_logic_vector(31 downto 0);
	signal q1_EX : std_logic_vector(31 downto 0);
	signal WBData : std_logic_vector(31 downto 0);
	signal regData : std_logic_vector(31 downto 0);
	signal equal : std_logic;
	
	--ALU I/O signals
	signal srca : std_logic_vector(31 downto 0);
	signal srcb : std_logic_vector(31 downto 0);
	signal srcb_default : std_logic_vector(31 downto 0);
	signal shdir : std_logic;
	signal sh16 : std_logic;
	signal ALUcont : std_logic_vector(3 downto 0);
	signal ALUout_EX : std_logic_vector(31 downto 0);
	signal ALUout_MEM : std_logic_vector(31 downto 0);
	signal ALUout_WB : std_logic_vector(31 downto 0);
	signal C : std_logic;
	signal V : std_logic;
	signal S : std_logic;
	signal Z : std_logic;
	
	--data memory signals
	signal readData : std_logic_vector(31 downto 0);
	signal byteEnable_EX : std_logic_vector(3 downto 0);
	signal byteEnable_MEM : std_logic_vector(3 downto 0);
	signal writeData : std_logic_vector(31 downto 0);
	signal readDataAdj_MEM : std_logic_vector(31 downto 0);
	signal readDataAdj_WB : std_logic_vector(31 downto 0);
	
	--hazard detection
	signal stall : std_logic;
	signal ALU_srcA_sel : std_logic_vector(1 downto 0);
	signal ALU_srcB_sel : std_logic_vector(1 downto 0);
	signal IDEX_q0_sel : std_logic_vector(1 downto 0);
	signal IDEX_q1_sel : std_logic_vector(1 downto 0);
	signal load_IF : std_logic;
	signal Rtype_IF : std_logic;
	signal Itype_IF : std_logic;
	signal store_IF : std_logic;
	signal jr_IF : std_logic;
	signal load_ID : std_logic;
	signal Rtype_ID : std_logic;
	signal Itype_ID : std_logic;
	signal store_ID : std_logic;
	signal jr_ID : std_logic;
	signal load_EX : std_logic;
	signal Rtype_EX : std_logic;
	signal Itype_EX : std_logic;
	signal store_EX : std_logic;
	signal load_MEM : std_logic;
	signal Rtype_MEM : std_logic;
	signal Itype_MEM : std_logic;
	signal load_WB : std_logic;
	signal Rtype_WB : std_logic;
	signal Itype_WB : std_logic;
begin
	
	--REMOVE:
	--IDEX_q0_sel <= "00";
	--IDEX_q1_sel <= "00";
	--ALU_srcA_sel <= "00";
	--ALU_srcB_sel <= "00";
	
	--HAZARD UNIT
	U_HAZ : entity work.hazardUnit
		port map(
			load_IF      => load_IF,
			Rtype_IF     => Rtype_IF,
			Itype_IF     => Itype_IF,
			store_IF     => store_IF,
			jr_IF        => jr_IF,
			jal_IF       => jal_IF,
			jump_IF      => jump_IF,
			branch_IF    => branch_IF,
			load_ID      => load_ID,
			Rtype_ID     => Rtype_ID,
			Itype_ID     => Itype_ID,
			store_ID     => store_ID,
			jr_ID        => jr_ID,
			jal_ID       => jal_ID,
			branch_ID    => branch_ID,
			load_EX      => load_EX,
			Rtype_EX     => Rtype_EX,
			Itype_EX     => Itype_EX,
			store_EX     => store_EX,
			jal_EX       => jal_EX,
			load_MEM     => load_MEM,
			Rtype_MEM    => Rtype_MEM,
			Itype_MEM    => Itype_MEM,
			jal_MEM      => jal_MEM,
			load_WB      => load_WB,
			Rtype_WB     => Rtype_WB,
			Itype_WB     => Itype_WB,
			jal_WB       => jal_WB,
			rs_IF        => instruction_IF(25 downto 21),
			rt_IF        => instruction_IF(20 downto 16),
			rs_ID        => rs_ID,
			rt_ID        => rt_ID,
			rd_ID        => rd_ID,
			rs_EX        => rs_EX,
			rt_EX        => rt_EX,
			rd_EX        => rd_EX,
			rt_MEM       => rt_MEM,
			rd_MEM       => rd_MEM,
			rt_WB        => rt_WB,
			rd_WB        => rd_WB,
			stall        => stall,
			ALU_srcA_sel => ALU_srcA_sel,
			ALU_srcB_sel => ALU_srcB_sel,
			IDEX_q0_sel  => IDEX_q0_sel,
			IDEX_q1_sel  => IDEX_q1_sel
		);
	
	--INSTRUCTION FETCH
	U_PC : entity work.reg32
		generic map(
			reset => x"003FFFFC"			--Start address - 4; instruction mem starts at PC+4 = 0x400000
		)
		port map(
			D   => PC_next,
			wr  => '1',
			Clk => clk,
			clr => rst,
			Q   => PC
		);
		
	U_INST_MEM : entity work.inst_mem
		port map(
			address => PC_next(9 downto 2),			--8-bit address; increments of 4 only, so ignore lowest 2 bits
			clock   => clk,
			data    => (others => '0'),
			wren    => '0',
			q       => instruction_IF
		);
		
	flush <= jump_ID or take_branch_ID or stall ;
		
	--PC Update
	U_ADD4 : entity work.add32
		port map(
			in0  => PC,
			in1  => x"00000004",
			cin  => '0',
			sum  => PC4_IF,
			cout => open,
			V    => open
		);
		
	U_JUMP_SH : entity work.shiftL2
		generic map(
			widthIn => 26
		)
		port map(
			input  => instruction_ID(25 downto 0),
			output => jump_imm(27 downto 0)
		);
	jump_imm(31 downto 28) <= PC4_ID(31 downto 28);		--jump address includes top four bits of current PC
		
	U_JTYPE_MUX : entity work.mux32
		port map(
			in0 => jump_imm,
			in1 => q0_ID,
			Sel => jtype_ID,
			O   => jump_addr
		);
		
	U_BRANCH_SH : entity work.shiftL2
		generic map(
			widthIn => 32
		)
		port map(
			input  => ext_imm_ID,
			output => offset
		);
		
	U_BRANCH_ADD : entity work.add32
		port map(
			in0  => PC4_ID,
			in1  => offset(31 downto 0),
			cin  => '0',
			sum  => PC_branch,
			cout => open,
			V    => open
		);
		
	U_BRANCH_CONT : entity work.branch_control
		port map(
			BEQ    => BEQ_ID,
			BNE    => BNE_ID,
			Z      => equal,
			branch => take_branch_ID
		);
		
	U_BRANCH_MUX : entity work.mux32
		port map(
			in0 => jump_addr,
			in1 => PC_branch,
			Sel => take_branch_ID,
			O   => PC_BorJ
		);
		
	PC_Sel(0) <= take_branch_ID or jump_ID;
	PC_Sel(1) <= stall;
	
	U_PC_NEXT_MUX : entity work.mux32x4
		port map(
			in0 => PC4_IF,
			in1 => PC_BorJ,
			in2 => PC,
			in3 => PC,
			Sel => PC_Sel,
			O   => PC_next
		);
		
	U_IF_ID_REG : entity work.IF_ID_reg
		port map(
			clk             => clk,
			rst             => rst,
			flush           => flush,
			PC4_IF          => PC4_IF,
			instruction_IF  => instruction_IF,
			ALUop_IF        => ALUop_IF,
			wr_IF           => wr_IF,
			ALUSrc_IF       => ALUSrc_IF,
			regDst_IF       => regDst_IF,
			ext_sel_IF      => ext_sel_IF,
			WriteDataSel_IF => WriteDataSel_IF,
			MemWrite_IF     => MemWrite_IF,
			sizeSel_IF      => sizeSel_IF,
			jump_IF         => jump_IF,
			jtype_IF        => jtype_IF,
			jal_IF          => jal_IF,
			BEQ_IF          => BEQ_IF,
			BNE_IF          => BNE_IF,
			branch_IF		=> branch_IF,
			instName_IF     => instName_IF,
			load_IF         => load_IF,
			Rtype_IF        => Rtype_IF,
			Itype_IF        => Itype_IF,
			store_IF        => store_IF,
			jr_IF           => jr_IF,
			rs_IF           => instruction_IF(25 downto 21),
			rt_IF           => instruction_IF(20 downto 16),
			rd_IF           => instruction_IF(15 downto 11),
			PC4_ID          => PC4_ID,
			instruction_ID  => instruction_ID,
			ALUop_ID        => ALUop_ID,
			wr_ID           => wr_ID,
			ALUSrc_ID       => ALUSrc_ID,
			regDst_ID       => regDst_ID,
			ext_sel_ID      => ext_sel_ID,
			WriteDataSel_ID => WriteDataSel_ID,
			MemWrite_ID     => MemWrite_ID,
			sizeSel_ID      => sizeSel_ID,
			jump_ID         => jump_ID,
			jtype_ID        => jtype_ID,
			jal_ID          => jal_ID,
			BEQ_ID          => BEQ_ID,
			BNE_ID          => BNE_ID,
			branch_ID		=> branch_ID,
			instName_ID     => instName_ID,
			load_ID         => load_ID,
			Rtype_ID        => Rtype_ID,
			Itype_ID        => Itype_ID,
			store_ID        => store_ID,
			jr_ID           => jr_ID,
			rs_ID           => rs_ID,
			rt_ID           => rt_ID,
			rd_ID           => rd_ID
		);
	
	--INSTRUCTION DECODE
	U_CONTROL : entity work.control
		port map(
			opcode => instruction_IF(31 downto 26),
			func => instruction_IF(5 downto 0),
			ALUop  => ALUop_IF,
			wr     => wr_IF,
			ALUSrc => ALUSrc_IF,
			regDst => regDst_IF,
			ext_sel => ext_sel_IF,
			WriteDataSel => WriteDataSel_IF,
			MemWrite => MemWrite_IF,
			sizeSel => sizeSel_IF,
			jump => jump_IF,
			jtype => jtype_IF,
			jal => jal_IF,
			BEQ => BEQ_IF,
			BNE => BNE_IF,
			branch => branch_IF,
			instName => instName_IF,
			load => load_IF,
			Rtype => Rtype_IF,
			Itype => Itype_IF,
			store => store_IF,
			jr => jr_IF
		);
	
	U_REGS : entity work.registerFile
		port map(
			rr0 => rs_ID,	--source register
			rr1 => rt_ID,	--source register
			rw  => rw,							--destination register from MUX
			d   => regData,
			clk => clk,
			wr  => wr_WB,
			rst => rst,
			q0  => q0,
			q1  => q1
		);
		
	U_REG_MUX1 : entity work.mux5		--select between rt and rd
		port map(
			in0 => rt_WB,
			in1 => rd_WB,
			Sel => regDst_WB,
			O   => inst_rw
		);
		
	U_REG_MUX2 : entity work.mux5		--select between rt/rd or $31 (for jal instruction)
		port map(
			in0 => inst_rw,
			in1 => "11111",
			Sel => jal_WB,
			O   => rw
		);
		
	U_REG_COMP : entity work.regCompare
		port map(
			q0    => q0_ID,
			q1    => q1_ID,
			equal => equal
		);
		
	U_ALU_CONT : entity work.alu32control
		port map(
			ALUop   => ALUop_EX,
			func    => func_EX,
			control => ALUcont,
			shdir   => shdir,
			sh16	=> sh16
		);
		
	U_EXT : entity work.extender
		port map(
			in0  => instruction_ID(15 downto 0),		--immediate
			Sel => ext_sel_ID,
			out0 => ext_imm_ID
		);
		
	U_Q0_MUX : entity work.mux32x4
		port map(
			in0 => q0,
			in1 => ALUout_MEM,
			in2 => regData,
			in3 => PC4_MEM,
			Sel => IDEX_q0_sel,
			O   => q0_ID
		);
		
	U_Q1_MUX : entity work.mux32x4
		port map(
			in0 => q1,
			in1 => ALUout_MEM,
			in2 => regData,
			in3 => PC4_MEM,
			Sel => IDEX_q1_sel,
			O   => q1_ID
		);
	
	U_ID_EX_REG : entity work.ID_EX_reg
		port map(
			clk             => clk,
			rst             => rst,
			ALUop_ID        => ALUop_ID,
			wr_ID           => wr_ID,
			ALUSrc_ID       => ALUSrc_ID,
			regDst_ID       => regDst_ID,
			WriteDataSel_ID => WriteDataSel_ID,
			MemWrite_ID     => MemWrite_ID,
			sizeSel_ID      => sizeSel_ID,
			jal_ID          => jal_ID,
			instName_ID     => instName_ID,
			load_ID 		=> load_ID,
			Rtype_ID 		=> Rtype_ID,
			Itype_ID 		=> Itype_ID,
			store_ID 		=> store_ID,
			ALUop_EX        => ALUop_EX,
			wr_EX           => wr_EX,
			ALUSrc_EX       => ALUSrc_EX,
			regDst_EX       => regDst_EX,
			WriteDataSel_EX => WriteDataSel_EX,
			MemWrite_EX     => MemWrite_EX,
			sizeSel_EX      => sizeSel_EX,
			jal_EX          => jal_EX,
			instName_EX     => instName_EX,
			load_EX 		=> load_EX,
			Rtype_EX 		=> Rtype_EX,
			Itype_EX 		=> Itype_EX,
			store_EX 		=> store_EX,
			q0_ID           => q0_ID,
			q1_ID           => q1_ID,
			ext_imm_ID      => ext_imm_ID,
			func_ID         => instruction_ID(5 downto 0),
			shamt_ID        => instruction_ID(10 downto 6),
			rs_ID			=> rs_ID,
			rt_ID			=> rt_ID,
			rd_ID			=> rd_ID,
			PC4_ID          => PC4_ID,
			q0_EX           => q0_EX,
			q1_EX           => q1_EX,
			ext_imm_EX      => ext_imm_EX,
			func_EX         => func_EX,
			shamt_EX        => shamt_EX,
			rs_EX			=> rs_EX,
			rt_EX			=> rt_EX,
			rd_EX			=> rd_EX,
			PC4_EX          => PC4_EX
		);
		
	--INSTRUCTION EXECUTE
	U_ALU : entity work.alu32
		port map(
			ia      => srca,
			ib      => srcb,
			control => ALUcont,
			shamt   => shamt_EX,
			shdir   => shdir,
			sh16	=> sh16,
			o       => ALUout_EX,
			C       => C,
			Z       => Z,
			V       => V,
			S       => S
		);
		
	U_ALU_MUX : entity work.mux32
		port map(
			in0 => srcb_default,
			in1 => ext_imm_EX,
			Sel => ALUSrc_EX,
			O   => srcb
		);
		
	U_SRCA_MUX : entity work.mux32x4
		port map(
			in0 => q0_EX,
			in1 => ALUout_MEM,
			in2 => regData,
			in3 => PC4_MEM,
			Sel => ALU_srcA_sel,
			O   => srca
		);
		
	U_SRCB_MUX : entity work.mux32x4
		port map(
			in0 => q1_EX,
			in1 => ALUout_MEM,
			in2 => regData,
			in3 => PC4_MEM,
			Sel => ALU_srcB_sel,
			O   => srcb_default
		);
	
	U_BYTE_CONT : entity work.byte_control
		port map(
			sizeSel    => sizeSel_EX,
			byteSel    => ALUout_EX(1 downto 0),
			byteEnable => byteEnable_EX
		);
		
	U_BYTE_ADJ_WR : entity work.byte_adj_write
		port map(
			dataIn     => srcb_default,
			byteEnable => byteEnable_EX,
			dataOut    => writeData
		);
		
	U_EX_MEM_REG : entity work.EX_MEM_reg
		port map(
			clk              => clk,
			rst              => rst,
			wr_EX            => wr_EX,
			regDst_EX        => regDst_EX,
			WriteDataSel_EX  => WriteDataSel_EX,
			jal_EX           => jal_EX,
			instName_EX      => instName_EX,
			load_EX			 => load_EX,
			Rtype_EX		 => Rtype_EX,
			Itype_EX		 => Itype_EX,
			wr_MEM           => wr_MEM,
			regDst_MEM       => regDst_MEM,
			WriteDataSel_MEM => WriteDataSel_MEM,
			jal_MEM          => jal_MEM,
			instName_MEM     => instName_MEM,
			load_MEM		 => load_MEM,
			Rtype_MEM		 => Rtype_MEM,
			Itype_MEM		 => Itype_MEM,
			ALUout_EX        => ALUout_EX,
			byteEnable_EX    => byteEnable_EX,
			PC4_EX           => PC4_EX,
			rt_EX			 => rt_EX,
			rd_EX			 => rd_EX,
			ALUout_MEM       => ALUout_MEM,
			byteEnable_MEM   => byteEnable_MEM,
			PC4_MEM          => PC4_MEM,
			rt_MEM			 => rt_MEM,
			rd_MEM			 => rd_MEM
		);
		
	--MEM/WRITE BACK
	U_DATA_MEM : entity work.data_mem
		port map(
			address => ALUout_EX(9 downto 2),		--word addressed; ignore 2 LSBs
			byteena => byteEnable_EX,
			clock   => clk,
			data    => writeData,
			wren    => MemWrite_EX,
			q       => readData
		);
		
	U_BYTE_ADJ_RD : entity work.byte_adj_read
		port map(
			dataIn     => readData,
			byteEnable => byteEnable_MEM,
			dataOut    => readDataAdj_MEM
		);
		
	U_WB_MUX1 : entity work.mux32				--select between ALU and Memory data
		port map(
			in0 => ALUout_WB,
			in1 => readDataAdj_WB,
			Sel => WriteDataSel_WB,
			O   => WBData
		);
		
	U_WB_MUX2 : entity work.mux32				--select between write back data and PC+4 (for jal instruction)
		port map(
			in0 => WBdata,
			in1 => PC4_WB,
			Sel => jal_WB,
			O   => regData
		);
		
	U_MEM_WB_REG : entity work.MEM_WB_reg
		port map(
			clk              => clk,
			rst              => rst,
			wr_MEM           => wr_MEM,
			regDst_MEM       => regDst_MEM,
			WriteDataSel_MEM => WriteDataSel_MEM,
			jal_MEM          => jal_MEM,
			instName_MEM     => instName_MEM,
			load_MEM		 => load_MEM,
			Rtype_MEM		 => Rtype_MEM,
			Itype_MEM		 => Itype_MEM,
			wr_WB            => wr_WB,
			regDst_WB        => regDst_WB,
			WriteDataSel_WB  => WriteDataSel_WB,
			jal_WB           => jal_WB,
			instName_WB      => instName_WB,
			load_WB		 	 => load_WB,
			Rtype_WB		 => Rtype_WB,
			Itype_WB		 => Itype_WB,
			readDataAdj_MEM  => readDataAdj_MEM,
			ALUout_MEM       => ALUout_MEM,
			PC4_MEM          => PC4_MEM,
			rt_MEM			 => rt_MEM,
			rd_MEM			 => rd_MEM,
			readDataAdj_WB   => readDataAdj_WB,
			ALUout_WB        => ALUout_WB,
			PC4_WB           => PC4_WB,
			rt_WB			 => rt_WB,
			rd_WB			 => rd_WB
		);
		
	WBdataOut <= WBdata;
	ALUoutput <= ALUout_MEM;
	q0Output <= q0_EX;
	instructionOutput <= instruction_ID;
	PCoutput <= PC;
end architecture STR;

