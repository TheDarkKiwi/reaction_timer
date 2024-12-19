----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 11.03.2024 13:14:48
-- Module Name: mux - Behavioral
-- Project Name: Reaction Timer
-- Description: takes part of the message out dependant on what anode we are currently displaying
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Port ( Display_Sel : in STD_LOGIC_VECTOR (2 downto 0);
           Message : in STD_LOGIC_VECTOR (31 downto 0);
           BCD : out STD_LOGIC_VECTOR (3 downto 0);
           DP : out STD_LOGIC);
end mux;

architecture Behavioral of mux is

signal dummy : STD_LOGIC_VECTOR (3 downto 0);

begin
    process (Display_Sel, Message, dummy)
    begin
    case Display_Sel is
        when "000" => dummy<= Message(3 downto 0);
        when "001" => dummy<= Message(7 downto 4);
        when "010" => dummy<= Message(11 downto 8);
        when "011" => dummy<= Message(15 downto 12);
        when "100" => dummy<= Message(19 downto 16);
        when "101" => dummy<= Message(23 downto 20);
        when "110" => dummy<= Message(27 downto 24);
        when others => dummy <= Message(31 downto 28);
    end case;
    if (dummy = "1111") then
        DP <= '1';
        BCD <= "1010";
    else
        DP <= '0';
        BCD <= dummy;
    end if;
    
    end process;

end Behavioral;
