--------------------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 10, 2015
-- File:	lec04_tb.vhdl
-- HW:	Lecture 4
--	Crs:	ECE 383
--
-- Purp:	testbench for lec4.vhdl
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
 
ENTITY lec4_tb IS
END lec4_tb;
 
ARCHITECTURE behavior OF lec4_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lec4
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
			ctrl: in std_logic_vector(1 downto 0);
         D : IN  unsigned(3 downto 0);
         Q : OUT  unsigned(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal ctrl : std_logic_vector(1 downto 0) := (others => '0');
   signal D : unsigned(3 downto 0) := (others => '0');

 	--Outputs
   signal Q : unsigned(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 500 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lec4 PORT MAP (
          clk => clk,
          reset => reset,
			 ctrl => ctrl,
          D => D,
          Q => Q
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
 	-----------------------------------------------------------------------------
	--		ctrl
	--		00			hold
	--		01			count up mod 10
	--		10			load D
	--		11			synch reset
	-----------------------------------------------------------------------------
	ctrl <= "01", "10" after 15us, "01" after 16us, "11" after 17us, "01" after 18us, "00" after 19us, "01" after 20us;
	D <= "1110";
	reset <= '0', '1' after 1us;

END;
