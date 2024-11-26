//Author: William Taylor
//Verion Date: 10/01/2024
//
// this is the more complex bit gen that will
// make 6 boxes in the middle of the screen and these will
// act the same way that the mustang lights leds would
// backround is white and the squares will be blue and when
// on they will be red
module bitgen_Mustang_Lights(
    input clk,              // 50 MHz clock
    input clear,            
    input [9:0] h_counter,  // Horizontal pixel counter from VGA sync
    input [9:0] v_counter,  // Vertical pixel counter from VGA sync
    input right,            // Input for right turn signal
    input left,             // Input for left turn signal
    input haz,              // Input for hazard signal
    output reg [2:0] rgb    
);

// Parameters for square sizes and positions
parameter SQUARE_WIDTH = 50;
parameter SQUARE_HEIGHT = 50;
parameter H_SPACING = 20;    // pixels between the screen

// Compute the start of the squares (centered on 640x480 screen)
parameter GRID_START_X = (640 - (6 * SQUARE_WIDTH + 5 * H_SPACING)) / 2;
parameter GRID_START_Y = (480 - SQUARE_HEIGHT) / 2;

// Wires to connect to mustang lights output
wire [2:0] LEDR;  
wire [2:0] LEDL;  

// Instantiate Mustang_Lights
Mustang_Lights mustang_lights_inst (
    .RIGHT(right),
    .LEFT(left),
    .HAZ(haz),
    .RESET(clear),
    .CLK(clk),      
    .LEDR(LEDR),    
    .LEDL(LEDL)     
);

// this always block looks scary but all that it does is check if you are inside of one of the boxes 
// and if so then grab the LED value from mustang lights and if that is a one then display red instead of blue
// if you are not in any of them then display white or background.
always @(*) begin
    if (h_counter >= GRID_START_X && h_counter < GRID_START_X + SQUARE_WIDTH &&
        v_counter >= GRID_START_Y && v_counter < GRID_START_Y + SQUARE_HEIGHT) begin
        rgb <= (LEDR[2]) ? 3'b100 : 3'b001;  
    end
    else if (h_counter >= GRID_START_X + SQUARE_WIDTH + H_SPACING &&
             h_counter < GRID_START_X + 2 * SQUARE_WIDTH + H_SPACING &&
             v_counter >= GRID_START_Y && v_counter < GRID_START_Y + SQUARE_HEIGHT) begin
        rgb <= (LEDR[1]) ? 3'b100 : 3'b001;  
    end
    else if (h_counter >= GRID_START_X + 2 * (SQUARE_WIDTH + H_SPACING) &&
             h_counter < GRID_START_X + 3 * SQUARE_WIDTH + 2 * H_SPACING &&
             v_counter >= GRID_START_Y && v_counter < GRID_START_Y + SQUARE_HEIGHT) begin
        rgb <= (LEDR[0]) ? 3'b100 : 3'b001;  
    end
    else if (h_counter >= GRID_START_X + 3 * (SQUARE_WIDTH + H_SPACING) &&
             h_counter < GRID_START_X + 4 * SQUARE_WIDTH + 3 * H_SPACING &&
             v_counter >= GRID_START_Y && v_counter < GRID_START_Y + SQUARE_HEIGHT) begin
        rgb <= (LEDL[0]) ? 3'b100 : 3'b001;  
    end
    else if (h_counter >= GRID_START_X + 4 * (SQUARE_WIDTH + H_SPACING) &&
             h_counter < GRID_START_X + 5 * SQUARE_WIDTH + 4 * H_SPACING &&
             v_counter >= GRID_START_Y && v_counter < GRID_START_Y + SQUARE_HEIGHT) begin
        rgb <= (LEDL[1]) ? 3'b100 : 3'b001;  
    end
    else if (h_counter >= GRID_START_X + 5 * (SQUARE_WIDTH + H_SPACING) &&
             h_counter < GRID_START_X + 6 * SQUARE_WIDTH + 5 * H_SPACING &&
             v_counter >= GRID_START_Y && v_counter < GRID_START_Y + SQUARE_HEIGHT) begin
        rgb <= (LEDL[2]) ? 3'b100 : 3'b001;  
    end
    else begin
        rgb <= 3'b111;  // White everywhere else
    end
end

endmodule
