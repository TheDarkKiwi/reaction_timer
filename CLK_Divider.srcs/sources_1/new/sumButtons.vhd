----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2024 15:37:47
-- Design Name: 
-- Module Name: sumButtons - Behavioral
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

entity sumButtons is
    Port ( BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           MoreThanOneButtonPressed : out STD_LOGIC);
end sumButtons;

architecture Behavioral of sumButtons is

signal sum : std_logic_vector(4 downto 0);

begin
process (BTNC, BTNU, BTNR, BTND, BTNL)
begin
sum <= (BTNC & BTNU & (BTNR) & (BTND) & (BTNL));
if (sum /= "01" or sum /= "00") then
MoreThanOneButtonPressed <= '1';
else
MoreThanOneButtonPressed <= '0';
end if;
end process;
end Behavioral;
