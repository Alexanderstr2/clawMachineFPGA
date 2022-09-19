--Authors: Group 17, Alexander Stratmoen, Mischa Lamoureux
--Inverter file
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
--Inputs and Outputs are defined for Inverter
entity Inverter is port (
   
   in_3   :  in  std_logic;
	in_2   :  in  std_logic;
	in_1   :  in  std_logic;
	in_0   :  in  std_logic;
	
	out_3   :  out  std_logic;
	out_2   :  out  std_logic;
	out_1   :  out  std_logic;
	out_0   :  out  std_logic
); 
end Inverter;

architecture logic_Inverter of Inverter is


begin
--All signals inverted
out_3 <= NOT in_3;
out_2 <= NOT in_2;
out_1 <= NOT in_1;
out_0 <= NOT in_0;
										 
end architecture logic_Inverter; 
----------------------------------------------------------------------