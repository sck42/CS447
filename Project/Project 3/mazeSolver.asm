.data
	solution: .space 1000
.text 
	jal _leftHandRule			#Call left hand rule
	addi $t8, $zero, 2			#U-Turn 
	addi $t8, $zero, 2
	addi $a0, $v0, 0 			#Last index 
	jal _cleanSolution
	addi $a0, $v0, 0 
	jal _traceBack
	addi $t8, $zero, 2			#U-Turn 
	addi $t8, $zero, 2
	addi $a0, $zero, 0			#Pass in row = 0 
	addi $a1, $zero, 0			#Pass in Col = 0 
	addi $a2, $zero, 0			#Pass in pr = 0 
	addi $a3, $zero, -1			#Pass in pc = -1 
	jal _backTracking
	addi $v0, $zero, 10
	syscall
######################################################################################
#solution array has the path taken by the car
#$v0 = solution array final index 
######################################################################################
_leftHandRule: 
	addi $t8, $zero, 1
	addi $s3, $zero, 0 	#array index 
	addi $s4, $zero, 1	#store one in register
	addi $s5, $zero, 2	#store two in register 
	addi $s6, $zero, -1 	#Store negative 1 
	addi $s7, $zero, 0 	#NumPositions 
loop:	
	srl $s2, $t9, 16  
	sll $s2, $s2, 24
	srl $s2, $s2, 24 	#c 
	srl $s1, $t9, 24	#R
	bne $s1, 7, next
	beq $s2, 8, return
next:	andi $s0, $t9, 4
	beq $s0, 0, turnLeft
	andi $s0, $t9, 8
	beq $s0, 0, moveForward
	#if(leftwall & frontwall) then turn right
	loop1: bne $t8, 0, loop1
	addi $t8, $zero, 3			#TURN RIGHT 
	andi $s0, $t9, 8
	bne $s0, 0, loop1			#If there is a wall in front turn right again
	j	moveForward
	#if(leftwall & !frontwall) then move forward
moveForward: 
	loop3: bne $t8, $zero, loop3
	addi $t8, $zero, 1 
	sw $s1, solution($s3)			#Store current Row
	addi $s3, $s3, 4
	sw $s2, solution($s3)			#Store current column 
	addi $s3, $s3, 4
	j	loop
turnLeft: 
	#if(!leftwall) then turn left 
	loop4: bne $t8, $zero, loop4
	addi $t8, $zero, 2 			#TURN LEFT 
	j	moveForward
return:	sw $s1, solution($s3)			
	addi $s3, $s3, 4
	sw $s2, solution($s3)
	addi $v0, $s3, 0
	jr	$ra 
#########################################################################################################
#a0 = old last index 
#v0 = new last index 
########################################################################################################
_cleanSolution:
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp) 
	sw $s5, 24($sp) 
	sw $s6, 28($sp) 
	
	addi $s0, $zero, 0 	#current row
	addi $s1, $zero, 0 	#current column
	addi $s2, $zero, 0	#array index 
	add  $s3, $zero, $a0	#end of array 
	addi $s4, $zero, 0 	#row to check
	addi $s5, $zero, 0 	#column to check 
	addi $s6, $s3, 0 	#Temp 
	CleanLoop:  	
			lw $s0, solution($s2)
			addi $s2, $s2, 4 
			lw $s1, solution($s2)
		 	addi $s3, $s6, 0 
		 	bne $s0, 7, small
		 	beq $s1, 8, exit 		#Found the last entry 
		small: 	lw $s5, solution($s3) 		#Store the last element in the array into column
			bne $s5, $s1, skip		#if the columns don't match jump to next 
			subi $s3, $s3, 4 		#If they match check the rows
			lw $s4, solution($s3)
			addi $s3, $s3, 4 
			bne $s3, $s2, some 		#if the indexes are the same means we are back where we started. move to next set 
			addi $s2, $s2, 4 
			j	CleanLoop
		some:	beq $s4, $s0, foundDuplicate 	#if rows match duplicate is found. jump to duplicate
		skip: 	subi $s3, $s3, 8		#Check the next column 
			j	small
		foundDuplicate: 
				addi $a0, $s2, 0	#Current column index 
				addi $a1, $s3, 0	#Duplicate colunm index
				addi $a2, $s6, 0 	#pass in numpositions 
				jal	remove
				addi $s6, $v0, 0 	#Set numPositions 
				addi $s2, $s2, 4 
				j	CleanLoop 
