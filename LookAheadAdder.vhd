library ieee;
use ieee.std_logic_1164.all;

entity LookAheadAdder is
port (a, b: in std_logic_vector(3 downto 0);
		 cin: in std_logic;
			s: out std_logic_vector(7 downto 0));
end LookAheadAdder;

architecture LookAheadAdderArc of LookAheadAdder is

signal p, g, c: std_logic_vector(3 downto 0); 
	  
component xor_gate
port (a, b: in std_logic;
			c: out std_logic);
end component;
			
begin
	
	xg0: xor_gate
	port map (a(0), b(0), p(0));
	
	xg1: xor_gate
	port map (a(1), b(1), p(1));
	
	xg2: xor_gate
	port map (a(2), b(2), p(2));
	
	xg3: xor_gate
	port map (a(3), b(3), p(3));
	
	g(0) <= a(0) and b(0);
	g(1) <= a(1) and b(1);
	g(2) <= a(2) and b(2);
	g(3) <= a(3) and b(3);
	
	c(0) <= g(0) or (p(0) and cin);
	
	c(1) <= g(1) or (p(1) and g(0));
	
	c(2) <= g(2) or (p(2) and g(1)) or (p(1) and p(2) and g(0));
	
	c(3) <= g(3) or (p(3) and g(2)) or (p(1) and p(2) and g(1)) or (p(1) and p(2) and p(3) and g(0));
	
	sum0: xor_gate
	port map (p(0), cin, s(0));
	
	sum1: xor_gate
	port map (p(1), c(0), s(1));
	
	sum2: xor_gate
	port map (p(2), c(1), s(2));
	
	sum3: xor_gate
	port map (p(3), c(2), s(3));
	
	s(4) <= c(3);
	
	s(5) <= '0'; s(6) <= '0'; s(7) <= '0';
	
end LookAheadAdderArc;