.include "hw6_macros.asm"
.data
input:		.asciz "Input your string"
input_num:	.asciz "Input num of characters to copy"
test_string1:	.asciz "@#f5%4"
test_string2:	.asciz "s8f7h3"
test_string3: 	.asciz ""

buf1:    	.space 100     # Буфер для первой строки
buf2:    	.space 100     # Буфер для второй строки
buf3:    	.space 100     # Буфер для третьей строки
buf4:    	.space 100     # Буфер для четвертой строки
buf5:    	.space 100     # Буфер для пятой строки
buf6:    	.space 100     # Буфер для шестой строки
.eqv SIZE 100
.align  2
ans_string:	.space 64

.text
.global main
main:
	# First test
	la a1 buf1
	la a2 test_string1
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 3)
	print_str_imm("We copied first 3 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	
	# Second test
	la a1 buf2
	la a2 test_string2
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 100)
	print_str_imm("We copied first 100 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Third test
	la a1 buf3
	la a2 test_string3
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 12)
	print_str_imm("We copied first 12 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Fourth test
	la a1 buf4
	print_str_imm("Input string: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 7)
	print_str_imm("We copied first 7 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Fifth test
	la a1 buf5
	print_str_imm("Input string: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 0)
	print_str_imm("We copied first 0 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Sixth test
	la a1 buf6
	print_str_imm("Input string: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, -5)
	print_str_imm("We copied first -5 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	
	exit
