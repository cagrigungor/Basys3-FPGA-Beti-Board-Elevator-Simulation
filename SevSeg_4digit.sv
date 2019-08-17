`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mustafa Çaðrý Güngör
// 
// Create Date: 01.11.2018 9:45:36
// Design Name: 
// Module Name: directorQuestion

// 
//////////////////////////////////////////////////////////////////////////////////

//module SevSeg_4digit(
// input clk, 
// output a, b, c, d, e, f, g, fg
// );

////logic [3:0] count = {4'b0000}; //initial value
//   logic clk_out;
//    ClockDivider myClock(clk,clk_out);
//    //localparam N = 18;
// logic [5:0] sseg_LEDs = {6'b111110};
// //assign sseg_LEDs = 6'b111110;   
//    always@ (posedge clk_out)
//    begin
//      sseg_LEDs <= {sseg_LEDs[0], sseg_LEDs[5:1]}; 
////    if( count == 4'b1001 )
////        count <= 4'b0000; 
////	count <= count + 4'b0001; 
//	end

////logic [6:0] sseg_LEDs; 
////always_comb
//// begin 
////  sseg_LEDs = 7'b1111111; //default
////  case(count)
////   0 : sseg_LEDs = 7'b1000000; //to display 0
////   1 : sseg_LEDs = 7'b1111001; //to display 1
////   2 : sseg_LEDs = 7'b0100100; //to display 2
////   3 : sseg_LEDs = 7'b0110000; //to display 3
////   4 : sseg_LEDs = 7'b0011001; //to display 4
////   5 : sseg_LEDs = 7'b0010010; //to display 5
////   6 : sseg_LEDs = 7'b0000010; //to display 6
////   7 : sseg_LEDs = 7'b1111000; //to display 7
////   8 : sseg_LEDs = 7'b0000000; //to display 8
////   9 : sseg_LEDs = 7'b0010000; //to display 9
////  endcase
//// end
 
//assign {g,f, e, d, c, b, a} = sseg_LEDs; 

 
 
//endmodule

`timescale 1 ps / 1 ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hamzeh Ahangari
// 
// Create Date: 
// Design Name: 
// Module Name: 
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

// This module shows 4 decimal numbers on 4-digit 7-Segment.  
// 4 digits are scanned with high speed, then you do not notice that every time 
// only one of them is ON. dp is always off.

// LED positions inside 7-segment
//    A 
//  F   B
//    G
//  E   C
//    D      DP

// digit positions on Basys3 :
// in3(left), in2, in1, in0(right)

(* keep_hierarchy = "yes" *) 
module SevSeg_4digit(
 input clk,
 input drc,reset,system_reset,starter,stop,
 //input [3:0] in0, in1, in2, in3, //user inputs for each digit (hexadecimal value)
 output a, b, c, d, e, f, g, // just connect them to FPGA pins (individual LEDs).
 output [3:0] an   // just connect them to FPGA pins (enable vector for 4 digits, active low)
 );
 
// divide system clock (100Mhz for Basys3) by 2^N using a counter, which allows us to multiplex at lower speed
   logic clk_out;
   logic clk_out1;
   logic load = 0;
    //ClockDivider myClock(clk,clk_out);
    ClockDivider1 myClock1(clk,clk_out1);
