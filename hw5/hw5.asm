.data
num_of_elems:   .asciz "Input number of elements in array: "
add_to_array: 	.asciz "Input num to add to array: "
sum_of_array:	.asciz "Sum of elements in array is "
sep:            .asciz  "--------\n"
.align  2
array:          .space 64
arrend:
.text

.include "macros_hw5.asm"

main:
	read_correct_array_length(t6)
	
	li 	t0, 1		  # check for num of elements in array in t0
 	la      t4, array	  # adress to array in t4
 	li	s0, 10
 	jal 	fill
 	
 	
fill: 	input_num_to_array(t2)
 	sw      t2, (t4)          # Запись числа по адресу в t0
 	
 	addi    t4, t4, 4
        addi    t0, t0, 1
        bgt	t0, s0, break
        ble 	t0, t6, fill	  # check for num of elements in array

break:
        li      a7, 4
	la      a0, sep           # Выведем строку-разделитель
        ecall
        
        la      t4, array
        li 	t0, 1
        
        li 	t5, 0		  # sum of elems in array in t5
out:    sum_of_array(t5)
        addi    t4, t4, 4
        addi    t0, t0, 1 
        ble 	t0, t6, out
        
        print(t5)

        
        li      a7, 10            # Останов
        ecall 	
	
	
	
