----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2024 13:09:05
-- Design Name: 
-- Module Name: main - Behavioral
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

entity messy is

end messy;

architecture Behavioral of messy is

signal BTNC : StD_lOgIc := '0';
signal CA, CB, CC, CD, CE, CF, CG, DP : std_logic;
signal AN : std_logic_vector (7 downto 0);
signal REFRESH_CLK : STD_LOGIC;
signal TIMER_CLK : STD_LOGIC;
signal DIGIT_SEL : STD_LOGIC_VECTOR (2 downto 0);
signal CATHODES : STD_LOGIC_VECTOR (0 to 7);
signal BCD : STD_LOGIC_VECTOR (3 downto 0);
signal DEC_POINT : STD_LOGIC;
signal MESSAGE : STD_LOGIC_VECTOR (31 downto 0);
signal COUNTER_RST : STD_LOGIC;
signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0);
signal TICK_1,TICK_2,TICK_3,TICK_4 : STD_LOGIC;
signal COUNT_EN : STD_LOGIC;

signal CPU_RESETN : sTd_LoGiC := '0';
signal clk : STD_LOGIC := '0';


begin

    clk <= not clk after 5ns;
    BTNC <= not BTNC after 10ms;
    
    CA <= not CATHODES(0);
    CB <= not CATHODES(1);
    CC <= not CATHODES(2);
    CD <= not CATHODES(3);
    CE <= not CATHODES(4);
    CF <= not CATHODES(5);
    CG <= not CATHODES(6);
    DP <= not CATHODES(7);
    
    inst_refresh_clock: entity work.clock_divider(Behavioral)
    port map(CLK=>CLK, UPPERBOUND=>(X"00006A0"), SLWCLK=>REFRESH_CLK);
    
    inst_timer_clock: entity work.clock_divider(Behavioral)
    port map(CLK=>CLK, UPPERBOUND=>(X"0000050"), SLWCLK=>TIMER_CLK);
    
    inst_display_selector: entity work.display_selector(Behavioral)
    port map (DISPLAY_CLK=>REFRESH_CLK, SELEC=>DIGIT_SEL);
        
    inst_anode_decoder: entity work.decoder(Behavioral)
    port map (DISPLAY_SELECTED=>DIGIT_SEL, ANODE=>AN);
            
    inst_bcd_to_7seg: entity work.bcd_to_7seg(Behavioral)
    port map (bcd=>BCD, dp=>DEC_POINT, seg=>CATHODES);
    
    inst_count_1: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TIMER_CLK,EN=>COUNT_EN,COUNT=>COUNT_1,RESET=>COUNTER_RST,TICK=>TICK_1);
    
    inst_count_2: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TICK_1,EN=>COUNT_EN,COUNT=>COUNT_2,RESET=>COUNTER_RST,TICK=>TICK_2);
    
    inst_count_3: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TICK_2,EN=>COUNT_EN,COUNT=>COUNT_3,RESET=>COUNTER_RST,TICK=>TICK_3);
    
    inst_count_4: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TICK_3,EN=>COUNT_EN,COUNT=>COUNT_4,RESET=>COUNTER_RST,TICK=>TICK_4);
    
    inst_mux: entity  work.mux(Behavioral)
    port map (Display_Sel=>DIGIT_SEL, Message=>MESSAGE, BCD=>BCD, DP=>DEC_POINT);
    
    inst_FSM : entity work.finite_state_machine(Behavioral)
    port map(clk=>TIMER_CLK, rst=>CPU_RESETN, BTNC=>BTNC, COUNT_1=>COUNT_1,COUNT_2=>COUNT_2,COUNT_3=>COUNT_3,COUNT_4=>COUNT_4, counter_en=>COUNT_EN, counter_rst=>COUNTER_RST, message=>MESSAGE);
    
end Behavioral;
