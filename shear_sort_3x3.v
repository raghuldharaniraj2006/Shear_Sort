`include "row_sort_3x3.v"

module shear_sort_3x3 (start,clk,rst,in1,in2,in3,in4,in5,in6,in7,in8,in9,o1,o2,o3,o4,o5,o6,o7,o8,o9,done);
input start,clk,rst;
input [7:0] in1,in2,in3,in4,in5,in6,in7,in8,in9;
output  [7:0] o1,o2,o3,o4,o5,o6,o7,o8,o9;
output reg done;

reg [1:0] iter_counter;

reg [1:0]state;
localparam  IDLE = 2'b00;
localparam  LOAD = 2'b01;
localparam  SORTER = 2'b10;
localparam  DONE = 2'b11;

reg [7:0] in_mat [8:0];
wire [7:0] rw [8:0];
wire [7:0] cl [8:0];


//rowsort
row_sort_3x3 r1 (in_mat[0],in_mat[1],in_mat[2],1'b0,rw[0],rw[1],rw[2]);
row_sort_3x3 r2 (in_mat[3],in_mat[4],in_mat[5],1'b1,rw[3],rw[4],rw[5]);
row_sort_3x3 r3 (in_mat[6],in_mat[7],in_mat[8],1'b0,rw[6],rw[7],rw[8]);

//column sort

row_sort_3x3 c1 (rw[0],rw[3],rw[6],1'b0,cl[0],cl[3],cl[6]);
row_sort_3x3 c2 (rw[1],rw[4],rw[7],1'b0,cl[1],cl[4],cl[7]);
row_sort_3x3 c3 (rw[2],rw[5],rw[8],1'b0,cl[2],cl[5],cl[8]);



always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        iter_counter <= 0;
        done <= 0;

    end
    else
    begin
        case(state)
        IDLE : begin
                    done <= 0;
                    iter_counter <= 0;
                    if (start) state <= LOAD; 
              end

        LOAD : begin
                    in_mat[0] <= in1; in_mat[1] <= in2; in_mat[2] <= in3;
                    in_mat[3] <= in4; in_mat[4] <= in5; in_mat[5] <= in6;
                    in_mat[6] <= in7; in_mat[7] <= in8; in_mat[8] <= in9;
                    state <= SORTER;
                end

        SORTER : begin
                    in_mat[0] <= cl[0]; in_mat[1] <= cl[1]; in_mat[2] <= cl[2];
                    in_mat[3] <= cl[3]; in_mat[4] <= cl[4]; in_mat[5] <= cl[5];
                    in_mat[6] <= cl[6]; in_mat[7] <= cl[7]; in_mat[8] <= cl[8];
                    

                     if (iter_counter == 2) state <= DONE;
                else begin 
                    iter_counter <= iter_counter + 1;
                     end

                    end

        
        DONE: begin
                    done <= 1;
                    if (!start) state <= IDLE;
              end




        endcase


    end



end

assign o1 = in_mat[0];  
assign o2 = in_mat[1]; 
assign o3 = in_mat[2]; 
assign o4 = in_mat[3]; 
assign o5 = in_mat[4];  
assign o6 = in_mat[5]; 
assign o7 = in_mat[6]; 
assign o8 = in_mat[7]; 
assign o9 = in_mat[8]; 


endmodule