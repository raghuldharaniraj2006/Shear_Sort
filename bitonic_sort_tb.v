`timescale 1ns/1ps

module bitonic_sort_tb;

    // 1. Signals
    reg [7:0] in1, in2, in3, in4;
    reg dir;
    wire [7:0] out1, out2, out3, out4;

    // 2. Instantiate the Unit Under Test (UUT)
    bitonic_sort uut (
        .in1(in1), .in2(in2), .in3(in3), .in4(in4),
        .dir(dir),
        .out1(out1), .out2(out2), .out3(out3), .out4(out4)
    );

    // 3. Stimulus
    initial begin
        // Display Header
        $display("Time\t Dir\t Inputs\t\t\t Outputs");
        $display("------------------------------------------------------------");

        // --- Test Case 1: Ascending ---
        dir = 1; 
        in1 = 15; in2 = 2; in3 = 9; in4 = 1;
        #10; // Wait for logic to settle
        $display("%0t\t %b\t [%d, %d, %d, %d]\t [%d, %d, %d, %d]", 
                 $time, dir, in1, in2, in3, in4, out1, out2, out3, out4);

        // --- Test Case 2: Descending ---
        dir = 0; 
        in1 = 5; in2 = 12; in3 = 3; in4 = 8;
        #10;
        $display("%0t\t %b\t [%d, %d, %d, %d]\t [%d, %d, %d, %d]", 
                 $time, dir, in1, in2, in3, in4, out1, out2, out3, out4);

        // --- Test Case 3: Already Sorted ---
        dir = 1;
        in1 = 10; in2 = 20; in3 = 30; in4 = 40;
        #10;
        $display("%0t\t %b\t [%d, %d, %d, %d]\t [%d, %d, %d, %d]", 
                 $time, dir, in1, in2, in3, in4, out1, out2, out3, out4);

        #100 $finish;
    end

endmodule