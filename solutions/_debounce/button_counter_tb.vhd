library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity button_counter_tb is
end entity button_counter_tb;

architecture v1 of button_counter_tb is

  constant clock_period    : time := 10 ns;
  constant debounce_period : time := 200 ns;

  signal halt_sys_clock : boolean := false;

  signal clock  : std_logic := '0';
  signal btn_up : std_logic;
  signal btn_dn : std_logic;
  signal leds   : std_logic_vector(15 downto 0);

  component button_counter is
    generic (
      clock_period    : time := 10 ns;
      debounce_period : time := 125 ms
    );
    port (
      clock  : in    std_logic;
      btn_up : in    std_logic;
      btn_dn : in    std_logic;
      leds   : out   std_logic_vector(15 downto 0)
    );
  end component button_counter;

begin

  clockgenerator : process is
  begin

    while not halt_sys_clock loop

      clock <= not clock;
      wait for clock_period / 2.0;

    end loop;

    wait;

  end process clockgenerator;

  stimulus : process is

    constant num_noise_samples : positive := 10;
    constant switch_time       : time     := 2 * debounce_period;
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

        wait for CLOCK_PERIOD / 5.0;

      end loop;

      sig <= final;
      wait for SWITCH_TIME;

    end procedure noisytransition;

  begin

    btn_up <= '0';
    btn_dn <= '0';
    wait for 3 ns;

    --
    -- Up Button
    --

    -- Perform 4 noisy presses and releases.
    for n in 1 to 4 loop

      noisytransition(btn_up, '1');
      noisytransition(btn_up, '0');

    end loop;

    --
    -- Down Button
    --

    -- Perform 1 noisy press and release.
    noisytransition(btn_dn, '1');
    noisytransition(btn_dn, '0');

    halt_sys_clock <= true;
    wait;

  end process stimulus;

  dut :
    component button_counter
    generic map (
      clock_period    => CLOCK_PERIOD,
      debounce_period => DEBOUNCE_PERIOD
    )
    port map (
      clock  => clock,
      btn_up => btn_up,
      btn_dn => btn_dn,
      leds   => leds
    );

end architecture v1;
