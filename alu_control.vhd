-- Operation codes:
-- and: 0000
-- or: 0001
-- add: 0010
-- bne: 0011
-- subtract: 0110
-- slt: 0111

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_control is
    port (
        funct              : in  std_logic_vector(5 downto 0);
        AluOp             : in  std_logic_vector(1 downto 0);
        alu_control_funct   : out std_logic_vector(3 downto 0)
    );
end alu_control;

architecture behavioral of alu_control is
    signal and_op          : std_logic_vector(3 downto 0) := "0000";
    signal or_op           : std_logic_vector(3 downto 0) := "0001";
    signal add             : std_logic_vector(3 downto 0) := "0010";
    signal branch_not_equal : std_logic_vector(3 downto 0) := "0011";
    signal subtract        : std_logic_vector(3 downto 0) := "0110";
    signal slt: std_logic_vector(3 downto 0) := "0111";

begin

    alu_control_funct <= add when (AluOp = "00" or (AluOp = "10" and funct = "100000")) else
                        subtract when (AluOp = "01" or (AluOp = "10" and funct = "100010")) else
                        branch_not_equal when (AluOp = "11") else
                        and_op when (AluOp = "10" and funct = "100100") else
                        or_op when (AluOp = "10" and funct = "100101") else
                        slt when (AluOp = "10" and funct = "101010") else
                        "0000";

end behavioral;
