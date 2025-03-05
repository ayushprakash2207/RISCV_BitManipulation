/*
ALU module, which takes two operands of size 32-bits each and a 4-bit ALU_control as input.
Operation is performed on the basis of ALU_control value and output is 32-bit ALU_result. 
If the ALU_result is zero, a ZERO FLAG is set.
*/

/*
ALU Control lines | Function
-----------------------------
        0000    Bitwise-AND
        0001    Bitwise-OR
        0010	Add (A+B)
        0100	Subtract (A-B)
        1000	Set on less than
        0011    Shift left logical
        0101    Shift right logical
        0110    Multiply
        0111    Bitwise-XOR
*/

module ALU (
    input [31:0] in1,in2, 
    input[3:0] alu_control,
    output reg [31:0] alu_result,
    output reg zero_flag
);

    integer n, n1, n2;
    reg [31:0] temp_one, temp_zero;
    
    always @(*)
    begin
        // Operating based on control input
        case(alu_control)

        4'b0000: alu_result = in1&in2;
        4'b0001: alu_result = in1|in2;
        4'b0010: alu_result = in1+in2;
        4'b0100: alu_result = in1-in2;
        4'b1000: begin 
            if(in1<in2)
            alu_result = 1;
            else
            alu_result = 0;
        end
        4'b0011: alu_result = in1<<in2;
        4'b0101: alu_result = in1>>in2;
        4'b0110: alu_result = in1*in2;
        4'b0111: alu_result = in1^in2;
        4'b1001: begin
            n1 = 0;
            n2 = 0;
            temp_one = 32'b0;
            temp_zero = 32'b0;
            alu_result = 32'b0;
            
            for (n = 0; n < 32; n = n + 1) begin
              if (in2[n]) begin
                temp_one[n1] = in1[n]; // Store masked bits first
                n1 = n1 + 1;
              end else begin
                temp_zero[n2] = in1[n]; // Store unmasked bits later
                n2 = n2 + 1;
              end
            end
            
            alu_result = (temp_zero << n1) | temp_one;
        end
        4'b1010: begin
            
            n1 = 0;
            for(n = 0;n < 32;n=n+1) begin
                if(in2[n] == 1'b1)
                begin
                    alu_result[n] = in1[n1];
                    n1 = n1 + 1;
                end
            end
            for(n = 0;n < 32;n=n+1) begin
                if(in2[n] == 1'b0)
                begin
                    alu_result[n] = in1[n1];
                    n1 = n1 + 1;
                end
            end
        end

        endcase

        // Setting Zero_flag if ALU_result is zero
        if (alu_result == 0)
            zero_flag = 1'b1;
        else
            zero_flag = 1'b0;
        
    end
endmodule