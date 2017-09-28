#Sai Konduru 

.data
intro: .asciiz "x*y calculator"
space: .asciiz "\n"
promptx: .asciiz "Please enter x: "
error: .asciiz "Integer must be non-negative."
prompty: .asciiz "Please enter y: "
multiply: .asciiz " * " 
equals: .asciiz " = "
.text
	#print intro
	addi $v0, $zero, 4
	la $a0, intro
	syscall
	
	#print space
	addi $v0, $zero, 4
	la $a0, space
	syscall
	
	#print first instruction
Loopx:	addi $v0, $zero, 4
	la $a0, promptx 
	syscall
	#Take first integer 
	addi $v0, $zero, 5
	syscall
	add $t0, $zero, $v0
	srl $t3, $t0, 31
	and $t3, $t3, 1
	bne $t3, 1, xNotNegative
	#print error msg
	addi $v0, $zero, 4
	la $a0, error
	syscall
	#print space
	addi $v0, $zero, 4
	la $a0, space
	syscall
	j	Loopx
xNotNegative: add $t5, $zero, $t0 	#store x in $t5

	#print second instruction
Loopy:	addi $v0, $zero, 4
	la $a0, prompty
	syscall
	#Take second integer 
	addi $v0, $zero, 5
	syscall
	add $t1, $zero, $v0
	srl $t3, $t1, 31
	and $t3, $t3, 1
	bne $t3, 1, yNotNegative
	#print error msg
	addi $v0, $zero, 4
	la $a0, error
	syscall
	#print space
	addi $v0, $zero, 4
	la $a0, space
	syscall
	j	Loopy
yNotNegative: add $t6, $zero, $t1 	#store y in $t6
	
	#Shifing counter 
	add $t2, $zero, $zero
	
	#Result 
	add $t7, $zero, $zero
	
Loop:	beq $t1, $zero, outOfLoop #Leave loop if b = 0 
	and $t4, $t1, 1 	  #And b with one to get the LSB
	bne $t4, 1, notOne	  #If the LSB is not one jump to Not One. 
	sllv $t3, $t0, $t2	  #Shift x to the left by 1 after each iteration  
	add $t7, $t7, $t3	  #Add to current result 
notOne:	addi $t2, $t2, 1	  #increment Shift counter
	srl $t1, $t1, 1	 	  #Shift y to the right by one 
	j	Loop
outOfLoop:
	#print x
	add $v0, $zero, 1
	add $a0, $t5, $zero
	syscall
	
	#print multiply
	addi $v0, $zero, 4
	la $a0, multiply 
	syscall
	
	#print y
	add $v0, $zero, 1
	add $a0, $t6, $zero
	syscall
	
	#print equals
	addi $v0, $zero, 4
	la $a0, equals 
	syscall
	
	#print output
	add  $v0, $zero, 1
	add $a0, $t7, $zero
	syscall
	
	
	
