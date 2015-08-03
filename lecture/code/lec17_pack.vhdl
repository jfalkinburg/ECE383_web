--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package lec17Parts is

	component lec10 is
		generic (N: integer := 4);
		Port(	clk: in  STD_LOGIC;
				reset : in  STD_LOGIC;
				crtl: in std_logic_vector(1 downto 0);
				D: in unsigned (N-1 downto 0);
				Q: out unsigned (N-1 downto 0));
	end component;
	
end package;