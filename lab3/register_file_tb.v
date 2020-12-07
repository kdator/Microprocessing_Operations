/*
	\brief Тесты для модуля регистрового файла.
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
 
module register_file_tb();

reg 	[4:0] 	addr1_i;    // адрес первого операнда.
reg 	[4:0] 	addr2_i;    // адрес второго операнда.
reg 	[4:0] 	wd_addr_i;  // адрес для записи данных.
reg 	[31:0]	wd_i;	      // данные для записи по wd_addr_i.
reg 				clk_i;      // тактовый сигнал CLK.
reg 				we_i;       // write enable сигнал.
reg				reset;      // reset сигнал.

wire 	[31:0]   rd1_o;      // данные, считанные с первого адреса.
wire	[31:0]   rd2_o;      // данные, считанные со второго адреса.

register_file RF(addr1_i, addr2_i, wd_addr_i, 
					  wd_i, clk_i, we_i, reset, 
					  rd1_o, rd2_o);

/*
	\brief Оба этих параметра нужны для эмуляции тактовых сигналов CLK.
*/
localparam CLK_FREQ_MHZ  = 5;                  // 100 MHz
localparam CLK_SEMI      = CLK_FREQ_MHZ / 2;   // 50  MHz

task testRF;
  input integer addr_1;
  input integer addr_2;
  input integer wd_addr;
  input integer write_data;

  begin
  addr1_i = addr_1;
  addr2_i = addr_2;
  wd_addr_i = wd_addr;
  wd_i = write_data;

  #50;
  $display("##################################");
  $display("WRITE)   Addres: %d, ", wd_addr, "Value after addres: %d", write_data);
  $display("READ_1)  Addres: %d, ", addr_1, "Value after addres: %d", rd1_o);
  $display("READ_2)  Addres: %d, ", addr_2, "Value after addres: %d", rd2_o);
  
  if (rd1_o != wd_i)
    $error("TEST RF BAD RESULT");
	else
	 $display("TEST RF GOOD RESULT");
  $display("##################################");

  end
endtask

task readDataFromRF;
  input integer addr_1;
  input integer wd_addr;
  input integer write_data;

  begin
  addr1_i = addr_1;
  wd_addr_i = wd_addr;
  wd_i = write_data;

  #50;
  $display("##################################");
  $display("WRITE)   Addres: %d, ", wd_addr, "Value after addres: %d", write_data);
  $display("READ)    Addres: %d, ", addr_1, "Value after addres: %d", rd1_o);

  if (rd1_o != wd_i)
    $error("READ DATA BAD RESULT");
  else
	 $display("READ DATA GOOD RESULT");
  $display("##################################");
  
  end
endtask

task resetRF;
  begin
  reset  = 1;
  addr1_i = 4'b0001;
  addr2_i = 4'b0010;
  #20;
  $display("rd1_o: %d", rd1_o, "\t rd2_o: %d", rd2_o);

  if (rd1_o != 32'd0 || rd2_o != 32'd0)
    $error("RESET BAD RESULT");

  addr1_i = 4'b0100;
  addr2_i = 4'b1111;
  #20;
  $display("rd1_o: %d", rd1_o, "\t rd2_o: %d", rd2_o);
  if (rd1_o != 32'd0 || rd2_o != 32'd0)
    $error("RESET BAD RESULT");

  end
endtask


initial begin
  $display("\nTEST WRITE ENABLE");
  we_i = 1;
  reset = 0;

  //             addres1  addres3  data
  readDataFromRF(4'b0001, 4'b0001, 32'd9);
  readDataFromRF(4'b0010, 4'b0010, 32'd111);
  readDataFromRF(4'b0100, 4'b0100, 32'd5);
  readDataFromRF(4'b1111, 4'b1111, 32'd1);

  //     addres1  addres2  wd_addr  data
  testRF(4'b0001, 4'b0010, 4'b0001, 32'd6);


  $display("\nTEST WRITE DISABLE"); 
  reset = 0;
  we_i = 0;
  readDataFromRF(4'b0001, 4'b0001, 32'd110);

  $display("\nTEST FIRST REG");
  we_i   = 1;
  reset  = 0;
  readDataFromRF(4'b0000, 4'b0000, 32'd227);

  $display("\nRESET TEST");
  resetRF();

end

initial begin
  clk_i = 1'b1; // изначально фронт активный.
  forever begin
    #CLK_SEMI clk_i = ~clk_i; // переключаем сигнал в противоположный.
  end
end


endmodule
