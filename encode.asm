.data
    startProgram:		.asciiz    	 	"The program for hidding sentence into a BMP image has began... \n"
    menuFilename:		.asciiz     	"Enter a number for choosing the image BMP to encode: 1 => img1.bmp, 2 => img2.bmp: "
    imageOne:			.asciiz     	"./ImageSource/img1.bmp"
    imageTwo:   		.asciiz     	"./ImageSource/img2.bmp"
    StringEnterToEncode:.asciiz     	"Enter a sentence to encode who size max is 300 characters: "
    LabelStringEnter:	.asciiz			"The string to encode is : "
    nameSaveFile: 		.asciiz			"New name of the file is : "
    saveFilename:   	.asciiz     	"Enter a filename for saving the image encode (the filename must end with .bmp) : "
    endProgram:     	.asciiz     	"The image has been save with the name: "
    errorMessage:		.asciiz			"You choose the wrong filename for the encoding..."
    errorMessageBis:	.asciiz			"The string to encode is empty..."
    leavingProgram:		.asciiz			"Leaving the program..."
    errorMsgFile:		.asciiz			"Error for loading the file descriptor\n"
    errorReadFile:		.asciiz			"Error for reading the file\n"
    test:				.asciiz			"TEST THE VALUE\n"
    newLine: 			.asciiz 		"\n"
    spacer:				.asciiz			", "
    buffer: 			.space 			1000
    arrayBit:			.word			1008:8
    arrayChar:			.word			1000:4
    header:				.space			128
    endString:			.word			0, 0, 1, 0, 1, 1, 1, 1


######################################################################################
######################################################################################
################################     MAIN     ########################################
######################################################################################
######################################################################################

.text
.globl main
main:
	#s0 = Menu selection
	#s1 = String to encode
	#s2 = String length to encode
	#s3 = Length of the array of bits
	#s4 = Length of the total array file
	#s5 = Array of the image bmp
	#s6 = New filename for saving

	jal start #Print the start of the program

	jal selectFile #go to the function selectFile the input of the user for the filename
	move $s0, $v1 #Save the return value of the selected file into $s0
	
	jal errorSelectionMenu #Function for testing the selection for the menu

	jal saveStrEncode #go to the function saveStrEncode for getting the string to encode for the program
	move $s1, $v1 #save the return value of the string to encode into $s1 // addi $s1, $v1, 0
	
	move $a1, $s1 #move the value of the string $s1 into $a1
	jal stringLength #go to the function for counting letter of the string to encode
	move $s2, $v1 #save the return value of the size of the string to encode


	jal stringToArray #go to the function string to arrat

	jal arrayCharToArrayBit #go to the function char to array bit
	sll $s3, $s2, 3 #shift left of 3 (multiple value by 3)
	
	#This is for display the name of the file header
	#li $t2, 4 #load $t2 = 4
	#li $v0, 1 #load return value to 1
	#lw $t1, arrayBit($t2) #load word $t1 with the arrayBit($t2)
	#move $a0, $t1 #move $t1 into argument $a0
	#syscall #exec cmd
	
	#jal testImg #Use this function to test the beginning of the img
	
	jal makingFileArray #go to the function for making the file array image (header + pixel)
	move $s4, $v0 #saving the total size of the file into $s4
	move $s5, $v1 #saving the file into $s5 (header + pixel)
	
	la $a2, 104 #load the value to read into $a2
	move $a1, $s5 #move the address of the file array into $a1
	jal showArrayAlloc #go to the function for testing the image pixel and header

	jal changePixelImg #go to the function for changing the pixel of the image

	la $a2, 104 #load the value to read into $a2
	move $a1, $s5 #move the address of the file array into $a1
	jal showArrayAlloc #go to the function for testing the image pixel and header

	jal saveStrFilename #go to the fuction saveStrFilename for getting the string for the new filename to save the file
	move $s6, $v1 #save the return value of te string for the filename into $s2

	move $a1, $s5 #move the adress of the array file into $a1
	jal saveFile #go to function saveFile

	jal end #go to the function end for saving the file
   
	jal exit #go to the function for exiting the program
	
