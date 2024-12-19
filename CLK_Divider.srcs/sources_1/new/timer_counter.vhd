----------------------------------------------------------------------------------
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 08.03.2024 11:51:25
-- Module Name: timer_counter - Behavioral
-- Project Name: Reaction Timer
-- Description: a decade timer counts from 0 to 9
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- inputs and outputs
entity timer_counter is
    Port ( EN : in STD_LOGIC;
           RESET : in STD_LOGIC;
           INCREMENT : in STD_LOGIC;
           COUNT : out STD_LOGIC_VECTOR (3 downto 0);
           TICK : out STD_LOGIC);
end timer_counter;

architecture Behavioral of timer_counter is
    -- dummy signal for an internal version of the count output
    signal dummy : std_logic_vector (3 downto 0);
begin
    decade : process (RESET, EN, INCREMENT) is
    begin 
    -- check for resetting the counter
    if RESET = '1' then
        dummy <= (others => '0');
        TICK <= '0';
    elsif rising_edge(INCREMENT) then
        -- checks timer is enabled then adds 1 and resets TICK to zero
        if EN = '1' then    
            dummy <= std_logic_vector(unsigned(dummy) + 1);
            TICK <= '0';
            -- checks if counter is 9 then puts back to zero
            -- then sets the TICK output to 1
            if dummy = "1001" then
                dummy <= "0000";
                TICK <= '1';
            end if;
        end if; 
        end if;    
    end process decade;
    count <= dummy;
end Behavioral;
