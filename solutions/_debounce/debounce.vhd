-- https://stackoverflow.com/questions/61630181/vhdl-button-debouncing-or-not-as-the-case-may-be

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity debounce is
  generic (
    clock_period    : time     := 10 ns;
    debounce_period : time     := 125 ms; -- 1/8th second as a rule of thumb for a tactile button/switch.
    sync_bits       : positive := 2       -- Number of bits in the synchronisation buffer (2 minimum).
  );
  port (
    clock  : in    std_logic;
    input  : in    std_logic;        -- Asynchronous and noisy input.
    output : out   std_logic := '0'; -- Synchronised, debounced and filtered output.
    edge   : out   std_logic := '0'; -- Goes high for 1 clock cycle on either edge of synchronised and debounced input.
    rise   : out   std_logic := '0'; -- Goes high for 1 clock cycle on the rising edge of synchronised and debounced input.
    fall   : out   std_logic := '0'  -- Goes high for 1 clock cycle on the falling edge of synchronised and debounced input.
  );
end entity debounce;

architecture v1 of debounce is

  constant sync_buffer_msb : positive                                   := sync_bits - 1;
  signal   sync_buffer     : std_logic_vector(sync_buffer_msb downto 0) := (others => '0'); -- N-bit synchronisation buffer (2 bits minimum).
  alias    sync_input      : std_logic is sync_buffer(sync_buffer_msb);                     -- The synchronised input is the MSB of the synchronisation buffer.

  constant max_count  : natural                      := debounce_period / clock_period;
  signal   counter    : natural range 0 to max_count := 0; -- Specify the range to reduce number of bits that are synthesised.
  signal   sig_output : std_logic;

begin

  assert SYNC_BITS >= 2
    report "Need a minimum of 2 bits in the synchronisation buffer." severity error;

  process (clock) is

    variable edge_internal : std_logic := '0';
    variable rise_internal : std_logic := '0';
    variable fall_internal : std_logic := '0';

  begin

    if rising_edge(clock) then
      -- Synchronise the asynchronous input.
      -- MSB of sync_buffer is the synchronised input.
      sync_buffer <= sync_buffer(sync_buffer_msb - 1 downto 0) & input;

      edge <= '0';                                                         -- Goes high for 1 clock cycle on either edge.
      rise <= '0';                                                         -- Goes high for 1 clock cycle on the rising edge.
      fall <= '0';                                                         -- Goes high for 1 clock cycle on the falling edge.

      if (counter = max_count - 1) then                                    -- If successfully debounced, notify what happened, and reset the counter.
        sig_output <= sync_input;
        edge       <= edge_internal;                                       -- Goes high for 1 clock cycle on either edge.
        rise       <= rise_internal;                                       -- Goes high for 1 clock cycle on the rising edge.
        fall       <= fall_internal;                                       -- Goes high for 1 clock cycle on the falling edge.
        counter    <= 0;
      elsif (sync_input /= sig_output) then
        counter <= counter + 1;
      else
        counter <= 0;
      end if;
    end if;

    -- Edge detection.
    edge_internal := sync_input xor sig_output;
    rise_internal := sync_input and not sig_output;
    fall_internal := not sync_input and sig_output;
    output        <= sig_output;

  end process;

end architecture v1;
