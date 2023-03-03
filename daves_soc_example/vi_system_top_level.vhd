library IEEE;use IEEE.STD_LOGIC_1164.ALL;use IEEE.STD_LOGIC_ARITH.ALL;use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vi_sys_top_level is
    Port ( clk,reset 	: in  std_logic;
           din1,din2	: in  std_logic_vector(7 downto 0);
           dout1,dout2	: out  std_logic_vector(7 downto 0));
end vi_sys_top_level;

architecture Behavioral of vi_sys_top_level is

--the processor:
--------------------------------------------------------------------
component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
end component;


--the ROM:
--------------------------------------------------------------------
component vi_sys_rom                             
    generic(          	  C_FAMILY : string := "7S"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port(      	   address : in std_logic_vector(11 downto 0);
		       instruction : out std_logic_vector(17 downto 0);
                 	    enable : in std_logic;
                    		rdl : out std_logic;                    
                    		clk : in std_logic);
end component;


--the output ports:
--------------------------------------------------------------------
component vi_output_ports is
    Port ( clk,write_strobe : in  STD_LOGIC;
           port_id,din	 : in  STD_LOGIC_VECTOR (7 downto 0);
           dout1,dout2	 : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


--the input ports:
--------------------------------------------------------------------
component vi_input_ports is
    Port ( clk,read_strobe	: in  STD_LOGIC;
           port_id,din1,din2    : in  STD_LOGIC_VECTOR (7 downto 0);
           dout 	: out  STD_LOGIC_VECTOR (7 downto 0));
end component;

	
--the signals:		
--------------------------------------------------------------------
signal address_sig:std_logic_vector(11 downto 0);
signal instruction_sig:std_logic_vector(17 downto 0);
signal din_sig,dout_sig,port_id_sig:std_logic_vector(7 downto 0);
signal write_strobe_sig,k_write_strobe_sig,read_strobe_sig,interrupt_sig,interrupt_ack_sig : std_logic;
signal sleep_sig,rdl_sig,reset_sig,bram_enable_sig:std_logic;

begin
--------------------------------------------------------------------
sleep_sig <= '0';
interrupt_sig <= interrupt_ack_sig;
reset_sig<=reset or rdl_sig;

processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address_sig,
               instruction => instruction_sig,
               bram_enable => bram_enable_sig,
                   port_id => port_id_sig,
              write_strobe => write_strobe_sig,
            k_write_strobe => k_write_strobe_sig,
                  out_port => dout_sig,
               read_strobe => read_strobe_sig,
                   in_port => din_sig,
                 interrupt => interrupt_sig,
             interrupt_ack => interrupt_ack_sig,
                     sleep => sleep_sig,
                     reset => reset_sig,
                       clk => clk);

the_rom: vi_sys_rom                    
    generic map(             C_FAMILY => "7S",   
                    C_RAM_SIZE_KWORDS => 1,      
                 C_JTAG_LOADER_ENABLE => 0)      
    port map(      address => address_sig,      
               instruction => instruction_sig,
                    enable => bram_enable_sig,
                       rdl => rdl_sig,
                       clk => clk);

vi_out_ports:vi_output_ports port map (clk=>clk,write_strobe=>write_strobe_sig,port_id=>port_id_sig,din=>dout_sig,dout1=>dout1,dout2=>dout2);

vi_in_ports:vi_input_ports port map (clk=> clk,read_strobe=>read_strobe_sig,port_id=>port_id_sig,din1=>din1,din2=>din2,dout=>din_sig);

end Behavioral;






