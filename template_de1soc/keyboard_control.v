module keyboard_control(
    input inclk,
    input kbd_data_ready,
    input flash_read_finished,
    input [7:0] kbd_received_ascii_code,
    output reg direction,
    output reg start_read_flash,
    output reg restart,
    output reg bonus_control
);

reg [2:0] state = check_key;

parameter check_key = 3'b000;

// forward playback control
parameter forward = 3'b001;
parameter forward_reset = 3'b010;
parameter forward_pause = 3'b011;

// backward playback control
parameter backward = 3'b100;
parameter backward_reset = 3'b101;
parameter backward_pause = 3'b110;

// Bonus state
parameter reset_state = 3'b111;

// Key press ASCII codes
parameter character_E = 8'h45;
parameter character_lowercase_e = 8'h65;
parameter character_D = 8'h44;
parameter character_lowercase_d = 8'h64;
parameter character_B = 8'h42;
parameter character_lowercase_b = 8'h62;
parameter character_F = 8'h46;
parameter character_lowercase_f = 8'h66;
parameter character_R = 8'h52;
parameter character_lowercase_r = 8'h72;

always @(*) begin
    case(state)
        forward_reset, backward_reset: begin
            restart = 1;
            start_read_flash = 1;
            bonus_control = (state == reset_state);
        end
        default: begin
            restart = 0;
            start_read_flash = (state == forward) || (state == backward);
            bonus_control = (state == reset_state);
        end
    endcase
end

always @(*) begin
    case (state)
        backward, backward_reset, backward_pause: direction = 1;
        forward, forward_reset, forward_pause: direction = 0;
        default: direction = 0;  // direction is forward by default
    endcase
end

always @(posedge inclk) begin
    case(state)
        check_key: begin
            if (kbd_received_ascii_code == character_E || kbd_received_ascii_code == character_lowercase_e) begin
                state <= forward;
            end else if (kbd_received_ascii_code == character_B || kbd_received_ascii_code == character_lowercase_b) begin
                state <= backward;
            end else if (kbd_received_ascii_code == character_R || kbd_received_ascii_code == character_lowercase_r) begin
                state <= reset_state;
            end else state <= check_key;
        end
        forward: begin
            if (kbd_received_ascii_code == character_R || kbd_received_ascii_code == character_lowercase_r) begin
                if (kbd_data_ready) begin
                    state <= forward_reset; // Only reset when key pressed
                end else begin
                    state <= forward;
                end
            end else if (kbd_received_ascii_code == character_B || kbd_received_ascii_code == character_lowercase_b) begin
                state <= backward;
            end else if (kbd_received_ascii_code == character_D || kbd_received_ascii_code == character_lowercase_d) begin
                state <= forward_pause;
            end else begin
                state <= forward; 
            end
        end 
        forward_reset: begin
            if (flash_read_finished) begin
                state <= forward;
            end
        end
        forward_pause: begin
            if (kbd_received_ascii_code == character_R || kbd_received_ascii_code == character_lowercase_r) begin
                state <= forward_reset;
            end else if (kbd_received_ascii_code == character_E || kbd_received_ascii_code == character_lowercase_e) begin
                state <= forward;
            end else if (kbd_received_ascii_code == character_B || kbd_received_ascii_code == character_lowercase_b) begin
                state <= backward_pause;
            end else begin
                state <= forward_pause;
            end
        end
        backward: begin
            if (kbd_received_ascii_code == character_R || kbd_received_ascii_code == character_lowercase_r) begin
                if (kbd_data_ready) begin
                    state <= backward_reset; // Only reset when key pressed
                end else begin
                    state <= backward;
                end
            end else if (kbd_received_ascii_code == character_D || kbd_received_ascii_code == character_lowercase_d) begin
                state <= backward_pause;
            end else if (kbd_received_ascii_code == character_F || kbd_received_ascii_code == character_lowercase_f) begin
                state <= forward;
            end else begin
                state <= backward;
            end
        end
        backward_reset: begin
            if (flash_read_finished) begin
                state <= backward;
            end
        end
        backward_pause: begin
            if (kbd_received_ascii_code == character_R || kbd_received_ascii_code == character_lowercase_r) begin
                state <= backward_reset;
            end else if (kbd_received_ascii_code == character_E || kbd_received_ascii_code == character_lowercase_e) begin
                state <= backward;
            end else if (kbd_received_ascii_code == character_F || kbd_received_ascii_code == character_lowercase_f) begin
                state <= forward_pause;
            end else begin
                state <= backward_pause;
            end
        end
        reset_state: begin
            state <= check_key;
        end
        default: begin
            state <= check_key;
        end
    endcase
end

endmodule