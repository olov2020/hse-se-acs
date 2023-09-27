.data
num_of_elems:   .asciz "Input number of elements in array: "
add_to_array: 	.asciz "Input num to add to array: "
sum_of_array:	.asciz "Sum of elements in array is "
sep:            .asciz  "--------\n"
.align  2
array:          .space 64
arrend:
	

.text
main:
	li	t1, 10		# correct num of elements in array in t1, t3
	li 	t3, 1
incorrect_array:
	li 	a7, 4
 	la 	a0, num_of_elems
 	ecall
 	
 	li 	a7, 5
 	ecall
 	mv 	t6, a0		  # num of elements in array in t6
 	
 	bgt 	t6, t1, incorrect_array
 	bgt 	t3, t6, incorrect_array
 	
 	li 	t0, 1		  # check for num of elements in array in t0
 	la      t4, array	  # adress to array in t4
 	
 fill:  li 	a7, 4
 	la 	a0, add_to_array
 	ecall
 	li 	a7, 5
 	ecall
 	mv 	t2, a0		  # adding elem to array in t2
 	sw      t2, (t4)          # Запись числа по адресу в t0
 	
 	addi    t4, t4, 4
        addi    t0, t0, 1         # check for num of elements in array
        ble 	t0, t6, fill

        li      a7, 4
	la      a0, sep           # Выведем строку-разделитель
        ecall
        
        la      t4, array
        li 	t0, 1
        
        li 	t5, 0		  # sum of elems in array in t5
        li	t2, 0 		  # sum of elems % 2 == 0
        li 	t1, 0 		  # sum of elems % 2 == 1
out:    li      a7, 1
        
        lw 	t3, (t4)
        add	t5, t5, t3
                
        
        addi    t4, t4, 4
        addi    t0, t0, 1 
        ble 	t0, t6, out
        
        li 	a7, 4
 	la 	a0, sum_of_array
 	ecall
        mv 	a0, t5
	li 	a7, 1
	ecall
        
        li      a7, 10            # Останов
        ecall 	
 	
