----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 02.05.2024 17:01:14
-- Module Name: findMax - Behavioral
-- Project Name: Reaction Timer
-- Description: finds the maximum value in the circular buffer
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity findMax is
  Port (time_1 : in STD_LOGIC_VECTOR (15 downto 0);
       time_2 : in STD_LOGIC_VECTOR (15 downto 0);
       time_3 : in STD_LOGIC_VECTOR (15 downto 0);
       EN : in STD_LOGIC;
       max : out STD_LOGIC_VECTOR (15 downto 0));
end findMax;

architecture Behavioral of findMax is

begin
process (EN)
    begin
        if EN = '1' then
            if (time_2 = X"0000") then
                max <= time_1;
            elsif (time_3 = X"0000") then
                if (time_1 < time_2) then
                    max <= time_2;
                else
                    max <= time_1;
                end if;
            else
                if (time_1 > time_2) and (time_1 > time_3) then
                    max <= time_1;
                elsif time_2 > time_3 then
                    max <= time_2;
                else
                    max <= time_3;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
