
`include "shear_sort_3x3.v"

`timescale 1ns/1ps

module shear_sort_sliding_tb();
    reg clk, rst, start;
    reg [7:0] in1, in2, in3, in4, in5, in6, in7, in8, in9;
    wire [7:0] o1, o2, o3, o4, o5, o6, o7, o8, o9;
    wire done;

    // File handling variables
    integer file_in, file_out, status;
    
    // Instantiate your shear_sort_3x3 module
    shear_sort_3x3 dut (
        .start(start), .clk(clk), .rst(rst),
        .in1(in1), .in2(in2), .in3(in3),
        .in4(in4), .in5(in5), .in6(in6),
        .in7(in7), .in8(in8), .in9(in9),
        .o1(o1), .o2(o2), .o3(o3),
        .o4(o4), .o5(o5), .o6(o6),
        .o7(o7), .o8(o8), .o9(o9),
        .done(done)
    );

    // Clock Generation (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        start = 0;
        
        // Open the files
        file_in = $fopen("girl_output.hex", "r");
        file_out = $fopen("image_output_girl_3x3.hex", "w");

        if (file_in == 0) begin
            $display("Error: Could not open input file.");
            $finish;
        end

        // Reset sequence
        #20 rst = 0;
        #10;

        // Process each 3x3 window from the file
        while (!$feof(file_in)) begin
            // Read 9 hex values from one line of the file
            status = $fscanf(file_in, "%h %h %h %h %h %h %h %h %h\n", 
                             in1, in2, in3, in4, in5, in6, in7, in8, in9);
            
            if (status == 9) begin
                @(posedge clk);
                start = 1;      // Trigger the LOAD and SORTER states
                
                wait(done);     // Wait for the state machine to reach DONE state
                
                // Save the median (o5) to our output hex file
                $fwrite(file_out, "%02x\n", o5);
                
                @(posedge clk);
                start = 0;      // Return to IDLE
            end
        end

        // Cleanup
        $fclose(file_in);
        $fclose(file_out);
        $display("Median filtering complete. Output saved to image_output_girl_3x3.hex");
        $finish;
    end

endmodule