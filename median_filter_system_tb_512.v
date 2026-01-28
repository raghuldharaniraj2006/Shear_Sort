`include "shear_sort_pip_fsm_bitonic.v"

module tb_shear_sort_512;

    // Parameters for 512x512 image
    parameter TOTAL_WINDOWS = 262144; // 512 * 512
    parameter CLK_PERIOD = 10;

    // Inputs to the module
    reg clk;
    reg rst;
    reg start;
    reg [7:0] in [1:16];

    // Outputs from the module
    wire [7:0] out [1:16];
    wire done;

    // File handling
    integer file_input, file_output;
    integer i, status;

    // Instantiate your Main Module
    shear_sort_pip_fsm_bitonic uut (
        .clk(clk),
        .rst(rst),
        .start(start),
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

    // Clock Generation
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        start = 0;
        
        // 1. Open your 512x512 stimulus and create the new result file
        file_input = $fopen("girl_4x4.hex", "r");
        file_output = $fopen("result_girl_512.hex", "w");

        if (file_input == 0) begin
            $display("Error: camera_man_512.hex not found!");
            $finish;
        end

        // Reset
        #(CLK_PERIOD * 2) rst = 0;

        $display("Starting Hardware Simulation for 512x512 image...");

        // 2. Main Loop for 262,144 windows
        for (i = 0; i < TOTAL_WINDOWS; i = i + 1) begin
            
            // Read 16 pixels from stimulus
            status = $fscanf(file_input, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h\n", 
                in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], 
                in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16]);

            // Trigger Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Wait for FSM to finish sorting
            wait(done == 1);
            
            // Extract Median (Index 8 is standard for 4x4)
            $fwrite(file_output, "%h\n", out[8]);

            // Progress Monitor (Prints every 10% to keep you updated)
            if (i % 26214 == 0 && i > 0) begin
                $display("Simulation Progress: %0d%% complete", (i * 100) / TOTAL_WINDOWS);
            end
        end

        $display("Simulation Complete! result_512.hex has been generated.");
        $fclose(file_input);
        $fclose(file_output);
        $finish;
    end

endmodule