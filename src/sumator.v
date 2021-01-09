/**
	\brief Модуль сумматора.
	\date xx-09-2020.
	\author kolpakov dmitrii.
*/

module sumator(
		input A,
		input B,
		input Cin,
		output Cout,
		output S
);

	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) + (A & Cin) + (B & Cin);

endmodule