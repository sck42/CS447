.text
# $t9 = 179 +(-293) + 561
top_of_loop: addi $t1, $zero, 0
addi $v0, $zero, 32 # request the sleep syscall
addi $a0, $zero, 500 # delay amount is 500 ms
syscall # perform the syscall (sleep for 500 ms)

addi $t9, $zero, 0
addi $v0, $zero, 32 # request the sleep syscall
addi $a0, $zero, 500 # delay amount is 500 ms
syscall # perform the syscall (sleep for 500 ms)

addi $t9, $t9, -293
addi $v0, $zero, 32 # request the sleep syscall
addi $a0, $zero, 500 # delay amount is 500 ms
syscall # perform the syscall (sleep for 500 ms)

addi $t9, $t9, 561
addi $v0, $zero, 32 # request the sleep syscall
addi $a0, $zero, 500 # delay amount is 500 ms
syscall # perform the syscall (sleep for 500 ms)

j top_of_loop
addi $v0, $zero, 32 # request the sleep syscall
addi $a0, $zero, 500 # delay amount is 500 ms
syscall # perform the syscall (sleep for 500 ms)