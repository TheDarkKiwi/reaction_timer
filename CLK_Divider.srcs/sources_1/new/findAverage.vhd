----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 02.05.2024 16:42:39
-- Module Name: findAverage - Behavioral
-- Project Name: Reaction Timer
-- Description: finds the average of the circular buffer
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity findAverage is
    Port ( time_1 : in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
           time_2 : in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
           time_3 : in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
           EN : in STD_LOGIC;
           average : out STD_LOGIC_VECTOR (15 downto 0) := (others => '0'));
end findAverage;

architecture Behavioral of findAverage is
signal intermediate : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
begin
process (EN, time_1, time_2, time_3)
variable sum : STD_LOGIC_VECTOR (15 downto 0);
    begin
        if EN = '1' then
            if (time_2 = X"0000") then
                intermediate <= time_1;
            elsif (time_3 = X"0000") then
                sum := std_logic_vector(unsigned(time_1) + unsigned(time_2));
                intermediate <= std_logic_vector(unsigned(sum) / "0010");
            else
                sum := std_logic_vector(unsigned(time_1) + unsigned(time_2) + unsigned(time_3));
                intermediate <= std_logic_vector(unsigned(sum) / "0011");                
            end if;
        end if;
    end process;
average <= intermediate;
end Behavioral;
