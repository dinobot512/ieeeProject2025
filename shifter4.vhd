library ieee;
use ieee.std_logic_1164.all;

entity shifter4 is
  port(
    I    : in  std_logic_vector(3 downto 0);
    Shl  : in  std_logic; -- corresponds to "<<?" in the .dig
    O    : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of shifter4 is
begin
  -- If Shl='1' shift left, else shift right (logical)
  O <= I(2 downto 0) & '0' when Shl = '1' else
       '0' & I(3 downto 1);
end architecture;
