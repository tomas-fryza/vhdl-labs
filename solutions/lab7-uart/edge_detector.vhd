
library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity edge_detector is
    port (
        clk      : in    std_logic; --! Main clock
        btn      : in    std_logic; --! Button input
        pos_edge : out   std_logic; --! Positive-edge (rising) impulse
        neg_edge : out   std_logic  --! Negative-edge (falling) impulse
    );
end entity edge_detector;

-------------------------------------------------

architecture behavioral of edge_detector is
    --! Remember previous button value
    signal sig_delayed : std_logic;
begin

    --! Remember the previous value of a signal and generates single
    --! clock pulses for positive and negative edges signal.
    p_edge_detector : process (clk) is
    begin

        if rising_edge(clk) then
            sig_delayed <= btn;
        end if;

    end process p_edge_detector;

    -- Assign output signals for edge detector
    pos_edge <= btn and not(sig_delayed);
    neg_edge <= not(btn) and sig_delayed;

end architecture behavioral;
