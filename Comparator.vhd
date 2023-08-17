library ieee;
use ieee.std_logic_1164.all;

entity Comparator is
port (a, b: in std_logic_vector(3 downto 0);
	 result: out std_logic_vector(7 downto 0));
end Comparator;

architecture ComparatorArc of Comparator is 

signal x0, x1, x2, x3: std_logic;
signal x, y, z: std_logic;

component xor_gate
port (a, b: in std_logic;
			c: out std_logic);
end component;

begin

g1: xor_gate
port map (a(0), b(0), x0);

g2: xor_gate
port map (a(1), b(1), x1);

g3: xor_gate
port map (a(2), b(2), x2);

g4: xor_gate
port map (a(3), b(3), x3);

y <= not (x0 or x1 or x2 or x3);

x <= (a(3) and (not b(3))) or ((not x3) and a(2) and (not b(2))) or ((not x3) and (not x2) and a(1) and (not b(1))) or ((not x3) and (not x2) and (not x1) and a(0) and (not b(0)));

z <= (b(3) and (not a(3))) or ((not x3) and b(2) and (not a(2))) or ((not x3) and (not x2) and b(1) and (not a(1))) or ((not x3) and (not x2) and (not x1) and b(0) and (not a(0)));

result(0) <= (not x) and (not y) and z;
result(1) <= (not x) and y and (not z);
result(2) <= x and (not y) and (not z);
result(3) <= '0'; 
result(4) <= '0';
result(5) <= '0';
result(6) <= '0';
result(7) <= '0';

end ComparatorArc;