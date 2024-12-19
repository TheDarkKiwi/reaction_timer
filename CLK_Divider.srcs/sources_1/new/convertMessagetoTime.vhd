----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 26.04.2024 13:49:57
-- Module Name: convertMessagetoTime - Behavioral
-- Project Name: Reaction Timer
-- Description: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity convertMessagetoTime is
    Port ( Message : in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
           TimeOut : out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
           EN : in std_logic);
end convertMessagetoTime;

architecture Behavioral of convertMessagetoTime is
signal intermediate : STD_LOGIC_VECTOR (15 downto 0);
begin
    process (Message, EN)
        begin
        if (EN='1') then
            intermediate <= STD_LOGIC_VECTOR(X"0000" + unsigned(Message(3 downto 0)) + ("1010" * unsigned(Message(7 downto 4))) + (X"64" * unsigned(Message(11 downto 8))) + (X"3E8" * unsigned(Message(15 downto 12))));
        end if;
    end process;
TimeOut <= intermediate;
end Behavioral;
