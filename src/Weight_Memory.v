`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2019 17:25:12
// Design Name: 
// Module Name: Weight_Memory
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
`include "include.v"

module Weight_Memory #(parameter numWeight = 3, neuronNo=5,layerNo=1,addressWidth=10,dataWidth=16,weightFile="w_1_15.mif") 
    ( 
    input clk,
    input wen,
    input ren,
    input [addressWidth-1:0] wadd,
    input [addressWidth-1:0] radd,
    input [dataWidth-1:0] win,
    output reg [dataWidth-1:0] wout);
    
    // parameterize width and depth of memory
    // to allow for neuron design to be indep
    // of # of neurons
    reg [dataWidth-1:0] mem [numWeight-1:0];

    // ifdef pretrained: ROM
    // else: RAM 
    `ifdef pretrained
        initial
		begin
            // predifined verilog system task to initialize memory
            // reading from weightFile and initializng mem
            // b - specifies binary format
	        $readmemb(weightFile, mem);
	    end
	`else
		always @(posedge clk)
		begin
			if (wen)
			begin
				mem[wadd] <= win;
			end
		end 
    `endif
    
    // BRAM:    sequential writing to memory
    //          large amounts of data (4k per BRAM)
    // DRAM:    continous assignment to memory
    //          smaller amounts of data (like in activation func)
    // this is BRAM
    always @(posedge clk)
    begin
        // weight memory stored by external circuitry
        if (ren)
        begin
            wout <= mem[radd];
        end
    end 
endmodule
