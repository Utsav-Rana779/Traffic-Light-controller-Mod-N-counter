`timescale 1ns/1ps

module mod_n_counter #(
    parameter integer N = 10,
    parameter integer WIDTH = (N <= 2) ? 1 : $clog2(N)
) (
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 enable,
    output reg  [WIDTH-1:0]     count,
    output wire                 terminal
);
    assign terminal = (count == N-1);

    always @(posedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (enable) begin
            if (terminal)
                count <= {WIDTH{1'b0}};
            else
                count <= count + 1'b1;
        end
    end
endmodule
