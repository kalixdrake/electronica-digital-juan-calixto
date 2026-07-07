TARGET=divisorsito
TOP=divisorsito

OBJS = divisorsito.v divisorsito_fsm.v divisorsito_datapath.v ../common/sumadorsito.v ../common/restadorsito.v ../common/muxsito.v ../common/decrementadorsito.v

all: sim

sim:
	rm -f a.out *.vcd
	iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $(TARGET)_TB.v $(OBJS)
	vvp a.out
	gtkwave $(TARGET)_TB.vcd

clean:
	rm -rf *.out *.vcd *.vpp synth.log