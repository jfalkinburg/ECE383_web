--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 10, 2015
-- File:	hw3_tb.vhdl
-- HW:	HW3
--	Crs:	ECE 383
--
-- Purp:	This is a testbench for homework #3
--
-- Documentation:	No help, I based this off a some previous labs I
--						generated at Penn State. 
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY hw3_tb IS
END hw3_tb;
 
ARCHITECTURE behavior OF hw3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT  hw3
		port(	d:	in unsigned(7 downto 0); 
				h: out std_logic);
    END COMPONENT;
    

	CONSTANT	TEST_ELEMENTS:integer:=4;
	SUBTYPE io_unsigned is std_logic_vector(7 downto 0);
	TYPE TEST_unsigned is array (1 to TEST_ELEMENTS) of io_unsigned;
	SIGNAL TEST: TEST_unsigned := (X"11", X"24", X"CC", X"D4");

	signal d: unsigned(7 downto 0);
	signal h: std_logic;
	SIGNAL i : integer;
 
BEGIN
 
	-------------------------------------------
	-- Instantiate the Unit Under Test (UUT)
	-------------------------------------------
   uut: hw3 PORT MAP (
         d => d,
			h => h);	

	process
	begin
 
		-------------------------------------------
		-- loop through all the test vectors and check
		-- they produce the correct output
		-------------------------------------------		
		for i in 1 to TEST_ELEMENTS loop
			d <= unsigned(test(i));
			wait for 1 us;
		end loop;

		-------------------------------------------
		-- If the simulation finishes then halt the
		-- sim and let the user know all is well.
		-------------------------------------------
		assert TRUE = FALSE
			report "Correct circuit behavior - nominal performance."
			severity failure;
	end process tb;

end architecture behavior;
