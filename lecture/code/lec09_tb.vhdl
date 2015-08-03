--------------------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 28, 2015
-- File:	lec09_tb.vhdl
-- HW:	Lecture 9
--	Crs:	ECE 383
--
-- Purp:	testbench for lec09.vhdl
--
-- Documentation:	This was genetrated almost exclusively from ISE testbench 
--						generator.  The tool was at a complete loss when it came
--						to the unsigned data type of Q and D.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY lec09_tb IS
END lec09_tb;
 
ARCHITECTURE behavior OF lec09_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT  lec09 is
		Port(	clk: in  STD_LOGIC;
				reset : in  STD_LOGIC;
				sw: in STD_LOGIC_VECTOR(2 downto 0);
				cw: out STD_LOGIC_VECTOR(4 downto 0));
    END COMPONENT;
    
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal sw : std_logic_vector(2 downto 0) := (others => '0');
   signal cw : std_logic_vector(4 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 500 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lec09 PORT MAP (
          clk => clk,
          reset => reset,
          sw => sw,
          cw => cw);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
 
 	------------------------------------------------------------------------------
	-- 		MEMORY INPUT EQUATIONS
	-- 
	--		bit 2				bit 1				bit 0
	--		RFID scan		Cow Present		Timer Status
	--		1-cow checked	1-cow				0 - running
	--		0-waiting		0-no cow			1 - times up
 	------------------------------------------------------------------------------
	sw <= "000", "010" after 6us, "110" after 8us, "011" after 10us, "000" after 14us;
	

	reset <= '0', '1' after 1us;

END;
