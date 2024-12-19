----------------------------------------------------------------------------------
-- Engineer: Romain Arnal
-- Create Date: 28.02.2024 13:36:09
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity comparator is
    Port ( CLK : in STD_LOGIC;
         VALUE_1 : in STD_LOGIC_VECTOR (3 downto 0);
         VALUE_2 : in STD_LOGIC_VECTOR (3 downto 0);
         EQUAL : out STD_LOGIC;
         GREATER : out STD_LOGIC;
         SMALLER : out STD_LOGIC);
end comparator;

architecture Behavioral of comparator is

begin

    -- Combinational comparator
  --  GREATER <= '1' when (VALUE_1 > VALUE_2) else '0';
  --  EQUAL <= '1'   when (VALUE_1 = VALUE_2) else '0';
  --  SMALLER <= '1' when (VALUE_1 < VALUE_2) else '0';

    -- Synchronous comparator
    compa: process (CLK, VALUE_1, VALUE_2)
    begin
        if rising_edge(CLK) then
            GREATER <= '0';
            SMALLER <= '0';
            EQUAL <= '0';
            if (VALUE_1 < VALUE_2) then
                SMALLER <= '1';
            elsif (VALUE_1 > VALUE_2) then
                GREATER <= '1';
            else
                EQUAL <= '1';
            end if;
        end if;
    end process;


end Behavioral;
