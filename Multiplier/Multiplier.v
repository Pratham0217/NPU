module Multiplier(
input clk,          // Clock
input [3:0]M,       // 4-bit Multiplicand
input [3:0]Q,       // 4-bit Multiplier
output reg [7:0]R   // 8-bit Result
);
reg [3:0]A;        // Accumulator (holds the upper half of the partial product)
reg [3:0]q;        // Local copy of the multiplier Q (holds the lower half)
reg C;             // Carry bit for additions
integer i;         // Loop counter
always @(posedge clk) begin
// Initialization
q=Q;      // Load multiplier into local register
A=4'd0;   // Reset the accumulator
R=8'd0;   // Reset the result
for(i=0;i<4;i=i+1) begin   // Shift-and-Add Loop (Executes entirely in one clock cycle)
if(q[0]) begin    // Check the LSB of the multiplier
// If LSB is 1: Add Multiplicand (M) to Accumulator (A)
// The carry out is stored in 'C'
{C,A} = M+A;
q = q >> 1;    // Right Shift q by 1-bit
q[3]=A[0];     // Move LSB of A into MSB of q
A = A >> 1;    // Right Shift A by 1-bit
A[3]=C;        // Move the Carry bit into MSB of A
end
else begin      // If LSB is 0: Do NOT add, just Right-shift {A, q}
q = q >> 1;      // Right Shift q by 1-bit
q[3]=A[0];       // Move LSB of A into MSB of q
A = A >> 1;      // Right Shift A by 1-bit
// C=0 because addition is not done, hence we dont need to move it into MSB of A
end
end
R={A,q};    // Final result
end
endmodule


// Testbench
module Multiplier_tb;
reg clk;
reg [3:0] M;
reg [3:0] Q;
wire [7:0] R;
Multiplier uut(.clk(clk),.M(M),.Q(Q),.R(R));    // Instantiate the Unit Under Test (UUT)
always #5 clk = ~clk;      // Clock of period 10 time units
initial begin
// Initialize Inputs
clk = 0;
M = 4'b0000;
Q = 4'b0000;
#10;
// Test Case 1: 11 * 7
M = 4'b1011; 
Q = 4'b0111; 
#10; 
// Test Case 2: 6 * 9
M = 4'b0110; 
Q = 4'b1001; 
#10; 
// Test Case 3: 10 * 12
M = 4'b1010; 
Q = 4'b1100; 
#10; 
// End simulation
$finish;
end
endmodule

