module row_sort_3x3(in1,in2,in3,dir,o1,o2,o3);
input dir;
input [7:0]in1,in2,in3;
output [7:0]o1,o2,o3;

wire [7:0] s0,s1;
assign s0 = (in1 > in2) ? in2 : in1;
assign s1 = (in1 > in2) ? in1 : in2;

wire [7:0] s2,s3;
assign s2 = (in3 > s0) ? s0 : in3;
assign s3 = (in3 > s0) ? in3 : s0;

wire [7:0] s4,s5;
assign s4 = (s1 > s3) ? s3 : s1;
assign s5 = (s1 > s3) ? s1 : s3;

assign o1 = dir ? s5 : s2;
assign o2 = s4;
assign o3 = dir ? s2 : s5;

endmodule
