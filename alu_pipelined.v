`timescale 1ns / 1ps
// Read After Write hazard :so if the instuctions 1 is R3=R1+R2 buthen the next instruction is R4=R3-R2 
//                          then what happens is that the value of R3 is updated in cycle 3 but the 2nd instruction 
//                          loading data from the register bank happens in the cycle 2 only so instruction 2 is computed
//                          with the old value of R3 that may give us the wrong result thisis the issue in this design
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 03:28:40 PM
// Design Name: 
// Module Name: alu_pipelined
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


module alu_pipelined(
  input [3:0] rs1,rs2,rd,func,
  input [7:0] addr,
  input clk,clk2,
  output [15:0]zout

    );
    
    reg [15:0] L12_A,L12_B,L23_Z,L34_Z;
    reg [3:0] L12_rd,L23_rd,L12_func;
    reg [7:0] L12_addr,L23_addr,L34_addr;
    reg [15:0] reg_bank [0:15];
    reg [15:0] memory [0:255];
    /*parameter S0= 4'b0000;
    parameter S1= 4'b0001;
    parameter S2= 4'b0010;
    parameter S3= 4'b0011;
    parameter S4= 4'b0100;
    parameter S5= 4'b0101;
    parameter S6= 4'b0110;
    parameter S7= 4'b0111;
    parameter S8= 4'b1000;
    parameter S9= 4'b1001;
    parameter S10=4'b1010;
    parameter S11=4'b1011;
    parameter S12=4'b1100;*/
   // parameter S13= 4'b1101;
    //parameter S14= 4'b1110;
    //parameter S15= 4'b1111;
    
  /*  integer i;
    initial begin
      for(i=0; i<16; i=i+1)
         reg_bank[i] = 0;
      for(i=0; i<256; i=i+1)
         memory[i] = 0;
    end*/
    
    
    assign zout=L34_Z;
    
    always @(posedge clk) // Stage 1
     begin
      L12_A <= #2 reg_bank[rs1];
      L12_B <= #2 reg_bank[rs2];
      L12_rd <= #2 rd;
      L12_func <= #2 func;
      L12_addr <= #2 addr;
     end
     
    always @(negedge  clk2)  // Stage 2 
     begin
      L23_rd <= L12_rd;
      L23_addr <= L12_addr;
      case(L12_func)
        0: L23_Z <= #2 L12_A + L12_B;
        1: L23_Z <= #2 L12_A - L12_B;
        2: L23_Z <= #2 L12_A * L12_B;
        3: L23_Z <= #2 (L12_B != 0) ? (L12_A / L12_B) : 0;
        4: L23_Z <= #2 L12_A & L12_B;
        5: L23_Z <= #2 L12_A | L12_B;
        6: L23_Z <=  #2 L12_A ^ L12_B;
        7: L23_Z <= #2 ~L12_A;
        8: L23_Z <= #2 ~L12_B;
        9: L23_Z <= #2 (L12_A<<1);// shift left A
        10: L23_Z <= #2 (L12_B<<1);// shift left B
        11: L23_Z <= #2 (L12_B>>1); // shift right B
        12: L23_Z <= #2 (L12_A>>1); // shift right A
        default: L23_Z <= #2 0;
       endcase 
     end
     
    always @ (posedge clk) //Stgae 3
     begin 
      L34_Z<= #2 L23_Z;
      L34_addr<= #2 L23_addr;
      reg_bank[L23_rd]<= #2 L23_Z;
      
     end 
    always@(negedge clk2) // Stgae 4
     begin 
      memory[L34_addr]<= #2 L34_Z;
     end
      
               
       
       
      
endmodule
