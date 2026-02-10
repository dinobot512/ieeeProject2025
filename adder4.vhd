library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder4 is
  port(
    A : in  std_logic_vector(3 downto 0);
    B : in  std_logic_vector(3 downto 0);
    S : out std_logic_vector(3 downto 0);
    C : out std_logic
  );
end entity;

architecture rtl of adder4 is
  signal tmp : unsigned(4 downto 0);
begin
  tmp <= ('0' & unsigned(A)) + ('0' & unsigned(B));
  S   <= std_logic_vector(tmp(3 downto 0));
  C   <= tmp(4);
end architecture;
