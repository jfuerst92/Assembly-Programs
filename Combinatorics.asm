TITLE Project 6B Combinatorics     (Combinatorics.asm)

; Author: Joseph Fuerst
; Course / Project ID   CS271 Project6B          Date: 5/21/2016
; Description: This program will ask the user to enter an amount of numbers they want to be generated. It then generated them in the range of 100 to 999. it then sorts 
; them from larges to smallest and prints them again.

;mWriteString macro is taken from demo8.asm by Paulson
;inputString reading compiled from various Stack overflow posts and reading the Irvine library documentation

INCLUDE Irvine32.inc

NLO = 3
NHI = 12
RLO = 1


mWriteString	MACRO	buffer
	push	edx				;Save edx register
	mov	edx, OFFSET buffer
	call	WriteString
	pop	edx				;Restore edx
ENDM

.data

intro_1		BYTE	"Combinatorics Practice          by Joseph Fuerst",0
intro_2		BYTE	"This program will give you a combinatorics problem and you will have to supply the answer. The program will tell you if you're right or wrong, then give you another until you choose to quit.",0
prompt_1	BYTE	"The number of elements in the set is: ",0
prompt_2	BYTE	"The number of elements choosing is: ",0
prompt_3	BYTE	"Enter the number of possible combinations:",0
res_1		BYTE	"The correct answer is: ",0
correct		BYTE	"Nice job! You got it right!",0
wrong		BYTE	"Sorry! looks like you need more practice.",0
error		BYTE	"What you entered is not valid.",0

rpt			BYTE	"Do you want to try again? Enter y to try again or enter any other letter to quit:", 0
goodbye		BYTE	"Goodbye and good luck!",0
inputStr	BYTE	80 DUP(0)
nNum		DWORD	?   ;number in set
rNum		DWORD	?   ;number choosing
inputNum	DWORD	?	;user guess
answer		DWORD	?	;actual answer
nFact		DWORD	?
rFact		DWORD	?
nrFact		DWORD	?
userChoice	BYTE	3 DUP(?)
lY			BYTE	"y", 0
cY			BYTE	"Y", 0


.code
main PROC

	call	RANDOMIZE		;ensure that numbers are generated different every time
;introducte the program and author
	call	intro			
AGAIN:		;jump here when the user wants to go again
	call	CrLf
	call	CrLf

;show the user a random problem
	mov		inputNum, 0
	push	OFFSET	nNum
	push	OFFSET	rNum
	call	showProblem

;get the user inputted data
	push	OFFSET inputStr		;ebp+12
	push	OFFSET inputNum		;ebp+8
	call	getData

;Calculate the answer and store it in answer
;This will  also call factorialCalc
	push	OFFSET nFact		;ebp+28
	push	OFFSET rFact		;ebp+24
	push	OFFSET nrFact		;ebp+20
	push	nNum				;ebp+16
	push	rNum				;ebp+12
	push	OFFSET answer		;ebp+8
	call	combinations

;print the results and tell the user whether or not they're right.
	push	inputNum			;ebp+12
	push	answer				;ebp+8
	call	showResults

;Ask the user if they want to get another problem or if they want to quit.
	mWriteString	rpt
	mov		edx, OFFSET userChoice
	mov		ecx, 79
	call	ReadString
	mov		esi, OFFSET userChoice
	mov		edi, OFFSET lY
	cmpsb
	je		AGAIN
	mov		esi, OFFSET userChoice
	mov		edi, OFFSET cY
	cmpsb
	je		AGAIN
	mWriteString	goodbye
	exit	; exit to operating system
main ENDP

;----------------------------------------------------------------------------
;| Function: introduction
;| Description: Explains program and author
;| Parameters: none
;----------------------------------------------------------------------------
intro PROC
	;mWriteString [ebp+12]
	mWriteString intro_1
	call	CrLf
	;mWriteString [ebp+8]
	mWriteString intro_2
	call	CrLf
	ret		
intro ENDP

;----------------------------------------------------------------------------
;| Function: showProblem
;| Description: Shows a random combinatorics problem to the user.
;| Parameters: nNum(ebp+12), rNum(ebp+8)
;----------------------------------------------------------------------------

