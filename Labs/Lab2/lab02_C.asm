#Sai Konduru 

#Store each ascii character value. 	
#R
add $t1, $zero, 82
#P
add $t2, $zero, 80
#S
add $t3, $zero, 83
#Q
add $t4, $zero, 81

#Create the RNG
addi $v0, $zero, 40 
add $a0, $zero, 0 
add $a1, $zero, 2
	
Loop: 
	#User picks his move. 
	.data
	prompt1Msg: .asciiz "Make a move (R, P, S, Q): "
	
	.text
		addi $v0, $zero, 4   
		la $a0, prompt1Msg
		syscall
		
		addi $v0, $zero, 12
		syscall
		add $s0, $zero, $v0
		
	#Computer randomly picks one of the three options
	addi $v0, $zero, 42
	add $a0, $zero, 0 
	add $a1, $zero, 3
	syscall 
	add $t5, $zero, $a0
	
	#if they picked rock. 
	beq $s0, $t1, rock
	#if they picked paper
	beq $s0, $t2, paper
	#if they picked scissor
	beq $s0, $t3, scissor 
	#if they picked quit
	beq $s0, $t4, quit
rock: 	
	beq $t5,  0, tie
	beq $t5, 1, loss
	beq $t5, 2, won
paper:

	beq $t5,  0, won
	beq $t5, 1, tie
	beq $t5, 2, loss
scissor:
	beq $t5,  0, loss
	beq $t5, 1, won
	beq $t5, 2, tie
tie: 
	.data
	tieMsg: .asciiz "TIE!"
	spaceMsg: .asciiz "\n"
	.text
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		addi $v0, $zero, 4   
		la $a0, tieMsg
		syscall
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		j	Loop 
loss: 

	.data
	lossMsg: .asciiz "You lost, Good luck next time"
	.text 
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		addi $v0, $zero, 4
		la $a0, lossMsg
		syscall
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		j	Loop
won: 
	.data
	winMsg: .asciiz "You Won, Congratulations"
	.text 
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		addi $v0, $zero, 4
		la $a0, winMsg
		syscall
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		addi $v0, $zero, 4   
		la $a0, spaceMsg
		syscall
		j	Loop

quit: 
	addi $v0 ,$zero, 10 
	syscall
