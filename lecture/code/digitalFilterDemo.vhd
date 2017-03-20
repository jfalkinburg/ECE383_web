

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.digitalFilterParts.all;			

entity digitalFilterDemo is
    Port ( clk : in  STD_LOGIC;
			reset_n : in  STD_LOGIC;
			ac_mclk : out STD_LOGIC;
			ac_adc_sdata : in STD_LOGIC;
			ac_dac_sdata : out STD_LOGIC;
			ac_bclk : out STD_LOGIC;
			ac_lrclk : out STD_LOGIC;
			scl : inout STD_LOGIC;
			sda : inout STD_LOGIC;
			filter_switch: in STD_LOGIC_VECTOR(1 downto 0));
end digitalFilterDemo;

architecture struct of digitalFilterDemo is

	signal LdacValue, RdacValue, LadcValue, RadcValue: std_logic_vector(17 downto 0);	
	signal L_filter_lpf1000, R_filter_lpf1000 : std_logic_vector(17 downto 0);					
	signal ready: std_logic;

begin

Audio_Codec : Audio_Codec_Wrapper
    Port map ( clk => clk,
        reset_n => reset_n, 
        ac_mclk => ac_mclk,
        ac_adc_sdata => ac_adc_sdata,
        ac_dac_sdata => ac_dac_sdata,
        ac_bclk => ac_bclk,
        ac_lrclk => ac_lrclk,
        ready => ready,
        L_bus_in => LdacValue, -- left channel input to DAC
        R_bus_in => RdacValue, -- right channel input to DAC
        L_bus_out => LadcValue, -- left channel output from ADC
        R_bus_out => RadcValue, -- right channel output from ADC
        scl => scl,
        sda => sda);
	

	left_filter_lpf1000: entity work.IIR_Biquad(arch)
		-- low pass  2nd order butt  fl = 1000Hz, Fs = 48000Hz
		-- http://www.earlevel.com/main/2013/10/13/biquad-calculator-v2/
		generic map	(	Coef_b0 => B"00_00_0000_0100_0000_0010_1001_0110_1101", 		-- +0.003916127	
							Coef_b1 => B"00_00_0000_1000_0000_0101_0010_1101_1010",		-- +0.007832253	
							Coef_b2 => B"00_00_0000_0100_0000_0010_1001_0110_1101",		-- +0.003916127	
							Coef_a1 => B"10_00_1011_1101_0001_0111_0011_1010_0010",		-- -1.815341083	
							Coef_a2 => B"00_11_0101_0010_1111_0011_0010_0001_0001")		-- +0.831005589
			
		port map (clk => clk, 
			n_reset => reset_n, 
			sample_trig => ready, 
			X_in => LadcValue, 
			filter_done => OPEN, 
			Y_out => L_filter_lpf1000);
		
	right_filter_lpf1000: entity work.IIR_Biquad(arch)
		generic map	(	Coef_b0 => B"00_00_0000_0100_0000_0010_1001_0110_1101", 		-- +0.003916127	
							Coef_b1 => B"00_00_0000_1000_0000_0101_0010_1101_1010",		-- +0.007832253	
							Coef_b2 => B"00_00_0000_0100_0000_0010_1001_0110_1101",		-- +0.003916127	
							Coef_a1 => B"10_00_1011_1101_0001_0111_0011_1010_0010",		-- -1.815341083	
							Coef_a2 => B"00_11_0101_0010_1111_0011_0010_0001_0001")		-- +0.831005589	
		port map (
			clk => clk, 
			n_reset => reset_n, 
			sample_trig => ready, 
			X_in => RadcValue,
			filter_done => OPEN,
			Y_out => R_filter_lpf1000);



	process (clk)
	begin
		if (rising_edge(clk)) then
			if reset_n = '0' then
				LdacValue <= (others => '0');
				RdacValue <= (others => '0');
			elsif(ready = '1') then
				if (filter_switch = "00") then
					LdacValue <= LadcValue;
					RdacValue <= RadcValue;			
				else	 
					LdacValue <= L_filter_lpf1000;
					RdacValue <= R_filter_lpf1000;
				end if;
			end if;
		end if;
	end process;
	
end struct;
