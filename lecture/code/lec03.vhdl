--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 10, 2015
-- File:	hw3.vhdl
-- HW:	Lecture 3
--	Crs:	ECE 383
--
-- Purp:	This 
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

entity lec3 is
	port(	au, bu:	in unsigned(3 downto 0); 
			cu,du,su:	out unsigned(3 downto 0); 
			as, bs: in signed(3 downto 0);
			cs,ds,ss:	out signed(3 downto 0));
end lec3;

architecture structure of lec3 is

begin

	cu <= "1000" when (au > bu) else 
			"0110" when (au = bu) else
			"0001";		
	su <= au + bu;
	du <= au - bu;
	
	cs <= "1000" when (as > bs) else 
			"0110" when (as = bs) else
			"0001";
	ss <= as + bs;
	ds <= as - bs;
	
end structure;
