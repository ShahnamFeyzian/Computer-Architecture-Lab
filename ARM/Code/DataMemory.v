module DataMemory(clk, rst, ALU_ResIn, Value_RmIn, MEM_W_ENIn, MEM_R_ENIn, resultOut);
    input clk, rst;
    input [31:0] memAdr, writeData;
    input memRead, memWrite;
    output reg [31:0] readData;

    param WordCount = 64;

    reg [31:0] dataMem [0:WordCount-1]; // 256B memory

    wire [31:0] dataAdr, adr;
    assign dataAdr = memAdr - 32'd1024;
    assign adr = {2'b00, dataAdr[31:2]}; // Align address to the word boundary

    integer i;

    always @(negedge clk, posedge rst) begin
        if (rst)
            for (i = 0; i < WordCount; i = i + 1) begin
                dataMem[i] <= 32'd0;
            end
        else if (memWrite)
            dataMem[adr] <= writeData;
    end

    always @(memRead or adr) begin
        if (memRead)
            readData = dataMem[adr];
    end
endmodule
