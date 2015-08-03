--------------------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 30, 2015
-- File:	lec10_tb.vhdl
-- Event: Lecture 10
--	Crs:	ECE 383
--
-- Purp:	testbench for lec10.vhdl
--
-- Documentation:	I borrowed heavily from lec04_tb, with the inclusion
--						of the new generic statement which I just remembered.
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
 
ENTITY lec10_tb IS
END lec10_tb;
 
ARCHITECTURE behavior OF lec10_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lec10
		generic (N: integer := 4);
		Port(	clk: in  STD_LOGIC;
				reset : in  STD_LOGIC;
				crtl: in std_logic_vector(1 downto 0);
				D: in unsigned (N-1 downto 0);
				Q: out unsigned (N-1 downto 0));
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal crtl : std_logic_vector(1 downto 0) := (others => '0');
   signal D : unsigned(4 downto 0) := (others => '0');

 	--Outputs
   signal Q : unsigned(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 500 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lec10 
	Generic map(5)
	PORT MAP (
          clk => clk,
          reset => reset,
			 crtl => crtl,
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
	--		crtl
	--		00			hold
	--		01			count up mod 10
	--		10			load D
	--		11			synch reset
	-----------------------------------------------------------------------------
	crtl <= "01", "10" after 5us, "01" after 6us, "01" after 10us, "11" after 11us, "01" after 12us;
	D <= "11100";
	reset <= '0', '1' after 1us;

END;