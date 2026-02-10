library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder4_wc is
  port(
    A  : in  std_logic_vector(3 downto 0);
    B  : in  std_logic_vector(3 downto 0);
    Ci : in  std_logic;
    S  : out std_logic_vector(3 downto 0);
    Co : out std_logic
  );
end entity;

architecture rtl of adder4_wc is
  signal tmp : unsigned(4 downto 0);
  signal ci5 : unsigned(4 downto 0);
begin
  ci5 <= (4 downto 1 => '0') & Ci;
  tmp <= ('0' & unsigned(A)) + ('0' & unsigned(B)) + ci5;
  S   <= std_logic_vector(tmp(3 downto 0));
  Co  <= tmp(4);
end architecture;