exit: 	addi $v0, $s6, 0 				#Return new last index 
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp) 
	lw $s5, 24($sp) 
	lw $s6, 28($sp) 
	addi $sp, $sp, 32
	jr	$ra
#########################################################################################################
#a0 = first occurrence   
#a1 = second occurrence 
#a2 = Last index  
#Returns new last index  
#########################################################################################################
remove: 
	addi $t0, $a0, 4	#rowOfFirstToBeDeleted 
	addi $t1, $a1, 4	#rowAfterSecondOccurrence 
	addi $t2, $a2, 0 	#ArrayEnd 
	addi $t3, $zero, 0 	#temp
	while:  slt $t5, $t2, $t1  
		beq $t5, 1, leave
		lw $t3, solution($t1)
		sw $t3, solution($t0)
		addi $t1, $t1, 4
		addi $t0, $t0, 4 
		j	while
leave:	addi $v0, $t0, -4 
	jr	$ra 
##########################################################################################################
#a0 = lastIndex 
##########################################################################################################
_traceBack: 
	addi $sp, $sp, -28
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp) 
	sw $s5, 24($sp) 
	
	addi $s2, $a0, 0 	#index 
	addi $s3, $zero, 0 	#arrayRow
	addi $s4, $zero, 0 	#arrayCol 
tLoop:	
	srl $s1, $t9, 16  
	andi $s1, $s1, 255	#c
	srl $s0, $t9, 24	#r
	bne $s0, 0, skipCol		#Check if row = 0 
	beq $s1, 0, quit 		#If row = 0 check that col = 0 
skipCol: 
	lw $s4, solution($s2)
	slt $s5, $s4, $s1 		#if current postion is greater than array col move West
	beq $s5, 1, moveWestT
	slt $s5, $s1, $s4		#if current postion is less than array col move East
	beq $s5, 1, moveEastT
	subi $s2, $s2, 4		#if both col are the same then decrement array index and try rows
	lw $s3, solution($s2)
	slt $s5, $s3, $s0		#if current postion is greater than array row move North
	beq $s5, 1, moveNorthT
	slt $s5, $s0, $s3		#if current postion is less than array row move south. 
	beq $s5, 1, moveSouthT		
	subi $s2, $s2, 4 		#if both row and col are the same then decrement array index
	j	tLoop
moveWestT: 
	addi $a0, $zero, 4
	jal 	moveCar
	subi $s2, $s2, 8
	j	tLoop
moveEastT: 
	addi $a0, $zero, 2
	jal 	moveCar
	subi $s2, $s2, 8
	j	tLoop
moveNorthT:
	addi $a0, $zero, 1 
	jal 	moveCar
	subi $s2, $s2, 4 
	j	tLoop
moveSouthT: 
	addi $a0, $zero, 3
	jal 	moveCar
	subi $s2, $s2, 4 
	j	tLoop
quit: 
	addi $a0, $zero, 4		#End lefthandrule by moving the car out of the maze to row 7 col 8
	jal	moveCar
	lw $ra, ($sp)			#Restore all variables. 
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp) 
	lw $s5, 24($sp) 
	addi $sp, $sp, 28
	jr 	$ra 
############################################################################################################
_backTracking:
	addi $sp, $sp, -24
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	addi $s0, $a0, 0		#r
	addi $s1, $a1, 0		#c
	addi $s2, $a2, 0		#pr
	addi $s3, $a3, 0		#pc
	addi $s4, $zero, 0 		#temp 
	bne $s0, 7, northWall		#r = height - 1
	beq $s1, 9, returnTrue		#c = width - 1
