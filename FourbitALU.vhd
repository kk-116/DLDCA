library ieee;
use ieee.std_logic_1164.all;

entity FourbitALU is
	port (	a, b: in std_logic_vector(3 downto 0);
				 sel: in std_logic_vector(2 downto 0);
			 result: out std_logic_vector(7 downto 0));
end entity;

architecture FourbitALUarc of FourbitALU is 

signal negb: std_logic_vector(3 downto 0);			--Negation of b(for the subtractor)
signal add, subtract, multiply, compare, NandAB, NorAB, XorAB, XnorAB: std_logic_vector(7 downto 0);
signal zero, one: std_logic;

component and_gate
port(a, b: in std_logic;
		  c: out std_logic);
end component;
		  
component or_gate
port(a, b: in std_logic;
		  c: out std_logic);
end component;
		  
component not_gate
port(a: in std_logic;
	  b: out std_logic);
end component;
	  
component xor_gate
port (a, b: in std_logic;
			c: out std_logic);
end component;

component LookAheadAdder
port (a, b: in std_logic_vector(3 downto 0);
		 cin: in std_logic;
			s: out std_logic_vector(7 downto 0));
end component;

component Multiplier
port (  a, b: in std_logic_vector(3 downto 0);
		result: out std_logic_vector(7 downto 0));
end component;

component Comparator
port (  a, b: in std_logic_vector(3 downto 0);
		result: out std_logic_vector(7 downto 0));
end component;

component BitwiseNand
port (a, b: in std_logic_vector(3 downto 0);
			c: out std_logic_vector(7 downto 0));
end component;

component BitwiseNor
port (a, b: in std_logic_vector(3 downto 0);
			c: out std_logic_vector(7 downto 0));
end component;

component BitwiseXor
port (a, b: in std_logic_vector(3 downto 0);
			c: out std_logic_vector(7 downto 0));
end component;

component BitwiseXnor
port (a, b: in std_logic_vector(3 downto 0);
			c: out std_logic_vector(7 downto 0));
end component;

component MUX
port (a0, a1, a2, a3, a4, a5, a6, a7, s0, s1, s2: in std_logic;
														output: out std_logic);
end component;

begin

	zero <= '0'; one <= '1';
	
	negb(0) <= not b(0);
	negb(1) <= not b(1);
	negb(2) <= not b(2);
	negb(3) <= not b(3);
	
	adder: LookAheadAdder
	port map (a, b, zero, add);
	
	subtractor: LookAheadAdder
	port map (a, negb, one, subtract);
	
	BitMultiplier: Multiplier
	port map (a, b, multiply);
	
	UnsignedComparator: Comparator
	port map (a, b, compare);
	
	BitNand: BitwiseNand
	port map (a, b, NandAB);
	
	BitNor: BitwiseNor
	port map (a, b, NorAB);
	
	BitXor: BitwiseXor
	port map (a, b, XorAB);
	
	BitXnor: BitwiseXnor
	port map (a, b, XnorAB);
	
	mux1: MUX
	port map (add(0), subtract(0), multiply(0), compare(0), NandAB(0), NorAB(0), XorAB(0), XnorAB(0), sel(0), sel(1), sel(2), result(0));
	
	mux2: MUX
	port map (add(1), subtract(1), multiply(1), compare(1), NandAB(1), NorAB(1), XorAB(1), XnorAB(1), sel(0), sel(1), sel(2), result(1));
	
	mux3: MUX
	port map (add(2), subtract(2), multiply(2), compare(2), NandAB(2), NorAB(2), XorAB(2), XnorAB(2), sel(0), sel(1), sel(2), result(2));
	
	mux4: MUX
	port map (add(3), subtract(3), multiply(3), compare(3), NandAB(3), NorAB(3), XorAB(3), XnorAB(3), sel(0), sel(1), sel(2), result(3));
	
	mux5: MUX
	port map (add(4), subtract(4), multiply(4), compare(4), NandAB(4), NorAB(4), XorAB(4), XnorAB(4), sel(0), sel(1), sel(2), result(4));
	
	mux6: MUX
	port map (add(5), subtract(5), multiply(5), compare(5), NandAB(5), NorAB(5), XorAB(5), XnorAB(5), sel(0), sel(1), sel(2), result(5));
	
	mux7: MUX
	port map (add(6), subtract(6), multiply(6), compare(6), NandAB(6), NorAB(6), XorAB(6), XnorAB(6), sel(0), sel(1), sel(2), result(6));
	
	mux8: MUX
	port map (add(7), subtract(7), multiply(7), compare(7), NandAB(7), NorAB(7), XorAB(7), XnorAB(7), sel(0), sel(1), sel(2), result(7));
	
	
	
end FourbitALUarc;