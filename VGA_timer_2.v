//Author: William Taylor
//Verion Date: 10/01/2024
//
// this is the timing for the 
// vga that is made with the table
// that was given in the assignment 
// details. I used a skeleton to set up 
// all of the parameters
module VGA_timer_2(
    input clk_50mhz,     // 50 MHz clock input
    input clear,         
    output reg hsync,    // Horizontal sync
    output reg vsync,    // Vertical sync
    output reg [9:0] h_counter, // Horizontal pixel counter (0-799)
    output reg [9:0] v_counter, // Vertical line counter (0-520)
    output reg display_on,  // Output signal to indicate when to display pixels
	 output reg vga_clk		 // clock that will go the the VGA cable. this is 25mhz
);

// Horizontal and Vertical timing parameters
parameter H_DISPLAY = 640;    // Horizontal display width
parameter H_FRONT_PORCH = 16; // Horizontal front porch
parameter H_SYNC_PULSE = 96;  // Horizontal sync pulse width
parameter H_BACK_PORCH = 48;  // Horizontal back porch
parameter H_TOTAL = 800;      // Total horizontal width

parameter V_DISPLAY = 480;    // Vertical display height
parameter V_FRONT_PORCH = 10; // Vertical front porch 
parameter V_SYNC_PULSE = 2;   // Vertical sync pulse width 
parameter V_BACK_PORCH = 29;  // Vertical back porch 
parameter V_TOTAL = 521;      // Total vertical height

// Clock divider for generating a 25 MHz clock from 50 MHz input
reg clk_25mhz = 0;
always @(posedge clk_50mhz or posedge clear) begin
    if (clear)
        clk_25mhz <= 0;
    else
        clk_25mhz <= ~clk_25mhz;  // Toggle every 50 MHz clock cycle to create 25 MHz clock
	
	 vga_clk <= clk_25mhz;
end

// Horizontal and Vertical counters with clear driven by the 25 MHz clock 
always @(posedge clk_25mhz or posedge clear) begin
    if (clear) begin
        h_counter <= 0;
        v_counter <= 0;
    end else if (h_counter == H_TOTAL - 1) begin
        h_counter <= 0;
        if (v_counter == V_TOTAL - 1)
            v_counter <= 0;
        else
            v_counter <= v_counter + 1;
    end else begin
        h_counter <= h_counter + 1;
    end
end

// Horizontal sync signal
always @(*) begin
    if (h_counter >= H_DISPLAY + H_FRONT_PORCH && h_counter < H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE)
        hsync = 0; // On
    else
        hsync = 1;
end

// Vertical sync signal
always @(*) begin
    if (v_counter >= V_DISPLAY + V_FRONT_PORCH && v_counter < V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE)
        vsync = 0; // On
    else
        vsync = 1;
end

// Display enable signal just when you are on the screen
always @(*) begin
    display_on = (h_counter < H_DISPLAY) && (v_counter < V_DISPLAY);
end

endmodule