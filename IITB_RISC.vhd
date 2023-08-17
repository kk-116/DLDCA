library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity IITB_RISC is
  port(clk,rst  : in  std_logic);
end entity;

architecture arc of IITB_RISC is

component ALU is 
	port( A, B : in std_logic_vector(15 downto 0);
		s_type : in std_logic ;
		C_out, Z_out: out std_logic;
		O : out std_logic_vector(15 downto 0));
end component ALU;

component memory_unit is 
	port ( wr,rd,clk : in std_logic; 
			Addr_in, D_in: in std_logic_vector(15 downto 0);
			D_out: out std_logic_vector(15 downto 0)); 
end component memory_unit;

component signex_7 is
port (A: in std_logic_vector(8 downto 0);
B: out std_logic_vector(15 downto 0));
end component signex_7;

component signex_10 is
port (A: in std_logic_vector(5 downto 0);
B: out std_logic_vector(15 downto 0));
end component signex_10;

 

component register_file is 
	port( A1,A2,A3 : in std_logic_vector(2 downto 0);
		  D3: in std_logic_vector(15 downto 0);
		clk,wr: in std_logic ; 
		D1, D2: out std_logic_vector(15 downto 0));
end component register_file;

----------------------------------------------------------------------------------------------------------------------------------------

type FSMState is (SReset, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19 ,S20);
signal state: FSMState;
signal t1, t2, t3, t4, IR, se7_o,se10_o, MEM_A, MEM_DIN, MEM_D, ALU_A, ALU_B, ALU_C, RF_D3, RF_D1, RF_D2, PC  :std_logic_vector(15 downto 0):=x"0000";
signal mr, mw, alu_s ,zero_out, car_out, z_out, carry, zero, rwr :std_logic:='0';
signal se7_i : std_logic_vector(8 downto 0);
signal se10_i : std_logic_vector(5 downto 0);
signal RF_A1, RF_A2, RF_A3: std_logic_vector(2 downto 0);
signal op_code : std_logic_vector(3 downto 0);

begin
	rf_main : register_file port map (RF_A1, RF_A2, RF_A3, RF_D3, clk, rwr, RF_D1, RF_D2);
	alu_main : alu port map (ALU_A, ALU_B, alu_s, car_out, z_out, ALU_C);
	mem_main : memory_unit port map (mw, mr,clk, MEM_A, MEM_DIN, MEM_D);
	se7_reg : signex_7 port map (se7_i, se7_o);
	se10_reg : signex_10 port map (se10_i, se10_o);

process(clk, state)
    variable next_state : FSMState;
	  variable T1_t, T2_t, T3_t, T4_t, IR_t,tem, next_pc: std_logic_vector(15 downto 0);
	  variable z, car : std_logic;
	  variable op_v : std_logic_vector(3 downto 0);
	  
begin
	   next_state :=state;
		T1_t :=t1; T2_t :=t2; T3_t :=t3; T4_t :=t4; IR_t :=IR; op_v := op_code;
		z :=zero; car :=carry;
		next_pc :=PC;
  case state is
       when SReset =>
		    mw <= '0';
		    mr <= '0';
			 rwr <= '0';
          z := '0';
			 car :='0';
          T1_t := x"0000";
          T2_t := x"0000";
          T3_t := x"0000";
		    IR_t := x"0000";
			 tem  := x"0000";
			 next_state := S0;
----------------------------------------------------------
       when S0 =>
		    mw <= '0';
		    mr <= '1';
			 rwr <= '0';
			 MEM_A <= PC;
			 IR_t := MEM_D;
			 op_v := IR_t(15 downto 12);
			 ALU_A <= PC;
			 ALU_B <= x"0001";
			 alu_s <= '0';
			 next_pc := ALU_C;
				
			 case (op_v) is
			   when "0001"|"0010"|"1000"  =>
					next_state :=S1;
				when "0000" =>
				  next_state :=S4;
				when "0011" =>
				  next_state :=S6;
				when "0101"|"0111" =>
				  next_state :=S7;
				when "1101"|"1100" =>
				  next_state :=S10;
				when "1010"|"1001" =>
				  next_state :=S15;
				when "1011" =>
				  next_state :=S18;
			   when others => null;
          end case; 
