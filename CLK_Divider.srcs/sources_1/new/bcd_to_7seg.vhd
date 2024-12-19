-------------------------------------------------------------------------------
-- Company: University of Canterbury
-- Engineer: Ciaran Moore, Jack Edwards, Rob Bass, Brent Smith
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity bcd_to_7seg is
 port ( bcd : in STD_LOGIC_VECTOR (3 downto 0);
 Display_Sel : in STD_LOGIC_VECTOR (2 downto 0);
 dp : in STD_LOGIC;
 seg : out STD_LOGIC_VECTOR (0 to 7));
end bcd_to_7seg;
architecture Behavioral of bcd_to_7seg is
begin
 process (bcd) is
 begin
 case (bcd) is
 when "0000" => seg(0 to 6) <= "1111110"; -- 0
 when "0001" => seg(0 to 6) <= "0110000"; -- 1
 when "0010" => seg(0 to 6) <= "1101101"; -- 2
 when "0011" => seg(0 to 6) <= "1111001"; -- 3
 when "0100" => seg(0 to 6) <= "0110011"; -- 4
 when "0101" => seg(0 to 6) <= "1011011"; -- 5 
 when "0110" => seg(0 to 6) <= "1011111"; -- 6 
 when "0111" => seg(0 to 6) <= "1110000"; -- 7 
 when "1000" => seg(0 to 6) <= "1111111"; -- 8
 when "1001" => seg(0 to 6) <= "1110011"; -- 9
 when "1010" => seg(0 to 6) <= "0000000"; -- blank
 when "1011" => seg(0 to 6) <= "1000000"; -- max
 when "1100" => seg(0 to 6) <= "0000001"; -- average
 when "1101" => seg(0 to 6) <= "0001000"; -- min
 when "1110" => 
    case (Display_Sel) is
    when "000" => seg(0 to 6) <= "0000101"; -- r
    when "001" => seg(0 to 6) <= "0011101"; -- o
    when "010" => seg(0 to 6) <= "0000101"; -- r
    when "011" => seg(0 to 6) <= "0000101"; -- r
    when "100" => seg(0 to 6) <= "1001111"; -- E
    when "101" => seg(0 to 6) <= "0000000"; -- blank
    when "110" => seg(0 to 6) <= "0000000"; -- blank
    when others => seg(0 to 6) <= "0000000"; -- blank
    end case;
 -- E = "1001111", r = "0000101", o = "0011101"
 --when "1111" => seg(0 to 6) <= 
 when others => NULL;
 end case;
end process; 
seg(7) <= dp;
end Behavioral;
