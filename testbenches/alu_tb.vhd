library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_alu is
end entity;

architecture testbench of tb_alu is
    signal in_1, in_2 : std_logic_vector(31 downto 0);
    signal alu_control_funct : std_logic_vector(3 downto 0);
    signal zero : std_logic;
    signal alu_result : std_logic_vector(31 downto 0);

    component alu
        port (
            in_1, in_2: in std_logic_vector(31 downto 0);
            alu_control_funct: in std_logic_vector(3 downto 0);
            zero: out std_logic;
            alu_result: out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: alu
        port map (
            in_1 => in_1,
            in_2 => in_2,
            alu_control_funct => alu_control_funct,
            zero => zero,
            alu_result => alu_result
        );

    process
    begin
        -- Test case 1: ADD operation
        in_1 <= "00000000000000000000000000001111";
        in_2 <= "00000000000000000000000000001101";
        alu_control_funct <= "0010";
        wait for 10 ns;
        assert alu_result = "00000000000000000000000000011110" report "Test Case 1 Failed" severity error;

        -- Test case 2: SUBTRACT operation
        in_1 <= "00000000000000000000000000001111";
        in_2 <= "00000000000000000000000000001101";
        alu_control_funct <= "0110";
        wait for 10 ns;
        assert alu_result = "00000000000000000000000000000010" report "Test Case 2 Failed" severity error;

        -- Test case 3: AND operation
        in_1 <= "11110000111100001111000011110000";
        in_2 <= "00001111000011110000111100001111";
        alu_control_funct <= "0000";
        wait for 10 ns;
        assert alu_result = "00000000000000000000000000000000" report "Test Case 3 Failed" severity error;
        wait;
    end process;

end testbench;
