library IEEE;use IEEE.STD_LOGIC_1164.ALL;use IEEE.STD_LOGIC_ARITH.ALL;use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity vi_input_ports is
    Port ( clk,read_strobe	: in  STD_LOGIC;
           port_id,din1,din2    : in  STD_LOGIC_VECTOR (7 downto 0);
           dout 	: out  STD_LOGIC_VECTOR (7 downto 0));
end vi_input_ports;
architecture Behavioral of vi_input_ports is
signal dout_sig: std_logic_vector(7 downto 0);
begin dout<=dout_sig;
input_process: process(clk) begin
if clk'event and clk='1' then
	if read_strobe='1' then 
		if port_id=x"00" then 
			dout_sig<=din1;
		elsif port_id=x"01" then 
			dout_sig<=din2;
		else
            dout_sig<=dout_sig;
        end if;
    end if;
end if;
end process;
end Behavioral;



