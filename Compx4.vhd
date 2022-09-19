--Authors: Group 17, Alexander Stratmoen, Mischa Lamoureux
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
--Inputs and Outputs are defined for Compx4
entity Compx4 is port (
   
   A_4bit   	:  in  std_logic_vector(3 downto 0);
   B_4bit     	:  in  std_logic_vector(3 downto 0);
	
	A_less_than_B_4bit     :  out  std_logic;
	A_equals_B_bit4        :  out  std_logic;
	A_greater_than_B_4bit  :  out  std_logic
); 
end Compx4;

architecture logic_compx4 of Compx4 is

--We import Compx1
component Compx1 is port (
   
   A	   :  in  std_logic;
   B     :  in  std_logic; 
	
	A_less_than_B     :  out  std_logic;
	A_equals_B     :  out  std_logic;
	A_greater_than_B     :  out  std_logic
); 
end component Compx1;


--A3 & B3
signal A3GTB3	:	std_logic;
signal A3EQB3	:	std_logic;
signal A3LTB3	:	std_logic;

--A2 & B2
signal A2GTB2	:	std_logic;
signal A2EQB2	:	std_logic;
signal A2LTB2	:	std_logic;

--A1 & B1
signal A1GTB1	:	std_logic;
signal A1EQB1	:	std_logic;
signal A1LTB1	:	std_logic;

--A0 & B0
signal A0GTB0	:	std_logic;
signal A0EQB0	:	std_logic;
signal A0LTB0	:	std_logic;



begin
--We will use our individual comparators to build a 4 bit comparator, they each take in 1 of the 4 bit signals from, A and B and output them to signals.
inst1: Compx1 port map ( --   			X3		 Y3      Z3
					A_4bit(3), B_4bit(3), A3LTB3, A3EQB3, A3GTB3
					);
inst2: Compx1 port map ( --   			X2		 Y2      Z2
					A_4bit(2), B_4bit(2), A2LTB2, A2EQB2, A2GTB2
					);
inst3: Compx1 port map ( --   			X1		 Y1      Z1
					A_4bit(1), B_4bit(1), A1LTB1, A1EQB1, A1GTB1
					);
inst4: Compx1 port map ( --   			X0		 Y0      Z0
					A_4bit(0), B_4bit(0), A0LTB0, A0EQB0, A0GTB0
					);
--After this they are combined following the logic outlined in out truth table to get final outputs
A_less_than_B_4bit <= ((A3LTB3) OR (A3EQB3 AND A2LTB2) OR (A3EQB3 AND A2EQB2 AND A1LTB1) OR (A3EQB3 AND A2EQB2 AND A1EQB1 AND A0LTB0));
A_equals_B_bit4 <= (A3EQB3 AND A2EQB2 AND A1EQB1 AND A0EQB0);
A_greater_than_B_4bit <= ((A3GTB3) OR (A3EQB3 AND A2GTB2) OR (A3EQB3 AND A2EQB2 AND A1GTB1) OR (A3EQB3 AND A2EQB2 AND A1EQB1 AND A0GTB0));
										 
end architecture logic_compx4; 
----------------------------------------------------------------------