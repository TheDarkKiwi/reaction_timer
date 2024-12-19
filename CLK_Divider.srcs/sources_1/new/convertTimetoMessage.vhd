----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 26.04.2024 13:57:06
-- Module Name: convertTimetoMessage - Behavioral
-- Project Name: Reaction Timer
-- Description: converts 4 numbers representing time in seperated digits into a single number
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity convertTimetoMessage is
    Port ( TimeIn : in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
           EN : in STD_LOGIC;
           Message : out STD_LOGIC_VECTOR (15 downto 0) := (others => '0'));
end convertTimetoMessage;

architecture Behavioral of convertTimetoMessage is
signal digit_1, digit_2, digit_3, digit_4 : STD_LOGIC_VECTOR (3 downto 0)  := (others => '0');


begin
    convertToMessage : process (TimeIn, EN, digit_1, digit_2, digit_3, digit_4)
    variable intermediate : STD_LOGIC_VECTOR (15 downto 0);
    begin
        if EN = '1' then
            intermediate := (std_logic_vector(unsigned(TIMEIN) / X"3E8"));
            digit_1 <= intermediate (3 downto 0);
            intermediate := std_logic_vector((unsigned(TIMEIN)-(unsigned(digit_1) * X"3E8")) / X"64");
            digit_2 <= intermediate (3 downto 0);
            intermediate := std_logic_vector((unsigned(TIMEIN)-(unsigned(digit_1) * X"3E8")-(unsigned(digit_2) * X"64")) / X"A");
            digit_3 <= intermediate (3 downto 0);
            intermediate := std_logic_vector((unsigned(TIMEIN)-(unsigned(digit_1) * X"3E8")-(unsigned(digit_2) * X"64")-(unsigned(digit_3) * X"A")));
            digit_4 <= intermediate (3 downto 0);
            message <= digit_1 & digit_2 & digit_3 & digit_4;
        end if;
    end process convertToMessage;
end Behavioral;
