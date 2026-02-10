library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
  port(
    A   : in  std_logic;
    B   : in  std_logic;
    Sel : in  std_logic;
    O   : out std_logic
  );
end entity;

architecture rtl of mux2_1 is
begin
  O <= A when Sel = '0' else B;
end architecture;
