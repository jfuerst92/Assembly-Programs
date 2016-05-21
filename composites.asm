TITLE Composite Numbers    (composites.asm)

; Author: Joseph Fuerst
; Date:5/5/2016
; Description: A program that calculates the amount of composite numbers that a user requests.

INCLUDE Irvine32.inc

UPPER_LIMIT = 400
LOWER_LIMIT = 1

.data

intro_1		BYTE "Composite Number Calculator    -by Joseph Fuerst",0
intro_2		BYTE "This program will calculate a number of composite numbers as specified by the user.",0
prompt_1	BYTE "Enter a number between 1 and 400, and I will give you that many composite numbers.",0
error_1		BYTE "Sorry, that number is out of range, try again!",0
goodBye		BYTE "Hope you enjoyed your numbers!",0
extra_1		BYTE "EC** The output is spaced into even columns."

compNum		DWORD ?
isComp		DWORD 0
lgFactor	DWORD ?
curNum		DWORD 4
smSpacing	BYTE "     ",0
medSpacing	BYTE "      ",0
bigSpacing	BYTE "       ",0
break		DWORD 0




.code
main PROC
	call introduction
	call getUserData
	call showComposites
	call farewell

	exit	; exit to operating system
main ENDP


;Introduces title of program and and author, explains program
introduction PROC
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_1
	call	WriteString
	call	CrLf
introduction ENDP

;prompt the user to enter the number of composites they want
getUserData PROC
INVALID:    ;jump here if number entered is invalid
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		ebx, 0
	call	validate
	cmp		ebx, 0
	je		INVALID
	mov		compNum, eax
	call	CrLf
	ret
getUserData ENDP

;validates that the number entered is between 1 and 400
validate PROC
	cmp		eax, UPPER_LIMIT
	jg		ERROR
	cmp		eax, LOWER_LIMIT
	jl		ERROR
	jmp		VALID
ERROR:		;if number is not valid
	mov		ebx, 0
	mov		edx, OFFSET error_1
	call	WriteString
	ret
VALID:		;if the number is valid
	mov		ebx, 1
	ret

validate ENDP

;calculates and prints the correct amount of composite numbers, starting with 4
showComposites PROC
	mov		ecx, compNum
NEXT:		;returns here after the first number is checked
	mov		isComp, 0
	call	isComposite
	cmp		isComp, 1
	jne		NOTCOMP ;number is not composite
	mov		eax, curNUm ;otherwise, print number
	call	writeDec
	cmp		eax, 10							;Extra credit to align output
	jl		BIG
	cmp		eax, 100
	jl		MED
	jmp		SMALL
BIG:		;spacing for numbers between 0 and 9
	mov		edx, OFFSET bigSpacing
	call	writeString
	jmp		SPACED
MED:		;spacing for numbers < 100
	mov		edx, OFFSET medSpacing
	call	writeString
	jmp		SPACED
SMALL:		;spacing for the rest of the numbers about
	mov		edx, OFFSET smSpacing
	call	writeString
SPACED:		;jump here after inserting spacing

	inc		break  ;tests whether a break is needed
	cmp		break, 10
	jge		BRK
	jmp		CNT
BRK:		;jump here if a break is needed
	call	CrLf
	mov		break, 0
CNT:		;jump here if break is not needed
	inc		curNum
	loop	NEXT
	jmp		CFIN
NOTCOMP:	;jump here is not composite
	inc		curNum
	jmp		NEXT
CFIN:
	ret
showCOmposites ENDP

;This tests each number to see if it is not prime
isComposite PROC
	push	ecx
	mov		ecx, curNum
NFOUND:		
	mov		lgFactor, 0
	mov		ebx, ecx
	dec		ebx ;number is obviously divisibly by itself, so dec first to skip that case.
	cmp		ebx, 1
	je		ENDL
	mov		edx, 0
	mov		eax, curNum
	div		ebx

	cmp		edx, 0	;if remainder is zero, then it's composite
	je		FOUND
	loop	NFOUND
	jmp		ENDL
FOUND:		;jump here if num is composite
	mov		lgFactor, 1
ENDL:		;jump when num is not composite
	cmp		lgFactor, 1
	jne		RETURN
	mov		isComp, 1
RETURN:		;jump when composite is found
	pop		ecx
	ret	
	
isComposite ENDP


;final message to the user
farewell PROC
	mov		edx, OFFSET goodBye
	call	WriteString
	ret
farewell ENDP

END main


