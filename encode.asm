.data
    startProgram:	.asciiz    	 "The program for hidding sentence into a BMP image has began... \n"
    menuFilename:	.asciiz     	"Enter a number for choosing the image BMP to encode: 1 => img1.bmp, 2 => img2.bmp: "
    imageOne:		.asciiz     	"img1.bmp"
    imageTwo:   	.asciiz     	"img2.bmp"
    StringEnterToEncode:   .asciiz     	"Enter a sentence to encode who size max is 300 characters: "
    LabelStringEnter:	.asciiz		"The string to encode is : "
    nameSaveFile: 	.asciiz		"New name of the file is : "
    saveFilename:   	.asciiz     	"Enter a filename for saving the image encode: "
    endProgram:     	.asciiz     	"The image has been save with the name: "
    errorMessage:	.asciiz		"You choose the wrong filename for the encoding..."
    errorMessageBis:	.asciiz		"The string to encode is empty..."
    leavingProgram:	.asciiz		"Leaving the program..."
    errorMsgFile:	.asciiz		"Error for loading the file descriptor\n"
    errorReadFile:	.asciiz		"Error for reading the file\n"
    test:		.asciiz		"TEST THE VALUE\n"
    newLine: 		.asciiz 	"\n"
    buffer: 		.space 		1000
    arrayBit:		.word		1000:8
    arrayChar:		.word		1000:4

.text
.globl main
main:
	#t0 = Menu selection
	#t1 = new filename
	#s1 = String to encode
	#s2 = String length to encode
	#s3 = Length of the array of bits
	#s4 = Length of the total array file
	#s5 = Array of the image bmp
	#s6 = New buffer for the changed image
	
	jal start #Print the start of the program

	jal selectFile #go to the function selectFile the input of the user for the filename
	move $t0, $v1 #Save the return value of the selected file into $s0
	
	jal errorSelectionMenu #Function for testing the selection for the menu

	jal saveStrEncode #go to the function for saveStrEncode for getting the string to encode for the program
	move $s1, $v1 #save the return value of the string to encode into $s1 // addi $s1, $v1, 0
	
	jal stringLength #go to the function for counting letter of the string to encode
	move $s2, $v1 #save the return value of the size of the string to encode

	jal stringToArray #go to the function string to arrat
	jal arrayCharToArrayBit #go to the function char to array bit
	sll $s3, $s2, 3 #shift left of 3 (multiple value by 3)
	
	jal makingFileArray #go to the function for making the file array image (header + pixel)
	move $s4, $v0 #saving the total size of the file into $s4
	move $s5, $v1 #saving the file into $s5 (header + pixel)

	jal changePixelImg #go to the function for changing the pixel of the image
	move $s6, $v0

	jal saveStrFilename #go to the fuction saveStrFilename for getting the string for the new filename to save the file
	move $t1, $v1 #save the return value of te string for the filname into $s2

	move $a1, $s5
	lwl $a2 5($a1)
	lwr $a2 2($a1)
	jal saveFile

	jal end #go to the function end for saving the file
   
	jal exit #go to the function for exiting the program

saveFile: ######Function for saving the file
	#s4 = size of the all file
	#s5 = file data
	addi $sp, $sp, 8 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	sw $a0, 4($sp) #allocate $a0 into the stack
	
	move $a0, $a1
	li $a1, 1	
	move $a2, $s5

	li $v0, 13 #signal for opening a file
	li $a2, 0 #mode
	syscall #exec of the cmd
	
	bltz $v0, exit # go to function error if fd < 0

	move $a0, $v0
	move $a1, $s5
	move $a2, $s4
	li $v0, 15
	syscall
	
	li $v0 16
	syscall 
	
	lw $a0, 4($sp) #restore $a0
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 8 #Desalocate the 
	jr $ra #jump back to $ra (main)	

changePixelImg: ###### Function for changing the pixel of the image
	#s3 = length array of bits
	#s5 = array of the file

	addi $sp, $sp, 8 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	sw $s5, 4($sp) #allocate $s5 into the stack

	li $t0, 0 #Iteration of the loop
	li $t1, 0 #iteration of the bit[]

	#lwr $s5, 14($s5)
	#add $s5, $s5, $t3

	#lb $t6, 0($t4)
	#li $v0, 1
	#move $a0, $t6
	#syscall

	WHILEABITARR:
		beq $t0, $s3, ENDBITARR # While i != array length
		lw $t2, arrayBit($t1)
		add $t1, $t1, 4
	ENDBITARR:
		lw $s5, 4($sp) #restore $s5
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 8 #Desalocate the 
		jr $ra #jump back to $ra (main)	

