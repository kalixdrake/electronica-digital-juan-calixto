Hola profe

# Cosas para el perip_test.v

//multiplicadorsito mult1 (
//  .reset(reset),
//  .clock(clk),
//  .start(init),
//  .done(done),
//  .result(result),
//  .M_in(A),
//  .Q_in(B)
// );

//divisorsito mult1 (
//  .rst(reset),
//  .clk(clk),
//  .start(init),
//  .ready(done),
//  .quotient_out(result),
//  .dividend_in(A),
//  .divisor_in(B)
// );

//contadorsito mult1 (
//  .rst(reset),
//  .clk(clk),
//  .start(init),
//  .ready(done),
//  .A_out(result),
//  .data_in(A)
// );

//raizsita mult1 (
//  .rst(reset),
//  .clk(clk),
//  .start(init),
//  .ready(done),
//  .Q_out(result),
//  .data_in(A)
// );

# Cosas para el makefile

COMM_OBJS+= cores/juan-calixto/common/decrementadorsito.v
COMM_OBJS+= cores/juan-calixto/common/muxsito.v
COMM_OBJS+= cores/juan-calixto/common/restadorsito.v
COMM_OBJS+= cores/juan-calixto/common/sumadorsito.v

#COMM_OBJS+= cores/juan-calixto/Entrega_multiplicador/multiplicadorsito.v
#COMM_OBJS+= cores/juan-calixto/Entrega_multiplicador/multiplicadorsito_fsm.v
#COMM_OBJS+= cores/juan-calixto/Entrega_multiplicador/multiplicadorsito_datapath.v

#COMM_OBJS+= cores/juan-calixto/Entrega_divisor/divisorsito.v
#COMM_OBJS+= cores/juan-calixto/Entrega_divisor/divisorsito_fsm.v
#COMM_OBJS+= cores/juan-calixto/Entrega_divisor/divisorsito_datapath.v

#COMM_OBJS+= cores/juan-calixto/Entrega_paridad/contadorsito.v
#COMM_OBJS+= cores/juan-calixto/Entrega_paridad/contadorsito_fsm.v
#COMM_OBJS+= cores/juan-calixto/Entrega_paridad/contadorsito_datapath.v

#COMM_OBJS+= cores/juan-calixto/Entrega_raiz_cuadrada/raizsita.v
#COMM_OBJS+= cores/juan-calixto/Entrega_raiz_cuadrada/raizsita_fsm.v
#COMM_OBJS+= cores/juan-calixto/Entrega_raiz_cuadrada/raizsita_datapath.v
