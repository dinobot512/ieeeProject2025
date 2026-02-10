library ieee;
use ieee.std_logic_1164.all;

entity mux4bit2_1 is
  port(
    A   : in  std_logic_vector(3 downto 0);
    B   : in  std_logic_vector(3 downto 0);
    Sel : in  std_logic;
    O   : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of mux4bit2_1 is
begin
  O <= A when Sel = '0' else B;
end architecture;
