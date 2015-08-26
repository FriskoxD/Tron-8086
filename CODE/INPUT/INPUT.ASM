; Program: TRON
; File: INPUT.ASM
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

Input_Get_Input PROC NEAR PUBLIC

	;------------------------
	; INPUT_GET_INPUT
	;------------------------
	;ARGUMENTS:
	; -None
	;
	;RETURNS:
	; -AX:
	;	-AH: (MSB) b0 b1 b2 b3 b4 b5 b6 b7 (LSB)
	;                        │ │  │  │  │
	;                   	 │ │  │  │  └─> Start Signal
	;                        │ │  │  └────> Quit Signal
	;                        │ │  └───────> Player 1: Special
	;                        │ └──────────> Player 2: Special
	;					     └────────────> Pause Signal
	;
	;	-AL: (MSB) b0 b1 b2 b3 b4 b5 b6 b7 (LSB)
	;              │  │  │  │  │  │  │  │
	;              │  │  │  │  │  │  │  └─> Player 1: Right
	;              │  │  │  │  │  │  └────> Player 1: Left
	;              │  │  │  │  │  └───────> Player 1: Up
	;              │  │  │  │  └──────────> Player 1: Down
	;              │  │  │  └─────────────> Player 2: Right
	;              │  │  └────────────────> Player 2: Left
	;              │  └───────────────────> Player 2: Up
	;              └──────────────────────> Player 2: Down
	;
	;CALLS ON PROCEDURE:
	; -None
	;
	;DESCRIPTION:
	; This procedure checks the system BIOS for input.
	; If the user has pressed keys, the corresponding bits in AX are set high.
	; If the key was not pressed, its corresponding bit remains low
	;
	;DETAILED DESCRIPTION:
	; AX is reset to 0.
	; The system BIOS gets checked to see if a key was pressed.
	; If a key was pressed it gets set into AX.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push bx
	push cx
	push dx
	push si
	
	mov ah, 01h ; Check if a key was pressed
	int 16h ; Call keyboard BIOS
	jz @noKeyPressed
	
	mov ah, 00h ; Get the pressed keys
	int 16h ; Call keyboard BIOS
	
	cmp al, 0 ; A key was pressed, but it has no ASCII code
	jne @compareKeys
	
	mov al, ah ; Use the BIOS code instead of the (non-existing) ASCII code
	
	@compareKeys:
	
		mov bl, al ; We will be modifying AX
		xor ax, ax
	
		cmp bl, gameStart
		jne @f
		xor ah, gameStartBit
		
		@@:
		cmp bl, gameQuit
		jne @f
		xor ah, gameQuitBit
		
		@@:
		cmp bl, gamePause
		jne @f
		xor ah, gamePauseBit
		
		@@:
		cmp bl, player1Special
		jne @f
		xor ah, player1SpecialBit
		
		@@:
		cmp bl, player2Special
		jne @f
		xor ah, player2SpecialBit
		
		@@:
		cmp bl, player1Up
		jne @f
		xor al, player1UpBit
		
		@@:
		cmp bl, player1Down
		jne @f
		xor al, player1DownBit
		
		@@:
		cmp bl, player1Left
		jne @f
		xor al, player1LeftBit
		
		@@:
		cmp bl, player1Right
		jne @f
		xor al, player1RightBit
		
		@@:
		cmp bl, player2Up
		jne @f
		xor al, player2UpBit
		
		@@:
		cmp bl, player2Down
		jne @f
		xor al, player2DownBit
		
		@@:
		cmp bl, player2Left
		jne @f
		xor al, player2LeftBit
		
		@@:
		cmp bl, player2Right
		jne @f
		xor al, player2RightBit
		
		@@:
		jmp @doneChecking
	
	@noKeyPressed:
	xor ax, ax
	
	@doneChecking:
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 0

Input_Get_Input ENDP

END