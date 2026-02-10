library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Matches your 4bitALU.dig ports: OP is 1-bit.
-- OP=0 => add, OP=1 => subtract (A - B)
entity alu4_simple is
  port(
    A  : in  std_logic_vector(3 downto 0);
    B  : in  std_logic_vector(3 downto 0);
    OP : in  std_logic;
    O  : out std_logic_vector(3 downto 0);
    Co : out std_logic
  );
end entity;

architecture rtl of alu4_simple is
  signal tmp : signed(4 downto 0);
  signal a_s, b_s : signed(4 downto 0);
  signal y   : signed(4 downto 0);
begin
  a_s <= signed('0' & A);
  b_s <= signed('0' & B);

  y <= a_s + b_s when OP = '0' else a_s - b_s;

  O  <= std_logic_vector(y(3 downto 0));
  -- Co meaning depends on your schematic; this is the MSB carry-out of unsigned add/sub.
  Co <= std_logic(unsigned(y)(4));
end architecture;