makingFileArray: #######Function for making the array of the file image
	#s4 = File descriptor of the image
	#s5 = Address of the array header 
	#s6 = Total size of the image
	#s7 = Address of the pixel array

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	jal openFile #go to function for opening a file
	move $s4, $v0 #move the file discriptor and save it into $s4
		
	la $a0, 14 #size to alloc in $a0
	jal mallocBit #go to the function for malloc
	move $s5, $v0 #Address of header array of the file

	move $a0, $s4 #move fd to $a0
	move $a1, $s5 #move new array alloc to $a1
	li $a2, 14 #load 14 bits into $a2

	jal readFileDescriptor #go to function for read the file descriptor for the header

    	lwl $s6, 5($s5)
    	lwr $s6, 2($s5)

     	move $a0, $s6 #move the size of file to $a0
	jal mallocBit #go to the function for malloc bit
    	move $s7, $v0 #save the value of the array of pixel to $s7
    	

   	move $a0, $s4  #move the file descriptor to $a0
   	jal closeFileDescriptor #go to the function for closing the file descriptor

	jal openFile #go to function for opening a file
	move $s4, $v0 #move the file discriptor and save it into $s4

	move $a0, $s4 #move fd to $a0
	move $a1, $s7 #move new array of the file alloc to $a1
	move $a2, $s6 #load the total size of the file into $a2

	jal readFileDescriptor #go to function for read the file descriptor

   	move $a0, $s4  #move the file descriptor to $a0
   	jal closeFileDescriptor #go to the function for closing the file descriptor

	move $v0, $s6 #move the total size to the return value $v0
	move $v1, $s7 #move the array of the file to the return value $v1

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)	
		
closeFileDescriptor: ######Function to close the file descriptor
	addi $sp, $sp, -4
    	sw $ra, 0($sp)	

	li $v0, 16
	syscall

	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra

mallocBit: ######Function to malloc bit
	addi $sp, $sp, -4
    	sw $ra, 0($sp)

	li $v0, 9 #system all for alloc
	syscall
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra

readFileDescriptor: ######Function to read the file discriptor
	addi $sp, $sp, -4
    	sw $ra, 0($sp)

   	li $v0, 14
    	syscall

    	bltz $v0, errorRead
        	j readFile
    	errorRead:
        	la $a0, errorReadFile
        	jal exit

   	readFile:
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra

showArray: ######Function to see an array
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	
	li $t0, 0
	li $t4, 4
	loopShow:
	move $t1, $a2
	la $t3, 54

	bge $t0, $t3, next
	lb $t2, 0($t1)
	li $v0, 1
	move $a0, $t2
	syscall
	jal printNewline

	add $t0, $t0, 4
	add $t1, $t1, $t4
	j loopShow
	next:
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)	

openFile: #function to open file
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $t0, 1
	li $t1, 2

	li $v0, 13 #signal for opening a file
	beq $s0, $t1, openImg2 #if $s0 = $t1 go to openImg2
	la $a0, imageOne #load path imageOne into $a0
	j endOpen #jump to endOpen
	openImg2: 
	la $a0, imageTwo #load path to the file to open
	endOpen:
	li $a1, 0 #flag for only reading (1 is for writing)
	li $a2, 0 #mode
	syscall #exec of the cmd
	
	bltz $v0, errorFileDescriptor # go to function error if fd < 0

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)	

errorFileDescriptor:
	la $a0, errorMsgFile
	jal printStringWithNewline
	jal exit

