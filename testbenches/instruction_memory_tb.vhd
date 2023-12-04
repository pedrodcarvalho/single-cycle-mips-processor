library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity tb_instruction_memory is
end entity;

architecture testbench of tb_instruction_memory is
    signal read_address, instruction, last_instruction_address: std_logic_vector(31 downto 0);

    -- 32 x 32-bit instruction memory (4 bytes per instruction)
    type mem_array is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal data_mem : mem_array := (
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
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000"
    );

    component instruction_memory
        port (
            read_address        : in  STD_LOGIC_VECTOR (31 downto 0);
            instruction         : out STD_LOGIC_VECTOR (31 downto 0);
            last_instruction_address  : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

begin
    uut: instruction_memory
        port map (
            read_address => read_address,
            instruction => instruction,
            last_instruction_address => last_instruction_address
        );

    process
        file file_pointer : text open read_mode is "/home/pedro/Codes/single-cycle-mips-processor/assets/instructions.txt";
        variable line_content : string(1 to 32);
        variable line_num : line;
        variable char : character := '0';
        variable i : integer := 0;

    begin
        wait for 10 ns;

        for i in 0 to 31 loop
            read_address <= std_logic_vector(to_unsigned(i * 4, read_address'length));

            if i > 0 then
                wait for 10 ns;
                assert instruction = data_mem(i) and last_instruction_address = std_logic_vector(to_unsigned((i - 1) * 4, last_instruction_address'length))
                    report "Test Case Failed" severity error;
            end if;
        end loop;

        wait;
    end process;

    process
    begin
        wait for 100 ns;
        assert false report "Testbench completed" severity note;
        wait;
    end process;

end testbench;
