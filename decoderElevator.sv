`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2018 11:27:03
// Design Name: 
// Module Name: decoderElevator
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


module decoderElevator( input [15:0] elevator, output [1:0]number  );

logic [1:0] temp = 2'b00; 

always_comb
 begin 
  //sseg_LEDs = 7'b1111111; //default
  case(elevator)
   16'b0000000000000000 : temp = 2'b00; //to display 0
   16'b1100000011000000 : temp = 2'b11;
   16'b0011000000110000 : temp = 2'b11;
//   {16'b0000000000000000} : temp = 2'b01;
//   {16'b0000000000000000} : temp = 2'b01;
//   {16'b0000000000000000} : temp = 2'b01;
//   {16'b0000000000000000} : temp = 2'b01;
//   {16'b0000000000000000} : temp = 2'b01;
   
   
   
  endcase
 end
   assign number = temp;

endmodule