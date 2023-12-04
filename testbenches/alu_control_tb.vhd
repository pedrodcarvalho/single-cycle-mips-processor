library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_alu_control is
end entity;

architecture testbench of tb_alu_control is
    signal funct : std_logic_vector(5 downto 0);
    signal AluOp : std_logic_vector(1 downto 0);
    signal alu_control_funct : std_logic_vector(3 downto 0);

    component alu_control
        port (
            funct              : in  std_logic_vector(5 downto 0);
            AluOp             : in  std_logic_vector(1 downto 0);
            alu_control_funct   : out std_logic_vector(3 downto 0)
        );
    end component;

begin
    uut: alu_control
        port map (
            funct              => funct,
            AluOp             => AluOp,
            alu_control_funct   => alu_control_funct
        );

    process
    begin
        -- Test case 1: ADD operation
        funct <= "100000";
        AluOp <= "00";
        wait for 10 ns;
        assert alu_control_funct = "0010" report "Test Case 1 Failed" severity error;

        -- Test case 2: SUBTRACT operation
        funct <= "100010";
        AluOp <= "01";
        wait for 10 ns;
        assert alu_control_funct = "0110" report "Test Case 2 Failed" severity error;

        -- Test case 3: BNE operation
        funct <= "000101";
        AluOp <= "11";
        wait for 10 ns;
        assert alu_control_funct = "0011" report "Test Case 3 Failed" severity error;
        wait;
    end process;

end testbench;
