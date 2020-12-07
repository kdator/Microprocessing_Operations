/**
	\brief Модуль 32 битного сумматора.
	\date xx-09-2020.
	\author kolpakov dmitrii.
*/
module sumator_32(
		input [31:0] A,
		input [31:0] B,
		input Cin,
		output Cout,
		output [31:0] S
);						
	wire [32:0] wires;
	assign wires[0] = Cin;
	assign Cout = wires[32];
	genvar i;
	generate
			for (i = 0; i < 32; i = i + 1) begin : newgen
					sumator new (
						.A(A[i]),
						.B(B[i]),
						.Cin(wires[i]),
						.Cout(wires[i+1]),
						.S(S[i])
					);
			end
	endgenerate
endmodule