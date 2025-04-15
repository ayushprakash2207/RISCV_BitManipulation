`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 16:45:17
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


`timescale 1 ns / 1 ps

module Top(clk, resetn, trap);
	input clk;
	input resetn;
	output trap;


	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg  [31:0] mem_rdata;


	picorv32 #(
	) core (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.trap        (trap       ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  )
	);

	reg [31:0] memory [0:255];

	initial begin
		memory[0] = 32'h 8FC8F0B7; // LUI  x1, 0x8FC8F
		memory[1] = 32'h C9608093; // ADDI x1, x1, -0x36A
		
		memory[2] = 32'h 00A00113; // ADDI x2, x0, 0xA
		memory[3] = 32'h 00C11113; // SLLI x2, x2, 12
		memory[4] = 32'h 53710113; // ADDI x2, x2, 0x537
		memory[5] = 32'h 294D01B7; // LUI  x3, 0x294D
		memory[6] = 32'h 00310133; // ADD  x2, x2, x3

        memory[7] = 32'h 302081EB; // GRUP
        
        memory[8] = 32'h 2021826B; //DEGRUP
		
//		memory[3] = 32'h 53710113; // ADDI x2, x2, -0xAC9
//		memory[4] = 32'h A0010113; //       sw      x2,0(x1)
//		memory[5] = 32'h ff5ff06f; //       j       <loop>
	end

	always @(posedge clk) begin
		mem_ready <= 0;
		if (mem_valid && !mem_ready) begin
			if (mem_addr < 1024) begin
				mem_ready <= 1;
				mem_rdata <= memory[mem_addr >> 2];
				if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
				if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
				if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
				if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
			end
			/* add memory-mapped IO here */
		end
	end
endmodule
