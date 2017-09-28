#Sai Konduru

.data
	promptMsg: .asciiz "Enter a String. "
	lengthMsg: .asciiz "This String has "
	length2Msg: .asciiz " characters."
	startIMsg: .asciiz "Specify start index: "
	endIMsg: .asciiz "Specify end index: "
	substringMsg: .asciiz "Your substring is: "
	input: .space 100
	output: .space 100
	enter: .ascii "\n"
.text
	addi $v0, $zero, 4 		#ask for user's string
	la $a0, promptMsg
	syscall
	
	addi $v0, $zero, 4 
	la $a0, enter
	syscall
	
	la $a0, input
	jal	_readString
	
	addi $v0, $zero, 4 		#print length message
	la $a0, lengthMsg
	syscall
	
	addi $v0, $zero, 1		#print length 
	add $a0, $zero, $v1
	syscall
	
	addi $v0, $zero, 4 		#print length message
	la $a0, length2Msg
	syscall
	
	addi $v0, $zero, 4 
	la $a0, enter
	syscall
	
	addi $v0, $zero, 4 		#ask for start index
	la $a0, startIMsg
	syscall
	
	addi $v0, $zero, 5 		#read start index
	syscall
	
	add $a2, $zero, $v0 		#save start index 
	
	addi $v0, $zero, 4 		#ask for end index
	la $a0, endIMsg
	syscall
	
	addi $v0, $zero, 5 		#read end index
	syscall
	
	la $a0, input 			#Load input
	la $a1, output 			#Load output
	add $a3, $zero, $v0 		#save end index
	
	jal	_subString
	
	addi $v0, $zero, 4 		#print substring message
	la $a0, substringMsg
	syscall
	
	addi $v0, $zero, 4 
	la $a0, enter
	syscall
	
	
	addi $v0, $zero, 4 		#print substring
	la $a0, ($a1)
	syscall
	
	addi $v0, $zero, 10 		#terminate Program
	syscall
	
_strLength: 
	add $t3, $zero, $zero  		#counter
	lLoop:  lbu $t1, 0($a0)
		beq $t1, $zero, exit
		addi $a0, $a0, 1
		addi $t3, $t3, 1
		j	lLoop
	exit:   add $v1, $zero, $t3
		jr	$ra

_readString:
	addi $v0, $zero, 8 		#read user's string 
	la $a0, input
	addi $a1, $zero, 100
	syscall
	
	la $t7, ($ra)
	jal	_strLength
	
	addi $v1, $v1, -1
	add $t0, $v1, $a0
	sb $zero, 0($t0)
	la $ra, ($t7)
	jr $ra
	
_subString:
	add $t0, $zero, $a0 		#Input	
	add $t8, $zero, $a1 		#Output
	add $t2, $zero, $a2 		#Start
	add $t4, $zero, $a3 		#End
	addi $t5, $zero, 0 		#temp
	la $t7, ($ra) 			#save the ra 
	
	slt $t5, $t4, $t2		#Check if end index is less than start index 
	beq $t5, 1, done
	
	slti $t5, $t2, 0 		#Check if start index is negative. 
	beq $t5, 1, done
	
	slti $t5, $t4, 0 		#Check if end indec is negative. 
	beq $t5, 1, done
	
	jal	_strLength
	addi $v1, $v1, -1
	
	slt $t5, $v1, $t4 	 	#Check if end index is too big
	bne $t5, 1, Loop		#if not move on to loop
	addi $t4, $v1, 0		#if too big change end index to strlength value 
	
	Loop:	
		beq $t2, $t4, done	#Start == End
		add $t5, $t0, $t2	#t5 = input + start
		lb $t5, 0($t5)		#t5 = byte of t5
		sb $t5, 0($t8) 		#t8 = byte of t5 added to the end of t8
		addi $t8, $t8, 1	#increment t8
		addi $t2, $t2, 1	#increment t2
		j	Loop
	done:   la $ra, ($t7)		#reload ra
		jr	$ra
	
