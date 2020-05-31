module boothMult6Controller(input[3:0]counterNum,input rst,clk,start,output reg ldA,ldQ,sh,inz,ldq0,ldM,ldc,dc,ready);
  reg [2:0] ns,ps;
  always@(posedge clk, posedge rst)
    if(rst) ps <= 2'b00;
    else ps <= ns;
  always@(ps,counterNum,start)begin
    if(rst) ns <= 2'b00;
    else begin
      case(ps)
        0 : ns <= start ? 1 : 0;
        1 : ns <= 2;
        2 : ns <= 3;
        3 : ns <= counterNum == 4'b0000 ? 4 : 2;
        4 : ns <= 0;
      endcase
    end
  end
  always@(ps)begin
    {ldA,ldQ,sh,inz,ldq0,ldM,ldc,dc,ready} = 9'b000000000;
    case(ps)
      0 : ;
      1 : {ldQ,inz,ldq0,ldM,ldc} = 5'b11111;
      2 : {ldA,dc} = 2'b11;
      3 : sh = 1;
      4 : ready = 1;
    endcase
  end
endmodule
