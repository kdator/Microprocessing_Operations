/*
	\brief Модуль, содержащий дефайны-константы для АЛУ.
			 Используются для определения операции, которая пришла на АЛУ.
	\date 22-11-2020
	\author kolpakov dmitrii
*/

`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_XOR  4'b0010
`define ALU_OR  4'b0011
`define ALU_AND  4'b0100
`define ALU_SRA  4'b0101
`define ALU_SRL  4'b0110
`define ALU_SLL  4'b0111
`define ALU_LTS  4'b1000
`define ALU_LTU  4'b1001
`define ALU_GES  4'b1010
`define ALU_GEU  4'b1011
`define ALU_EQ  4'b1100
`define ALU_NE  4'b1101
`define ALU_SLTS  4'b1110
`define ALU_SLTU  4'b1111