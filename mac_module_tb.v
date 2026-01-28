`timescale 1ns / 1ps

module mac_unit_tb;

    parameter DATA_WIDTH = 16;
    parameter ACC_WIDTH  = 40;
    parameter CLK_PERIOD = 10;

    reg                   clk;
    reg                   rst_n;
    reg                   start;
    reg  [15:0]           vec_len;
    reg  [DATA_WIDTH-1:0] weight;
    reg  [DATA_WIDTH-1:0] activation;
    
    wire                  done;
    wire [ACC_WIDTH-1:0]  mac_out;

    mac_unit #(DATA_WIDTH, ACC_WIDTH) uut (
        .clk(clk), .rst_n(rst_n), .start(start), .vec_len(vec_len),
        .done(done), .weight(weight), .activation(activation), .mac_out(mac_out)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        // Reset
        rst_n = 0; start = 0; vec_len = 0; weight = 0; activation = 0;
        #(CLK_PERIOD * 2);
        rst_n = 1; 
        
        @(posedge clk); 

        // --- Test Case: (2*5) + (3*4) + (10*2) + (5*5) = 67 ---
        $display("Starting MAC Simulation with 4 sets...");
        
        @(posedge clk);
        start      <= 1;
        vec_len    <= 4;
        
        // Wait for FSM to move from IDLE to COMPUTE
        @(posedge clk);
        start      <= 0; 
        weight     <= 16'd2;  activation <= 16'd5;  // Set 1
        
        @(posedge clk);
        weight     <= 16'd3;  activation <= 16'd4;  // Set 2
        
        @(posedge clk);
        weight     <= 16'd10; activation <= 16'd2;  // Set 3
        
        @(posedge clk);
        weight     <= 16'd5;  activation <= 16'd5;  // Set 4
        
        @(posedge clk);
        weight     <= 0; activation <= 0;

        // Wait for Done
        wait(done);
        @(posedge clk); 
        
        $display("Final Accumulation: %d (Expected: 67)", mac_out);
        
        if(mac_out == 67) 
            $display("SUCCESS: MAC matches 67.");
        else 
            $display("ERROR: Mismatch! Got %d", mac_out);

        #(CLK_PERIOD * 5);
        $finish;
    end

endmodule