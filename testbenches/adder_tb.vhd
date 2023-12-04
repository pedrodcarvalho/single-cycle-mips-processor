library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_adder is
end entity;

architecture testbench of tb_adder is
    signal x, y, z : std_logic_vector(31 downto 0);

    component adder
        port (
            x, y: in std_logic_vector(31 downto 0);
            z: out std_logic_vector(31 downto 0)
        );
    end component;
begin
    uut: adder port map (x, y, z);

    process
    begin
        -- Test case 1: Positive case
        x <= "00000000000000000000000000001111";
        y <= "00000000000000000000000000001101";

        wait for 10 ns;
        assert z = "00000000000000000000000000011100" report "Test Case 1 Failed" severity error;

        -- Test case 2: Negative case
        x <= "11111111111111111111111111110000";
        y <= "00000000000000000000000000000001";

        wait for 10 ns;
        assert z = "11111111111111111111111111110001" report "Test Case 2 Failed" severity error;
        wait;
    end process;

end testbench;
