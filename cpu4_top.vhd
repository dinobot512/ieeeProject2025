library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- NOTE:
-- This matches the *ports* seen in 4bitCPU.dig: A(4), B(4), CP(1), OP(2), outputs: O(4), Co(1), Done(1).
-- The internal behavior is a reasonable functional CPU/ALU-style unit:
--   OP=00: add (O=A+B)
--   OP=01: subtract (O=A-B)
--   OP=10: multiply (shift-add; returns low 4 bits in O, high bit in Co; Done pulses when finished)
--   OP=11: divide (restoring division; O=quotient, Co=LSB of remainder; Done pulses when finished)
-- If your .dig CPU uses a different opcode mapping, tell me your mapping and I'll swap it.

entity cpu4_top is
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

architecture rtl of cpu4_top is
  -- add/sub
  signal alu_o  : std_logic_vector(3 downto 0);
  signal alu_co : std_logic;

  -- multiplier
  type mul_state_t is (M_IDLE, M_RUN, M_DONE);
  signal mstate : mul_state_t := M_IDLE;
  signal m_acc  : unsigned(7 downto 0) := (others => '0');
  signal m_mcand: unsigned(7 downto 0) := (others => '0');
  signal m_mplier: unsigned(3 downto 0) := (others => '0');
  signal m_cnt  : unsigned(2 downto 0) := (others => '0');

  -- divider
  type div_state_t is (D_IDLE, D_RUN, D_DONE);
  signal dstate : div_state_t := D_IDLE;
  signal dA     : signed(4 downto 0) := (others => '0');
  signal dQ     : unsigned(3 downto 0) := (others => '0');
  signal dM     : signed(4 downto 0) := (others => '0');
  signal d_cnt  : unsigned(2 downto 0) := (others => '0');
  signal div_dbz: std_logic := '0';

  signal o_reg  : std_logic_vector(3 downto 0) := (others => '0');
  signal co_reg : std_logic := '0';
  signal done_reg : std_logic := '0';

begin
  U_ALU: entity work.alu4_addsub
    port map(
      A => A,
      B => B,
      OP => OP(0),
      O => alu_o,
      Co => alu_co
    );

  O    <= o_reg;
  Co   <= co_reg;
  Done <= done_reg;

  process(CP)
    variable A_next : signed(4 downto 0);
    variable Q_next : unsigned(3 downto 0);
  begin
    if rising_edge(CP) then
      done_reg <= '0';

      case OP is
        when "00" | "01" =>
          -- single-cycle add/sub
          o_reg  <= alu_o;
          co_reg <= alu_co;
          -- reset multi-cycle engines
          mstate <= M_IDLE;
          dstate <= D_IDLE;
          div_dbz <= '0';

        when "10" =>
          -- multiply
          dstate <= D_IDLE;
          div_dbz <= '0';
          case mstate is
            when M_IDLE =>
              m_acc    <= (others => '0');
              m_mcand  <= unsigned("0000" & A);
              m_mplier <= unsigned(B);
              m_cnt    <= to_unsigned(4, 3);
              mstate   <= M_RUN;

            when M_RUN =>
              if m_mplier(0) = '1' then
                m_acc <= m_acc + m_mcand;
              end if;
              m_mcand  <= shift_left(m_mcand, 1);
              m_mplier <= '0' & m_mplier(3 downto 1);

              if m_cnt = 1 then
                mstate <= M_DONE;
              else
                m_cnt <= m_cnt - 1;
              end if;

            when M_DONE =>
              o_reg  <= std_logic_vector(m_acc(3 downto 0));
              co_reg <= std_logic(m_acc(4));
              done_reg <= '1';
              mstate <= M_IDLE;
          end case;

        when others =>
          -- divide
          mstate <= M_IDLE;
          case dstate is
            when D_IDLE =>
              if B = "0000" then
                div_dbz <= '1';
                o_reg <= (others => '0');
                co_reg <= '0';
                done_reg <= '1';
                dstate <= D_IDLE;
              else
                div_dbz <= '0';
                dA <= (others => '0');
                dQ <= unsigned(A);
                dM <= signed('0' & B);
                d_cnt <= to_unsigned(4, 3);
                dstate <= D_RUN;
              end if;

            when D_RUN =>
              -- Shift left (A,Q)
              A_next := shift_left(dA, 1);
              A_next(0) := dQ(3);
              Q_next := dQ(2 downto 0) & '0';

              -- A = A - M
              A_next := A_next - dM;

              if A_next(4) = '1' then
                -- negative: restore, Q0=0
                A_next := A_next + dM;
                Q_next(0) := '0';
              else
                Q_next(0) := '1';
              end if;

              dA <= A_next;
              dQ <= Q_next;

              if d_cnt = 1 then
                dstate <= D_DONE;
              else
                d_cnt <= d_cnt - 1;
              end if;

            when D_DONE =>
              o_reg  <= std_logic_vector(dQ);
              -- Co: give you *something useful* (LSB of remainder)
              co_reg <= std_logic(unsigned(dA(3 downto 0))(0));
              done_reg <= '1';
              dstate <= D_IDLE;
          end case;
      end case;
    end if;
  end process;
end architecture;