showProblem PROC
	push	ebp
	mov		ebp, esp
	mov		eax, NHI			;get range for nNum
	sub		eax, NLO
	inc		eax
	call	RandomRange
	add		eax, NLO
	mov		ebx, [ebp+12]		;nNum
	mov		[ebx], eax			
	mWriteString	prompt_1
	call	CrLf
	call	WriteDec
	call	CrLf
	sub		eax, RLO			;get range for rNum
	inc		eax
	call	RandomRange
	add		eax, RLO
	mov		ebx, [ebp+8]		;rNum
	mov		[ebx], eax
	mWriteString	prompt_2
	call	CrLf
	call	WriteDec
	call	CrLf
	
	pop		ebp
	ret		8

showProblem ENDP

;----------------------------------------------------------------------------
;| Function: getData
;| Description: Gets and validates data from the user
;| Parameters:inputStr(ebp+12), inputNum(ebp+8)
;----------------------------------------------------------------------------

getData PROC
	push	ebp
	mov		ebp, esp
	jmp		CNT1				;jump to skip the error statement

ERR:
	mWriteString error
	call	CrLf
CNT1:
	mov		eax, 0
	mov		ebx, [ebp+8]		;inputNum
	mWriteString prompt_3
	mov		edx, [ebp+12]		;inputStr
	mov		ecx, 79
	call	ReadString
	mov		ecx, eax
	mov		esi, [ebp+12]


CNT2:							;reads each character in the string and appends the number to inputNum
	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		ebx, 10
	mul		ebx
	mov		ebx, [ebp+8]
	mov		[ebx], eax
	mov		al, [esi]
	cmp		al, 57				;make sure the charadcter is valid
	jg		ERR
	cmp		al, 48
	jl		ERR
	inc		esi
	sub		al, 48

	mov		ebx, [ebp+8]
	add		[ebx], al

	loop	CNT2				;get the next character

	pop		ebp
	ret		4


getData ENDP

;----------------------------------------------------------------------------
;| Function: combinations
;| Description: calculates the number of combinations
;| Parameters:nFact (ebp+28), rFact (ebp+24), nrFact (ebp+20), nNum (ebp+16), rNum(ebp+12),answer (ebp+8)
;----------------------------------------------------------------------------

combinations PROC
	push	ebp
	mov		ebp, esp
	push	[ebp+16]			;nNum
	call	factorialCalc		;calc n!
	mov		ebx, [ebp+28]		;nFact
	mov		[ebx], eax
	push	[ebp+12]
	call	factorialCalc		;calc r!
	mov		ebx, [ebp+24]		;rFact
	mov		[ebx], eax
	mov		ebx, [ebp+16]
	sub		ebx, [ebp+12]
	push	ebx
	call	factorialCalc		;calc (n-r)! Now, just do the multiplication and division
	mov		ebx, [ebp+20]		;nrFact
	mov		[ebx], eax
	mov		ebx, [ebp+24]
	mov		ebx, [ebx]
	mul		ebx
	mov		edx, 0
	mov		ebx, eax
	mov		eax, [ebp+28]
	mov		eax, [eax]
	div		ebx
	mov		ebx, [ebp+8]
	mov		[ebx], eax
	pop		ebp
	ret		24


combinations ENDP

;----------------------------------------------------------------------------
;| Function: combinations
;| Description: recursively calculates the number of combinations
;| rNum, nNum or nrNum(ebp+8)
;----------------------------------------------------------------------------

factorialCalc PROC
	push	ebp
	mov		ebp, esp
	
	mov		eax, [ebp+8]		;num to be calculated
	cmp		eax, 0				;check that the base case is not met(num is 0)
	ja		CNT					;jump to recursive call
	mov		eax, 1				;base case 0! = 1
	jmp		FIN					;return
CNT:
	dec	eax						
	push eax
	call factorialCalc			;call factorial with num - 1
	mov		ebx, [ebp+8]		;after returning, multiply
	mul		ebx
FIN:
	pop		ebp					;return
	ret		4

factorialCalc ENDP
;----------------------------------------------------------------------------
;| Function: combinations
;| Description: calculates the number of combinations
;| Parameters:inputNum (ebp+12) answer (ebp+8)
;----------------------------------------------------------------------------
showResults PROC
	push	ebp
	mov		ebp, esp
	mWriteString res_1
	mov		eax, [ebp+8]
	call	WriteDec
	call	CrLf
	mov		ebx, [ebp+12]
	cmp	eax, ebx
	je		R
	jmp		W
R:
	mWriteString correct
	call	CrLf
	jmp DN
W:
	mWriteString wrong
	call	CrLf
DN:
	pop		ebp
	ret		8

showResults ENDP

END main