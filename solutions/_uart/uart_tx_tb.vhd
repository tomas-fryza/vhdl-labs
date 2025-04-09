-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 09 Apr 2025 14:20:02 GMT
-- Request id : cfwk-fed377c2-67f6821292f8f

library ieee;
use ieee.std_logic_1164.all;

entity tb_uart_tx is
end tb_uart_tx;

architecture tb of tb_uart_tx is
    component uart_tx
        generic (
            CLK_FREQ : integer;
            BAUDRATE : integer
        );
            port (clk      : in std_logic;
              rst      : in std_logic;
              data_in  : in std_logic_vector (7 downto 0);
              tx_start : in std_logic;
              tx       : out std_logic;
              tx_done  : out std_logic);
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal data_in  : std_logic_vector (7 downto 0);
    signal tx_start : std_logic;
    signal tx       : std_logic;
    signal tx_done  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : uart_tx
    generic map(CLK_FREQ => 100_000_000,
                BAUDRATE => 15_600_000)  -- For simulation only
    port map (clk      => clk,
              rst      => rst,
              data_in  => data_in,
              tx_start => tx_start,
              tx       => tx,
              tx_done  => tx_done);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        -- tx_start <= '0';
        -- data_in  <= (others => '0');

        -- Reset generation
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        data_in  <= b"0101_0101";
        wait for 3 * tbperiod;
        tx_start <= '1';
        wait for 1 * tbperiod;
        tx_start <= '0';
        wait for 100 * tbperiod;

        data_in  <= x"43";
        wait for 3 * tbperiod;
        tx_start <= '1';
        wait for 1 * tbperiod;
        tx_start <= '0';
        wait for 100 * tbperiod;

        -- Stop the clock and hence terminate the simulation
        tbsimended <= '1';
        wait;
    end process;

end tb;
