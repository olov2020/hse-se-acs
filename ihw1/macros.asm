 .macro input_num_to_array(%x)		# read new elem for array
	li 	a7, 4
 	la 	a0, add_to_array
 	ecall
 	li 	a7, 5
 	ecall
 	mv 	%x, a0
.end_macro

.macro print(%x)			# print elem from B-array
	lw	t3, (%x)
        mv 	a0, t3
	li 	a7, 1
	ecall
	li 	a7, 4
 	la 	a0, sep_B
 	ecall
.end_macro

.macro check_elem(%x)			# check sign of elem in A-array
	li	s0, 0
        lw 	t3, (t4)		# load elem from A-array at address t4 to t3
        beqz	t3, zero_elem		# check if num is equal to 0
        ble	t3, s0, less_zero	# check if num is less than 0
        ble	s0, t3, greater_zero	# check if num is greater than 0
        
        zero_elem:
        	li	t3, 0
        	j 	out
        	
       	greater_zero:
        	li	t3, 1
        	j 	out
        	
        less_zero:
        	li	t3, -1
        	j 	out
        
        out:
        	mv	%x, t3
.end_macro