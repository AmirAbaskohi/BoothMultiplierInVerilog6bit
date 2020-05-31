module arithmaticSHRReg(input ldQ,ldA,ldq0,shr,clk,inz,input [5:0]inQ,inA,output [5:0]outQ,outA,output outq0);
  reg [12:0]fullReg;
  always@(posedge clk)begin
    if(ldQ) fullReg[6:1] <= inQ;
    if(ldA) fullReg[12:7] <= inA; 
    if(inz) fullReg[12:7] <= 6'b000000;
    if(ldq0) fullReg[0] <= 1'b0;
    if(shr) fullReg <= {fullReg[12],fullReg[12:1]};
  end
  assign outA = fullReg[12:7];
  assign outQ = fullReg[6:1];
  assign outq0 = fullReg[0];
endmodule

module ALU(input q1,q0,input [5:0]A,M,output [5:0] out);
  assign out = ({q1,q0} == 2'b00 | {q1,q0} == 2'b11)?A : ({q1,q0} == 2'b01 ? A + M : A + ((M^6'b111111)+6'b000001));
endmodule 

module register(input clk,ldM,input [5:0]inM,output reg[5:0]outM);
  always@(posedge clk)begin
    if(ldM)outM <= inM;
  end
endmodule

module counter6(input ldc,dc,clk,output reg[3:0] counterNum);
  always@(posedge clk)begin
    if(ldc) counterNum <= 4'b0110;
    if(dc)  counterNum <= counterNum + 4'b1111;
  end
endmodule

module boothMult6DataPath(input clk,ldA,ldQ,sh,inz,ldq0,ldM,ldc,dc,input [5:0]inQ,inM,output [11:0]out,output [3:0]counterNum);
  wire [5:0] outM,outQ,outA,inA;
  wire outq0;
  register mreg(clk,ldM,inM,outM);
  arithmaticSHRReg shr(ldQ,ldA,ldq0,sh,clk,inz,inQ,inA,outQ,outA,outq0);
  ALU alu(outQ[0],outq0,outA,outM,inA);
  counter6 cnt(ldc,dc,clk,counterNum);
  assign out = {outA,outQ};
endmodule