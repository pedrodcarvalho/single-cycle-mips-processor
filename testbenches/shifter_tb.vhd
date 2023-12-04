library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_shifter is
end entity;

architecture testbench of tb_shifter is
    signal x, y: std_logic_vector(31 downto 0);

    component shifter
        generic (
            n1: natural := 32;
            n2: natural := 32;
            k: natural := 2
        );
        port (
            x: in std_logic_vector(n1-1 downto 0);
            y: out std_logic_vector(n2-1 downto 0)
        );
    end component;

begin
    uut: shifter generic map (32, 32, 2)
        port map (
            x => x,
            y => y
        );

    process
    begin
        -- Test case 1: Shift left by 2
        x <= "11001100110011001100110011001100";
        wait for 10 ns;
        assert y = "00110011001100110011001100110000"
            report "Test Case 1 Failed" severity error;

        -- Test case 2: Shift left by 1
        x <= "01010101010101010101010101010101";
        wait for 10 ns;
        assert y = "10101010101010101010101010101010"
            report "Test Case 2 Failed" severity error;
        wait;
    end process;

end testbench;
