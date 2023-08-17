library ieee;
use ieee.std_logic_1164.all;

entity BitwiseXnor is
port (a, b: in std_logic_vector(3 downto 0);
			c: out std_logic_vector(7 downto 0));
end BitwiseXnor;

architecture BitwiseXnorArc of BitwiseXnor is

component xnor_gate
port (a, b: in std_logic;
			c: out std_logic);
end component;

begin

g1: xnor_gate
port map (a(0), b(0), c(0));

g2: xnor_gate
port map (a(1), b(1), c(1));

g3: xnor_gate
port map (a(2), b(2), c(2));

g4: xnor_gate
port map (a(3), b(3), c(3));

c(4) <= '0'; c(5) <= '0'; c(6) <= '0'; c(7) <= '0';

end BitwiseXnorArc;