###################
# Tahsin Emre Sen
###################

############################################
# Data Segment
# messages
############################################  

.data
input_msg: .asciiz	"Enter integer (from -2^31 + 1 to 2^31 - 1): "
output_msg: .asciiz "The integer is: "
int_str: .space 48
int:    .space 4

############################################
# Text Segment
# routines
############################################  
############################################
# Main Routine 		   	
############################################  
.text
main:
	la	$a0, input_msg		#load adress input
	jal	print_str		# print_str method
	
		
	jal	read_int		# read the input
	add	$a0, $zero, $v0		#a0 = $zero + v0 
        la	$a1, int_str		# load the space for the first string into register
	# $a0 contains the integer  
	jal	toString
	
	# print integer a string.
	la	$a0, int_str
	jal	print_str
	addi	$a0, $zero, '\n'	# print a newline
	j	exit			# exit
exit:
	addi	$v0, $zero, 10		# system code for exit
	syscall				# exit gracefully
	
############################################
# I/O Routines
############################################
print_str:				# $a0 has string to be printed
	addi	$v0, $zero, 4		# system code for print_str
	syscall				# print it
	jr 	$ra			# return
	
print_int:				# $a0 has number to be printed
	addi	$v0, $zero, 1		# system code for print_int
	syscall
	jr 	$ra

read_int:				# $v0 contains the read int
	addi	$v0, $zero, 5		# system code for read_int
	syscall				
	jr	$ra


#########  toString routine
toString:					
	# $a0 has the integer.
	
	# a1 >>> memory address where to store the resulting null-terminated string
	
	blt $zero, $a0, notzero  #Checks if number is < 0 if not jump to notzero
	
	#If our number is < 0 we are here.
	mul $a0, $a0, -1 # Multiplying the number with -1 result with a positive number
	li $t1, '-' #Load char '-'
	sb $t1, 0($a1) #Store '-' onto a1 which is our memory address where to store the result
	addi $a1, $a1, 1 # Increasing the address of a1 by 1 byte
	
	#here we have our result like >>> -......
	
	notzero:
		
		#If we jump to notzero we have our result like >>> ...... >> Adress shows beginning
		#If we did not jump and stored '-' into our result we have our result like >>> -...... >> Adress icreased by 1 so it shows the byte comes after '-'
	
		addi $a2, $zero, 10 # a2 = 10 divider
	
		div $a0, $a2 # integer / 10
		
		mflo $a3 #Division to a3
		mfhi $s0 #Remainder to s0
	
		addi $t8 , $zero, 0 # t8 stores 0 >> SP Increase counter
		addi $t9 , $zero, 0 # t9 stores 0 >> SP Decrease counter
	
		addi $s0, $s0, 48 #Converting to ascii
		sb $s0, 0($sp) # Push it
		addi $sp, $sp, 1 #Increase stack pointer by one
	
		addi $t8, $t8, 1 # t8 ++ SP Increased by 1
	
	while: 
			bgt $a2, $a3, last # while Division  > divider(10) >>> while loop else Exit	
			
			div $a3, $a2 # Division/10 

			mflo $a3 #Division to a3
			mfhi $s0 #Remainder to s0
			addi $s0, $s0, 48 #Converting Remainder to ascii
			sb $s0, 0($sp) #Remainder push 
			
			addi $sp, $sp, 1 #Increase stack pointer by one
			
			addi $t8, $t8, 1 # t8 ++ >> SP Increase counter +1
			
			j while
			
			#If bolum < bolen(10) we will go to last section.
			
	last:
			addi $t8, $t8, 1 # t8 ++ >> SP Increase counter +1
			
			addi $a3, $a3, 48 #Converting Division to ascii
			sb $a3, 0($sp) #Division push >> will be our last digit 
			
			bne $t8,$t9, pop #if Increased SP Counter != Decreased SP Counter Jump to POP		
			
	pop: 
			lb $t1, 0($sp) # Pop from the stack onto t1
			sb $t1, 0($a1) #Store poped(t1) onto a1 which is our memory address where to store the result
			addi $a1, $a1, 1 # Increasing the address of a1 by 1 byte
      			addi $sp, $sp, -1   # Increment stack pointer by 1
      			
      			addi $t9, $t9, 1 # t9 ++ SP Decrease counter +1

			bne $t9,$t8, pop #Loop until Increased SP = Decreased SP
			
			jr $ra 
			
