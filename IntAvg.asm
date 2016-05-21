TITLE Average of Integers    (IntAvg.asm)

; Author: Joseph Fuerst
; Date:5/1/2016	
; Description: This program asks the users name, repeatedly prompt the user for a number between -100 and -1 until a non negative
; number is entered, sums the numbers up, and finds the average  of those numbers.
; EC** Program will number the lines of user input

INCLUDE Irvine32.inc

LOWER_LIMIT	= -100 ;lowest number the user can enter without generating error.

.data

intro_1		BYTE	"Average of Integers         by Joseph Fuerst", 0
prompt_1	BYTE	"What is your name?", 0
userName	BYTE	33 DUP(0)	;users name
prompt_2	BYTE	"Enter numbers between -100 and -1 and I'll calculate the average of them!", 0
prompt_3	BYTE	" Enter a non-negative number to stop entering numbers.", 0
error_1		BYTE	"Sorry, that number is too low, so it wont be counted.", 0
continue	BYTE	" Enter another number between -100 and -1.", 0
extra_1		BYTE	"**EC: Program will number the lines of user input.", 0

lineNum		SDWORD	1 ;counts line numbers
curNum		SDWORD  ? ;current entered number
numberSum	SDWORD	0 ;current total of entered numbers
numAmount	DWORD	0 ;amount of numbers entered
res_quo		SDWORD	? ;stores the quotient
res_rem		SDWORD	? ;stores the remainder
rounder		DWORD	? ;determines whether to round up or down
numAvg		SDWORD	? ;average of numbers entered	

prompt_4	BYTE	"The sum of the numbers you entered is: ", 0
prompt_5	BYTE	"The average of the numbers you entered is: ", 0
goodBye		BYTE	"Goodbye, ", 0

.code
main PROC

;Introduce program, programmer, and explain extra credit attempted
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_1
	call	WriteString
	call	CrLf   

;Get user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

	jmp		FIRSTTRY	;jumps over invalid entry code
TOOLOW:                 ;jump here when invalid number entered
	mov		edx, OFFSET error_1
	call	WriteString
	call	CrLf
	jmp		CNT
FIRSTTRY:               ;first number entry
;Program function is explained and user begins entering numbers
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	mov		eax, lineNum
	call	WriteDec
	inc		eax
	mov		lineNum, eax
	mov		edx, OFFSET prompt_3
	call	WriteString
	jmp		CNTPSKIP ;skips CNT for first loop
CNT:
	mov		eax, lineNum
	call	WriteDec
	inc		eax
	mov		lineNum, eax
	mov		edx, OFFSET continue
	call	WriteString
CNTPSKIP:
	
	call	ReadInt
	cmp		eax, 0
	jge		NEND         ;if number is positive, exit loop and calculate average
	cmp		eax, LOWER_LIMIT
	jl		TOOLOW
	mov		curNum, eax
	inc		numAmount
	mov		eax, curNum
	add		eax, numberSum
	mov		numberSum, eax
	jmp		CNT

;display sum
NEND:
	mov		edx, OFFSET prompt_4
	call	WriteString
	mov		eax, numberSum
	call	WriteInt
	call	CrLf
;Calculate average
	cdq
	mov		ebx, numAmount
	idiv	ebx
	mov		res_quo, eax
	mov		res_rem, edx
	neg		edx          ;get positive remainder
	mov		eax, edx     ;calculate whether to round up or down
	sub		ebx, eax     
	cmp		ebx, eax
	jl		ROUNDUP     
	jmp		NOROUND
ROUNDUP:    ;if decimal remainder is greater than .5
	mov		eax, res_quo
	dec		eax
	mov		edx, OFFSET prompt_5
	call	WriteString
	call	WriteInt
	call	CrLf
	jmp		FIN
NOROUND:    ;if decimal remainder is less than .5
	mov		eax, res_quo
	mov		edx, OFFSET prompt_5
	call	WriteString
	call	WriteInt
	call	CrLf
FIN:	
;say "goodbye" and exit the program
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf   

	exit	; exit to operating system
main ENDP


END main