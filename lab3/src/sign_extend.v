/*
	\brief Модуль знакорасширителя.
	\date 22-11-2020
	\author kolpakov dmitrii
*/

module sign_extend(
		input [7:0] const_i,
		input [31:0] instruction,
		output [31:0] extended_const_o
);

	assign extended_const_o =  {{24{instruction[7]}},const_i[7:0]}; // расширяем константу из инструкции до 32 битов.
endmodule

