#Sai Konduru
.data
prompt: .asciiz "Please enter your integer: "
prompt2: .asciiz "Here is the output: "
.text
	#print first instruction
	addi $v0, $zero, 4
	la $a0, prompt 
	syscall
	 #take and store integer given by user. 
	addi $v0, $zero, 5
	syscall
	add $t0, $zero, $v0
	
	srl $t1, $t0, 15 #shift to the right by 15 
	andi $t1, $t1, 7 #add with 7 to keep the LSB
	
	#print second instruction
	addi $v0, $zero, 4
	la $a0, prompt2 
	syscall
	
	#print output
	add  $v0, $zero, 1
	add $a0, $t1, $zero
	syscall
	
