--Authors: Group 17, Alexander Stratmoen, Mischa Lamoureux
--4bit Register
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity Four_Bit_Register is port
	(
			CLK				: in std_logic := '0';
			RESET				: in std_logic := '0';
			CAPTURE			: in std_logic := '0';
			INPUT				: in std_logic_vector(3 downto 0);
			OUTPUT			: out std_logic_vector(3 downto 0)
	);
end Entity;

ARCHITECTURE one OF Four_Bit_Register IS

Signal hold				: std_logic_vector(3 downto 0);

BEGIN

process (CLK, RESET) is
begin
	if (RESET = '1') then
			hold <= "0000";
			
	elsif (rising_edge(CLK) AND (CAPTURE = '1')) then
					
		hold (3 downto 0) <= INPUT (3 downto 0);
	
	end if;
	OUTPUT <= hold;
	
end process;

END one;