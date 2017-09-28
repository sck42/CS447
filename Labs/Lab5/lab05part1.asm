.data 
	types: .asciiz "bit", "nybble", "byte", "half", "word"
	bits: .asciiz "one", "four", "eight", "sixteen", "thirty-two"
	startPrompt: .asciiz "Please enter a datatype: "
	outputMSG: .asciiz "Number of bits: "
	notFoundMSG: .asciiz "Not Found!"
	output: .space 64
	input: .space 64
	temp: .space 4
	
.text

	addi $v0, $zero, 4 			#ask for user's string
	la $a0, startPrompt
	syscall
	
	la $a0, input
	jal	_readString
	
	addi $s2, $zero, 0			#Index
	la $s3, types				#store type array 
	la $s4, bits				#store bit array
	la $s5, input				#store input 
	
	Loop:
		add $a0, $zero, $s3
		add $a1, $zero, $s5
		jal	CheckType
		add $s6, $zero, $v0		#result of checkType
		bne $s6, 1, next		#if result != 1 jump to next 
		
		add $a0, $zero, $s4
		add $a1, $zero, $s2
		jal LookUp
		
		addi $v0, $zero, 10 		#terminate Program
		syscall
	next:
		addi $s2, $s2, 1
		bne $s2, 5, notEqual
		addi $v0, $zero, 4 		#print Message
		la $a0, notFoundMSG
		syscall
		addi $v0, $zero, 10 		#terminate Program
		syscall
	notEqual:
		la $a0, ($s3)			#Move to the next element 
		jal	_strLength
		add $s3, $s3, $v1
		addi $s3, $s3, 1
		j	Loop
		
	
_strLength: 
	add $t3, $zero, $zero  			#counter
	addi $t1, $zero, 0
	
	sLoop:  
		lb $t1, 0($a0)
		beq $t1, $zero, exit
		addi $a0, $a0, 1
		addi $t3, $t3, 1
		j	sLoop	
	exit:   add $v1, $zero, $t3
		jr	$ra

_readString:
	addi $v0, $zero, 8 			#read user's string 
	la $a0, input
	addi $a1, $zero, 64
	syscall
	
	la $t7, ($ra)
	la $a0, input
	jal	_strLength
	
	addi $v1, $v1, -1
	add $t0, $v1, $a0
	sb $zero, 0($t0)
	la $ra, ($t7)
	jr $ra
CheckType: 
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	add $s0, $zero, $a0			#Types
	add $s1, $zero, $a1			#input
	
	la $a0, ($s0)
	jal	_strLength 
	addi $s3, $v1, 0			#Store length of types 
	
	la $a0, ($s1)
	jal 	_strLength 
	addi $s4, $v1, -1			#Store length of input
	
	bne $s3, $s4, nEqual			#Check if the lengths are equal 
	add $s5, $zero, $s3
	cLoop:
		lb $s3, ($s0)			#If same length check for same characters 
		lb $s4, ($s1)
		bne $s3, $s4, nEqual
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		sub $s5, $s5, 1
		bne $s5, 0, cLoop
	addi $v0, $zero, 1			#Same length and same character = same word
	lw $ra, 0($sp)				#return 1 
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr	$ra
nEqual: 
	addi $v0, $zero, 0			#word not found, return 0 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr	$ra
	
LookUp: 
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	add $s0, $zero, $a0			#bits
	add $s1, $zero, $a1			#index
	addi $t2, $zero, 0
	lLoop: 					#Keep moving to the next element until  
		beq $t2, $s1, lexit		#the desired index is reached. 
		la $a0, ($s0) 
		jal	_strLength
		add $s0, $s0, $v1
		addi $s0, $s0, 1
		addi $t2, $t2, 1
		j	lLoop
	lexit:
		addi $v0, $zero, 4 		#print Message
		la $a0, outputMSG
		syscall
		addi $v0, $zero, 4 		#print result
		la $a0, ($s0)
		syscall
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		addi $sp, $sp, 16
		jr	$ra
		
		
	
	
	
