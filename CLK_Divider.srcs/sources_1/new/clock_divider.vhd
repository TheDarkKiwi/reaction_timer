----------------------------------------------------------------------------------
-- Company: Rob Bass Inc.
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Module Name: clock_divider - Behavioral
-- Project Name: Reaction Timer
-- Description: a clock divider which also generates a rand number when required
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port ( CLK : in STD_LOGIC;
           UPPERBOUND : in STD_LOGIC_VECTOR (27 downto 0);
           getRand : in STD_LOGIC;
           SLWCLK : out STD_LOGIC;
           randNum : out STD_LOGIC_VECTOR (11 downto 0));
end clock_divider;

architecture Behavioral of clock_divider is
    signal count: std_logic_vector (27 downto 0) := (others => '0');
    signal dummy: std_logic := '1';
begin
    
    SLWCLK <= dummy;
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            if count = UPPERBOUND then   --5F5E100 is 100 mil
                count <= (others => '0');
                dummy <= not dummy;
            else
                count <= std_logic_vector(unsigned(count) + 1);
            end if;
        end if;
    end process;
    
    process (getRand, count)
    begin
    if rising_edge(getRand) then
        randNum <= STD_LOGIC_VECTOR(unsigned(count(5 downto  0)) & "00000" + (X"100"));
    end if;
    end process;
    
end Behavioral;
