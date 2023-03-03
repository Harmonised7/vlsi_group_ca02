library IEEE;use IEEE.STD_LOGIC_1164.ALL;use IEEE.STD_LOGIC_ARITH.ALL;use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity vi_output_ports is
    Port ( clk,write_strobe : in  STD_LOGIC;
           port_id,din	 : in  STD_LOGIC_VECTOR (7 downto 0);
           dout1,dout2	 : out  STD_LOGIC_VECTOR (7 downto 0));
end vi_output_ports;
architecture Behavioral of vi_output_ports is signal dout1_sig,dout2_sig:std_logic_vector(7 downto 0);
begin dout1<=dout1_sig;dout2<=dout2_sig;output_ports: process(clk)begin
if clk'event and clk='1' then 
	if write_strobe='1' then 
		if port_id(0)='1' then
			dout1_sig<=din;
		elsif port_id(1)='1' then 
			dout2_sig<=din;
		else dout1_sig<=dout1_sig;dout2_sig<=dout2_sig;
end if;end if;end if;end process;
end Behavioral;
