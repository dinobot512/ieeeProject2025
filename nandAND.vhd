library ieee;
use ieee.std_logic_1164.all;

entity nandAND is
  port(
    A : in  std_logic;
    B : in  std_logic;
    Y : out std_logic
  );
end entity;

architecture rtl of nandAND is
begin
  Y <= A and B;
end architecture;
