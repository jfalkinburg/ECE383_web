--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 10, 2015
-- File:	lec04.vhdl
-- HW:	Lecture 4
--	Crs:	ECE 383
--
-- Purp:	Demos the use of processes
--
-- Documentation:	I pulled some information from chapter .
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


entity lec10 is
	generic (N: integer := 4);
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			crtl: in std_logic_vector(1 downto 0);
			D: in unsigned (N-1 downto 0);
			Q: out unsigned (N-1 downto 0));
end lec10;

architecture behavior of lec10 is
	
	signal processQ: unsigned (N-1 downto 0);

begin
	
	
	-----------------------------------------------------------------------------
	--		crtl
	--		00			hold
	--		01			count up mod 10
	--		10			load D
	--		11			synch reset
	-----------------------------------------------------------------------------
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '0') then
				processQ <= (others => '0');
			elsif (crtl = "01") then
				processQ <= processQ + 1;
			elsif (crtl = "10") then
				processQ <= unsigned(D);
			elsif (crtl = "11") then
				processQ <= (others => '0');
			end if;
		end if;
	end process;
 
	Q <= processQ;
	
end behavior;