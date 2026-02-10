library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter4_versatile is
  port(
    CP : in  std_logic;
    S  : in  std_logic; -- select: 0=load D, 1=accumulate (Q+I)
    D  : in  std_logic_vector(3 downto 0);
    I  : in  std_logic_vector(3 downto 0);
    O  : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of counter4_versatile is
  signal q : std_logic_vector(3 downto 0) := (others => '0');
  signal next_q : std_logic_vector(3 downto 0);
  signal sum : unsigned(3 downto 0);
begin
  sum <= unsigned(q) + unsigned(I);
  next_q <= D when S = '0' else std_logic_vector(sum);

  process(CP)
  begin
    if rising_edge(CP) then
      q <= next_q;
    end if;
  end process;

  O <= q;
end architecture;
