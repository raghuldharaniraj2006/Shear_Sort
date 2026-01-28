`timescale 1ns/1ps

module shear_sort_tb;

    // 1. Signals
    reg clk;
    reg rst;
    reg start;
    reg [7:0] in [15:0];
    wire [7:0] out [15:0];
    wire done;
    
    // For automatic checking
    reg [7:0] expected_out [15:0];
    integer i, j, tc;
    integer errors;

    // 2. Instantiate the Unit Under Test (UUT)
    shear_sort_pip_fsm_bitonic uut (
        .clk(clk), .rst(rst), .start(start),
        .in_1(in[0]),   .in_2(in[1]),   .in_3(in[2]),   .in_4(in[3]),
        .in_5(in[4]),   .in_6(in[5]),   .in_7(in[6]),   .in_8(in[7]),
        .in_9(in[8]),   .in_10(in[9]),  .in_11(in[10]), .in_12(in[11]),
        .in_13(in[12]), .in_14(in[13]), .in_15(in[14]), .in_16(in[15]),
        .out_1(out[0]),  .out_2(out[1]),  .out_3(out[2]),  .out_4(out[3]),
        .out_5(out[4]),  .out_6(out[5]),  .out_7(out[6]),  .out_8(out[7]),
        .out_9(out[8]),  .out_10(out[9]), .out_11(out[10]), .out_12(out[11]),
        .out_13(out[12]), .out_14(out[13]), .out_15(out[14]), .out_16(out[15]),
        .done(done)
    );

    // 3. Clock Generation
    always #5 clk = ~clk;

    // 4. Reference Task: Golden Model (The "Correct" answer)
    // This task sorts the 16 numbers in a snake pattern manually
    task golden_model;
        reg [7:0] temp [15:0];
        reg [7:0] swap;
        integer x, y;
        begin
            for(x=0; x<16; x=x+1) temp[x] = in[x];
            // Simple Bubble Sort to get the full 1D sorted list
            for(x=0; x<15; x=x+1) begin
                for(y=0; y<15-x; y=y+1) begin
                    if(temp[y] > temp[y+1]) begin
                        swap = temp[y];
                        temp[y] = temp[y+1];
                        temp[y+1] = swap;
                    end
                end
            end
            // Map to Snake Pattern (Row 1 and 3 descending)
            expected_out[0]=temp[0];   expected_out[1]=temp[1];   expected_out[2]=temp[2];   expected_out[3]=temp[3];
            expected_out[4]=temp[7];   expected_out[5]=temp[6];   expected_out[6]=temp[5];   expected_out[7]=temp[4];
            expected_out[8]=temp[8];   expected_out[9]=temp[9];   expected_out[10]=temp[10]; expected_out[11]=temp[11];
            expected_out[15]=temp[12]; expected_out[14]=temp[13]; expected_out[13]=temp[14]; expected_out[12]=temp[15];
        end
    endtask

    // 5. Main Simulation Loop
   initial begin
        clk = 0; rst = 1; start = 0; errors = 0;
        #100 rst = 0; // Hold reset for a few cycles
        #20;

        $display("--- Starting 1,000 Random Test Cases ---");

        for (tc = 1; tc <= 1000; tc = tc + 1) begin
            // 1. Prepare Data
            for (i = 0; i < 16; i = i + 1) in[i] = $random % 256;
            golden_model();

            // 2. Start the FSM
            @(posedge clk);
            start <= 1;
            @(posedge clk);
            start <= 0; // Immediately pull start low so FSM can move to DONE

            // 3. Wait for Done with a Safety Timeout
            fork : wait_or_timeout
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout;
                end
                begin
                    #1000; // If 100 cycles pass and no 'done'
                    $display("TC %0d: TIMEOUT! FSM HANG.", tc);
                    $finish;
                end
            join

            // 4. Check results
            for (j = 0; j < 16; j = j + 1) begin
                if (out[j] !== expected_out[j]) begin
                    errors = errors + 1;
                end
            end
            
            // 5. Return to IDLE properly
            @(posedge clk);
            wait(done == 0); // Wait for FSM to actually go back to IDLE
            
            if (tc % 100 == 0) $display("Checked %0d cases...", tc);
        end

        if (errors == 0)begin
            $display("*************************************");
            $display("TEST PASSED: 1000/1000 cases correct!");
            $display("*************************************");
        end
        else begin
            $display("TEST FAILED: %0d errors found.", errors);
        end
        $finish;
    end
endmodule