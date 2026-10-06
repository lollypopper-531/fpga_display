module osd_overlay_640x480(
    input  wire        I_clk,
    input  wire        I_rst,
    input  wire        I_vs,
    input  wire        I_de,
    input  wire [23:0] I_rgb,
    input  wire [1:0]  I_image_index,
    input  wire        I_auto_play,
    input  wire        I_display_valid,
    output reg  [23:0] O_rgb
);

reg        S_vs_d;
reg        S_de_d;
reg [10:0] S_x;
reg [9:0]  S_y;
reg [7:0]  S_char_code;
reg [7:0]  S_glyph_bits;
reg [3:0]  S_char_index;
reg [2:0]  S_row_index;
reg [2:0]  S_glyph_col;
reg        S_text_on;

function [7:0] font_row;
    input [7:0] code;
    input [2:0] row;
    begin
        font_row = 8'h00;
        case (code)
            8'h41: begin
                case (row)
                    3'd0: font_row = 8'b00111100;
                    3'd1: font_row = 8'b01100110;
                    3'd2: font_row = 8'b11000011;
                    3'd3: font_row = 8'b11111111;
                    3'd4: font_row = 8'b11000011;
                    3'd5: font_row = 8'b11000011;
                    3'd6: font_row = 8'b11000011;
                    default: ;
                endcase
            end
            8'h46: begin
                case (row)
                    3'd0: font_row = 8'b11111111;
                    3'd1: font_row = 8'b11000000;
                    3'd2: font_row = 8'b11000000;
                    3'd3: font_row = 8'b11111100;
                    3'd4: font_row = 8'b11000000;
                    3'd5: font_row = 8'b11000000;
                    3'd6: font_row = 8'b11000000;
                    default: ;
                endcase
            end
            8'h47: begin
                case (row)
                    3'd0: font_row = 8'b00111110;
                    3'd1: font_row = 8'b01100000;
                    3'd2: font_row = 8'b11000000;
                    3'd3: font_row = 8'b11001111;
                    3'd4: font_row = 8'b11000011;
                    3'd5: font_row = 8'b01100011;
                    3'd6: font_row = 8'b00111110;
                    default: ;
                endcase
            end
            8'h49: begin
                case (row)
                    3'd0: font_row = 8'b11111111;
                    3'd1: font_row = 8'b00011000;
                    3'd2: font_row = 8'b00011000;
                    3'd3: font_row = 8'b00011000;
                    3'd4: font_row = 8'b00011000;
                    3'd5: font_row = 8'b00011000;
                    3'd6: font_row = 8'b11111111;
                    default: ;
                endcase
            end
            8'h4D: begin
                case (row)
                    3'd0: font_row = 8'b11000011;
                    3'd1: font_row = 8'b11100111;
                    3'd2: font_row = 8'b11111111;
                    3'd3: font_row = 8'b11011011;
                    3'd4: font_row = 8'b11000011;
                    3'd5: font_row = 8'b11000011;
                    3'd6: font_row = 8'b11000011;
                    default: ;
                endcase
            end
            8'h4F: begin
                case (row)
                    3'd0: font_row = 8'b00111100;
                    3'd1: font_row = 8'b01100110;
                    3'd2: font_row = 8'b11000011;
                    3'd3: font_row = 8'b11000011;
                    3'd4: font_row = 8'b11000011;
                    3'd5: font_row = 8'b01100110;
                    3'd6: font_row = 8'b00111100;
                    default: ;
                endcase
            end
            8'h50: begin
                case (row)
                    3'd0: font_row = 8'b11111100;
                    3'd1: font_row = 8'b11000110;
                    3'd2: font_row = 8'b11000110;
                    3'd3: font_row = 8'b11111100;
                    3'd4: font_row = 8'b11000000;
                    3'd5: font_row = 8'b11000000;
                    3'd6: font_row = 8'b11000000;
                    default: ;
                endcase
            end
            8'h53: begin
                case (row)
                    3'd0: font_row = 8'b00111110;
                    3'd1: font_row = 8'b01100000;
                    3'd2: font_row = 8'b01100000;
                    3'd3: font_row = 8'b00111100;
                    3'd4: font_row = 8'b00000110;
                    3'd5: font_row = 8'b00000110;
                    3'd6: font_row = 8'b01111100;
                    default: ;
                endcase
            end
            8'h54: begin
                case (row)
                    3'd0: font_row = 8'b11111111;
                    3'd1: font_row = 8'b00011000;
                    3'd2: font_row = 8'b00011000;
                    3'd3: font_row = 8'b00011000;
                    3'd4: font_row = 8'b00011000;
                    3'd5: font_row = 8'b00011000;
                    3'd6: font_row = 8'b00011000;
                    default: ;
                endcase
            end
            8'h55: begin
                case (row)
                    3'd0: font_row = 8'b11000011;
                    3'd1: font_row = 8'b11000011;
                    3'd2: font_row = 8'b11000011;
                    3'd3: font_row = 8'b11000011;
                    3'd4: font_row = 8'b11000011;
                    3'd5: font_row = 8'b01100110;
                    3'd6: font_row = 8'b00111100;
                    default: ;
                endcase
            end
            8'h30: begin
                case (row)
                    3'd0: font_row = 8'b00111100;
                    3'd1: font_row = 8'b01100110;
                    3'd2: font_row = 8'b11001111;
                    3'd3: font_row = 8'b11011011;
                    3'd4: font_row = 8'b11110011;
                    3'd5: font_row = 8'b01100110;
                    3'd6: font_row = 8'b00111100;
                    default: ;
                endcase
            end
            8'h31: begin
                case (row)
                    3'd0: font_row = 8'b00011000;
                    3'd1: font_row = 8'b00111000;
                    3'd2: font_row = 8'b00011000;
                    3'd3: font_row = 8'b00011000;
                    3'd4: font_row = 8'b00011000;
                    3'd5: font_row = 8'b00011000;
                    3'd6: font_row = 8'b01111110;
                    default: ;
                endcase
            end
            8'h32: begin
                case (row)
                    3'd0: font_row = 8'b00111100;
                    3'd1: font_row = 8'b01100110;
                    3'd2: font_row = 8'b00000110;
                    3'd3: font_row = 8'b00011100;
                    3'd4: font_row = 8'b00110000;
                    3'd5: font_row = 8'b01100000;
                    3'd6: font_row = 8'b01111110;
                    default: ;
                endcase
            end
            8'h33: begin
                case (row)
                    3'd0: font_row = 8'b00111100;
                    3'd1: font_row = 8'b01100110;
                    3'd2: font_row = 8'b00000110;
                    3'd3: font_row = 8'b00011100;
                    3'd4: font_row = 8'b00000110;
                    3'd5: font_row = 8'b01100110;
                    3'd6: font_row = 8'b00111100;
                    default: ;
                endcase
            end
            default: ;
        endcase
    end
