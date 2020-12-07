/*
	\brief Модуль, содержащий дефайны-константы для АЛУ.
			 Используются для определения операции, которая пришла на АЛУ.
	\date 22-11-2020
	\author kolpakov dmitrii
*/

`define ALU_ADD  6'b0000
`define ALU_SUB  6'b0001
`define ALU_XOR  6'b0010
`define ALU_OR  6'b0011
`define ALU_AND  6'b0100
`define ALU_SRA  6'b0101
`define ALU_SRL  6'b0110
`define ALU_SLL  6'b0111
`define ALU_LTS  6'b1000
`define ALU_LTU  6'b1001
`define ALU_GES  6'b1010
`define ALU_GEU  6'b1011
`define ALU_EQ  6'b1100
`define ALU_NE  6'b1101
`define ALU_SLTS  6'b1110
`define ALU_SLTU  6'b1111