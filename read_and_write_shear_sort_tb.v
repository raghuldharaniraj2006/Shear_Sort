`include "shear_sort_pip_fsm_bitonic.v"
module shear_sort_image_tb;

    // --- 1. Signals ---
    reg clk;
    reg rst;
    reg start;
    reg [7:0] img_in [0:15];  // Memory to hold input hex
    wire [7:0] img_out [0:15]; // Outputs from your FSM
    wire done;
    integer file_ptr, i;

    // --- 2. Instantiate your Shear Sort FSM ---
    shear_sort_pip_fsm_bitonic uut (
        .clk(clk), .rst(rst), .start(start),
        .in_1(img_in[0]),   .in_2(img_in[1]),   .in_3(img_in[2]),   .in_4(img_in[3]),
        .in_5(img_in[4]),   .in_6(img_in[5]),   .in_7(img_in[6]),   .in_8(img_in[7]),
        .in_9(img_in[8]),   .in_10(img_in[9]),  .in_11(img_in[10]), .in_12(img_in[11]),
        .in_13(img_in[12]), .in_14(img_in[13]), .in_15(img_in[14]), .in_16(img_in[15]),
        .out_1(img_out[0]),  .out_2(img_out[1]),  .out_3(img_out[2]),  .out_4(img_out[3]),
        .out_5(img_out[4]),  .out_6(img_out[5]),  .out_7(img_out[6]),  .out_8(img_out[7]),
        .out_9(img_out[8]),  .out_10(img_out[9]), .out_11(img_out[10]), .out_12(img_out[11]),
        .out_13(img_out[12]), .out_14(img_out[13]), .out_15(img_out[14]), .out_16(img_out[15]),
        .done(done)
    );

    // --- 3. Clock Generation ---
    always #5 clk = ~clk;

    // --- 4. Main Simulation Task ---
    initial begin
        // Initialize
        clk = 0; rst = 1; start = 0;
        
        // A. Load the image created in Colab
        $display("Loading input_pixels.hex...");
        $readmemh("input_pixels.hex", img_in);
        
        #20 rst = 0; // Release reset
        #20 start = 1;
        #10 start = 0;

        // B. Wait for your Moore FSM to finish
        $display("Processing image pixels...");
        wait(done);
        #10;
        $display("Sorting/Filtering Complete!");

        // C. Write results back to a Hex file
        file_ptr = $fopen("output_pixels.hex", "w");
        if (file_ptr == 0) begin
            $display("Error: Could not create output file.");
            $finish;
        end

        for (i = 0; i < 16; i = i + 1) begin
            $fwrite(file_ptr, "%h\n", img_out[i]);
        end

        $fclose(file_ptr);
        $display("Successfully saved to output_pixels.hex");
        $display("Upload this file back to Colab to see your image!");
        
        $finish;
    end

endmodule