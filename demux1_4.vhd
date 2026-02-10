library ieee;
use ieee.std_logic_1164.all;

entity demux1_4 is
  port(
    I   : in  std_logic;
    Sel : in  std_logic_vector(1 downto 0);
    O0  : out std_logic;
    O1  : out std_logic;
    O2  : out std_logic;
    O3  : out std_logic
  );
end entity;

architecture rtl of demux1_4 is
begin
  O0 <= I when Sel = "00" else '0';
  O1 <= I when Sel = "01" else '0';
  O2 <= I when Sel = "10" else '0';
  O3 <= I when Sel = "11" else '0';
end architecture;
