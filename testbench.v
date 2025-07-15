`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2025 04:00:47 PM
// Design Name: 
// Module Name: SPI_SLAVE
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


module SPI_SLAVE (
    input wire clk,
    input wire rst,
    input wire sclk,
    input wire mosi,
    input wire ss,
    output reg miso,
    output reg [7:0] received_data
);

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg [7:0] transmit_data = 8'b10101010;

    always @(posedge sclk or posedge rst) begin
        if (rst) begin
            bit_cnt <= 0;
            shift_reg <= 0;
        end else if (!ss) begin
            shift_reg <= {shift_reg[6:0], mosi};
            bit_cnt <= bit_cnt + 1;
        end
    end

    always @(posedge sclk) begin
        if (!ss && bit_cnt == 3'b111) begin
            received_data <= {shift_reg[6:0], mosi};
        end
    end

    always @(negedge sclk or posedge rst) begin
        if (rst) begin
            miso <= 1'b0;
        end else if (!ss) begin
            miso <= transmit_data[7 - bit_cnt];
        end
    end

endmodule

