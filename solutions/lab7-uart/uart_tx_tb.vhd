-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 23.3.2025 17:32:11 UTC

library ieee;
  use ieee.std_logic_1164.all;

entity tb_uart_tx is
end entity tb_uart_tx;

architecture tb of tb_uart_tx is

  component uart_tx is
    port (
      clk      : in    std_logic;
      rst      : in    std_logic;
      baud_en  : in    std_logic;
      tx_start : in    std_logic;
      data_in  : in    std_logic_vector(7 downto 0);
      tx       : out   std_logic;
      tx_done  : out   std_logic
    );
  end component uart_tx;

  signal clk      : std_logic;
  signal rst      : std_logic;
  signal baud_en  : std_logic;
  signal tx_start : std_logic;
  signal data_in  : std_logic_vector(7 downto 0);
  signal tx       : std_logic;
  signal tx_done  : std_logic;

  constant tbperiod   : time      := 10 ns; -- EDIT Put right period here
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin

  dut : component uart_tx
    port map (
      clk      => clk,
      rst      => rst,
      baud_en  => baud_en,
      tx_start => tx_start,
      data_in  => data_in,
      tx       => tx,
      tx_done  => tx_done
    );

  -- Clock generation
  tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
             '0';

  -- EDIT: Check that clk is really your main clock signal
  clk <= tbclock;

  stimuli : process is
  begin

    -- EDIT Adapt initialization as needed
    tx_start <= '0';
    data_in  <= (others => '0');
    baud_en  <= '0';

    -- Reset generation
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    wait for 20 ns;

    baud_en <= '1';

    data_in  <= x"41";
    wait for 3 * tbperiod;
    tx_start <= '1';
    wait for 3 * tbperiod;
    tx_start <= '0';
    wait for 15 * tbperiod;

    data_in  <= x"43";
    wait for 3 * tbperiod;
    tx_start <= '1';
    wait for 3 * tbperiod;
    tx_start <= '0';
    wait for 15 * tbperiod;

    -- Stop the clock and hence terminate the simulation
    tbsimended <= '1';
    wait;

  end process stimuli;

end architecture tb;
