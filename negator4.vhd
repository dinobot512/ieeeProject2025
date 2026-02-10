library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity negator4 is
  port(
    I : in  std_logic_vector(3 downto 0);
    O : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of negator4 is
begin
  -- Two's complement negation
  O <= std_logic_vector(unsigned(not I) + 1);
end architecture;
