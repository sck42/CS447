addi $t0, $zero, 0 #Counter 
addi $t1, $zero, 0 #temp
addi $t2, $zero, 0 #Multiplicand
addi $t3, $zero, 0 #Multiplier
addi $t4, $zero, 0 #temp
addi $t7, $zero, 0 #Operator

addi $s0, $zero, 0 #temp
addi $s1, $zero, 0 #Multi return 
addi $v0, $zero, 0 #return 
State0:
	addi $t5, $zero, 0 #Operand 1 
	addi $t6, $zero, 0 #Operand 2
	addi $t9, $zero, 0 #buttons 
	add $t8, $zero, $t5 #Display
	j	State1
State1:
	s1Loop: beq $t9, $zero, s1Loop
		andi $t9, $t9, 31
		beq $t9, 10, dDone
		beq $t9, 11, dDone
		beq $t9, 12, dDone
		beq $t9, 13, dDone
		beq $t9, 14, dDone 
		beq $t9, 15, Clear

		#Multiply by 10
		add $t1, $zero, $t5
		add $t2, $zero, $t5
		sll $t1, $t1, 3
		add $t5, $t5, $t1
		add $t5, $t5, $t2
		
		add $t5, $t5, $t9
		add $t8, $zero, $t5
		add $t9, $zero, $zero
		j	s1Loop
	dDone:  add $t8, $zero, $t5
		beq $t9, 14, Result 
		j	State2
State2: add $t7, $zero, $t9
	addi $t9, $zero, 0
	s2Loop: beq $t9, $zero, s2Loop
		andi $t9, $t9, 31
		beq $t9, 10, s2Done
		beq $t9, 11, s2Done
		beq $t9, 12, s2Done
		beq $t9, 13, s2Done
		beq $t9, 14, s2Done 
		beq $t9, 15, Clear

		#Multiply by 10
		add $t1, $zero, $t6
		add $t2, $zero, $t6
		sll $t1, $t1, 3
		add $t6, $t6, $t1
		add $t6, $t6, $t2
		
		add $t6, $t6, $t9
		add $t8, $zero, $t6
		add $t9, $zero, $zero
		j	s2Loop
	s2Done:	add $t8, $zero, $t6
		j	State3
State3: add $t7, $zero, $t9
	addi $t9, $zero, 0
	s3Loop: beq $t9, $zero, s3Loop
		andi $t9, $t9, 31
		beq $t9, 10, s3Done
		beq $t9, 11, s3Done
		beq $t9, 12, s3Done
		beq $t9, 13, s3Done
		beq $t9, 14, s3Done 
		beq $t9, 15, Clear

		#Multiply by 10
		add $t1, $zero, $t6
		add $t2, $zero, $t6
		sll $t1, $t1, 3
		add $t6, $t6, $t1
		add $t6, $t6, $t2
		
		add $t6, $t6, $t9
		add $t8, $zero, $t6
		add $t9, $zero, $zero
		j	s3Loop
	s3Done:	add $t8, $zero, $t6
		j	Result
Result: 
	beq $t7, 10, Add
	beq $t7, 11, Sub
	beq $t7, 12, Multi
	beq $t7, 13, Divid
	beq $t7, 14, Equals
	Add: add $t5, $t5, $t6
		add $t8, $zero, $t5 
		add $t6, $zero, $zero
		beq $t9, 10, State3
		beq $t9, 11, State3
		beq $t9, 12, State3
		beq $t9, 13, State3
	Sub: sub $t5, $t5, $t6
		add $t8, $zero, $t5
		add $t6, $zero, $zero
		beq $t9, 10, State3
		beq $t9, 11, State3
		beq $t9, 12, State3
		beq $t9, 13, State3
	Multi: add $t0, $zero, $zero
		mLoop: slt $t1, $t0, $t6
			beq $t1, $zero, nDone
			add $s1, $s1, $t5
			addi $t0, $t0, 1
			j	mLoop
		nDone: add $t8, $zero, $s1
			add $t5, $zero, $s1
			add $t6, $zero, $zero
			beq $t9, 10, State3
			beq $t9, 11, State3
			beq $t9, 12, State3
			beq $t9, 13, State3
	
	Divid:
			beq $t9, 10, State3
			beq $t9, 11, State3
			beq $t9, 12, State3
			beq $t9, 13, State3
	Equals: add $t8, $zero, $t5
Clear: j	State0
