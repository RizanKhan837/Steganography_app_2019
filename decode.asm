.data
    startProgram:   .asciiz     "The program to decode a hidding sentence into a BMP image has began...\n"
    menuFilename:   .asciiz     "Enter a number for choosing the image BMP to decode: 1 => img1.bmp, 2 => img2.bmp: "
    imageOne:   .asciiz     "img1.bmp"
    imageTwo:   .asciiz     "img2.bmp"
    endProgram:     .asciiz     "The decode of the image has finished and the result his: "
    newLine: 	.asciiz 	"\n"

.text
.globl main
main: 
    # INPUT FOR THE USER
    # ASK THE USER FOR THE FILENAME
    li $v0, 4 #cmd for printing a string
    la $a0, startProgram  #load the string into the arg to enable printing
    syscall #exec cmd
    
    li $v0, 4 #cmd for printing a string
    la $a0, newLine  #load the string into the arg to enable printing
    syscall #exec cmd

    li $v0, 4 #cmd for printing a string
    la $a0, menuFilename  #load the string into the arg to enable printing
    syscall #exec cmd

    li $v0, 5 #cmd for reading an integer
    syscall #exec cmd
    move $t0, $v0 #move the integer input into the temporary register $t2

    li $v0, 4 #cmd for printing a string
    la $a0, newLine  #load the string into the arg to enable printing
    syscall #exec cmd








    # END OF PROGRAM
    # PRINT THE END OF PROGRAM AND THE SENTENCE DECODE
    li $v0, 4 #cmd for printing a string
    la $a0, endProgram  #load the string into the arg to enable printing
    syscall #exec cmd

    #PRINT THE RESULT OF THE STRING DECODE
    #li $v0, 4 #cmd for printing a string
    #move $a0, $t1 #load the string into the arg to enable printing
    #syscall #exec cmd

    li $v0, 10 #end the program
    syscall
