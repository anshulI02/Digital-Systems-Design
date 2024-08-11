`timescale 1ns / 1ps

module tb_keyboard_control();

    // Testbench signals
    reg inclk;
    reg kbd_data_ready;
    reg flash_read_finished;
    reg [7:0] kbd_received_ascii_code;
    wire direction;
    wire start_read_flash;
    wire restart;
    wire bonus_control;

    // Instantiate the DUT (Device Under Test)
    keyboard_control uut (
        .inclk(inclk),
        .kbd_data_ready(kbd_data_ready),
        .flash_read_finished(flash_read_finished),
        .kbd_received_ascii_code(kbd_received_ascii_code),
        .direction(direction),
        .start_read_flash(start_read_flash),
        .restart(restart),
        .bonus_control(bonus_control)
    );

    // Clock generation
    always begin
        inclk = 1;
        #5;
        inclk = 0;
        #5;
    end

    // Stimulus process
    initial begin
        // Initialize signals
        kbd_data_ready = 0;
        flash_read_finished = 0;
        kbd_received_ascii_code = 8'h00;

        // Wait for a few clock cycles
        #20;

        // Test forward state
        kbd_received_ascii_code = 8'h45; // ASCII code for 'E'
        #10;
        kbd_received_ascii_code = 8'h00;
        #50;

        // Test forward reset state
        kbd_received_ascii_code = 8'h52; // ASCII code for 'R'
        kbd_data_ready = 1;
        #10;
        kbd_data_ready = 0;
        kbd_received_ascii_code = 8'h00;
        #50;

        // Simulate flash read finished
        flash_read_finished = 1;
        #10;
        flash_read_finished = 0;
        #50;

        // Test forward pause state
        kbd_received_ascii_code = 8'h44; // ASCII code for 'D'
        #10;
        kbd_received_ascii_code = 8'h00;
        #50;

        // Test backward state
        kbd_received_ascii_code = 8'h42; // ASCII code for 'B'
        #10;
        kbd_received_ascii_code = 8'h00;
        #50;

        // Test backward reset state
        kbd_received_ascii_code = 8'h52; // ASCII code for 'R'
        kbd_data_ready = 1;
        #10;
        kbd_data_ready = 0;
        kbd_received_ascii_code = 8'h00;
        #50;

        // Simulate flash read finished
        flash_read_finished = 1;
        #10;
        flash_read_finished = 0;
        #50;

        // Test backward pause state
        kbd_received_ascii_code = 8'h44; // ASCII code for 'D'
        #10;
        kbd_received_ascii_code = 8'h00;
        #50;

        // Test bonus reset state
        kbd_received_ascii_code = 8'h52; // ASCII code for 'R'
        #10;
        kbd_received_ascii_code = 8'h00;
        #50;

        // Finish simulation
        $finish;
    end

endmodule
