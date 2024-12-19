----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 01.03.2024 14:45:09
-- Module Name: display_selec - Behavioral
-- Project Name: Reaction Timer
-- Description: selects which 7 segment anode we are looking at
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_selector is
    Port ( DISPLAY_CLK : in STD_LOGIC;
           SELEC : out STD_LOGIC_VECTOR (2 downto 0));
end display_selector;

architecture Behavioral of display_selector is

signal count: std_logic_vector (2 downto 0) := (others => '0');
begin

    SELEC <= count;
    
    process (DISPLAY_CLK)
    begin
        if rising_edge(DISPLAY_CLK) then
                count <= std_logic_vector(unsigned(count) + 1);
        end if;
    end process;


end Behavioral;
