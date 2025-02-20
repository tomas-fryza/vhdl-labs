-------------------------------------------------
--! @brief VHDL example for basic logic gates.
--! @version 1.1
--! @copyright (c) 2019-2025 Tomas Fryza, MIT license
--!
--! The entity 'gates' defines an interface for implementing
--! 2-input AND, OR, and XOR gates. The architecture
--! implements the behavior of these gates with specified delays.
--!
--! Developed using TerosHDL, Vivado 2020.2, and EDA Playground.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity gates is
    port (
        a       : in    std_logic; --! First input
        b       : in    std_logic; --! Second input
        and_out : out   std_logic; --! Logic AND
        or_out  : out   std_logic; --! Logic OR
        xor_out : out   std_logic  --! Logic XOR
    );
end entity gates;

-------------------------------------------------

architecture behavioral of gates is
begin

    -- 2-input AND gate
    and_out <= a and b;
    -- and_out <= a and b after 3 ns;

    -- 2-input OR gate
    or_out <= a or b;
    -- or_out <= a or b after 2 ns;

    -- XOR gate
    xor_out <= a xor b;
    -- xor_out <= a xor b after 6 ns;

end architecture behavioral;
