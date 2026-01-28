`timescale 1ns / 1ps

module tb_adaptive_shear_sort;

    // Parameters for 512x512 image
    parameter TOTAL_WINDOWS = 262144; 
    parameter CLK_PERIOD = 10;
    
    // Testbench Signals
    reg clk;
    reg rst;
    reg start;
    reg [7:0] threshold_val;
    reg [7:0] in [1:16];
    wire [7:0] out [1:16];
    wire done;

    // File handling variables
    integer file_input, file_output;
    integer i, status;

    // 1. Instantiate the Module with the threshold port
    shear_sort_pip_fsm_bitonic uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .threshold(threshold_val), // Connected to our testbench register
        .in_1(in[1]),   .in_2(in[2]),   .in_3(in[3]),   .in_4(in[4]),
        .in_5(in[5]),   .in_6(in[6]),   .in_7(in[7]),   .in_8(in[8]),
        .in_9(in[9]),   .in_10(in[10]), .in_11(in[11]), .in_12(in[12]),
        .in_13(in[13]), .in_14(in[14]), .in_15(in[15]), .in_16(in[16]),
        .out_1(out[1]), .out_2(out[2]), .out_3(out[3]), .out_4(out[4]),
        .out_5(out[5]), .out_6(out[6]), .out_7(out[7]), .out_8(out[8]),
        .out_9(out[9]), .out_10(out[10]),.out_11(out[11]),.out_12(out[12]),
        .out_13(out[13]),.out_14(out[14]),.out_15(out[15]),.out_16(out[16]),
        .done(done)
    );

    // 2. Clock Generation
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        start = 0;
        threshold_val = 8'd50; // Set your filtering sensitivity here
        
        // Open the files
        file_input = $fopen("camera_man_512.hex", "r");
        file_output = $fopen("result_adaptive3_512.hex", "w");

        if (file_input == 0) begin
            $display("Error: Input file 'camera_man_512.hex' not found!");
            $finish;
        end

        // Reset system
        #(CLK_PERIOD * 2) rst = 0;
        $display("--- Starting Adaptive Hardware Simulation ---");

        // 3. Main Processing Loop
        for (i = 0; i < TOTAL_WINDOWS; i = i + 1) begin
            
            // Read 16 pixels from the hex file
            status = $fscanf(file_input, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h\n", 
                in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], 
                in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16]);

            // Trigger Start pulse
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Wait for Adaptive Logic DONE signal
            wait(done == 1);
            
            // Write the intelligently filtered pixel (out_8) to the result file
            $fwrite(file_output, "%h\n", out[8]);

            // Progress Monitor (displays every 10%)
            if (i % 26214 == 0 && i > 0) begin
                $display("Simulation Progress: %0d%%", (i * 100) / TOTAL_WINDOWS);
            end
        end

        $display("Success: Simulation Complete. 'result_adaptive_512.hex' generated.");
        $fclose(file_input);
        $fclose(file_output);
        $finish;
    end

endmodule