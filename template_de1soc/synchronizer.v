module synchronizer(
    input async_sig,    // asynchronous signal
    input outclk,
    output reg out_sync_sig  // synchronized output signal
);

wire ff1_out, ff2_out, ff3_out, ff4_out;

parameter vcc = 1'b1;
parameter gnd = 1'b0;

sync_ff sync_ff_1(.in(vcc), .out(ff1_out), .clk(async_sig), .reset(ff4_out));
sync_ff sync_ff_2(.in(ff1_out), .out(ff2_out), .clk(outclk), .reset(gnd));
sync_ff sync_ff_3(.in(ff2_out), .out(out_sync_sig), .clk(outclk), .reset(gnd));
sync_ff sync_ff_4(.in(out_sync_sig), .out(ff4_out), .clk(outclk), .reset(gnd));

endmodule

module sync_ff (
    input in,
    input clk,
    input reset,
    output reg out
);

always_ff @(posedge reset or posedge clk) begin
    if (reset) begin
        out <= 1'b0;
    end else begin
        out <= in;
    end
end

endmodule