--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- File:	lec11_dp.vhdl
-- HW:	Lecture 11
--	Crs:	ECE 383
--
-- Purp:	Most of the datapath for the keyboard scan circuit
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


entity lec11_dp is
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			cw: in std_logic_vector(2 downto 0);
			sw: out std_logic;
			kbData : in std_logic;
			scan: out std_logic_vector (7 downto 0));
end lec11_dp;

architecture behavior of lec11_dp is

	signal shiftReg : std_logic_vector(10 downto 0);
	signal keyCntr: unsigned (5 downto 0);
	
begin
	
	
	-----------------------------------------------------------------------------
	--		The counter tells us which bit we are processing
	--		00			hold
	--		01			count up
	--		10			unused
	--		11			synch reset
	-----------------------------------------------------------------------------
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '0') then
				keyCntr <= (others => '0');
			elsif (cw(1 downto 0) = "01") then
				keyCntr <= keyCntr + 1;
			elsif (cw(1 downto 0) = "11") then
				keyCntr <= (others => '0');
			end if;
		end if;
	end process;
 
 	-----------------------------------------------------------------------------
	-- Implements the comparator to tell the FSM when we have gotten a complete
	-- key press and release
 	-----------------------------------------------------------------------------
	sw <= '1' when (keyCntr = 33) else '0';
	
	
 	-----------------------------------------------------------------------------
	--		The shift register keeps only 11-bits 
	--		0			hold
	--		1			shift right (data comes in at the MSB)
	-----------------------------------------------------------------------------
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '0') then
				shiftReg <= (others => '0');
			elsif (cw(2) = '1') then
				shiftReg <= kbData & shiftReg (10 downto 1);
			end if;
		end if;
	end process;
	
	scan <= shiftReg(8 downto 1);
	
end behavior;