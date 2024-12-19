----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Create Date: 08.03.2024 13:09:05
-- Module Name: main - Behavioral
-- Project Name: Reaction Timer
-- Description: main file which interconnects all modules
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC, BTNU, BTNL, BTND, BTNR : in StD_lOgIc;
           CPU_RESETN : in sTd_LoGiC;
           CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
           AN : out std_logic_vector (7 downto 0));
end main;

architecture Behavioral of main is

signal REFRESH_CLK : STD_LOGIC;
signal TIMER_CLK : STD_LOGIC;
signal DIGIT_SEL : STD_LOGIC_VECTOR (2 downto 0);
signal CATHODES : STD_LOGIC_VECTOR (0 to 7);
signal BCD : STD_LOGIC_VECTOR (3 downto 0);
signal DEC_POINT : STD_LOGIC;
signal MESSAGE : STD_LOGIC_VECTOR (31 downto 0);
signal COUNTER_RST : STD_LOGIC;
signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal TICK_1,TICK_2,TICK_3,TICK_4 : STD_LOGIC;
signal COUNT_EN : STD_LOGIC;
signal RESET : STD_LOGIC;
signal BUFF_EN : STD_LOGIC;
signal PROCESSED_MESSAGE : STD_LOGIC_VECTOR (31 downto 0);
signal TIME_MESSAGE : STD_LOGIC_VECTOR (15 downto 0);
signal displaySelec : STD_LOGIC_VECTOR (1 downto 0);
signal message_1, message_2, message_3, time_1, time_2, time_3 : STD_LOGIC_VECTOR (15 downto 0);
signal getAverage, getMin, getMax: STD_LOGIC := '0';
signal aveMessage, slowMessage, fastMessage: STD_LOGIC_VECTOR (15 downto 0);
signal aveTime, slowTime, fastTime: STD_LOGIC_VECTOR (15 downto 0);
signal CONVERT_M_TO_T_EN, blank1, getRand, blank3 : std_logic;
signal randNum, blank2 : STD_LOGIC_VECTOR (11 downto 0);

begin
    RESET <= not CPU_RESETN;
    CA <= not CATHODES(0);
    CB <= not CATHODES(1);
    CC <= not CATHODES(2);
    CD <= not CATHODES(3);
    CE <= not CATHODES(4);
    CF <= not CATHODES(5);
    CG <= not CATHODES(6);
    DP <= not CATHODES(7);
    TIME_MESSAGE <= COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
    CONVERT_M_TO_T_EN <= getAverage or getMin or getMax;
    
    inst_refresh_clock: entity work.clock_divider(Behavioral)
    port map(CLK=>CLK100MHZ, UPPERBOUND=>(X"00186A0"), SLWCLK=>REFRESH_CLK, getRand=>blank1, randNum=>blank2);
--    port map(CLK=>CLK100MHZ, UPPERBOUND=>(X"00003E8"), SLWCLK=>REFRESH_CLK, getRand=>blank1, randNum=>blank2);

    inst_timer_clock: entity work.clock_divider(Behavioral)
--    port map(CLK=>CLK100MHZ, UPPERBOUND=>(X"0000010"), SLWCLK=>TIMER_CLK, getRand=>blank1, randNum=>blank2);
    port map(CLK=>CLK100MHZ, UPPERBOUND=>(X"000c350"), SLWCLK=>TIMER_CLK, getRand=>blank1, randNum=>blank2);

    inst_rand_num_generator: entity work.clock_divider(Behavioral)
    port map(CLK=>CLK100MHZ, UPPERBOUND=>(X"000001F"), SLWCLK=>blank3, getRand=>getRand, randNum=>randNum);
