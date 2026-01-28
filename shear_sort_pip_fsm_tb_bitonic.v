`include "shear_sort_pip_fsm_bitonic.v"
`timescale 1ns/1ps

module shear_sort_pip_fsm_tb_bitonic;

    // 1. Signals
    reg clk;
    reg rst;
    reg start;
    
    // Inputs
    reg [7:0] in_1,  in_2,  in_3,  in_4,  in_5,  in_6,  in_7,  in_8;
    reg [7:0] in_9,  in_10, in_11, in_12, in_13, in_14, in_15, in_16;
    
    // Outputs
    wire [7:0] out_1,  out_2,  out_3,  out_4,  out_5,  out_6,  out_7,  out_8;
    wire [7:0] out_9,  out_10, out_11, out_12, out_13, out_14, out_15, out_16;
    wire done;



    // 2. Instantiate the Design Under Test (DUT)
    shear_sort_pip_fsm_bitonic dut (
        .clk(clk), .rst(rst), .start(start),
        .in_1(in_1),   .in_2(in_2),   .in_3(in_3),   .in_4(in_4),
        .in_5(in_5),   .in_6(in_6),   .in_7(in_7),   .in_8(in_8),
        .in_9(in_9),   .in_10(in_10), .in_11(in_11), .in_12(in_12),
        .in_13(in_13), .in_14(in_14), .in_15(in_15), .in_16(in_16),
        .out_1(out_1),   .out_2(out_2),   .out_3(out_3),   .out_4(out_4),
        .out_5(out_5),   .out_6(out_6),   .out_7(out_7),   .out_8(out_8),
        .out_9(out_9),   .out_10(out_10), .out_11(out_11), .out_12(out_12),
        .out_13(out_13), .out_14(out_14), .out_15(out_15), .out_16(out_16),
        .done(done)
    );

    // 3. Clock Generation (100MHz)
    always #5 clk = (clk === 1'b0); // Initializes to 0 automatically

    // 4. Monitoring (Prints every state change)
    initial begin
        $monitor("Time: %0t | State: %b | Count: %d | Done: %b", $time, dut.state, dut.iter_counter, done);
    end

    // 5. Stimulus
    initial begin
        // Initialize
        clk = 0;
        rst = 1;      // Start in Reset (Active High)
        start = 0;
        
        // Unsorted input data
        in_1=10;  in_2=2;   in_3=5;   in_4=1;
        in_5=15;  in_6=8;   in_7=12;  in_8=4;
        in_9=3;   in_10=11; in_11=6;  in_12=9;
        in_13=14; in_14=0;  in_15=7;  in_16=13;

        // Sequence
        #20 rst = 0;             // Release Reset
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0; // The FSM must see start go to 0 to stay in the loop!       // Trigger Start
             // Clear Start

        // Wait for Hardware to finish 3 iterations
        wait(done == 1'b1);
        #1; // Wait 1ns for assignments to settle

        // 6. Display Output Matrix
        $display("\n========================================");
        $display("   SHEAR SORT FINAL OUTPUT MATRIX");
        $display("========================================");
        $display("Row 0: %d\t%d\t%d\t%d", out_1,  out_2,  out_3,  out_4);
        $display("Row 1: %d\t%d\t%d\t%d", out_5,  out_6,  out_7,  out_8);
        $display("Row 2: %d\t%d\t%d\t%d", out_9,  out_10, out_11, out_12);
        $display("Row 3: %d\t%d\t%d\t%d", out_13, out_14, out_15, out_16);
        $display("========================================\n");
        
        $finish;
    end

    // 7. Waveform Dump
    initial begin
        $dumpfile("shear_sort_fsm_bit.vcd");
        $dumpvars(0, shear_sort_pip_fsm_tb_bitonic);
    end

endmodule