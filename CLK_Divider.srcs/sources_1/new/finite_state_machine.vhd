
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity finite_state_machine is
    Port ( clk, rst : in STD_LOGIC;
         BTNC : in STD_LOGIC;
         COUNT_1,COUNT_2,COUNT_3,COUNT_4 : in STD_LOGIC_VECTOR (3 downto 0);
         counter_en, counter_rst : out STD_LOGIC;   
         -- each nibble of message represent one character or digit on a 7 segment display.
         message : out STD_LOGIC_VECTOR (31 downto 0));
end finite_state_machine;

architecture Behavioral of finite_state_machine is

    type state_type is (warning_3, warning_2, warning_1, counting, printing);
    signal current_state, next_state : state_type := warning_3;
    constant T1: natural := 1000 ;
    signal t: natural range 0 to T1-1;

begin

    STATE_REGISTER: process (clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                current_state <= warning_3;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    OUTPUT_DECODE: process (current_state, COUNT_4, COUNT_3, COUNT_2, COUNT_1)
    begin
        case (current_state) is
            when warning_3 =>
                counter_en <= '0';
                counter_rst <= '1';
                message <= X"00000111"; -- to modify to show three dots
            when warning_2 =>
                counter_en <= '0';
                counter_rst <= '0';
                message <= X"00000011"; -- to modify to show two dots
            when warning_1 =>
                counter_en <= '0';
                counter_rst <= '0';
                message <= X"00000001"; -- to modify to show one dots
            when counting =>
                counter_en <= '1';
                counter_rst <= '0';
                message(31 downto 16) <= (others => '0') ;
                message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            when printing =>
                counter_en <= '0';
                counter_rst <= '0';
                message(31 downto 16) <= (others => '0') ;
                message(15 downto 0) <=  COUNT_4 & COUNT_3 & COUNT_2 & COUNT_1;
            when others =>
                counter_en <= '0';
                counter_rst <= '1';
                message <= X"00000000";
        end case;
    end process;

    NEXT_STATE_DECODE: process (current_state, t, BTNC)
    begin
        case (current_state) is
            when warning_3 =>
                if t = 999 then
                    next_state <= warning_2;
                else
                    next_state <= warning_3;
                end if;
            when warning_2 =>
                if t = 999 then
                    next_state <= warning_1;
                else
                    next_state <= warning_2;
                end if;
            when warning_1 =>
                if t = 999 then
                    next_state <= counting;
                else
                    next_state <= warning_1;
                end if;
            when counting =>
                if BTNC = '1' then
                    next_state <= printing;
                else
                    next_state <= counting;
                end if;
            when printing =>
                if (BTNC = '1' and t = 999) then
                    next_state <= warning_3;
                else
                    next_state <= printing;
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








