/*
	\brief Модуль процессора.
	\date 22-11-2020
	\author kolpakov dmitrii
*/

/*
	* B – выполнить безусловный переход;
	* C – выполнить условный переход;
	* WE – разрешение на запись в регистровый файл;
	* WS[1:0] – источник данных для записи в регистровый файл (0 – константа
	из инструкции, 1 – данные с переключателей, 2 – результат операции АЛУ;
	* ALUop[3:0] – код операции, которую надо выполнить АЛУ;
	* RA1[4:0] – адрес первого операнда для АЛУ;
	* RA2[4:0] – адрес второго операнда для АЛУ;
	* WA[4:0] – адрес регистра в регистровом файле, куда будет производиться
	запись;
	* const[7:0] – 8-битное значение константы.
	|31|30|29|28 27|26 25 24 23|22 21 20 19 18|17 16 15 14 13|12 11 10 9 8|7 6 5 4 3 2 1 0|
	 B  C  WE  WS     ALUop          RA1            RA2           WA             CONST
*/

module processor (
		input           clk_i,       // тактовый сигнал CLK.
		input    [9:0]  switches_i,  // данные с переключателей.
		input           reset,       // сигнал перехода к началу инструкций.
		output   [6:0]  hex1_o,
		output   [6:0]  hex2_o
);

	reg      [31:0]   instruction_in_memory;
	reg      [31:0]   wd;

	wire     [31:0]   instruction;
	wire     [31:0]   rd1;
	wire     [31:0]   rd2;
	wire     [31:0]   result;
	wire     [31:0]   se;
	wire     [31:0]   data_to_write;
	wire              comparsion_result;
	wire              data_we;

	initial instruction_in_memory <= 32'h66000000; // указатель на инструкцию.

	
	/*
		\brief "На рисунке также отражено подключение первого порта чтения к семисегментным индикаторам (HEX)"
	*/
	hex_decoder display1(
		.hex_i		(result[3:0]), 
		.hex_o	   (hex1_o)
	);

	hex_decoder display2(
		.hex_i		(result[7:4]),
		.hex_o	   (hex2_o)
	);

	data_memory data(
	  .addr_i   (instruction_in_memory),    // даём адрес инструкции в памяти.
	  .wd_i     (data_to_write),            // даём данные для записи.
	  .clk_i    (clk_i),                    // тактовый сигнал CLK.
	  .we_i     (data_we),						 // write enable сигнал.
	  .rd_o     (instruction)					 // получаем инструкцию из памяти.
	);

	register_file registers(
	  .addr1_i   (instruction[22:18]),    // адрес первого операнда.
	  .addr2_i   (instruction[17:13]),    // адрес второго операнда.
	  .wd_addr_i (instruction[12:8]),     // адрес для записи данных.
	  .wd_i      (wd),                    // данные для записи в wd_addr.
	  .we_i      (instruction[29]),       // write enable сигнал.
	  .clk_i     (clk_i),					  // тактовый сигнал CLK.
	  .reset_i   (reset),                 // reset сигнал.
	  .rd1_o     (rd1),                   // данные с первого порта.
	  .rd2_o     (rd2)                    // данные со второго порта.
	);


	miriscv_alu alu(
	  .operator_i           (instruction[26:23]), // ALUop.
	  .operand_a_i          (rd1),                // адрес первого операнда.
	  .operand_b_i          (rd2),					 // адрес второго операнда.
	  .comparsion_result_o  (comparsion_result),
	  .result_o             (result)
	);

	sign_extend sign_extender(
	  .const_i           (instruction[7:0]),
	  .instruction       (instruction[31:0]),
	  .extended_const_o  (se[31:0])
	);

	always @ (posedge clk_i) begin
	  if (reset)
		 instruction_in_memory <= 32'h66000000;
	  else if (instruction[31])
		 instruction_in_memory <= instruction_in_memory + (se << 2); // делаем безусловный переход.
	  else if (instruction[30])
			begin
			  if (comparsion_result == 0)
			  	 instruction_in_memory <= instruction_in_memory + 32'd4; // переходим к следующей инструкции.
			  else
				 instruction_in_memory <= instruction_in_memory + (se << 2); // делаем переход туда, куда нужно программисту.
			end
	  else
		 instruction_in_memory <= instruction_in_memory + 32'd4; // переход на следующую инструкцию по-умолчанию.
	end

	always @ ( * ) begin
		case (instruction[28:27]) // в зависимости от WS записываем в RG разные данные.
			2'b00 :   wd[31:0] <= se;
			2'b01	:   wd[31:0] <= {{24{switches_i[7]}},switches_i[7:0]};
			2'b10 :   wd[31:0] <= result;
			default : wd[31:0] <= 32'd0;
		endcase
	end
endmodule
