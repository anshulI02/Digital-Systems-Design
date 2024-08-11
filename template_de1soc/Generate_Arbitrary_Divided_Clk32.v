`timescale 1ns / 1ps

module Generate_Arbitrary_Divided_Clk32(inclk,outclk,outclk_Not,div_clk_count,Reset);
    input inclk;
	input Reset;
	output outclk;
	output outclk_Not;
	input[31:0] div_clk_count;
	 
	clk_div32 Div_Clk(.inclk(inclk),.outclk(outclk),
	.outclk_not(outclk_Not),.clk_count(div_clk_count),.reset(Reset));

endmodule

module clk_div32 (
	input inclk,
	input reset,
	output outclk,
	output outclk_not,
	input [31:0] clk_count
);

wire [31:0] counter;
assign outclk_not = ~outclk;

always @(posedge inclk) begin
	if (~reset) begin       // reset = 1'h1 --> ~reset = 1'h0 --> active-low reset
		counter <= 32'd0;
	end else if (counter >= clk_count - 1) begin 
        counter <= 32'd0;
        outclk <= ~outclk;
    end else begin
        counter <= counter + 32'd1;
    end
end
endmodule