endfunction

always @(posedge I_clk or posedge I_rst) begin
    if (I_rst) begin
        S_vs_d <= 1'b0;
        S_de_d <= 1'b0;
        S_x    <= 11'd0;
        S_y    <= 10'd0;
    end else begin
        S_vs_d <= I_vs;
        S_de_d <= I_de;
        if (I_vs ^ S_vs_d) begin
            S_x <= 11'd0;
            S_y <= 10'd0;
        end else if (S_de_d && !I_de) begin
            S_x <= 11'd0;
            if (S_y == 10'd479)
                S_y <= 10'd0;
            else
                S_y <= S_y + 10'd1;
        end else if (I_de) begin
            if (S_x == 11'd639)
                S_x <= 11'd0;
            else
                S_x <= S_x + 11'd1;
        end
    end
end

always @* begin
    S_text_on   = 1'b0;
    S_char_code = 8'h20;
    S_char_index = 4'd0;
    S_row_index  = 3'd0;
    S_glyph_col  = 3'd0;
    S_glyph_bits = 8'h00;
    O_rgb        = I_rgb;

    if (I_de) begin
        if ((S_x >= 11'd16) && (S_x < 11'd208) &&
            (S_y >= 10'd8) && (S_y < 10'd60))
            O_rgb = {
                (I_rgb[23:16] >> 1) + 8'h08,
                (I_rgb[15:8]  >> 1) + 8'h0C,
                (I_rgb[7:0]   >> 1) + 8'h10
            };

        if (((S_x >= 11'd16) && (S_x < 11'd208) &&
             ((S_y == 10'd8) || (S_y == 10'd59))) ||
            ((S_y >= 10'd8) && (S_y < 10'd60) &&
             ((S_x == 11'd16) || (S_x == 11'd207))))
            O_rgb = 24'h00B8E8;

        if ((S_x >= 11'd24) && (S_x < 11'd88) &&
            (S_y >= 10'd16) && (S_y < 10'd24)) begin
            S_text_on    = 1'b1;
            S_char_index = (S_x - 11'd24) >> 3;
            S_row_index  = (S_y - 10'd16) & 3'b111;
            S_glyph_col  = (S_x - 11'd24) & 3'b111;
            case (S_char_index)
                4'd0: S_char_code = 8'h46;
                4'd1: S_char_code = 8'h50;
                4'd2: S_char_code = 8'h47;
                4'd3: S_char_code = 8'h41;
                4'd4: S_char_code = 8'h20;
                4'd5: S_char_code = 8'h4F;
                4'd6: S_char_code = 8'h53;
                default: S_char_code = 8'h44;
            endcase
        end

        if ((S_x >= 11'd24) && (S_x < 11'd104) &&
            (S_y >= 10'd36) && (S_y < 10'd44)) begin
            S_text_on    = 1'b1;
            S_char_index = (S_x - 11'd24) >> 3;
            S_row_index  = (S_y - 10'd36) & 3'b111;
            S_glyph_col  = (S_x - 11'd24) & 3'b111;
            case (S_char_index)
                4'd0: S_char_code = 8'h49;
                4'd1: S_char_code = 8'h4D;
                4'd2: S_char_code = 8'h47;
                4'd3: S_char_code = 8'h20;
                4'd4: S_char_code = I_image_index + 8'h31;
                4'd5: S_char_code = 8'h20;
                4'd6: S_char_code = I_auto_play ? 8'h41 : 8'h4D;
                4'd7: S_char_code = I_auto_play ? 8'h55 : 8'h41;
                4'd8: S_char_code = I_auto_play ? 8'h54 : 8'h4E;
                default: S_char_code = I_auto_play ? 8'h4F : 8'h55;
            endcase
        end

        if (S_text_on) begin
            S_glyph_bits = font_row(S_char_code, S_row_index);
            if (S_glyph_bits[7 - S_glyph_col])
                O_rgb = I_display_valid ? 24'hFFFF40 : 24'hA0A0A0;
        end
    end
end

endmodule
