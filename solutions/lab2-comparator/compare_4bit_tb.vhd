library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity tb_compare_4bit is
-- Entity of testbench is always empty
end entity tb_compare_4bit;

-------------------------------------------------

architecture testbench of tb_compare_4bit is
    component compare_4bit is
        port (
            b         : in    std_logic_vector(3 downto 0);
            a         : in    std_logic_vector(3 downto 0);
            b_greater : out   std_logic;
            b_a_equal : out   std_logic;
            a_greater : out   std_logic
        );
    end component;

    -- Testbench local signals
    signal sig_b         : std_logic_vector(3 downto 0);
    signal sig_a         : std_logic_vector(3 downto 0);
    signal sig_b_greater : std_logic;
    signal sig_b_a_equal : std_logic;
    signal sig_a_greater : std_logic;
begin

    dut : component compare_4bit
        port map (
            b         => sig_b,
            a         => sig_a,
            b_greater => sig_b_greater,
            b_a_equal => sig_b_a_equal,
            a_greater => sig_a_greater
        );

    -----------------------------------------------
    p_stimulus : process is
    begin

        -- Report a note at the beginning of stimulus process
        report "Stimulus process started";

        -- Test case is followed by the expected output
        -- value(s). If assert condition is false, then
        -- an error is reported to the console.
        sig_b <= "0000";
        sig_a <= "0000";
        wait for 100 ns;
        assert (sig_b_greater = '0') and
           (sig_b_a_equal = '1') and
           (sig_a_greater = '0')
            report "Input combination b=0, a=0 FAILED"
            severity error;

        ------------------------------
        -- WRITE OTHER TEST CASES AND ASSERTS HERE
        sig_b <= "0001";
        sig_a <= "0001";
        wait for 100 ns;
        assert (sig_b_greater = '0') and
           (sig_b_a_equal = '1') and
           (sig_a_greater = '0')
            report "Input combination b=1, a=1 FAILED"
            severity error;

        ------------------------------
        sig_b <= "0011";
        sig_a <= "1100";
        wait for 100 ns;
        assert (sig_b_greater = '0') and
           (sig_b_a_equal = '0') and
           (sig_a_greater = '1')
            report "Input combination b=3, a=12 FAILED"
            severity error;

        ------------------------------
        sig_b <= "1000";
        sig_a <= "1001";
        wait for 100 ns;
        assert (sig_b_greater = '0') and
           (sig_b_a_equal = '0') and
           (sig_a_greater = '1')
            report "Input combination b=8, a=9 FAILED"
            severity error;

        ------------------------------
        sig_b <= "1001";
        sig_a <= "1000";
        wait for 100 ns;
        assert (sig_b_greater = '1') and
           (sig_b_a_equal = '0') and
           (sig_a_greater = '0')
            report "Input combination b=9, a=8 FAILED"
            severity error;

        report "Stimulus process finished";

        -- Data generation process is suspended forever
        wait;

    end process p_stimulus;

end architecture testbench;
