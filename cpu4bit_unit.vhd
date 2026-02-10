library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Best-effort behavioral CPU/compute unit matching your 4bitCPU.dig top-level ports.
-- Inputs: A(4), B(4), CP(clock), OP(2)
-- Outputs: O(4), Co(1), Done(1)
--
-- OP mapping (you can change to match your schematic):
--   00: ADD  (A+B)
--   01: SUB  (A-B)
--   10: MUL  (shift-add, 4 cycles) => O = low 4 bits, Co = high bit of low-nibble carry (or use upper bits)
--   11: DIV  (restoring division, 4 cycles) => O = quotient, Co = remainder[0]
entity cpu4bit_unit is
  port(
    A    : in  std_logic_vector(3 downto 0);
    B    : in  std_logic_vector(3 downto 0);
    CP   : in  std_logic;
    OP   : in  std_logic_vector(1 downto 0);
    O    : out std_logic_vector(3 downto 0);
    Co   : out std_logic;
    Done : out std_logic
  );
end entity;

architecture rtl of cpu4bit_unit is
  type state_t is (IDLE, MUL_RUN, DIV_RUN);
  signal st : state_t := IDLE;

  -- add/sub immediate
  signal addsub_y : unsigned(4 downto 0);

  -- MUL state
  signal mul_acc   : unsigned(7 downto 0) := (others => '0');
  signal mul_mcand : unsigned(7 downto 0) := (others => '0');
  signal mul_mplier: unsigned(3 downto 0) := (others => '0');
  signal mul_cnt   : unsigned(2 downto 0) := (others => '0');

  -- DIV state (restoring)
  signal div_A : signed(4 downto 0) := (others => '0');
  signal div_Q : unsigned(3 downto 0) := (others => '0');
  signal div_M : signed(4 downto 0) := (others => '0');
  signal div_cnt : unsigned(2 downto 0) := (others => '0');

  signal o_i : std_logic_vector(3 downto 0) := (others => '0');
  signal co_i : std_logic := '0';
  signal done_i : std_logic := '0';

begin
  O    <= o_i;
  Co   <= co_i;
  Done <= done_i;

  addsub_y <= ('0' & unsigned(A)) + ('0' & unsigned(B)) when OP = "00" else
              ('0' & unsigned(A)) - ('0' & unsigned(B));

  process(CP)
    variable A_next : signed(4 downto 0);
    variable Q_next : unsigned(3 downto 0);
    variable acc_next : unsigned(7 downto 0);
    variable mcand_next : unsigned(7 downto 0);
    variable mplier_next : unsigned(3 downto 0);
  begin
    if rising_edge(CP) then
      done_i <= '0';

      case st is
        when IDLE =>
          if OP = "00" or OP = "01" then
            o_i <= std_logic_vector(addsub_y(3 downto 0));
            co_i <= addsub_y(4);
            done_i <= '1';
          elsif OP = "10" then
            -- init MUL
            mul_acc    <= (others => '0');
            mul_mcand  <= unsigned("0000" & A);
            mul_mplier <= unsigned(B);
            mul_cnt    <= to_unsigned(4, 3);
            st <= MUL_RUN;
          else
            -- init DIV
            if B = "0000" then
              o_i <= (others => '0');
              co_i <= '0';
              done_i <= '1';
            else
              div_A <= (others => '0');
              div_Q <= unsigned(A);
              div_M <= signed('0' & B);
              div_cnt <= to_unsigned(4, 3);
              st <= DIV_RUN;
            end if;
          end if;

        when MUL_RUN =>
          acc_next := mul_acc;
          mcand_next := mul_mcand;
          mplier_next := mul_mplier;

          if mplier_next(0) = '1' then
            acc_next := acc_next + mcand_next;
          end if;

          mcand_next := shift_left(mcand_next, 1);
          mplier_next := '0' & mplier_next(3 downto 1);

          mul_acc <= acc_next;
          mul_mcand <= mcand_next;
          mul_mplier <= mplier_next;

          if mul_cnt = 1 then
            st <= IDLE;
            o_i <= std_logic_vector(acc_next(3 downto 0));
            co_i <= acc_next(4); -- small 'carry-ish' bit; change if you want acc_next(7)
            done_i <= '1';
            mul_cnt <= (others => '0');
          else
            mul_cnt <= mul_cnt - 1;
          end if;

        when DIV_RUN =>
          -- Shift left (A,Q)
          A_next := shift_left(div_A, 1);
          A_next(0) := div_Q(3);
          Q_next := div_Q(2 downto 0) & '0';

          -- subtract
          A_next := A_next - div_M;

          if A_next(4) = '1' then
            -- restore
            A_next := A_next + div_M;
            Q_next(0) := '0';
          else
            Q_next(0) := '1';
          end if;

          div_A <= A_next;
          div_Q <= Q_next;

          if div_cnt = 1 then
            st <= IDLE;
            o_i <= std_logic_vector(Q_next);
            co_i <= std_logic_vector(unsigned(A_next(3 downto 0)))(0);
            done_i <= '1';
            div_cnt <= (others => '0');
          else
            div_cnt <= div_cnt - 1;
          end if;
      end case;
    end if;
  end process;

end architecture;
