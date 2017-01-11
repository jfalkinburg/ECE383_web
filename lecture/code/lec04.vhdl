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


entity lec4 is
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			ctrl: in std_logic_vector(1 downto 0);
			D: in unsigned (3 downto 0);
			Q: out unsigned (3 downto 0));
end lec4;

architecture behavior of lec4 is
	
	signal rollSynch, rollCombo: STD_LOGIC;
	signal processQ: unsigned (3 downto 0);

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
			if (reset = '0') then
				processQ <= (others => '0');
				rollSynch <= '0';
			elsif ((processQ < 9) and (ctrl = "01")) then
				processQ <= processQ + 1;
				rollSynch <= '0';
			elsif ((processQ = 9) and (ctrl = "01")) then
				processQ <= (others => '0');
				rollSynch <= '1';
			elsif (ctrl = "10") then
				processQ <= unsigned(D);
			elsif (ctrl = "11") then
				processQ <= (others => '0');
			end if;
		end if;
	end process;
 
	-- CSA
	rollCombo  <= '1' when (processQ = 9) else '0';
	Q <= processQ;
	
end behavior;