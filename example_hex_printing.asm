# $t0 loop counter
# $a0 hold the hex digit to analyze
# $t2 hold input number

	.data
prompt:
	.asciiz "Enter decimal: "
answer:
	.asciiz "Result is 0x"
comp:
	.asciiz "Again? y/n: "

	.text
main:
	la $a0,prompt  # Load prompt
	li $v0,4  # Set string output call value
	syscall	 # Call to print string
	
	li $v0,5
	syscall  # Call to get input integer
	
	move $t1,$v0  # Save the received integer
	
	la $a0,answer  # Load the prefix to the answer
	li $v0,4
	syscall  # Call to print string
	
	move $t0,$zero  # Clear the counter
	
	li $v0,11  # Set caracter output call value
	
elim:
	rol $t1,$t1,4  # Put left digit in right-most position
	
	and $a0,$t1,0xf  # Mask leftmost digit
	bgtz $a0,num  # If non-zero character, go to char converter
	addi $t0,$t0,1  # Character is zero, increment counter
	beq $0,8,zero  # If all 8 zeros, go to print trailing zero
	j elim  # Get next character

loop:
	rol $t1,$t1,4  # Rotate
	and $a0,$t1,0xf  # Mask left digit

num:
	ble $a0,9,conv  # Convert directly for 0-9
	addi $a0,$a0,7  # Add 7 for the letters

conv:
	add $a0,$a0,48  # Convert to ASCII
	syscall  # Output ASCII using preset $v0
	addi $t0,$t0,1  # Increment counter
	blt $t0,8,loop  # If not done, go back to the loop
	j next  # Else request next digit
	
zero:
	li $a0,0x30
	syscall  # Output zero character

next:
	li $a0,0x0a  # Carriage return after number completed
	syscall
	
	la $a0,comp  # Load repetition prompt
	li $v0,4  # Set string output call value
	syscall  # Display prompt
	
	li $v0,11 # Set character output call value
	li $a0,0x0a  # Carriage return char
	syscall # Output \cr
	
	li $v0,12  # Get character input
	syscall # Call
	
	beq $v0,0x79,main  # If got 'y', continue
	
	li $v0,10 # Else, call exit
	syscall
