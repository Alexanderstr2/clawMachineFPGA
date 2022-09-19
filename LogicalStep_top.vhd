LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
	Clk			: in	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 
	leds			: out std_logic_vector(7 downto 0);

------------------------------------------------------------------	
	--xreg, yreg	: out std_logic_vector(3 downto 0);-- (for SIMULATION only)
	--sxPOS, yPOS	: out std_logic_vector(3 downto 0);-- (for SIMULATION only)
------------------------------------------------------------------	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment display (for LogicalStep only)
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector (for LogicalStep only)
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector (for LogicalStep only)
	
	);
END LogicalStep_Lab4_top;

ARCHITECTURE Circuit OF LogicalStep_Lab4_top IS

-- Provided Project Components Used
------------------------------------------------------------------- 
COMPONENT Clock_Source 	port (SIM_FLAG: in boolean;clk_input: in std_logic;clock_out: out std_logic);
END COMPONENT;

component SevenSegment
  port 
   (
      hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
      sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
end component SevenSegment;

component segment7_mux 
  port 
   (
      clk        	: in  std_logic := '0';
		DIN2 			: in  std_logic_vector(6 downto 0);	
		DIN1 			: in  std_logic_vector(6 downto 0);
		DOUT			: out	std_logic_vector(6 downto 0);
		DIG2			: out	std_logic;
		DIG1			: out	std_logic
   );
end component segment7_mux;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------
component Inverter is port (
   
   in_3   :  in  std_logic;
	in_2   :  in  std_logic;
	in_1   :  in  std_logic;
	in_0   :  in  std_logic;
	
	out_3   :  out  std_logic;
	out_2   :  out  std_logic;
	out_1   :  out  std_logic;
	out_0   :  out  std_logic
); 
end component Inverter;

component Bidir_shift is port
	(
			CLK				: in std_logic := '0';
			RESET				: in std_logic := '0';
			CLK_EN			: in std_logic := '0';
			LEFT0_RIGHT1	: in std_logic := '0';
			REG_BITS			: out std_logic_vector(3 downto 0)
	);
end component Bidir_shift;

component XY_Motion_State_Machine IS Port

(
 clk_input, reset, motion, X_LT, X_EQ, X_GT, Y_LT, Y_EQ, Y_GT, extender_out		: IN std_logic;
 clk_en_X, up_down_X, error, capture_XY, clk_en_Y, up_down_Y, extender_en			: OUT std_logic
 );
 
END component XY_Motion_State_Machine;

component Extender IS Port
(
  clk_input, reset, extender, ext_en					             					: IN std_logic;
  ext_pos                                                 							: IN std_logic_vector(3 downto 0);
  clk_en, left_right, grappler_en, extender_out											: OUT std_logic
 );
end component Extender;

component Grappler IS Port
(
 clk_input, reset, grappler, grappler_en	: IN std_logic;
 grappler_on    			               	:  out  std_logic
 );
END component Grappler;

component Compx4 is port (
   
   A_4bit   :  in  std_logic_vector(3 downto 0);
   B_4bit     :  in  std_logic_vector(3 downto 0);
	
	A_less_than_B_4bit     :  out  std_logic;
	A_equals_B_bit4        :  out  std_logic;
	A_greater_than_B_4bit  :  out  std_logic
); 
end component Compx4;

component Four_Bit_Register is port
	(
			CLK				: in std_logic := '0';
			RESET				: in std_logic := '0';
			CAPTURE			: in std_logic := '0';
			INPUT				: in std_logic_vector(3 downto 0);
			OUTPUT			: out std_logic_vector(3 downto 0)
	);
end component Four_Bit_Register;

component U_D_Bin_Counter4bit is port
	(
			CLK				: in std_logic := '0';
			RESET				: in std_logic := '0';
			CLK_EN			: in std_logic := '0';
			UP1_DOWN0		: in std_logic := '0';
			COUNTER_BITS	: out std_logic_vector(3 downto 0)
	);
end component U_D_Bin_Counter4bit;
------------------------------------------------------------------
-- provided signals
-------------------------------------------------------------------
------------------------------------------------------------------	
constant SIM_FLAG : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board
------------------------------------------------------------------	
------------------------------------------------------------------	
-- Create any additional internal signals to be used
signal clk_in, clock	: std_logic;
signal motion : std_logic;
signal reset  : std_logic;
signal extender_signal : std_logic;
signal grappler_signal : std_logic;
signal X_LT, X_EQ, X_GT : std_logic;
signal Y_LT, Y_EQ, Y_GT : std_logic;
signal clk_enX, up_downX : std_logic;
signal clk_enY, up_downY : std_logic;
signal clk_on_reg4		: std_logic;
signal left_right_reg4  : std_logic;
signal capture_XY : std_logic;
signal extender_en : std_logic;
signal extender_out : std_logic;
signal grappler_en : std_logic;
signal ext_pos : std_logic_vector(3 downto 0);
signal X_pos : std_logic_vector(3 downto 0);
signal Y_pos : std_logic_vector(3 downto 0);
signal X_pos_mux : std_logic_vector(6 downto 0);
signal Y_pos_mux : std_logic_vector(6 downto 0);
signal X_reg : std_logic_vector(3 downto 0);
signal Y_reg : std_logic_vector(3 downto 0);

BEGIN

--xreg <= X_reg;
--yreg <= Y_reg;
--xPOS <= X_pos;
--yPOS <= Y_pos;

leds(5 downto 2) <= ext_pos;
	
clk_in <= clk;

Clock_Selector: Clock_source port map(SIM_FLAG, clk_in, clock);

inst0: Inverter port map ('1', pb_n(2), pb_n(1), pb_n(0), reset, motion, extender_signal, grappler_signal);
inst1: XY_Motion_State_Machine port map (clock, reset, motion, X_LT, X_EQ, X_GT, Y_LT, Y_EQ, Y_GT, extender_out, 
			clk_enX, up_downX, leds(0), capture_XY, clk_enY, up_downY, extender_en);
inst2: Extender port map (clock, reset, extender_signal, extender_en, ext_pos, clk_on_reg4, left_right_reg4, grappler_en, extender_out);
inst3: Grappler port map (clock, reset, grappler_signal, grappler_en, leds(1));
inst4: U_D_Bin_Counter4bit port map (clock, reset, clk_enX, up_downX, X_pos);
inst5: Four_Bit_Register port map (clock, reset, capture_XY, sw(7 downto 4), X_reg);
inst6: U_D_Bin_Counter4bit port map (clock, reset, clk_enY, up_downY, Y_pos);
inst7: Four_Bit_Register port map (clock, reset, capture_XY, sw(3 downto 0), Y_reg);
inst8: Bidir_shift port map (clock, reset, clk_on_reg4, left_right_reg4, ext_pos);
inst9: Compx4 port map (X_pos, X_reg, X_LT, X_EQ, X_GT);
inst10: Compx4 port map (Y_pos, Y_reg, Y_LT, Y_EQ, Y_GT);
inst11: SevenSegment port map (X_pos, X_pos_mux);
inst12: SevenSegment port map (Y_pos, Y_pos_mux);
inst13: segment7_mux port map (clk_in, X_pos_mux, Y_pos_mux, seg7_data, seg7_char1, seg7_char2);


END Circuit;