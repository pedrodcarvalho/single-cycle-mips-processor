library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_control is
end entity;

architecture testbench of tb_control is
    signal opcode : std_logic_vector(5 downto 0);
    signal RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite : std_logic;
    signal AluOp : std_logic_vector(1 downto 0);

    component control
        port (
            opcode: in std_logic_vector(5 downto 0);
            RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite: out std_logic;
            AluOp: out std_logic_vector(1 downto 0)
        );
    end component;

begin
    uut: control
        port map (
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

    process
    begin
        -- Test case 1: R-type instruction
        opcode <= "000000";
        wait for 10 ns;
        assert RegDst = '1' and Jump = '0' and Branch = '0' and MemRead = '0' and MemToReg = '0' and MemWrite = '0' and AluSrc = '0' and RegWrite = '1' and AluOp = "10"
            report "Test Case 1 Failed" severity error;

        -- Test case 2: ADDI instruction
        opcode <= "001000";
        wait for 10 ns;
        assert RegDst = '0' and Jump = '0' and Branch = '0' and MemRead = '0' and MemToReg = '0' and MemWrite = '0' and AluSrc = '1' and RegWrite = '1' and AluOp = "00"
            report "Test Case 2 Failed" severity error;

        -- Test case 3: BEQ instruction
        opcode <= "000100";
        wait for 10 ns;
        assert RegDst = '0' and Jump = '0' and Branch = '1' and MemRead = '0' and MemToReg = '0' and MemWrite = '0' and AluSrc = '0' and RegWrite = '0' and AluOp = "01"
            report "Test Case 3 Failed" severity error;
        wait;
    end process;

end testbench;
