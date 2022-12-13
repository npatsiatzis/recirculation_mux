--Synchronize a data bus across clock boundaries.

--1) toggle synchronizer to transfer a control pulse from domain A to B
--2) use synchronized control pulse as mux select that leads to a register
--either sampling the data to be transfered, or recirculate its previous value. 
library ieee;
use ieee.std_logic_1164.all;

entity recirculation_mux is
	generic(
		g_stages : natural :=2;
		g_width : natural :=8);
	port(
		--domain A data bus
		i_clk_A : in std_ulogic;
		i_rst_A : in std_ulogic;
		i_pulse_A : in std_ulogic;
		i_data_A : in std_ulogic_vector(g_width -1 downto 0);
		--domain B data bus
		i_clk_B : in std_ulogic;
		i_rst_B : in std_ulogic;
		o_data_B : out std_ulogic_vector(g_width -1 downto 0));
end recirculation_mux;

architecture arch of recirculation_mux is
	signal w_pulse_B : std_ulogic;
begin
	toggle_synchronizer : entity work.toggle_synchronizer(arch)
	generic map(
		g_stages => g_stages)
	port map(
		i_clk_A => i_clk_A,
		i_rst_A => i_rst_A,
		i_pulse_A => i_pulse_A,

		i_clk_B => i_clk_B,
		i_rst_B => i_rst_B,
		o_pulse_B => w_pulse_B);

	--MUX recirculation
	domainB_MUX_recirculation : process(i_clk_B)
	begin
		if(rising_edge(i_clk_B)) then
			if(i_rst_B = '1') then
				o_data_B <= (others => '0');
			else
				if(w_pulse_B = '1') then
					o_data_B <= i_data_A;
				end if;
			end if;
		end if;
	end process; -- domainB_MUX_recirculation


end arch;