--Authors: Group 17, Alexander Stratmoen, Mischa Lamoureux
--XY Motion State Machine

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity  XY_Motion_State_Machine IS Port

(
 clk_input, reset, motion, X_LT, X_EQ, X_GT, Y_LT, Y_EQ, Y_GT, extender_out		: IN std_logic;
 clk_en_X, up_down_X, error, capture_XY, clk_en_Y, up_down_Y, extender_en			: OUT std_logic
 );
 
END ENTITY;
 

Architecture SM of XY_Motion_State_Machine is
 
  
 TYPE STATE_NAMES IS (off, capture, move, error_state);   -- list all the STATE_NAMES values

  
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


BEGIN 
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, reset, next_state)  -- this process synchronizes the activity to a clock
BEGIN
	IF (reset = '1') THEN
		current_state <= off;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_State;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (motion, X_EQ, Y_EQ, extender_out, current_state) 

BEGIN
    CASE current_state IS
         WHEN off =>		
				IF (motion = '1') THEN
					next_state <= capture;
				ELSE
					next_state <= off;
				END IF;

         WHEN capture =>
				IF (extender_out = '1') THEN
					next_state <= error_state;
				ELSIF (motion = '0') THEN
					next_state <= move;
				ELSE
					next_state <= capture;
				END IF;
					
         WHEN move =>
				IF (extender_out = '1') THEN
					next_state <= error_state;
				ELSIF ((X_EQ = '1') AND (Y_EQ = '1')) THEN
					next_state <= off;
				ELSE
					next_state <= move;
				END IF;
				
         WHEN error_state =>		
				IF(extender_out = '1') THEN
					next_state <= error_state;
				ELSIF ((X_EQ = '1') AND (Y_EQ = '1') AND (motion = '0') AND (extender_out = '0')) THEN
					next_state <= off;
				ELSIF ((motion = '1') AND (extender_out = '0')) THEN
					next_state <= capture;
				ELSIF (extender_out = '0') THEN
					next_state <= move;
				ELSE
					next_state <= error_state;
				END IF;
				
	  END CASE;
 END PROCESS;

-- DECODER SECTION PROCESS
--Mealy machine

Decoder_Section: PROCESS (clk_input, X_LT, X_EQ, Y_LT, Y_EQ, current_state) 
BEGIN
    CASE current_state IS
         WHEN off =>		
			clk_en_X     <= '0';
			up_down_X    <= '0';
			error        <= '0';
			capture_XY   <= '0';
			clk_en_Y     <= '0';
			up_down_Y    <= '0';
			extender_en  <= '1';
			
         WHEN capture =>		
			clk_en_X     <= '0';
			up_down_X    <= '0';
			error        <= '0';
			capture_XY   <= '1';
			clk_en_Y     <= '0';
			up_down_Y    <= '0';
			extender_en  <= '0';

         WHEN move =>		
			clk_en_X     <= NOT X_EQ;
			up_down_X    <= X_LT;
			error        <= '0';
			capture_XY   <= '0';
			clk_en_Y     <= NOT Y_EQ;
			up_down_Y    <= Y_LT;
			extender_en  <= '0';
			
         WHEN error_state =>		
			clk_en_X     <= '0';
			up_down_X    <= '0';
			error        <= clk_input;
			capture_XY   <= '0';
			clk_en_Y     <= '0';
			up_down_Y    <= '0';
			extender_en  <= '0';
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
