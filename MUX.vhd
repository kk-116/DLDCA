library ieee;
use ieee.std_logic_1164.all;

entity MUX is
	port (a0, a1, a2, a3, a4, a5, a6, a7, s0, s1, s2: in std_logic;
															output: out std_logic);
end MUX;

architecture MUXarc of MUX is

signal sig: std_logic_vector(7 downto 0);
	  
begin
	
sig(7) <= s2 and s1 and s0 and a7;
sig(6) <= s2 and s1 and (not s0) and a6;
sig(5) <= s2 and (not s1) and s0 and a5;
sig(4) <= s2 and (not s1) and (not s0) and a4;
sig(3) <= (not s2) and s1 and s0 and a3;
sig(2) <= (not s2) and s1 and (not s0) and a2;
sig(1) <= (not s2) and (not s1) and s0 and a1;
sig(0) <= (not s2) and (not s1) and (not s0) and a0;

output <= (sig(7)) or (sig(6)) or (sig(5)) or (sig(4)) or (sig(3)) or (sig(2)) or (sig(1)) or (sig(0));
	
end MUXarc;