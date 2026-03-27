
`include "shear_sort_3x3.v"
`timescale 1ns / 1ps

module shear_sort_3x3_tb();
    // Inputs to the DUT (Design Under Test)
    reg clk, start, rst;
    reg [7:0] in1, in2, in3, in4, in5, in6, in7, in8, in9;
    
    // Outputs from the DUT
    wire [7:0] o1, o2, o3, o4, o5, o6, o7, o8, o9;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    // Ensure the module name "shear_sort_top" matches your file
    shear_sort_3x3 uut (
        .clk(clk), .rst(rst), .start(start),
        .in1(in1), .in2(in2), .in3(in3),
        .in4(in4), .in5(in5), .in6(in6),
        .in7(in7), .in8(in8), .in9(in9),
        .o1(o1), .o2(o2), .o3(o3),
        .o4(o4), .o5(o5), .o6(o6),
        .o7(o7), .o8(o8), .o9(o9),
        .done(done)
    );

    // Clock generation: 10ns period (100MHz)
    // Research targeted 81MHz, so 10ns is a safe simulation speed [cite: 13, 162]
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        start = 0;
        in1=0; in2=0; in3=0; in4=0; in5=0; in6=0; in7=0; in8=0; in9=0;

        // Reset the system
        #20 rst = 0;
        
        // Apply Input Data (31 to 39 in random order)
        #10;
        in1 = 8'd39; in2 = 8'd31; in3 = 8'd32;
        in4 = 8'd37; in5 = 8'd35; in6 = 8'd34;
        in7 = 8'd36; in8 = 8'd33; in9 = 8'd38;
        
        // Pulse Start to begin sorting
        #10 start = 1;
        #10 start = 0;

        // Wait for the 'done' signal from the state machine
        // The research algorithm concludes after Row, Column, and Diagonal sorting 
        wait(done == 1);
        
        #20;
        $display("--- Sorting Complete ---");
        $display("Results: %d %d %d | %d %d %d | %d %d %d", o1, o2, o3, o4, o5, o6, o7, o8, o9);
        $finish;
    end

    // Monitor for debugging output in the console
    initial begin
        $monitor("Time=%t | Done=%b | Center(Median)=%d", $time, done, o5);
    end

endmodule