-- Control Unit Signals:
-- RegDst: writes to the register specified in the rd field of the instruction
-- Jump: jumps to the address in the register
-- Branch: branches if the two registers are equal
-- MemRead: reads from data memory
-- MemToReg: writes the data memory value to the register
-- MemWrite: writes to data memory
-- AluSrc: uses the immediate value as the second operand to the ALU
-- RegWrite: writes to the register file
-- AluOp: specifies the operation to be performed by the ALU

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control is
    port (
        opcode: in std_logic_vector(5 downto 0);
        RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite: out std_logic;
        AluOp: out std_logic_vector(1 downto 0)
    );
end control;

architecture behavioral of control is
begin

    --        R-types                       addi                          beq                           bne                           jump                          lw                            sw
    RegDst <= '1' when opcode="000000" else '0' when opcode="001000" else '0' when opcode="000100" else '0' when opcode="000101" else '0' when opcode="000010" else '0' when opcode="100011" else '0' when opcode="101011" else '0';
    Jump <= '0' when opcode="000000" else '0' when opcode="001000" else '0' when opcode="000100" else '0' when opcode="000101" else '1' when opcode="000010" else '0' when opcode="100011" else '0' when opcode="101011" else '0';
    Branch <= '0' when opcode="000000" else '0' when opcode="001000" else '1' when opcode="000100" else '1' when opcode="000101" else '0' when opcode="000010" else '0' when opcode="100011" else '0' when opcode="101011" else '0';
    MemRead <= '0' when opcode="000000" else '0' when opcode="001000" else '0' when opcode="000100" else '0' when opcode="000101" else '0' when opcode="000010" else '1' when opcode="100011" else '0' when opcode="101011" else '0';
    MemToReg <= '0' when opcode="000000" else '0' when opcode="001000" else '0' when opcode="000100" else '0' when opcode="000101" else '0' when opcode="000010" else '1' when opcode="100011" else '0' when opcode="101011" else '0';
    MemWrite <= '0' when opcode="000000" else '0' when opcode="001000" else '0' when opcode="000100" else '0' when opcode="000101" else '0' when opcode="000010" else '0' when opcode="100011" else '1' when opcode="101011" else '0';
    AluSrc <= '0' when opcode="000000" else '1' when opcode="001000" else '0' when opcode="000100" else '0' when opcode="000101" else '0' when opcode="000010" else '1' when opcode="100011" else '1' when opcode="101011" else '0';
    RegWrite <= '1' when opcode="000000" else '1' when opcode="001000" else '0' when opcode="000100" else '0' when opcode="000101" else '0' when opcode="000010" else '1' when opcode="100011" else '0' when opcode="101011" else '0';
    AluOp <= "10" when opcode="000000" else "00" when opcode="001000" else "01" when opcode="000100" else "11" when opcode="000101" else "00" when opcode="000010" else "00" when opcode="100011" else "00" when opcode="101011" else "00";

end behavioral;
