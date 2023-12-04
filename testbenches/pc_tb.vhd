library IEEE;
use IEEE.std_logic_1164.all;

entity tb_pc is
end entity;

architecture testbench of tb_pc is
    signal ck: std_logic := '0';
    signal address_to_load, current_address: std_logic_vector(31 downto 0);

    component pc
        port(
            ck: in std_logic;
            address_to_load: in std_logic_vector(31 downto 0);
            current_address: out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: pc port map (ck, address_to_load, current_address);

    process
    begin
        -- Apply a sequence of addresses
        address_to_load <= "00000000000000000000000000000001";
        wait for 10 ns;

        address_to_load <= "00000000000000000000000000000100";
        wait for 10 ns;

        address_to_load <= "11111111111111111111111111111111";
        wait for 10 ns;

        wait for 5 ns; -- Wait for the next clock cycle

        -- Check if current_address updates accordingly
        assert current_address = "11111111111111111111111111111111"
            report "Test failed!"
            severity error;

        wait;
    end process;

    -- Clock generation process
    process
    begin
        while now < 100 ns loop
            ck <= not ck;
            wait for 5 ns;
        end loop;
        wait;
    end process;

end testbench;
