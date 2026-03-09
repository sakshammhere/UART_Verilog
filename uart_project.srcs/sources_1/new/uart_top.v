module uart_top(

input clk,
input reset,
input start,
input [7:0] data,

output tx,
output [7:0] rx_data,
output data_valid

);

wire baud_tick;

baud_generator baud_gen(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

uart_tx transmitter(
    .clk(clk),
    .reset(reset),
    .start(start),
    .baud_tick(baud_tick),
    .data(data),
    .tx(tx)
);

uart_rx receiver(
    .clk(clk),
    .reset(reset),
    .rx(tx),      // loopback connection
    .baud_tick(baud_tick),
    .data_out(rx_data),
    .data_valid(data_valid)
);

endmodule