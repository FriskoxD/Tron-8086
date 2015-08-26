; Program: TRON
; File: TRON.ASM
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

include GUI.INC
include INPUT.INC
include VIDEO.INC
include CORE.INC

main PROC NEAR

	mov	ax, @DATA
	mov	ds, ax
	
	push es
	push ds

	; Initialize the screen.
	call Video_Initialize
	mov oldVideoMode, ax ; The video mode
	
	call Core_Display_Splash
	
	@startNewGame:
		lea ax, matchNumber
		push ax
		lea ax, player2Score
		push ax
		lea ax, player1Score
		push ax
		lea ax, player2JumpPoints
		push ax
		lea ax, player1JumpPoints
		push ax
		call Core_New_Game
		
	@startNewMatch:
		xor ah, ah
		mov al, player1Score
		push ax
		mov al, player1JumpPoints
		push ax
		mov al, player2Score
		push ax
		mov al, player2JumpPoints
		push ax
		mov al, matchNumber
		push ax
		call Core_New_Match

	@waitForStart:
		;Wait for the user to press start.
		call Input_Get_Input
		cmp ah, gameQuitBit ; User wants to quit.
		je @overAndOut
		cmp ah, gameStartBit ; User wants to start.
		jne @waitForStart ; No relevant key was pressed.
		
		call Core_Start_Game
		
	@gameFlow:
		Call Input_Get_Input
		cmp ah, gameQuitBit ; User wants to quit.
		je @overAndOut
		cmp ah, gamePauseBit ; User wants to quit
		jne @notPaused
		
		@Pause:
		Call Input_Get_Input
		cmp ah, gameQuitBit
		je @overAndOut
		cmp ah, gamePauseBit
		jne @Pause
		
		@notPaused:
		push ax ; Argument gotten by Input_Get_Input.
		call Core_Move_Players ; Move the players.
		
		cmp ax, 0
		je @gameFlow ; No crash
		
	cmp ax, 2
	je @player2Crashed
	jb @player1Crashed
	ja @increaseMatch ; Both players crashed.
	
	@player1Crashed:
		inc player2Score
		inc player2JumpPoints
		jmp @increaseMatch
	
	@player2Crashed:
		inc player1Score
		inc player1JumpPoints
		jmp @increaseMatch
	
	@increaseMatch:
		inc matchNumber
		
	xor ah, ah
	mov al, player1Score
	push ax
	mov al, player2Score
	push ax
	mov al, matchNumber
	push ax
	call Core_End_Match
	cmp ax, 0
	jne @f ; Workaround for error 6003 conditional jump too far
	jmp @startNewMatch
	
	@@:
	jmp @startNewGame
	
	@overAndOut:
	
	; Restore the old video mode.
	mov ax, oldVideoMode
	push ax
	
	call Video_Restore
	
	pop ds
	pop es
	
	; Exit to DOS
	mov	ax, 4c00h
	int	21h

main ENDP

END main