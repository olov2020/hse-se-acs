main:
	li 	t6, 2147483647	# max num
	li 	t0, 1		# finding num which is less than t6
	li 	t1, 1		# finding factorial
	li 	t2, 1		# last num of factorial mul
	
main_while:
	jal 	while
	div 	t3, t6, t2
	ble 	t3, t1, out
	ble	t1, t6, main_while
	
while:
	mul 	t1, t1, t2
	addi	t2, t2, 1
	ret
	
out:
	addi	t0, t2, -1
	mv 	a0, t0
	li 	a7, 1
	ecall
	li      a7, 10		# exit
        ecall 