######################################################################################
######################################################################################	

changePixelImg: ###### Function for changing the pixel of the image
	#s3 = length array of bits
	#s5 = array of the file

	addi $sp, $sp, 8 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	sw $s5, 4($sp) #allocate $s5 into the stack

	li $t0, 0 #Iteration of the loop
	li $t1, 0 #iteration of the bit[]
	li $t3, 1 #value to add if bit[$t1] = 1
	
	add $s5 $s5, 60 # add 56 bits for going to the first pixel adress

	WHILEBITARR:
		beq $t0, $s3, ENDBITARR # While i != array length
		lb $t4, 0($s5) #value of the first pixel
		lb $t6, arrayBit($t1) #value of the arraybit($t1)
		add $t4, $t4, 0 #add the value of the pixel to $t4

		beq $t6, $0, NOADDZERO #if $t6 == 0 jump to NOADDZERO
		add $t4, $t4, $t3 #add one to the value of the pixel

		sb $t4, ($s5) #add the new value to the pixel array
		add $s5, $s5, 4 #iteration of the pixel array 
		add $t1, $t1, 4 #bit[j], j++
		add $t0, $t0, 1 #i++ of the loop
		j WHILEBITARR	#jump to WHILEBITARR
		NOADDZERO:
		add $s5, $s5, 4 #iteration of the pixel array 
		add $t1, $t1, 4 #bit[j], j++ 
		add $t0, $t0, 1 #i++ of the loop
		j WHILEBITARR #jump to WHILEBITARR
	ENDBITARR:
		li $t0, 0 #Iteration of the loop
		li $t1, 0 #iteration of the enString[]
		li $t3, 1 #value to add if endString[$t1] = 1
		li $t7, 8 #end of loop
		LOOPADDCHAR:
		#Add end of string before leaving function
		beq $t0, $t7, ENDADDCHAR # While i != array length
		lb $t4, 0($s5) #value of the first pixel
		lw $t6, endString($t1) #value of the arraybit($t1)
		add $t4, $t4, 0 #add the value of the pixel to $t4

		beq $t6, $0, NOADDZEROBIS #if $t6 == 0 jump to NOADDZEROBIS
		add $t4, $t4, $t3 #add one to the value of the pixel
		sb $t4, ($s5) #add the new value to the pixel array
		add $s5, $s5, 4 #iteration of the pixel array 
		add $t1, $t1, 4 #endString[j], j++
		add $t0, $t0, 1 #i++ of the loop
		j LOOPADDCHAR #jump to LOOPADDCHAR
		NOADDZEROBIS:
		add $s5, $s5, 4 #iteration of the pixel array 
		add $t1, $t1, 4 #bit[j], j++ 
		add $t0, $t0, 1 #i++ of the loop
		j LOOPADDCHAR	#jump to LOOPADDCHAR
		ENDADDCHAR:

		lw $s5, 4($sp) #restore $s5
		lw $ra, 0($sp) #restore the value of the stack with the register
		addi $sp, $sp, 8 #Desalocate the 
		jr $ra #jump back to $ra (main)

makingFileArray: #######Function for making the array of the file image
	#s4 = File descriptor of the image
	#s5 = Address of the array header 
	#s6 = Total size of the image
	#s7 = Address of the pixel array

	addi $sp, $sp, -4 #load the stack with one spotr
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

	#get the total length of the file
    	lwl $s6, 5($s5) #load the word left into $s6
    	lwr $s6, 2($s5) #load the word right into $6

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

#################################################################################
##### FUNCTION FOR READING / OPENING / CLOSE FILE
	
closeFileDescriptor: ####### Function to close the file descriptor
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $v0, 16 #signal to close the file descriptor
	syscall #exec the cmd

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)

