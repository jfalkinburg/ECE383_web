----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;


entity video is
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
end video;

architecture structure of video is

	signal red, green, blue: STD_LOGIC_VECTOR(7 downto 0);
	signal pixel_clk, serialize_clk, serialize_clk_n, blank, h_sync, v_sync: STD_LOGIC;
	signal clock_s, red_s, green_s, blue_s: STD_LOGIC;
	signal h_synch, v_synch: STD_LOGIC;

	component vga is
	Port(	clk: in  STD_LOGIC;
			reset_n : in  STD_LOGIC;
			h_sync : out  STD_LOGIC;
			v_sync : out  STD_LOGIC; 
			blank : out  STD_LOGIC;
			r: out STD_LOGIC_VECTOR(7 downto 0);
			g: out STD_LOGIC_VECTOR(7 downto 0);
			b: out STD_LOGIC_VECTOR(7 downto 0);
			trigger_time: in unsigned(9 downto 0);
			trigger_volt: in unsigned (9 downto 0);
			row: out unsigned(9 downto 0);
			column: out unsigned(9 downto 0);
			ch1: in std_logic;
			ch1_enb: in std_logic;
			ch2: in std_logic;
			ch2_enb: in std_logic);
	end component;
    --------------------------------------------------------------------------
    -- Clock Wizard Component Instantiation Using Xilinx Vivado 
    --------------------------------------------------------------------------
    component clk_wiz_0 is
    Port (
        clk_in1 : in STD_LOGIC;
        clk_out1 : out STD_LOGIC;
        clk_out2 : out STD_LOGIC;
        clk_out3 : out STD_LOGIC;
        resetn : in STD_LOGIC);
     end component;   

begin

	--------------------------------------------------------------------------
	-- Digital Clocking Wizard using Xilinx Vivado creates 25Mhz pixel clock and 
	-- 125MHz HDMI serial output clocks from 100MHz system clock. The Digital 
    -- Clocking Wizard is in the Vivado IP Catalog.
	--------------------------------------------------------------------------
	mmcm_adv_inst_display_clocks: clk_wiz_0
		Port Map (
			clk_in1 => clk,
			clk_out1 => pixel_clk, -- 25Mhz pixel clock
			clk_out2 => serialize_clk, -- 125Mhz HDMI serial output clock
			clk_out3 => serialize_clk_n, -- 125Mhz HDMI serial output clock 180 degrees out of phase
			resetn => reset_n);  -- active low reset for Nexys Video

	------------------------------------------------------------------------------
	-- H and V synch are used to interface to the DVID module
	------------------------------------------------------------------------------
	Inst_vga: vga
		PORT MAP(	clk => pixel_clk,
						reset_n => reset_n,
						h_sync => h_sync,
						v_sync => v_sync,
						blank => blank,
						r => red,
						g => green,
						b => blue,
						trigger_volt => trigger_volt, 
						trigger_time => trigger_time,
						row => row,
						column => column,
						ch1				=> ch1,
						ch1_enb			=> ch1_enb,
						ch2				=> ch2,
						ch2_enb			=> ch2_enb); 

	------------------------------------------------------------------------------
	-- This module was provided to us free of charge.  It converts a VGA signal
	-- into DVID/HDMI signal.
	------------------------------------------------------------------------------	 
    inst_dvid: entity work.dvid 
		port map(	clk       => serialize_clk,
						clk_n     => serialize_clk_n, 
						clk_pixel => pixel_clk,
						red_p     => red,
						green_p   => green,
						blue_p    => blue,
						blank     => blank,
						hsync     => h_sync,
						vsync     => v_sync,
						red_s     => red_s,
						green_s   => green_s,
						blue_s    => blue_s,
						clock_s   => clock_s		);


	------------------------------------------------------------------------------
	-- This HDMI signals are high speed so buffer to insure signal integrity.
	------------------------------------------------------------------------------
	OBUFDS_blue  : OBUFDS port map
        ( O  => TMDS(0), OB => TMDSB(0), I  => blue_s  );
	OBUFDS_red   : OBUFDS port map
        ( O  => TMDS(1), OB => TMDSB(1), I  => green_s );
	OBUFDS_green : OBUFDS port map
        ( O  => TMDS(2), OB => TMDSB(2), I  => red_s   );
	OBUFDS_clock : OBUFDS port map
        ( O  => TMDS(3), OB => TMDSB(3), I  => clock_s );

end structure;
