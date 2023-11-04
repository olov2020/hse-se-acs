.data
wrong_input_text:	.asciz "Input num is incorrect"

.include "macros.asm"

.text
main:
	li		s0, 1			# some useful vars
	li		s1, 0
	li		s2, -1
	
	fcvt.d.w	ft3, s0			# some useful vars
	fcvt.d.w	ft4, s1
	fcvt.d.w	ft5, s2
	
	input_x(ft0)				# input double to ft0
	
 	fge.d 		t3, ft0, ft3		# chech if input >= 1
 	beq		t3, s0, wrong_input
 	flt.d 		t3, ft0, ft5		# check if input < -1
 	beq		t3, s0, wrong_input
 	j		func
 
wrong_input:
	li		a7, 4
	la		a0, wrong_input_text
	ecall
	li      	a7, 10            	# return
        ecall 
 	
 func: 	
 	li		t6, 1			# count of iterations
	li		s5, 1000000		# upper side for correctness (1e6)
 	fcvt.d.w	ft1, s1			# answer in ft1
 	fcvt.d.w	ft3, s0			# numerator 
 	
 	
 calculating:
 	fcvt.d.w	ft2, t6
 	fmul.d		ft3, ft3, ft0		# count pow(x, i), i = 1, 2, ...
 	fdiv.d		ft4, ft3, ft2		# count pow(x, i) / i, i = 1, 2, ...
 	fsub.d		ft1, ft1, ft4		# update answer
 	
 	addi		t6, t6, 1		# update iterator
 	blt		t6, s5, calculating
 
 	print(ft1)				# print answer in ft1
 	
 	
 
