`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2018 21:20:26
// Design Name: 
// Module Name: MainController
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


module MainController(
        input clk,
        input [3:0] keyb_col,
        input starter,reset,system_reset,
        output [3:0] keyb_row,
        output reset_out, //shift register's reset
        output OE,     //output enable, active low 
        output SH_CP,  //pulse to the shift register
        output ST_CP,  //pulse to store shift register
        output DS,     //shift register's serial input data
        output [7:0] col_select, // active column, active high
        output a,b,c,d,e,f,g,[3:0]fg
    );
    logic starter_out;
    logic reseto;
    logic system_reset_out;
    debounce starter1(starter,clk,starter_out);
    debounce reset1(reset,clk,reseto);
    debounce system_reset1(system_reset,clk,system_reset_out);
    logic [1:0][5:0] cthird;
    logic [1:0][5:0] csecond;
    logic [1:0][5:0] cfirst;
    
//    logic [1:0][5:0] fthird = cthird;
//    logic [1:0][5:0] fsecond = csecond;
//    logic [1:0][5:0] ffirst = cfirst;
    
    logic [7:0][7:0] tempImage_red;
    logic [7:0][7:0] tempImage_blue;
    logic [1:0][5:0] tempThird;
    logic stop;
    logic drc;
    logic tStarter = 0;
    
    always@ (posedge clk)begin
        if( starter_out == 1)
          tStarter <= 1;
        
        if( system_reset == 1 )
          tStarter <= 0;
    
    end
    
    
    
    
    //control4x4 call4(clk,starter,cthird,csecond,cfirst,keyb_row,keyb_col);
    //ControlElevator callElevator(clk,system_reset,starter,first,second,third/*,tempThird*/,Othird,tempImage_red,tempImage_blue);
    ControlElevator callElevator(clk,system_reset_out,tStarter,keyb_col/*,fthird,fsecond,ffirst*/,keyb_row,tempImage_red,tempImage_blue,drc,stop);
    //assign third = Othird;
    control8x8 call8(clk,tempImage_red,tempImage_blue,reset_out,OE,SH_CP,ST_CP,DS,col_select);
    SevSeg_4digit seg( clk,drc,reseto,system_reset_out,tStarter,stop,a,b,c,d,e,f,g,fg);
  
    
endmodule
