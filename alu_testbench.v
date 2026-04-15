`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2026 12:53:40 PM
// Design Name: 
// Module Name: alu_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_testbench;

 wire [15:0] zout;
 reg [3:0] rs1,rs2,rd,func;
 reg [7:0] addr;
 reg clk,clk2;
 integer k;
 


alu_pipelined exp(rs1,rs2,rd,func,addr,clk,clk2,zout);

initial begin 
  clk=0;
  clk2=0;
  repeat (50)
   begin
     #5 clk=1;
     #5 clk=0;
     #5 clk2=1;
     #5 clk2=0;
   end
end    
initial 
 begin
  for(k=0;k<16;k=k+1)
   exp.reg_bank[k]=k;
 end
   
initial begin 

   // -------------------------
   // TEST 1: 3 + 7 = 10
   // -------------------------
   #5 rs1=3; rs2=7; rd=10; func=0; addr=125;
   #40;
   if (zout == 10)
      $display("PASS 1: ADD correct → %d", zout);
   else
      $display("FAIL 1: ADD wrong → %d", zout);

   // -------------------------
   // TEST 2: 15 * 5 = 75
   // -------------------------
   #20 rs1=15; rs2=5; rd=1; func=2; addr=126;
   #40;
   if (zout == 75)
      $display("PASS 2: MUL correct → %d", zout);
   else
      $display("FAIL 2: MUL wrong → %d", zout);

   // -------------------------
   // TEST 3: 12 & 11 = 8
   // -------------------------
   #20 rs1=12; rs2=11; rd=2; func=4; addr=127;
   #40;
   if (zout == 8)
      $display("PASS 3: AND correct → %d", zout);
   else
      $display("FAIL 3: AND wrong → %d", zout);

   // -------------------------
   // TEST 4: 4 - 6 = -2 (FFFE)
   // -------------------------
   #20 rs1=4; rs2=6; rd=8; func=1; addr=128;
   #40;
   if (zout == 16'hFFFE)
      $display("PASS 4: SUB correct → %h", zout);
   else
      $display("FAIL 4: SUB wrong → %h", zout);

   // -------------------------
   // TEST 5: 9 / 13 = 0
   // -------------------------
   #20 rs1=9; rs2=13; rd=14; func=3; addr=129;
   #40;
   if (zout == 0)
      $display("PASS 5: DIV correct → %d", zout);
   else
      $display("FAIL 5: DIV wrong → %d", zout);

   $stop;
end
  

        
          

endmodule
