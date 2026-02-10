library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FourBitCPU is
end entity;

architecture sim of tb_FourBitCPU is
  signal OP   : std_logic_vector(1 downto 0) := "00";
  signal A    : std_logic_vector(3 downto 0) := (others => '0');
  signal B    : std_logic_vector(3 downto 0) := (others => '0');
  signal CP   : std_logic := '0';
  signal O    : std_logic_vector(3 downto 0);
  signal Co   : std_logic;
  signal Done : std_logic;

  constant Tclk : time := 10 ns;

  procedure tick is
  begin
    CP <= '0'; wait for Tclk/2;
    CP <= '1'; wait for Tclk/2;
  end procedure;

begin
  DUT: entity work.FourBitCPU
    port map(
      OP => OP,
      A  => A,
      B  => B,
      CP => CP,
      O  => O,
      Co => Co,
      Done => Done
    );

  stim: process
    variable oi : unsigned(3 downto 0);
  begin
    -- ADD: 3 + 5 = 8
    A  <= "0011";
    B  <= "0101";
    OP <= "00";
    tick;
    wait for 1 ns;
    assert Done = '1' report "ADD did not assert Done" severity error;
    assert O = "1000" report "ADD wrong result" severity error;

    -- SUB: 9 - 2 = 7
    A  <= "1001";
    B  <= "0010";
    OP <= "01";
    tick;
    wait for 1 ns;
    assert Done = '1' report "SUB did not assert Done" severity error;
    assert O = "0111" report "SUB wrong result" severity error;

    -- MUL: 3 * 6 = 18 (0x12) => low nibble 2
    A  <= "0011";
    B  <= "0110";
    OP <= "10";
    -- start op on next rising edge
    tick;
    -- run 4 cycles total; Done asserted at end
    tick; tick; tick;
    wait for 1 ns;
    assert Done = '1' report "MUL did not assert Done" severity error;
    assert O = "0010" report "MUL wrong low nibble" severity error;

    -- DIV: 13 / 3 = 4 remainder 1 => quotient 4
    A  <= "1101";
    B  <= "0011";
    OP <= "11";
    tick;
    tick; tick; tick;
    wait for 1 ns;
    assert Done = '1' report "DIV did not assert Done" severity error;
    assert O = "0100" report "DIV wrong quotient" severity error;

    -- done
    report "tb_FourBitCPU completed" severity note;
    wait;
  end process;
end architecture;
