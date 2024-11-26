module bitgen_Pipe(
    input clk,
    input clear,
    input [9:0] h_counter, // Horizontal pixel counter from VGA_timer
    input [9:0] v_counter, // Vertical pixel counter from VGA_timer
    output reg [2:0] rgb // RGB output (2: Green, 1: Blue, 0: Red)
);

    // Screen resolution parameters
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    
    // Pipe dimensions
    parameter PIPE_WIDTH = 50;
    parameter PIPE_HEIGHT = 100;

    // Movement parameters
    parameter TOTAL_CYCLES = 25_000_000 * 8; // Total clock cycles for 8 seconds
    parameter PIXELS_PER_CYCLE = SCREEN_WIDTH / TOTAL_CYCLES; // Pixels moved per clock cycle

    // Registers to track pipe positions
    reg [31:0] pipe_position; // Horizontal position of the pipes (left edge)

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            pipe_position <= 0; // Reset pipe position
        end else if (pipe_position < SCREEN_WIDTH) begin
            pipe_position <= pipe_position + PIXELS_PER_CYCLE; // Move pipes to the right
        end
    end

    // Assign RGB values based on pipe positions
    always @(*) begin
        // Initialize RGB to black
        rgb = 3'b000;

        // Check for pipe in the top region
        if (h_counter >= pipe_position && h_counter < pipe_position + PIPE_WIDTH &&
            v_counter < PIPE_HEIGHT) begin
            rgb = 3'b010; // Green
        end
        
        // Check for pipe in the bottom region
        else if (h_counter >= pipe_position && h_counter < pipe_position + PIPE_WIDTH &&
                 v_counter >= (SCREEN_HEIGHT - PIPE_HEIGHT)) begin
            rgb = 3'b010; // Green
        end
    end
endmodule
