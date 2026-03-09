module uart_rx(

input clk,
input reset,
input rx,
input baud_tick,

output reg [7:0] data_out,
output reg data_valid

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
        bit_index <= 0;
        data_reg <= 0;
        data_out <= 0;
        data_valid <= 0;
    end

    else if(baud_tick)
    begin
        case(state)

        IDLE:
        begin
            data_valid <= 0;

            if(rx == 0)
                state <= START;
        end

        START:
        begin
            bit_index <= 0;
            state <= DATA;
        end

        DATA:
        begin
            data_reg[bit_index] <= rx;

            if(bit_index == 7)
                state <= STOP;
            else
                bit_index <= bit_index + 1;
        end

        STOP:
        begin
            data_out <= data_reg;
            data_valid <= 1;
            state <= IDLE;
        end

        endcase
    end
end

endmodule