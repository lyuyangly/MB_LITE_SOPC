/*
************************************************************************************************
*	File   : ram_wb.v
*	Module : ram_wb
*	Author : Lyu Yang
*	Data   : 01,01,1970
*	Description : wishbone generic ram
************************************************************************************************
*/

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
`timescale 1ns / 100ps
module ram_wb (
    clk_i,
    rst_i,
    cyc_i,
    stb_i,
    we_i,
    sel_i,
    adr_i,
    dat_i,
    dat_o,
    cti_i,
    ack_o
);

parameter adr_width = 10;
parameter mem_size  = 1024;

// clock
input                   clk_i;
// async reset
input                   rst_i;

// wishbone signals
input                   cyc_i;
input                   stb_i;
input                   we_i;
input   [3:0]           sel_i;
input   [adr_width+1:0] adr_i;
input   [31:0]          dat_i;   
output  [31:0]          dat_o;
input   [2:0]           cti_i;
output  reg             ack_o;

wire [31:0] 		 wr_data;

// mux for data to ram
assign wr_data[31:24] = sel_i[3] ? dat_i[31:24] : dat_o[31:24];
assign wr_data[23:16] = sel_i[2] ? dat_i[23:16] : dat_o[23:16];
assign wr_data[15: 8] = sel_i[1] ? dat_i[15: 8] : dat_o[15: 8];
assign wr_data[ 7: 0] = sel_i[0] ? dat_i[ 7: 0] : dat_o[ 7: 0];

ram #(
    .dat_width(32),
    .adr_width(adr_width),
    .mem_size(mem_size)
) ram0 (
    .dat_i(wr_data),
    .dat_o(dat_o),
    .adr_i(adr_i[adr_width+1:2]), 
    .we_i(we_i & ack_o),
    .clk(clk_i)
);

// ack_o
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    ack_o <= 1'b0;
else if (!ack_o)
    begin
        if (cyc_i & stb_i)
            ack_o <= 1'b1;
    end  
else if ((sel_i != 4'b1111) | (cti_i == 3'b000) | (cti_i == 3'b111))
    ack_o <= 1'b0;

    
endmodule

//////////////////////////////////////////////////////////////////////////
module ram
(
    clk,
    we_i,
    adr_i,
    dat_i,
    dat_o
);

parameter adr_width = 10;
parameter dat_width = 32;
parameter mem_size  = 1024;

input [dat_width-1:0]      dat_i;
input [adr_width-1:0]      adr_i;
input 		               we_i;
output reg [dat_width-1:0] dat_o;
input                      clk;   

reg [dat_width-1:0] ram [0:mem_size - 1];

initial $readmemh("data.txt", ram);

always @ (posedge clk)
begin 
	dat_o <= ram[adr_i];
    if (we_i)
        ram[adr_i] <= dat_i;
end 

endmodule // ram
     