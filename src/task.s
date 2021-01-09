.globl __start

.text
__start:
		addi x7, x0, 4     #                  || Define a address
		lw x8, 0(x7)       #                  || Load a
		addi x9, x0, 0     # x11 <- 0         || Make reg 11 accumulator of result
		addi x10, x0, 1    # x12 <- 0x1       || Put 1 const to 12 reg for compearations
		call factorial     # mult(a, b)       || Calling function
return:
		addi x16, x0, 12    # output result   || Define result address
		sw x11, 0(x16)      # output result   || Writing result to memory
		lw x11, 0(x16)      #                 || Print result
		nop                 #                 || finish the programm
		jal Exit            #                 || exit programm

factorial:
		addi x12, x8, 0                       #  number_to_return = number;
        sub x13, x8, x10                      #  int i = number - i;
		begin_first_loop:
        		beq x13, x0, end_first_loop   #  if (i == 0) jump to the end of the first cycle.
                addi x14, x0, 0				  #  sum = 0;
                addi x15, x13, 0			  #  int j = i;
        begin_second_loop:
        		beq x15, x0, end_second_loop  #  if (j == 0) jump to the end of the second cycle.
                add x14, x14, x12 			  #  sum += number_to_return;
                sub x15, x15, x10             #  j--;
                j begin_second_loop			  #  back to the begin of the second cycle.
        end_second_loop:
        		addi x12, x14, 0              #  number_to_return = sum;
                sub x13, x13, x10             #  i--;
                j begin_first_loop            #  back to the begin of the first cycle.
        end_first_loop:
        		addi x9, x12, 0               #  return number_to_return;
				ret                     #                   || Returning to main func

Exit:
	nop
  tail Exit