library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RunLengthEncoder is
	port(clk : in std_logic;
		  inp : in std_logic_vector(7 downto 0);
		  outp: out std_logic_vector(7 downto 0);
		  fin : out std_logic;
		  dataValidity: out std_logic);
end entity;

architecture RunLengthEncoderArc of RunLengthEncoder is

type twoDarray is array (63 downto 0) of std_logic_vector(7 downto 0);
type oneDarray is array (63 downto 0) of integer;
signal bufferArray   : twoDarray := (others => (others => '0'));
signal index         : integer := 0;
signal total		 : integer := 0;
signal track		 : integer := 0;
signal count		 : integer := 1;

begin
	--dataValid <= '0';
	--outp <= "00000000";
	process (clk)
	--variable count: integer := 1;
	--variable index: integer := 0;
	--variable total: integer := 0;
	--variable freq : integer := 1;
	
	variable dummyDataValid: std_logic := '0';
	variable dataValid: std_logic := '0';
	variable endOfInput: std_logic := '0';
	
	variable outType: oneDarray := (others => 0);
	--variable steps: oneDarray := (others => 0);
	variable freq: oneDarray := (others => 0);
	
	--variable track: integer := 0;
	--variable sig: std_logic := '0';
	variable dummyFinish: std_logic := '0';
	
	variable escape: std_logic_vector(7 downto 0) := "00011011";
	begin 
		if (rising_edge(clk)) then
			if (index = total and endOfInput = '1') then
				dummyFinish := '1';
				fin <= '1';
				dataValid := '0';
			else
				if dummyDataValid = '1' then
					dataValid := '1';
					if outType(index) = 1 then
						outp <= bufferArray(index);
						index <= index+1;
					elsif outType(index) = 2 then
						outp <= bufferArray(index);
						if track = 0 then
							track <= 1;
						elsif track = 1 then
							track <= 0;
							index <= index + 1;
						end if;
					elsif outType(index) = 3 then
						if track = 0 then
							outp <= escape;
							track <= 1;
						elsif track = 1 then
							if freq(index) = 1 then
								outp <= "00000001";
							elsif freq(index) = 2 then
								outp <= "00000010";
							elsif freq(index) = 3 then
								outp <= "00000011";
							elsif freq(index) = 4 then
								outp <= "00000100";
							elsif freq(index) = 5 then
								outp <= "00000101";
							elsif freq(index) = 6 then
								outp <= "00000110";
							elsif freq(index) = 7 then
								outp <= "00000111";
							end if;
							track <= 2;
						elsif track = 2 then
							outp <= bufferArray(index);
							track <= 0;
							index <= index+1;
						end if;
					 end if;
				 else
					dataValid := '0';
				 end if;
				 if index = total and endOfInput = '1' then
						fin <= '1';
						dummyFinish := '1';
				 end if;
			end if;
					
		elsif (falling_edge(clk)) then
			if total = 0 then
				bufferArray(0) <= inp;
				total <= 1;
			else  
				if bufferArray(total-1) = inp and ((inp = escape and count < 6) or ((not(inp = escape)) and count < 5)) then
					count <= count + 1;
					if (index = total-1) then
							dummyDataValid := '0'; 
						else 
							dummyDataValid := '1';
					end if;
				else
					if not (inp = "00000000") then
						bufferArray(total) <= inp;
					end if;
					if ((not (inp = "00000000")) or (inp = "00000000" and endOfInput = '0')) then
						if bufferArray(total-1) = escape then
							outType(total-1) := 3;
						else
							if count = 1 then
								outType(total-1) := 1;
							elsif count = 2 then
								outType(total-1) := 2;
							elsif count > 2 then
								outType(total-1) := 3;
							end if;
						end if;
						freq(total-1)   := count;
					end if;
					dummyDataValid := '1';
					
					count <= 1;
					if ((not (inp = "00000000"))) then
						total <= total + 1;
					end if;
					if inp = "00000000" then
						dummyDataValid := '1';
						endOfInput := '1';
					end if;
				end if;
			end if;
		end if;
		dataValidity <= dataValid;
		fin <= dummyFinish;
	end process;
end RunLengthEncoderArc;
