`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2019 15:57:43
// Design Name: 
// Module Name: top_sim
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

`define MaxTestSamples 100

module top_sim(

    );
    
    reg reset;
    reg clock;
    reg [`dataWidth-1:0] in;
    reg in_valid;
    reg [`dataWidth-1:0] in_mem [784:0];
    reg [26*8-1:0] fileName; // each character is 8 bits & ../data/test_data_XXXX.txt is 26 characters long at most
    reg s_axi_awvalid;
    reg [31:0] s_axi_awaddr;
    wire s_axi_awready;
    reg [31:0] s_axi_wdata;
    reg s_axi_wvalid;
    wire s_axi_wready;
    wire s_axi_bvalid;
    reg s_axi_bready;
    wire intr;
    reg [31:0] axiRdData;
    reg [31:0] s_axi_araddr;
    wire [31:0] s_axi_rdata;
    reg s_axi_arvalid;
    wire s_axi_arready;
    wire s_axi_rvalid;
    reg s_axi_rready;
    reg [`dataWidth-1:0] expected;

    wire [31:0] numNeurons[31:1];
    wire [31:0] numWeights[31:1];
    
    assign numNeurons[1] = 30;
    assign numNeurons[2] = 30;
    assign numNeurons[3] = 10;
    assign numNeurons[4] = 10;
    
    assign numWeights[1] = 784;
    assign numWeights[2] = 30;
    assign numWeights[3] = 30;
    assign numWeights[4] = 10;
    
    integer right=0;
    integer wrong=0;
    

    zyNet dut(
    .s_axi_aclk(clock),
    .s_axi_aresetn(reset),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awprot(0),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(4'hF),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arprot(0),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .axis_in_data(in),
    .axis_in_data_valid(in_valid),
    .axis_in_data_ready(),
    .intr(intr)
    );
    
            
    initial
    begin
        clock = 1'b0;
        s_axi_awvalid = 1'b0;
        s_axi_bready = 1'b0;
        s_axi_wvalid = 1'b0;
        s_axi_arvalid = 1'b0;
    end
        
    always
        #5 clock = ~clock;
    
    function [7:0] to_ascii;
      input integer a;
      begin
        to_ascii = a+48;
      end
    endfunction
    
    always @(posedge clock)
    begin
        s_axi_bready <= s_axi_bvalid;
        s_axi_rready <= s_axi_rvalid;
    end
    
    task writeAxi(
    input [31:0] address,
    input [31:0] data
    );
    begin
        @(posedge clock);
        s_axi_awvalid <= 1'b1;
        s_axi_awaddr <= address;
        s_axi_wdata <= data;
        s_axi_wvalid <= 1'b1;
        wait(s_axi_wready);
        @(posedge clock);
        s_axi_awvalid <= 1'b0;
        s_axi_wvalid <= 1'b0;
        @(posedge clock);
    end
    endtask
    
    task readAxi(
    input [31:0] address
    );
    begin
        @(posedge clock);
        s_axi_arvalid <= 1'b1;
        s_axi_araddr <= address;
        wait(s_axi_arready);
        @(posedge clock);
        s_axi_arvalid <= 1'b0;
        wait(s_axi_rvalid);
        @(posedge clock);
        axiRdData <= s_axi_rdata;
        @(posedge clock);
    end
    endtask
    
    task configWeights();
    integer i,j,k,t;
    integer neuronNo_int;
    reg [`dataWidth:0] config_mem [783:0];
    begin
        @(posedge clock);
        for(k=1;k<=`numLayers;k=k+1)
        begin
            writeAxi(12,k);//Write layer number
            for(j=0;j<numNeurons[k];j=j+1)
            begin
                neuronNo_int = j;
                fileName = "_00.mif";
                i=0;
                while(neuronNo_int != 0)
                begin
                    fileName[8*(i+4) +: 1*8] = to_ascii(neuronNo_int%10);
                    neuronNo_int = neuronNo_int/10;
                    i=i+1;
                end 
                fileName[7*8 +: 1*8] = to_ascii(k);
                fileName[8*8 +: 13*8] = "../weights/w_";
                $readmemb(fileName, config_mem);
                writeAxi(16,j);//Write neuron number
                for (t=0; t<numWeights[k]; t=t+1) begin
                    writeAxi(0,{15'd0,config_mem[t]});
                end 
            end
        end
    end
    endtask
    
    task configBias();
    integer i,j,k,t;
    integer neuronNo_int;
    reg [31:0] bias[0:0];
    begin
        @(posedge clock);
        for(k=1;k<=`numLayers;k=k+1)
        begin
            writeAxi(12,k);//Write layer number
            for(j=0;j<numNeurons[k];j=j+1)
            begin
                neuronNo_int = j;
                fileName = "_00.mif";
                i=0;
                while(neuronNo_int != 0)
                begin
                    fileName[8*(i+4) +: 1*8] = to_ascii(neuronNo_int%10);
                    neuronNo_int = neuronNo_int/10;
                    i=i+1;
                end 
                fileName[7*8 +: 1*8] = to_ascii(k);
                fileName[8*8 +: 12*8] = "../biases/b_";
                $readmemb(fileName, bias);
                writeAxi(16,j);//Write neuron number
                writeAxi(4,{15'd0,bias[0]});
            end
        end
    end
    endtask
    
    
    task sendData();
    //input [25*7:0] fileName;
    integer t;
    begin
        $readmemb(fileName, in_mem);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        for (t=0; t <784; t=t+1) begin
            @(posedge clock);
            in <= in_mem[t];
            in_valid <= 1;
            //@(posedge clock);
            //in_valid <= 0;
        end 
        @(posedge clock);
        in_valid <= 0;
        expected = in_mem[t];
    end
    endtask
   
    integer i,j,layerNo=1,k;
    integer start;
    integer testDataCount;
    integer testDataCount_int;
    initial
    begin
        reset = 0;
        in_valid = 0;
        #100;
        reset = 1;
        #100
        writeAxi(28,0);//clear soft reset
        start = $time;
        `ifndef pretrained
            configWeights();
            configBias();
        `endif
        $display("Configuration completed",,,,$time-start,,"ns");
        start = $time;
        for(testDataCount=0;testDataCount<`MaxTestSamples;testDataCount=testDataCount+1)
        begin
            testDataCount_int = testDataCount;
            fileName = "0000.txt";
            i=0;
            // Convert each digit of the number to ASCII character and store it in fileName
            while(testDataCount_int != 0)
            begin
                fileName[8*(i+4) +: 1*8] = to_ascii(testDataCount_int%10); // append 1 byte long string starting at index 8*(i+4)
                testDataCount_int = testDataCount_int/10; // Divide by 10 to get the next digit
                i=i+1;
            end 
            fileName[8*8 +: 18*8] = "../data/test_data_"; // append 18 byte long string to currently 8 byte long string representing fileName
            sendData();
            @(posedge intr);
            //readAxi(24);
            //$display("Status: %0x",axiRdData);
            readAxi(8);
            if(axiRdData==expected)
                right = right+1;
            $display("%0d. Accuracy: %f, Detected number: %0x, Expected: %x",testDataCount+1,right*100.0/(testDataCount+1),axiRdData,expected);
            /*$display("Total execution time",,,,$time-start,,"ns");
            j=0;
            repeat(10)
            begin
                readAxi(20);
                $display("Output of Neuron %d: %0x",j,axiRdData);
                j=j+1;
            end*/
        end
        $display("Accuracy: %f",right*100.0/testDataCount);
        $stop;
    end


endmodule
