`timescale 1ns/1ps

module traffic_light_controller #(
    parameter integer GREEN_TICKS  = 10,
    parameter integer YELLOW_TICKS = 3,
    parameter integer COUNT_WIDTH  = 16
) (
    input  wire clk,
    input  wire rst,
    output reg ns_red,
    output reg ns_yellow,
    output reg ns_green,
    output reg ew_red,
    output reg ew_yellow,
    output reg ew_green
);
    localparam [1:0] NS_GREEN  = 2'd0;
    localparam [1:0] NS_YELLOW = 2'd1;
    localparam [1:0] EW_GREEN  = 2'd2;
    localparam [1:0] EW_YELLOW = 2'd3;

    reg [1:0] state;
    reg [COUNT_WIDTH-1:0] timer;
    reg [COUNT_WIDTH-1:0] phase_limit;

    always @* begin
        case (state)
            NS_GREEN:  phase_limit = GREEN_TICKS - 1;
            NS_YELLOW: phase_limit = YELLOW_TICKS - 1;
            EW_GREEN:  phase_limit = GREEN_TICKS - 1;
            EW_YELLOW: phase_limit = YELLOW_TICKS - 1;
            default:   phase_limit = GREEN_TICKS - 1;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= NS_GREEN;
            timer <= 0;
        end else begin
            if (timer >= phase_limit) begin
                timer <= 0;
                case (state)
                    NS_GREEN:  state <= NS_YELLOW;
                    NS_YELLOW: state <= EW_GREEN;
                    EW_GREEN:  state <= EW_YELLOW;
                    EW_YELLOW: state <= NS_GREEN;
                    default:   state <= NS_GREEN;
                endcase
            end else begin
                timer <= timer + 1'b1;
            end
        end
    end

    always @* begin
        ns_red = 1'b0; ns_yellow = 1'b0; ns_green = 1'b0;
        ew_red = 1'b0; ew_yellow = 1'b0; ew_green = 1'b0;
        case (state)
            NS_GREEN: begin ns_green = 1'b1; ew_red = 1'b1; end
            NS_YELLOW: begin ns_yellow = 1'b1; ew_red = 1'b1; end
            EW_GREEN: begin ew_green = 1'b1; ns_red = 1'b1; end
            EW_YELLOW: begin ew_yellow = 1'b1; ns_red = 1'b1; end
            default: begin ns_red = 1'b1; ew_red = 1'b1; end
        endcase
    end
endmodule
