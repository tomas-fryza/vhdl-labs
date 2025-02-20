library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity tb_gates is
-- Entity of testbench is always empty
end entity tb_gates;

-------------------------------------------------

architecture testbench of tb_gates is
    component gates is
        port (
            a       : in    std_logic;
            b       : in    std_logic;
            and_out : out   std_logic;
            or_out  : out   std_logic;
            xor_out : out   std_logic
        );
    end component;

    -- Testbench local signals
    signal sig_a, sig_b : std_logic;
    signal sig_and_out  : std_logic;
    signal sig_or_out   : std_logic;
    signal sig_xor_out  : std_logic;
begin

    -- Instantiate the design under test (DUT)
    dut : component gates
        port map (
            a       => sig_a,
            b       => sig_b,
            and_out => sig_and_out,
            or_out  => sig_or_out,
            xor_out => sig_xor_out
        );

    -- Test stimulus
    stimulus_process : process is
    begin

        sig_b <= '0';
        sig_a <= '0';
        wait for 100 ns;
        sig_b <= '0';
        sig_a <= '1';
        wait for 100 ns;
        sig_b <= '1';
        sig_a <= '0';
        wait for 100 ns;
        sig_b <= '1';
        sig_a <= '1';
        wait for 100 ns;
        sig_b <= '0';
        sig_a <= '0';
        wait for 100 ns;

        wait;

    end process stimulus_process;

end architecture testbench;
