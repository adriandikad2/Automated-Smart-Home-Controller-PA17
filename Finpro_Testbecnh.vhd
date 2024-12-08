library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Testbench_Smart_Home_Controller is
end Testbench_Smart_Home_Controller;

architecture behavior of Testbench_Smart_Home_Controller is

    -- Deklarasi sinyal untuk modul Smart Home Controller
    signal clk           : STD_LOGIC := '0';
    signal reset         : STD_LOGIC := '0';
    signal temperature   : STD_LOGIC_VECTOR(7 downto 0) := "00000000";  -- Default value
    signal light_sensor  : STD_LOGIC_VECTOR(7 downto 0) := "00000000";  -- Default value
    signal fan_signal    : STD_LOGIC;
    signal light_signal  : STD_LOGIC;
    signal alarm_signal  : STD_LOGIC;
    signal display       : STD_LOGIC_VECTOR(6 downto 0);
    signal error_flag    : STD_LOGIC := '0';

    -- Instantiate the Smart Home Controller
    uut: entity work.Smart_Home_Controller
        port map ( clk           => clk,
                   reset         => reset,
                   temperature   => temperature,
                   light_sensor  => light_sensor,
                   fan_control   => fan_signal,
                   light_control => light_signal,
                   alarm_control => alarm_signal,
                   display       => display );

begin

    -- Clock generation
    clk_process: process
    begin
        clk <= not clk after 10 ns;
        wait for 10 ns;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Simulate normal conditions
        temperature <= "00111100"; -- 60�C
        light_sensor <= "00110000"; -- Low light
        wait for 50 ns;
        assert fan_signal = '1' report "Error: Fan should be ON" severity error;
        assert light_signal = '1' report "Error: Light should be ON" severity error;

        -- Simulate light and temperature change
        temperature <= "00011000"; -- 25�C
        light_sensor <= "11000000"; -- Bright light
        wait for 50 ns;
        assert fan_signal = '0' report "Error: Fan should be OFF" severity error;
        assert light_signal = '0' report "Error: Light should be OFF" severity error;

        -- Simulate high temperature (alarm should activate)
        temperature <= "01000000"; -- 40�C
        light_sensor <= "00000000"; -- Dark environment
        wait for 50 ns;
        assert alarm_signal = '1' report "Error: Alarm should be ON due to high temperature" severity error;

        -- Finish simulation
        wait;
    end process;

    -- Error flag handling
    error_check: process
    begin
        -- Set error_flag if any assertion fails
        if error_flag = '1' then
            report "Test failed due to assertion error" severity failure;
        end if;
        wait for 1 ns;
    end process;

end behavior;
