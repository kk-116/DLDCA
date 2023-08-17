library ieee;
use ieee.std_logic_1164.all;

entity OnebitFullAdd is
port ( a, b, cin : in std_logic;
		  sum, cout: out std_logic);
end entity;

architecture OnebitFullAddArc of OnebitFullAdd is

signal s1, c1, c2: std_logic;

component HalfAdder
port(		  a, b: in std_logic;
	  sum, carry: out std_logic);
end component;

component or_gate
port(a, b: in std_logic;
		  c: out std_logic);
end component;
	  
begin
gate1: HalfAdder
port map(a, b, s1, c1);

gate2: HalfAdder
port map(cin, s1, sum, c2);

gate3: or_gate
port map(c1, c2, cout);


end OnebitFullAddArc;