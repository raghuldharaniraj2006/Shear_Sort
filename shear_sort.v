`include "row_sort.v"
`include "column_sort.v"


module shear_sort(in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16,
out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_10,out_11,out_12,out_13,out_14,out_15,out_16);

input [7:0] in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16; 
output [7:0] out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9,out_10,out_11,out_12,out_13,out_14,out_15,out_16;

//iteration 1

//row sort_s1
wire [7:0] in_mat[3:0][3:0];

assign in_mat[0][0]=in_1;
assign in_mat[0][1]=in_2;
assign in_mat[0][2]=in_3;
assign in_mat[0][3]=in_4;
assign in_mat[1][0]=in_5;
assign in_mat[1][1]=in_6;
assign in_mat[1][2]=in_7;
assign in_mat[1][3]=in_8;
assign in_mat[2][0]=in_9;
assign in_mat[2][1]=in_10;
assign in_mat[2][2]=in_11;
assign in_mat[2][3]=in_12;
assign in_mat[3][0]=in_13;
assign in_mat[3][1]=in_14;
assign in_mat[3][2]=in_15;
assign in_mat[3][3]=in_16;


wire [7:0] row_sort_0[3:0];
row_sort r1 (in_mat[0][0],in_mat[0][1],in_mat[0][2],in_mat[0][3],row_sort_0[0],row_sort_0[1],row_sort_0[2],row_sort_0[3]);

wire [7:0] row_sort_1[3:0];
row_sort r2 (in_mat[1][0],in_mat[1][1],in_mat[1][2],in_mat[1][3],row_sort_1[3],row_sort_1[2],row_sort_1[1],row_sort_1[0]);

wire [7:0] row_sort_2[3:0];
row_sort r3 (in_mat[2][0],in_mat[2][1],in_mat[2][2],in_mat[2][3],row_sort_2[0],row_sort_2[1],row_sort_2[2],row_sort_2[3]);

wire [7:0] row_sort_3[3:0];
row_sort r4 (in_mat[3][0],in_mat[3][1],in_mat[3][2],in_mat[3][3],row_sort_3[3],row_sort_3[2],row_sort_3[1],row_sort_3[0]);

//column sort_s1
wire [7:0] col_sort_0[3:0];
column_sort c1 (row_sort_0[0],row_sort_1[0],row_sort_2[0],row_sort_3[0],col_sort_0[0],col_sort_0[1],col_sort_0[2],col_sort_0[3]);

wire [7:0] col_sort_1[3:0];
column_sort c2 (row_sort_0[1],row_sort_1[1],row_sort_2[1],row_sort_3[1],col_sort_1[0],col_sort_1[1],col_sort_1[2],col_sort_1[3]);

wire [7:0] col_sort_2[3:0];
column_sort c3 (row_sort_0[2],row_sort_1[2],row_sort_2[2],row_sort_3[2],col_sort_2[0],col_sort_2[1],col_sort_2[2],col_sort_2[3]);

wire [7:0] col_sort_3[3:0];
column_sort c4 (row_sort_0[3],row_sort_1[3],row_sort_2[3],row_sort_3[3],col_sort_3[0],col_sort_3[1],col_sort_3[2],col_sort_3[3]);

//out_1
wire [7:0]out_s1[16:1];

assign out_s1[1] = col_sort_0[0];
assign out_s1[2] = col_sort_1[0];
assign out_s1[3] = col_sort_2[0];
assign out_s1[4] = col_sort_3[0];

assign out_s1[5] = col_sort_0[1];
assign out_s1[6] = col_sort_1[1];
assign out_s1[7] = col_sort_2[1];
assign out_s1[8] = col_sort_3[1];

assign out_s1[9]= col_sort_0[2];
assign out_s1[10]= col_sort_1[2];
assign out_s1[11]= col_sort_2[2];
assign out_s1[12]= col_sort_3[2];

assign out_s1[13]= col_sort_0[3];
assign out_s1[14]= col_sort_1[3];
assign out_s1[15]= col_sort_2[3];
assign out_s1[16]= col_sort_3[3];

//iteration 2

//row_sort s2

wire [7:0] row_sort_4[3:0];
row_sort r5 (out_s1[1],out_s1[2],out_s1[3],out_s1[4],row_sort_4[0],row_sort_4[1],row_sort_4[2],row_sort_4[3]);

wire [7:0] row_sort_5[3:0];
row_sort r6 (out_s1[5],out_s1[6],out_s1[7],out_s1[8],row_sort_5[3],row_sort_5[2],row_sort_5[1],row_sort_5[0]);

wire [7:0] row_sort_6[3:0];
row_sort r7 (out_s1[9],out_s1[10],out_s1[11],out_s1[12],row_sort_6[0],row_sort_6[1],row_sort_6[2],row_sort_6[3]);

