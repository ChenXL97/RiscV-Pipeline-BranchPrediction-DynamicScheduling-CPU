`include "headfile.v"

module control 
(
	input clk,
	input IRQ,
	//input en,
	input rst,
	input [31:0]instruction,
	input N,V,C,Z,
	output reg PCwr,
	output reg DMwr,
	output reg RFwr,
	output reg[3:0]ALUop,
	output reg[1:0]NPCop,
	output reg RbSrc,
	output reg IMen,
	output reg[1:0]Rw,
	output reg [1:0]ALUASrc,
	output reg [2:0]ALUBSrc,
	output reg PCtoBL,
	output reg [31:0]ID_IR,EX_IR,MEM_IR,WB_IR,
	output reg [1:0]EXTop_ID,EXTop_EX,EXTop_WB,
	output reg MSR
	
);
	reg branch,Branch;
	reg irq;
	reg count;
	wire [3:0] cond; 

	
	assign cond=EX_IR[31:28];
	//assign op=instruction [27:26];
	//assign funct = instruction [25:20];

	parameter [3:0] IF   = 4'b0000,
						 DCD  = 4'b0001,
						 MA   = 4'b0010,
						 MR   = 4'b0011,
						 MEMWB= 4'b0100,
						 MW   = 4'b0101,
						 EXE  = 4'b0110,
						 ALUWB= 4'b0111,
						 BR   = 4'b1000;
						 
						 
	
	wire EQ,NE,CS,CC,MI,PL,VS,VC,HI,LS,GE,LT,GT,LE,AL; //Ìõ¼þÖ´ÐÐ
		assign EQ=(cond==4'b0000)?1'b1:1'b0;
		assign NE=(cond==4'b0001)?1'b1:1'b0;
		assign CS=(cond==4'b0010)?1'b1:1'b0;
		assign CC=(cond==4'b0011)?1'b1:1'b0;
		assign MI=(cond==4'b0100)?1'b1:1'b0;
		assign PL=(cond==4'b0101)?1'b1:1'b0;
		assign VS=(cond==4'b0110)?1'b1:1'b0;
		assign VC=(cond==4'b0111)?1'b1:1'b0;
		assign HI=(cond==4'b1000)?1'b1:1'b0;
		assign LS=(cond==4'b1001)?1'b1:1'b0;
		assign GE=(cond==4'b1010)?1'b1:1'b0;
		assign LT=(cond==4'b1011)?1'b1:1'b0;
		assign GT=(cond==4'b1100)?1'b1:1'b0;
		assign LE=(cond==4'b1101)?1'b1:1'b0;
		assign AL=(cond==4'b1110)?1'b1:1'b0;
		
		
		
	always@(posedge clk or negedge rst)
		begin
			if(!rst)
				begin
				irq<=1'b0;
				count<=1'b0;
				end
			else if(count==1'b1)
			begin
				irq<=IRQ;
				count<=1'b0;
			end
			else if(IRQ && !count)
			   begin
			   irq<=irq;
			   count<=count+1'b1;
			   end
			 else 
			     begin
			     irq<=irq;
			     count<=count;
			     end
		end
		
		
	//IF
	always@(posedge clk or negedge rst)
		begin
			if(!rst)
			begin
			ID_IR<=32'd0;
			Branch<=1'b0;
			end
			else
				begin
				if(branch)
					begin
					Branch<=1'b1;
					ID_IR<=32'd0;
					end
				else if(Branch)
				    begin
				    ID_IR<=32'd0;
				    Branch<=1'b0;
				    end
				else
					begin
					ID_IR<=instruction;
					Branch<=1'b0;
					end
					
				end
		end
		
			always@(negedge clk)
            begin 
                   IMen=1'b1;
                    if((EX_IR[27:26]==2'b10)&& !(branch||!((EQ&&Z)||(NE&&!Z)||(CS&&C)||(CC&&!C)||
                              (MI&&N)||(PL&&!N)||(VS&&V)||(VC&&!V)||(HI&&(!Z&&C))||
                              (LS&&(Z||!C))||(GE&&!(N^V))||(LT&&(N^V))||(LE&&(Z||(N^V)))||AL||(GT&&(!Z&&!(N^V)))))
                  )
                        begin
                        NPCop=2'b01;//EX_IMM32!
                        PCwr=1'b1;
                        EXTop_EX=2'b10;
                        branch=1'b1;
                        if(EX_IR[25])
                            PCtoBL=1'b1;
                        else
                            PCtoBL=1'b0;
                        end
                    else
                        begin
                        
								if(IRQ&&(!irq))
								begin
								NPCop=2'b10;
								PCwr=1'b1;
								EXTop_EX=2'b10;
								branch=1'b0;
								PCtoBL=1'b1;
								end
					   else
							begin
                        NPCop=2'b00;
                        PCwr=1'b1;
                        EXTop_EX=2'b10;
                        branch=1'b0;
                        PCtoBL=1'b0;
                        end
                        end
            
            end
				
	//DCD	
    always@(posedge clk or negedge rst)
        if(!rst)
            EX_IR<=32'd0;
        else  if (branch)
            EX_IR<=32'd0;
        else
            EX_IR<=ID_IR;            
    	
	always@(negedge clk)
		begin
		 if (branch || ID_IR==32'd0)
				begin
				EXTop_ID=2'b00;
				ALUBSrc=2'b00;
				ALUASrc=2'b00;
				end
			else
				begin

					case(ID_IR[27:26])
					2'b00: 
						begin

                        if(ID_IR[27:20]==6'b010010)
                                 begin
                                 EXTop_ID=2'b00;
                                 MSR=1'b1;
                                 end
                       else					
                        begin
								EXTop_ID=2'b00;
								MSR=1'b0;
					if(ID_IR[24:21]==`ADD||
						ID_IR[24:21]==`SUB||
						ID_IR[24:21]==`ORR||
						ID_IR[24:21]==`EOR||
						ID_IR[24:21]==`AND||
						ID_IR[24:21]==`MOV||
						ID_IR[24:21]==`CMP||
						ID_IR[24:21]==`RSB||
						ID_IR[24:21]==`SBC||
						ID_IR[24:21]==`TST||
						ID_IR[24:21]==`ADC||
						ID_IR[24:21]==`BIC||
						ID_IR[24:21]==`MVN||
						ID_IR[24:21]==`TEQ||
						ID_IR[24:21]==`RSC||
						ID_IR[24:21]==`CMN)
							begin
							     if(ID_IR[19:16] == EX_IR[15:12] && EX_IR[27:26]==2'b00 && EX_IR!=0)
							         ALUASrc=2'b01;
							     else if(ID_IR[19:16]==MEM_IR[15:12]&& MEM_IR[27:26]==2'b00&& MEM_IR!=0)
							         ALUASrc=2'b10;
							     else if (ID_IR[19:16]==WB_IR[15:12] && WB_IR[27:26]==2'b00 && WB_IR!=0)
							         ALUASrc=2'b11; 
							     else 
							         ALUASrc=2'b00;
							
								if(ID_IR[25])
									begin
										ALUBSrc=3'b001;
									end
								else
									begin
			                          if(ID_IR[3:0] == EX_IR[15:12] && EX_IR[27:26]==2'b00 && EX_IR!=0)
                                        ALUBSrc=3'b101;                             
                                    else if(ID_IR[3:0]==MEM_IR[15:12]&& MEM_IR[27:26]==2'b00 && MEM_IR!=0)//harzard
                                        ALUBSrc=3'b110;
                                    else if(ID_IR[3:0]==WB_IR[15:12] && WB_IR[27:26]==2'b00 && WB_IR!=0)       
                                        ALUBSrc=3'b111;            
									else
										ALUBSrc=3'b000;
									end
							 end
						
					  else
						begin
						ALUBSrc=3'b000;
						ALUASrc=2'b00;
						end
					end		
					end
						
						
					2'b01://STR/LDR
							begin
							MSR=1'b0;
							 if(ID_IR[19:16] == EX_IR[15:12] && EX_IR[27:26]==2'b00)
                                ALUASrc=2'b01;
                            else if(ID_IR[19:16]==MEM_IR[15:12]&&MEM_IR[27:26]==2'b00)
                                ALUASrc=2'b10;
                            else if (ID_IR[19:16]==WB_IR[15:12] && WB_IR[27:26]==2'b00)
                                ALUASrc=2'b11; 
                            else 
                                ALUASrc=2'b00;
								if(!ID_IR[25])//Immediate
									begin
										EXTop_ID=2'b01;
										ALUBSrc=1'b1;
					
							//			RbSrc<=1'b0;
									end
								else
									begin
								//		RbSrc<=1'b0;
										ALUBSrc=1'b0;
										EXTop_ID=2'b01;
									
									end
							end
						
					2'b10://Branch
						begin
						  MSR=1'b0;
							ALUASrc=2'b00;
							EXTop_ID=2'b10;
						//	RbSrc<=1'b0;
							ALUBSrc=1'b0;
						end
				
					//end
				default:
				    begin
					 		//RbSrc<=1'b0;
					 		MSR=1'b0;
							ALUASrc=2'b00;
							ALUBSrc=1'b0;
							EXTop_ID=2'b00;
						end
					endcase
			end
		end
		
			

	//EX	
	always@(posedge clk or negedge rst)
		if(!rst)
		begin
			MEM_IR<=32'd0;
		end
		else
            if (!((EQ&&Z)||(NE&&!Z)||(CS&&C)||(CC&&!C)||
                        (MI&&N)||(PL&&!N)||(VS&&V)||(VC&&!V)||(HI&&(!Z&&C))||
                        (LS&&(Z||!C))||(GE&&!(N^V))||(LT&&(N^V))||(LE&&(Z||(N^V)))||AL||(GT&&(!Z&&!(N^V)))))
                  begin
                    MEM_IR<=32'd0;
                  end
        else
			begin
				MEM_IR<=EX_IR;		
			end
			
	always@(negedge clk)
		if(EX_IR)
			begin
                    case (EX_IR[27:26])
                        2'b00: //Data
                        if(EX_IR[24:21]==`ADD||
                                EX_IR[24:21]==`SUB||
                                EX_IR[24:21]==`ORR||
                                EX_IR[24:21]==`EOR||
                                EX_IR[24:21]==`AND||
                                EX_IR[24:21]==`MOV||
                                EX_IR[24:21]==`CMP||
                                EX_IR[24:21]==`RSB||
                                EX_IR[24:21]==`SBC||
                                EX_IR[24:21]==`TST||
                                EX_IR[24:21]==`ADC||
                                EX_IR[24:21]==`BIC||
                                EX_IR[24:21]==`MVN||
                                EX_IR[24:21]==`TEQ||
                                EX_IR[24:21]==`RSC||
                                EX_IR[24:21]==`CMN)
                                begin
                                    ALUop=EX_IR[24:21];
                                    end
                                else 
                   
                                    begin
                                    ALUop=4'd0;
                                    end
                        2'b01:    //LDR|STR        
                            begin
                                if(EX_IR[23])
                                    ALUop=4'b0100;
                                else
                                    ALUop=4'b0010;
                            end
                        
                        
                        default:
                                begin
                                ALUop=4'd0;
                                end
                        endcase
                    end

		
	//MEM
	always@(posedge clk or negedge rst)
		if(!rst)
			WB_IR<=32'd0;
		else
			WB_IR<=MEM_IR;
            
		always@(negedge clk)
				if(MEM_IR)
						begin
                        if(MEM_IR[27:26]==2'b01)
                            begin
                            if(!MEM_IR[20])
                               begin
                                DMwr=1'b1;
                                RbSrc=1'b1;
                               end
                            else //LDR
                                begin
                                DMwr=1'b0;
                                RbSrc=1'b0;
                                end
                            end            
                        else
						  begin
                            DMwr=1'b0;    
                            RbSrc=1'b0;
                            end
                    end

						
				//WB		
	always@(negedge clk)
                            //        ALUWB:
                            if(WB_IR[27:26]==2'b00 && WB_IR!=32'd0)
                                if(WB_IR[25:20]==6'b010000)
                                begin
                                    RFwr=1'b1;
                                    Rw=2'b11;
                                    EXTop_WB=2'b00;
                                end
                                else 
                                begin
                                    if(WB_IR[24:21]==`ADD||
                                        WB_IR[24:21]==`SUB||
                                        WB_IR[24:21]==`ORR||
                                        WB_IR[24:21]==`EOR||
                                        WB_IR[24:21]==`AND||						
                                        WB_IR[24:21]==`RSB||
                                        WB_IR[24:21]==`SBC||
                                        WB_IR[24:21]==`ADC||
                                        WB_IR[24:21]==`BIC||
                                        WB_IR[24:21]==`MVN||
                                        WB_IR[24:21]==`RSC)
                                        begin
                                            RFwr=1'b1;
                                            Rw=2'b00;
                                            EXTop_WB=2'b00;
                                        end
                                else if(WB_IR[24:21]==`MOV)
                                        begin
                                            if(WB_IR[25])
                                                begin
                                                RFwr=1'b1;
                                                Rw=2'b10;
                                                EXTop_WB=2'b00;
                                                end
                                            else
                                                begin
                                                RFwr=1'b1;
                                                Rw=2'b00;
                                                EXTop_WB=2'b00;
                                                end
                                            
                                        end
                                        
                                    else
                                        begin
                                        RFwr=1'b0;
                                        Rw=2'b00;
                                        EXTop_WB=2'b00;
                                        end
                                end
                        //        MEMWB:
                            else if(WB_IR[27:26]==2'b01)
                                    begin
                                      if(WB_IR[20]==1'b1)
                                            begin
                                            RFwr=1'b1;
                                            EXTop_WB=2'b00;
                                            Rw=2'b01;
                                            end
                                        else
                                            begin
                                            RFwr=1'b0;
                                            Rw=2'b00;
                                            EXTop_WB=2'b00;
                                            end
                                    end
                            else begin
                               RFwr=1'b0;
                                    Rw=2'b00;
                                    EXTop_WB=2'b00;
                                    end
		

endmodule 