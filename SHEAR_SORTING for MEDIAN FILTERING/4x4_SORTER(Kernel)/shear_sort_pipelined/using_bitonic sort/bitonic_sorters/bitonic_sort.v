module bitonic_sort(in1,in2,in3,in4,dir,out1,out2,out3,out4);
input [7:0] in1,in2,in3,in4;
input dir;
output  [7:0] out1,out2,out3,out4;
wire [7:0] w1 [3:0];

assign w1[0] = (in1 > in2) ? in2 : in1;
assign w1[1] = (in1 > in2) ? in1 : in2;
assign w1[2] = (in3 > in4) ? in3 : in4;
assign w1[3] = (in3 > in4) ? in4 : in3;


wire [7:0] w2 [3:0];
assign w2[0] = (w1[0]  > w1[2]) ? w1[2] : w1[0];
assign w2[2] = (w1[0]  > w1[2]) ? w1[0] : w1[2];
assign w2[1] = (w1[1]  > w1[3]) ? w1[3] : w1[1];
assign w2[3] = (w1[1]  > w1[3]) ? w1[1] : w1[3];


wire [7:0] w3 [3:0];
assign w3[0] = (w2[0] > w2 [1]) ? w2[1] : w2[0];
assign w3[1] = (w2[0] > w2 [1]) ? w2[0] : w2[1];
assign w3[2] = (w2[2] > w2 [3]) ? w2[3] : w2[2];
assign w3[3] = (w2[2] > w2 [3]) ? w2[2] : w2[3];

assign out1 = dir ? w3[0] : w3[3];
assign out2 = dir ? w3[1] : w3[2];
assign out3 = dir ? w3[2] : w3[1];
assign out4 = dir ? w3[3] : w3[0];


endmodule
