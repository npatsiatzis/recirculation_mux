--Toggle Synchronzier
--Open-Loop sampling solution for pulse synchronization

--1)Toggle level when pulse is asserted
--2)2 (or more) DFF synchronizer chain
--3)edge detection, i.e 1 FF + XOR gate


library ieee;
use ieee.std_logic_1164.all;

entity toggle_synchronizer is
	generic (
			g_stages : natural :=2);
	port (
			--domain A bus
			i_clk_A : in std_ulogic;
			i_rst_A : in std_ulogic;
			i_pulse_A : in std_ulogic;

			--domain B bus
			i_clk_B : in std_ulogic;
			i_rst_B : in std_ulogic;
			o_pulse_B : out std_ulogic);
end toggle_synchronizer;

architecture arch of toggle_synchronizer is
	signal r_pulseA : std_ulogic;
	signal r_syncB_pulseA : std_logic_vector(g_stages -1 downto 0);
	signal r_edge_detect_ff : std_ulogic;

	alias syncedB_pulseA : std_ulogic is r_syncB_pulseA(r_syncB_pulseA'high);
begin

	--Domain A

	pulse_to_level_domainA : process(i_clk_A)
	begin
		if(rising_edge(i_clk_A)) then
			if(i_rst_A = '1') then
				r_pulseA <= '0';
			else
				if(i_pulse_A = '1') then
					r_pulseA <= not r_pulseA;
				end if;				
			end if;
		end if;
	end process; -- pulse_to_level_domainA

	--Domain B

	syncB_pulseA : process(i_clk_B,i_rst_B) 
	begin
		if(rising_edge(i_clk_B)) then
			if(i_rst_B = '1') then 
				r_syncB_pulseA <= (others => '0');
				r_edge_detect_ff <= '0';
			else
				r_syncB_pulseA <= r_syncB_pulseA(r_syncB_pulseA'high -1 downto 0) & r_pulseA;
				r_edge_detect_ff <= syncedB_pulseA;
			end if;
		end if;
	end process; -- syncB_pulseA

	o_pulse_B <= r_edge_detect_ff xor syncedB_pulseA;
end arch;