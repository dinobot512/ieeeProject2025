library ieee;
use ieee.std_logic_1164.all;

entity dff1 is
  port(
    D  : in  std_logic;
    E  : in  std_logic;
    Q  : out std_logic;
    nQ : out std_logic
  );
end entity;

architecture rtl of dff1 is
  signal q_i : std_logic := '0';
begin
  Q  <= q_i;
  nQ <= not q_i;

  process(E)
  begin
    if rising_edge(E) then
      q_i <= D;
    end if;
  end process;
end architecture;
