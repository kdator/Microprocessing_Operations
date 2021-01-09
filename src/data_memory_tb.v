/*
	\brief Тесты для модуля памяти.
	\date 22-11-2020
	\author kolpakov dmitrii
*/

/*
	Второе задание
	Хотя созданные модули относительно просты, тем не менее необходимо убедиться в
	правильности их функционирования. Для этого нужно написать testbench реализующий,
	на модели, последовательную автоматическую запись во все регистры RF некоторых
	случайных значений, а затем их считывание; убеждаясь в правильности записанного.
	В результате работы в терминал должны быть выведены сообщения: (1) об адресах
	регистров, в которые производится запись, (2) данные, которые были записаны,
	(3) считаны и (4) результат автоматического сравнения в конце в виде сообщения
	«good» или «bad», в случае успехов и ошибок, соответственно.
*/

`timescale 1ns / 1ps

module data_memory_tb();

reg [31:0]   addr_i;   // считываемый адрес.
reg [31:0]   wd_i;     // записываемые данные.
reg          clk_i;    // тактовый сигнал.
reg          we_i;     // write enable сигнал.

wire [31:0]  rd_o;     // данные, считанные с addr_i.

data_memory dm(addr_i, wd_i, clk_i, we_i, rd_o);

/*
	\brief Оба этих параметра нужны для эмуляции тактовых сигналов CLK.
*/
localparam CLK_FREQ_MHZ  = 5;                  // 100 MHz.
localparam CLK_SEMI      = CLK_FREQ_MHZ / 2;   // 50  MHz.

task writeDataToDM;
  input integer addr;
  input integer data;

  begin
    addr_i = addr;
    wd_i   = data;

    #50;
	 $display("##################################");
    $display("Addres: %d, ", (addr_i - 32'h66000000), "Value on write data: %d / %b", wd_i, wd_i);
    $display("Addres: %d, ", (addr_i - 32'h66000000), "Value on read data: %d / %b", rd_o, rd_o);
    if (wd_i != rd_o)
  		$error("BAD RESULT");
	 else
		$display("GOOD RESULT");
	 $display("##################################");
	 
  end
endtask

task readDataFromDM;
  input integer addr;

  begin
    addr_i = 32'h66000000 + addr;

    #50
	 $display("##################################");
	 $display("Addres: %b", (addr_i - 32'h66000000));
    $display("Addres: %d, ", (addr_i - 32'h66000000), "Value in read data: %d / %b", rd_o , rd_o);
	 $display("##################################");
  end
endtask

initial begin
  $display("\nREAD DATA FROM FILE");
  readDataFromDM(32'd0);
  readDataFromDM(32'd4);
  readDataFromDM(32'd8);

  $display("\nWRITE ENABELED TEST");
  we_i = 1;
  writeDataToDM(32'h66000001, 32'd5);
  writeDataToDM(32'h6600000B, 32'd6);
  writeDataToDM(32'h660000AB, 32'd7);
  
  $display("\nOUT OF BOARDER TEST");
  $display("\nTRY TO WRITE DATA BEFORE MY MEMORY:");
  writeDataToDM(32'h65000000, 32'd15);
  $display("\nTRY TO WRITE DATA AFTER MY MEMORY:");
  writeDataToDM(32'h67000034, 32'd15);

  $display("\nWRITE DISABLED TEST");
  we_i = 0;
  writeDataToDM(32'h66000009, 32'd15); // здесь должно типо не сработать.
end

initial begin
  clk_i = 1'b1; // изначально фронт активный.
  forever begin
    #CLK_SEMI;
	 clk_i = ~clk_i; // переключаем сигнал в противоположный.
  end
end
endmodule
