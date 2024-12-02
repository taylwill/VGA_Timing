module bitgen_Pipe(
    input clk,
    input clear,
    input [9:0] h_counter, // Horizontal pixel counter from VGA_timer
    input [9:0] v_counter, // Vertical pixel counter from VGA_timer
    output reg [2:0] rgb // RGB output (2: Green, 1: Blue, 0: Red)
);

    // Screen resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;

    // Pipe dimensions
    parameter PIPE_WIDTH = 50;
    parameter PIPE_HEIGHT = 170;
    parameter BIRD_SIZE = 15;

    // Position of the first white square
    parameter SQUARE_SIZE = 30; // Size of the square (30x30 pixels)
    parameter SQUARE_X = (SCREEN_WIDTH - SQUARE_SIZE) / 2; // Center horizontally
    parameter SQUARE_Y = (SCREEN_HEIGHT - SQUARE_SIZE) / 2; // Center vertically

    // Position of the second white square (30 pixels to the left of the first one)
    parameter SQUARE2_X = SQUARE_X - SQUARE_SIZE - 30;

    // Internal pipe position
    wire [9:0] pipe_x; // Horizontal position of the pipe

    // Instantiate the pipe_controller
    pipe_controller pipe_ctrl(
        .clk(clk),
        .clear(clear),
        .pipe_x(pipe_x)
    );

    // RGB output logic
    always @(*) begin
        // Default background color (black)
        rgb = 3'b000;

        // Pipe: Top and bottom sections
        if ((h_counter >= pipe_x && h_counter < (pipe_x + PIPE_WIDTH) &&
             (v_counter < PIPE_HEIGHT || v_counter >= (SCREEN_HEIGHT - PIPE_HEIGHT)))) begin
            rgb = 3'b010; // Green
        end

        // Draw the first white square "bird" in the middle of the screen
        if ((h_counter >= SQUARE_X) && (h_counter < (SQUARE_X + SQUARE_SIZE)) &&
                 (v_counter >= SQUARE_Y) && (v_counter < (SQUARE_Y + SQUARE_SIZE))) begin
            rgb = 3'b111; // White 
        end

        // Draw the second white square to the left of the first one
        if ((h_counter >= SQUARE2_X) && (h_counter < (SQUARE2_X + SQUARE_SIZE)) &&
                 (v_counter >= SQUARE_Y) && (v_counter < (SQUARE_Y + SQUARE_SIZE))) begin
            rgb = 3'b110; // White 
        end
    end
endmodule


module pipe_controller(
    input clk,
    input clear,
    output reg [9:0] pipe_x // Horizontal position of the pipe
);

    // Screen resolution and pipe width
    parameter SCREEN_WIDTH = 640;
    parameter PIPE_WIDTH = 50;

    // Movement parameters
    parameter MOVE_SPEED = 3; // Speed of movement in pixels (1 is the slowest practical speed)
    reg [31:0] tick_counter = 0; // Counter for slowing movement

    // Slower movement by increasing this threshold
    parameter UPDATE_THRESHOLD = 1_000_000; // Adjust for extreme slowness (1M cycles)

    always @(posedge clk) begin
            // Increment movement counter
            tick_counter <= tick_counter + 1;
				

            // Update pipe position less frequently
            if (tick_counter == UPDATE_THRESHOLD) begin
                tick_counter <= 0;

                // Move pipe left and reset when off-screen
                if (pipe_x <= MOVE_SPEED) 
                    pipe_x <= SCREEN_WIDTH; // Wrap around to the right
                else
                    pipe_x <= pipe_x - MOVE_SPEED;
            
        end
    end
endmodule
