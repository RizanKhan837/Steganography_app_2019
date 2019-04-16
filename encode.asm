.data
    startProgram:   .asciiz     "The program for hidding sentence into a BMP image has began... \n"
    menuFilename:   .asciiz     "Enter a number for choosing the image BMP to encode: 1 => img1.bmp, 2 => img2.bmp: "
    imageOne:   .asciiz     "img1.bmp"
    imageTwo:   .asciiz     "img2.bmp"
    StringEnterToEncode:   .asciiz     "Enter a sentence to encode: "
    LabelStringEnter:	.asciiz		"The string to encode is : "
    nameSaveFile: 	.asciiz		"New name of the file is : "
    saveFilename:   .asciiz     "Enter a filename for saving the image encode: "
    endProgram:     .asciiz     "The image has been save with the name: "
    newLine: 	.asciiz 	"\n"
    buffer: 	.space 		20

.text
.globl main
main:
    # INPUT FOR THE USER
    # ASK THE USER FOR THE FILENAME
    li $v0, 4 #cmd for printing a string
    la $a0, startProgram #load the string into the arg to enable printing
    syscall #exec cmd

    # PRINT A NEWLINE
    li $v0, 4 #cmd for printing a string
    la $a0, newLine  #load the string into the arg to enable printing
    syscall #exec cmd

    # SELECTION MENU FOR THE IMG
    li $v0, 4   #cmd for printing a string
    la $a0, menuFilename    #load the string into the arg to enable printing
    syscall #exec cmd

    # READ THE INPUT FOR THE CHOOSING FILE
    li $v0, 5 #cmd for reading an integer
    syscall #exec cmd
    move $t0, $v0 #move the integer input into the temporary register $t2

    # PRINT A NEWLINE
    li $v0, 4 #cmd for printing a string
    la $a0, newLine  #load the string into the arg to enable printing
    syscall #exec cmd

    # ASK THE USER FOR THE STRING TO ENCODE
    li $v0, 4 #cmd for printing a string
    la $a0, StringEnterToEncode    #load the string into the arg to enable printing
    syscall #exec cmd

    # TAKE THE INPUT OF THE USER FOR THE STRING TO ENCODE
    li $v0, 8 #cmd for reading a string
    la $a0, buffer #Load byte into the adress
    li $a1, 100 #alloc the byt space for the string
    move $t1, $a0 #save the string input into the temporary register $t1
    syscall #exec cmd

    # LABEL FOR STRING TO ENCODE
    li $v0, 4 #cmd for printing a string
    la $a0, LabelStringEnter    #load the string into the arg to enable printing
    syscall #exec cmd

    # SHOWING THE STRING ENTER
    la, $a0, buffer #Reload byte space to address
    move $a0, $t1 #Load adress with the String in $t0
    li $v0, 4 #Print String
    syscall

    # PRINT A NEWLINE
    li $v0, 4 #cmd for printing a string
    la $a0, newLine  #load the string into the arg to enable printing
    syscall #exec cmd














    # END OF PROGRAM
    # ASK THE USER FOR THE NEW FILNAME TO SAVE
    li $v0, 4 #cmd for asking a string from the user
    la $a0, saveFilename #load the string into the arg to enable printing
    syscall #exec cmd

    # TAKE THE INPUT OF THE USER FOR THE NAME OF THE NEW FILE
    li $v0, 8 #cmd for reading a string
    la $a0, buffer #Load byte into the adress
    li $a1, 100 #alloc the byt space for the string
    move $t2, $a0 #save the string input into the temporary register $t1
    syscall #exec cmd

    # PRINT A NEWLINE
    li $v0, 4 #cmd for printing a string
    la $a0, newLine  #load the string into the arg to enable printing
    syscall #exec cmd

    # PRINT THE END OF PROGRAM AND THE FILENAME
    li $v0, 4 #cmd for printing a string
    la $a0, endProgram #load the string into the arg to enable printing
    syscall #exec cmd

    # SHOWING THE NAME OF THE FILE
    la, $a0, buffer #Reload byte space to address
    move $a0, $t2 #Load adress with the String in $t0
    li $v0, 4 #Print String
    syscall

    li $v0, 10 #end the program
    syscall

#takeFile:
