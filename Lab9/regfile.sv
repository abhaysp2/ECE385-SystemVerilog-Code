module regfile(input logic CLK, RESET, AVL_WRITE, AVL_READ, AVL_CS,
                   input  logic [3:0]AVL_BYTE_EN, AVL_ADDR,
                   input  logic [31:0] D,
                    output logic [31:0] Output);
           
logic [15:0][31:0] REG; //representation of dat
logic [31:0] Change;
           
always_ff @ (posedge CLK)
    begin
        if (RESET)      //set all 16 registers to 0
            begin
                REG[0] <= 31'h0;
                REG[1] <= 31'h0;
                REG[2] <= 31'h0;
                REG[3] <= 31'h0;
                REG[4] <= 31'h0;
                REG[5] <= 31'h0;
                REG[6] <= 31'h0;
                REG[7] <= 31'h0;
                REG[8] <= 31'h0;
                REG[9] <= 31'h0;
                REG[10] <= 31'h0;
                REG[11] <= 31'h0;
                REG[12] <= 31'h0;
                REG[13] <= 31'h0;
                REG[14] <= 31'h0;
                REG[15] <= 31'h0;
            end    
        else if (AVL_WRITE & AVL_CS)            //output register specified by addr
            case(AVL_ADDR)
                4'b0000: REG[0] <= Change;     
                4'b0001: REG[1] <= Change;
                4'b0010: REG[2] <= Change;
                4'b0011: REG[3] <= Change;
                4'b0100: REG[4] <= Change;
                4'b0101: REG[5] <= Change;
                4'b0110: REG[6] <= Change;
                4'b0111: REG[7] <= Change;
                4'b1000: REG[8] <= Change;
                4'b1001: REG[9] <= Change;
                4'b1010: REG[10] <= Change;
                4'b1011: REG[11] <= Change;
                4'b1100: REG[12] <= Change;
                4'b1101: REG[13] <= Change;
                4'b1110: REG[14] <= Change;
                4'b1111: REG[15] <= Change;
                default: ;
            endcase
    end
   
always_comb
    begin  
        case(AVL_BYTE_EN) //selects REGput data selected by SR1_Input      
            4'b0001: Change[7:0] = D[7:0];
            4'b0010: Change[15:8] = D[15:8];
            4'b0100: Change[23:16] = D[23:16];
            4'b1000: Change[31:24] = D[31:24];
            4'b0011: Change[15:0] = D[15:0];
            4'b1100: Change[31:16] = D[31:16];
            4'b1111: Change = D;
            default: ;
        endcase
    if (AVL_READ & AVL_CS)          //load register specified by addr
            case(AVL_ADDR)
                4'b0000: Output = REG[0];     
                4'b0001: Output = REG[1];
                4'b0010: Output = REG[2];
                4'b0011: Output = REG[3];
                4'b0100: Output = REG[4];
                4'b0101: Output = REG[5];
                4'b0110: Output = REG[6];
                4'b0111: Output = REG[7];
                4'b1000: Output = REG[8];
                4'b1001: Output = REG[9];
                4'b1010: Output = REG[10];
                4'b1011: Output = REG[11];
                4'b1100: Output = REG[12];
                4'b1101: Output = REG[13];
                4'b1110: Output = REG[14];
                4'b1111: Output = REG[15];
                default: ;
            endcase
    end
endmodule