Learn MIPS:

############Introduction to MIPS
I.Data types
1.Literals
-numbers (5)
-char ('a')
-string ('name')

2.Registers
-with '$'
-adressed by using register's number ('$0 -$31)
-adressed by the name ('$t1')

II.General structure of a program (two main part)
1.data declaration section (.data)
-declaration of variable (create and define)
-storage allocated in memory (RAM)

Example:
name:           .storage_type       value(s)
(name variable) (type_of_data)      (info_to_be_store)
var1:           .word               5 (for int a = 5)

2.code section (.text)
-where the instruction are executed
-manipulation of registers and arithmetic operations
-starting point = main
-ending point = exit system call

a.Manipulation of registers
-using 'load', 'indirect' or 'indexed' addressing
*load (copied and stored in temp register) :
la $t0, var1 -> load var1 into $t0
*indirect (random-Access Memory adress copied into temp $t0)
lw $t2, ($t0) -> copy of $t0 into $t2
*indexed (address of a $t0 + offset by a value = value stored in a another random-Access Memory adress)
lw $t2, 4($t0) -> obtain the adress four adresses away from $t0 into $t2

b.Performance of arithmetic operations
-mostly with 3 operands (always registers)
-size of operand is a word
-most command are 'add/sub/mult/div'

Example:
operation   storage_reg, first_op, second op
(operateur) (result)     (operand) (operand) 

III.Program

1. ".data"
-Use this part to ask things to the user
-Declaration of global variables

2. Load value that will be use in the program (Pre-load)
li  $t3, 1 #load 1 in $(t3) (int)

3. Get Value of the User
-Ask the user and print the message .data
li $v0, 4 #cmd for printing a string
la $a0, prompt1 #load the string to print into the arg to enable printing
syscall #exec cmd
-Reading the answer of the user
li $v0, 5 #cmd reading int
syscall #exec cmd
move $t0, $v0 #move nb input into reg temp $t0
Remake the thing for each input needed from the user with the right datatype

4. Make control structure (know what do exec)
beq $t2, $t3, addProcess #Branch to 'addProcess' if $t2 == $t3
Do the same for every branch

5. Exec the branch
addProcess:
    add $t6, $t0, $t1 # $t6 = $t0 + $t1 
    #Load string result and print it
    li $v0, 1 #cmd for printing a integer
    la $a0, ($t6)
    syscall #load the integer into the arg $a0 for printing

6. End the program
    li $v0, 10 #end the program

############MIPS programming, Bitwise logic operations:

#MIPS Instruction Format Table
Field Size 6bits 5bits 5bits 5bits 5bits 6bits == 32 bits
1.R-Format  opcode rs    rt    rd    shamt funct ==> Arith and logic inst
2;I-Format  opcode rs    rt   immediate value    ==> Branches, immediate, Data Transfer
3.J-Format   opcode          Target address      ==> Jump inst

Opcode = operational code (machine representation of inst)
Shamt = shift amount (how many bits rs is shifted)

1. rs = 1st src reg (value for op) / rt = 2nd source reg / rd = dest reg
2. rs = 1st src reg / rt = dest reg / immidiate value (not a reg)
3. jump (instruction) + target address => j addition (example)

#MIPS Syscall Services (invoke OS for action)

print_int    $a0 1 // int val
print_string $a0 4 // & string
print_char   $a0 11 // char to print
read_int     $v0 5 // contains integer to read 
read_string  $a0 8 // $a0 & input buffer / $a1 max char to read
read_char    $v0 12 // character to print
sbrk         $a0 $v0 9 // total bytes to alloc / address of allocated mem
exit         10 (li $v0 10 syscall)
open_file    $v0 $a0 (filename) / $a1 (flags) / $a2 (mode) 13
read_from_file $v0 (nb char read) $a2(max nb of char read)/ $a1(& input buf) / $a0(file descriptor)
write_to_file $v0 (nb of char to write) $a2 (nb of char write) $a1 (& of output buffer) $a0 (file descriptor)
close_file $a0 16 / file descriptor
print_int_hex $a0 34
print_int_bin $a0 35

