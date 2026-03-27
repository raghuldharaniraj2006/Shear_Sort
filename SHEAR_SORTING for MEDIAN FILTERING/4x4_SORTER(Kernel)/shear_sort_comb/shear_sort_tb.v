`include "shear_sort.v"

module shear_sort_tb();
reg [7:0] in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16;
wire [7:0] out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_10,out_11,out_12,out_13,out_14,out_15,out_16;

shear_sort dut (in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16,
out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_10,out_11,out_12,out_13,out_14,out_15,out_16);

initial begin
    
    
   
    in_1 = 8'd255;
    in_2 = 8'd250;
    in_3 = 8'd245;
    in_4 = 8'd240;
   

    in_5 = 8'd100;
    in_6 = 8'd110;
    in_7 = 8'd120;
    in_8 = 8'd130;
   
    in_9 = 8'd200;
    in_10 = 8'd190;
    in_11 = 8'd180;
    in_12 = 8'd170;
   
    in_13 = 8'd10;
    in_14 = 8'd20;
    in_15 = 8'd30;
    in_16 = 8'd40;


    #5

    in_1 = 8'd16; in_2 = 8'd6; in_3 = 8'd4; in_4 = 8'd13;

    in_5 = 8'd9;  in_6 = 8'd1; in_7 = 8'd11; in_8 = 8'd12;
  
    in_9 = 8'd3;  in_10= 8'd7;  in_11= 8'd15;  in_12= 8'd5;
   
    in_13= 8'd10;  in_14= 8'd2;  in_15= 8'd8;  in_16= 8'd14;

 

end

initial
#3 $monitor(" __%d__%d__%d__%d__%d__%d__%d__%d__%d__%d__%d__%d__%d__%d__%d__%d__",out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_10,out_11,out_12,out_13,out_14,out_15,out_16);

endmodule