--------------------------------------------------------------------------		
	--Reads data from RF_A1(rA) and RF_A2(rB) into T1_t and T2_t
	     when S1 =>
		      mr <= '0';
		      RF_A1 <=IR_t(11 downto 9);
				RF_A2 <=IR_t(8 downto 6);
				T1_t := RF_D1;
				T2_t := RF_D2;
				case (op_v) is
					when "1000" =>
					  if(T1_t=T2_t) then
							next_state :=S20;
						 else
							next_state :=S0;
						 end if;
					 when others => 
						next_state :=S2;   
				end case; 
				
---------------------------------------------------------------------------
	--performs ADD and NAND operations
		  when S2 =>
		      ALU_A <= T1_t;
				ALU_B <= T2_t;
				tem(15 downto 1) := T2_t(15 downto 1);
				if(op_v="0001" and IR_t(1 downto 0)="11") then 
				ALU_B <= tem;
				end if;
				if(op_v="0001") then
				  alu_s <='1';
				else 
				  alu_s <= '0';
				end if;
				T3_t := ALU_C;
				case (op_v) is
			    when "0001"|"0010" =>
				  next_state :=S3;
			    when "0000" =>
				  next_state :=S5;
				 when "0101" =>
				  next_state :=S8;
				 when "0111" =>
				  next_state :=S9;
				  
			    when others => null;
            end case; 
------------------------------------------------------------------------------------------------------------		
	-- for op_v = 0001/0010( ADD, ADC, ADZ, ADL,NDU, NDC, NDZ)
	-- write computed result into RF_A3(rC) ad modify flags based on ZC conditions	 
			when S3 =>
			   rwr <= '1';
				if((IR_t(1 downto 0)="10" and car='1') or (IR_t(1 downto 0)="01" and z='1') or (IR_t(1 downto 0)="00") or (IR_t(1 downto 0)="11")) then
					RF_D3<=T3_t;
					RF_A3<=IR_t(5 downto 3);
					if(op_v="0001") then
						car :=car_out;
					end if;
					z:=z_out;
		      end if;	
            next_state :=S0;
------------------------------------------------------------------------------------------------------------
	--slightly different from S1 bcoz T2_t is filled by imm6, can write S4 in S1 since behavioural
		   when S4 =>
		      mr <= '0';
		      RF_A1 <=IR_t(11 downto 9);
				T1_t := RF_D1;
				se10_i <=IR_t(5 downto 0);
				T2_t := se10_o;
				next_state :=S2;
-------------------------------------------------------------------------------------------------------------				
	--slightly different from S3 bcoz RF_A3(rB) is 8 downto 6 here, can write S5 in S3 since behavioural
			when S5 =>
			   rwr <= '1';
				z :=z_out;
				car:=car_out;
				RF_D3<=T3_t;
				RF_A3<=IR_t(8 downto 6);
            next_state :=S0;

-----------------------------------------------------------------
		when S6 =>
		      mr <= '0';
				T1_t := IR_t(8 downto 0)&'0'&'0'&'0'&'0'&'0'&'0'&'0';
				rwr <= '1';
				RF_D3<=T1_t;
				RF_A3<=IR_t(11 downto 9);
				next_state :=S0;


-----------------------------------------------------------------
	--for LW and SW( 0101 and 0111)
	--fill T1_t from rB and T2_t  from imm6
         when S7 =>    
		      mr <= '0';
		      RF_A1 <=IR_t(8 downto 6);
				T1_t := RF_D1;
				se10_i <=IR_t(5 downto 0);
				T2_t := se10_o;
				next_state :=S2;
-----------------------------------------------------------------
	--for LW(0101)
	--loads data from MEM_A( data(rB) + imm6) into rA
         when S8 =>     
			   mr <='1';
		      z :=z_out;			
			   MEM_A <= T3_t;
			   T1_t := MEM_D;
			   rwr <= '1';
				RF_D3<=T1_t;
				RF_A3<=IR_t(11 downto 9);
            next_state :=S0;
-----------------------------------------------------------------
	--for SW(0111)
	--writes data from rA into MEM_A( data(rB) + imm6) 
         when S9 =>
            mw <= '1';
		      RF_A1 <=IR_t(11 downto 9);
				T2_t := RF_D1;
	         MEM_A <= T3_t;
	         MEM_DIN <= T2_t;
	         next_state :=S0;
----------------------------------------------------------------
	--for LM(1101) and SM(1100)
	--get memory add from rA
	      when S10 =>
		      mr <= '0';
		      RF_A1 <=IR_t(11 downto 9);
				T1_t := RF_D1;
				if(op_v="0110") then
				  next_state :=S11;
				else
				  next_state :=S13;
				end if;