//localparam N = 18;
logic [3:0] count = {4{1'b0}}; //initial value
logic [3:0] countTen = {4{1'b0}};
logic [3:0] countHun = {4{1'b0}};
logic [5:0] turn = {6'b111110};
logic[27:0] counter = {28{1'b0}};
logic[27:0] counterT = {28{1'b0}};
always@ (posedge clk)begin
    if( reset == 1 || system_reset == 1)begin
                count <= {4'b0000}; //initial value
                countTen <= {4{1'b0}};
                countHun <= {4{1'b0}};
                turn <= {6'b111110}; 
    end
    
    if(starter == 1 && stop == 0)begin
    counter <= counter + 1;
    counterT <= counterT + 1;
    
    end
    
      if( counterT == 27'd24_999_999 )begin          
                  if( starter == 1 )begin
                        if( drc == 1)
                          turn <= {turn[4:0],turn[5]};
              
                      else
                          turn <= {turn[0],turn[5:1]};
                  end
                  counterT <= 0;
      end
    if( counter == 27'd99_999_999 )begin
            
            
                if( starter == 1 )begin
                count <= count + 1;
                if( drc == 1)
                    turn <= {turn[4:0],turn[5]};
        
                else
                    turn <= {turn[0],turn[5:1]};
                end
             
             
            if( count == 4'b1001 )begin
                countTen <= countTen + 1;
                count <= 4'b0000; 
                end
            if( countTen == 4'b1001 && count == 4'b1001 )begin
                countHun <= countHun + 1;
                countTen <= 4'b0000; 
                end
            if( countHun == 4'b1001 && countTen == 4'b1001 && count == 4'b1001 )begin
                countHun <= 4'b0000; 
                end
        counter <= 0;
     end
  end
	
	

localparam N1 = 18;
logic [N1-1:0] count1 = {N1{1'b0}}; //initial value
always@ (posedge clk_out1)
	count1 <= count1 + 1;

 
logic [3:0]digit_val; // multiplexer of digits
logic [3:0]digit_en;  // decoder of enable bits
 
always_comb
 begin
 digit_en = 4'b1111; 
 //digit_val = in0; 
 
  case(count1[1:0]) //using only the 2 MSB's of the counter 
    
   2'b00 :  //select first 7Seg.
    begin    
     
     digit_val = count; //count[3:0];
     digit_en = 4'b1110;
    end
    
   2'b01:  //select second 7Seg.
    begin
     digit_val = countTen;
     digit_en = 4'b1101;
    end
    
   2'b10:  //select third 7Seg.
    begin
     digit_val = countHun;
     digit_en = 4'b1011;
    end
     
   2'b11:  //select forth 7Seg.
    begin
    digit_val = 4'b1111;   
     digit_en = 4'b0111;
    end
  endcase
 end
 

//Convert digit value to LED vector. LEDs are active low.
logic [6:0] sseg_LEDs; 
always_comb
 begin 
  sseg_LEDs = 7'b1111111; //default
  case(digit_val)
   4'd0 : sseg_LEDs = 7'b1000000; //to display 0
   4'd1 : sseg_LEDs = 7'b1111001; //to display 1
   4'd2 : sseg_LEDs = 7'b0100100; //to display 2
   4'd3 : sseg_LEDs = 7'b0110000; //to display 3
   4'd4 : sseg_LEDs = 7'b0011001; //to display 4
   4'd5 : sseg_LEDs = 7'b0010010; //to display 5
   4'd6 : sseg_LEDs = 7'b0000010; //to display 6
   4'd7 : sseg_LEDs = 7'b1111000; //to display 7
   4'd8 : sseg_LEDs = 7'b0000000; //to display 8
   4'd9 : sseg_LEDs = 7'b0010000; //to display 9
   4'd10: sseg_LEDs = 7'b0001000; //to display a
//   4'd11: sseg_LEDs = 7'b0000011; //to display b
//   4'd12: sseg_LEDs = 7'b1000110; //to display c
//   4'd13: sseg_LEDs = 7'b0100001; //to display d
//   4'd14: sseg_LEDs = 7'b0000110; //to display e
//   4'd15: sseg_LEDs = 7'b0001110; //to display f   
   default : sseg_LEDs = {1'b1 , turn}; //dash
  endcase
 end
// if(count1[1:0] == 2'b11)
//    sseg_LEDs = 7'b1111111;
 
assign an = digit_en; 
assign {g, f, e, d, c, b, a} = sseg_LEDs; 
assign dp = 1'b1; //turn dp off
 
 
 
endmodule
/*
module directorQuestion( input logic n,m,l,
                      output logic  w,x,y,z);
    logic outAnd;
    
    assign outAnd = m & l;
    assign y = m ? ~l : l;
    assign w =n ? outAnd : 0;
    assign x = n ? ~outAnd : outAnd;
    assign z = m;

    
endmodule
*/
//module sevSeg( input clk,drc,
//                      output a,b,c,d,e,f,g,[3:0]fg);
//    SevSeg_4digit( clk,drc,a,b,c,d,e,f,g,fg);
//    //assign g = 1;
//    //assign fg = 4'b1110;
    
//endmodule
module ClockDivider1(
 input clk_in,
 output clk_out
 );

logic [9:0] count = {10{1'b0}};
logic clk_NoBuf;
always@ (posedge clk_in) begin
count <= count + 1;
end
// you can modify 25 to have different clock rate
assign clk_NoBuf = count[9];
BUFG BUFG_inst (
 .I(clk_NoBuf), // 1-bit input: Clock input
 .O(clk_out) // 1-bit output: Clock output
);
endmodule

//module ClockDivider(
// input clk_in,
// output clk_out
// );
//logic result = 0;
//logic [26:0] count = {27{1'b0}};
//logic clk_NoBuf = 0;
//always@ (posedge clk_in) begin

//count <= count + 1;
//    if( count == 27'd99_999_999 )begin
//        clk_NoBuf <= 1;
//        count <= 0; 
//    end
//end
//// you can modify 25 to have different clock rate
//assign clk_out = clk_NoBuf;
//endmodule
