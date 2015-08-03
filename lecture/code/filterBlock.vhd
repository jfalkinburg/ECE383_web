--////////////////////// IIR_Biquad_I //////////////////////////////////--
-- ***********************************************************************
-- FileName: IIR_Biquad_1.vhd
-- FPGA: Xilinx Spartan 6
-- IDE: Xilinx ISE 13.1 
--
-- HDL IS PROVIDED "AS IS." DIGI-KEY EXPRESSLY DISCLAIMS ANY
-- WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
-- PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
-- BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
-- DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
-- PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
-- BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
-- ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
-- DIGI-KEY ALSO DISCLAIMS ANY LIABILITY FOR PATENT OR COPYRIGHT
-- INFRINGEMENT.
--
-- Version History
-- Version 1.0 7/31/2012 Tony Storey
-- Initial Public Releaselibrary ieee;


-- This biquad is set up for 18 bit input words with 32 bit coefficients


library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity IIR_Biquad is
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
end IIR_Biquad;

architecture arch of IIR_Biquad is
	-- define each pre gain sample flip flop
	signal ZFF_X0, ZFF_X1, ZFF_X2, ZFF_Y1, ZFF_Y2 : std_logic_vector(17 downto 0) := (others => '0');

	-- define each post gain 64 bit sample
	signal pgZFF_X0_quad, pgZFF_X1_quad, pgZFF_X2_quad, pgZFF_Y1_quad, pgZFF_Y2_quad  : std_logic_vector( 49 downto 0) := (others => '0');

	-- define each post gain 32 but truncated sample
	signal pgZFF_X0, pgZFF_X1, pgZFF_X2, pgZFF_Y1, pgZFF_Y2 : std_logic_vector(17 downto 0) := (others => '0');

	-- define output double reg
	signal Y_out_double : std_logic_vector( 17 downto 0) := (others => '0');
	
	-- state machine signals
	type state_type is (idle, run);
	signal state_reg, state_next : state_type;
	
	-- counter signals
	signal q_reg, q_next : unsigned(2 downto 0);
	signal q_reset, q_add : std_logic;

	-- data path flags
	signal mul_coefs, trunc_prods, sum_stg_a, trunc_out : std_logic;

begin

	-- process to shift samples
	process(clk, n_reset, Y_out_double, sample_trig)
	begin
		if(n_reset = '0') then
			ZFF_X0 <= (others => '0'); 
			ZFF_X1 <= (others => '0'); 
			ZFF_X2 <= (others => '0');
			ZFF_Y1 <= (others => '0'); 
			ZFF_Y2 <= (others => '0');

		elsif(rising_edge(clk)) then
			if(sample_trig = '1') then
				ZFF_X0 <= X_in(17) & X_in(17 downto 1);
				ZFF_X1 <= ZFF_X0;
				ZFF_X2 <= ZFF_X1;
				ZFF_Y1 <= Y_out_double;								
				ZFF_Y2 <= ZFF_Y1;
			end if;	
		end if;
	end process;
	
	
   -- STATE UPDATE AND TIMING
	process(clk, n_reset) 
   begin
		if(n_reset = '0') then
			state_reg <= idle;                                    
         q_reg <= (others => '0');                               -- reset counter
		elsif (rising_edge(clk))  then
			state_reg <= state_next;                                -- update the state
         q_reg <= q_next;
		end if;
	end process;
	
	
	-- COUNTER FOR TIMING 
	q_next <= (others => '0') when q_reset = '1' else               -- resets the counter 
							q_reg + 1 when q_add = '1' else                 -- increment count if commanded
							q_reg;  	
	
	
	-- process for control of data path flags
	process( q_reg, state_reg, sample_trig)
	begin
		
		-- defaults
		q_reset <= '0';
		q_add <= '0';
		mul_coefs <= '0';
		trunc_prods <= '0';
		sum_stg_a <= '0';
		trunc_out <= '0';
		filter_done <= '0';
		
		case state_reg is
		
		when idle =>
			
			if(sample_trig = '1') then
				state_next <= run;
			else
				state_next <= idle;
			end if;
			
		when run =>	
		
			if( q_reg < "001") then		  

				q_add <= '1';
				state_next <= run;
			elsif( q_reg < "011") then
				mul_coefs <= '1';
				q_add <= '1';
				state_next <= run;
			elsif( q_reg < "100") then
				trunc_prods <= '1';
				q_add <= '1';
				state_next <= run;
			elsif( q_reg < "101") then
				sum_stg_a <= '1';
				q_add <= '1';
				state_next <= run;
			elsif( q_reg < "110") then
				trunc_out <= '1';
				q_add <= '1';
				state_next <= run;				
			else
				q_reset <= '1';
				filter_done <= '1';
				state_next <= idle;
			end if;
			
		end case;
	end process;
		
	-- add gain factors to numerator of biquad (feed forward path)
	pgZFF_X0_quad <= std_logic_vector( signed(Coef_b0) * signed(ZFF_X0)) when mul_coefs = '1';
	pgZFF_X1_quad <= std_logic_vector( signed(Coef_b1) * signed(ZFF_X1)) when mul_coefs = '1';
	pgZFF_X2_quad <= std_logic_vector( signed(Coef_b2) * signed(ZFF_X2)) when mul_coefs = '1';

	-- add gain factors to denominator of biquad (feed back path)
	pgZFF_Y1_quad <= std_logic_vector( signed(Coef_a1) * signed(ZFF_Y1)) when mul_coefs = '1';
	pgZFF_Y2_quad <= std_logic_vector( signed(Coef_a2) * signed(ZFF_Y2)) when mul_coefs = '1';
	
	

	-- truncate the output to summation block
	process(clk, trunc_prods, pgZFF_X0_quad, pgZFF_X1_quad, pgZFF_X2_quad, pgZFF_Y1_quad, pgZFF_Y2_quad)
	begin
		if rising_edge(clk) then
			if (trunc_prods = '1') then	
				pgZFF_X0 <= pgZFF_X0_quad(47 downto 30);	
				pgZFF_X2 <= pgZFF_X2_quad(47 downto 30);
				pgZFF_X1 <= pgZFF_X1_quad(47 downto 30);
				pgZFF_Y1 <= pgZFF_Y1_quad(47 downto 30);
				pgZFF_Y2 <= pgZFF_Y2_quad(47 downto 30);
			end if;
		end if;
	end process;
		
	-- sum all post gain feedback and feedfoward paths
	-- Y[z] = X[z]*bo + X[z]*b1*Z^-1 + X[z]*b2*Z^-2 - Y[z]*a1*z^-1 + Y[z]*a2*z^-2
	process(clk, sum_stg_a)
	begin
		if(rising_edge(clk)) then
			if(sum_stg_a = '1') then
				Y_out_double <= std_logic_vector(signed(pgZFF_X0) + signed(pgZFF_X1) + signed(pgZFF_X2) - signed(pgZFF_Y1) - signed(pgZFF_Y2));
			end if;
		end if;
	end process;


	-- output truncation block
	process(clk, trunc_out)
	begin
		if rising_edge(clk) then
			if (trunc_out = '1') then
				Y_out <= Y_out_double( 17 downto 0);
			end if;
		end if;
	end process;
end arch;
