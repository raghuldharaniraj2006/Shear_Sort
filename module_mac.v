module mac_unit #(
    parameter DATA_WIDTH = 16,
    parameter ACC_WIDTH  = 40
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   start,      
    input  wire [15:0]            vec_len,    
    output reg                    done,       
    input  wire [DATA_WIDTH-1:0]  weight,     
    input  wire [DATA_WIDTH-1:0]  activation, 
    output wire [ACC_WIDTH-1:0]   mac_out     
);

    parameter IDLE    = 2'b00;
    parameter COMPUTE = 2'b01;
    parameter FINISH  = 2'b10;

    reg [1:0]           state;
    reg [ACC_WIDTH-1:0] accumulator;
    reg [15:0]          count;
    
    wire [ (2*DATA_WIDTH)-1 : 0 ] product;
    assign product = weight * activation;
    assign mac_out = accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            accumulator <= 0;
            count       <= 0;
            done        <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        accumulator <= 0;
                        count       <= 0;
                        state       <= COMPUTE;
                    end
                end

                COMPUTE: begin
                    if (count < vec_len) begin
                        accumulator <= accumulator + product;
                        count       <= count + 1;
                    end
                    
                    // Transition to finish only after ALL elements are added
                    if (count == vec_len - 1) begin
                        state <= FINISH;
                    end
                end

                FINISH: begin
                    done  <= 1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule