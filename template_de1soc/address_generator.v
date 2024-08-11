module address_generator (
    input inclk,
    input audio_clk,
    input start_read,
    input direction,
    input restart,
    input end_flash,
    input [31:0] flash_mem_readdata,
    output reg start_flash,
    output reg finish,
    output reg flash_mem_read,
    output reg [22:0] flash_mem_address,
    output reg [3:0] flash_mem_byteenable,
    output reg [7:0] audio_data
);

parameter last_address = 23'h7FFFF;

parameter idle = 4'b0000;
parameter read_from_flash = 4'b0001;
parameter upper_data = 4'b0010;
parameter read_upper_data = 4'b0011;
parameter lower_data = 4'b0100;
parameter read_lower_data = 4'b0101;
parameter check_direction = 4'b0110;
parameter inc_mem_address = 4'b0111;
parameter dec_mem_address = 4'b1000;
parameter finished = 4'b1001;

reg [3:0] state = idle;

initial begin
    flash_mem_address = 0;
end

always @(posedge inclk) begin
    case (state)
        idle: begin
            if (start_read) begin
                state <= read_from_flash;
            end
        end
        read_from_flash: begin
            if (end_flash) begin
                state <= upper_data;
            end
        end
        upper_data: begin
            if (audio_clk) begin
                state <= read_upper_data;
            end
        end
        read_upper_data: begin
            state <= lower_data;
        end
        lower_data: begin
            if (audio_clk) begin
                state <= read_lower_data;
            end
        end
        read_lower_data: begin
            state <= check_direction;
        end
        check_direction: begin
            state <= direction ? dec_mem_address : inc_mem_address;
        end
        inc_mem_address: begin
            state <= finished;
        end
        dec_mem_address: begin
            state <= finished;
        end
        finished: begin
            state <= idle;
        end
        default: begin
            state <= idle;
        end
    endcase
end

always @(posedge inclk) begin
    case (state)
        read_upper_data: begin
            if (direction) begin
                audio_data <= flash_mem_readdata[31:24];
            end else begin
                audio_data <= flash_mem_readdata[7:0];
            end
            flash_mem_address <= flash_mem_address;
        end
        read_lower_data: begin
            if (direction) begin
                audio_data <= flash_mem_readdata[7:0];
            end else begin
                audio_data <= flash_mem_readdata[31:24];
            end
            flash_mem_address <= flash_mem_address;
        end
        dec_mem_address: begin
            if (restart) begin
                flash_mem_address <= last_address;
            end else begin
                flash_mem_address <= flash_mem_address - 23'd1;
                if (flash_mem_address == 0) begin
                    flash_mem_address <= last_address;
                end
            end
            audio_data <= audio_data;
        end
        inc_mem_address: begin
            if (restart) begin
                flash_mem_address <= 0;
            end else begin
                flash_mem_address <= flash_mem_address + 23'd1;
                if (flash_mem_address > last_address) begin
                    flash_mem_address <= 0;
                end
            end
            audio_data <= audio_data;
        end
        default: begin
            flash_mem_address <= flash_mem_address;
            audio_data <= audio_data;
        end
    endcase
end

always @(*) begin
    flash_mem_byteenable = 4'b1111;
    start_flash = (state == read_from_flash);
    flash_mem_read = (state == read_from_flash);
    finish = (state == finished);

end

endmodule
