`timescale 1ns / 1ps
module pong_graph(
        input wire clk, reset,
        input wire [1:0] btn1,
        input wire [1:0] btn2,
        input wire [9:0] pix_x, pix_y,
        input wire graph_still,
        output wire graph_on,
        output reg hit, miss,
        output reg [2:0] graph_rgb
    );
    
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
	
	// all about ball
    reg [9:0] ball_x, ball_y;
    wire [9:0] ball_x_next, ball_y_next;
	wire [9:0] ball_right, ball_left, ball_top, ball_bottom;
    reg [9:0] x_delta, x_delta_next;
    reg [9:0] y_delta, y_delta_next;
	
	wire [2:0] ball_row, ball_col;
	reg [7:0] ball_data;
	
	// all about the output rgb
	wire barr_on, barl_on, sq_ball_on, rd_ball_on;
	wire [2:0] wall_rgb, barr_rgb, barl_rgb, ball_rgb;
	
	// colors
	assign barr_rgb = 3'b101;	// purple
	assign barl_rgb = 3'b010;	// green
	assign ball_rgb = 3'b100;	// red
	
	// who konws
	assign refr_tick = (pix_y==481) && (pix_x==0);
	
	always @*
	case (ball_row)
		3'h0: ball_data = 8'b00111100; 	//   ****
		3'h1: ball_data = 8'b01111110; 	//  ******
		3'h2: ball_data = 8'b11111111; 	// ********
		3'h3: ball_data = 8'b11111111; 	// ********
		3'h4: ball_data = 8'b11111111; 	// ********
		3'h5: ball_data = 8'b11111111; 	// ********
		3'h6: ball_data = 8'b01111110; 	//  ******
		3'h7: ball_data = 8'b00111100; 	//   ****
	endcase
	
	always @(posedge clk, posedge reset)
    begin
		if (reset)
        begin
            barr_y_reg <= 0;
            barl_y_reg <= 0;
            ball_x_reg <= 0;
            ball_y_reg <= 0;
            x_delta_reg <= 10'h004;
            y_delta_reg <= 10'h004;
        end   
		else
        begin
            barr_y <= barr_y_next;
            barl_y <= barl_y_next;
            ball_x <= ball_x_next;
            ball_y <= ball_y_next;
            x_delta <= x_delta_next;
            y_delta <= y_delta_next;
        end   
    end

	// positions
	assign ball_right = ball_x + 4;
	assign ball_left = ball_x + 3;
	assign ball_top = ball_y + 3;
	assign ball_bottom = ball_y + 4;
	assign ball_x_next = (gra_still) ? MAX_X / 2 :
						 (refr_tick) ? ball_x_reg + x_delta_reg :
						 ball_x;
	assign ball_y_next = (gra_still) ? MAX_Y / 2 :
						 (refr_tick) ? ball_y_reg + y_delta_reg :
                         ball_y;
	assign ball_on = ball_on & ball_bit;
	
	assign ball_bit = ball_data[ball_col];
	
	always @*
	begin
		hit = 1'b0;
		miss = 1'b0;
		x_delta_next = x_delta;
		y_delta_next = y_delta;
		if (graph_still)
			begin
				x_delta_next = 2;
				y_delta_next = 2;
			end
		else if ()
		else if (ball_right >= MAX_X - 10 or ball_right <= 10)
			miss = 1'b1;					// a miss
	end

	always @* 
	begin
        if (barr_on)
			graph_rgb = barr_rgb;
        else if (barl_on)
			graph_rgb = barl_rgb;
		else if (ball_on)
			graph_rgb = ball_rgb;
		else
			graph_rgb = 3'b000;
	end

	assign graph_on =  barr_on | barl_on | ball_on;
	
endmodule
