library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNIMACRO;
use UNIMACRO.vcomponents.all;
use work.lab2Parts.all;		


entity lab2 is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
		   ac_mclk : out STD_LOGIC;
		   ac_adc_sdata : in STD_LOGIC;
		   ac_dac_sdata : out STD_LOGIC;
		   ac_bclk : out STD_LOGIC;
		   ac_lrclk : out STD_LOGIC;
           scl : inout STD_LOGIC;
           sda : inout STD_LOGIC;
		   tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
		   btn: in	STD_LOGIC_VECTOR(4 downto 0));
end lab2;

architecture behavior of lab2 is

	signal sw: std_logic_vector(2 downto 0);
	signal cw: std_logic_vector (2 downto 0);

	
begin


	
	datapath: lab2_datapath port map(
		clk => clk,
		reset_n => reset_n,
		ac_mclk => ac_mclk,
		ac_adc_sdata => ac_adc_sdata,
		ac_dac_sdata => ac_dac_sdata,
		ac_bclk => ac_bclk,
		ac_lrclk => ac_lrclk,
        scl => scl,
        sda => sda,
		tmds => tmds,
		tmdsb => tmdsb,
		sw => sw,
		cw => cw,
		btn => btn, 
		exWrAddr => "0000000000",
		exWen => '0',
		exSel => '0',
		Lbus_out => OPEN,
		Rbus_out => OPEN,
		exLbus => "0000000000000000",
		exRbus => "0000000000000000",		
		flagQ => OPEN,
		flagClear => "00000000");
		
			  
	control: lab2_fsm port map( 
		clk => clk,
		reset_n => reset_n,
		sw => sw,
		cw => cw);

end behavior;
