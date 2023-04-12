import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer,RisingEdge,FallingEdge,ClockCycles
from cocotb.result import TestFailure
import random
from cocotb_coverage.coverage import CoverCross,CoverPoint,coverage_db

pulse_B = 0

# #Callback functions to capture the bin content showing
def notify_pulse():
	global pulse_B
	pulse_B +=1

# at_least = value is superfluous, just shows how you can determine the amount of times that
# a bin must be hit to considered covered
@CoverPoint("top.o_pulse_B",xf = lambda x : x.o_pulse_B.value ==1 , bins = [True,False], at_least=1)
def number_cover(dut):
	pass

async def send_pulse(dut):
	dut.i_pulse_A.value = 1
	await RisingEdge(dut.i_clk_A)
	dut.i_pulse_A.value = 0
	await RisingEdge(dut.i_clk_A)

async def reset(dut,cycles=1):
	dut.i_rst_A.value = 1
	dut.i_rst_B.value = 1

	dut.i_pulse_A.value = 0 

	await ClockCycles(dut.i_clk_A,cycles)
	dut.i_rst_A.value = 0
	dut.i_rst_B.value = 0
	await RisingEdge(dut.i_clk_A)
	dut._log.info("the core was reset")

@cocotb.test()
async def test(dut):
	"""Check results and coverage for toggle pulse synchronizer"""

	cocotb.start_soon(Clock(dut.i_clk_A, 5, units="ns").start())
	cocotb.start_soon(Clock(dut.i_clk_B, 20, units="ns").start())
	await reset(dut,5)	
	
	rx_data = 0
	while (pulse_B<100):
		cycles = random.randint(0,100)
		await ClockCycles(dut.i_clk_A,cycles)
		await send_pulse(dut)
		await RisingEdge(dut.o_pulse_B)
		number_cover(dut)
		coverage_db["top.o_pulse_B"].add_bins_callback(notify_pulse, True)	