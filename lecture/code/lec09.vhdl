--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 15, 2015
-- File:	lec09.vhdl
-- HW:	Lecture 9
--	Crs:	ECE 383
--
-- Purp:	Demonstrate finite state machine construction with DAISY
--
-- Documentation:	No help, though I used an example from my Digital
--						Design text book.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lec09 is
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			sw: in STD_LOGIC_VECTOR(2 downto 0);
			cw: out STD_LOGIC_VECTOR(4 downto 0));
end lec09;



architecture behavior of lec09 is

	type state_type is (WaitEnter, WaitRead, Set30, WaitLeave, Set3, Goose);
	signal state: state_type;
	
	constant rfid: integer := 2;		-- helps keep status bits straight
	constant cow: integer := 1;
	constant timer: integer := 0;
	
begin
	
	------------------------------------------------------------------------------
	-- 		MEMORY INPUT EQUATIONS
	-- 
	--		bit 2				bit 1				bit 0
	--		RFID scan		Cow Present		Timer Status
	--		1-cow checked	1-cow				0 - running
	--		0-waiting		0-no cow			1 - times up
	------------------------------------------------------------------------------	
    state_process: process(clk,reset)
	 begin
		if (rising_edge(clk)) then
			if (reset = '0') then 
				state <= WaitEnter;
			else
				case state is
					when WaitEnter =>
						if (sw(cow) = '1') then state <= WaitRead; end if;
					when WaitRead =>
						if (sw(rfid) = '1') then state <= Set30; end if;
					when Set30 =>
						state <= WaitLeave;					
					when WaitLeave =>
						if 	(sw(cow) = '0') then state <= WaitEnter;
						elsif (sw(timer) = '1' and sw(cow) = '1') then state <= Set3; end if;
					when Set3 =>
						state <= Goose;
					when Goose =>
						if (sw(timer) = '1') then state <= Set30; end if;					
				end case;
			end if;
		end if;
	end process;


	------------------------------------------------------------------------------
	--			OUTPUT EQUATIONS
	--	
	--		bit 4			bit 3			bit 2,1					bit 0
	--		Gate1			Gate2			Timer						Control Air
	--		1-gate up	1-gate up	00 Stop timer			0 - closed
	--		0-gate down	0-gate down	01 Set to 30 secs		1 - open
	--										10 Set to 3 secs	
	--										11 Run timer	
	------------------------------------------------------------------------------	
	cw <= "10000" when state = WaitEnter else
			"00000" when state = WaitRead else
			"01010" when state = Set30 else 
			"01000" when state = WaitLeave else
			"01100" when state = Set3 else
			"01111"; -- when state = Goose;

end behavior;	