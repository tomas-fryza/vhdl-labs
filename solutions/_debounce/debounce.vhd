-- https://stackoverflow.com/questions/61630181/vhdl-button-debouncing-or-not-as-the-case-may-be

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity debounce is
    generic (
        CLOCK_PERIOD    : time := 10 ns;
        DEBOUNCE_PERIOD : time := 25 ms
    );
    port (
        clock  : in    std_logic;
        input  : in    std_logic; -- Asynchronous and noisy input
        output : out   std_logic; -- Synchronised, debounced and filtered output
        edge   : out   std_logic;
        rise   : out   std_logic;
        fall   : out   std_logic
    );
end entity debounce;

architecture v1 of debounce is
    -- Number of bits in the synchronisation buffer (2 minimum)
    constant SYNC_BITS   : positive := 2;
    signal   sync_buffer : std_logic_vector(SYNC_BITS - 1 downto 0);
    alias    sync_input  : std_logic is sync_buffer(SYNC_BITS - 1);

    constant MAX_COUNT  : natural := DEBOUNCE_PERIOD / CLOCK_PERIOD;
    signal   counter    : natural range 0 to MAX_COUNT;
    signal   sig_output : std_logic;

begin
    p_debounce : process (clock) is
        variable edge_internal : std_logic;
        variable rise_internal : std_logic;
        variable fall_internal : std_logic;

    begin
        if rising_edge(clock) then
            -- Synchronise the asynchronous input
            -- MSB of sync_buffer is the synchronised input
            sync_buffer <= sync_buffer(SYNC_BITS - 2 downto 0) & input;

            edge <= '0';
            rise <= '0';
            fall <= '0';

            -- If successfully debounced, notify what happened, and reset the counter
            if (counter = MAX_COUNT - 1) then
                sig_output <= sync_input;
                edge       <= edge_internal;
                rise       <= rise_internal;
                fall       <= fall_internal;
                counter    <= 0;

            elsif (sync_input /= sig_output) then
                counter <= counter + 1;

            else
                counter <= 0;
            end if;
        end if;

        -- Edge detection
        edge_internal := sync_input xor sig_output;
        rise_internal := sync_input and not sig_output;
        fall_internal := not sync_input and sig_output;
        output        <= sig_output;

    end process p_debounce;

end architecture v1;
