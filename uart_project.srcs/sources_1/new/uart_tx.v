module uart_tx(
input clk,
input reset,
input start,
input baud_tick,
input [7:0] data,
output reg tx,
output reg busy
);

reg [3:0] state;
reg [2:0] bit_index;
reg [7:0] data_reg;

parameter IDLE  = 0;
parameter START = 1;
parameter DATA  = 2;
parameter STOP  = 3;

always @(posedge clk or posedge reset)
begin

if(reset)
begin
state <= IDLE;
tx <= 1;
busy <= 0;
bit_index <= 0;
end

else
begin

case(state)

IDLE:
begin
tx <= 1;
busy <= 0;

if(start)
begin
data_reg <= data;
state <= START;
busy <= 1;
end
end

START:
begin
if(baud_tick)
begin
tx <= 0;
state <= DATA;
bit_index <= 0;
end
end

DATA:
begin
if(baud_tick)
begin
tx <= data_reg[bit_index];

if(bit_index == 7)
state <= STOP;
else
bit_index <= bit_index + 1;
end
end

STOP:
begin
if(baud_tick)
begin
tx <= 1;
state <= IDLE;
end
end

endcase

end

end

endmodule