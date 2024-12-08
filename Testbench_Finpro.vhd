
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Testbench_Smarthome

 is
end Testbench_Smarthome;

architecture behavior of Testbench_Smarthome is
    -- Deklarasi sinyal untuk setiap modul
    signal clk           : STD_LOGIC := '0';
    signal reset         : STD_LOGIC := '0';
    signal temperature   : STD_LOGIC_VECTOR(7 downto 0);
    signal light_sensor  : STD_LOGIC_VECTOR(7 downto 0);
    signal fan_signal    : STD_LOGIC;
    signal light_signal  : STD_LOGIC;
    signal alarm_signal  : STD_LOGIC;
    signal current_state : String (1 to 16);
    signal alarm_active  : STD_LOGIC;
    signal display       : STD_LOGIC_VECTOR(6 downto 0);
begin
    -- Instantiate each module
    uut_device_control: entity work.Device_Control_Module
        port map ( clk => clk, reset => reset, temperature => temperature,
                   light_sensor => light_sensor, fan_control => fan_signal,
                   light_control => light_signal, alarm_control => alarm_signal );

    uut_state_monitoring: entity work.State_Monitoring_System
        port map ( clk => clk, reset => reset, fan_control => fan_signal,
                   light_control => light_signal, alarm_control => alarm_signal,
                   current_state => current_state );

    uut_environment_monitoring: entity work.Environment_Monitoring_Module
        port map ( temperature => temperature, light_sensor => light_sensor,
                   fan_signal => fan_signal, light_signal => light_signal );

    uut_automation: entity work.Automation_Module
        port map ( clk => clk, reset => reset, temperature => temperature,
                   fan_signal => fan_signal );

    uut_alarm: entity work.Alarm_System
        port map ( clk => clk, reset => reset, alarm_trigger => alarm_signal,
                   alarm_active => alarm_active );

    uut_display: entity work.Display_System
        port map ( clk => clk, reset => reset, fan_state => fan_signal,
                   light_state => light_signal, display => display );

    -- Clock generation
    clk_process: process
    begin
        clk <= not clk after 10 ns;
        wait for 10 ns;
    end process;

    -- Stimulus generation
    stimulus_process: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Simulate different sensor values
        temperature <= "00111100"; -- 60�C
        light_sensor <= "00110000"; -- Low light
        wait for 50 ns;

        temperature <= "00011000"; -- 25�C
        light_sensor <= "11000000"; -- Bright light
        wait for 50 ns;

        temperature <= "01000000"; -- 40�C
        light_sensor <= "00000000"; -- Dark environment
        wait for 50 ns;

        -- Finish simulation
        wait;
    end process;
end behavior;
