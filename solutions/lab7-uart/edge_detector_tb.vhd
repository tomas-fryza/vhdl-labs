-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 24 Mar 2025 08:10:06 GMT
-- Request id : cfwk-7285587e-M-67e1135ec978c

library ieee;
    use ieee.std_logic_1164.all;

entity tb_edge_detector is
end entity tb_edge_detector;

architecture tb of tb_edge_detector is
    component edge_detector is
        port (
            clk      : in    std_logic;
            btn      : in    std_logic;
            pos_edge : out   std_logic;
            neg_edge : out   std_logic
        );
    end component;

    signal clk      : std_logic;
    signal btn      : std_logic;
    signal pos_edge : std_logic;
    signal neg_edge : std_logic;

    constant TbPeriod   : time      := 1000 ns; -- EDIT Put right period here
    signal   TbClock    : std_logic := '0';
    signal   TbSimEnded : std_logic := '0';
begin

    dut : component edge_detector
        port map (
            clk      => clk,
            btn      => btn,
            pos_edge => pos_edge,
            neg_edge => neg_edge
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod / 2 when TbSimEnded /= '1' else
               '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process is
    begin

        -- EDIT Adapt initialization as needed
        btn <= '0';

        -- EDIT Add stimuli here
        wait for 10 * TbPeriod;
        btn <= '1';
        wait for 15 * TbPeriod;
        btn <= '0';

        wait for 18 * TbPeriod;
        btn <= '1';
        wait for 11 * TbPeriod;
        btn <= '0';
        wait for 18 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;

    end process stimuli;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_edge_detector of tb_edge_detector is
    for tb
    end for;
end cfg_tb_edge_detector;
