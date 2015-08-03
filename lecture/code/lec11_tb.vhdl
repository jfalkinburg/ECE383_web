--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- File:	lec11_tb.vhdl
-- HW:	Lecture 11
--	Crs:	ECE 383
--
-- Purp: The testbench for lec11.vhdl keyboard scancode reader
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lec11_tb IS
END lec11_tb;

ARCHITECTURE behavior OF lec11_tb IS 

	COMPONENT lec11
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			kbClk: in std_logic;
			kbData: in std_logic;
			scan: out std_logic_vector(7 downto 0);
			busy: out std_logic);
	END COMPONENT;

	component keyboard is
		port (kbclk, kbdata: out std_logic);
	end component;

	SIGNAL clk :  std_logic;
	SIGNAL reset :  std_logic;
	SIGNAL kbclk :  std_logic;
	SIGNAL kbdata :  std_logic;
	SIGNAL busy :  std_logic;
	SIGNAL scan :  std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 500 ns;


BEGIN

	uut: lec11 PORT MAP(
		clk => clk,
		reset => reset,
		kbclk => kbclk,
		kbdata => kbdata,
		busy => busy,
		scan => scan);
	
	sim: keyboard port map (
		kbclk => kbclk,
		kbdata => kbdata);

  -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2; 
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	reset <= '0', '1' after 2 us;
	

END;
