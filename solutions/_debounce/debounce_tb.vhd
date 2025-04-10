library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

entity debounce_tb is
end entity debounce_tb;

architecture tb of debounce_tb is
    signal halt_sys_clock : boolean;

    signal   clk      : std_logic;
    signal   btn_in   : std_logic;
    signal   btn_out  : std_logic;
    signal   edge     : std_logic;
    signal   rise     : std_logic;
    signal   fall     : std_logic;
    constant TbPeriod : time := 10 ns;

    component debounce is
        port (
            clk     : in    std_logic;
            btn_in  : in    std_logic;
            btn_out : out   std_logic;
            edge    : out   std_logic;
            rise    : out   std_logic;
            fall    : out   std_logic
        );
    end component debounce;

begin
    dut : component debounce
        port map (
            clk     => clk,
            btn_in  => btn_in,
            btn_out => btn_out,
            edge    => edge,
            rise    => rise,
            fall    => fall
        );

    clockgenerator : process is
    begin

        while not halt_sys_clock loop
            clk <= not clk;
            wait for TbPeriod / 2.0;
        end loop;

        wait;

    end process clockgenerator;

    stimulus : process is

        constant NUM_NOISE_SAMPLES : positive := 10;
        constant SWITCH_TIME       : time     := 2 * 25 ms;
        variable seed1             : positive := 1;
        variable seed2             : positive := 1;
        variable rrand             : real;
        variable nrand             : natural;

        -- Performs noisy transition of sig from current value to final value.

        procedure noisytransition (
            signal sig : out std_logic;
            final      : std_logic
        ) is
        begin

            for n in 1 to NUM_NOISE_SAMPLES loop
                uniform(seed1, seed2, rrand);
                nrand := natural(round(rrand));

                if (nrand = 0) then
                    sig <= not final;
                else
                    sig <= final;
                end if;

                wait for TbPeriod / 5.0;
            end loop;

            sig <= final;
            wait for SWITCH_TIME;

        end procedure noisytransition;

    begin

        halt_sys_clock <= True;

        btn_in <= '0';
        wait for 3 ns;

        --
        -- Up Button
        -- Perform 4 noisy presses and releases.
        for n in 1 to 4 loop
            noisytransition(btn_in, '1');
            noisytransition(btn_in, '0');
        end loop;

        halt_sys_clock <= true;
        wait;

    end process stimulus;
end architecture tb;