--    port map(CLK=>CLK100MHZ, UPPERBOUND=>(X"0000419"), SLWCLK=>blank3, getRand=>getRand, randNum=>randNum);

    inst_display_selector: entity work.display_selector(Behavioral)
    port map (DISPLAY_CLK=>REFRESH_CLK, SELEC=>DIGIT_SEL);
        
    inst_anode_decoder: entity work.decoder(Behavioral)
    port map (DISPLAY_SELECTED=>DIGIT_SEL, ANODE=>AN);
            
    inst_bcd_to_7seg: entity work.bcd_to_7seg(Behavioral)
    port map (bcd=>BCD, Display_Sel=>DIGIT_SEL, dp=>DEC_POINT, seg=>CATHODES);
    
    inst_count_1: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TIMER_CLK,EN=>COUNT_EN,COUNT=>COUNT_1,RESET=>COUNTER_RST,TICK=>TICK_1);
    
    inst_count_2: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TICK_1,EN=>COUNT_EN,COUNT=>COUNT_2,RESET=>COUNTER_RST,TICK=>TICK_2);
    
    inst_count_3: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TICK_2,EN=>COUNT_EN,COUNT=>COUNT_3,RESET=>COUNTER_RST,TICK=>TICK_3);
    
    inst_count_4: entity  work.timer_counter(Behavioral)
    port map (INCREMENT=>TICK_3 ,EN=>COUNT_EN,COUNT=>COUNT_4,RESET=>COUNTER_RST,TICK=>TICK_4);
    
    inst_mux: entity  work.mux(Behavioral)
    port map (Display_Sel=>DIGIT_SEL, Message=>MESSAGE, BCD=>BCD, DP=>DEC_POINT);
    
    inst_FSM : entity work.finite_state_machine(Behavioral)
    port map(clk=>TIMER_CLK, rst=>RESET, BUFF_EN=>BUFF_EN, getAverage=>getAverage, getMin=>getMin, getMax=>getMax, getRand=>getRand,
    BTNC=>BTNC, BTNU=>BTNU, BTNR=>BTNR, BTND=>BTND, BTNL=>BTNL, 
    COUNT_1=>COUNT_1,COUNT_2=>COUNT_2,COUNT_3=>COUNT_3,COUNT_4=>COUNT_4, RANDOM_NUM=>randNum,
    counter_en=>COUNT_EN, counter_rst=>COUNTER_RST, message=>MESSAGE, aveMessage=>aveMESSAGE, slowMessage=>slowMessage, fastMessage=>fastMessage);
  
    inst_circ: entity  work.circ_buffer(Behavioral)
    port map (newVal=>TIME_MESSAGE, EN=>BUFF_EN, CLEAR=>BTNL,
        message_1=>message_1, message_2=>message_2, message_3=>message_3);
    
    convert_time_1: entity  work.convertMessagetoTime(Behavioral)
    port map (Message=>message_1, timeout=>time_1, EN=>CONVERT_M_TO_T_EN);
    
    convert_time_2: entity  work.convertMessagetoTime(Behavioral)
    port map (Message=>message_2, timeout=>time_2, EN=>CONVERT_M_TO_T_EN);
    
    convert_time_3: entity  work.convertMessagetoTime(Behavioral)
    port map (Message=>message_3, timeout=>time_3, EN=>CONVERT_M_TO_T_EN);
    
    convert_aveMessage: entity  work.convertTimetoMessage(Behavioral)
    port map (Message=>aveMessage, EN=>getAverage, timein=>aveTime);
    
    convert_minMessage: entity  work.convertTimetoMessage(Behavioral)
    port map (Message=>fastMessage, EN=>getMin, timein=>fastTime);

    convert_maxMessage: entity  work.convertTimetoMessage(Behavioral)
    port map (Message=>slowMessage, EN=>getMax, timein=>slowTime);
    
    inst_findAverage: entity  work.findAverage(Behavioral)
    port map (time_1=>time_1, time_2=>time_2, time_3=>time_3, EN=>getAverage, average=>aveTime);
    
    inst_findMin: entity  work.findMin(Behavioral)
    port map (time_1=>time_1, time_2=>time_2, time_3=>time_3, EN=>getMin, min=>fastTime);
    
    inst_findMax: entity  work.findMax(Behavioral)
    port map (time_1=>time_1, time_2=>time_2, time_3=>time_3, EN=>getMax, max=>slowTime);
    
end Behavioral;
