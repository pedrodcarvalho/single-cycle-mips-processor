library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is

end main;

architecture behavioral of main is
	signal ck: std_logic;
	signal instruction_address: std_logic_vector(31 downto 0); -- The address of the instruction to be loaded into the PC
	signal next_address: std_logic_vector(31 downto 0); -- The address of the next instruction to be loaded into the PC
	signal instruction: std_logic_vector(31 downto 0); -- The instruction to be loaded into the instruction register
	signal read_data_1, read_data_2, write_data, extended_immediate, shifted_immediate, alu_in_2, alu_result, last_instruction_address, incremented_address, add2_result, mux4_result, concatenated_pc_and_jump_address, mem_read_data: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
	signal shifted_jump_address: std_logic_vector(27 downto 0); -- The jump address shifted left 2 bits (for J-type instructions)
	signal jump_address: std_logic_vector(25 downto 0); -- The jump address of the instruction (for J-type instructions)
	signal immediate: std_logic_vector(15 downto 0); -- The immediate field of the instruction (for I-type instructions)
	signal opcode, funct: std_logic_vector(5 downto 0); -- The opcode and funct fields of the instruction
	signal rs, rt, rd, shamt, write_reg: std_logic_vector(4 downto 0); -- The rs, rt, rd, and shamt fields of the instruction (for R-type instructions)
	signal alu_control_funct: std_logic_vector(3 downto 0);
	signal RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite, alu_zero, branch_and_alu_zero: std_logic:= '0';
	signal AluOp: std_logic_vector(1 downto 0);

	-- Enum to verify the state of the program
	type state is (loading, running, done);
	signal s: state:= loading;

	-- Clock enable
	signal en: std_logic:= '0';

	-- Clock period
	constant clk_period : time := 10 ns;

	-- Components
	component pc
		port (
			ck: in std_logic;
			address_to_load: in std_logic_vector(31 downto 0);
			current_address: out std_logic_vector(31 downto 0)
		);
	end component;
	component instruction_memory
		port (
			read_address: in STD_LOGIC_VECTOR (31 downto 0);
			instruction, last_instruction_address: out STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	component register_file
		port (
			ck: in std_logic;
			RegWrite: in std_logic;
			read_reg_1, read_reg_2, write_reg: in std_logic_vector(4 downto 0);
			write_data: in std_logic_vector(31 downto 0);
			read_data_1, read_data_2: out std_logic_vector(31 downto 0)
		);
	end component;
	component control
		port (
			opcode: in std_logic_vector(5 downto 0);
			RegDst,Jump, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite: out std_logic;
			AluOp: out std_logic_vector(1 downto 0)
		);
	end component;
	component mux
		generic (n: natural:= 1);
		port (
			x,y: in std_logic_vector(n-1 downto 0);
			s: in std_logic;
			z: out std_logic_vector(n-1 downto 0)
		);
	end component;
	component alu_control
		port (
			funct: in std_logic_vector(5 downto 0);
			AluOp: in std_logic_vector(1 downto 0);
			alu_control_funct: out std_logic_vector(3 downto 0)
		);
	end component;
	component sign_extend
		port (
			x: in std_logic_vector(15 downto 0);
			y: out std_logic_vector(31 downto 0)
		);
	end component;
	component alu
		port (
			in_1, in_2: std_logic_vector(31 downto 0);
			alu_control_funct: in std_logic_vector(3 downto 0);
			zero: out std_logic;
			alu_result: out std_logic_vector(31 downto 0)
		);
	end component;
	component shifter
		generic (n1: natural:= 32; n2: natural:= 32; k: natural:= 2);
		port (
			x: in std_logic_vector(n1-1 downto 0);
			y: out std_logic_vector(n2-1 downto 0)
		);
	end component;
	component adder
		port (
			x,y: in std_logic_vector(31 downto 0);
			z: out std_logic_vector(31 downto 0)
		);
	end component;

	component memory is
	port (
		address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
		MemWrite, MemRead,ck: in STD_LOGIC;
		read_data: out STD_LOGIC_VECTOR (31 downto 0)
	);
	end component;

	begin

	clk_process : process
  	begin
    	ck <= '1';
    	wait for clk_period/2;
    	ck <= '0';
    	wait for clk_period/2;
  	end process;

	process(ck)
		begin
		case s is
			when running =>
				en <= ck;
			when others =>
				en <= '0';
		end case;

		if ck='1' and ck'event then
			case s is
				when loading =>
					s <= running; -- One clock cycle to load the instruction into the instruction register
				when running =>
					if instruction_address > last_instruction_address then
						s <= done; -- If the instruction address is greater than the last instruction address, stops PC from incrementing and stops the program
						en <= '0';
					end if;
				when others =>
					null;
			end case;
		end if;
	end process;

	-- Wires up the components and signals to the ports of the main component
	opcode <= instruction(31 downto 26);
	rs <= instruction(25 downto 21);
	rt <= instruction(20 downto 16);
	rd <= instruction(15 downto 11);
	shamt <= instruction(10 downto 6);
	funct <= instruction(5 downto 0);
	immediate <= instruction(15 downto 0);
	jump_address <= instruction(25 downto 0);

	Prog_Count: pc port map (en, next_address, instruction_address);

	IM: instruction_memory port map (instruction_address, instruction, last_instruction_address);

	CONTROL1: control port map (
		opcode => opcode,
		RegDst => RegDst,
		Jump => Jump,
		Branch => Branch,
		MemRead => MemRead,
		MemToReg => MemToReg,
		MemWrite => MemWrite,
		AluSrc => AluSrc,
		RegWrite => RegWrite,
		AluOp => AluOp
	);

	-- MUX from the Write Register port of the Register File (chooses between rt and rd)
	MUX1: mux generic map(5) port map (
		x => rt,
		y => rd,
		s => RegDst,
		z => write_reg
	);

	REG: register_file port map (
		ck => en,
		RegWrite => RegWrite,
		read_reg_1 => rs,
		read_reg_2 => rt,
		write_reg => write_reg,
		write_data => write_data,
		read_data_1 => read_data_1,
		read_data_2 => read_data_2
	);

	ALU_CONTRL: alu_control port map (funct, AluOp, alu_control_funct);

	-- MUX from the ALU's second input (chooses between Read Data 2 and the immediate)
	SGN_EXT: sign_extend port map (immediate, extended_immediate);

	MUX2: mux generic map(32) port map (
		x => read_data_2,
		y => extended_immediate,
		s => AluSrc,
		z => alu_in_2
	);

	ALU1: alu port map (read_data_1, alu_in_2, alu_control_funct, alu_zero, alu_result);

	-- MUX from Write Data port of the Register File (chooses between the ALU result and the data memory Read Data)
	MUX3: mux generic map (32) port map (
		x => alu_result,
		y => mem_read_data,
		s => MemToReg,
		z => write_data
	);

	-- Shift Left 2 bits for the immediate
	SHIFT1: shifter port map (
		x => extended_immediate,
		y => shifted_immediate
	);

	-- PC + 4 adder
	ADD1: adder port map (
		x => instruction_address,
		y => "00000000000000000000000000000100",
		z => incremented_address
	);

	-- MUX from the PC + 4 adder and and the sign-extended immediate (for the Branch instruction)
	branch_and_alu_zero <= Branch and alu_zero;
	MUX4: mux generic map (32) port map (
		x => incremented_address,
		y => add2_result,
		s => branch_and_alu_zero,
		z => mux4_result
	);

	-- Adder from the PC + 4 adder and the sign-extended immediate (for the Branch instruction)
	ADD2: adder port map (
		x => incremented_address,
		y => shifted_immediate,
		z => add2_result
	);

	-- Shif Left 2 bits for the Jump address
	SHIFT2: shifter generic map (n1 =>26, n2 => 28) port map (
		x => jump_address,
		y => shifted_jump_address
	);

	-- MUX from the result of the PC + 4 adder and the Jump address (for the Jump instruction)
	concatenated_pc_and_jump_address <= incremented_address(31 downto 28) & shifted_jump_address;
	MUX5: mux generic map (32) port map (
		x => mux4_result,
		y => concatenated_pc_and_jump_address,
		s => Jump,
		z => next_address
	);

	MEM: memory port map (
		address => alu_result,
		write_data => read_data_2,
		MemWrite => MemWrite,
		MemRead => MemRead,
		ck => en,
		read_data => mem_read_data
	);

end behavioral;
