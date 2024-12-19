library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Port ( CLK : in STD_LOGIC;
           COUNT : out std_logic_vector (7 downto 0));
end counter;

architecture Behavioral of counter is
    signal count_tmp: std_logic_vector (7 downto 0) := (others => '0');
begin

    COUNT <= count_tmp;
    process (CLK)
    begin
        if rising_edge(CLK) then
                count_tmp <= std_logic_vector(unsigned(count_tmp) + 1);
        end if;
    end process;
    
end Behavioral;
