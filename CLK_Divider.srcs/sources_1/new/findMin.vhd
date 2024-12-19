----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 02.05.2024 16:55:45
-- Module Name: findMin - Behavioral
-- Project Name: Reaction Timer
-- Description: finds teh minimum value of teh circular buffer
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity findMin is
    Port ( time_1 : in STD_LOGIC_VECTOR (15 downto 0);
           time_2 : in STD_LOGIC_VECTOR (15 downto 0);
           time_3 : in STD_LOGIC_VECTOR (15 downto 0);
           EN : in STD_LOGIC;
           min : out STD_LOGIC_VECTOR (15 downto 0));
end findMin;

architecture Behavioral of findMin is
begin
process (EN)
    begin
        if EN = '1' then
            if (time_2 = X"0000") then
                min <= time_1;
            elsif (time_3 = X"0000") then
                if (time_1 > time_2) then
                    min <= time_2;
                else
                    min <= time_1;
                end if;
            else
                if (time_1 < time_2) and (time_1 < time_3) then
                    min <= time_1;
                elsif time_2 < time_3 then
                    min <= time_2;
                else
                    min <= time_3;
                end if;
            end if;
        end if;
    end process;
end Behavioral;