-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 3.3.2025 11:37:53 UTC

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all; -- Package for data type conversions

entity tb_alu is
end entity tb_alu;

architecture tb of tb_alu is
    component alu is
        port (
            a      : in    std_logic_vector(3 downto 0);
            b      : in    std_logic_vector(3 downto 0);
            opcode : in    std_logic_vector(2 downto 0);
            result : out   std_logic_vector(3 downto 0);
            carry  : out   std_logic;
            zero   : out   std_logic
        );
    end component;

    signal a      : std_logic_vector(3 downto 0);
    signal b      : std_logic_vector(3 downto 0);
    signal opcode : std_logic_vector(2 downto 0);
    signal result : std_logic_vector(3 downto 0);
    signal carry  : std_logic;
    signal zero   : std_logic;
begin

    dut : component alu
        port map (
            a      => a,
            b      => b,
            opcode => opcode,
            result => result,
            carry  => carry,
            zero   => zero
        );

    stimuli : process is
    begin

        -- EDIT Adapt initialization as needed
        a      <= (others => '0');
        b      <= (others => '0');
        opcode <= (others => '0');

        report "==== START ====";
        a <= x"A";
        b <= x"6";

        -- Loop for several instructions
        for i in 0 to 7 loop

            -- Convert decimal value `i` to 3-bit wide binary
            opcode <= std_logic_vector(to_unsigned(i, 3));
            wait for 50 ns;

        end loop;

        wait;

    end process stimuli;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_alu of tb_alu is
    for tb
    end for;
end cfg_tb_alu;
