----------------------------------------------------------------------------------
--	Put proper documentation here
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity lab1 is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
			  btn: in	STD_LOGIC_VECTOR(4 downto 0);
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end lab1;

architecture structure of lab1 is

	signal trigger_time, trigger_volt, row, column: unsigned(9 downto 0);
	signal old_button, button_activity: std_logic_vector(4 downto 0);
	signal ch1_wave, ch2_wave: std_logic;
	
	component video is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  trigger_time: in unsigned(9 downto 0);
			  trigger_volt: in unsigned (9 downto 0);
			  row: out unsigned(9 downto 0);
			  column: out unsigned(9 downto 0);
			  ch1: in std_logic;
			  ch1_enb: in std_logic;
			  ch2: in std_logic;
			  ch2_enb: in std_logic);
	end component;

begin


	------------------------------------------------------------------------------
	-- the variable button_activity will contain a '1' in any position which 
	-- has been pressed or released.  The buttons are all nominally 0
	-- and equal to 1 when pressed.
	------------------------------------------------------------------------------


	------------------------------------------------------------------------------
	-- If a button has been pressed then increment of decrement the trigger vars
	------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
	video_inst: video port map( 
		clk => clk,
		reset_n => reset_n,
		tmds => tmds,
		tmdsb => tmdsb,
		trigger_time => trigger_time,
		trigger_volt => trigger_volt,
		row => row, 
		column => column,
		ch1 => ch1_wave,
		ch1_enb => ch1_wave,
		ch2 => ch2_wave,
		ch2_enb => ch2_wave); 

	
end structure;
