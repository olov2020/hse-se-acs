.macro read_correct_array_length(%x)
	li 	a7, 4
 	la 	a0, num_of_elems
 	ecall
 	
 	li 	a7, 5
 	ecall 	 	
 	mv	%x, a0
 .end_macro
 
 .macro input_num_to_array(%x)
	li 	a7, 4
 	la 	a0, add_to_array
 	ecall
 	li 	a7, 5
 	ecall
 	mv 	%x, a0
.end_macro

.macro print(%x)
	li 	a7, 4
 	la 	a0, sum_of_array
 	ecall
        mv 	a0, %x
	li 	a7, 1
	ecall
.end_macro

.macro sum_of_array(%x)
	li      a7, 1
        lw 	t3, (t4)
        add	%x, %x, t3
.end_macro
