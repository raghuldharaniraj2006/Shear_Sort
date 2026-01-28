module bitonic_sort(clk,rst,in1,in2,in3,in4,dir,out1,out2,out3,out4);
input [7:0] in1,in2,in3,in4;
input dir,clk,rst;
output reg [7:0] out1,out2,out3,out4;
wire [7:0] w1 [3:0];

assign w1[0] = (in1 > in2) ? in2 : in1;
assign w1[1] = (in1 > in2) ? in1 : in2;
assign w1[2] = (in3 > in4) ? in3 : in4;
assign w1[3] = (in3 > in4) ? in4 : in3;


reg dir1;
reg [7:0] r1 [3:0];
always @ (posedge clk or posedge rst)
begin
        if (rst)
        begin
            r1[0] <= 0;
            r1[1] <= 0;
            r1[2] <= 0;
            r1[3] <= 0;
            dir1 <= 0;
        end
        else
        begin
            r1[0] <= w1[0];
            r1[1] <= w1[1];
            r1[2] <= w1[2];
            r1[3] <= w1[3];
            dir1 <= dir;
        end
end

wire [7:0] w2 [3:0];
assign w2[0] = (r1[0]  > r1[2]) ? r1[2] : r1[0];
assign w2[2] = (r1[0]  > r1[2]) ? r1[0] : r1[2];
assign w2[1] = (r1[1]  > r1[3]) ? r1[3] : r1[1];
assign w2[3] = (r1[1]  > r1[3]) ? r1[1] : r1[3];

reg [7:0] r2 [3:0];
reg dir2;
always @ (posedge clk or posedge rst)
begin
        if (rst)
        begin
            r2[0] <= 0;
            r2[1] <= 0;
            r2[2] <= 0;
            r2[3] <= 0;
            dir2 <= 0;
        end
        else
        begin
            r2[0] <= w2[0];
            r2[1] <= w2[1];
            r2[2] <= w2[2];
            r2[3] <= w2[3];
            dir2 <= dir1;;
        end
end


wire [7:0] w3 [3:0];
assign w3[0] = (r2[0] > r2 [1]) ? r2[1] : r2[0];
assign w3[1] = (r2[0] > r2 [1]) ? r2[0] : r2[1];
assign w3[2] = (r2[2] > r2 [3]) ? r2[3] : r2[2];
assign w3[3] = (r2[2] > r2 [3]) ? r2[2] : r2[3];

always @ (posedge clk or posedge rst)
begin
    if (rst)
        begin
            out1 <= 0;
            out2 <= 0;
            out3 <= 0;
            out4 <= 0;
        end
    else
        begin
            if (dir2)       //1 for assending and 0 for desending
            begin
                out1 <= w3[0];
                out2 <= w3[1];
                out3 <= w3[2];
                out4 <= w3[3];
            end   
            else
            begin
                out1 <= w3[3];
                out2 <= w3[2];
                out3 <= w3[1];
                out4 <= w3[0];


            end        

        end

end



endmodule
