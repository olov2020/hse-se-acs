.include "macros.asm"

# Sample program that writes to a new file.
.eqv		NAME_SIZE 512	# Размер буфера для имени файла
.eqv    	TEXT_SIZE 10240	# Размер буфера для текста

.data
prompt:  	.asciz "Input file path: "     	# Путь до читаемого файла
er_name_mes: 	.asciz "Incorrect file name\n"
default_name: 	.asciz "output.txt"      	# Имя файла по умолчанию

# Это выводимый текст
buffer: 	.asciz "The quick brown fox jumps over the lazy dog."
file_name: 	.space NAME_SIZE		# Имя читаемого файла
ans:    	.space TEXT_SIZE		# store answer here

.global write_to_file
.text
write_to_file:	
# Ввод имени файла с консоли эмулятора
    	la	a0, file_name
    	li      a1, NAME_SIZE
    	li      a7, 8
    	ecall
    	
    # Убрать перевод строки
    	li  	t4, '\n'
    	la  	t5, file_name
    	mv  	t3, t5				# Сохранение начала буфера для проверки на пустую строку
    	
loop2:
    	lb	t6, (t5)
    	beq 	t4, t6, replace2
    	addi 	t5, t5, 1
    	j   	loop2
    	
replace2:
    	beq 	t3, t5, default			# Установка имени введенного файла
    	sb 	zero, (t5)
    	mv 	a0, t3 				# Имя, введенное пользователем
    	j 	out
    	
default:
    	la  	 a0, default_name 		# Имя файла по умолчани
    	
out:
    # Open (for writing) a file that does not exist
    	li   	a7, 1024     			# system call for open file
    	li   	a1, 1        			# Open for writing (flags are 0: read, 1: write)
    	ecall            			# open a file (file descriptor returned in a0)
    	mv   	s3, a0       			# save the file descriptor
    	
    # Write to file just opened
	#la	s3, ans
	# print_str(s3)
	la	s2, ans
	func(s6, s2)				# change chars 
	
	li	t0, 1
	beq	s5, t0, print_console		# check needness to print answer to console
	bne	s5, t0, not_console

print_console:
	la	s2, ans
	print_str(s2)

not_console:	
	la	s2, ans
    	li   	a7, 64       			# system call for write to file
    	mv   	a0, s3      			# file descriptor
    	la   	a1, ans   			# address of buffer from which to write
    	li   	a2, 44       			# hardcoded buffer length
    	ecall             			# write to file
    	
    # Close the file
    	li   	a7, 57       			# system call for close file
    	mv   	a0, s3       			# file descriptor to close
    	ecall             			# close file
	ret
