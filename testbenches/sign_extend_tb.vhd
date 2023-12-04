library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_sign_extend is
end entity;

architecture testbench of tb_sign_extend is
    signal x: std_logic_vector(15 downto 0);
    signal y: std_logic_vector(31 downto 0);

    component sign_extend
        port (
            x: in std_logic_vector(15 downto 0);
            y: out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: sign_extend
        port map (
            x => x,
            y => y
        );

    process
    begin
        -- Test case 1: Positive value
        x <= "0000000000001100";
        wait for 10 ns;
        assert y = "00000000000000000000000000001100"
            report "Test Case 1 Failed" severity error;

        -- Test case 2: Negative value
        x <= "1111111111111010";
        wait for 10 ns;
        assert y = "11111111111111111111111111111010"
            report "Test Case 2 Failed" severity error;
        wait;
    end process;

end testbench;
