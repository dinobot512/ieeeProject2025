library ieee;
use ieee.std_logic_1164.all;

entity demux1_2 is
  port(
    I   : in  std_logic;
    Sel : in  std_logic;
    O0  : out std_logic;
    O1  : out std_logic
  );
end entity;

architecture rtl of demux1_2 is
begin
  O0 <= I when Sel = '0' else '0';
  O1 <= I when Sel = '1' else '0';
end architecture;
