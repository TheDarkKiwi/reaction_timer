----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2024 14:05:19
-- Design Name: 
-- Module Name: main_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_tb is
end main_tb;

architecture Behavioral of main_tb is

signal BTNC, BTNU, BTND, BTNL, BTNR : StD_lOgIc := '0';
signal AN : std_logic_vector (7 downto 0);
signal CA, CB, CC, CD, CE, CF, CG, DP : std_logic;
signal CPU_RESETN : sTd_LoGiC := '0';
signal CLK100MHZ : STD_LOGIC := '0';

begin

    CLK100MHZ <= not CLK100MHZ after 500ps;
    --BTNC <= not BTNC after 3ms;

    inst_main: entity work.main(Behavioral)
    port map(CLK100MHZ=>CLK100MHZ, BTNC=>BTNC, BTNU=>BTNU, BTND=>BTND, BTNL=>BTNL, BTNR=>BTNR, CPU_RESETN=> '1', AN=>AN, CA=>CA, CB=>CB, CC=>CC, CD=>CD, CE=>CE, CF=>CF, CG=>CG, DP=>DP);
    
end Behavioral;
