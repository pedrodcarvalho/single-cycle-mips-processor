library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_memory is
end entity;

architecture testbench of tb_memory is
    signal address, write_data: std_logic_vector(31 downto 0);
    signal MemWrite, MemRead, ck: std_logic;
    signal read_data: std_logic_vector(31 downto 0);

    component memory
        port (
            address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
            MemWrite, MemRead, ck: in STD_LOGIC;
            read_data: out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

begin
    uut: memory
        port map (
            address => address,
            write_data => write_data,
            MemWrite => MemWrite,
            MemRead => MemRead,
            ck => ck,
            read_data => read_data
        );

    process
    begin
        -- Test case 1: Write data to memory
        address <= "00000000000000000000000000000000";
        write_data <= "11111111000000001111111100000000";
        MemWrite <= '1';
        ck <= '0';
        wait for 10 ns;
        assert data_mem(0) = write_data
            report "Test Case 1 Failed" severity error;

        -- Test case 2: Read data from memory
        address <= "00000000000000000000000000000000";
        MemRead <= '1';
        ck <= '0';
        wait for 10 ns;
        assert read_data = write_data
            report "Test Case 2 Failed" severity error;
        wait;
    end process;

end testbench;
