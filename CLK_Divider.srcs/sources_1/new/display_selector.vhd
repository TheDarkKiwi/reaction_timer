----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.03.2024 14:17:40
-- Design Name: 
-- Module Name: display_selector - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_selector is
    Port ( CLK : in STD_LOGIC;
           SELEC : out STD_LOGIC_VECTOR (2 downto 0));
end display_selector;

architecture Behavioral of display_selector is

signal count: std_logic_vector (2 downto 0) := (others => '0');
begin

    SELEC <= count;
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            count <= std_logic_vector(unsigned(count) + 1);
        end if;
    end process;


end Behavioral;
