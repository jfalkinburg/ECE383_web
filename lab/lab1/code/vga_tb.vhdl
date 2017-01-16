--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY lab1_tb IS
END lab1_tb;
 
ARCHITECTURE behavior OF lab1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga
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
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal trigger_volt : unsigned(9 downto 0) := (others => '0');
   signal trigger_time : unsigned(9 downto 0) := (others => '0');
   signal row : unsigned(9 downto 0) := (others => '0');
   signal column : unsigned(9 downto 0) := (others => '0');
	signal ch1, ch1_enb, ch2, ch2_enb: std_logic := '0';
	
 	--Outputs
   signal h_sync : std_logic;
   signal v_sync : std_logic;
   signal blank : std_logic;

   signal r : std_logic_vector(7 downto 0);
   signal g : std_logic_vector(7 downto 0);
   signal b : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vga PORT MAP (
          clk => clk,
          reset_n => reset_n,
          h_sync => h_sync,
          v_sync => v_sync,
          blank => blank,
          r => r,
          g => g,
          b => b,
          trigger_volt => trigger_volt,
          trigger_time => trigger_time,
			row => row,
			column => column,
			ch1 => ch1,
			ch1_enb => ch1_enb,
			ch2 => ch2,
			ch2_enb => ch2_enb			 
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	reset_n <= '0', '1' after 30nS;


END;
