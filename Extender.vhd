--Authors: Group 17, Alexander Stratmoen, Mischa Lamoureux
--Extender
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Extender IS Port
(
 clk_input, reset, extender, ext_en					      				     		  	: IN std_logic;
 ext_pos                                               						  		: IN std_logic_vector(3 downto 0);
 clk_en, left_right, grappler_en, extender_out											: OUT std_logic
 );
END ENTITY;
 

 Architecture SM of Extender is
 
  
 TYPE STATE_NAMES IS (Retracted, Button1Retracted, Extending, Fully_Extended, Fully_Extended1, Retracting);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


BEGIN 
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, reset, next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (reset = '1') THEN
		current_state <= Retracted;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_State;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (ext_pos, extender, current_state) 

BEGIN
    CASE current_state IS
         WHEN Retracted =>
				IF(extender = '1' AND ext_en = '1') THEN
					next_state <= Button1Retracted;
				ELSE
					next_state <= Retracted;
				END IF;
				
			WHEN Button1Retracted =>		
				IF(extender='0') THEN
					next_state <= Extending;
				ELSE
					next_state <= Button1Retracted;
				END IF;

         WHEN Extending =>
				IF(ext_pos = "1111") THEN
					next_state <= Fully_Extended;
				ELSE
					next_state <= Extending;
				END IF;

         WHEN Fully_Extended =>		
				IF(extender = '1') THEN
					next_state <= Fully_Extended1;
				ELSE
					next_state <= Fully_Extended;
				END IF;
			
			WHEN Fully_Extended1 =>		
				IF(extender='0') THEN
					next_state <= Retracting;
				ELSE
					next_state <= Fully_Extended1;
				END IF;
				
			WHEN Retracting =>		
				IF(ext_pos = "0000") THEN
					next_state <= Retracted;
				ELSE
					next_state <= Retracting;
				END IF;
					
 		END CASE;

 END PROCESS;

-- DECODER SECTION PROCESS
--Moore machine

Decoder_Section: PROCESS (ext_pos, extender, current_state) 

BEGIN
    CASE current_state IS
	 
         WHEN Retracted =>		
			clk_en     	<= '0';
			left_right 	<= '0';
			grappler_en <= '0';
			extender_out <= '0';
         WHEN Button1Retracted =>		
			clk_en     	<= '0';
			left_right 	<= '0';
			grappler_en <= '0';
			extender_out <= '0';

         WHEN Extending =>		
			clk_en     	<= '1';
			left_right 	<= '1';
			grappler_en <= '0';
			extender_out <= '1';

         WHEN Fully_Extended =>		
			clk_en     	<= '0';
			left_right 	<= '1';
			grappler_en <= '1';
			extender_out <= '1';
				
         WHEN Fully_Extended1 =>		
			clk_en     	<= '0';
			left_right 	<= '0';
			grappler_en <= '1';
			extender_out <= '1';
			
			WHEN Retracting =>		
			clk_en     	<= '1';
			left_right 	<= '0';
			grappler_en <= '0';
			extender_out <= '1';
				

	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
