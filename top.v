`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/19 20:27:06
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire sys_clk,
    input wire rst_n,
    input wire sig_in,
    input wire sw,
    output reg [15:0] led,
    output wire [3:0] an,
    output wire [6:0] seg
    );

    reg [15:0] cnt;
	wire [31:0] sig_in_high_cnt_buf;
    wire [31:0] sig_in_low_cnt_buf;
    reg div_clk;
    reg [31:0] div_cnt;
    initial begin
        div_cnt <= 32'd0;
        div_clk <= 1'b0;
    end

    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            div_clk <= 1'b0;
            div_cnt <= 32'd0;
        end
        else begin
            if (div_cnt == 2000) begin
                div_cnt <= 32'd0;
                div_clk <= ~ div_clk;
            end
            else div_cnt <= div_cnt + 1'b1;
        end
    end
    
//    freq_counter test(
//        .sys_clk(sys_clk),
//        .rst_n(1'b1),
//        .sig_in(sig_in),
//        .sig_freq_cnt_buf(sig_freq_cnt_buf)
//    );

	reg [3:0] in1;
	reg [3:0] in2;
	reg [3:0] in3;
	reg [3:0] in4;
    wire [31:0] phase_diff_cnt_buf;
    
    bin_to_seg test1 (
        .clk(div_clk),
        .rst_n(1'b1),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .seg(seg),
        .wela(an)
    );
//    assign led[15:0] = phase_diff_cnt_buf[15:0];

//    wire ref_clk_1_2Hz;
//    wire phase_diff_detect;
    
//    phase_diff test(
//    	.sys_clk(sys_clk),
//    	.rst_n(1'b1),
//    	.sig_in0(sig_in0),
//    	.sig_in1(sig_in1),
//    	.phase_diff_cnt_buf(phase_diff_cnt_buf)
//    );


//    always @ (posedge sys_clk) begin
//    	if (sw) begin
//    		in1 <= sig_in_high_cnt_buf[3:0];
//    		in2 <= sig_in_high_cnt_buf[7:4];
//    		in3 <= sig_in_high_cnt_buf[11:8];
//    		in4 <= sig_in_high_cnt_buf[15:12];
//    		led[15:0] <= sig_in_low_cnt_buf[15:0];
//    	end
//    	else begin
//			in1 <= sig_in_high_cnt_buf[19:16];
//			in2 <= sig_in_high_cnt_buf[23:20];
//			in3 <= sig_in_high_cnt_buf[27:24];
//			in4 <= sig_in_high_cnt_buf[31:28];
//			led[15:0] <= sig_in_low_cnt_buf[31:16];
//    	end
//    end
    
    duty_cycle_meter test(
    	.sys_clk(sys_clk),
    	.rst_n(1'b1),
    	.sig_in(sig_in),
    	.sig_in_high_cnt_buf(sig_in_high_cnt_buf),
    	.sig_in_low_cnt_buf(sig_in_low_cnt_buf)
    );
    
    always @ (posedge sys_clk) begin
    	if (sw) begin
    		in4 <= sig_in_high_cnt_buf[31:28];
    		in3 <= sig_in_high_cnt_buf[27:24];
    		in2 <= sig_in_high_cnt_buf[23:20];
    		in1 <= sig_in_high_cnt_buf[19:16];
    		led <= sig_in_low_cnt_buf[31:16];
    	end
    	else begin
    		in4 <= sig_in_high_cnt_buf[15:12];
			in3 <= sig_in_high_cnt_buf[11:8];
			in2 <= sig_in_high_cnt_buf[7:4];
			in1 <= sig_in_high_cnt_buf[3:0];
			led <= sig_in_low_cnt_buf[15:0];
    	end
    end
    
    
 
endmodule

//module duty_cycle_meter(
//	input wire sys_clk,
//	input wire rst_n,
//	input wire sig_in,
//	output reg [31:0] sig_in_high_cnt_buf,
//	output reg [31:0] sig_in_low_cnt_buf
//	);