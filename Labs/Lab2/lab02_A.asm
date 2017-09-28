.data
firstnumberMsg: .asciiz "What is the first value?"
.text
	addi $v0, $zero, 4   
	la $a0, firstnumberMsg
	syscall

	addi $v0, $zero, 5
	syscall
	add $s2, $zero, $v0
	
.data
secondnumberMsg: .asciiz "What is the second value?"

.text
	addi $v0, $zero, 4
	la $a0, secondnumberMsg
	syscall

	addi $v0, $zero, 5
	syscall
	add $s3, $zero, $v0
	
	add $s4, $s2, $s3
	
.data
sumMsg: .asciiz "The sum of "

.text
	addi $v0, $zero, 4
	la $a0, sumMsg
	syscall
	
	addi $v0, $zero, 1
	add $a0, $zero, $s2
	syscall
	
.data
sum1Msg: .asciiz " and "

.text
	addi $v0, $zero, 4
	la $a0, sum1Msg
	syscall
	
	addi $v0, $zero, 1
	add $a0, $zero, $s3
	syscall
	
.data 
sum2Msg: .asciiz " is "

.text  
 	addi $v0, $zero, 4
	la $a0, sum2Msg
	syscall
	
	addi $v0, $zero, 1
	add $a0, $zero, $s4
	syscall
	
	addi $v0, $zero, 10