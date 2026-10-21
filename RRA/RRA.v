module RRA(
input clk,            // Clock
input [3:0]req,       // 4-bit request 
output reg [3:0]gnt); // 4-bit grant
reg [1:0]priority=2'd0;  // This register keeps track of which requester has highest priority currently
initial gnt=4'd0;    // Initialize grant=0
always @(posedge clk)
case(priority)      // Checks value of priority to determine which requester to prioritize
2'd0:	if(req[0]) begin
// Priority = 0: Requester 0 has the highest priority.
// Checking order: req[0] -> req[1] -> req[2] -> req[3]
gnt<=4'b0001;        // Grant access to requester 0
priority<=2'd1;      // Shift highest priority to requester 1 for the next cycle
end
else if(req[1]) begin
gnt<=4'b0010;        // Grant access to requester 1
priority<=2'd2;      // Shift highest priority to requester 2
end
else if(req[2]) begin
gnt<=4'b0100;        // Grant access to requester 2
priority<=2'd3;      // Shift highest priority to requester 3
end
else if(req[3]) begin
gnt<=4'b1000;        // Grant access to requester 3
priority<=2'd0;      // Shift highest priority back to requester 0
end
else 
gnt<=4'b0000;        // No requests at all
// Priority = 1: Requester 1 has the highest priority.
// Checking order: req[1] -> req[2] -> req[3] -> req[0]
2'd1:	if(req[1]) begin
gnt<=4'b0010;
priority<=2'd2;
end
else if(req[2]) begin
gnt<=4'b0100;
priority<=2'd3;
end
else if(req[3]) begin
gnt<=4'b1000;
priority<=2'd0;
end
else if(req[0]) begin
gnt<=4'b0001;
priority<=2'd1;
end
else 
gnt<=4'b0000;
// Priority = 2: Requester 2 has the highest priority.
// Checking order: req[2] -> req[3] -> req[0] -> req[1]
2'd2:	if(req[2]) begin
gnt<=4'b0100;
priority<=2'd3;
end
else if(req[3]) begin
gnt<=4'b1000;
priority<=2'd0;
end
else if(req[0]) begin
gnt<=4'b0001;
priority<=2'd1;
end
else if(req[1]) begin
gnt<=4'b0010;
priority<=2'd2;
end
else 
gnt<=4'b0000;
// Priority = 3: Requester 3 has the highest priority.
// Checking order: req[3] -> req[0] -> req[1] -> req[2]
2'd3:	if(req[3]) begin
gnt<=4'b1000;
priority<=2'd0;
end
else if(req[0]) begin
gnt<=4'b0001;
priority<=2'd1;
end
else if(req[1]) begin
gnt<=4'b0010;
priority<=2'd2;
end
else if(req[2])begin
gnt<=4'b0100;
priority<=2'd3;
end
else 
gnt<=4'b0000;
default: priority<=2'd0;
endcase
endmodule



//TESTBENCH
module RRA_tb;
reg clk;
reg [3:0] req;
wire [3:0] gnt;
// Instantiate the Unit Under Test (UUT)
RRA uut (.clk(clk),.req(req),.gnt(gnt));
always #5 clk = ~clk;      // Clock of period 10 time units
initial begin
// Initialize Inputs
clk = 0;
req = 4'b0000;
#10;
// Test Case 1: Single request
req = 4'b0001; 
#20;
// Test Case 2: Different single request
req = 4'b0010; 
#20;
// Test Case 3: Multiple simultaneous requests
req = 4'b1011; 
#40;
// Test Case 4: All requests active
req = 4'b1111; 
#40; 
// Test Case 5: No requests
req = 4'b0000;
#20;
// End simulation
$finish;
end
endmodule
