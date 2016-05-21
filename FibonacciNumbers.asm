TITLE Fibonacci Numbers   (FibonacciNumbers.asm)

; Author: Joseph Fuerst
; Date: 4/13/2016
; Description: This program displays the Author's name and the title, asks the user for their nameand the number of Fibonacci numbers they want displayed.
; Then it calculates and prints that many numbers.

INCLUDE Irvine32.inc

UPPER_LIMIT		= 46 ;constant, max fibonacci number that DWORD can handle

.data

intro_1		BYTE	"Fibonacci Numbers         by Joseph Fuerst", 0

prompt_1	BYTE	"What is your name?", 0
userName	BYTE	33 DUP(0)	;users name
invalidNum	BYTE	"That number was not between 1 and 46! Try again!", 0	
prompt_2	BYTE	"Enter a number between 1 and 46 and I'll calculate that many Fibonacci numbers!", 0
maxNum		DWORD	? ;number to calculate Fibonacci numbers
currNum		DWORD	? ;current number in the sequence to be printed
firstNum	DWORD	0 ;start of fibonacci sequence
SecondNum	DWORD	1 ;next number to be added in sequence
spacing		BYTE	"     ", 0 ;spacing for the numbers
countBreak	DWORD	0 ;counter to insert a line break every 5 numbers
goodBye		BYTE	"Goodbye, ", 0



.code
main PROC

;Introduce program, programmer, and explain extra credit attempted
	mov		edx, OFFSET intro_1
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
INVALID:	;Jump here if invalid number is entered
	mov		edx, OFFSET invalidNum
	call	WriteString
	call	CrLf
FIRSTTRY:
;Get amount of Fibonacci numbers to calculate
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	call	ReadInt
	cmp		eax, UPPER_LIMIT	;check if number entered is greater than 46
	jg		INVALID
	cmp		eax, 1  ;check if number entered is less than 46
	jl		INVALID
	mov		maxNum, eax ;assign number to maxNum if correct
			
;calculate fibonacci numbers
	mov		ecx, MaxNum
	mov		edx, OFFSET spacing
	mov		eax, 1 ;special case, print 1 then calculate as normal
	call	WriteInt
	call	WriteString
	jmp		CNT ;jump to increment linebreak count for special case 1. 
L1: ;loop jumps here to print each number until the end
	mov		eax, firstNum
	mov		ebx, secondNum
	add		eax, ebx
	mov		currNum, eax
	call	WriteInt
	call	WriteString
	mov		firstNum, ebx
	mov		secondNum, eax
CNT:
	inc		countBreak
	cmp		countBreak, 5
	je		BREAK
	jmp		NOBREAK
BREAK:
	call	CrLf
	mov		countBreak, 0
NOBREAK:
	loop	L1
;Say goodbye to user
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main