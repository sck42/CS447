#Sai Konduru 
.data 
	sequence: .space 200 
	
.text
	addi $t0, $zero, 1 			#numCalls = 1
	addi $t1, $zero, -1			#Store -1 
	addi $s0, $zero, 0			#Index
	addi $t2, $zero, 0			#counter 
	la $a1, sequence 			#Array
startLoop:
	addi $t9, $zero, 0			#Keep Looping until Start game is pushed 
	bne $t9, 16, startLoop
	addi $t8, $zero, 16			#Play start game sound and disable Start game Button 
sLoop:	bne $t8, $zero, sLoop

loop:
	add $a0, $zero, $t0			#Pass in numcalls 
	jal	_playSequence			#Play the sequence 
	la $a1, sequence
	addi $t2, $zero, 0 
	Increment: 
		beq $t2, $s0, Incrementdone 
		addi $a1, $a1, 4
		addi $t2, $t2, 1 
		j	Increment 
Incrementdone: 	sw  $v0, 0($a1)  		#Add the new sequence to the end
		addi $a1, $a1, 4
		addi $s0, $s0, 1 
		sw  $t1, 0($a1)
	
	add $a0, $zero, $t0			#Pass in numcalls 
	la $a1, sequence
	jal	_userPlay			#Let user play 
	addi $t0, $t0, 1			#numCalls++
	beq $v0, 0, reset			#If user inputs wrong color leave loop. 
	j	loop
	
reset:	addi $t8, $zero, 15			#play game over sound and enable start game 
eLoop:	bne $t8, $zero, eLoop
	addi $t0, $zero, 1 			#Reset variables 
	addi $t1, $zero, -1
	addi $t3, $zero, 3
	addi $s0, $zero, 0
	j	startLoop			#Jump back to startLoop  

###############################################
#$a0 has the number of calls 
_playSequence: 
	addi $sp, $sp, -24			#Save to stack 
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	addi $s0, $a0, 0			#s0 = a0 
	addi $s1, $zero, 1			#s1 = 1
	beq $s0, $s1, nextColor			#If first call jump to nextColor 
	la $s2, ($a1)				#s2 is the Array 
	addi $s3, $zero, 0 			#Index 
	addi $s1, $zero, -1			#s1 = -1 
loop1:	
	lw $s3, 0($s2)   			#a0 = sequence[index] 
	beq $s3, $s1, done1			#if a0 = -1 jump to done1 
	add  $a0, $zero, $s3
	jal	_makeNoise			#Make the noise 
	addi $s2, $s2, 4			#increment index
	j	loop1
done1: 	
nextColor: 
	
	addi $v0, $zero, 42			#Generate a random number from 0 to 4 exclusive 
	addi $a0, $zero, 0
	addi $a1, $zero, 4
	syscall 
	jal 	_makeNoise			#Make the noise 
	addi $v0, $a0, 0			#Set v0 to the newest color 
	lw $ra, ($sp)				#Restore all the variables 
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24			#free everthing in the stack 
	jr 	$ra
#################################################
#Allows user to input his sequence 
# a0 contains the number of colors in sequence. 
# v0 contains if user matched the color
_userPlay:
	addi $sp, $sp, -20			#Save to the stack 
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp) 
	
	addi $t9, $zero, 0 			#Set t9 to 0 
	add $s0, $zero, $a0			#s0 is the number of colors, counter 
	addi $s2, $zero, 0			#Index
	la $s3, ($a1)
uLoop: 
	beq $t9, $zero, uLoop 			#Keep looping until a color is pushed 
	add $a0, $zero, $t9			#Make noise 
	jal	_makeNoiseUser	
	lw $s1, 0($s3)  			#Compare the selected color to the once in the sequence 
	beq $s1, 0, blueSet 
	beq $s1, 1, yellowSet
	beq $s1, 2, greenSet
	beq $s1, 3, redSet
return:	addi $s3, $s3, 4 			#increment index 
	addi $s0, $s0, -1			#Decrement counter 
	beq $s0, 0, uDone			#leave loop after counter equals 0 
	bne $t9, $s1, notEqual			#If the selected color is not equal leave loop 
	addi $t9, $zero, 0
	j	uLoop

blueSet: addi $s1, $zero, 1
	j	return 
yellowSet: addi $s1, $zero, 2
	j	return
greenSet: addi $s1, $zero, 4
	j	return
redSet: addi $s1, $zero, 8
	j	return
	
uDone:	addi $v0, $zero, 1			#Set v0 to 1 
	lw $ra, ($sp)				#Restore and free stack 
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr	$ra
notEqual: 
	addi $v0, $zero, 0			#Set v0 to 0 
	lw $ra, ($sp)				#Restore and free stack 
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp) 
	addi $sp, $sp, 20
	jr $ra
#############################################
#Makes the noise for the cpu
#$a0 has the color 
_makeNoise:
	beq $a0, 0, blue 
	beq $a0, 1, yellow
	beq $a0, 2, green 
	beq $a0, 3, red
	blue: addi $t8, $zero, 1
	bloop: bne $t8, $zero, bloop
	jr	$ra
	yellow: addi $t8, $zero, 2
	yloop: bne $t8, $zero, yloop
	jr	$ra
	green: addi $t8, $zero, 4
	gloop: bne $t8, $zero, gloop
	jr 	$ra	 
	red: addi $t8, $zero, 8
	rloop: bne $t8, $zero, rloop
	jr	$ra 
##############################################
#Makes the noise for user input
#$a0 has the color 
_makeNoiseUser:
	beq $a0, 1, blue 
	beq $a0, 2, yellow
	beq $a0, 4, green 
	beq $a0, 8, red
	blue1: addi $t8, $zero, 1
	bloop1: bne $t8, $zero, bloop1
	jr	$ra
	yellow1: addi $t8, $zero, 2
	yloop1: bne $t8, $zero, yloop1
	jr	$ra
	green1: addi $t8, $zero, 4
	gloop1: bne $t8, $zero, gloop1
	jr	$ra
	red1: addi $t8, $zero, 8
	rloop1: bne $t8, $zero, rloop1
	jr	$ra 
	
	
	
