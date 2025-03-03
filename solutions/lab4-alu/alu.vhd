-------------------------------------------------
--! @brief 4-bit Arithmetic Logic Unit (ALU)
--! @version 1.0
--! @copyright (c) 2025 Tomas Fryza, MIT license
--!
--! This VHDL module implements ...
--!
--! Developed using TerosHDL, Vivado 2023.2.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all; -- Package for data type conversions

-------------------------------------------------

entity alu is
    port (
        a      : in    std_logic_vector(3 downto 0); --! 4-bit inputs
        b      : in    std_logic_vector(3 downto 0);
        opcode : in    std_logic_vector(2 downto 0); --! Operation selector
        result : out   std_logic_vector(3 downto 0); --! 4-bit output
        carry  : out   std_logic;                    --! Carry out flag
        zero   : out   std_logic                     --! Zero flag
    );
end entity alu;

-------------------------------------------------

architecture behavioral of alu is
    signal sig_res : std_logic_vector(4 downto 0);  -- Extra bit for carry
begin

    p_alu : process (a, b, opcode) is
    begin

        case opcode is

            when "000" =>
                sig_res <= '0' & not a;                             -- NOT A

            when "001" =>
                sig_res <= '0' & (a xor b);                         -- XOR

            when "010" =>
                sig_res <= std_logic_vector(unsigned('0' & a) +
                                            unsigned('0' & b));     -- ADD

            when "011" =>
                sig_res <= std_logic_vector(unsigned('0' & a) -
                                            unsigned('0' & b));     -- SUB

            -- Extended operations
            when "100" =>
                sig_res <= std_logic_vector(unsigned('0' & a) + 1); -- Increment A

            when "101" =>
                sig_res <= std_logic_vector(unsigned('0' & a) - 1); -- Decrement A

            when "110" =>
                sig_res <= a(3 downto 0) & '0';                     -- Multiply by 2 (Shift Left)

            when "111" =>
                sig_res <= "00" & a(3 downto 1);                    -- Divide by 2 (Shift Right)

            when others =>
                sig_res <= "00000";                                 -- Default case

        end case;

    end process p_alu;

    -- Assign outputs
    result <= sig_res(3 downto 0);
    carry  <= sig_res(4); -- Carry bit
    zero   <= '1' when sig_res(3 downto 0) = "0000" else
              '0';        -- Zero flag

end architecture behavioral;
