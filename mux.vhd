library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
    -- n is the number of bits in the input and output vectors
    generic (
        n: natural := 1
    );
    port (
        x, y: in std_logic_vector(n-1 downto 0);
        s: in std_logic;
        z: out std_logic_vector(n-1 downto 0)
    );
end mux;

architecture behavioral of mux is
begin
    z <= x when (s = '0') else y;
end behavioral;
