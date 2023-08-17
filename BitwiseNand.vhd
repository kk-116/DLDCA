library ieee;
use ieee.std_logic_1164.all;

entity BitwiseNand is
port (a, b: in std_logic_vector(3 downto 0);
			c: out std_logic_vector(7 downto 0));
end BitwiseNand;

architecture BitwiseNandArc of BitwiseNand is

component nand_gate
port (a, b: in std_logic;
			c: out std_logic);
end component;

begin

g1: nand_gate
port map (a(0), b(0), c(0));

g2: nand_gate
port map (a(1), b(1), c(1));

g3: nand_gate
port map (a(2), b(2), c(2));

g4: nand_gate
port map (a(3), b(3), c(3));

c(4) <= '0'; c(5) <= '0'; c(6) <= '0'; c(7) <= '0';

end BitwiseNandArc;