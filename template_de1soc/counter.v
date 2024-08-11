module counter (
	input in_clk,
	input reset,
	input [3:0] max_count,
	output [3:0] count
);

always @(posedge in_clk) begin
	if (~reset) begin       // reset = 1'b1 --> ~reset = 1'b0 --> active-low reset 
		count <= 4'b000;
	end else if (count >= max_count - 1) begin  
        count <= 4'b000;
    end else begin
        count <= count + 1;
    end
end
endmodule