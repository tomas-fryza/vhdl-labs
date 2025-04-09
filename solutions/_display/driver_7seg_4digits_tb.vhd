----------------------------------------------------------
--
-- Template for 4-digit 7-segment display driver testbench.
-- Nexys A7-50T, xc7a50ticsg324-1L
-- TerosHDL, Vivado v2020.2, EDA Playground
--
-- Copyright (c) 2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

----------------------------------------------------------
-- Entity declaration for testbench
----------------------------------------------------------

entity tb_driver_7seg_4digits is
  -- Entity of testbench is always empty
end entity tb_driver_7seg_4digits;

----------------------------------------------------------
-- Architecture body for testbench
----------------------------------------------------------

architecture testbench of tb_driver_7seg_4digits is

  -- Testbench local constants
  constant c_CLK_100MHZ_PERIOD : time := 10 ns;

  -- Testench local signals
  signal sig_clk_100mhz : std_logic;
  signal sig_rst        : std_logic;
  signal sig_data0      : std_logic_vector(3 downto 0);
  signal sig_data1      : std_logic_vector(3 downto 0);
  signal sig_data2      : std_logic_vector(3 downto 0);
  signal sig_data3      : std_logic_vector(3 downto 0);
  signal sig_dp_vect    : std_logic_vector(3 downto 0);
  signal sig_dp         : std_logic;
  signal sig_seg        : std_logic_vector(6 downto 0);
  signal sig_dig        : std_logic_vector(3 downto 0);

begin

  -- Connecting testbench signals with driver_7seg_4digits
  -- entity (Unit Under Test)
  uut_driver_7seg_4digits : entity work.driver_7seg_4digits
    port map (
      clk     => sig_clk_100mhz,
      rst     => sig_rst,
      data0   => sig_data0,
      data1   => sig_data1,
      data2   => sig_data2,
      data3   => sig_data3,
      dp_vect => sig_dp_vect,
      dp      => sig_dp,
      seg     => sig_seg,
      dig     => sig_dig
    );

  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
  p_clk_gen : process is
  begin

    while now < 400 ns loop -- 40 periods of 100MHz clock

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;

  end process p_clk_gen;

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_reset_gen : process is
  begin

    sig_rst <= '0';
    -- WRITE YOUR CODE HERE AND ACTIVATE RESET FOR A WHILE
    wait for 12 ns;

    sig_rst <= '1'; -- Reset activated
    wait for 73 ns;

    sig_rst <= '0'; -- Reset deactivated

    wait;

  end process p_reset_gen;

  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";

    -- WRITE YOUR CODE HERE AND TEST INPUT VALUE "3.142"
    -- Display "3.142"
    sig_dp_vect <= "0111"; -- Decimal point
    sig_data3   <= x"3";
    sig_data2   <= x"1";
    sig_data1   <= x"4";
    sig_data0   <= x"2";

    report "Stimulus process finished";
    wait;

  end process p_stimulus;

end architecture testbench;