`timescale 1ns/1ps

module tb_traffic_light_controller;
    reg clk = 0;
    reg rst = 1;
    wire ns_red, ns_yellow, ns_green;
    wire ew_red, ew_yellow, ew_green;

    // Short timings keep simulation quick; change values for longer phases.
    traffic_light_controller #(
        .GREEN_TICKS(5),
        .YELLOW_TICKS(2),
        .COUNT_WIDTH(8)
    ) dut (
        .clk(clk), .rst(rst),
        .ns_red(ns_red), .ns_yellow(ns_yellow), .ns_green(ns_green),
        .ew_red(ew_red), .ew_yellow(ew_yellow), .ew_green(ew_green)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light_controller);
        $display("time  NS(RYG) EW(RYG)");
        $monitor("%4t    %b%b%b    %b%b%b",
                 $time, ns_red, ns_yellow, ns_green,
                 ew_red, ew_yellow, ew_green);
        repeat (2) @(posedge clk);
        rst = 0;
        repeat (30) @(posedge clk);
        $finish;
    end
endmodule
