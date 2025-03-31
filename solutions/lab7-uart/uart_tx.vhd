-------------------------------------------------
--! @brief UART Transmitter
--! @version 1.0
--! @copyright (c) 2025 Tomas Fryza, MIT license
--!
--! This module implements a UART (Universal Asynchronous
--! Receiver Transmitter) transmitter using a Finite State
--! Machine (FSM). The transmitter sends an 8-bit data
--! frame over a serial interface, including start, stop,
--! and no parity bit.
--!
--! Notes:
--!   - Ensure that 'baud_en' matches the desired baud rate.
--!
--! Developed using TerosHDL, Vivado 2020.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity uart_tx is
  port (
    clk      : in    std_logic;                    --! Main clock
    rst      : in    std_logic;                    --! High-active synchronous reset
    baud_en  : in    std_logic;                    --! Clock Enable signal (Baud tick)
    tx_start : in    std_logic;                    --! Start transmission
    data_in  : in    std_logic_vector(7 downto 0); --! Data to transmit
    tx       : out   std_logic;                    --! UART Tx line
    tx_done  : out   std_logic                     --! Ready for transmission
  );
end entity uart_tx;

-------------------------------------------------

architecture behavioral of uart_tx is

  -- FSM States

  type state_type is (idle, start_bit, data, stop_bit);

  signal state_tx : state_type;

  -- Transmission Registers
  signal sig_count : integer range 0 to 7;
  signal sig_reg   : std_logic_vector(7 downto 0);

begin

  -- UART Transmitter FSM
  p_uart_tx : process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        tx        <= '1';
        sig_count <= 0;
        tx_done   <= '0';
        state_tx  <= idle;
      else

        case state_tx is

          when idle =>

            tx      <= '1';
            tx_done <= '0';
            if (tx_start = '1') then
              state_tx <= start_bit;
            end if;

          when start_bit =>

            -- Start bit (LOW), Load data
            tx        <= '0';
            sig_reg   <= data_in;
            sig_count <= 0;
            tx_done   <= '0';

            if (baud_en = '1') then
              state_tx <= data;
            end if;

          when data =>

            -- Transmit LSB, Shift right
            tx      <= sig_reg(0);
            sig_reg <= '0' & sig_reg(7 downto 1);

            if (baud_en = '1') then
              if (sig_count = 7) then
                state_tx <= stop_bit;
              else
                sig_count <= sig_count + 1;
              end if;
            end if;

          when stop_bit =>

            -- Stop bit (HIGH)
            tx      <= '1';
            tx_done <= '1';

            if (baud_en = '1') then
              state_tx <= idle;
            end if;

          when others =>

            state_tx <= idle;

        end case;

      end if;
    end if;

  end process p_uart_tx;

end architecture behavioral;