readFileDescriptor: ####### Function to read the file discriptor
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

   	li $v0, 14 #signal to read
    	syscall #exec the cmd

    	bltz $v0, errorRead #if $v0 < 0 goto errorRead
        	j readFile #jump to readFile
    	errorRead:
        	la $a0, errorReadFile #load the error string to $a0
        	jal exit #jump to exit the program

   	readFile:
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)

openFile: ####### Function to open file
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $t0, 1 #init $t0 = 1 (choice 1)
	li $t1, 2 #init $t1 = 2 (choice 2)

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

errorFileDescriptor: ####### FUNCTION FOR ERROR FD
	la $a0, errorMsgFile #load the string into $a0
	jal printStringWithNewline #go to the function for print a string with a new line
	jal exit #go to the function for exit the program

#####################################################################################
#####################################################################################
####### FUNCTION FOR SAVING THE FILENAME / THE FILE / STR TO ENCODE
saveStrEncode: ####### FUNCTION FOR THE STRING TO ENCODE

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

    	# ASK THE USER FOR THE STRING TO ENCODE
  	la $a0, StringEnterToEncode   #load the string into the arg to enable printing
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


saveStrFilename: ####### FUNCTION FOR THE NEW FILENAME
    	li $t1 10 #value of \n
    	li $t2 0  #value of \0
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

    	# ASK THE USER FOR THE STRING TO ENCODE
  	la $a0, saveFilename   #load the string into the arg to enable printing
  	jal printString #jump to the function printString

   	 # TAKE THE INPUT OF THE USER FOR THE STRING TO ENCODE
    	li $v0, 8 #cmd for reading a string
    	la $a0, buffer #Load byte into the adress
    	li $a1, 500 #alloc the byt space for the string
    	move $v1, $a0 #save the string input into the return value $v1
    	syscall #exec cmd
  
     	move $t0 $a0 #save the value of $a0 in $t0
    	LOOPSTRFILE:
        lb $t3 0($t0) #load byte of the adress of $t0 in $t3
        beqz $t3 ENDLOOPSTRFILE #if $t3 == 0 go to ENDLOOPSTRFILE
        beq $t3 $t1 DELETEENDLINE #if $t3 == \n go to DELETEENDLINE
            	addi $t0 $t0 1   #$t0 += 1
            	j LOOPSTRFILE #jump to LOOPSTRFILE
        DELETEENDLINE:
            	sb $t2 0($t0) #store bits of $t2 into $t0
            	j ENDLOOPSTRFILE
    	ENDLOOPSTRFILE:
    	move $v1 $a0 #move $a0 to the return value $v1
	
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the stack at the pos

    	jr $ra #jump back to the pc - 1

saveFile: ######Function for saving the file
	#s4 = size of the all file
	#s5 = file data
	addi $sp, $sp, 4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0


	li $v0, 13 #signal for opening a file
	move $a0, $s6 #load filename into $a0
	li $a1, 1 #enable writing
	li $a2, 0 #ignore the mode
	syscall #exec of the cmd
	move $a0, $v0 #load the file descriptor into $a0
	
	bltz $v0, exit # go to function error if fd < 0

	li $v0, 15 #signal for writing into file
	move $a1, $s5 #put the file into $a1
	move $a2, $s4 #put the totalsize into $s4
	syscall #exec cmd
	
	li $v0, 16 #signal for closing the fd
	syscall #exec cmd
	
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)


#########################################################################################
######## FUNCTION FOR HANDLING STRING ENTER TO ENCODE
arrayCharToArrayBit: ###### Function to put array of char into array of bit
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $t0, 0 #iteration of the loop for array of char (i)
	li $t1, 7 #iteration of the loop for compute bit (j)
	li $t2, 0 #address of the array of bit (k)
	li $t3, 0 #value of the new bit
	li $t4, 0 #address of the array of char
		
	
	move $t4 $s1 #address of the string