northWall:
	addi $a0, $s0, 0		#r
	addi $a1, $s1, 0		#c
	jal	isNorthWall
	beq $v0, 1, westWall		#!isNorthWall(r, c)
	subi $s4, $s0, 1		#r - 1 
	beq $s4, $s2, westWall		#&& r - 1 != pr
	#move car North
	addi $a0, $zero, 1
	jal	moveCar
	addi $a0, $s4, 0		#r = r -1 
	addi $a1, $s1, 0		#c = c
	addi $a2, $s0, 0		#pr = r
	addi $a3, $s1, 0		#pc = c
	jal _backTracking		#solveMaze(r - 1, c, r, c)
	beq $v0, 1, returnTrue
	#Move car back. 
	addi $a0, $zero, 3		#north failed so move back and try west 
	jal	moveCar
westWall:
	addi $a0, $s0, 0		#r
	addi $a1, $s1, 0		#c
	jal	isWestWall		#!isWestWall(r,c)
	beq $v0, 1, southWall
	subi $s4, $s1, 1		#c - 1
	beq $s4, $s3, southWall		#&& c-1 != pc
	#move car West
	addi $a0, $zero, 4		#Move west 
	jal	moveCar
	addi $a0, $s0, 0		#r =  r
	addi $a1, $s4, 0		#c = c - 1
	addi $a2, $s0, 0		#pr = r 
	addi $a3, $s1, 0		#pc = c
	jal _backTracking		#solveMaze(r, c -1, r, c)
	beq $v0, 1, returnTrue
	#Move car back.
	addi $a0, $zero, 2		#If west fails move east and try south 
	jal	moveCar
southWall: 
	addi $a0, $s0, 0		#r
	addi $a1, $s1, 0		#c
	jal	isSouthWall		#!isSouthWall(r,c) 
	beq $v0, 1, eastWall
	addi $s4, $s0, 1		#r + 1
	beq $s4, $s2, eastWall		# && r+1 != pr
	#Move car south
	addi $a0, $zero, 3		#move south if there isn't a south fall and r + 1 doesn't eqaul pr
	jal	moveCar
	addi $a0, $s4, 0		#r = r + 1
	addi $a1, $s1, 0		#c = c
	addi $a2, $s0, 0		#pr = r
	addi $a3, $s1, 0		#pc = c
	jal _backTracking		#solveMaze(r + 1, c, r, c)
	beq $v0, 1, returnTrue
	#Move car back
	addi $a0, $zero, 1		#if south fails move back and try east 
	jal 	moveCar
eastWall: 
	addi $a0, $s0, 0		#r
	addi $a1, $s1, 0		#c
	jal	isEastWall		#!isEastWall(r,c)
	beq $v0, 1, returnFalse
	addi $s4, $s1, 1		#c + 1
	beq $s4, $s3, returnFalse 	#c+1 = pc
	#move car East
	addi $a0, $zero, 2		#move east if there isn't an east wall and c + 1 doesn't equal pc 
	jal	moveCar
	addi $a0, $s0, 0		#r = r
	addi $a1, $s4, 0		#c = c + 1
	addi $a2, $s0, 0		#pr = r
	addi $a3, $s1, 0		#pc = c 
	jal _backTracking
	beq $v0, 1, returnTrue
	#Move car back.
	addi $a0, $zero, 4		#if east fails move back and then all solutions fails so return false 
	jal	moveCar
returnFalse: 
	addi $v0, $zero, 0 
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	jr	$ra 
returnTrue: 
	addi $v0, $zero, 1 
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	jr	$ra 
#####################################################################################
# v0 = 1 if northWall is present and 0 if no northWall
#####################################################################################
isNorthWall:
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp) 
	jal	checkFacing
	beq $v0, 1, northFacingN
	beq $v0, 2, eastFacingN
	beq $v0, 3, southFacingN
	beq $v0, 4, westFacingN 
