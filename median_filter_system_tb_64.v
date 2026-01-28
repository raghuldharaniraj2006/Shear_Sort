`include "shear_sort_pip_fsm_bitonic.v"

module tb_shear_sort_image_system;

    // Parameters
    parameter TOTAL_WINDOWS = 4096; // 64x64 image
    parameter CLK_PERIOD = 10;

    // Inputs to the shear_sort_pip_fsm_bitonic
    reg clk;
    reg rst;
    reg start;
    reg [7:0] in_p [1:16];

    // Outputs from the module
    wire [7:0] out_p [1:16];
    wire done;

    // File handling variables
    integer file_input, file_output;
    integer i, status;

    // 1. Instantiate your Main Module
    shear_sort_pip_fsm_bitonic uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_1(in_p[1]),   .in_2(in_p[2]),   .in_3(in_p[3]),   .in_4(in_p[4]),
        .in_5(in_p[5]),   .in_6(in_p[6]),   .in_7(in_p[7]),   .in_8(in_p[8]),
        .in_9(in_p[9]),   .in_10(in_p[10]), .in_11(in_p[11]), .in_12(in_p[12]),
        .in_13(in_p[13]), .in_14(in_p[14]), .in_15(in_p[15]), .in_16(in_p[16]),
        .out_1(out_p[1]), .out_2(out_p[2]), .out_3(out_p[3]), .out_4(out_p[4]),
        .out_5(out_p[5]), .out_6(out_p[6]), .out_7(out_p[7]), .out_8(out_p[8]),
        .out_9(out_p[9]), .out_10(out_p[10]),.out_11(out_p[11]),.out_12(out_p[12]),
        .out_13(out_p[13]),.out_14(out_p[14]),.out_15(out_p[15]),.out_16(out_p[16]),
        .done(done)
    );

    // Clock Generation
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        start = 0;
        
        // Open the stimulus you generated and create the results file
        file_input = $fopen("median_filter_test_stimulus.hex", "r");
        file_output = $fopen("photographer_result.hex", "w");

        if (file_input == 0) begin
            $display("Error: stimulus.hex not found. Check your Python script output.");
            $finish;
        end

        // Global Reset
        #(CLK_PERIOD * 2) rst = 0;

        $display("Starting simulation for %0d windows...", TOTAL_WINDOWS);

        // 2. The Main Verification Loop
        for (i = 0; i < TOTAL_WINDOWS; i = i + 1) begin
            
            // Read 16 pixels from the hex file (mapped to your in_1 to in_16)
            status = $fscanf(file_input, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h\n", 
                in_p[1], in_p[2], in_p[3], in_p[4], in_p[5], in_p[6], in_p[7], in_p[8], 
                in_p[9], in_p[10], in_p[11], in_p[12], in_p[13], in_p[14], in_p[15], in_p[16]);

            // Trigger the LOAD state
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // 3. Wait for the DONE state
            wait(done == 1);
            
            // Extract the Median value 
            // In a sorted 4x4 matrix, index 8 (out_8) is a standard median choice
            $fwrite(file_output, "%h\n", out_p[8]);

            // Clean up for next iteration
            @(posedge clk); 
        end

        $display("Simulation successfully completed. result.hex generated.");
        $fclose(file_input);
        $fclose(file_output);
        $finish;
    end

endmodule