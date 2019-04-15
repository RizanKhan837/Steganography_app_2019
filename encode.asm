.data
    startProgram:   .asciiz     "The program for hidding sentence into a BMP image has began... "
    menuFilename:   .asciiz     "Enter a number for choosing the image BMP to encode: 1 => img1.bmp, 2 => img2.bmp: "
    imageOne:   .asciiz     "img1.bmp"
    imageTwo:   .asciiz     "img2.bmp"
    stringEncode:   .asciiz     "Enter a sentence to encode: "
    saveFilename:   .asciiz     "Enter a filename for saving the image encode: "
    endProgram:     .asciiz     "The image has been save with the name: "

.text
.globl main
main:
    # INPUT FOR THE USER
    # ASK THE USER FOR THE FILENAME
    li $v0, 4 #cmd for printing a string
    la $a0, startProgram #load the string into the arg to enable printing
    syscall #exec cmd

    li $v0, 4   #cmd for printing a string
    la $a0, menuFilename    #load the string into the arg to enable printing
    syscall #exec cmd

    li $v0, 5 #cmd for reading an integer
    syscall #exec cmd
    move $t0, $v0 #move the integer input into the temporary register $t2

    # ASK THE USER FOR THE STRING TO ENCODE
    li $v0, 4 #cmd for printing a string
    la $a0, stringEncode    #load the string into the arg to enable printing
    syscall #exec cmd

    #TODO VEREFY
    li $a0, 8 #cmd for reading a string
    syscall #exec cmd
    move $t1, $a0 #move the string input into the temporary register $t2








    # END OF PROGRAM
    # ASK THE USER FOR THE NEW FILNAME TO SAVE
    li $v0, 4 #cmd for printing a string
    la $a0, saveFilename #load the string into the arg to enable printing
    syscall #exec cmd

    li $a0, 8
    syscall #exec cmd
    move $t0, $a0 #move the string input into the temporary register $t2

    # PRINT THE END OF PROGRAM AND THE FILENAME
    li $v0, 4 #cmd for printing a string
    la $a0, endProgram #load the string into the arg to enable printing
    syscall #exec cmd

    # PRINT THE END OF PROGRAM AND THE FILENAME
    li $v0, 4 #cmd for printing a string
    la $a0, $t0 #load the string into the arg to enable printing
    syscall #exec cmd

    li $v0, 10 #end the program

    


