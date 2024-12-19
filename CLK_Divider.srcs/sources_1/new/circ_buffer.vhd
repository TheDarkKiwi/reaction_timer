----------------------------------------------------------------------------------
-- Company: Rob Bass Inc.
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 22.03.2024 14:18:50
-- Module Name: circ_buffer - Behavioral
-- Project Name: Reaction Timer
-- Description: a circular buffer storing reaction time values
-- techincally more a shift register then a circular buffer but eh
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity circ_buffer is
    Port ( newVal : in STD_LOGIC_VECTOR (15 downto 0);
           EN, CLEAR : in STD_LOGIC;
           message_1, message_2, message_3 : inout STD_LOGIC_VECTOR (15 downto 0) := (others => '0'));
end circ_buffer;

architecture Behavioral of circ_buffer is

begin

update_buffer: process (EN, newVal)
begin
if CLEAR = '1' then
    message_3 <= (others => '0');
    message_2 <= (others => '0');
    message_1 <= (others => '0');
elsif rising_edge(EN) then
    message_3 <= message_2;
    message_2 <= message_1;
    message_1 <= newVal;   
end if;
end process;

end Behavioral;