#LOOPSTRFILEBIS:
#        lb $t6 0($t4) #load byte of the adress of $t0 in $t3
 #       li $v0, 1
  #      move $a0, $t6
   #     syscall
        
    #    la $a0, spacer
	#jal printString

        #beqz $t6 ENDLOOPSTRFILEBIS #if $t3 == 0 go to ENDLOOPSTRFILE
         #   addi $t5 $t5 1   #$t0 += 1
          #  j LOOPSTRFILEBIS #jump to LOOPSTRFILE
        #ENDLOOPSTRFILEBIS:
	WHILEARRAYBIT:  
		lb $t5, 0($t4) #get the value of the array char into $t5
		
		beq $t0, $s2, ENDARRAYBIT # While i != array length
		#li $v0, 11 #signal to print a char
		#move $a0, $t5 #move $t5 into $a0
		#syscall #exec cmd

		#la $a0, spacer #load the address of spacer into $a0
		#jal printString #go to the function for print a string

		WHILELOOPBIT:
		blt $t1 $zero ENDWHILEARRAYBIT # While j >= 0
		#CALCULATION OF x = bit[k]
		srlv $t3, $t5, $t1 # number shift right of j 
		andi $t3, $t3, 1 # value logical and 1
		
		sb $t3, arrayBit($t7) #TODO ERROR ICI WTFFFF

		li $v0, 1 #signal to print an integer
		move $a0, $t3 #move $t3 into $a0
		syscall #exec cmd

		add $t7, $t7, 4 # iteration of the bit[k + 4]
		sub $t1, $t1, 1 # iteration of the loop (j--)
		
		la $a0, spacer #load the address of spacer into $a0
		jal printString #go to the function for print a string

		#li $v0, 1 #signal to print an integer
		#move $a0, $t1 #move $t3 into $a0
		#syscall #exec cmd

		la $a0, spacer #load the address of spacer into $a0
		jal printString #go to the function for print a string		
						
		j WHILELOOPBIT
		ENDWHILEARRAYBIT:
			#GO BACK TO THE MAIN LOOP AND INIT VALUE BACK
			li $v0, 1
			move $a0, $t1
			syscall
			jal printNewline #go to the function for print a new line
			li $t1, 7 # reset the value of j to 7
			li $t3, 0 # reset the value of the bit to 0
			addi $t4, $t4, 1 # add 4 to the adress of the array of char
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

stringLength: ###### FUNCTION FOR COUNTING THE LENGTH OF THE STRING
	
	li $t0, 0 #interation of $t0
	li $t3, 0 #counter
 
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	WHILESTRLEN:
		add $t1, $a1, $t0  #assign at $t1 the adress of the array $a1 at $t0 (t1 = &A[i]) 
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
		
######################################################################################
######################################################################################
####### FUNCTION FOR STARTING / ENDING THE PROGRAM

start: ###### INPUT FOR THE USER
    	# ASK THE USER FOR THE FILENAME
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
    	
    	la $a0, startProgram #load the string into the arg to enable printing
	jal printString #jump to function to print string with a bew line

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
    	move $a0, $s6 #Load adress with the String in $t1
    	li $v0, 4 #Print String
    	syscall #exec the instruction
    
    	jr $ra #jump back to the pc - 1
    	
######################################################################################
######################################################################################
######### FUNCTION FOR THE MENU SELECTION

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
    	
errorSelectionMenu: ###### Function for error handling menu selection
	li $t2 1 #init $t0 to 1
	li $t1 2 #init $t1 to 2

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	beq $s0, $t2, ENDMENU #check if $s0 is equal to $t0
	bne $s0, $t1, ELSEMENU #check if $s0 is equal to $t1
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

######################################################################################
######################################################################################
######## TOOL FOR THE PROGRAM

exit: ###### Exit the program
    	jal printNewline

	la $a0, leavingProgram #load the string for leaving the program in $a0
	jal printString #jump to the function for print string
    	li $v0, 10 #Signal for existing the program 
    	syscall #exec cmd

