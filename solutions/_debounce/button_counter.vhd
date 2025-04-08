library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity button_counter is
  generic (
    clock_period    : time := 10 ns;
    debounce_period : time := 125 ms
  );
  port (
    clock  : in    std_logic;
    btn_up : in    std_logic;
    btn_dn : in    std_logic;
    led_up : out   std_logic;
    led_dn : out   std_logic;
    leds   : out   std_logic_vector(15 downto 0)
  );
end entity button_counter;

architecture v1 of button_counter is

  signal count_up : std_logic;
  signal count_dn : std_logic;

  component debounce is
    generic (
      clock_period    : time := 10 ns;
      debounce_period : time := 125 ms
    );
    port (
      clock  : in    std_logic;
      input  : in    std_logic;
      output : out   std_logic;
      edge   : out   std_logic;
      rise   : out   std_logic;
      fall   : out   std_logic
    );
  end component debounce;

begin

  debounce_btn_up :
    component debounce
    generic map (
      clock_period    => clock_period,
      debounce_period => debounce_period
    )
    port map (
      clock  => clock,
      input  => btn_up,
      output => led_up,
      edge   => open,
      rise   => count_up,
      fall   => open
    );

  debounce_btn_dn :
    component debounce
    generic map (
      clock_period    => clock_period,
      debounce_period => debounce_period
    )
    port map (
      clock  => clock,
      input  => btn_dn,
      output => led_dn,
      edge   => open,
      rise   => count_dn,
      fall   => open
    );

  process (clock) is

    variable counter : natural range 0 to 2 ** leds'length - 1 := 0;  -- Specify the range to reduce number of bits that are synthesised.

  begin

    if rising_edge(clock) then
      if (count_up = '1') then
        counter := counter + 1;
      elsif (count_dn = '1') then
        counter := counter - 1;
      end if;
      leds <= std_logic_vector(to_unsigned(counter, leds'length));
    end if;

  end process;

end architecture v1;
