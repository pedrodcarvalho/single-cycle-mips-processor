library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_register_file is
end entity;

architecture testbench of tb_register_file is
    signal ck, RegWrite: std_logic := '0';
    signal read_reg_1, read_reg_2, write_reg: std_logic_vector(4 downto 0);
    signal write_data, read_data_1, read_data_2: std_logic_vector(31 downto 0);

    -- register file of 32 32-bit register_file
    type mem_array is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal reg_mem: mem_array := (
        "00000000000000000000000000000000", -- $zero
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "11110000111100001111000011110000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000"
    );

    component register_file
        port (
            ck          : in std_logic;
            RegWrite   : in std_logic;
            read_reg_1  : in std_logic_vector(4 downto 0);
            read_reg_2  : in std_logic_vector(4 downto 0);
            write_reg   : in std_logic_vector(4 downto 0);
            write_data  : in std_logic_vector(31 downto 0);
            read_data_1 : out std_logic_vector(31 downto 0);
            read_data_2 : out std_logic_vector(31 downto 0)
        );
    end component;
begin
    uut: register_file
        port map (
            ck => ck,
            RegWrite => RegWrite,
            read_reg_1 => read_reg_1,
            read_reg_2 => read_reg_2,
            write_reg => write_reg,
            write_data => write_data,
            read_data_1 => read_data_1,
            read_data_2 => read_data_2
        );

    process
    begin
        -- Test case 1: Write data to register 5
        ck <= '0';
        RegWrite <= '1';
        read_reg_1 <= "00000";
        read_reg_2 <= "00000";
        write_reg <= "00101";
        write_data <= "11110000111100001111000011110000";
        wait for 10 ns;
        assert reg_mem(5) = write_data
            report "Test Case 1 Failed" severity error;

        -- Test case 2: Read data from registers 2 and 10
        ck <= '1';
        RegWrite <= '0';
        read_reg_1 <= "00010";
        read_reg_2 <= "01010";
        wait for 10 ns;
        assert read_data_1 = reg_mem(2) and read_data_2 = reg_mem(10)
            report "Test Case 2 Failed" severity error;
        wait;
    end process;

end testbench;
