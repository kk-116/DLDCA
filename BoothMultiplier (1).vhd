library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity BoothMultiplier is
	port ( clk, rst : in std_logic;
	a, b : in std_logic_vector (3 downto 0);
	result : out std_logic_vector (7 downto 0) );
end entity;

architecture booth_arc of BoothMultiplier is
	signal cycle, next_cycle: std_logic;
	signal partial1, partial2, sum: std_logic_vector(7 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if(rst = '1') then
				next_cycle <= '0';
				sum <= "00000000";
			else
				if(cycle = '0') then
					next_cycle <= '1';
					
					if(b(1 downto 0) = "00") then
						partial1 <= "00000000";
					elsif(b(1 downto 0) = "01") then
						partial1 <= "0000" & a;
					elsif(b(1 downto 0) = "10") then
						partial1 <= "000" & a & "0";
					elsif(b(1 downto 0) = "11") then
						partial1 <= ("00"&a&"00") + Not("0000"&a) + "00000001";
					end if;
					
					if(b(3 downto 2) = "00") then
						partial2 <= "00000000";
					elsif(b(3 downto 2) = "01") then
						partial2 <= "00" & a & "00";
					elsif(b(3 downto 2) = "10") then
						partial2 <= "0" & a & "000";
					elsif(b(3 downto 2) = "11") then
						partial2 <= (a&"0000") + Not("00"&a&"11") + "00000100";
					end if;
					
				elsif(cycle = '1') then
					next_cycle <= '0';
					
					sum <= partial1 + partial2;
				end if;
			end if;
		end if;
	end process;
	
	process(next_cycle)
	begin
		cycle <= next_cycle;
	end process;
	
	process(sum)
	begin
		result <= sum;
	end process;
	
end architecture;