#Register (32-bit wide)
.ascii = string data without '\0'
.asciiz = string data with '\0'
.halfword (16bits)
.byte (8bits)
.word (32bits)
.doubleword (64bits
.float = 1.1 (only one decimal)
.double = 1.33 (xx decimal)
-load = copies a bit from mem to reg
-store = copies a bit from reg to mem

1.machine instruction in hex 0 1 0 9 5 0 2 1 (nb in hex)
2.machine instruction in bits 4 4 4 4 4 4 4 4 (nb bits)
3.fields of the instruction 6 5 5 5 5 6 (nb bits)
4.meaning of the fields (opcode oprnd oprnd dest ----- 2ndary)
(ALUop $8 $9 $10 ____  addu)

$0 -> zero : 0 (always 32bits)
$1 -> $at : assembler temp (reserved) 
$2 - $3 -> $v0 - $v1 : value return by subroutine
$4 - $7 -> $a0 - $a3 : arg to a subroutine
$8 - $15 -> $t0 - $t7 : temp
$16 - $23 -> $s0 - $s7 : save reg
$24 - $25 -> $t8 - $t9 : temp
$26 - $27 -> $k0 - $k1 : kernel (reserved OS)
$28 -> $gp -> global *
$29 -> $sp -> stack *
$30 -> $fp -> frame *
$31 -> $ra -> return &

#Model machine Cycle
1. Fetch the instruction from the & in the Program counter
2. ++ the program counter
3. Exec the cmd

*Instruction next to each other but can jump (jal) to a particular branch
*Basic operation : arithmetic / logic / mem access / control branches
*32bits adress space but only 16 for the user (text data stack)

-Bitwise : OR / AND (logical operation on each operand) = don't need to have the same size of bit
ori = or (1 0 = 1 / 0 0 = 0 / 1 1 = 1) (immidiate value)
andi = and (1 1 = 1 / 0 1 = 0) -> andi d, s, const () (immidiate value)
xori = exclusive or (1 0 = 1 / 0 1 = 0) (immidiate value)
or / and / xor / nor = not immidiatly value
or -> or d, s, t
nor (0 0 = 1)
not = nor d, s, $0 # $d <- bitwise NOT of $s
or d, s, $0 # $d <- content $s ==> Move as Or with Zero

-Shift : sll / srl // TODO : LEARN CHAP 12
Example:
sll d, s, shft (0 <= shft < 32) => srl same but to the right
shft = 2
10100111 -> 01001110
#no-op (the no operation) is usefull in MIPS

############Integer arithmetic. Moving data to and from mem
u = (no overflow, unsigned operand)
****ADDITION
addu d, s, t # s + t -> d (no overflow trap)
add d, s, t # s + t -> d (overflow trap)

Example:
####ori $8, $0, 0xAB # put 0x000000AB into $8 // we can do the same with decimal (no 0x)
    ori $9, $0, 0x55 # put 0x00000055 into $9
    addu $10, $9, $8
####Reflect
nor $8, $8, $9
add one to $9
ori $9, $0, 1
addu $8,  $8, $9
##Put in neg (addu)
ori $8, $0, 82 #put 82 into $8
nor $8, $8, 0 #reflect
ori $9, $0, 1 #put 1 into $9
addu $8, $8, $9 #add 1: $8 = -82
##Same in addiu (immidiate) ++performance
ori $7, $0, 146 #put +146 into $7
addiu $10, $7, -82 # add -82

****SUBSTRACTION (no immidiate sub only do immidiate sub with addiu)
subu d, s, t # s - t -> d (no overflow trap)
sub d, s, t # s - t -> d (overflow trap)

Example to do 5 * x - 74:
ori $8, $0, 12 #put x into $8
sll $9, $8, 2 # $9 = 4x (shift left of 2)
addu $9, $9, $8 # $9 = 5x
addiu $9, $9, -74 # $9 = 5x - 74

****MULTIPLICATION
mult s, t # $s *$t -> hilo (two's comp operands)
multu s, t # $s * $t -> hilo (unsigned operands)

Only with product and do it after each operation (WTF)
mfhi d # d <- hi move from hi (multu ?)
mflo d # d <- lo move from lo (mult)

Example:
ori $8, $0, 12 #put x into $8
ori $9, $0, 5 #put 5 into $9
mult $9, $8 #lo = 5x
mflo $9 #$9 = 5x
addiu $9, $9, -74

****DIVISION

div s, t # mflo <- s div t
         # mfhi <- s mod t
divu s, t # mflo <- s div t
         # mfhi <- s mod t
Pretty much like mult but need:
mflo $10 = quotient
mfhi $11 = remaider

****ARITHMETIC SHIFT (not for '-')
sra d, s, shft # d <- s shifted right (shft pos) ==> division by 2

#Mem Access Inst
op for arith and logic = register!
load = copies data from main mem into reg
store = copies data from reg into main mem

lw = load word into reg from mem // lw $8, 0x60($10)
sw = store word from reg into mem // sw $12, 0xFFF8($13) or sw $12, -8($13)

lui $13, 0x0004 => lw immidiate
ori (fills in the lower 16bits)
-ori $13, $13, 0x5000 => upper half same and OR for the other
-ori $10, $0, 0x00C4 => replaces bits with the zero-extended immediate 

EXAMPLE:
	#SAVE AND RESTORE REGISTER WITH STACK
	#addi $sp, $sp, -4 // add $s0 to the fct with load stack 
	#sw $s0, 0($sp)
	#addi $s0, $s0, 30
	#li $v0, 1
	#move $a0, $s0
	#syscall
	#lw $s0, 0($sp) // restore value of the stack
	#addi $sp, $sp, 4
	
	#NESTED FUNCTION JAL WORKS
	#addi $sp, $sp, -4 #// add $s0 to the fct with load stack 
	#sw $ra, 0($sp)
	##ADD FUNCTION HERE
	#lw $ra, 0($sp) #// restore value of the stack
	#addi $sp, $sp, 4
	
	# beq(=) / sle(<=) / bge(>=) / blt(<) / bgtz(> 0)
	
	#WHILE
	#li $t0, 0
	#while:
	 #bgt $t0, 10 exit
	 #addi $t0, $t0, 1 # i++
	 #j while
	#exit:
	
	##ARRAY (name: .space n)
    # sw assign value / get elem
	#li $t0, 0
	#sw $s0 array($t0) (assign value to the pos)
	#	addi $t0, $t0, 4 (pos++) // this how we add element
	#lw $t1, array($zero) //  load element at pos 0 to the temp $t1
	#while: 
	#	beq $t0, 12(size of tab), exit
	#	lw $t1, array($t0)
	#	li $v0, $t1
	#	move $a0, $t1
	#	syscall
	#	addi $t0, $t0, 4
	#	j while
	#exit:
	
	#sw $v0, nameVar (work with a .data var) // save the return value into the variable
	#lw $a0, namevar // load the var into the arg 0
	
	### COUNTING LETTER
	#loop:
	# beq $t0, $a1, exit #while $t0 < $a1 
	# add $t1, $a0, $t0 # assign at $t1 the adress of the array $a0 at $t0 (t1 = &A[i])
	# lb $t2, 0($t1) #because its a char 'lb'=> load byte for the offset 0 of the adress $t1 (t2 = A[i] 
	# bne $t2, $a0, skip
	# add $v1, $v1, 1
	# skip:
	# add $t0, $t0, 1
	# j loop
	# exit:
	# jr $ra
	
#malloc:                 # procédure d'allocation dynamique
#        li $v0, 9       # appel système n. 9 
#        syscall         # alloue une taille a0 et
#        j  $ra          # retourne le pointeur dans v0