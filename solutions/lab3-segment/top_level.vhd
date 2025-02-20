-------------------------------------------------
--! @brief Top level of 7-segment display decoder
--! @version 1.3
--! @copyright (c) 2020-2025 Tomas Fryza, MIT license
--!
--! This VHDL file implements the top-level module for
--! a binary-to-seven-segment decoder, controlling two displays.
--! The module instantiates the 'bin2seg' component to decode
--! binary inputs into seven-segment display signals. Display
--! position is selected by BTND button, and the input data is
--! displayed on LEDs (LED_R and LED_L).
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity top_level is
    port (
        SW_R  : in    std_logic_vector(3 downto 0); --! Binary value for right display
        LED_R : out   std_logic_vector(3 downto 0); --! Show right binary value
        SW_L  : in    std_logic_vector(3 downto 0); --! Binary value for left display
        LED_L : out   std_logic_vector(3 downto 0); --! Show left binary value
        CA    : out   std_logic;                    --! Cathode of segment A
        CB    : out   std_logic;                    --! Cathode of segment B
        CC    : out   std_logic;                    --! Cathode of segment C
        CD    : out   std_logic;                    --! Cathode of segment D
        CE    : out   std_logic;                    --! Cathode of segment E
        CF    : out   std_logic;                    --! Cathode of segment F
        CG    : out   std_logic;                    --! Cathode of segment G
        DP    : out   std_logic;                    --! Decimal point
        AN    : out   std_logic_vector(7 downto 0); --! Common anodes of all on-board displays
        BTNC  : in    std_logic;                    --! Clear the display
        BTND  : in    std_logic                     --! Switch between displays
    );
end entity top_level;

-------------------------------------------------

architecture behavioral of top_level is
    component bin2seg is
        port (
            clear : in    std_logic;
            bin   : in    std_logic_vector(3 downto 0);
            seg   : out   std_logic_vector(6 downto 0)
        );
    end component;

    --! Local signal for 7-segment decoder
    signal sig_tmp : std_logic_vector(3 downto 0);
begin

    --! Instantiate (make a copy of) `bin2seg` component to
    --! decode binary input into seven-segment display signals.
    display : component bin2seg
        port map (
            clear  => BTNC,
            bin    => sig_tmp,
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG
        );

    -- Connect local signal to input switches
    sig_tmp <= SW_L when (BTND = '1') else
               SW_R;

    -- Turn off decimal point
    DP <= '1';

    -- Display input value(s) on LEDs
    LED_R <= SW_R;
    LED_L <= SW_L;

    -- Set display position
    AN(7 downto 2) <= b"11_1111";
    AN(1)          <= not(BTND);
    AN(0)          <= BTND;

end architecture behavioral;
