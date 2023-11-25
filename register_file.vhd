library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_file is
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
end register_file;

architecture behavioral of register_file is

    -- register file of 32 32-bit register_file
    type mem_array is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal reg_mem: mem_array := (
        "00000000000000000000000000000000", -- $zero
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

    read_data_1 <= reg_mem(to_integer(unsigned(read_reg_1)));
    read_data_2 <= reg_mem(to_integer(unsigned(read_reg_2)));

    process(ck)
        begin
            if ck='0' and ck'event and RegWrite='1' then
                reg_mem(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end process;

end behavioral;