wire [7:0] row_sort_7[3:0];
row_sort r8 (out_s1[13],out_s1[14],out_s1[15],out_s1[16],row_sort_7[3],row_sort_7[2],row_sort_7[1],row_sort_7[0]);

//column sort s2

wire [7:0] col_sort_4[3:0];
column_sort c5 (row_sort_4[0],row_sort_5[0],row_sort_6[0],row_sort_7[0],col_sort_4[0],col_sort_4[1],col_sort_4[2],col_sort_4[3]);

wire [7:0] col_sort_5[3:0];
column_sort c6 (row_sort_4[1],row_sort_5[1],row_sort_6[1],row_sort_7[1],col_sort_5[0],col_sort_5[1],col_sort_5[2],col_sort_5[3]);

wire [7:0] col_sort_6[3:0];
column_sort c7 (row_sort_4[2],row_sort_5[2],row_sort_6[2],row_sort_7[2],col_sort_6[0],col_sort_6[1],col_sort_6[2],col_sort_6[3]);

wire [7:0] col_sort_7[3:0];
column_sort c8 (row_sort_4[3],row_sort_5[3],row_sort_6[3],row_sort_7[3],col_sort_7[0],col_sort_7[1],col_sort_7[2],col_sort_7[3]);


//out_2
wire [7:0]out_s2[16:1];

assign out_s2[1] = col_sort_4[0];
assign out_s2[2] = col_sort_5[0];
assign out_s2[3] = col_sort_6[0];
assign out_s2[4] = col_sort_7[0];

assign out_s2[5] = col_sort_4[1];
assign out_s2[6] = col_sort_5[1];
assign out_s2[7] = col_sort_6[1];
assign out_s2[8] = col_sort_7[1];

assign out_s2[9]= col_sort_4[2];
assign out_s2[10]= col_sort_5[2];
assign out_s2[11]= col_sort_6[2];
assign out_s2[12]= col_sort_7[2];

assign out_s2[13]= col_sort_4[3];
assign out_s2[14]= col_sort_5[3];
assign out_s2[15]= col_sort_6[3];
assign out_s2[16]= col_sort_7[3];


// iteration 3


//row_sort s3

wire [7:0] row_sort_8[3:0];
row_sort r9 (out_s2[1],out_s2[2],out_s2[3],out_s2[4],row_sort_8[0],row_sort_8[1],row_sort_8[2],row_sort_8[3]);

wire [7:0] row_sort_9[3:0];
row_sort r10 (out_s2[5],out_s2[6],out_s2[7],out_s2[8],row_sort_9[3],row_sort_9[2],row_sort_9[1],row_sort_9[0]);

wire [7:0] row_sort_10[3:0];
row_sort r11 (out_s2[9],out_s2[10],out_s2[11],out_s2[12],row_sort_10[0],row_sort_10[1],row_sort_10[2],row_sort_10[3]);

wire [7:0] row_sort_11[3:0];
row_sort r12 (out_s2[13],out_s2[14],out_s2[15],out_s2[16],row_sort_11[3],row_sort_11[2],row_sort_11[1],row_sort_11[0]);


//column sort s3

wire [7:0] col_sort_8[3:0];
column_sort c9 (row_sort_8[0],row_sort_9[0],row_sort_10[0],row_sort_11[0],col_sort_8[0],col_sort_8[1],col_sort_8[2],col_sort_8[3]);

wire [7:0] col_sort_9[3:0];
column_sort c10 (row_sort_8[1],row_sort_9[1],row_sort_10[1],row_sort_11[1],col_sort_9[0],col_sort_9[1],col_sort_9[2],col_sort_9[3]);

wire [7:0] col_sort_10[3:0];
column_sort c11 (row_sort_8[2],row_sort_9[2],row_sort_10[2],row_sort_11[2],col_sort_10[0],col_sort_10[1],col_sort_10[2],col_sort_10[3]);

wire [7:0] col_sort_11[3:0];
column_sort c12 (row_sort_8[3],row_sort_9[3],row_sort_10[3],row_sort_11[3],col_sort_11[0],col_sort_11[1],col_sort_11[2],col_sort_11[3]);



//sorted matrix

assign out_1 = col_sort_8[0];
assign out_2 = col_sort_9[0];
assign out_3 = col_sort_10[0];
assign out_4 = col_sort_11[0];

assign out_5 = col_sort_8[1];
assign out_6 = col_sort_9[1];
assign out_7 = col_sort_10[1];
assign out_8 = col_sort_11[1];

assign out_9= col_sort_8[2];
assign out_10= col_sort_9[2];
assign out_11= col_sort_10[2];
assign out_12= col_sort_11[2];

assign out_13= col_sort_8[3];
assign out_14= col_sort_9[3];
assign out_15= col_sort_10[3];
assign out_16= col_sort_11[3];


endmodule