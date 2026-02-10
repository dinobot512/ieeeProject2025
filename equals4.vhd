library ieee;
use ieee.std_logic_1164.all;

entity equals4 is
  port(
    A  : in  std_logic_vector(3 downto 0);
    B  : in  std_logic_vector(3 downto 0);
    Eq : out std_logic
  );
end entity;

architecture rtl of equals4 is
begin
  Eq <= '1' when A = B else '0';
end architecture;
