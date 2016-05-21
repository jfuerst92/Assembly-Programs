TITLE Basic Arithmetic   (Sum.asm)

; Author: Joseph Fuerst
; Date: 4/8/2016
; Description: This program displays the Author's name and the title, asks the user for two numbers, and calculates and prints the sum, difference, product, quotient and remainder of them.
; EC: Program verifies second number less than first.
; EC: Program repeats until user chooses to quit

INCLUDE Irvine32.inc

.data

firstNum	DWORD	?	;integer to be entered by user
secondNum	DWORD	?	;integer to be entered by user	
decision	DWORD	?	;checks whether the user wants to try two more numbers
intro_1		BYTE	"Basic Arithmetic         by Joseph Fuerst", 0
intro_2		BYTE	" Enter 2 numbers. I'll then calculate the sum, difference, product, quotient, and remainder of them.", 0
extra_1		BYTE	"**EC: Program verifies second number less than first.", 0
extra_2		BYTE	"**EC: Program lets user repeat until they choose to quit.", 0
prompt_1	BYTE	"Enter a number.", 0
prompt_2	BYTE	"Now enter another number. ", 0
error_1		BYTE	"The second number must be less than the first! Try again!", 0
prompt_3	BYTE	"The sum is ", 0
prompt_4	BYTE	"The difference is ", 0
prompt_5	BYTE	"The product is ", 0
prompt_6	BYTE	"The quotient is ", 0
prompt_7	BYTE	" is the remainder. ", 0
retry		BYTE	"Enter 1 to try again. ", 0
res_sum		DWORD	? ;stores the sum
res_prod	DWORD	? ;stores the product
res_dif		DWORD	? ;stores the difference
res_quo		DWORD	? ;stores the quotient
res_rem		DWORD	? ;stores the remainder

goodBye		BYTE	"Goodbye, friend! ", 0

.code
main PROC

;Introduce program, programmer, and explain extra credit attempted
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf   ;new line
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_1
	call	WriteString
	call	CrLf   
	mov		edx, OFFSET extra_2
	call	WriteString
	call	CrLf  

L1: ;If invalid secondNum is entered, return here

;get first number and store it in firstNum
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	readInt
	mov		firstNum, eax
	call	CrLf

;get second number and store it in secondNum
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	readInt
	mov		secondNum, eax
	call	CrLf

;compare firstNum and secondNum. If secondNum is higher, jump to INVAL, otherwise continue to calculation
	mov		eax, secondNum
	cmp		eax, firstNum
	ja		INVAL
	jmp		CALC

INVAL: ;jump here if secondNum is greater than first
	mov		edx, OFFSET error_1
	call	WriteString
	call	CrLf
	jmp		L1 ;get two new numbers 

CALC: ;jump here if numbers are valid

;calculate product and store in res_prod
	mov		edx, OFFSET prompt_5
	call	WriteString
	mov		eax, firstNum
	mov		ebx, secondNum
	mul		ebx
	mov		res_prod, eax
	call	WriteDec
	call	CrLf

;calculate sum and store in res_sum
	mov		edx, OFFSET prompt_3
	call	WriteString
	mov		eax, firstNum
	mov		ebx, secondNum
	add		eax, ebx
	mov		res_sum, eax
	call	WriteDec
	call	CrLf

;calculate difference and store in res_dif
	mov		edx, OFFSET prompt_4
	call	WriteString
	mov		eax, firstNum
	mov		ebx, secondNum
	sub		eax, ebx
	mov		res_dif, eax
	call	WriteDec
	call	CrLf

;calculate quotient and remainder, store in res_quo and res_rem
	mov		edx, OFFSET prompt_6
	call	WriteString
	mov		eax, firstNum
	cdq     ;needed for unsigned integer division
	mov		ebx, secondNum
	div		ebx
	mov		res_quo, eax
	call	WriteDec
	call	CrLf
	mov		res_rem, edx
	mov		eax, res_rem
	call	WriteDec
	mov		edx, OFFSET prompt_7
	call	WriteString
	call	CrLf

;retry
	mov		edx, OFFSET retry
	call	WriteString
	call	readInt
	mov		decision, eax
	cmp		decision, 1
	je		L1
	


;say "goodbye" and exit the program
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf   ;new line i think

	exit	; exit to operating system
main ENDP



END main