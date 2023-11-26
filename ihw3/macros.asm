.macro func(%input_str, %ans_str)		# replacing chars
	li	s4, 90
loop:
	lb	t1, (%input_str)
	# print_int(t1)
	beqz	t1, end				# check for enging
	ble	t1, s4, to_upper
	bgt	t1, s4, to_lower
	
next_char:					# move forward in string
	addi	%input_str, %input_str, 1
	addi	%ans_str, %ans_str, 1
	j loop
	
to_lower:					# change upper char to lower
	addi	t2, t1, -32
	li	t3, 42
	beq	t2, t3, end
	sb	t2, (%ans_str)
	# print_char(t2)
	j next_char
to_upper:					# change lower char to upper
	addi	t2, t1, 32
	beq	t2, t3, end			# if there is "\n" in string
	sb	t2, (%ans_str)
	# print_char(t2)
	j next_char
end:
.end_macro

.macro read_from_file(%x)
	mv	s6, %x
	jal	read_from_file
	mv	%x, s6
.end_macro

.macro write_to_file(%x, %y)
	mv	s6, %x
	mv	s5, %y
	jal	write_to_file
.end_macro

.macro print_int(%int)				# for debug
	mv	a0, %int
	li	a7, 1
	ecall
.end_macro

.macro print_char(%char)			# just char print for debug
	mv	a0, %char
	li	a7, 11
	ecall
.end_macro

.macro print_str(%str)				# help to print
	mv 	a0 %str
	li 	a7 4
	ecall
.end_macro
