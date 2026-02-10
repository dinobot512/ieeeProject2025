library ieee;
use ieee.std_logic_1164.all;

entity decoder2 is
  port(
    A  : in  std_logic_vector(1 downto 0);
    D0 : out std_logic;
    D1 : out std_logic;
    D2 : out std_logic;
    D3 : out std_logic
  );
end entity;

architecture rtl of decoder2 is
begin
  D0 <= '1' when A = "00" else '0';
  D1 <= '1' when A = "01" else '0';
  D2 <= '1' when A = "10" else '0';
  D3 <= '1' when A = "11" else '0';
end architecture;
