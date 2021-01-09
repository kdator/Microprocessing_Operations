/*
	\brief Модуль регистрового файла.
	\date 22-11-2020
	\author kolpakov dmitrii
*/

 module register_file (
		input    [4:0] 	addr1_i,    // адрес первого операнда.
		input 	[4:0] 	addr2_i,    // адрес второго операнда.
		input 	[4:0] 	wd_addr_i,  // адрес для записи результата.
		input 	[31:0]	wd_i,	      // порт, куда запишутся данные.
		input 				clk_i,      // тактовый сигнал CLK.
		input 				we_i,       // write enable сигнал.
		input					reset_i,    // reset сигнал.
		output   [31:0]   rd1_o,      // данные, считанные с первого адресса.
		output	[31:0]   rd2_o	      // данные, считаннве со второго адресса.
);

	integer i; // переменная для сброса регистров в цикле.
	reg [31:0] RAM [0:31]; // 32 регистра по 32 бита каждый.

	// считываем данные из RAM на выход.
	assign rd1_o = (addr1_i != 32'd0) ?  RAM[addr1_i] : 32'd0;
	assign rd2_o = (addr2_i != 32'd0) ?  RAM[addr2_i] : 32'd0;

	always @ (posedge clk_i)
		begin
			if (we_i)
				begin
					if (wd_addr_i != 5'd0) // убеждаемся, что не пишем в константный ноль.
						RAM[wd_addr_i] <= wd_i;
				end
			if (reset_i)
				begin
					for (i = 0; i < 32; i = i + 1)
						begin
							RAM[i] <= 32'd0;
						end
				end
		end

endmodule