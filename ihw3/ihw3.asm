.include "macros.asm"

.align  2
.eqv		SIZE 100

.data
user:      	.space SIZE

.global main
.text
main:
	la	a0, user			# read input
    	li      a1, SIZE
    	li      a7, 8
    	ecall
    	
    	li	t4, '\n'			# change "\n" at the end to zero
    	la	t5, user
loop:	
    	lb	t6, (t5)
    	beq 	t4, t6, replace
    	addi 	t5, t5, 1
    	j	loop
replace:
    	sb	zero, (t5)
    	
    	li	t0, 89
    	li	t1, 78
    	la	t5, user
    	li	t2, 0
loop3:						# count lenght
	lb	t6, (t5)
	beqz	t6, skip
	addi	t2, t2, 1
	addi	t5, t5, 1
	j loop3

skip:
	li	t3, 1
	li	t4, -1
	bne	t2, t3, main			# if length != 1, move to main
	
	la	t5, user
	lb	t6, (t5)
	beq	t6, t0, check_print_console	# if Y in input
	beq	t6, t1, no_check_print_console	# if N in input
	j main

check_print_console:
	li	s5, 1				# print answer to console
	j input

no_check_print_console:
	li	s5, -1				# don't print answer
	j input
	
input:
	read_from_file(s6) 	# read from file to s6
	
	write_to_file(s6, s5)	# write file and there function for string is located
	
	li	a7, 10
    	ecall
