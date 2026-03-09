module uart_tb;

reg clk;
reg reset;
reg start;
reg [7:0] data;

wire tx;
wire [7:0] rx_data;
wire data_valid;

uart_top uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data(data),
    .tx(tx),
    .rx_data(rx_data),
    .data_valid(data_valid)
);

// clock
always #10 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;
    start = 0;
    data = 8'h41;   // ASCII 'A'

    #100;
    reset = 0;

    #100;
    start = 1;

    #40;
    start = 0;

    // run long enough for UART frame
    #2000000;

    $finish;
end

endmodule