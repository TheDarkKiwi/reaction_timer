library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity finite_state_machine_tb is
end finite_state_machine_tb;

-----------------------------------------------------------------
-----------------------------------------------------------------
-- Run simulation for at least 110 us (scaled by 100000) i.e. 11 seconds
-----------------------------------------------------------------
-----------------------------------------------------------------

architecture Behavioral of finite_state_machine_tb is

    signal clk, rst :  STD_LOGIC := '0';
    signal BTNC :  STD_LOGIC := '0';
    signal COUNT_1,COUNT_2,COUNT_3,COUNT_4 : STD_LOGIC_VECTOR (3 downto 0):= (others =>'0');
    signal counter_en, counter_rst :  STD_LOGIC;
    signal message :  STD_LOGIC_VECTOR (31 downto 0) := (others =>'0');

begin

    -- FSM clock period 10ns (scaled from 1ms to speed up simulation)
    clk <= not clk after 5ns;

    -- Instantiate the finite_state_machine
    inst_FSM : entity work.finite_state_machine(Behavioral)
        port map(clk, rst, BTNC, COUNT_1,COUNT_2,COUNT_3,COUNT_4, counter_en, counter_rst, message);

    -- This process mimics the module 5 instantiations
    module5: process
    begin
        if counter_rst = '1' then
            COUNT_1 <= (others => '0');
            COUNT_2 <= (others => '0');
            COUNT_3 <= (others => '0');
            COUNT_4 <= (others => '0');
        else
            if counter_en = '1' then
                COUNT_1 <= std_logic_vector(unsigned(COUNT_1)+1);
                if COUNT_1 = "1001" then
                    COUNT_1 <= (others => '0');
                    COUNT_2 <= std_logic_vector(unsigned(COUNT_2)+1);
                end if;
                if (COUNT_2 = "1001" and COUNT_1 = "1001")then
                    COUNT_2 <= (others => '0');
                    COUNT_3 <= std_logic_vector(unsigned(COUNT_3)+1);
                end if;
                if (COUNT_3 = "1001" and COUNT_2 = "1001" and COUNT_1 = "1001") then
                    COUNT_3 <= (others => '0');
                    COUNT_4 <= std_logic_vector(unsigned(COUNT_4)+1);
                end if;
            end if;
        end if;
        wait for 10ns;
    end process;

    -- Apply rst and btnc stimulus
    stimulus: process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 80000 ns;
        BTNC <= '1';
        wait for 100 ns;
        BTNC <= '0';
        wait for 10000 ns;
        BTNC <= '1';
        wait for 100 ns;
        BTNC <= '0';
        wait;
    end process;

end Behavioral;
