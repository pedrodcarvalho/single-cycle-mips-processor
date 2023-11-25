library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
    port (
        in_1, in_2: std_logic_vector(31 downto 0);
        alu_control_funct: in std_logic_vector(3 downto 0);
        zero: out std_logic;
        alu_result: out std_logic_vector(31 downto 0)
    );
end alu;

architecture behavioral of alu is
    signal and_op: std_logic_vector(3 downto 0):= "0000";
    signal or_op: std_logic_vector(3 downto 0):= "0001";
    signal add: std_logic_vector(3 downto 0):= "0010";
    signal branch_not_equal: std_logic_vector(3 downto 0):= "0011";
    signal subtract: std_logic_vector(3 downto 0):= "0110";
    signal slt: std_logic_vector(3 downto 0):= "0111";

begin

    alu_result <= in_1 + in_2 when(alu_control_funct=add) else
                  in_1 - in_2 when(alu_control_funct=subtract or alu_control_funct=branch_not_equal) else
                  in_1 and in_2 when(alu_control_funct=and_op) else
                  in_1 or in_2 when(alu_control_funct=or_op) else
                  "00000000000000000000000000000001" when(alu_control_funct=slt and in_1 < in_2) else
                  "00000000000000000000000000000000" when(alu_control_funct=slt);

    zero <= '1' when(in_1/=in_2 and alu_control_funct=branch_not_equal) else
            '0' when(in_1=in_2 and alu_control_funct=branch_not_equal) else
            '1' when(in_1=in_2) else
            '0';

end behavioral;
