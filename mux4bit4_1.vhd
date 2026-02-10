library ieee;
use ieee.std_logic_1164.all;

entity mux4bit4_1 is
  port(
    I0  : in  std_logic_vector(3 downto 0);
    I1  : in  std_logic_vector(3 downto 0);
    I2  : in  std_logic_vector(3 downto 0);
    I3  : in  std_logic_vector(3 downto 0);
    Sel : in  std_logic_vector(1 downto 0);
    O   : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of mux4bit4_1 is
begin
  with Sel select
    O <= I0 when "00",
         I1 when "01",
         I2 when "10",
         I3 when "11",
         (others => '0') when others;
end architecture;
