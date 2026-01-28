
`include "shear_sort_pip_fsm_bitonic.v"

module tb_shear_sort_512;

    // Parameters
    parameter TOTAL_WINDOWS = 262144; 
    parameter CLK_PERIOD = 10;

    // Signals
    reg clk;
    reg rst;
    reg start;
    reg [7:0] in [1:16];
    wire [7:0] out [1:16];
    wire done;

    // Intermediate wires for the "Better Median" math
    reg [7:0] better_median;

    // File handling
    integer file_input, file_output;
    integer i, status;

    // Instantiate UUT
    shear_sort_pip_fsm_bitonic uut (
        .clk(clk), .rst(rst), .start(start),
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

    // Clock
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        clk = 0; rst = 1; start = 0;
        
        file_input = $fopen("camera_man_512.hex", "r");
        file_output = $fopen("result_512_better_avg.hex", "w");

        if (file_input == 0) begin
            $display("Error: Input file not found!");
            $finish;
        end

        #(CLK_PERIOD * 2) rst = 0;
        $display("Starting Simulation: Averaging out[8] and out[9] for Better Median...");

        for (i = 0; i < TOTAL_WINDOWS; i = i + 1) begin
            
            status = $fscanf(file_input, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h\n", 
                in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], 
                in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16]);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Wait for hardware to finish sorting
            wait(done == 1);
            
            // --- THE BETTER MEDIAN CALCULATION ---
            // In a 4x4 (16 pixels), the two middle elements are at index 8 and 9.
            // We average them to get a smoother result.
            better_median = (out[8] + out[9]) >> 1;

            // Write the averaged result to the file
            $fwrite(file_output, "%h\n", better_median);

            if (i % 26214 == 0 && i > 0) begin
                $display("Progress: %0d%%...", (i * 100) / TOTAL_WINDOWS);
            end
        end

        $display("Done! result_512_better.hex created.");
        $fclose(file_input); $fclose(file_output);
        $finish;
    end
endmodule