printStringWithNewline: ###### FUNCTION FOR PRINT STRING WITH \n
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	li $v0, 4 #load the signal to print a string
	syscall #exec the instruction

	li $v0, 4 #load the signal to print a string
	la $a0, newLine
	syscall #exec the instruction

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to the pc - 1

printString: ###### FUNCTION FOR PRINT THE STRING
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $v0, 4 #load the signal to print a string
	syscall #exec the instruction

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 	
	jr $ra ##jump back to the pc - 1

printNewline: ###### FUNCTION FOR PRINTING A NEW LINE
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $v0, 4 #load the signal to print a string
	la $a0, newLine #load the string newline into $a0
	syscall #exec the instruction

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to the pc - 1

mallocBit: ######Function to malloc bit
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $v0, 9 #system all for alloc
	syscall #exec the cmd
	
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)
	
######################################################################################
######################################################################################
######## FUNCTION FOR TESTING

testImg: ####### FUNCTION FOR TESTING THE IMAGE

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	jal openFile #go to function for opening a file
	move $t7, $v0 #move the file descriptor and save it into $s4
	
	move $a0, $t7 #move the file descriptor into $a0
	la $a1, header #load the header array address into $a1
	li $a2, 128 # header = array of space 54

	jal readFileDescriptor #go to the function to read the file descriptor of a particular size

	jal showArray #go to the function for showing the array

	move $a0, $t7 #move the file descriptor into $a0
	jal closeFileDescriptor #go to the function to close de file descriptor

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 8 #Desalocate the 
	jr $ra #jump back to $ra (main)	
	
showArray: ######Function to see an array
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	
	li $t0, 0 #init $t0 = 0

	li $v0, 4 #signal to print a string
	la $a0, header($t0) #load the adress 0 of the header to $a0
	syscall #exec the cmd
	
	jal printNewline #go to the function for print a new line
	loopShow:
	move $t1, $a2 #move the value to read into $t1

	bge $t0, $t1, next #if $t0 > $t1 go to next
	lb $t2, header($t0) #load byt of header($t0) to $t2
	li $v0, 1 #signal to print int
	move $a0, $t2 #move $t2 to the arg $a0
	syscall #exec cmd
	li $v0, 4 #signal to print string
	la $a0, spacer #load string into $a0
	syscall #exec cmd
	add $t0, $t0, 4 # $t0 += 4
	j loopShow #jump back to top
	next:
	jal printNewline #go to function for print a new line
	jal printNewline #go to function for print a new line
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)	

showArrayAlloc: ######Function to show array alloc
	# $a2 = number of bit to read
	# $a1 = array to read

	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	
	li $t0, 0 #iteration of the loop
	
	move $t1, $a2 #move the value to read into $t1
	move $t3, $a1 #move the array to $t3
	
	loopShowAlloc:
	bge $t0, $t1, nextAlloc #if $t0 > $t1 go to next
	lb $t2, 0($t3) #load byt of header($t0) to $t2
	li $v0, 1 #signal to print int
	move $a0, $t2 #move $t2 to the arg $a0
	syscall #exec cmd
	li $v0, 4 #signal to print string
	la $a0, spacer #load string into $a0
	syscall #exec cmd
	add $t0, $t0, 4 # $t0 += 4
	add $t3, $t3, 4 # $t3 += 4
	j loopShowAlloc #jump back to top

	nextAlloc:
	jal printNewline #go to function for print a new line
	jal printNewline #go to function for print a new line
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)
	
testValueArray:
	# $a1 = position
	# $a2 = array
	addi $sp, $sp, 4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0	

	li $v0, 1 #signal for print a int
	move $t0, $a1 #move the pos $a1 into $t0
	move $t1, $a2 #move the array $a2 into $t1
	add $t1, $t1, $t0 #add the position of the pixel to the array address
	lb $t2, 0($t1) #load bit into $t2 from address $t1
	move $a0, $t2 #move $t2 into $a0
	syscall #exec cmd
	
	jal printNewline #go to function for print a new line

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)
######################################################################################
######################################################################################
