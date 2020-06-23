`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/18 08:32:31
// Design Name: 
// Module Name: CPSR_tb
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


module CPSR_tb(

    );
      reg clk;
    reg rst,Nin,Zin,Cin,Vin;
    
    
   CPSR U_CPSR
    (
       .clk(clk),
       .rst(rst),
        .Nin(Nin),
       .Zin(Zin),
         .Cin(Cin),
        .Vin(Vin),
        .Nout(Nout),
       .Zout(Zout),
        .Cout(Cout),
      .Vout(Vout)
    );
  

  always begin
    clk=0;
    #100
    clk=1;
    #100;
    end
    
    
   initial begin
    $monitor ($time,"clk=%d,Zin=%d,Zout=%d",U_CPSR.clk,U_CPSR.Zin,U_CPSR.Zout);
   
   rst=0;
   Zin=1;
   Cin=1;
   Nin=1;
   Vin=1;
   #100
   rst=1;
   #50
   Zin=0;
   Cin=0;
   Nin=0;
   Vin=0;
   
   
   
   end
    
    
  
  
  
    
   
endmodule
