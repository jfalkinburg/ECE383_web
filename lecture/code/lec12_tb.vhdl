--------------------------------------------------------------------
-- Name:	Maj Jeff Falkinburg
-- Date:	Jan 29, 2017
-- File:	lec12_tb.vhdl
-- HW:	Lecture 12
--	Crs:	ECE 383
--
-- Purp: The testbench for lec12.vhdl datapath and control example
--
-- Documentation:	No help, though I used an example from the Digital
--						Design text book.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
--
--		The control word format 
--		5		read enable
--		4		write enable
--		3-2	byte write mask
--		1-0	counter control	00=hold	01=up		11=reset
--
------------------------------------------------------------------------- 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lec12_tb IS
END lec12_tb;

ARCHITECTURE behavior OF lec12_tb IS 

	COMPONENT lec12Dual_dp
	Port(	clk: in  STD_LOGIC;
			n_reset : in  STD_LOGIC;
			cw: std_logic_vector(5 downto 0));
	END COMPONENT;

	SIGNAL clk :  std_logic;
	SIGNAL n_reset :  std_logic;
	SIGNAL cw : std_logic_vector(5 downto 0);
   -- Clock period definitions
   constant clk_period : time := 500 ns;
	

BEGIN

	uut: lec12Dual_dp PORT MAP(
		clk => clk,
		n_reset => n_reset,
		cw => cw);
	
  -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2; 
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	n_reset <= '0', '1' after 1 us;
	
	-------------------------------------------------------------------------
	-- READ ENABLE
	cw(5) <= '1', '0' after 7 us, '1' after 8 us;
	
	-------------------------------------------------------------------------
	-- WRITE ENABLE
	cw(4) <= '1', '0' after 3 us, '1' after 4 us;
	

	-------------------------------------------------------------------------
	-- BYTE WRITE ENABLE
	cw(3 downto 2) <= "11", "10" after 4 us, "01" after 5 us, "11" after 6us;

	-------------------------------------------------------------------------
	-- COUNTER CONTROL
	cw(1 downto 0) <= "01";

END;
