.include "macros.asm"

.align  2

.data

.global main
.text
main:
	read_from_file(s6) 	# read from file to s6
	
	write_to_file(s6)	# 
	
	li	a7, 10
    	ecall