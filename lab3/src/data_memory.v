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
		output wire	[31:0] rd_o   // инструкция из памяти.
);

	reg [31:0] MEMORY [0:63]; // типо память.
	initial $readmemb ("C:\\Users\\User\\Desktop\\test.txt", MEMORY); // считываем тестовые данные в память.

	assign rd_o = (24'h660000 == addr_i[31:8]) ?  MEMORY[addr_i[7:2]] : 32'd0; // считываем машинное слово целиком.

	always @ (posedge clk_i)
		begin
			if (we_i)
				begin
					MEMORY[addr_i[7:2]] <= wd_i; // записываем слово, поэтому последние два бита откидываем.
				end
		end

endmodule