
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        CLK100MHZ    : in    STD_LOGIC;
        BTNC         : in    STD_LOGIC;
        BTNU         : in    STD_LOGIC;
        SW           : in    STD_LOGIC_VECTOR(7 downto 0);
        UART_RXD_OUT : out   STD_LOGIC;
        LED16_B      : out   STD_LOGIC
    );
end entity top_level;

architecture Behavioral of top_level is
    component clock_en is
        generic (
            n_periods : integer
        );
        port (
            clk   : in    std_logic;
            rst   : in    std_logic;
            pulse : out   std_logic
        );
    end component;

    component uart_tx_8n1 is
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            baud_en  : in    std_logic;
            tx_start : in    std_logic;
            data_in  : in    std_logic_vector(7 downto 0);
            tx       : out   std_logic;
            tx_done  : out   std_logic
        );
    end component;

    signal sig_9600bd : std_logic;

begin

    CLK_BAUD : component clock_en
        generic map (
            n_periods => 10_417  -- baudrate = 9600
            -- n_periods => 868  -- baudrate = 115_200
        )
        port map (
            clk   => CLK100MHZ,
            rst   => BTNC,
            pulse => sig_9600bd
        );

    UART : component uart_tx_8n1
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            tx_start => BTNU,
            data_in  => SW,
            baud_en  => sig_9600bd,
            tx       => UART_RXD_OUT,
            tx_done  => LED16_B
        );

end architecture Behavioral;
