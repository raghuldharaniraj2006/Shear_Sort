`timescale 1ns/1ps

module bitonic_sort_tb;

    // 1. Signals
    reg clk;
    reg rst;
    reg [7:0] in1, in2, in3, in4;
    reg dir;
    wire [7:0] out1, out2, out3, out4;

    // 2. Instantiate the Unit Under Test (UUT)
    bitonic_sort uut (
        .clk(clk), .rst(rst),
        .in1(in1), .in2(in2), .in3(in3), .in4(in4),
        .dir(dir),
        .out1(out1), .out2(out2), .out3(out3), .out4(out4)
    );

    // 3. Clock Generation (100MHz)
    always #5 clk = ~clk;

    // 4. Stimulus
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        in1 = 0; in2 = 0; in3 = 0; in4 = 0;
        dir = 0;

        // Reset Pulse
        #20 rst = 0;

        // --- Test Case 1: Ascending Sort (dir = 1) ---
        @(posedge clk);
        in1 = 8'd15; in2 = 8'd2; in3 = 8'd9; in4 = 8'd1;
        dir = 1;
        
        $display("Time %0t: Inputs provided [%d, %d, %d, %d]", $time, in1, in2, in3, in4);

        // Wait for Pipeline Latency (3 Cycles)
        repeat(3) @(posedge clk);
        
        // At the 4th posedge after input, the output is ready
        #1; // Small delay to let logic settle
        $display("Time %0t: Output (Asc)  [%d, %d, %d, %d]", $time, out1, out2, out3, out4);

        // --- Test Case 2: Descending Sort (dir = 0) ---
        @(posedge clk);
        in1 = 8'd5; in2 = 8'd12; in3 = 8'd3; in4 = 8'd8;
        dir = 0;

        $display("Time %0t: Inputs provided [%d, %d, %d, %d]", $time, in1, in2, in3, in4);

        repeat(3) @(posedge clk);
        #1;
        $display("Time %0t: Output (Desc) [%d, %d, %d, %d]", $time, out1, out2, out3, out4);

        #50 $finish;
    end

    // 5. Waveform Dump
    initial begin
        $dumpfile("bitonic_sort.vcd");
        $dumpvars(0, bitonic_sort_tb);
    end

endmodule