--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 5, 2015
-- File:	lec12_dp.vhdl
-- HW:	Lecture 12
--	Crs:	ECE 383
--
-- Purp:	A datapath integrating a small RAM in preparation for Lab 2
--
-- Documentation:	I pulled the BRAM example from the Xilinx technical
--						documents.  They were significantly modified to get
--						get them into their current form.
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
library IEEE;		
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;				-- contains the unsigned data type 
library UNIMACRO;							-- This contains links to the Xilinx block RAM
use UNIMACRO.vcomponents.all;

entity lec12Dual_dp is
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			cw: std_logic_vector(5 downto 0));
end lec12Dual_dp;

architecture behavior of lec12Dual_dp is

	signal writeInput, readOutput: std_logic_vector(17 downto 0);
	signal addrWrite, addrRead: unsigned(9 downto 0);
	signal vecAddrWrite, vecAddrRead : std_logic_vector(9 downto 0);

	signal n_reset: std_logic;

begin		

	-----------------------------------------------------------------------------
	--		The address counter sends in an address
	--		00			hold
	--		01			count up
	--		10			unused
	--		11			synch reset
	-----------------------------------------------------------------------------
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '0') then
				addrWrite <= (others => '0');
			elsif (cw(1 downto 0) = "01") then
				addrWrite <= addrWrite + 1;
			elsif (cw(1 downto 0) = "11") then
				addrWrite <= (others => '0');
			end if;
		end if;
	end process;

	addrRead <= addrWrite - 1;							-- Have the read follow the writes
	writeInput <= "10101010101010" & vecAddrWrite(3 downto 0);		-- Provide some changing data input
	
	n_reset <= not reset;								-- BRAM reset is active high
	vecAddrWrite <= std_logic_vector(addrWrite);	-- type conversion (address are std_logic_vector)
	vecAddrRead <= std_logic_vector(addrRead);	
	
	----------------------------------------------------------------------------	
	-- Reference:	Spartan-6 Libraries Guide for HDL Designs
	-- 				UG615 (v 12.4) December 14, 2010
	--	Note:			Do not waste your time with the December 2, 2009 version
	-- Page:			10
	-----------------------------------------------------------------------------	
	sampleMemory: BRAM_SDP_MACRO
		generic map (
			BRAM_SIZE => "18Kb", 						-- Target BRAM, "9Kb" or "18Kb"
			DEVICE => "SPARTAN6", 						-- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
			DO_REG => 0, 									-- Optional output register disabled
			INIT => X"000000000000000000",			-- Initial values on output port
			INIT_FILE => "NONE",							-- Not sure how to initialize the RAM from a file
			WRITE_WIDTH => 18, 							-- Valid values are 1-36
			READ_WIDTH => 18, 							-- Valid values are 1-36
			SIM_COLLISION_CHECK => "NONE", 			-- Simulation collision check
			SRVAL => X"000000000000000000")			-- Set/Reset value for port output
		port map (
			DO => readOutput,								-- Output read data port, width defined by READ_WIDTH parameter
			RDADDR => vecAddrRead,						-- Input address, width defined by port depth
			RDCLK => clk,	 								-- 1-bit input clock
			RST => n_reset,								-- active high reset
			RDEN => cw(5),									-- read enable 
			REGCE => '1',									-- 1-bit input read output register enable - ignored
			DI => writeInput,								-- Input data port, width defined by WRITE_WIDTH parameter
			WE => cw(3 downto 2),						-- since RAM is byte read, this determines high or low byte
			WRADDR => vecAddrWrite,						-- Input write address, width defined by write port depth
			WRCLK => clk,								 	-- 1-bit input write clock
			WREN => cw(4));					 			-- 1-bit input write port enable
	
end behavior;