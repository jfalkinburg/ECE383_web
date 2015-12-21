------------------------------------------
-- Comments start with two dashes
-- You should always have the following
-- three lines in all of your code
-- Author:	Capt Jeff Falkinburg
-- Date:	Spring 2016
-- Purp:	Majority circuit
------------------------------------------
library IEEE;						-- These lines are similar to a #include in C
use IEEE.std_logic_1164.all;

entity majority is
        port(	a, b, c:	in std_logic; 
					f:   		out std_logic);
end majority;

architecture structure of majority is
signal	s1, s2, s3: std_logic;	-- wires which begin and end in the component

begin 
	s1 <= a and b;			-- These statements are called
	s2 <= b and c;			-- concurrent signal assignments.
	s3 <= a and c;			-- They all happen at the same time
	f <= s1 or s2 or s3;	-- unlike a regular programming lang.
end structure;
 