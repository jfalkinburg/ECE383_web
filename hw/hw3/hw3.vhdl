--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 8, 2015
-- File:	hw3.vhdl
-- HW:	HW3
--	Crs:	ECE 383
--
-- Purp:	Create a digital circuit that takes as input a 8-bit unsigned 
--			value (provided by the DIP switches) and illuminates an LED if 
--			the input is a multiple of 17. Do NOT use the remainder or division 
--			operations, this can easily be accomplished using a single conditional 
--			signal assignment statement.
--
--	Turn: A hardcopy of your VHDL file (include a proper header).
-- 		A hardcopy of a timing diagram from Isim showing several inputs and the output.
-- 		A hardcopy of your UCF file.
-- 		Demo your circuit in class.
--
-- Documentation:	No help, I based this off the class notes and readings.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;		
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL; 

entity hw3 is
	port(	d:	in unsigned(7 downto 0); 
			h: out std_logic);
end hw3;

architecture structure of hw3 is

begin

	h <=	'1' when d = 17 else
			'1' when d = 34 else
			'1' when d = 51 else
			'1' when d = 68 else
			'1' when d = 85 else
			'1' when d = 102 else
			'1' when d = 119 else
			'1' when d = 136 else
			'1' when d = 153 else
			'1' when d = 170 else
			'1' when d = 187 else
			'1' when d = 204 else
			'1' when d = 221 else
			'1' when d = 238 else		
			'1' when d = 255 else	
			'0';
	
end structure;
