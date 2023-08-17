library ieee;
use ieee.std_logic_1164.all;

entity HalfAdder is
port(		  a, b: in std_logic;
	  sum, carry: out std_logic);
end HalfAdder;

architecture HalfAdderArc of HalfAdder is 

component xor_gate
port(a, b: in std_logic;
		  c: out std_logic);
end component;

component and_gate
port(a, b: in std_logic;
		  c: out std_logic);		  
end component;
		  
begin

gate1: xor_gate
port map(a, b, sum);

gate2: and_gate
port map(a, b, carry);

end HalfAdderArc;