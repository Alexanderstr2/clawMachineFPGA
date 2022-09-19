--Authors: Group 17, Alexander Stratmoen, Mischa Lamoureux
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
--Inputs and Outputs are defined for Compx1
entity Compx1 is port (
   
   A	   :  in  std_logic;
   B     :  in  std_logic; 
	
	A_less_than_B     :  out  std_logic;
	A_equals_B     :  out  std_logic;
	A_greater_than_B     :  out  std_logic
); 
end Compx1;

architecture logic_compx1 of Compx1 is



begin
--Basic 1 bit comparator design, we had issues with factoring out our NOTs so to be save we left them on each signal
A_less_than_B <= (NOT A) AND B; --When A is false and B is true A < B
A_equals_B <= (A AND B) OR ((NOT A) AND (NOT B)); --When A AND B are false or A AND B are true A = B
A_greater_than_B <= A AND (NOT B); --When A is true and B is false A > B
										 
end architecture logic_compx1; 
----------------------------------------------------------------------
