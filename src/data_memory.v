/*
	\brief Модуль памяти.
	\date 22-11-2020
	\author kolpakov dmitrii
*/

module data_memory (
		input		[31:0] 	addr_i, // считываемый адрес.
		input 	[31:0] 	wd_i,   // данные для записи.
		input 		    	clk_i,  // тактовый сигнал.
		input 	       	we_i,   // write enable сигнал.
		output	wire [31:0] rd_o   // инструкция из памяти.
);

	reg [7:0] MEMORY [0:63]; // типо память.
	wire [7:0] addr;
	initial $readmemb ("C:\\Users\\User\\Desktop\\test.txt", MEMORY); // считываем тестовые данные в память.
	
	assign addr = {addr_i[7:2], 2'b0};
	assign rd_o = (24'h660000 == addr_i[31:8]) ?  {MEMORY[addr + 3], MEMORY[addr + 2], MEMORY[addr + 1], MEMORY[addr]} : 32'd0;

	always @ (posedge clk_i)
		begin
			if (addr_i >= 32'h66000000 && addr_i <= 32'h660000FC)
				begin
				if (we_i)
					begin
						MEMORY[addr_i[7:2]]     <= wd_i[7:0];
						MEMORY[addr_i[7:2] + 1] <= wd_i[15:8];
						MEMORY[addr_i[7:2] + 2] <= wd_i[23:16];
						MEMORY[addr_i[7:2] + 3] <= wd_i[31:24];
					end
				end
		end
endmodule