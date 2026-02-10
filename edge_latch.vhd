library ieee;
use ieee.std_logic_1164.all;

entity edge_latch is
  port(
    D  : in  std_logic;
    CP : in  std_logic;
    Q  : out std_logic;
    nQ : out std_logic
  );
end entity;

architecture rtl of edge_latch is
  signal q_i : std_logic := '0';
begin
  process(CP)
  begin
    if rising_edge(CP) then
      q_i <= D;
    end if;
  end process;

  Q  <= q_i;
  nQ <= not q_i;
end architecture;
