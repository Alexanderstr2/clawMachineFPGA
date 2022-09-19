--Authors: Group 17, Alexander Stratmoen, Mischa Lamoureux
--Grappler
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Grappler IS Port
(
 clk_input, reset, grappler, grappler_en	: IN std_logic;
 grappler_on    			               	:  out  std_logic
 );
END ENTITY;
 

 Architecture SM of Grappler is
 
  
 TYPE STATE_NAMES IS (goff, presson, gon, pressoff);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


BEGIN 
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, reset, next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (reset = '1') THEN
		current_state <= goff;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_State;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (grappler, current_state) 

BEGIN
    CASE current_state IS
         WHEN goff =>		
				IF(grappler='1' AND grappler_en = '1') THEN
					next_state <= presson;
				ELSE
					next_state <= goff;
				END IF;

         WHEN presson =>		
				IF(grappler='0') THEN
					next_state <= gon;
				ELSE
					next_state <= presson;
				END IF;

         WHEN gon =>		
				IF(grappler='1' AND grappler_en = '1') THEN
					next_state <= pressoff;
				ELSE
					next_state <= gon;
				END IF;
				
         WHEN pressoff =>		
				IF(grappler='0') THEN
					next_state <= goff;
				ELSE
					next_state <= pressoff;
				END IF;
	  END CASE;
 END PROCESS;

-- DECODER SECTION PROCESS
--Moore machine

Decoder_Section: PROCESS (grappler, grappler_en, current_state) 

BEGIN
    CASE current_state IS
         WHEN goff =>		
			grappler_on <= '0';
			
         WHEN presson =>		
			grappler_on <= '0';

         WHEN gon =>		
			grappler_on <= '1';
			
         WHEN pressoff =>
			grappler_on <= '1';		


	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
