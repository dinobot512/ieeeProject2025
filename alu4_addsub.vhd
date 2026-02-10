library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu4_addsub is
  port(
    A  : in  std_logic_vector(3 downto 0);
    B  : in  std_logic_vector(3 downto 0);
    OP : in  std_logic; -- 0:add, 1:sub
    O  : out std_logic_vector(3 downto 0);
    Co : out std_logic
  );
end entity;

architecture rtl of alu4_addsub is
  signal b_eff : std_logic_vector(3 downto 0);
  signal tmp   : unsigned(4 downto 0);
  signal ci5   : unsigned(4 downto 0);
begin
  -- subtraction as A + (~B) + 1
  b_eff <= B when OP = '0' else not B;
  ci5   <= (4 downto 1 => '0') & OP;
  tmp   <= ('0' & unsigned(A)) + ('0' & unsigned(b_eff)) + ci5;

  O  <= std_logic_vector(tmp(3 downto 0));
  Co <= tmp(4);
end architecture;
