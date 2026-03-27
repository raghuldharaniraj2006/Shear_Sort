module column_sort(in_0,in_1,in_2,in_3,out0,out1,out2,out3);
input [7:0] in_0,in_1,in_2,in_3;

output [7:0]out0,out1,out2,out3;

//intermediate wires
wire [7:0] s_0,s_1,s_2,s_3;
wire [7:0] s1_0,s1_1,s1_2,s1_3;
wire [7:0] s2_0,s2_1,s2_2,s2_3;

        //stage 0
       

      assign  s_0 = (in_0 > in_1) ? in_1 : in_0;
      assign s_1 = (in_0 > in_1) ? in_0 : in_1;
        assign s_2 = (in_2 > in_3) ? in_3 : in_2;
        assign s_3 = (in_2 > in_3) ? in_2 : in_3;

        //stage 1
       

       assign  s1_0 = (s_0 > s_2) ? s_2 : s_0;
       assign  s1_1 = (s_0 > s_2) ? s_0 : s_2;
       assign  s1_2 = (s_1 > s_3) ? s_3 : s_1;
       assign  s1_3 = (s_1 > s_3) ? s_1 : s_3;

        //stage 2

     

       assign  s2_0 = s1_0;
       assign  s2_1 = (s1_1 > s1_2) ? s1_2 : s1_1;
       assign  s2_2 = (s1_1 > s1_2) ? s1_1 : s1_2;
        assign s2_3 = s1_3;

        //sorted 
      assign   out0 = s2_0;
       assign  out1 = s2_1;
       assign  out2 = s2_2;
       assign  out3 = s2_3;

   





endmodule
