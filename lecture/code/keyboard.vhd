--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- File:	keyboard.vhdl
-- HW:	Lecture 11
--	Crs:	ECE 383
--
-- Purp:	A FSM for the keyboard scan unit
--
-- Documentation:	I borrowed this heavily from a piece of code I wrote
--						back in 2004.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity keyboard is
	port (kbclk, kbdata: out std_logic);
end entity;


architecture behavior of keyboard is

------------------------------------------------------------------------- 
--  PS2 scancodes for the number keys 0,1...,9.
------------------------------------------------------------------------- 
constant zero:		std_logic_vector(7 downto 0) := x"45";
constant one:		std_logic_vector(7 downto 0) := x"16";
constant two:		std_logic_vector(7 downto 0) := x"1E";
constant three:	std_logic_vector(7 downto 0) := x"26";
constant four:		std_logic_vector(7 downto 0) := x"25";
constant five:		std_logic_vector(7 downto 0) := x"2E";
constant six:		std_logic_vector(7 downto 0) := x"36";
constant seven:	std_logic_vector(7 downto 0) := x"3D";
constant eight:	std_logic_vector(7 downto 0) := x"3E";
constant nine:		std_logic_vector(7 downto 0) := x"46";
constant break:	std_logic_vector(7 downto 0) := x"FF";

------------------------------------------------------------------------- 
-- This is the number of keypresses being simulated.
------------------------------------------------------------------------- 
constant N: integer := 3;

------------------------------------------------------------------------- 
-- This type definition will be used below to store the keypresses
------------------------------------------------------------------------- 
type test is array (0 to N-1) of std_logic_vector(7 downto 0);

------------------------------------------------------------------------- 
-- This is the set of keypresses comprising the simulation.
------------------------------------------------------------------------- 
signal event: test := (	one, two, three);

procedure CodeGen(char: in std_logic_vector(7 downto 0);

	signal kbclk, kbdata: out std_logic) is  
	variable key_hit, bit_number: integer;
	variable parity: std_logic;
	variable key_value: std_logic_vector(7 downto 0); 
	constant clkHalfPeriod :time := 10 uS;

	
begin

	-- Send the start code
	kbdata <= '0'; 								wait for clkHalfPeriod;
	kbclk <= '0';  								wait for clkHalfPeriod;
	
	-- Send the 8-bits of data	
	parity := '0';
	key_value := char;
	for bit_number in 0 to 7 loop	  
		parity := parity xor  key_value(bit_number);
		kbdata <= key_value(bit_number);	
		kbclk <= '1';								wait for clkHalfPeriod;
		kbclk <= '0';								wait for clkHalfPeriod;
	end loop;
	
	-- send the parity bit (even)
 	kbdata <= parity;		kbclk <= '1';		wait for clkHalfPeriod;
	kbclk <= '0';									wait for clkHalfPeriod;
	
	-- send the stop bit
 	kbdata <= '1';			kbclk <= '1';		wait for clkHalfPeriod;
	kbclk <= '0';									wait for clkHalfPeriod;		
	kbclk <= '1';									wait for clkHalfPeriod;
	
end procedure;


begin

	------------------------------------------------------------------------- 
	-- This process will emulate the keypress of a user.  The keypress
	-- sequence is defined in the event array above.
	key_pressing: process is   

		type  phases is (MAKE_CODE, BREAK_CODE, SCAN_CODE, IDLE);
		variable phase: phases;
		constant fingerPressTime :time := 100 uS;	
		constant interKeyPause :time := 250 uS;		
		constant break2MakePause :time := 5 uS;		
		
		begin
			-- initialize the keyboard signals
			kbclk <= '1';	kbdata <= '1';	phase := IDLE;

			-- wait 100 ns before we do anything
			wait for fingerPressTime;

			-- Now, loop through all the keyboard presses in the event array
			for key_hit in 0 to N-1 loop
		
				phase := MAKE_CODE;
				CodeGen(event(key_hit), kbclk, kbdata);
				phase := IDLE;
				wait for fingerPressTime;
				phase := BREAK_CODE;
				CodeGen(break, kbclk, kbdata);
				phase := IDLE;
				wait for break2MakePause;
				phase := SCAN_CODE;
				CodeGen(event(key_hit), kbclk, kbdata);
				phase := IDLE;
				wait for interKeyPause;
			end loop; 
		wait;
	end process;
end architecture;