arrayCharToArrayBit: ###### Function to put array of char into array of bit
	li $t0, 0 #iteration of the loop for array of char (i)
	li $t1, 7 #iteration of the loop for compute bit (j)
	li $t2, 0 #address of the array of bit (k)
	li $t3, 0 #value of the new bit
	li $t4, 0 #address of the array of char

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	WHILEARRAYBIT:  
		beq $t0, $s2, ENDARRAYBIT # While i != array length
		lw $t5, arrayChar($t4) #get the value of the array char into $t5
		WHILELOOPBIT:
		blt $t1 $zero ENDWHILEARRAYBIT # While j >= 0

		#CALCULATION OF x = bit[k]
		srlv $t3, $t5, $t1 # number shift right of j 
		andi $t3, $t3, 1 # value and 1

		add $t2, $t2, 4 # iteration of the bit[k + 4]
		sub $t1, $t1, 1 # iteration of the loop (j--)
		j WHILELOOPBIT
		ENDWHILEARRAYBIT:
			#GO BACK TO THE MAIN LOOP AND INIT VALUE BACK
			li $t1, 7 # reset the value of j to 7
			li $t3, 0 # reset the value of the bit to 0
			add $t4, $t4, 4 # add 4 to the adress of the array of char
			add $t0, $t0, 1 # add one to the iteration of the main loop (i++)
			j WHILEARRAYBIT
	ENDARRAYBIT:
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 4 #Desalocate the 
		jr $ra #jump back to $ra (main)		
	

stringToArray: ###### Function to put string to array of char
	li $t0, 0 #iteration the string  $t0
	li $t3, 0 #iteration of the array
 
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	WHILESTRARRAY:  
		add $t1, $s1, $t0  #assign at $t1 the adress of the array $s1 at $t0 (t1 = &A[i])
		lb $t2, 0($t1) #load byte for the offset 0 of the adress $t1 (t2 = A[i]
		beqz $t2, ENDWHILESTRARRAY #If \0 is found go to END
		sw $t2, arrayChar($t3) #set the value of the array to $t2

		#li $v0, 11
		#lw $a0, arrayChar($t3)
		#syscall
		
		addi $t3, $t3, 4 #Add 4 bit to the address of the array
		add $t0, $t0, 1 #add one to the counter of the array
		j WHILESTRARRAY #jump back to while
	ENDWHILESTRARRAY:
		bne $t3, 1, ENDSTRARRAY #jump to function print string with a new line
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 4 #Desalocate the stack at the pos
		jal exit #jump to function for exit the program
	ENDSTRARRAY:
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 4 #Desalocate the stack at the pos
		jr $ra #jump back to $ra (main)

errorSelectionMenu: ###### Function for error handling menu selection
	li $t2 1 #init $t0 to 1
	li $t1 2 #init $t1 to 2

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	beq $t0, $t2, ENDMENU #check if $s0 is equal to $t0
	bne $t0, $t1, ELSEMENU #check if $s0 is equal to $t1
	j ENDMENU #jump to END 
	ELSEMENU: 
		la $a0, errorMessage #load errorMessage to $a0
		jal printStringWithNewline #jump to function for print a string with a new line
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 4 #Desalocate the stack at the pos
		jal exit #jump to function for exit the program	
	ENDMENU:
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 4 #Desalocate the stack at the pos
		jr $ra #jump back to $ra (main)


stringLength: ###### FUNCTION FOR COUNTING THE LENGTH OF THE STRING
	
	li $t0, 0 #interation of $t0
	li $t3, 0 #counter
 
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	WHILESTRLEN:
		add $t1, $s1, $t0  #assign at $t1 the adress of the array $s1 at $t0 (t1 = &A[i]) 
		lb $t2, 0($t1) #load byte for the offset 0 of the adress $t1 (t2 = A[i]) 		
		beqz $t2, ENDWHILESTRLEN #If \0 is found go to END
		add $t3, $t3, 1 #add one to the counter
		add $t0, $t0, 1 #add one to the counter of the array
		j WHILESTRLEN #jump back to while
	ENDWHILESTRLEN:
		bne $t3, 1, ENDSTRLEN #jump to function print string with a new line
		la $a0, errorMessageBis #load errorMessageBis for void string
		jal printStringWithNewline #jump to function for print a string with a new line
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 4 #Desalocate the stack at the pos
		jal exit #jump to function for exit the program
	ENDSTRLEN:
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 4 #Desalocate the stack at the pos
		move $v1, $t0
		jr $ra #jump back to $ra (main)
	
	#ENCODE THE STRING INTO BIT (CHANGE CHAR INTO NUMBER THEN CHANGE NUMBER INTO BIT AND PUT IT IN A STACK
	
	#OPEN THE FILE AND READ COLOR BY COLOR (8 bits) AFTER THE HEADER

	#ADD THE CHAR START ENCODE STRING '\0' IN ASCII TO THE END OF THE STRING AT THE PIXEL

	#ALTER THE COLOR OF EACH PIXEL WITH EACH BIT OF THE STRING IN BIT
	
	#ADD THE CHAR ENDLINE '\0' IN ASCII TO THE END OF THE STRING AT THE PIXEL
	
	#CLOSE THE FILE
	
	#SAVE THE FILL WITH THE NEW FILE

