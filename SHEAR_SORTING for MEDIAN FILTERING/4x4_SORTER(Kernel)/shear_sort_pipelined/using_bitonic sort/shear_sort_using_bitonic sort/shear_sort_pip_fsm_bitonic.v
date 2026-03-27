`include "bitonic_sort.v"


module shear_sort_pip_fsm_bitonic(clk,rst,start,in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16,
out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_10,out_11,out_12,out_13,out_14,out_15,out_16,done);

input clk,rst,start;
input [7:0]in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16;
output [7:0]out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_10,out_11,out_12,out_13,out_14,out_15,out_16;
output reg done;

reg [1:0] iter_counter;

reg [1:0]state;
localparam  IDLE = 2'b00;
localparam  LOAD = 2'b01;
localparam  SORTER = 2'b10;
localparam  DONE = 2'b11;

reg [7:0] in_mat [15:0] ;
wire [7:0] rw [15:0];
wire [7:0] cl [15:0];


bitonic_sort r0 (in_mat[0],in_mat[1],in_mat[2],in_mat[3],1'b1,rw[0],rw[1],rw[2],rw[3]);
bitonic_sort r1 (in_mat[4],in_mat[5],in_mat[6],in_mat[7],1'b0,rw[4],rw[5],rw[6],rw[7]);
bitonic_sort r2 (in_mat[8],in_mat[9],in_mat[10],in_mat[11],1'b1,rw[8],rw[9],rw[10],rw[11]);
bitonic_sort r3 (in_mat[12],in_mat[13],in_mat[14],in_mat[15],1'b0,rw[12],rw[13],rw[14],rw[15]);

bitonic_sort c0 (rw[0],  rw[4],  rw[8],  rw[12],1'b1,
                cl[0],  cl[4],  cl[8],  cl[12]);

bitonic_sort c1 (rw[1],  rw[5],  rw[9],  rw[13],1'b1,
                cl[1],  cl[5],  cl[9],  cl[13]);

bitonic_sort c2 (rw[2],  rw[6],  rw[10], rw[14],1'b1,
                cl[2],  cl[6],  cl[10], cl[14]);
bitonic_sort c3 (rw[3],  rw[7],  rw[11], rw[15],1'b1,
                cl[3],  cl[7],  cl[11], cl[15]);

always @ (posedge clk or posedge rst)
begin
    if (rst)
    begin
        state <= IDLE;
        iter_counter <= 0;
        done <= 0;
    end
    else
    begin
        case (state)

        IDLE : begin
                    done <= 0;
                    iter_counter <= 0;
                    if (start) state <= LOAD; 
              end

        LOAD : begin
                    in_mat[0] <= in_1; in_mat[1] <= in_2; in_mat[2] <= in_3; in_mat[3] <= in_4;
                    in_mat[4] <= in_5; in_mat[5] <= in_6; in_mat[6] <= in_7; in_mat[7] <= in_8;
                    in_mat[8] <= in_9; in_mat[9] <= in_10; in_mat[10] <= in_11; in_mat[11] <= in_12;
                    in_mat[12] <= in_13; in_mat[13] <= in_14; in_mat[14] <= in_15; in_mat[15] <= in_16;
                    state <= SORTER;
               end

        SORTER : begin
                in_mat[0] <= cl[0]; in_mat[1] <= cl[1]; in_mat[2] <= cl[2]; in_mat[3] <= cl[3];
                in_mat[4] <= cl[4]; in_mat[5] <= cl[5]; in_mat[6] <= cl[6]; in_mat[7] <= cl[7];
                in_mat[8] <= cl[8]; in_mat[9] <= cl[9]; in_mat[10] <= cl[10]; in_mat[11] <= cl[11];
                in_mat[12] <= cl[12]; in_mat[13] <= cl[13]; in_mat[14] <= cl[14]; in_mat[15] <= cl[15];

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

assign out_1 = in_mat[0]; 
assign out_2 = in_mat[1]; 
assign out_3 = in_mat[2]; 
assign out_4 = in_mat[3]; 
assign out_5 = in_mat[4]; 
assign out_6 = in_mat[5]; 
assign out_7 = in_mat[6]; 
assign out_8 = in_mat[7]; 
assign out_9 = in_mat[8]; 
assign out_10 = in_mat[9]; 
assign out_11 = in_mat[10]; 
assign out_12 = in_mat[11]; 
assign out_13 = in_mat[12]; 
assign out_14 = in_mat[13]; 
assign out_15 = in_mat[14]; 
assign out_16 = in_mat[15]; 



















endmodule