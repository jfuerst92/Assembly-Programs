TITLE Random Numbers     (RandomNumbers.asm)

; Author: Joseph Fuerst
; Date: 5/21/2016
; Description: This program will ask the user to enter an amount of numbers they want to be generated. It then generated them in the range of 100 to 999. it then sorts 
; them from larges to smallest and prints them again.

INCLUDE Irvine32.inc

	MIN = 10	;min value that the user may enter
	MAX = 200	;max value that the user may enter
	LO = 100	;the lowest random number to be generated
	HI = 999	;the hightest random number to be generated

.data

	intro_1		BYTE	"Average of Integers         by Joseph Fuerst", 0
	intro_2		BYTE	"This program will ask you for an amount of random integers to generate. Then it will generate that many integers in the range of 100-999.",0
	intro_3		BYTE	"It will then display the integers, sort them by size, calculate and display the median value, then print out the sorted list.",0
	prompt_1	BYTE	"Enter an amount of random numbers to generate between 10 and 200:",0
	error		BYTE	"That number is out of range! Try again!",0
	median		BYTE	"The median is: ",0

	request		DWORD	?  ;the amount requested to be generated
	array		DWORD	MAX		DUP(?)	;the array to be filled with random numbers
	ulist		BYTE	"This is the unsorted list:",0
	olist		BYTE	"This is the sorted list:",0
	spacing		BYTE	"     ",0 ;Spacing to make list easy to read.
	


.code
main PROC
;This is what will give us our random numbers, and ensure each time the numbers are different.
	call	RANDOMIZE		
	call	introduction
;Get and validate data from the user.
	push	OFFSET request
	call	getData
;Fill the array with that many random numbers
	push	OFFSET array
	push	request
	call	fillArray
;print the list
	push	OFFSET array
	push	request
	push	OFFSET ulist
	call	dispList
;sort the list large to small
	push	OFFSET array
	push	request
	call	sortList
;display the median value
	push	OFFSET array
	push	request
	call	dispMedian
;print the list once more
	push	OFFSET array
	push	request
	push	OFFSET olist
	call	dispList


	exit	; exit to operating system
main ENDP

;----------------------------------------------------------------------------
;| Function: introduction
;| Description: Explains program and author
;| Parameters: none
;----------------------------------------------------------------------------

introduction PROC
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	ret
introduction ENDP

;----------------------------------------------------------------------------
;| Function: getData
;| Description: Gets and validates data from the user
;| Parameters: request(DWORD)
;----------------------------------------------------------------------------


getData PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp+8]	;address of request var
	jmp		START
ERR:						;jump here if the number is out of range
	mov		edx, OFFSET error 
	call	WriteString
	call	CrLf
START:
	mov		edx, OFFSET prompt_1
	call	WriteString
	
	call	ReadInt
	cmp		eax, MAX		;compare number vs max and min
	jg		ERR
	cmp		eax, MIN
	jl		ERR
	mov		[ebx], eax
	pop		ebp
	ret		4

getData ENDP

;----------------------------------------------------------------------------
;| Function: fillArray
;| Description: Fill the array with random numbers
;| Parameters: Array(DWORD), request(DWORD)
;----------------------------------------------------------------------------


fillArray PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]	;request
	mov		edi, [ebp+12]	;array
CONT:
	mov		eax, HI			;get the range to generate within
	sub		eax, LO
	inc		eax 
	call	RandomRange		;get the random number
	add		eax, LO			;add the low number to ensure it's within 100-999
	mov		[edi], eax		;store the number in the current index of the array
	add		edi, 4			;increment the index
	loop	CONT
	pop		ebp
	ret		8
fillArray ENDP

;----------------------------------------------------------------------------
;| Function: sortList
;| Description: sort the numbers in the array large to small, based on Kip Irvines
;| bubbleSort algorithm in Assembly Language for x86 Processors, 7th edition
;| Parameters: Array(DWORD), request(DWORD)
;----------------------------------------------------------------------------


sortList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]	;request
	dec		ecx				;decrement to get proper array index
OL:
	push	ecx				;store the current index on the stack
	mov		esi, [ebp+12]   ;array
IL:
	mov		eax, [esi]      ;get the first element in the array
	cmp		eax, [esi+4]    ;compare it to the next element
	jg		NFOUND          ;if the first element is greater, no need to swap
	xchg	eax, [esi+4]	;else, swap the two numbers
	mov		[esi], eax
NFOUND:
	add		esi, 4			;move to the next element
	loop	IL				;do this for every element . Now the highest element is in the right spot.
	pop		ecx				;pop and decrement the outer count
	loop	OL				

	pop		ebp
	ret		8


sortList ENDP

;----------------------------------------------------------------------------
;| Function: dispMedian
;| Description: Display the median value in the list
;| Parameters: Array(DWORD), request(DWORD)
;----------------------------------------------------------------------------


dispMedian PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+8]	;request
	mov		esi, [ebp+12]	;array
	mov		ebx, 2
	mov		edx, 0  
	div		ebx				;divide request number by two to get index of middle. 
	mov		ebx, 4			;multiply by 4 to get the right address index.
	mul		ebx
	mov		eax, [esi+eax]  ;store the number at the median index
	mov		edx, OFFSET median
	call	CrLf
	call	WriteString
	call	WriteDec
	call	CrLf
	pop		ebp
	ret		8	
dispMedian ENDP

;----------------------------------------------------------------------------
;| Function: dispList
;| Description: Displays each element in the list, 10 elements per line.
;| Parameters: Array(DWORD), request(DWORD), olist/ulist(BYTE)
;----------------------------------------------------------------------------


dispList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+12]	;request
	mov		esi, [ebp+16]	;array
	mov		ebx, 0			;counter for break

	mov		edx, [ebp+8]	;olist or ulist
	call	WriteString		;say what kind of list this is
	call	CrLf
PRINTNEXT:					;print each element
	mov		eax, [esi]
	call	WriteDec
	mov		edx, OFFSET spacing ;spacing for each number
	call	WriteString
	inc		ebx				;increment counter
	cmp		ebx, 10			;when counter is greater than 10, call CrLf and set ebx back to 0
	jl		CNT				;if its less, than skip the next two lines
	call	CrLf
	mov		ebx, 0
CNT:
	add		esi, 4			;increment the index
	loop	PRINTNEXT		;loop until all numbers are printed.
	pop		ebp
	ret		12

dispList ENDP



END main