module smg_control_module
(
    input CLK,
	 input RSTn,
	 input [15:0]Number_Sig,
	 output [3:0]Number_Data
);

    /******************************************/    
	 
	 parameter T1MS = 17'd49999;
	 
	 /******************************************/  
	 
	  reg [16:0]C1;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      C1 <= 17'd0;
		  else if( C1 == T1MS )
		      C1 <= 17'd0;
		  else
		      C1 <= C1 + 1'b1;
	 
	 /******************************************/ 
	 
	 reg [3:0]i;
	 reg [3:0]rNumber;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
		          i <= 4'd0;
			    	 rNumber <= 4'd0;
				end
		  else 
		      case( i )
//				    0:
//				    if(C1==T1MS) i<=i+1'b1;
//				    else rNumber<=Number_Sig%10;
				    
//				    1:
//				    if(C1==T1MS) i<=i+1'b1;
//                    else rNumber<=(Number_Sig%100)/10;
                    
                    
//                   2:
//                   if(C1==T1MS) i<=0;
//                   else rNumber<=(Number_Sig)/100;                    

					 
					 0:
					 if( C1 == T1MS ) i <= i + 1'b1;
					 else rNumber <= Number_Sig[15:12];
					 
					 1:
					 if( C1 == T1MS ) i <= i + 1'b1;
					 else rNumber <= Number_Sig[11:8];
					 
					 2:
					 if( C1 == T1MS ) i <= i + 1'b1;
					 else rNumber <= Number_Sig[7:4];
					 
					 3:
					 if( C1 == T1MS ) i <= 4'd0;
					 else rNumber <= Number_Sig[3:0];
				
				endcase
				
    /******************************************/ 
	 
	 assign Number_Data = rNumber;
	 
	 /******************************************/
	 
endmodule
