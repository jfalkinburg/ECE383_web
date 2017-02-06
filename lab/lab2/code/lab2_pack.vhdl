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

package lab2Parts is


component lab2 
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
end component;

component flagRegister 
	Generic (N: integer := 8);
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			set, clear: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0));
end component;

--/////////////////////// Audio Codec Wrapper //////////////////////////////////--

component Audio_Codec_Wrapper 
    Port ( clk : in STD_LOGIC;
        reset_n : in STD_LOGIC;
        ac_mclk : out STD_LOGIC;
        ac_adc_sdata : in STD_LOGIC;
        ac_dac_sdata : out STD_LOGIC;
        ac_bclk : out STD_LOGIC;
        ac_lrclk : out STD_LOGIC;
        ready : out STD_LOGIC;
        L_bus_in : in std_logic_vector(17 downto 0); -- left channel input to DAC
        R_bus_in : in std_logic_vector(17 downto 0); -- right channel input to DAC
        L_bus_out : out  std_logic_vector(17 downto 0); -- left channel output from ADC
        R_bus_out : out  std_logic_vector(17 downto 0); -- right channel output from ADC
        scl : inout STD_LOGIC;
        sda : inout STD_LOGIC);
end component;


component lab2_fsm
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
			  sw: in std_logic_vector(2 downto 0);
			  cw: out std_logic_vector (2 downto 0) );
end component;


component lab2_datapath
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
	sw: out std_logic_vector(2 downto 0);
	cw: in std_logic_vector (2 downto 0);
	btn: in	STD_LOGIC_VECTOR(4 downto 0);
	exWrAddr: in std_logic_vector(9 downto 0);
	exWen, exSel: in std_logic;
	Lbus_out, Rbus_out: out std_logic_vector(15 downto 0);
	exLbus, exRbus: in std_logic_vector(15 downto 0);
	flagQ: out std_logic_vector(7 downto 0);
	flagClear: in std_logic_vector(7 downto 0));

end component;


	component video is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  trigger_time: in unsigned(9 downto 0);
			  trigger_volt: in unsigned (9 downto 0);
			  row: out unsigned(9 downto 0);
			  column: out unsigned(9 downto 0);
			  ch1: in std_logic;
			  ch1_enb: in std_logic;
			  ch2: in std_logic;
			  ch2_enb: in std_logic);
	end component;
	

end lab2Parts;
