library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux is
end entity;

architecture testbench of tb_mux is
    signal x, y, z: std_logic_vector(3 downto 0);
    signal s: std_logic;

    component mux
        generic (
            n: natural := 1
        );
        port (
            x, y: in std_logic_vector(n-1 downto 0);
            s: in std_logic;
            z: out std_logic_vector(n-1 downto 0)
        );
    end component;

begin
    uut: mux generic map (4)
        port map (
            x => x,
            y => y,
            s => s,
            z => z
        );

    process
    begin
        -- Test case 1: Select input x
        x <= "0101";
        y <= "1111";
        s <= '0';
        wait for 10 ns;
        assert z = x report "Test Case 1 Failed" severity error;

        -- Test case 2: Select input y
        x <= "0101";
        y <= "1111";
        s <= '1';
        wait for 10 ns;
        assert z = y report "Test Case 2 Failed" severity error;
        wait;
    end process;

end testbench;
