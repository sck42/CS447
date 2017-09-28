
.data
	startPrompt: .asciiz "Enter a nonnegative integer: "
	errorMSG: .asciiz "Sorry Invalid Integer; Try again"
	answerMSG: .asciiz "Fib("
	answerMSG2: .asciiz ") = "
	enter: .asciiz "\n"
.text
return:	addi $v0, $zero, 4		#Print start Prompt
	la $a0, startPrompt
	syscall
	addi $v0, $zero, 5		#Take input integer
	syscall
	add $t1, $zero, $v0
	blt $t1, 0, negative		#Check if less than 0
	
	add $a0, $zero, $t1		#run fibonacci
	jal	_fib
	addi $t2, $v0, 0
	
	addi $v0, $zero, 4		#Print answer prompt 
	la $a0, answerMSG
	syscall
	
	addi $v0, $zero, 1		#Print answer prompt
	addi $a0, $t1, 0 
	syscall 
	
	addi $v0, $zero, 4		#Print answer
	la $a0, answerMSG2
	syscall 
	
	addi $v0, $zero, 1		#Print answer prompt
	addi $a0, $t2, 0 
	syscall
	
	addi $v0, $zero, 10		#Terminate Program
	syscall 


_fib:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	
	move $s0, $a0
	li $v0, 1 			# return value for terminal condition
	ble $s0, 0x2, fExit  		# check terminal condition
	addi $a0, $s0, -1 		# set args for recursive call to f(n-1)
	jal _fib
	move $s1, $v0 			# store result of f(n-1) to s1
	addi $a0, $s0, -2 		# set args for recursive call to f(n-2)
	jal _fib
	add $v0, $s1, $v0 		# add result of f(n-1) to it
fExit:
	lw $ra, 8($sp)
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 12
	jr $ra

   	 	
negative: 
	addi $v0, $zero, 4
	la $a0, errorMSG
	syscall
	
	addi $v0, $zero, 4
	la $a0, enter
	syscall
	j	return 