---------------------------------------------------------------------------
	--for LM(1101)		
	--from memory to T3_t and from T3_t to rf in sequence 
			when S11 =>
		      mr <= '1';
			   MEM_A <= T1_t;
			   T3_t := MEM_D;
				RF_D3<=T3_t;
				RF_A3<=T2_t(2 downto 0);
				rwr <= '1';
				next_state :=S14;

-----------------------------------------------------------------
	--for LM(1101) and SM(1100)
	--jump to next memory addr and check for T2_t(rf addr)
         when S12 =>
			   ALU_A <= T1_t;
				ALU_B <= x"0001";
				alu_s <= '0';
				T1_t := ALU_C;
				if(unsigned(T2_t)<8) then
				  if(op_v="0110") then
				    next_state :=S11;
				  else
				    next_state :=S13;
				  end if;
				else
				  next_state :=S0;
				end if;
-----------------------------------------------------------------			
		--for SM(1100)
		--read data from rf(using T2_t) and write it in memory
         when S13 =>
			   mw <= '1';
		      RF_A2 <=T2_t(2 downto 0);
				T3_t := RF_D2;
				MEM_A <= T1_t;
	         MEM_DIN <= T3_t;
	         next_state :=S14;
-----------------------------------------------------------------
	--for SM(1100) and LM(1101)
	--T2_t++
         when S14 =>
			   mw <= '0';
		      mr <= '0';
				rwr<= '0';
			   ALU_A <= T2_t;
				ALU_B <= x"0001";
				alu_s <='0';
				T2_t :=ALU_C;
				if(IR_t(8-to_integer(unsigned(ALU_C(2 downto 0))))= '0') then
				   next_state := S14;
				else
				   next_state :=S12;
				end if;
-----------------------------------------------------------------
	--for JAL(1001) and JLR(1010)
	--write pc(PC) into rA
         when S15 =>
		      mr <= '0';
			   rwr <= '1';
				ALU_A <= PC;
				ALU_B <= x"0001";
				alu_s <='0';
				RF_D3 <= ALU_C;
				RF_A3<=IR_t(11 downto 9);
				if(op_v="1001") then
				  next_state :=S16;
				else
				  next_state :=S17;
				end if;
-----------------------------------------------------------------
	--for JLR(1010)
	--load pc value form rB
         when S16 =>
			   rwr <= '0';
		      RF_A1 <=IR_t(8 downto 6);
				next_pc := RF_D1;
	         next_state :=S0;
-----------------------------------------------------------------
	--for JAL(1001)
	--pc=pc+imm9
         when S17 =>
			   rwr <= '0';
				ALU_A <=PC;
				se7_i <=IR_t(8 downto 0);
				ALU_B <=se7_o;
				alu_s <= '0';
				next_pc:=ALU_C;
				next_state :=S0;
-----------------------------------------------------------------
	--for JRI(1011)
	--pc=pc+imm9  -part1
         when S18 =>
			   rwr <= '0';
				ALU_A <=PC;
				se7_i <=IR_t(8 downto 0);
				ALU_B <=se7_o;
				alu_s <= '0';
				next_pc:=ALU_C;
				next_state :=S19;
-----------------------------------------------------------------
	--for JRI(1011)
	--pc=pc+ load value from rA  -part2
         when S19 =>
			   rwr <= '0';
				RF_A1 <=IR_t(11 downto 9);
				ALU_A <=PC;
				ALU_B <=RF_D1;
				alu_s <= '0';
				next_pc:=ALU_C;
				next_state :=S0;
-----------------------------------------------------------------
	--for BEQ(100)
	--pc = pc+imm6
         when S20 =>
            ALU_A <= PC;
	         se10_i <= IR_t(5 downto 0);
	         ALU_B <= se10_o;
				alu_s<='0';
				next_pc:=ALU_C;
				next_state :=S0;
-----------------------------------------------------------------				
		when others => null;
	end case;	
  
	if(rising_edge(clk)) then
		 if(rst = '1') then
			 state <= SReset;
		 else
			 state <= next_state;
			 t1<=T1_t;t2<=T2_t;t3<=T3_t;t4<=T4_t;
			 zero<=z; carry<=car;IR<=IR_t;
			 op_code<=op_v;PC<=next_pc;
		 end if;
   end if;
end process;
end arc;