northFacingN: 	
	andi $s0, $t9, 8
	beq $s0, 8, returnT
	j	returnF
eastFacingN:
	andi $s0, $t9, 4
	beq $s0, 4, returnT
	j	returnF
southFacingN:
	andi $s0, $t9, 1
	beq $s0, 1, returnT
	j	returnF
westFacingN: 
	andi $s0, $t9, 2
	beq $s0, 2, returnT
	j	returnF
returnT:
	addi $v0, $zero, 1 
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
returnF:
	addi $v0, $zero, 0 
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
#############################################################################################
# v0 = 1 if eastWall is present and 0 if no eastWall
#############################################################################################
isEastWall:
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp) 
	jal	checkFacing
	beq $v0, 1, northFacingE
	beq $v0, 2, eastFacingE
	beq $v0, 3, southFacingE
	beq $v0, 4, westFacingE 
northFacingE: 	
	andi $s0, $t9, 2
	beq $s0, 2, returnTE
	j	returnFE
eastFacingE:
	andi $s0, $t9, 8
	beq $s0, 8, returnTE
	j	returnFE
southFacingE:
	andi $s0, $t9, 4
	beq $s0, 4, returnTE
	j	returnFE
westFacingE: 
	andi $s0, $t9, 1
	beq $s0, 1, returnTE
	j	returnFE
returnTE:
	addi $v0, $zero, 1 
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
returnFE:
	addi $v0, $zero, 0 
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
#####################################################################################################
# v0 = 1 if southWall is present and 0 if no southWall
#####################################################################################################
isSouthWall:
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp) 
	jal	checkFacing
	beq $v0, 1, northFacingS
	beq $v0, 2, eastFacingS
	beq $v0, 3, southFacingS
	beq $v0, 4, westFacingS
northFacingS: 	
	andi $s0, $t9, 1
	beq $s0, 1, returnTS
	j	returnFS
eastFacingS:
	andi $s0, $t9, 2
	beq $s0, 2, returnTS
	j	returnFS
southFacingS:
	andi $s0, $t9, 8
	beq $s0, 8, returnTS
	j	returnFS
westFacingS: 
	andi $s0, $t9, 4
	beq $s0, 4, returnTS
	j	returnFS
returnTS:
	addi $v0, $zero, 1
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
returnFS:
	addi $v0, $zero, 0 
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
#######################################################################################################
# v0 = 1 if westWall is present and 0 if no westWall
#######################################################################################################
isWestWall: 
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp) 
	
	jal	checkFacing
	beq $v0, 1, northFacingW
	beq $v0, 2, eastFacingW
	beq $v0, 3, southFacingW
	beq $v0, 4, westFacingW 
northFacingW: 	
	andi $s0, $t9, 4
	beq $s0, 4, returnTW
	j	returnFW	
eastFacingW:
	andi $s0, $t9, 1
	beq $s0, 1, returnTW
	j	returnFW		
southFacingW:
	andi $s0, $t9, 2
	beq $s0, 2, returnTW
	j	returnFW		
westFacingW: 
	andi $s0, $t9, 8
	beq $s0, 8, returnTW
	j	returnFW
returnTW:
	addi $v0, $zero, 1 
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
returnFW:
	addi $v0, $zero, 0 
	lw $ra, ($sp)
	lw $s0, 4($sp) 
	addi $sp, $sp, 8
	jr 	$ra
#########################################################################################################
#Returns the direction the car is facing 
#$v0 = 1 north facing
#$v0 = 2 east facing
#$v0 = 3 south facing 
#$v0 = 4 west facing 
#########################################################################################################
checkFacing:
	andi $t0, $t9, 2048				
	beq $t0, 2048, northFacing1
	andi $t0, $t9, 1024
	beq $t0, 1024, eastFacing1
	andi $t0, $t9, 512
	beq $t0, 512, southFacing1
	andi $t0, $t9, 256
	beq $t0, 256, westFacing1
