----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 08.03.2024 10:55:22
-- Module Name: decoder - Behavioral
-- Project Name: Reaction Timer
-- Description: decodes the current disired number to the 7 segment anode display
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    Port ( DISPLAY_SELECTED : in STD_LOGIC_VECTOR (2 downto 0);
           ANODE : out STD_LOGIC_VECTOR (7 downto 0));
end decoder;

architecture Behavioral of decoder is

begin

    decode : process (DISPLAY_SELECTED) is
    begin
    case DISPLAY_SELECTED is
        when "000" => ANODE <= "11111110";
        when "001" => ANODE <= "11111101";
        when "010" => ANODE <= "11111011";
        when "011" => ANODE <= "11110111";
        when "100" => ANODE <= "11101111";
        when "101" => ANODE <= "11011111";
        when "110" => ANODE <= "10111111";
        when others => ANODE <= "01111111";
    end case;
    end process decode;

end Behavioral;
