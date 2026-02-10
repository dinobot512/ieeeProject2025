library ieee;
use ieee.std_logic_1164.all;

-- Functional equivalent of the NAND-built XOR/XNOR schematic.
-- If your .dig implements XNOR instead, flip the assignment.
entity nandNXOR is
  port(
    A : in  std_logic;
    B : in  std_logic;
    Y : out std_logic
  );
end entity;

architecture rtl of nandNXOR is
begin
  Y <= A xor B;
  -- Y <= not (A xor B); -- use this if schematic is XNOR
end architecture;
