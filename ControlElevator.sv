`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.12.2018 09:13:12
// Design Name: 
// Module Name: ControlElevator
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


module ControlElevator(
            input clk,system_reset,starter,
            input [3:0] keyb_col,
            /*input [0:1][5:0] thirdF,
            input [0:1][5:0] secondF,
            input [0:1][5:0] firstF,*/
            output [3:0] keyb_row,

            output [0:7][7:0] tempImage_redF,
            output [0:7][7:6] tempImage_blue,
            //output logic stop,
            output tempDrc,
            output tstop
   
    );
    logic check;
    logic [0:1][5:0] third ;
    logic [0:1][5:0] second ;
    logic [0:1][5:0] first;
    
    
    
    logic [0:1][5:0] cthird;
    logic [0:1][5:0] csecond;
    logic [0:1][5:0] cfirst;
    control4x4 call4(clk,starter,cthird,csecond,cfirst,keyb_row,keyb_col);
    

//    logic [3:0] noThird;
//    logic [3:0] noSecond;
//    logic [3:0] noFirst;
    
    logic [15:0] redElevator = { 16{ 1'b0 } };
    logic [1:0]noRedElevator;
    logic drc;

//    assign thirdF = cthird;
//    assign secondF = csecond;
//    assign firstF = cfirst;
//    decoderFloor deco1( first, noFirst  );
//    decoderFloor deco2( second, noSecond  );
//    decoderFloor deco3( third, noThird  );
    
//    decoderElevator deco4( redElevator, noRedElevator  );

    
    logic [15:0]elevator; 
    logic [0:1] [7:0] Floor;
    assign Floor[0][7] = elevator[15];
    assign Floor[0][6] = elevator[14];
    assign Floor[0][5] = elevator[13];
    assign Floor[0][4] = elevator[12];
    assign Floor[0][3] = elevator[11];
    assign Floor[0][2] = elevator[10];
    assign Floor[0][1] = elevator[9];
    assign Floor[0][0] = elevator[8];
    assign Floor[1][7] = elevator[7];
    assign Floor[1][6] = elevator[6];
    assign Floor[1][5] = elevator[5];
    assign Floor[1][4] = elevator[4];
    assign Floor[1][3] = elevator[3];
    assign Floor[1][2] = elevator[2];
    assign Floor[1][1] = elevator[1];
    assign Floor[1][0] = elevator[0];
        
//    always@ (posedge clk)begin
//        if(starter == 1'b0 || system_reset == 1 )begin
//            drc = 1;
//            elevator <= {16'b0000001100000011};
//            redElevator = { 16{ 1'b0 } };
//            third <= cthird;
//            second <= csecond;
//            first <= cfirst;end
//    end
   
    logic clk_out;
    //ClockDivider myClock8x8(clk,clk_out);
    logic [28:0] counter = {29{1'b0}}; 
    logic down = 0;
    logic run = 1;
    logic [29:0]timer;
    logic stop = 0;
    
    
    always@ (posedge clk)
    begin
        counter <= counter + 1;
    
        
//        if(starter == 1'b0)begin
//              third <= thirdF;
//              second <= secondF;
//              first <= firstF;end
      
          
        if((starter == 1'b0 || system_reset == 1) )begin
                drc = 1;
                elevator <= {16'b0000001100000011};
                redElevator = { 16{ 1'b0 } };
                third <= cthird;
                second <= csecond;
                first <= cfirst;
                counter <= 0;
                run <= 1;
                stop <= 0;
        end
        
        if( drc == 0  )
             down <= 1;
        else
             down <= 0;     
        
        if( run == 1 )   
            timer <= 29'd299_999_999; 
        else
            timer <= 29'd199_999_999;
           
        if( counter == timer )begin

        
        
        if(starter == 1'b1 && system_reset != 1 )begin
        run <= 1;
        

        //***********************************************************Third Start*******************************************************************
        if( third[1][0] == 1 )begin
        
            if( elevator !=  16'b1100000011000000 &&  (elevator == 16'b0000001100000011 || elevator == 16'b0000110000001100 || elevator == 16'b0011000000110000) && drc == 1 )begin
                   elevator <= { elevator[13:0], elevator[15:14] };
                   if( elevator == 16'b0011000000110000 )
                    run<= 0;
            end
            else if(drc == 1)begin
            
            if( third[0][5] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;
   
                third[0][5] <= 1'b0;
                third[0][4] <= 1'b0;
                third[1][5] <= 1'b0;
                third[1][4] <= 1'b0;
                            
            end//12li end 
            
            else if( third[1][5] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;

                third[0][4] <= 1'b0;
                third[0][3] <= 1'b0;
                third[1][5] <= 1'b0;
                third[1][4] <= 1'b0;                       
            end//11
            else if( third[0][4] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;

                third[0][4] <= 1'b0;
                third[0][3] <= 1'b0;
                third[1][4] <= 1'b0;
                third[1][3] <= 1'b0;            
            end//10
            else if( third[1][4] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;

                third[0][3] <= 1'b0;
                third[0][2] <= 1'b0;
                third[1][4] <= 1'b0;
                third[1][3] <= 1'b0;    
            end//9        
            else if( third[0][3] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;
  
                third[0][2] <= 1'b0;
                third[0][3] <= 1'b0;
                third[1][2] <= 1'b0;
                third[1][3] <= 1'b0;
                            
            end//8li end
            else if( third[1][3] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;
      
                third[0][2] <= 1'b0;
                third[0][1] <= 1'b0;
                third[1][3] <= 1'b0;
                third[1][2] <= 1'b0;
                            
            end//7
            else if( third[0][2] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;

                third[0][2] <= 1'b0;
                third[0][1] <= 1'b0;
                third[1][2] <= 1'b0;
                third[1][1] <= 1'b0;
                            
            end//6
            else if( third[1][2] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b1100000011000000;

                third[0][0] <= 1'b0;
                third[0][1] <= 1'b0;
                third[1][2] <= 1'b0;
                third[1][1] <= 1'b0;
                            
            end//5
            else if( third[0][1] == 1)begin
                    elevator = 16'b0000000000000000;
                    redElevator = 16'b1100000011000000;
                    //tempImage_redF[0][0]= 0;
                   // noThird <= noThird - 4'b0100;
                    third[0][0] <= 1'b0;
                    third[0][1] <= 1'b0;
                    third[1][0] <= 1'b0;
                    third[1][1] <= 1'b0;
//                    tempThird[1][0] <= 1'b0;
                
             end//4lü end
            else if( third[1][1] == 1)begin
                   elevator = 16'b00000000_10000000;
                   redElevator = 16'b11000000_01000000;
            
                   third[0][0] <= 1'b0;
                   third[1][0] <= 1'b0;
                   third[1][1] <= 1'b0;
                 
              end//3lü end     
            else if( third[0][0] == 1)begin
                     elevator = 16'b00000000_11000000;
                     redElevator = 16'b11000000_00000000;
              
                     third[0][0] <= 1'b0;
                     third[1][0] <= 1'b0;
                   
             end//2lü end   
            else if( third[1][0] == 1)begin
                    elevator = 16'b10000000_11000000;
                    redElevator = 16'b01000000_00000000;
                    
                    third[1][0] <= 1'b0;
                    
              end//1lü end       
            drc <= 0;
            run <= 1;
            end// 3.katta
            
        end//3. katta adam varsa
        //***********************************************************Second Start*******************************************************************
        else if( second[1][0] == 1 )begin
            if( elevator !=  16'b0011000000110000 && (elevator == 16'b0000001100000011 || elevator == 16'b0000110000001100 ) && drc == 1 )begin
                //if( elevator == 16'b0000001100000011 || elevator == 16'b0000110000001100 )
                elevator <= { elevator[13:0], elevator[15:14] };
                if( elevator == 16'b0000110000001100 )
                    run<= 0;
            end
            else if(drc == 1)begin
            
            if( second[0][5] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][5] <= 1'b0;
                second[0][4] <= 1'b0;
                second[1][5] <= 1'b0;
                second[1][4] <= 1'b0;
                            
            end//12li end 
            
            else if( second[1][5] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][4] <= 1'b0;
                second[0][3] <= 1'b0;
                second[1][5] <= 1'b0;
                second[1][4] <= 1'b0;                       
            end//11
            else if( second[0][4] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][4] <= 1'b0;
                second[0][3] <= 1'b0;
                second[1][4] <= 1'b0;
                second[1][3] <= 1'b0;            
            end//10
            else if( second[1][4] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;
                
                second[0][3] <= 1'b0;
                second[0][2] <= 1'b0;
                second[1][4] <= 1'b0;
                second[1][3] <= 1'b0;    
            end//9        
            else if( second[0][3] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][2] <= 1'b0;
                second[0][3] <= 1'b0;
                second[1][2] <= 1'b0;
                second[1][3] <= 1'b0;
                            
            end//8li end
            else if( second[1][3] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][2] <= 1'b0;
                second[0][1] <= 1'b0;
                second[1][3] <= 1'b0;
                second[1][2] <= 1'b0;
                            
            end//7
            else if( second[0][2] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][2] <= 1'b0;
                second[0][1] <= 1'b0;
                second[1][2] <= 1'b0;
                second[1][1] <= 1'b0;
                            
            end//6
            else if( second[1][2] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][0] <= 1'b0;
                second[0][1] <= 1'b0;
                second[1][2] <= 1'b0;
                second[1][1] <= 1'b0;
                            
            end//5
            else if( second[0][1] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0011000000110000;

                second[0][0] <= 1'b0;
                second[0][1] <= 1'b0;
                second[1][0] <= 1'b0;
                second[1][1] <= 1'b0;
                
             end//4lü end
            else if( second[1][1] == 1)begin
                    elevator = 16'b00000000_00100000;
                    redElevator = 16'b00110000_00010000;
                    
             
                    second[0][0] <= 1'b0;
                    second[1][0] <= 1'b0;
                    second[1][1] <= 1'b0;
                  
               end//3lü end     
             else if( second[0][0] == 1)begin
                      elevator = 16'b00000000_00110000;
                      redElevator = 16'b00110000_00000000;
               
                      second[0][0] <= 1'b0;
                      second[1][0] <= 1'b0;
                    
              end//2lü end   
             else if( second[1][0] == 1)begin
                     elevator = 16'b00100000_00110000;
                     redElevator = 16'b00010000_00000000;
                    
                    
                     second[1][0] <= 1'b0;
                     
               end//1lü end   
               drc <= 0;
               run <= 1;
//**************************************************************************************first start**********************************************
            end// 2.katta?
            
        end//2. katta adam varsa
        
        else if( first[1][0] == 1 )begin
            if( elevator !=  16'b0000110000001100 && elevator == 16'b0000001100000011  && drc == 1 )begin
                //if( elevator == 16'b0000001100000011 || elevator == 16'b0000110000001100 )
                elevator <= { elevator[13:0], elevator[15:14] };
                if( elevator == 16'b0000001100000011 )
                  run<= 0;
            end
            else if(drc == 1)begin
            
            if( first[0][5] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;

                first[0][5] <= 1'b0;
                first[0][4] <= 1'b0;
                first[1][5] <= 1'b0;
                first[1][4] <= 1'b0;
                            
            end//12li end 
            
            else if( first[1][5] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;

                first[0][4] <= 1'b0;
                first[0][3] <= 1'b0;
                first[1][5] <= 1'b0;
                first[1][4] <= 1'b0;                       
            end//11
            else if( first[0][4] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;

                first[0][4] <= 1'b0;
                first[0][3] <= 1'b0;
                first[1][4] <= 1'b0;
                first[1][3] <= 1'b0;            
            end//10
            else if( first[1][4] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;
                
                first[0][3] <= 1'b0;
                first[0][2] <= 1'b0;
                first[1][4] <= 1'b0;
                first[1][3] <= 1'b0;    
            end//9        
            else if( first[0][3] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;
                
                first[0][2] <= 1'b0;
                first[0][3] <= 1'b0;
                first[1][2] <= 1'b0;
                first[1][3] <= 1'b0;
                            
            end//8li end
            else if( first[1][3] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;

                first[0][2] <= 1'b0;
                first[0][1] <= 1'b0;
                first[1][3] <= 1'b0;
                first[1][2] <= 1'b0;
                            
            end//7
            else if( first[0][2] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;

                first[0][2] <= 1'b0;
                first[0][1] <= 1'b0;
                first[1][2] <= 1'b0;
                first[1][1] <= 1'b0;
                            
            end//6
            else if( first[1][2] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;

                first[0][0] <= 1'b0;
                first[0][1] <= 1'b0;
                first[1][2] <= 1'b0;
                first[1][1] <= 1'b0;
                            
            end//5
            else if( first[0][1] == 1)begin
                elevator = 16'b0000000000000000;
                redElevator = 16'b0000110000001100;

                first[0][0] <= 1'b0;
                first[0][1] <= 1'b0;
                first[1][0] <= 1'b0;
                first[1][1] <= 1'b0;
                
             end//4lü end
            else if( first[1][1] == 1)begin
                    elevator = 16'b00000000_00001000;
                    redElevator = 16'b00001100_00000100;
             
                    first[0][0] <= 1'b0;
                    first[1][0] <= 1'b0;
                    first[1][1] <= 1'b0;
                  
               end//3lü end     
             else if( first[0][0] == 1)begin
                      elevator = 16'b00000000_00001100;
                      redElevator = 16'b00001100_00000000;
               
                      first[0][0] <= 1'b0;
                      first[1][0] <= 1'b0;
                    
              end//2lü end   
             else if( first[1][0] == 1)begin
                     elevator = 16'b00001000_00001100;
                     redElevator = 16'b00000100_00000000;

                                                       
                     first[1][0] <= 1'b0;
                     
               end//1lü end   
            drc <= 0;
            run <= 1;
            end// 1.katta?
            
        end//1. katta adam varsa
                   
        
        if( (redElevator[7] == 1 || redElevator[5] == 1 || redElevator[3] == 1 || redElevator[1] == 1 ) && down == 1 )begin
            if(redElevator ==  16'b00001100_00001100)
               run <= 0;
             if(redElevator !=  16'b0000001100000011)
                  redElevator <= { redElevator[1:0], redElevator[15:2] };

             else begin
                  elevator <= 16'b0000001100000011;
                  redElevator <= 16'b0000000000000000;
                  drc <= 1;
                  run <= 1;
             end           
        end
        else if( down == 1 &&  ( ( redElevator == 16'b11000000_01000000 || redElevator == 16'b11000000_00000000 || redElevator == 16'b01000000_00000000 ) || ( redElevator == 16'b00110000_00010000 || redElevator == 16'b00110000_00000000 || redElevator == 16'b00010000_00000000 ) || ( redElevator == 16'b00001100_00000100 || redElevator == 16'b00001100_00000000 || redElevator == 16'b00000100_00000000 ) || ( redElevator == 16'b00000011_00000001 || redElevator == 16'b00000011_00000000 || redElevator == 16'b00000001_00000000 )) )begin 

            if( second[1][0] == 1'b1 /*&& redElevator[5] != 1*/ )begin
                if( redElevator[12] != 1/*!( ( redElevator ==  16'b00110000_00010000 ) || ( redElevator ==  16'b00110000_00000000 ) || ( redElevator ==  16'b00010000_00000000 ) )*/ )begin
                   redElevator <= { redElevator[1:0], redElevator[15:2] };
                   elevator <= { elevator[1:0], elevator[15:2] };
                if(( redElevator == 16'b11000000_01000000 || redElevator == 16'b11000000_00000000 || redElevator == 16'b01000000_00000000 ))
                    run <= 0;
                end
                else if( redElevator[5] != 1)begin
//*************************************************************************************second Empty*******************************************************************************
                
                    if( second[0][4] == 1)begin
                        if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][5] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][5] <= 1'b0;
                            second[1][5] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[0][5] <= 1'b0;
                            second[1][5] <= 1'b0;
                            second[0][4] <= 1'b0;
                        end
                                    
                    end//12li end 
                    
                    else if( second[1][5] == 1)begin
                        if( redElevator[4] == 1 )begin
                        elevator = 16'b0000000000000000;
                        redElevator = 16'b0011000000110000;
                        second[1][5] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][4] <= 1'b0;
                            second[1][5] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[1][4] <= 1'b0;
                            second[1][5] <= 1'b0;
                            second[0][4] <= 1'b0;
                        end                       
                    end//11
                    else if( second[0][4] == 1)begin
                        if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][4] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][4] <= 1'b0;
                            second[1][4] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[0][4] <= 1'b0;
                            second[1][4] <= 1'b0;
                            second[0][3] <= 1'b0;
                        end            
                    end//10
                    else if( second[1][4] == 1)begin
                            if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[1][4] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[1][4] <= 1'b0;
                            second[0][3] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[1][4] <= 1'b0;
                            second[0][3] <= 1'b0;
                            second[1][3] <= 1'b0;
                        end      
                    end//9        
                    else if( second[0][3] == 1)begin
                            if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][3] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][3] <= 1'b0;
                            second[1][3] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[0][3] <= 1'b0;
                            second[1][3] <= 1'b0;
                            second[0][2] <= 1'b0;
                        end  
                                    
                    end//8li end
                    else if( second[1][3] == 1)begin
                            if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[1][3] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[1][3] <= 1'b0;
                            second[0][2] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[1][3] <= 1'b0;
                            second[0][2] <= 1'b0;
                            second[1][2] <= 1'b0;
                        end  
                                    
                    end//7
                    else if( second[0][2] == 1)begin
                                    
                        if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][2] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][2] <= 1'b0;
                            second[1][2] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[0][1] <= 1'b0;
                            second[0][2] <= 1'b0;
                            second[1][2] <= 1'b0;
                        end
                                    
                    end//6
                    else if( second[1][2] == 1)begin
                        if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[1][2] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[1][2] <= 1'b0;
                            second[0][1] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[1][2] <= 1'b0;
                            second[0][1] <= 1'b0;
                            second[1][1] <= 1'b0;
                        end
                                    
                    end//5
                    else if( second[0][1] == 1)begin
                        if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][1] <= 1'b0;
                        end
                        else if ( redElevator[13] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;
                            second[0][1] <= 1'b0;
                            second[1][1] <= 1'b0;                   
                        end
                        else if ( redElevator[12] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b0011000000110000;            
                            second[0][1] <= 1'b0;
                            second[1][1] <= 1'b0;
                            second[0][0] <= 1'b0;
                        end
                        
                     end//4lü end
                    else if( second[1][1] == 1)begin
                            if( redElevator[4] == 1 )begin
                                elevator = 16'b0000000000000000;
                                redElevator = 16'b0011000000110000;
                                second[1][1] <= 1'b0;
                            end
                            else if ( redElevator[13] == 1 )begin
                                elevator = 16'b0000000000000000;
                                redElevator = 16'b0011000000110000;
                                second[1][1] <= 1'b0;
                                second[0][0] <= 1'b0;                   
                            end
                            else if ( redElevator[12] == 1 )begin
                                elevator = 16'b0000000000000000;
                                redElevator = 16'b0011000000110000;            
                                second[1][1] <= 1'b0;
                                second[0][0] <= 1'b0;
                                second[1][0] <= 1'b0;
                            end
                          
                       end//3lü end     
                     else if( second[0][0] == 1)begin
                             if( redElevator[4] == 1 )begin
                                 elevator = 16'b0000000000000000;
                                 redElevator = 16'b00110000_00110000;
                                 second[0][0] <= 1'b0;
                             end
                             else if ( redElevator[13] == 1 )begin
                                 elevator = 16'b0000000000000000;
                                 redElevator = 16'b0011000000110000;
                                 second[0][0] <= 1'b0;
                                 second[1][0] <= 1'b0;                   
                             end
                             else if ( redElevator[12] == 1 )begin
                                 elevator = 16'b00000000_00100000;
                                 redElevator = 16'b00110000_00010000;            
                                 second[0][0] <= 1'b0;
                                 second[1][0] <= 1'b0;
                             end
                            
                      end//2lü end   
                     else if( second[1][0] == 1)begin
                             if( redElevator[4] == 1 )begin
                             elevator = 16'b0000000000000000;
                             redElevator = 16'b00110000_00110000;
                             second[1][0] <= 1'b0;
                         end
                         else if ( redElevator[13] == 1 )begin
                             elevator = 16'b00000000_00100000;
                             redElevator = 16'b00110000_00010000;
                             second[1][0] <= 1'b0;                   
                         end
                         else if ( redElevator[12] == 1 )begin
                             elevator = 16'b00000000_00110000;
                             redElevator = 16'b00110000_00000000;            
                             second[1][0] <= 1'b0;
                         end
                             
                     end//1lü end   
                    run <= 1;
                 end// 4.katta
            end//4. katta adam varsa
            else if( first[1][0] == 1'b1 /*&& redElevator[3] != 1*/ )begin
                if( redElevator[10] != 1/*!( ( redElevator ==  16'b00110000_00010000 ) || ( redElevator ==  16'b00110000_00000000 ) || ( redElevator ==  16'b00010000_00000000 ) )*/ )begin
                   redElevator <= { redElevator[1:0], redElevator[15:2] };
                   elevator <= { elevator[1:0], elevator[15:2] };
                if( ( redElevator == 16'b00110000_00010000 || redElevator == 16'b00110000_00000000 || redElevator == 16'b00010000_00000000 ) )
                    run <= 0;
                end
                else if( redElevator[3] != 1)begin
//*************************************************************************************first Empty*******************************************************************************
                
                    if( first[0][4] == 1)begin
                        if( redElevator[2] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][5] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][5] <= 1'b0;
                            first[1][5] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;       
                            first[0][5] <= 1'b0;
                            first[1][5] <= 1'b0;
                            first[0][4] <= 1'b0;
                        end
                                    
                    end//12li end 
                    
                    else if( first[1][5] == 1)begin
                        if( redElevator[2] == 1 )begin
                        elevator = 16'b0000000000000000;
                        redElevator = 16'b00001100_00001100;
                        first[1][5] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][4] <= 1'b0;
                            first[1][5] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;            
                            first[1][4] <= 1'b0;
                            first[1][5] <= 1'b0;
                            first[0][4] <= 1'b0;
                        end                       
                    end//11
                    else if( first[0][4] == 1)begin
                        if( redElevator[2] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][4] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][4] <= 1'b0;
                            first[1][4] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;       
                            first[0][4] <= 1'b0;
                            first[1][4] <= 1'b0;
                            first[0][3] <= 1'b0;
                        end            
                    end//10
                    else if( first[1][4] == 1)begin
                            if( redElevator[2] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[1][4] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[1][4] <= 1'b0;
                            first[0][3] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;;            
                            first[1][4] <= 1'b0;
                            first[0][3] <= 1'b0;
                            first[1][3] <= 1'b0;
                        end      
                    end//9        
                    else if( first[0][3] == 2)begin
                            if( redElevator[4] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][3] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][3] <= 1'b0;
                            first[1][3] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;           
                            first[0][3] <= 1'b0;
                            first[1][3] <= 1'b0;
                            first[0][2] <= 1'b0;
                        end  
                                    
                    end//8li end
                    else if( first[1][3] == 1)begin
                            if( redElevator[2] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator =16'b00001100_00001100;
                            first[1][3] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[1][3] <= 1'b0;
                            first[0][2] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;           
                            first[1][3] <= 1'b0;
                            first[0][2] <= 1'b0;
                            first[1][2] <= 1'b0;
                        end  
                                    
                    end//7
                    else if( first[0][2] == 1)begin
                                    
                        if( redElevator[2] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][2] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][2] <= 1'b0;
                            first[1][2] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;     
                            first[0][1] <= 1'b0;
                            first[0][2] <= 1'b0;
                            first[1][2] <= 1'b0;
                        end
                                    
                    end//6
                    else if( first[1][2] == 1)begin
                        if( redElevator[2] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[1][2] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[1][2] <= 1'b0;
                            first[0][1] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;        
                            first[1][2] <= 1'b0;
                            first[0][1] <= 1'b0;
                            first[1][1] <= 1'b0;
                        end
                                    
                    end//5
                    else if( first[0][1] == 1)begin
                        if( redElevator[2] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][1] <= 1'b0;
                        end
                        else if ( redElevator[11] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;
                            first[0][1] <= 1'b0;
                            first[1][1] <= 1'b0;                   
                        end
                        else if ( redElevator[10] == 1 )begin
                            elevator = 16'b0000000000000000;
                            redElevator = 16'b00001100_00001100;  
                            first[0][1] <= 1'b0;
                            first[1][1] <= 1'b0;
                            first[0][0] <= 1'b0;
                        end
                        
                     end//4lü end
                    else if( first[1][1] == 1)begin
                            if( redElevator[2] == 1 )begin
                                elevator = 16'b0000000000000000;
                                redElevator = 16'b00001100_00001100;
                                first[1][1] <= 1'b0;
                            end
                            else if ( redElevator[11] == 1 )begin
                                elevator = 16'b0000000000000000;
                                redElevator = 16'b00001100_00001100;
                                first[1][1] <= 1'b0;
                                first[0][0] <= 1'b0;                   
                            end
                            else if ( redElevator[10] == 1 )begin
                                elevator = 16'b0000000000000000;
                                redElevator = 16'b00001100_00001100;          
                                first[1][1] <= 1'b0;
                                first[0][0] <= 1'b0;
                                first[1][0] <= 1'b0;
                            end
                          
                       end//3lü end     
                     else if( first[0][0] == 1)begin
                             if( redElevator[2] == 1 )begin
                                 elevator = 16'b0000000000000000;
                                 redElevator = 16'b00001100_00001100;
                                 first[0][0] <= 1'b0;
                             end
                             else if ( redElevator[11] == 1 )begin
                                 elevator = 16'b0000000000000000;
                                 redElevator = 16'b00001100_00001100;
                                 first[0][0] <= 1'b0;
                                 first[1][0] <= 1'b0;                   
                             end
                             else if ( redElevator[10] == 1 )begin
                                 elevator = 16'b0000000000001000;
                                 redElevator = 16'b00001100_00000100;            
                                 first[0][0] <= 1'b0;
                                 first[1][0] <= 1'b0;
                             end
                            
                      end//2lü end   
                     else if( first[1][0] == 1)begin
                             if( redElevator[2] == 1 )begin
                             elevator = 16'b0000000000000000;
                             redElevator = 16'b00001100_00001100;    
                             first[1][0] <= 1'b0;
                         end
                         else if ( redElevator[11] == 1 )begin
                             elevator = 16'b00000000_00001000;
                             redElevator = 16'b00001100_00000100;    
                             first[1][0] <= 1'b0;                   
                         end
                         else if ( redElevator[10] == 1 )begin
                             elevator = 16'b00000000_00001100;
                             redElevator = 16'b00001100_00000000;            
                             first[1][0] <= 1'b0;
                         end
                             
                     end//1lü end   
                  run <= 1;
                  end// 4.katta
             end
            
                else begin
                        if( redElevator[8] != 1/*!( ( redElevator ==  16'b00000011_00000001 ) || ( redElevator ==  16'b00000011_00000000 ) || ( redElevator ==  16'b00000001_00000000 ) )*/ )begin
                            redElevator <= { redElevator[1:0], redElevator[15:2] };
                            elevator <= { elevator[1:0], elevator[15:2] };
                        if( ( redElevator == 16'b00001100_00000100 || redElevator == 16'b00001100_00000000 || redElevator == 16'b00000100_00000000 ) )
                            run <= 0;                            
                        end
                        else begin
                             elevator <= 16'b0000001100000011;
                             redElevator <= 16'b0000000000000000;
                             drc = 1;
                             run <= 1;
                        end
                end
            end
            
            if( first[1][0] == 0  && second[1][0] == 0 && third[1][0] == 0 && elevator != 16'b0000001100000011 )begin
                if( redElevator[8] != 1/*!( ( redElevator ==  16'b00000011_00000001 ) || ( redElevator ==  16'b00000011_00000000 ) || ( redElevator ==  16'b00000001_00000000 ) )*/ )begin
                      redElevator <= { redElevator[1:0], redElevator[15:2] };
                      elevator <= { elevator[1:0], elevator[15:2] };
                   
                end
                else begin
                     elevator <= 16'b0000001100000011;
                     redElevator <= 16'b0000000000000000;
                     drc = 1;
                     stop <= 1;
                    
                end                
            end
            
//            if( first[1][0] == 0  && second[1][0] == 0 && third[1][0] == 0 && elevator == 16'b0000001100000011 )begin
//                //stop = 1;          
       counter <= 0;
    end
    end
   end
    assign tempDrc = drc;
    assign tstop = stop;
        
                assign tempImage_redF[0][1] = redElevator[9];
                assign tempImage_redF[0][2] = redElevator[10];
                assign tempImage_redF[0][3] = redElevator[11];
                assign tempImage_redF[0][4] = redElevator[12];
                assign tempImage_redF[0][5] = redElevator[13];
                assign tempImage_redF[0][6] = redElevator[14];
                assign tempImage_redF[0][7] = redElevator[15];
                
                assign tempImage_redF[1][0] = redElevator[0];
                assign tempImage_redF[1][1] = redElevator[1];
                assign tempImage_redF[1][2] = redElevator[2];
                assign tempImage_redF[1][3] = redElevator[3];
                assign tempImage_redF[1][4] = redElevator[4];
                assign tempImage_redF[1][5] = redElevator[5];
                assign tempImage_redF[1][6] = redElevator[6];
                assign tempImage_redF[1][7] = redElevator[7];
                
                assign tempImage_redF[2][0] = 1'b0;
                assign tempImage_redF[2][1] = 1'b0;
                assign tempImage_redF[2][2] = first[1][0];
                assign tempImage_redF[2][3] = first[0][0];
                assign tempImage_redF[2][4] = second[1][0];
                assign tempImage_redF[2][5] = second[0][0];
                assign tempImage_redF[2][6] = third[1][0];
                assign tempImage_redF[2][7] = third[0][0];
            
                assign tempImage_redF[3][0] = 1'b0;
                assign tempImage_redF[3][1] = 1'b0;
                assign tempImage_redF[3][2] = first[1][1];
                assign tempImage_redF[3][3] = first[0][1];
                assign tempImage_redF[3][4] = second[1][1];
                assign tempImage_redF[3][5] = second[0][1];
                assign tempImage_redF[3][6] = third[1][1];
                assign tempImage_redF[3][7] = third[0][1];    
                
                assign tempImage_redF[4][0] = 1'b0;
                assign tempImage_redF[4][1] = 1'b0;
                assign tempImage_redF[4][2] = first[1][2];
                assign tempImage_redF[4][3] = first[0][2];
                assign tempImage_redF[4][4] = second[1][2];
                assign tempImage_redF[4][5] = second[0][2];
                assign tempImage_redF[4][6] = third[1][2];
                assign tempImage_redF[4][7] = third[0][2];
                
                assign tempImage_redF[5][0] = 1'b0;
                assign tempImage_redF[5][1] = 1'b0;
                assign tempImage_redF[5][2] = first[1][3];
                assign tempImage_redF[5][3] = first[0][3];
                assign tempImage_redF[5][4] = second[1][3];
                assign tempImage_redF[5][5] = second[0][3];
                assign tempImage_redF[5][6] = third[1][3];
                assign tempImage_redF[5][7] = third[0][3];
                
                assign tempImage_redF[6][0] = 1'b0;
                assign tempImage_redF[6][1] = 1'b0;
                assign tempImage_redF[6][2] = first[1][4];
                assign tempImage_redF[6][3] = first[0][4];
                assign tempImage_redF[6][4] = second[1][4];
                assign tempImage_redF[6][5] = second[0][4];
                assign tempImage_redF[6][6] = third[1][4];
                assign tempImage_redF[6][7] = third[0][4];
                
                assign tempImage_redF[7][0] = 1'b0;
                assign tempImage_redF[7][1] = 1'b0;
                assign tempImage_redF[7][2] = first[1][5];
                assign tempImage_redF[7][3] = first[0][5];
                assign tempImage_redF[7][4] = second[1][5];
                assign tempImage_redF[7][5] = second[0][5];
                assign tempImage_redF[7][6] = third[1][5];
                assign tempImage_redF[7][7] = third[0][5];  
        
        assign tempImage_redF[0][0] = redElevator[8];
        logic [0:1] [7:0] blueElevator = Floor;
        assign tempImage_blue = blueElevator;
    
endmodule
