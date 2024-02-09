-------------------------------------------------
--! @brief 2-bit binary comparator.
--! @version 1.1
--! @copyright (c) 2020 Tomas Fryza, MIT license
--!
--! A digital or **binary comparator** compares
--! digital signals A, B presented at input terminal
--! and produce outputs depending upon the condition
--! of those inputs. Two-bit binary comparator use
--! `when/else` assignments to distinguish three
--! states: greater than, equal, and less than.
--!
--! Wavedrom example, see <https://wavedrom.com/>:
--! {signal: [
--!  {name: 'b[1:0]', wave: '333333', data: ['0','1','2','1','2','2']},
--!  {name: 'a[1:0]', wave: '333333', data: ['0','1','3','2','1','2']},
--!  {},
--!  {name: 'b_greater', wave: 'l...hl'},
--!  {name: 'b_a_equal', wave: 'h.l..h'},
--!  {name: 'a_greater', wave: 'l.h.l.'},
--! ]}
--!
--! Developed using TerosHDL, Vivado 2020.2, and
--! EDA Playground.
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity compare_2bit is
  port (
    b         : in    std_logic_vector(1 downto 0); --! Input bus b[1:0]
    a         : in    std_logic_vector(1 downto 0); --! Input bus a[1:0]
    b_greater : out   std_logic;                    --! Output is `1` if b > a
    b_a_equal : out   std_logic;                    --! Output is `1` if b = a
    a_greater : out   std_logic                     --! Output is `1` if b < a
  );
end entity compare_2bit;

-------------------------------------------------

architecture behavioral of compare_2bit is

begin

  -- MODIFY LOGIC FUNCTION FOR "B GREATER"
  b_greater <= '1' when (b > a) else
               '0';

  b_a_equal <= '1' when (b = a) else
               '0';

  -- MODIFY LOGIC FUNCTION FOR "A GREATER"
  a_greater <= '1' when (b < a) else
               '0';

end architecture behavioral;
