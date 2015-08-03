--
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package digitalFilterParts is

--/////////////////////// AC97 Driver //////////////////////////////////--


component IIR_Biquad
		generic(	Coef_b0 : std_logic_vector(31 downto 0);
					Coef_b1 : std_logic_vector(31 downto 0);
					Coef_b2 : std_logic_vector(31 downto 0);
					Coef_a1 : std_logic_vector(31 downto 0);
					Coef_a2 : std_logic_vector(31 downto 0));
		Port ( 
				clk : in  STD_LOGIC;
				n_reset : in  STD_LOGIC;
				sample_trig : in  STD_LOGIC;
				X_in : in  STD_LOGIC_VECTOR (17 downto 0);
				filter_done : out STD_LOGIC;
				Y_out : out  STD_LOGIC_VECTOR (17 downto 0)
				);
end component;


component ac97 
	port (
		n_reset        : in  std_logic;
		clk            : in  std_logic;
																				-- ac97 interface signals
		ac97_sdata_out : out std_logic;								-- ac97 output to SDATA_IN
		ac97_sdata_in  : in  std_logic;								-- ac97 input from SDATA_OUT
		ac97_sync      : out std_logic;								-- SYNC signal to ac97
		ac97_bitclk    : in  std_logic;								-- 12.288 MHz clock from ac97
		ac97_n_reset   : out std_logic;								-- ac97 reset for initialization [active low]
		ac97_ready_sig : out std_logic; 								-- pulse for one cycle
		L_out          : in  std_logic_vector(17 downto 0);	-- lt chan output from ADC
		R_out          : in  std_logic_vector(17 downto 0);	-- rt chan output from ADC
		L_in           : out std_logic_vector(17 downto 0);	-- lt chan input to DAC
		R_in           : out std_logic_vector(17 downto 0);	-- rt chan input to DAC
		latching_cmd	: in std_logic;
		cmd_addr       : in  std_logic_vector(7 downto 0);		-- cmd address coming in from ac97cmd state machine
		cmd_data       : in  std_logic_vector(15 downto 0) 	-- cmd data coming in from ac97cmd state machine
		);
end component;


--/////////////// STATE MACHINE TO CONFIGURE THE AC97 ///////////////////////////--

component ac97cmd 
	port (
		 clk      			: in  std_logic;
		 ac97_ready_sig   : in  std_logic;
		 cmd_addr 			: out std_logic_vector(7 downto 0);
		 cmd_data 			: out std_logic_vector(15 downto 0);
		 latching_cmd		: out std_logic;
		 volume   			: in  std_logic_vector(4 downto 0);  			-- input for encoder for volume control 0->31
		 source   			: in  std_logic_vector(2 downto 0)); 			-- 000 = Mic, 100=LineIn
end component;


component ac97_wrapper
	port (
		reset        : in  std_logic;
		clk            : in  std_logic;	
		ac97_sdata_out : out std_logic;								-- ac97 output to SDATA_IN
		ac97_sdata_in  : in  std_logic;								-- ac97 input from SDATA_OUT
		ac97_sync      : out std_logic;								-- SYNC signal to ac97
		ac97_bitclk    : in  std_logic;								-- 12.288 MHz clock from ac97
		ac97_n_reset   : out std_logic;								-- ac97 reset for initialization [active low]
		ac97_ready_sig : out std_logic; 								-- pulse for one cycle
		L_out          : in  std_logic_vector(17 downto 0);	-- lt chan output from ADC
		R_out          : in  std_logic_vector(17 downto 0);	-- rt chan output from ADC
		L_in           : out std_logic_vector(17 downto 0);	-- lt chan input to DAC
		R_in           : out std_logic_vector(17 downto 0));	-- rt chan input to DAC
end component;



end digitalFilterParts;
