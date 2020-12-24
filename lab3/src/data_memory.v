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
		output reg	[31:0] rd_o   // инструкция из памяти.
);

	reg [7:0] MEMORY [0:254]; // типо память.
	reg [31:0] instr_begin;   // начало инструкции.
	initial $readmemb ("C:\\Users\\User\\Desktop\\test.txt", MEMORY); // считываем тестовые данные в память.

	always @ (posedge clk_i)
		begin
			if (addr_i >= 32'h66000000 && addr_i <= 32'h660000FC)
				begin
					instr_begin <= (addr_i & (8'hff-3));
					rd_o[31:24] <= MEMORY[instr_begin + 3];
					rd_o[23:16] <= MEMORY[instr_begin + 2];
					rd_o[15:8] <= MEMORY[instr_begin + 1];
					rd_o[7:0] <= MEMORY[instr_begin];
			if (we_i)
				begin
					MEMORY[instr_begin] <= wd_i[7:0];
					MEMORY[instr_begin + 1] <= wd_i[15:8];
					MEMORY[instr_begin + 2] <= wd_i[23:16];
					MEMORY[instr_begin + 3] <= wd_i[31:24];
				end
		end
		else
			if (!we_i)
				begin
					rd_o[31:24] <= 0;
					rd_o[23:16] <= 0;
					rd_o[15:8]  <= 0;
					rd_o[7:0]   <= 0;
				end
		end
endmodule