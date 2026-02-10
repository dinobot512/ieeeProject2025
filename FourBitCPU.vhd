library ieee;
use ieee.std_logic_1164.all;

-- Top-level wrapper for your project.
-- This corresponds to the top schematic: 4bitCPU.dig (highest level).
entity FourBitCPU is
  port(
    OP   : in  std_logic_vector(1 downto 0);
    A    : in  std_logic_vector(3 downto 0);
    B    : in  std_logic_vector(3 downto 0);
    CP   : in  std_logic;
    O    : out std_logic_vector(3 downto 0);
    Co   : out std_logic;
    Done : out std_logic
  );
end entity;

architecture rtl of FourBitCPU is
begin
  U_CPU: entity work.cpu4bit_unit
    port map(
      A    => A,
      B    => B,
      CP   => CP,
      OP   => OP,
      O    => O,
      Co   => Co,
      Done => Done
    );
end architecture;
