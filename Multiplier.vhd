library ieee;
use ieee.std_logic_1164.all;

entity Multiplier is
port (	  a, b: in std_logic_vector(3 downto 0);
			result: out std_logic_vector(7 downto 0));
end Multiplier;

architecture MultiplierArc of Multiplier is 

signal a0b0, a0b1, a0b2, a0b3, a1b0, a1b1, a1b2, a1b3,
								 a2b0, a2b1, a2b2, a2b3, a3b0, a3b1, a3b2, a3b3: std_logic;
signal zero, one: std_logic;
signal c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16: std_logic;
signal d1, d2, d3, d4, d5, d6, d7, d8, d9: std_logic;

component OneBitFullAdd
port ( a, b, cin : in std_logic;
		  sum, cout: out std_logic);
end component;

begin

zero <= '0'; one <= '1';

a0b0 <= a(0) and b(0);	a0b1 <= a(0) and b(1); a0b2 <= a(0) and b(2); a0b3 <= a(0) and b(3);
a1b0 <= a(1) and b(0);	a1b1 <= a(1) and b(1); a1b2 <= a(1) and b(2); a1b3 <= a(1) and b(3);
a2b0 <= a(2) and b(0);	a2b1 <= a(2) and b(1); a2b2 <= a(2) and b(2); a2b3 <= a(2) and b(3);
a3b0 <= a(3) and b(0);	a3b1 <= a(3) and b(1); a3b2 <= a(3) and b(2); a3b3 <= a(0) and b(3);

result(0) <= a0b0;

g1: OneBitFullAdd
port map (a0b1, a1b0, zero, result(1), c1);

g2: OneBitFullAdd
port map (a0b2, a1b1, zero, d1, c2);

g3: OneBitFullAdd
port map (a0b3, a1b2, zero, d2, c3);

g4: OneBitFullAdd
port map (zero, a1b3, zero, d3, c4);

g5: OneBitFullAdd
port map (d1, a2b0, c1, result(2), c5);

g6: OneBitFullAdd
port map (d2, a2b1, c2, d4, c6);

g7: OneBitFullAdd
port map (d3, a2b2, c3, d5, c7);

g8: OneBitFullAdd
port map (zero, a2b3, c4, d6, c8);

g9: OneBitFullAdd
port map (d4, a3b0, c5, result(3), c9);

g10: OneBitFullAdd
port map (d5, a3b1, c6, d7, c10);

g11: OneBitFullAdd
port map (d6, a3b2, c7, d8, c11);

g12: OneBitFullAdd
port map (zero, a3b3, c8, d9, c12);

g13: OneBitFullAdd
port map (d7, c9, zero, result(4), c13);

g14: OneBitFullAdd
port map (d8, c10, c13, result(5), c14);

g15: OneBitFullAdd
port map (d9, c11, c14, result(6), c15);

g16: OneBitFullAdd
port map (zero, c12, c15, result(7), c16);

end MultiplierArc;
