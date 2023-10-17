.data
num_of_elems:   	.asciz "\nInput number of elements in array: "
add_to_array: 		.asciz "Input num to add to array: "
error_num_of_elems:	.asciz "Incorrect value for num of elements in array: "
sep:            	.asciz "--------\n"
sep_B:			.asciz " "
.align  2
A:          		.space 64
B:			.space 64

.include "macros.asm"	

.text
main:
	li	s1, 10			# correct num of elements in array in s1, s2
	li 	s2, 1
	
	li 	a7, 4
 	la 	a0, num_of_elems
 	ecall
 	
 	li 	a7, 5
 	ecall
 	mv 	t6, a0			# num of elements in array in t6
 	
 	bgt 	t6, s1, incorrect_array	# check correctness for num of elems in A-array 
 	bgt 	s2, t6, incorrect_array
 	j 	make_array		# if num is correct
 	
incorrect_array:			# read new num of elems 
	li 	a7, 4
 	la 	a0, error_num_of_elems
 	ecall
 	
 	li 	a7, 5
 	ecall
 	mv 	t6, a0			
 	
 	bgt 	t6, s1, incorrect_array
 	bgt 	s2, t6, incorrect_array
 
 make_array:	
 	li 	t0, 1		  	# check for num of elements in array in t0
 	la      t4, A	  		# adress to array in t4
 	
fill_A: 				# read nums to A-array
	input_num_to_array(t2)		# read num to t2 and than add it to A-array
 	sw      t2, (t4)          	# put t4 to address at t4
 	
 	addi    t4, t4, 4
        addi    t0, t0, 1
        ble 	t0, t6, fill_A	  	# check for num of elements in array

        li      a7, 4
	la      a0, sep           	
        ecall
        
        la      t4, A		
        la      t5, B			# create B-array
        li 	t0, 1
        
fill_B:    				# fill B-array
	check_elem(t2)			# get elem for B-array
	sw      t2, (t5)
        addi    t4, t4, 4
        addi    t5, t5, 4
        addi    t0, t0, 1 
        ble 	t0, t6, fill_B

        la      t5, B
        li 	t0, 1
        
print_B:        			# print elems from B-array
        print(t5)
        addi    t5, t5, 4
        addi    t0, t0, 1 
        ble 	t0, t6, print_B
        
        li      a7, 10            	# return
        ecall 	
