----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jack Edwards, Rob Bass, Brent Smith
-- 
-- Module Name: finite_state_machine - Behavioral
-- Project Name: Reaction Timer
-- Description: fsm which controls what state we are in and 
-- then relays what to display to the anodes and responds to button presses
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity finite_state_machine is
    Port ( clk, rst : in STD_LOGIC;
         BTNC, BTNU, BTNR, BTND, BTNL : in STD_LOGIC;
         aveMessage, slowMessage, fastMessage: in STD_LOGIC_VECTOR (15 downto 0);
         getAverage, getMin, getMax, getRand: out STD_LOGIC;
         BUFF_EN : out STD_LOGIC;
         COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);
         RANDOM_NUM : in STD_LOGIC_VECTOR (11 downto 0);
         counter_en, counter_rst : out STD_LOGIC;   
         -- each nibble of message represent one character or digit on a 7 segment display.
         message : out STD_LOGIC_VECTOR (31 downto 0));
end finite_state_machine;

architecture Behavioral of finite_state_machine is

    type state_type is (warning_3, warning_2, warning_1, counting, printing, error_state, displaySlow, displayAverage, displayFast);
    signal current_state, next_state, previous_state : state_type := printing;
    constant T1: natural := 1500 ;
    signal t: natural range 0 to T1-1;
    signal BUT_CHECK : STD_LOGIC;

