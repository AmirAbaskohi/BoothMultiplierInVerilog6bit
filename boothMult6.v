`timescale 1ns/1ns
module boothMult6(input [5:0]multiplicand,multiplier,input rst,start,clk,output ready,output [11:0]out);
  wire ldA,ldQ,sh,inz,ldq0,ldM,ldc,dc;
  wire [3:0]counterNum;
  boothMult6DataPath DP(clk,ldA,ldQ,sh,inz,ldq0,ldM,ldc,dc,multiplier,multiplicand,out,counterNum);
  boothMult6Controller CN(counterNum,rst,clk,start,ldA,ldQ,sh,inz,ldq0,ldM,ldc,dc,ready);
endmodule

module test();
  reg [5:0]multiplicand,multiplier;
  reg rst,start,clk;
  wire ready;
  wire [11:0]out;
  boothMult6 cut1(multiplicand,multiplier,rst,start,clk,ready,out);
  initial begin
    clk = 0;
    #100 rst = 1;
    #100 rst = 0;
    #100 multiplicand = 6'b010001; multiplier = 6'b010111;//17*23
    #100 start = 1;
    #1450 start = 0;
    #100 multiplicand = 6'b100001; multiplier = 6'b001011;//-31 * 11
    #100 start = 1;
    #1450 start = 0;
    #100 multiplicand = 6'b010100; multiplier = 6'b100011;//20 * -29
    #100 start = 1;
    #1450 start = 0;
    #100 multiplicand = 6'b110100; multiplier = 6'b110011;//-12 * -13
    #100 start = 1;
    #1450 start = 0;
    #100 multiplicand = 6'b000000; multiplier = 6'b001010;//0 * 18
    #100 start = 1;
    #1450 start = 0;
    #100 multiplicand = 6'b000101; multiplier = 6'b000000;//5 * 0
    #100 start = 1;
    #1450 start = 0;
    #100 $stop;
  end
  always #50 clk = ~clk;
endmodule