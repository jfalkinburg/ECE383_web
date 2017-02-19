--------------------------------------------------------------------
-- Name:	Maj Jeff Falkinburg
-- Date:	Feb 16, 2017
-- File:	lec18.vhdl
-- HW:		Lecture 18
--	Crs:	ECE 383
--
-- Purp:	Will interface this counter to the microBlaze
--
-- Documentation:	I pulled this from Lecture 10 to demonstrate that
--						you do not have to do anything special to interface
--						existing hardware designs with the microBlaze.
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
			reset_n : in  STD_LOGIC;
			ctrl: in std_logic_vector(1 downto 0);
			D: in unsigned (N-1 downto 0);
			Q: out unsigned (N-1 downto 0));
end lec10;

architecture behavior of lec10 is
	
	signal processQ: unsigned (N-1 downto 0);

begin

	-----------------------------------------------------------------------------
	--		ctrl
	--		00			hold
	--		01			count up mod 10
	--		10			load D
	--		11			synch reset
	-----------------------------------------------------------------------------
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				processQ <= (others => '0');
			elsif (ctrl = "01") then
				processQ <= processQ + 1;
			elsif (ctrl = "10") then
				processQ <= unsigned(D);
			elsif (ctrl = "11") then
				processQ <= (others => '0');
			end if;
		end if;
	end process;
 
	Q <= processQ;
	
end behavior;
