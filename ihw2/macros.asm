.macro input_x(%x)
	li 		a7, 7			# read double
 	ecall
 	
 	fadd.d		%x, fa0, ft4		# put num to %x arg
.end_macro

.macro print(%x)
	fcvt.d.w	ft3, s1
 	fadd.d		fa0, %x, ft3		# move %x (contains answer) to fa0
 	li		a7, 3			# print double ans
 	ecall
 	li      	a7, 10            	# return
        ecall 
.end_macro