begin
    
    --inst_sumButtons: entity  work.sumButtons(Behavioral)
    --port map (BTNC=>BTNC, BTNU=>BTNU, BTNR=>BTNR, BTND=>BTND, BTNL=>BTNL, MoreThanOneButtonPressed=>BUT_CHECK);
    
    STATE_REGISTER: process (clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                current_state <= printing;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    OUTPUT_DECODE: process (current_state, COUNT_4, COUNT_3, COUNT_2, COUNT_1, aveMessage, slowMessage, fastMessage)
    begin
        case (current_state) is
            when warning_3 =>
                counter_en <= '0';
                counter_rst <= '1';
                getRand <= '0';
                BUFF_EN <= '0';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '0'; 
                message <= X"AAAAAFFF"; -- to modify to show three dots
            when warning_2 =>
                counter_en <= '0';
                counter_rst <= '0';
                getRand <= '1';
                BUFF_EN <= '0';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '0'; 
                message <= X"AAAAAAFF"; -- to modify to show two dots
            when warning_1 =>
                counter_en <= '0';
                counter_rst <= '0';
                getRand <= '0';
                BUFF_EN <= '0';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '0'; 
                message <= X"AAAAAAAF"; -- to modify to show one dots
            when counting =>
                counter_en <= '1';
                counter_rst <= '0';
                getRand <= '0';
                BUFF_EN <= '0';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '0'; 
                message(31 downto 16) <= (others => '0') ;
                message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            when printing =>
                counter_en <= '0';
                counter_rst <= '0';
                getRand <= '0';
                message(31 downto 16) <= (others => '0') ;
                message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
                BUFF_EN <= '1';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '0'; 
            when error_state =>
                counter_en <= '0';
                counter_rst <= '0';
                getRand <= '0';
                BUFF_EN <= '0';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '0'; 
                message <= X"EEEEEEEE";
            when displaySlow =>
                BUFF_EN <= '0';
                counter_en <= '0';
                counter_rst <= '0';
                getRand <= '0';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '1'; 
                message <= X"BBBB" & slowMessage;
            when displayFast =>
                BUFF_EN <= '0';
                counter_en <= '0';
                counter_rst <= '0';
                getRand <= '0';
                getAverage <= '0';
                getMin <= '1';
                getMax <= '0';
                message <= X"DDDD" & fastMessage;
            when displayAverage =>
                BUFF_EN <= '0';
                counter_en <= '0';
                counter_rst <= '0';
                getRand <= '0';
                getAverage <= '1';
                getMin <= '0';
                getMax <= '0';                
                message <= X"CCCC" & aveMessage;                                
            when others =>
                counter_en <= '0';
                counter_rst <= '1';
                getRand <= '0';
                BUFF_EN <= '0';
                getAverage <= '0';
                getMin <= '0';
                getMax <= '0'; 
                message <= X"00000000";
        end case;
    end process;

    NEXT_STATE_DECODE: process (current_state, t, BTNC, BTND, BTNR, BTNU, BTNL, RANDOM_NUM)
    begin
        case (current_state) is
            when warning_3 =>
                previous_state <= warning_3;
                if (BTNC = '1') and t > 200 then
                    next_state <= error_state;
                elsif t > 998 then
                    next_state <= warning_2;
                else
                    next_state <= warning_3;
                end if;
            when warning_2 =>
                previous_state <= warning_2;
                if (BTNC = '1') then
                    next_state <= error_state;
                elsif t > 998 then
                    next_state <= warning_1;
                else
                    next_state <= warning_2;
                end if;
            when warning_1 =>
                previous_state <= warning_1;
                if (BTNC = '1') then
                    next_state <= error_state;
                elsif t > unsigned(random_num) then
                    next_state <= counting;
                else
                    next_state <= warning_1;
                end if;
            when counting =>
                previous_state <= counting;
                if BTNC = '1' then
                    next_state <= printing;
                else
                    next_state <= counting;
                end if;
            when printing =>
            previous_state <= printing;
                --if BUT_CHECK = '1' and t > 499 then
                  --  next_state <= error_state;
                if (BTNC = '1' and t > 998) then
                    next_state <= warning_3;
                elsif (BTNU = '1' and t > 499) then
                    next_state <= displaySlow;
                elsif (BTND = '1' and t > 499) then
                    next_state <= displayFast;
                elsif (BTNR = '1' and t > 499) then
                    next_state <= displayAverage;                                        
                else
                    next_state <= printing;
                end if;
            when error_state =>
                if t > 998 then
                    if previous_state = displaySlow then
                        next_state <= displaySlow;
                        previous_state <= error_state;
                    elsif previous_state = displayFast then
                        next_state <= displayFast;
                        previous_state <= error_state;
                    elsif previous_state = displayAverage then
                        next_state <= displayAverage;
                        previous_state <= error_state;                        
                    else
                        next_state <= warning_3;
                        previous_state <= error_state;
                    end if;
                else
                    next_state <= error_state;
                end if;
            when displaySlow =>
                previous_state <= displaySlow;
                --if BUT_CHECK = '1' and t > 249 then
                  --  next_state <= error_state;
                if BTNC = '1' and t > 499 then
                    next_state <= warning_3;
                elsif (BTND = '1' and t > 499) then
                    next_state <= displayFast;
                elsif (BTNR = '1' and t > 499) then
                    next_state <= displayAverage;                     
                else
                    next_state <= displaySlow;
                end if;
            when displayAverage =>
                previous_state <= displayAverage;
                --if BUT_CHECK = '1' and t > 249 then
                  --  next_state <= error_state;
                if BTNC = '1' and t > 499 then
                    next_state <= warning_3;
                elsif (BTND = '1' and t > 499) then
                    next_state <= displayFast;
                elsif (BTNU = '1' and t > 499) then
                    next_state <= displaySlow;                     
                else
                    next_state <= displayAverage;
                end if;
            when displayFast =>
                previous_state <= displayFast;
                --if BUT_CHECK = '1' and t > 249 then
                  --  next_state <= error_state;
                if BTNC = '1' and t > 499 then
                    next_state <= warning_3;
                elsif (BTNU = '1' and t > 499) then
                    next_state <= displaySlow;
                elsif (BTNR = '1' and t > 499) then
                    next_state <= displayAverage;                     
                else
                    next_state <= displayFast;
                end if;                                
            when others =>
                next_state <= current_state;
        end case;
    end process;

    TIMER: process (clk)
    begin
        if rising_edge(clk) then
            if current_state /= next_state then
                t <= 0;
            elsif t /= T1-1 then
                t <= t + 1;
            end if;
        end if;
    end process;

end Behavioral;








