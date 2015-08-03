--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 6, 2015
-- File:	majority.tb.vhdl
-- HW:	Lecture 2
--	Crs:	ECE 383
--
-- Purp:	This is a testbench for the majority circuti designed
--			for homework #1
--
-- Documentation:	No help, I based this off a some previous labs I
--						generated at Penn State.  I also consulted
--						page 36 of our text for some useful syntax.	
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

ENTITY majority_tb IS
END majority_tb;
 
ARCHITECTURE behavior OF majority_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT majority
    PORT(	a : IN  std_logic;
				b : IN  std_logic;
				c : IN  std_logic;
				f : OUT  std_logic);
    END COMPONENT;
    
   signal a, b, c, f: std_logic;
	signal testVector: std_logic_vector(2 downto 0);
	
	CONSTANT	TEST_ELEMENTS:integer:=8;
	SUBTYPE INPUT is std_logic_vector(2 downto 0);
	TYPE TEST_INPUT_VECTOR is array (1 to TEST_ELEMENTS) of INPUT;
	SIGNAL TEST_INPUT: TEST_INPUT_VECTOR := ("000", "001", "010", "011", "100", "101", "110", "111");

	SUBTYPE OUTPUT is std_logic;
	TYPE TEST_OUTPUT_VECTOR is array (1 to TEST_ELEMENTS) of OUTPUT;
	SIGNAL TEST_OUTPUT: TEST_OUTPUT_VECTOR := ('0', '0', '0', '1', '0', '1', '1', '1');
	
	SIGNAL i : integer;
 
BEGIN
 
	-------------------------------------------
	-- Instantiate the Unit Under Test (UUT)
	-------------------------------------------
   uut: majority PORT MAP (
          a => a,
          b => b,
          c => c,
          f => f);

	-------------------------------------------
	-- break down the 3-bit vector into components
	-------------------------------------------	
	a <= testVector(2);
	b <= testVector(1);
	c <= testVector(0);
	

	process
	begin
 
		-------------------------------------------
		-- loop through all the test vectors and check
		-- they produce the correct output
		-------------------------------------------		
		for i in 1 to TEST_ELEMENTS loop
			testVector <= test_input(i);
			wait for 1 us;
			-------------------------------------------
			-- If these two don't match the simulation will halt
			-------------------------------------------		
			assert f = test_output(i)
				report "Error in majority circuit for input "  & integer'image(i)
				severity failure;
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
