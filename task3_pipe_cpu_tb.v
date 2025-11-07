`timescale 1ns/1ps
module tb_task3_pipe_cpu;
    reg clk, rst;
    task3_pipe_cpu uut (.clk(clk), .rst(rst));
    initial clk = 0;
    always #5 clk = ~clk;
    initial begin
        rst = 1; #20; rst = 0;
        uut.data_mem[0] = 8'h05;
        uut.data_mem[1] = 8'h03;
        #200;
        $display("Reg0=%h Reg1=%h Reg2=%h Reg3=%h", uut.regfile[0], uut.regfile[1], uut.regfile[2], uut.regfile[3]);
        $stop;
    end
endmodule
