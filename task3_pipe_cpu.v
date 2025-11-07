module task3_pipe_cpu (
    input wire clk,
    input wire rst
);
    reg [7:0] instr_mem [0:7];
    reg [7:0] data_mem  [0:15];
    reg [7:0] regfile   [0:3];
    reg [7:0] IF_ID_instr;
    reg [7:0] ID_EX_instr;
    reg [7:0] EX_WB_instr;
    reg [7:0] EX_WB_alu_out;
    reg [7:0] WB_result;
    reg [2:0] pc;
    integer i;
    initial begin
        for (i=0; i<8; i=i+1) instr_mem[i] = 8'h00;
        for (i=0; i<16; i=i+1) data_mem[i] = 8'h00;
        for (i=0; i<4; i=i+1) regfile[i] = 8'h00;
        instr_mem[0] = 8'b11000000;
        instr_mem[1] = 8'b11010001;
        instr_mem[2] = 8'b01001001;
        instr_mem[3] = 8'b01011000;
        instr_mem[4] = 8'b00000000;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 3'd0;
            IF_ID_instr <= 8'h00;
            ID_EX_instr <= 8'h00;
            EX_WB_instr <= 8'h00;
            EX_WB_alu_out <= 8'h00;
            WB_result <= 8'h00;
        end else begin
            IF_ID_instr <= instr_mem[pc];
            pc <= pc + 1;
            ID_EX_instr <= IF_ID_instr;
            EX_WB_instr <= ID_EX_instr;
            case (EX_WB_instr[7:6])
                2'b01: EX_WB_alu_out <= regfile[EX_WB_instr[3:2]] + regfile[EX_WB_instr[1:0]];
                2'b10: EX_WB_alu_out <= regfile[EX_WB_instr[3:2]] - regfile[EX_WB_instr[1:0]];
                2'b11: EX_WB_alu_out <= data_mem[EX_WB_instr[1:0]];
                default: EX_WB_alu_out <= 8'h00;
            endcase
            WB_result <= EX_WB_alu_out;
            if (EX_WB_instr[7:6] != 2'b00)
                regfile[EX_WB_instr[5:4]] <= EX_WB_alu_out;
        end
    end
endmodule
