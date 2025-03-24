
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
    signal sig_baud : std_logic;
    signal sig_edge : std_logic;
    component clock_enable is
        generic (
            n_periods : integer := 3
        );
        port (
            clk   : in    std_logic;
            rst   : in    std_logic;
            pulse : out   std_logic
        );
    end component;

    component edge_detector is
        port (
            clk      : in    std_logic;
            btn      : in    std_logic;
            pos_edge : out   std_logic;
            neg_edge : out   std_logic
        );
    end component;

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
    end component;

begin

    BAUDRATE : component clock_enable
        generic map (
            n_periods => 10_417  -- baudrate = 9600
            -- n_periods => 868  -- baudrate = 115_200
        )
        port map (
            clk   => CLK100MHZ,
            rst   => BTNC,
            pulse => sig_baud
        );

    EDGE : component edge_detector
        port map (
            clk      => CLK100MHZ,
            btn      => BTNU,
            pos_edge => sig_edge,
            neg_edge => open
        );

    UART : component uart_tx
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            tx_start => BTNU,
            data_in  => SW,
            baud_en  => sig_baud,
            tx       => UART_RXD_OUT,
            tx_done  => LED16_B
        );

end architecture Behavioral;
