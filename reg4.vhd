library ieee;
use ieee.std_logic_1164.all;

entity reg4 is
  port(
    D  : in  std_logic_vector(3 downto 0);
    CP : in  std_logic;
    Q  : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of reg4 is
  signal q_i : std_logic_vector(3 downto 0) := (others => '0');
begin
  process(CP)
  begin
    if rising_edge(CP) then
      q_i <= D;
    end if;
  end process;

  Q <= q_i;
end architecture;
