library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all; -- For reading from files

entity instruction_memory is
    port (
        read_address        : in  STD_LOGIC_VECTOR (31 downto 0);
        instruction         : out STD_LOGIC_VECTOR (31 downto 0);
        last_instruction_address  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end instruction_memory;

architecture behavioral of instruction_memory is

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

begin

    -- Reads the binary code instruction into the instruction memory
    process
        file file_pointer : text open read_mode is "/home/pedro/Codes/single-cycle-mips-processor/assets/instructions.txt";
        variable line_content : string(1 to 32);
        variable line_num : line;
        variable i : integer := 0;
        variable j : integer := 0;
        variable char : character := '0';

    begin
        while not endfile(file_pointer) loop
            readline(file_pointer, line_num);
            READ(line_num, line_content);
            for j in 1 to 32 loop
                char := line_content(j);
                if (char = '0') then
                    data_mem(i)(32 - j) <= '0';
                else
                    data_mem(i)(32 - j) <= '1';
                end if;
            end loop;
            i := i + 1;
        end loop;

        if i > 0 then
            last_instruction_address <= std_logic_vector(to_unsigned((i - 1) * 4, last_instruction_address'length));
        else
            last_instruction_address <= "00000000000000000000000000000000";
        end if;

        file_close(file_pointer);
        wait;
    end process;

    -- Registers have 4 bytes each, so it's necessary to discard the last two bits
    instruction <= data_mem(to_integer(unsigned(read_address(31 downto 2))));

end behavioral;
