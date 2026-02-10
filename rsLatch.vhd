library ieee;
use ieee.std_logic_1164.all;

-- Simple active-high R/S latch (NOR-latch behavior).
-- S=1 sets Q, R=1 resets Q. S=R=0 holds. S=R=1 is invalid.
entity rsLatch is
  port(
    R  : in  std_logic;
    S  : in  std_logic;
    Q  : out std_logic;
    nQ : out std_logic
  );
end entity;

architecture rtl of rsLatch is
  signal q_i : std_logic := '0';
begin
  process(R, S)
  begin
    if S = '1' then
      q_i <= '1';
    elsif R = '1' then
      q_i <= '0';
    end if;
  end process;

  Q  <= q_i;
  nQ <= not q_i;
end architecture;
