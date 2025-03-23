library ieee;
  use ieee.std_logic_1164.all;

entity uart_tx is
  port (
    clk         : in    std_logic;                    --! System clock
    rst         : in    std_logic;                    --! Reset
    baud_clk_en : in    std_logic;                    --! Clock Enable signal (Baud tick)
    tx_start    : in    std_logic;                    --! Start transmission
    data_in     : in    std_logic_vector(7 downto 0); --! Data to transmit
    tx          : out   std_logic;                    --! UART Tx line
    tx_ready    : out   std_logic                     --! Ready for transmission
  );
end entity uart_tx;

architecture behavioral of uart_tx is

  -- FSM States

  type state_type is (idle, start, data, stop);

  signal state : state_type;

  -- Transmission Registers
  signal sig_count : integer range 0 to 7;
  signal sig_reg   : std_logic_vector(7 downto 0);

begin

  -- UART Transmitter FSM
  p_uart_tx : process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then                         -- Synchronous reset
        state     <= idle;
        tx        <= '1';
        sig_count <= 0;
      elsif (baud_clk_en = '1') then              -- Use clock enable signal

        case state is

          when idle =>

            tx <= '1';                            -- TX line stays HIGH when idle
            if (tx_start = '1') then
              sig_reg <= data_in;                 -- Load data
              state   <= start;
            end if;

          when start =>

            tx        <= '0';                     -- Start bit (LOW)
            state     <= data;
            sig_count <= 0;

          when data =>

            tx      <= sig_reg(0);                -- Transmit LSB first
            sig_reg <= '0' & sig_reg(7 downto 1); -- Shift right
            if (sig_count = 7) then
              state <= stop;
            else
              sig_count <= sig_count + 1;
            end if;

          when stop =>

            tx    <= '1';                         -- Stop bit (HIGH)
            state <= idle;

          when others =>

            state <= idle;

        end case;

      end if;
    end if;                                       -- clk

  end process p_uart_tx;

  tx_ready <= '1' when (state = idle) else
              '0'; -- Tx ready when idle

end architecture behavioral;
