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

end digitalFilterParts;
