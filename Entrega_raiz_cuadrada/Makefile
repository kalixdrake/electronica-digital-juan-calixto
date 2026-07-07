TARGET=raizsita
TOP=raizsita

OBJS = raizsita.v raizsita_fsm.v raizsita_datapath.v ../common/restadorsito.v ../common/sumadorsito.v ../common/decrementadorsito.v

all: sim

sim:
	rm -f a.out *.vcd
	iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $(TARGET)_TB.v $(OBJS)
	vvp a.out
	gtkwave $(TARGET)_TB.vcd

clean:
	rm -rf *.out *.vcd *.vpp synth.log