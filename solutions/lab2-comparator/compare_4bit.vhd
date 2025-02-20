-------------------------------------------------
--! @brief 4-bit binary comparator.
--! @version 1.3
--! @copyright (c) 2020-2025 Tomas Fryza, MIT license
--!
--! A digital or **binary comparator** compares digital
--! signals A, B and produce outputs depending upon the
--! condition of those inputs. Four-bit binary comparator
--! use `when/else` assignments to distinguish three
--! states: greater than, equal, and less than.
--!
--! Wavedrom example, see <https://wavedrom.com/>:
--! {signal: [
--!  {name: 'b[3:0]', wave: '333333', data: ['0','1','3','8','9','a']},
--!  {name: 'a[3:0]', wave: '333333', data: ['0','1','c','9','3','a']},
--!  {},
--!  {name: 'b_greater', wave: 'l...hl'},
--!  {name: 'b_a_equal', wave: 'h.l..h'},
--!  {name: 'a_greater', wave: 'l.h.l.'},
--! ]}
--!
--! Developed using TerosHDL, Vivado 2020.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity compare_4bit is
    port (
        b         : in    std_logic_vector(3 downto 0); --! Input bus b[3:0]
        a         : in    std_logic_vector(3 downto 0); --! Input bus a[3:0]
        b_greater : out   std_logic;                    --! Output is `1` if b > a
        b_a_equal : out   std_logic;                    --! Output is `1` if b = a
        a_greater : out   std_logic                     --! Output is `1` if b < a
    );
end entity compare_4bit;

-------------------------------------------------

architecture behavioral of compare_4bit is
begin

    b_greater <= '1' when (b > a) else
                 '0';

    b_a_equal <= '1' when (b = a) else
                 '0';

    a_greater <= '1' when (b < a) else
                 '0';

end architecture behavioral;
