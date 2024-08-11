parameter default_speed = 32'd1227;

module audio_speed_controller(
    input clk,
    input speed_up, 
    input speed_down, 
    input speed_reset,
    output reg [31:0] clk_div_end   //change name later
);

reg [31:0] temp_count = default_speed;

always_ff @(posedge clk) begin
    case({speed_up, speed_down, speed_reset})
        3'b001: temp_count <= default_speed;
        3'b010: temp_count <= temp_count - 32'd16;
        3'b100: temp_count <= temp_count + 32'd16;
    endcase
end

assign clk_div_end = temp_count;

endmodule