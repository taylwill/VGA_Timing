//Author: William Taylor
//Verion Date: 10/01/2024
//
// This is the Wrapper class for all of the other classes
// this will be the top level file all it does is call the
// other files
module VGA(
    input clk,
    input left, right, haz,
    input clear,
    output reg [7:0] Red, Green, Blue,  
    output hsync, vsync,
    output bright,
	 output vga_clk
);
    wire [9:0] hcount;
    wire [9:0] vcount;
    wire [2:0] rgbout; 
	 
	 parameter On = 8'b11111111;
	 parameter Off = 8'b00000000;

    // Instantiate bitgen_1 module
    bitgen_Mustang_Lights bits(
		  .clk(clk),
        .clear(clear),
        .h_counter(hcount),  
        .v_counter(vcount),
		  .right(right),
		  .left(left),
		  .haz(haz),
        .rgb(rgbout)
    ); 
	 

    // Instantiate VGA_timer_2 module
    VGA_timer_2 timer(
        .clk_50mhz(clk),
        .clear(clear),
        .hsync(hsync),
        .vsync(vsync),
        .h_counter(hcount),
        .v_counter(vcount),
        .display_on(bright),
		  .vga_clk(vga_clk)
    );

    // Combinational logic for RGB output
    always @(*) begin
        // Set Red output based on the second bit of rgbout
        if (rgbout[2] == 1'b1) begin
            Red = On; 
        end 
		  else begin
            Red = Off; 
        end

        // Set Green output based on the first bit of rgbout
        if (rgbout[1] == 1'b1) begin
            Green = On; 
        end 
		  else begin
            Green = Off; 
        end

        // Set Blue output based on the zeroth bit of rgbout
        if (rgbout[0] == 1'b1) begin
            Blue = On; 
        end 
		  else begin
            Blue = Off; 
        end
    end

endmodule