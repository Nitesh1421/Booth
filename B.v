//Booth's Algorithm............
module booth(P , G , M , N);
 parameter size = 32;
 input signed [size - 1:0]M , N;
 output reg signed[size + size - 1:0]P;
 output reg [size + size - 1:0]G;//Magnitude
 
 reg signed[size - 1:0]X = 0;
 reg n = 1'b0;
 //reg [1:0]counter;
 integer counter ;
 
 reg signed [size + size:0]K;
 
 
 always @(M , N)
  begin
      K = {X , N , n}; 
      for(counter = 0 ; counter < size/*no of bits*/ ; counter = counter + 1)
	   begin
	     case({K[1],K[0]})
		      2'b00 , 2'b11 : begin K = K >>> 1; end
			  2'b01 : begin 
			              K[size + size:size + 1] = K[size + size:size + 1] + M;
						  K = K >>> 1;
					  end
			               
			  2'b10 : begin 
			              K[size + size:size + 1] = K[size + size:size + 1] - M;
						  K = K >>> 1;
					  end
			 // 2'b11 : begin K = K >>> 1; end
		 endcase
	   end
	   P = K[size + size:1];
	   G = (K[size + size] == 1'b1) ? ~K[size + size:1] + 1'b1 : K[size + size:1];
  end
  
  /*assign P = K[8:1];
  assign G = (K[8] == 1'b1) ? ~K[8:1] + 1'b1 : K[8:1];*/
endmodule

module test(P , G , M , N);
 input signed[63:0]P;
 input [63:0]G;
 output reg signed [31:0]M , N;
 
 //Driver
 initial
  begin
      #2 M = -7 ; N = 3 ;
	  #2 M = 3 ; N = 7 ;
	  #2 M = -7 ; N = 7 ;
	  #2 M = 2 ; N = 15 ;
	  #2 M = 16777215 ; N = 16777215;
	  
  end
  
 //Monitor
 initial
  begin
      $monitor($time , " M = %d , N = %d , P = %b , Magnitude = %d ", M , N , P , G);
	  #10 $finish;
  end
endmodule

module top;
 wire [31:0]M , N;
 wire [63:0]P , G;
 booth B(P , G , M , N);
 test T(P , G , M , N);
endmodule