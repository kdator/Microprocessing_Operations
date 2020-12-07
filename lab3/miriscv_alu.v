 /*
	\brief Модуль АЛУ, разработанный во второй лабораторной работе.
	\date 22-11-2020
	\author kolpakov dmitrii
 */
 
 
 `include "defines.v"

module miriscv_alu (
		input [3:0] operator_i,
		input [31:0] operand_a_i,
		input [31:0] operand_b_i,
		output reg[31:0] result_o,
		output reg comparsion_result_o,
		output cout
);

reg [31:0] second_operand; // для изменения состояния второго операнда.
wire [31:0] output_data; // для выходных данных с сумматора.
reg cin;

sumator_32 sumat(
	.A(operand_a_i),
	.B(second_operand),
	.Cin(cin),
	.Cout(cout),
	.S(output_data)
);

always @ ( * ) begin
	case (operator_i)
		`ALU_ADD: begin
			second_operand = operand_b_i;
			cin = 0;
			result_o <= output_data;
			comparsion_result_o <= 0;
			end
		`ALU_SUB: begin
			second_operand = ~operand_b_i;
			cin = 1;
			result_o <= output_data;
			comparsion_result_o <= 0;
			end
		`ALU_XOR: begin
			result_o <= operand_a_i ^ operand_b_i;
			comparsion_result_o <= 0;
			end
		`ALU_OR: begin
			result_o <= operand_a_i | operand_b_i;
			comparsion_result_o <= 0;
			end
		`ALU_AND: begin
			result_o <= operand_a_i & operand_b_i;
			comparsion_result_o <= 0;
			end
		`ALU_SRA: begin
			result_o <= $signed(operand_a_i) >>> operand_b_i;
			comparsion_result_o <= 0;
			end
		`ALU_SRL: begin
			result_o <= operand_a_i >> operand_b_i;
			comparsion_result_o <= 0;
			end
		`ALU_SLL: begin
			result_o <= operand_a_i << operand_b_i;
			comparsion_result_o <= 0;
			end
		`ALU_LTS: begin
			result_o <= ($signed(operand_a_i) < $signed(operand_b_i)) ? 1 : 0 ;
			comparsion_result_o <= result_o;
			end
		`ALU_LTU: begin
			result_o <= (operand_a_i < operand_b_i) ? 1 : 0 ;
			comparsion_result_o <= result_o;
			end
		`ALU_GES: begin
			result_o <= ($signed(operand_a_i) >= $signed(operand_b_i)) ? 1 : 0;
			comparsion_result_o <= result_o;
			end
		`ALU_GEU: begin
			result_o <= (operand_a_i >= operand_b_i) ? 1 : 0;
			comparsion_result_o <= result_o;
			end
		`ALU_EQ: begin
			result_o <= (operand_a_i == operand_b_i) ? 1 : 0;
			comparsion_result_o <= result_o;
			end
		`ALU_NE: begin
			result_o <= (operand_a_i != operand_b_i) ? 1 : 0;
			comparsion_result_o <= result_o;
			end
		default: begin
			result_o <= 0 ;
			comparsion_result_o <= result_o;
			end
	endcase
end

endmodule