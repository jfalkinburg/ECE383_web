----------------------------------------------------------------------------------
-- Name:	Maj Jeff Falkinburg
-- Date:	Spring 2017
-- Course:	ECE 383
-- File: lab2_datapath_tb.vhd
-- HW:	Lab 2 
-- Pupr:	Lab 2 Datapath Testbench drives the blue audio jack input using the to
-- 		simulate the National Semiconductor LM450 AC'97 multi-channel audio 
--			codec and translates it for storage in BRAM and eventual display on the 
-- 		oscope display.  
--
-- Doc:	None
-- 	
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.lab2Parts.all;		
 
ENTITY Lab2_datapath_tb IS
END Lab2_datapath_tb;
 
ARCHITECTURE behavior OF Lab2_datapath_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lab2_datapath
    PORT(
         clk : IN  std_logic;
         reset_n : IN  std_logic;
         ac_mclk : out STD_LOGIC;
         ac_adc_sdata : in STD_LOGIC;
         ac_dac_sdata : out STD_LOGIC;
         ac_bclk : out STD_LOGIC;
         ac_lrclk : out STD_LOGIC;
         scl : inout STD_LOGIC;
         sda : inout STD_LOGIC;
         tmds : OUT  std_logic_vector(3 downto 0);
         tmdsb : OUT  std_logic_vector(3 downto 0);
         sw : OUT  std_logic_vector(2 downto 0);
         cw : IN  std_logic_vector(2 downto 0);
         btn : IN  std_logic_vector(4 downto 0);
         exWrAddr : IN  std_logic_vector(9 downto 0);
         exWen : IN  std_logic;
         exSel : IN  std_logic;
         Lbus_out : OUT  std_logic_vector(15 downto 0);
         Rbus_out : OUT  std_logic_vector(15 downto 0);
         exLbus : IN  std_logic_vector(15 downto 0);
         exRbus : IN  std_logic_vector(15 downto 0);
         flagQ : OUT  std_logic_vector(7 downto 0);
         flagClear : IN  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal ac_adc_sdata : std_logic := '0';
   signal sda : std_logic := '0';
   signal BIT_CLK : std_logic := '0';
   signal cw : std_logic_vector(2 downto 0) := (others => '0');
   signal btn : std_logic_vector(4 downto 0) := (others => '0');
   signal exWrAddr : std_logic_vector(9 downto 0) := (others => '0');
   signal exWen : std_logic := '0';
   signal exSel : std_logic := '0';
   signal exLbus : std_logic_vector(15 downto 0) := (others => '0');
   signal exRbus : std_logic_vector(15 downto 0) := (others => '0');
   signal flagClear : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal ac_mclk : std_logic;
   signal ac_dac_sdata : std_logic;
   signal ac_bclk : std_logic;
   signal ac_lrclk : std_logic;
   signal scl : std_logic;
--   signal AC97_n_RESET : std_logic;
   signal tmds : std_logic_vector(3 downto 0);
   signal tmdsb : std_logic_vector(3 downto 0);
   signal sw : std_logic_vector(2 downto 0);
   signal Lbus_out : std_logic_vector(15 downto 0);
   signal Rbus_out : std_logic_vector(15 downto 0);
   signal flagQ : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;  -- Sets clock to ~ 100MHz
--   constant BIT_CLK_period : time := 80 ns;  -- Sets Bit Clock for AC'97 to the necessary 12.288 MHz
   constant BIT_CLK_period : time := 40 ns;  -- Sets Bit Clock for Audio Codec to the necessary 25 MHz

	-- FSM Control signals
	type state_type is (RST, WAIT_TRIGGER, STORE_SAMPLE, WAIT_SAMPLE);
	signal state: state_type;


BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lab2_datapath PORT MAP (
          clk => clk,
          reset_n => reset_n,
  		  ac_mclk => ac_mclk,
          ac_adc_sdata => ac_adc_sdata,
          ac_dac_sdata => ac_dac_sdata,
          ac_bclk => ac_bclk,
          ac_lrclk => ac_lrclk,
          scl => scl,
          sda => sda,
--          AC97_n_RESET => AC97_n_RESET,
          tmds => tmds,
          tmdsb => tmdsb,
          sw => sw,
          cw => cw,
          btn => btn,
          exWrAddr => exWrAddr,
          exWen => exWen,
          exSel => exSel,
          Lbus_out => Lbus_out,
          Rbus_out => Rbus_out,
          exLbus => exLbus,
          exRbus => exRbus,
          flagQ => flagQ,
          flagClear => flagClear
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
--   BIT_CLK_process :process
--   begin
--		BIT_CLK <= '0';
--		wait for BIT_CLK_period/2;
--		BIT_CLK <= '1';
--		wait for BIT_CLK_period/2;
--   end process;
    
    SDATA_process :process  -- Inputs alternating 1's and 0's on each Bit Clock
    begin
         ac_adc_sdata <= '0';
         wait for BIT_CLK_period;
         ac_adc_sdata <= '1';
         wait for BIT_CLK_period*2;
    end process;

 
   -- Stimulus process
   stim_proc: process 
   begin		
      -- hold reset state for 100 ns.
		reset_n <= '0', '1' after 10 ns;
		cw <= "111", "101" after 30 ns;
			-- insert stimulus here 

		
		wait;
   end process;

END;