northFacing1:
	addi $v0, $zero, 1
	jr	$ra
eastFacing1: 
	addi $v0, $zero, 2
	jr	$ra
southFacing1: 
	addi $v0, $zero, 3
	jr 	$ra
westFacing1: 
	addi $v0, $zero, 4
	jr	$ra
###############################################################################################
#$a0 = the desired direction of movement 
#a0 = 1 move north
#a0 = 2 move east 
#a0 = 3 move south 
#a0 = 4 move west
###############################################################################################
moveCar: 
	addi $sp, $sp, -4
	sw $ra, ($sp) 
	jal	checkFacing
	beq $v0, 1, northFacingM
	beq $v0, 2, eastFacingM
	beq $v0, 3, southFacingM
	beq $v0, 4, westFacingM
#Move while north facing 
northFacingM:
	beq $a0, 1, moveNorthN
	beq $a0, 2, moveEastN
	beq $a0, 3, moveSouthN
	beq $a0, 4, moveWestN
moveNorthN: 
	loopN: bne $t8, 0, loopN
	addi $t8, $zero, 1 
	j	done
moveEastN: 
	loopE: bne $t8, 0, loopE
	addi $t8, $zero, 3		
	addi $t8, $zero, 1 
	j	done
moveSouthN: 
	loopS: bne $t8, 0, loopS
	addi $t8, $zero, 3
	addi $t8, $zero, 3
	addi $t8, $zero, 1 
	j	done
moveWestN: 
	loopW: bne $t8, 0, loopW
	addi $t8, $zero, 2
	addi $t8, $zero, 1 
	j	done
#Move while east facing 
eastFacingM: 
	beq $a0, 1, moveNorthE
	beq $a0, 2, moveEastE
	beq $a0, 3, moveSouthE
	beq $a0, 4, moveWestE
moveNorthE: 
	loopEN: bne $t8, 0, loopEN
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	j	done
moveEastE: 
	loopEE: bne $t8, 0, loopEE
	addi $t8, $zero, 1 
	j	done
moveSouthE: 
	loopES: bne $t8, 0, loopES
	addi $t8, $zero, 3		
	addi $t8, $zero, 1 
	j	done
moveWestE: 
	loopEW: bne $t8, 0, loopEW
	addi $t8, $zero, 3
	addi $t8, $zero, 3
	addi $t8, $zero, 1 
	j	done
#move while south facing 
southFacingM:
	beq $a0, 1, moveNorthS
	beq $a0, 2, moveEastS
	beq $a0, 3, moveSouthS
	beq $a0, 4, moveWestS
moveNorthS: 
	loopSN: bne $t8, 0, loopSN
	addi $t8, $zero, 3
	addi $t8, $zero, 3
	addi $t8, $zero, 1 
	j	done
moveEastS: 
	loopSE: bne $t8, 0, loopSE
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	j	done
moveSouthS: 
	loopSS: bne $t8, 0, loopSS
	addi $t8, $zero, 1
	j	done
moveWestS: 
	loopSW: bne $t8, 0, loopSW
	addi $t8, $zero, 3		
	addi $t8, $zero, 1 
	j	done
#move while west facing 
westFacingM:
	beq $a0, 1, moveNorthW
	beq $a0, 2, moveEastW
	beq $a0, 3, moveSouthW
	beq $a0, 4, moveWestW
moveNorthW: 
	loopWN: bne $t8, 0, loopWN
	addi $t8, $zero, 3		
	addi $t8, $zero, 1 
	j	done
moveEastW: 
	loopWE: bne $t8, 0, loopWE
	addi $t8, $zero, 3
	addi $t8, $zero, 3
	addi $t8, $zero, 1 
	j	done
moveSouthW: 
	loopWS: bne $t8, 0, loopWS
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	j	done
moveWestW: 
	loopWW: bne $t8, 0, loopWW
	addi $t8, $zero, 1
	j	done
done:	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr 	$ra
