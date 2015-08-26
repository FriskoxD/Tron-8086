; Program: TRON
; File: MISC.ASM
;
; Author: Jan De Groot <jan.degroot@live.be>
; Author: Khaled Radmal
;
; Copyright 2015 under the Raindrop License Agreement V1.1.
; If you did not receive a copy of the Raindrop License Agreement 
; with this Software, please contact the Author of the Software.
;

.MODEL small ; one data and one code segment, stack and data segment are grouped
.STACK 1024  ; stack, 1024 bytes
.DATA        ; data segment, global variables
include VAR.INC
include SETTINGS.INC
.CODE        ; code segment

generateRandom PROC NEAR PUBLIC
	
	;----------------------------------------------------
	; generateRandom
	;----------------------------------------------------
	;ARGUMENTS:
	; -[STACK] Minimum Value
	; -[STACK] Difference between minimum and maximum value (maximum - minimum)
	;
	;RETURNS:
	; -AX: The random value.
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; Generates a random number.
	;
	;DETAILED DESCRIPTION:
	; Gets the ticks from the system clock. Applies a bit shift to prevent the same value being generated multiple times within the same tick.
	; Then applies a linear transformation to scale it within the new bounds.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push bx
	push cx
	push dx
	push si
	
	; Generate a random number
	; Get the system ticks since midnight
	mov ah, 00h     
	int 1Ah
	
	differenceMinimumMaximum equ [bp+4]
	minimumValue equ [bp+6]
	
	; Now map it to the settings specified in the SETTINGS file
	mov cl, bitShiftRandom
	rcr dl, cl ; If this code is executed in multiple times in sequence things aren't quite random enough any more. This allows us to mix things up a bit.
	xor ah, ah
	mov al, dl ; Store the random number (0->255)
	mov bl, 100
	mul bl ; Multiply it by 100 to keep accuracy
	xor dx, dx ; Clear to prepare for division
	mov bx, 255 ; It's a number from 0->255 so to get it back to a scaleable format we divide it by 255
	div bx
	mov bl, differenceMinimumMaximum ; Get the new scale
	inc bl ; Compensate to be able to reach the maximum
	mul bl ; Apply the new scale
	xor dx, dx ; Clear to prepare for division
	mov bx, 100
	div bx; Because we scaled up the initial number we have to scale it back down
	add ax, minimumValue ; Add the minimum value to map it between the minimum and maximum values
	
	inc bitShiftRandom
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return and pop 10 bytes
	ret 4
	
generateRandom ENDP


END