module flash_controller (
    input inclk,
    input start_read,
    input flash_mem_read,
    input flash_mem_waitrequest,
    input flash_mem_readdatavalid,
    output finish
);

parameter idle = 3'b000;
parameter check_read = 3'b001;
parameter read_instantiation = 3'b010;
parameter data_validation = 3'b011;
parameter finished = 3'b100;

reg [2:0] state = idle;

assign finish = (state == finished);

always @(posedge inclk) begin
    case (state)
        idle: begin
            if (start_read) begin
                state <= check_read;
            end
        end
        check_read: begin
            if (flash_mem_read) begin
                state <= read_instantiation;
            end
        end
        read_instantiation: begin
            if (!flash_mem_waitrequest) begin
                state <= data_validation;
            end
        end
        data_validation: begin
            if (flash_mem_readdatavalid) begin
                state <= finished;
            end
        end
        finished: begin
            state <= idle;
        end
        default: begin
            state <= idle;
        end
    endcase
end

endmodule