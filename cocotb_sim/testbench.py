import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer,RisingEdge,FallingEdge,ClockCycles
from cocotb.result import TestFailure
import random
from cocotb_coverage.coverage import CoverCross,CoverPoint,coverage_db

covered_value = []
g_width = int(cocotb.top.g_width)

full_coverage = False

# #Callback functions to capture the bin content showing
def notify_full():
	global full_coverage
	full_coverage = True

# at_least = value is superfluous, just shows how you can determine the amount of times that
# a bin must be hit to considered covered
@CoverPoint("top.o_data",xf = lambda x : x.o_data_B.value, bins = list(range(2**g_width)), at_least=1)
def number_cover(dut):
	covered_value.append(dut.o_data_B.value)

async def send_pulse(dut):
	dut.i_pulse_A.value = 1
	await RisingEdge(dut.i_clk_A)
	dut.i_pulse_A.value = 0
	await RisingEdge(dut.i_clk_A)

async def reset(dut,cycles=1):
	dut.i_rst_A.value = 1
	dut.i_rst_B.value = 1

	dut.i_pulse_A.value = 0 
	dut.i_data_A.value = 0

	await ClockCycles(dut.i_clk_A,cycles)
	dut.i_rst_A.value = 0
	dut.i_rst_B.value = 0
	await RisingEdge(dut.i_clk_A)
	dut._log.info("the core was reset")

@cocotb.test()
async def test(dut):
	"""Check results and coverage for recirculation MUX CDC"""

	#clocks with variable phase difference
	cocotb.start_soon(Clock(dut.i_clk_A, 3, units="ns").start())
	cocotb.start_soon(Clock(dut.i_clk_B, 11, units="ns").start())
	await reset(dut,5)	
	
	rx_data = 0
	while (full_coverage != True):
		await send_pulse(dut)
		data = random.randint(0,2**g_width-1)
		dut.i_data_A.value = data
		expected_value = data
		old_rx_data = rx_data
		rx_data = dut.o_data_B.value
		await RisingEdge(dut.i_clk_A)

		await FallingEdge(dut.w_pulse_B)
		assert not (expected_value != int(dut.o_data_B.value)),"Different expected to actual read data"
		number_cover(dut)
		coverage_db["top.o_data"].add_threshold_callback(notify_full, 100)	

	coverage_db.report_coverage(cocotb.log.info,bins=True)
	coverage_db.export_to_xml(filename="coverage.xml") 
		