library ieee;
use ieee.std_logic_1164.all;

entity dff is
  port(
    D : in  std_logic;
    E : in  std_logic; -- used as clock in the .dig
    Q : out std_logic;
    nQ: out std_logic
  );
end entity;

architecture rtl of dff is
  signal q_i : std_logic := '0';
begin
  process(E)
  begin
    if rising_edge(E) then
      q_i <= D;
    end if;
  end process;

  Q  <= q_i;
  nQ <= not q_i;
end architecture;
