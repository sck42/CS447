#Sai Konduru

.text
addi $t0, $zero, 0 			#Counter/Divid return
addi $t1, $zero, 0 			#temp
addi $t2, $zero, 0			#Multiplicand
addi $t3, $zero, 0 			#Multiplier
addi $t4, $zero, 0 			#temp
addi $s0, $zero, 0 			#temp
addi $s1, $zero, 0 			#Multi return 
addi $s2, $zero, 0 			#temp

State0:
	addi $t5, $zero, 0 		#Operand 1 
	addi $t6, $zero, 0 		#Operand 2
	addi $t7, $zero, 0 		#Operator
	add $t8, $zero, $t5 		#Display
	addi $t9, $zero, 0 		#buttons 
	j	State1
State1:
	s1Loop: 
		beq $t9, $zero, s1Loop  #Loop until something other than zero is pushed
		andi $t9, $t9, 31	#determine what button was pushed 
		beq $t9, 10, s1Done	#if operator was pushed leave loop. 
		beq $t9, 11, s1Done
		beq $t9, 12, s1Done
		beq $t9, 13, s1Done
		beq $t9, 14, Result 
		beq $t9, 15, Clear 

		add $t1, $zero, $t5	#Multiply by 10
		add $t2, $zero, $t5
		sll $t1, $t1, 3
		add $t5, $t5, $t1
		add $t5, $t5, $t2
		
		add $t5, $t5, $t9	#Operand1 = (operand1 * 10) + input
		add $t8, $zero, $t5	#Display
		add $t9, $zero, $zero	#reset t9
		j	s1Loop
	s1Done: 
		add $t8, $zero, $t5	#Display
		j	State2
State2: 
		add $t7, $zero, $t9	#Save operator
		add $t8, $zero, $t5	#Display
		addi $t9, $zero, 0	#reset t9
	s2Loop: 
		beq $t9, $zero, s2Loop	#Same as State 1
		andi $t9, $t9, 31	
		beq $t9, 10, State2	#Keep looping until User starts to input next operand.
		beq $t9, 11, State2
		beq $t9, 12, State2
		beq $t9, 13, State2
		beq $t9, 14, Result 
		beq $t9, 15, Clear
		
		add $t6, $t6, $t9	#Save the first digit
		add $t8, $zero, $t6	#Display 
		add $t9, $zero, $zero	#Reset t9
		j	State3
State3: 	
		addi $t9, $zero, 0	#Reset t9
	s3Loop: 
		beq $t9, $zero, s3Loop	#Same as before 
		andi $t9, $t9, 31
		beq $t9, 10, s3Done	#if operator was pushed leave loop.
		beq $t9, 11, s3Done
		beq $t9, 12, s3Done
		beq $t9, 13, s3Done
		beq $t9, 14, s3Done 
		beq $t9, 15, Clear

		add $t1, $zero, $t6	#Multiply by 10
		add $t2, $zero, $t6
		sll $t1, $t1, 3
		add $t6, $t6, $t1
		add $t6, $t6, $t2
		
		add $t6, $t6, $t9	#Operand2 = (Operand2 * 10) + input
		add $t8, $zero, $t6	#Display
		add $t9, $zero, $zero	#Reset
		j	State3
	s3Done:	
		add $t8, $zero, $t6
		j	Result
Result: 	
		beq $t7, 10, Add	#Jump to the right operation based on operator. 
		beq $t7, 11, Sub
		beq $t7, 12, Multi
		beq $t7, 13, Divid
		beq $t7, 14, Equals
	Add: 	
		add $t5, $t5, $t6	#Add, Display, reset operand2 and store result in t5
		add $t8, $zero, $t5 
		add $t6, $zero, $zero
		beq $t9, 10, State2	#Jump back to state 2 if user pressed an operand last 
		beq $t9, 11, State2
		beq $t9, 12, State2
		beq $t9, 13, State2
		beq $t9, 14, Equals	#Jump to Equals if user pressed equals 
	Sub: 	
		sub $t5, $t5, $t6	#Subtract, Display, reset operand2 and store result in t5
		add $t8, $zero, $t5
		add $t6, $zero, $zero
		beq $t9, 10, State2
		beq $t9, 11, State2
		beq $t9, 12, State2
		beq $t9, 13, State2
		beq $t9, 14, Equals 
	Multi: 	
		addi $t0, $zero, 0
		addi $t1, $zero, 0 
		addi $s1, $zero, 0
		mLoop: 	
			slt $t1, $t0, $t6	 
			beq $t1, 0, mDone
			add $s1, $s1, $t5
			addi $t0, $t0, 1
			add $t4, $zero, $s1
			j	mLoop
		mDone: 	
			add $t8, $zero, $t4	#Multiply, Display, reset operand2 and store result in t5
			add $t5, $zero, $t4
			add $t6, $zero, $zero
			beq $t9, 10, State2
			beq $t9, 11, State2
			beq $t9, 12, State2
			beq $t9, 13, State2
			beq $t9, 14, Equals
	Divid: 	
		addi $t0, $zero, 0
		addi $t1, $zero, 0
		addi $s0, $t5, 0
		dLoop: 	
			sle $t1, $t6, $s0  	
			beq $t1, 0, dDone
			sub $s0, $s0, $t6 
			addi $t0, $t0, 1
			add $s2, $zero, $t0
			j	dLoop
		dDone: 	
			add $t8, $zero, $s2	#Divid, Display, reset operand2 and store result in t5
			add $t5, $zero, $s2
			add $t6, $zero, $zero
			beq $t9, 10, State2
			beq $t9, 11, State2
			beq $t9, 12, State2
			beq $t9, 13, State2
			beq $t9, 14, Equals
	Equals: 
		add $t8, $zero, $t5	#Display answer
		j	State4
State4: 	
		addi $t9, $zero, 0	#Reset t9
	s4Loop: 
		beq $t9, $zero, s4Loop	#Loop until something other than zero is pushed
		andi $t9, $t9, 31
		beq $t9, 10, State2
		beq $t9, 11, State2
		beq $t9, 12, State2
		beq $t9, 13, State2
		beq $t9, 14, Result
		beq $t9, 15, Clear
		addi $t5, $zero, 0	#Reset t5 if new number is pushed 
		add $t8, $zero, $t9	#Display new number. 
		j	State1	
Clear: 
	j	State0