exit: ###### Exit the program
	la $a0, leavingProgram #load the string for leaving the program in $a0
	jal printString #jump to the function for print string
    	li $v0, 10 #Signal for existing the program 
    	syscall

start: ###### INPUT FOR THE USER
    	# ASK THE USER FOR THE FILENAME
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
    	
    	la $a0, startProgram #load the string into the arg to enable printing
	jal printStringWithNewline #jump to function to print string with a bew line

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the stack at the pos

    	jr $ra #jump back to the pc - 1

selectFile: ###### SELECTION MENU FOR THE IMG
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

   	la $a0, menuFilename    #load the string into the arg to enable printing
	jal printString #jump to function print string

    	# READ THE INPUT FOR THE CHOOSING FILE
    	li $v0, 5 #cmd for reading an integer
    	syscall #exec cmd
    	move $v1, $v0 #move the integer input into the temporary register $t0

    	# PRINT A NEWLINE
	jal printNewline #jump to function for print a new line

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the stack at the pos

    	jr $ra #jump back to the pc - 1

saveStrEncode:

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

    	# ASK THE USER FOR THE STRING TO ENCODE
  	la $a0, StringEnterToEncode    #load the string into the arg to enable printing
  	jal printString #jump to the function printString

   	 # TAKE THE INPUT OF THE USER FOR THE STRING TO ENCODE
    	li $v0, 8 #cmd for reading a string
    	la $a0, buffer #Load byte into the adress
    	li $a1, 500 #alloc the byt space for the string
    	move $v1, $a0 #save the string input into the return value $v1
    	syscall #exec cmd

    	# LABEL FOR STRING TO ENCODE
    	la $a0, LabelStringEnter    #load the string into the arg to enable printing
	jal printString #jump to the function printString

    	# SHOWING THE STRING ENTER
	move $a0, $v1 #load adress with the String in $t1
	jal printStringWithNewline #jump to the function print string with a new line
    	#la, $a0, buffer #Reload byte space to address

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the stack at the pos

    	jr $ra #jump back to the pc - 1

saveStrFilename: ###### ASK THE USER FOR THE NEW FILNAME TO SAVE
    	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	la $a0, saveFilename #Print the string
	jal printString #jump to the function printString

    	# TAKE THE INPUT OF THE USER FOR THE NAME OF THE NEW FILE
    	li $v0, 8 #cmd for reading a string
    	la $a0, buffer #Load byte into the adress
    	li $a1, 100 #alloc the byt space for the string
    	move $v1, $a0 #save the string input into the temporary register $t1
    	syscall #exec cmd

    	# PRINT A NEWLINE
	jal printNewline #jump to the function print new line

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the stack at the pos

    	jr $ra #jump back to the pc - 1

end:	###### PRINT THE END OF PROGRAM AND THE FILENAME
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	la $a0, endProgram #Print the string
	jal printString #jump to the function printString

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the stack at the pos
   
   	# SHOWING THE NAME OF THE FILE
    	la, $a0, buffer #Reload byte space to address
    	move $a0, $t1 #Load adress with the String in $t1
    	li $v0, 4 #Print String
    	syscall #exec the instruction
    
    	jr $ra #jump back to the pc - 1

printStringWithNewline: ###### FUNCTION FOR PRINT STRING WITH \n
	li $v0, 4 #load the signal to print a string
	syscall #exec the instruction

	li $v0, 4 #load the signal to print a string
	la $a0, newLine
	syscall #exec the instruction

	jr $ra #jump back to the pc - 1

printString: ###### FUNCTION FOR PRINT THE STRING
	li $v0, 4 #load the signal to print a string
	syscall #exec the instruction
	
	jr $ra ##jump back to the pc - 1

printNewline: ###### FUNCTION FOR PRINTING A NEW LINE
	li $v0, 4 #load the signal to print a string
	la $a0, newLine #load the string newline into $a0
	syscall #exec the instruction
	
	jr $ra #jump back to the pc - 1
