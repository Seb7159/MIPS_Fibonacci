    .data
intro:      .asciiz "Provide an integer for the Fibonacci computation: \n"

mid_string: .asciiz "The Fibonacci numbers are: \n" 

fib_start:  .asciiz "f("
fib_mid:    .asciiz ")=" 

first_final_string: .asciiz "\nThe Fibonacci elemet at index "
mid_final_string:   .asciiz " is " 
last_final_string:  .asciiz "."

no_grace_string:    .asciiz "\nNumber is not valid for finding index in the Fibonacci sequence." 

eol:        .asciiz "\n" 

    .text
main:
    # Print introductory message 
    la $a0, intro
    li $v0, 4
    syscall 
    
    # Get index n of element from Fibonacci sequence
    li $v0, 5
    syscall 
    
    # Save n in s0
    move $s0, $v0 
    
    
    # Checking/Testing the input 
    # If s0 is smaller than 0, end program 
    bltz $s0, end_program_no_grace
    
    
    # Else get to action and print mid_string
    la $a0, mid_string
    li $v0, 4
    syscall 
    
    # Allocate heap space to save all the elements in the heap 
    li $t0, 4
    mul $a0, $s0, $t0
    addi $a0, $a0, 4
    li $v0, 9
    syscall 
    
    # Save heap memory address to s1
    move $s1, $v0
    
    # Save current index 0 to s2 
    li $s2, 0 
    
    
    # Call our Fibonacci method fib 
    jal fib
    
    
    # Set return value of fib_loop to argument of print_finall
    move $a0, $v0 
    # Print final statement
    jal print_final 
    
    
    # If method is finished, call end program method 
    j end_program


# My Fibonacci sequence element finder method 
fib: 
    # Go to fib_init
    
# Method to initialise parameters in the Fibonacci method 
fib_init:
    # Save the stack and its return address
    addi $sp, $sp, -4
    sw $ra, 0($sp) 

    # Put the first element of Fibonacci into the heap 
    li $t0, 0
    sw $t0, 0($s1) 
    
    # Print it 
    jal print_number_fib 
    
    # Increment index 
    addi $s2, $s2, 1
    
    # If n == 0, end program
    beqz $s0, end_fib_init
    
    
    # Else proceed to second element 
    addi $s1, $s1, 4
    li $t0, 1
    sw $t0, 0($s1) 
    
    # Print second element
    jal print_number_fib
    
    # Increment index 
    addi $s2, $s2, 1
    
    
    # Call recursive fibonacci method
    jal fib_loop 
    

# When fib_init is finished 
end_fib_init:
    # Put argument from fib_loop to return argument
    move $v0, $t0
    
    # Get return address and adjust stack pointer
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    # Return to main method
    jr $ra 
    
    
# Method to call when initialising of fibonacci finished 
fib_loop:
    # Save the stack and its return address 
    addi $sp, $sp, -4
    sw $ra, 0($sp) 
    
    # Check if index s2 is greater than n so program ends peacefully 
    bgt $s2, $s0, fib_end
    
    # Else add 4 to heap
    addi $s1, $s1, 4
    
    # Get element n-2 to t0
    lw $t0, -8($s1)
    
    # Get element n-1 to t1
    lw $t1, -4($s1) 
    
    # Calculate next fibonacci number 
    add $t0, $t0, $t1
    sw $t0, 0($s1) 
    
    # Set return variable v0 to the current fibonaci number
    move $v0, $t0 
    
    # Print element
    jal print_number_fib
    
    # Increment index 
    addi $s2, $s2, 1 
    
    # Continue to next fibonacci element
    jal fib_loop 
    
    
# Method to call when fibonacci loop ends 
fib_end: 
    # Load return address, and adjust stack pointer
    lw $ra, 0($sp)
    addi $sp, $sp,  4
    
    # Return to previous method call
    jr $ra 
    
    
# Method to print current element of the array 
print_number_fib:
    # Print first part of print string
    la $a0, fib_start
    li $v0, 4
    syscall
    
    # Print index of element 
    move $a0, $s2
    li $v0, 1
    syscall
    
    # Print mid part of print string
    la $a0, fib_mid
    li $v0, 4
    syscall 
    
    # Print element at current index of Fibonacci sequence 
    lw $a0, 0($s1) 
    li $v0, 1
    syscall 
    
    # Prind end of line 
    la $a0, eol
    li $v0, 4
    syscall
    
    # Return to previous method 
    jr $ra 
    

# Method to print final statement 
print_final:
    # Save argument of method
    move $t0, $a0

    # Print first part of final string
    la $a0, first_final_string
    li $v0, 4
    syscall 
    
    # Print n 
    move $a0, $s0
    li $v0, 1
    syscall
    
    # Print mid part of final string 
    la $a0 mid_final_string
    li $v0, 4
    syscall 
    
    # Print final element in the argument of the method
    move $a0, $t0
    li $v0, 1
    syscall 
    
    # Print final part of final string
    la $a0, last_final_string
    li $v0, 4
    syscall 
    
    # Return to previous method
    jr $ra 


# Method in case program ends and test cases were not passed at first 
end_program_no_grace:
    # Print string 
    la $a0, no_grace_string
    li $v0, 4
    syscall 
    
    # Then jump to end program

# Method when program ends 
end_program:
    # Calculate deallocation space 
    addi $t8, $t8, -4
    mul $t9, $s0, $t8

    # Deallocate heap space
    move $a0, $t9
    li $v0, 9
    syscall

    # Call end command to program
    li $v0, 10
    syscall 