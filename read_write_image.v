module image_loader;
    // 1. Define memory: 16 addresses, each 8-bits wide
    reg [7:0] image_data [0:15]; 
    integer i;

    initial begin
        // 2. Load the Hex file into memory
        // Make sure "input_pixels.hex" is in your project folder
        $readmemh("input_pixels.hex", image_data);

        // 3. Print to console to check
        for (i = 0; i < 16; i = i + 1) begin
            $display("Pixel %0d = %h", i, image_data[i]);
        end
    end
endmodule