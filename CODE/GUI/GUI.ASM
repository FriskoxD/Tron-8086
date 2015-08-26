; Program: TRON
; File: GUI.ASM
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

include VIDEO.INC

rectangulate MACRO xPosition, yPosition, xSize, ySize, colourIndex
	
	;----------------------------------------------------
	; rectangulate
	;----------------------------------------------------
	;ARGUMENTS:
	; -xPosition: The X position on the screen in pixels
	; -yPosition: The Y position on the screen in pixels
	; -xSize: The width in pixels
	; -ySize: The height in pixels
	; -colourIndex: The rectangle's colour
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -Video_Draw_Rectangle
	;
	;DESCRIPTION:
	; Draws a rectangle on the screen.
	; This prevents the arguments making a mess in the code because they are pushed in this macro.
	
	push ax ; ax will be modified in the following code
	; Pass the arguments to the procedure
	mov ax, xPosition
	push ax
	mov ax, yPosition
	push ax
	mov ax, colourIndex
	push ax
	mov ax, xSize
	push ax
	mov ax, ySize
	push ax
	
	call Video_Draw_Rectangle

	pop ax ; Restore the original ax value
	
ENDM

GUI_Display_SplashScreen PROC NEAR PUBLIC
	
	;----------------------------------------------------
	; GUI_Display_SplashScreen
	;----------------------------------------------------
	;ARGUMENTS:
	; -None
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -Video_Draw_Rectangle
	; -Video_Clear_Screen
	;
	;DESCRIPTION:
	; Displays the intro screen.
	;
	;DETAILED DESCRIPTION:
	; Displays the intro screen by colouring rectangles on the screen.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov ax, backgroundColour
	push ax
	call Video_Clear_Screen
	
	;
	; Draw the T
	;
	
	rectangulate 98, 087, 115, 002, 1
	rectangulate 98, 090, 115, 002, 1
	rectangulate 113, 092, 006, 037, 1
	
	;
	; Draw the R
	;
	
	rectangulate 129, 099, 004, 030, 1
	rectangulate 133, 099, 010, 003, 1
	rectangulate 133, 114, 010, 003, 1
	rectangulate 143, 100, 002, 004, 1
	rectangulate 145, 101, 002, 012, 1
	rectangulate 147, 104, 002, 006, 1
	rectangulate 147, 102, 001, 002, 1
	rectangulate 147, 109, 001, 003, 1
	rectangulate 144, 110, 001, 002, 1
	rectangulate 143, 112, 002, 003, 1
	rectangulate 141, 113, 002, 001, 1
	rectangulate 142, 102, 001, 001, 1
	rectangulate 144, 104, 001, 001, 1
	rectangulate 145, 113, 001, 001, 1
	rectangulate 141, 117, 003, 002, 1
	rectangulate 143, 119, 003, 002, 1
	rectangulate 145, 121, 003, 002, 1
	rectangulate 147, 123, 003, 002, 1
	rectangulate 149, 125, 003, 002, 1
	rectangulate 151, 127, 003, 002, 1
	rectangulate 140, 117, 001, 001, 1
	rectangulate 144, 118, 001, 001, 1
	rectangulate 142, 119, 001, 001, 1
	rectangulate 146, 120, 001, 001, 1
	rectangulate 144, 121, 001, 001, 1
	rectangulate 148, 122, 001, 001, 1
	rectangulate 146, 123, 001, 001, 1
	rectangulate 150, 124, 001, 001, 1
	rectangulate 148, 125, 001, 001, 1
	rectangulate 152, 126, 001, 001, 1
	rectangulate 150, 127, 001, 001, 1
	
	;
	; Draw the O
	;
	
	rectangulate 156, 110, 004, 008, 2
	rectangulate 157, 118, 003, 002, 2
	rectangulate 158, 120, 003, 002, 2
	rectangulate 159, 122, 004, 002, 2
	rectangulate 161, 124, 004, 002, 2
	rectangulate 164, 126, 012, 002, 2
	rectangulate 165, 125, 002, 001, 2
	rectangulate 166, 128, 008, 001, 2
	rectangulate 175, 124, 004, 002, 2
	rectangulate 177, 122, 003, 002, 2
	rectangulate 179, 119, 001, 003, 2
	rectangulate 180, 107, 003, 013, 2
	rectangulate 180, 120, 002, 002, 2
	rectangulate 180, 122, 001, 002, 2
	rectangulate 183, 110, 001, 008, 2
	rectangulate 179, 105, 003, 002, 2
	rectangulate 177, 103, 004, 002, 2
	rectangulate 175, 101, 004, 002, 2
	rectangulate 164, 099, 012, 002, 2
	rectangulate 166, 098, 008, 001, 2
	rectangulate 161, 101, 004, 002, 2
	rectangulate 159, 103, 004, 002, 2
	rectangulate 158, 105, 003, 003, 2
	rectangulate 157, 108, 003, 003, 2
	rectangulate 176, 126, 001, 001, 2
	rectangulate 157, 107, 001, 001, 2
	rectangulate 161, 105, 001, 001, 2
	rectangulate 160, 102, 001, 001, 2
	rectangulate 163, 103, 001, 001, 2
	rectangulate 163, 100, 001, 001, 2
	rectangulate 165, 101, 001, 001, 2
	rectangulate 174, 101, 001, 001, 2
	rectangulate 176, 100, 001, 001, 2
	rectangulate 176, 103, 001, 001, 2
	rectangulate 179, 102, 001, 001, 2
	rectangulate 178, 105, 001, 001, 2
	rectangulate 179, 107, 001, 001, 2
	rectangulate 178, 121, 001, 001, 2
	rectangulate 176, 123, 001, 001, 2
	rectangulate 179, 124, 001, 001, 2
	rectangulate 174, 125, 001, 001, 2
	rectangulate 163, 126, 001, 001, 2
	rectangulate 160, 124, 001, 001, 2
	rectangulate 163, 123, 001, 001, 2
	rectangulate 161, 121, 001, 001, 2
	rectangulate 160, 119, 001, 001, 2
	
	;
	; Draw the N
	;
	
	rectangulate 190, 099, 004, 030, 1
	rectangulate 194, 099, 003, 004, 1
	rectangulate 195, 103, 004, 002, 1
	rectangulate 196, 105, 004, 002, 1
	rectangulate 197, 107, 004, 002, 1
	rectangulate 198, 109, 004, 002, 1
	rectangulate 199, 111, 004, 002, 1
	rectangulate 200, 113, 004, 002, 1
	rectangulate 201, 115, 004, 002, 1
	rectangulate 202, 117, 004, 002, 1
	rectangulate 203, 119, 004, 002, 1
	rectangulate 204, 121, 004, 002, 1
	rectangulate 205, 123, 004, 002, 1
	rectangulate 206, 125, 004, 002, 1
	rectangulate 207, 127, 004, 002, 1
	rectangulate 209, 099, 004, 030, 1
	rectangulate 197, 101, 001, 002, 1
	
	;
	; Subscript
	;
	
	rectangulate 215, 089, 006, 001, 1 ; T
	rectangulate 220, 087, 001, 005, 1 ; T
	
	rectangulate 215, 093, 006, 001, 1 ; H
	rectangulate 215, 096, 006, 001, 1 ; H
	rectangulate 218, 094, 001, 002, 1 ; H
	
	rectangulate 215, 099, 006, 001, 1 ; E
	rectangulate 215, 100, 001, 003, 1 ; E
	rectangulate 218, 100, 001, 003, 1 ; E
	rectangulate 220, 100, 001, 003, 1 ; E
	
	rectangulate 217, 106, 002, 001, 1 ; G
	rectangulate 215, 108, 001, 003, 1 ; G
	rectangulate 220, 108, 001, 003, 1 ; G
	rectangulate 216, 111, 002, 001, 1 ; G
	rectangulate 216, 107, 001, 001, 1 ; G
	rectangulate 219, 107, 001, 001, 1 ; G
	rectangulate 217, 110, 001, 001, 1 ; G
	rectangulate 219, 111, 001, 001, 1 ; G
	
	rectangulate 215, 113, 005, 001, 1 ; A
	rectangulate 215, 116, 005, 001, 1 ; A
	rectangulate 217, 114, 001, 002, 1 ; A
	rectangulate 220, 114, 001, 002, 1 ; A
	
	rectangulate 215, 118, 006, 001, 1 ; M
	rectangulate 218, 119, 002, 001, 1 ; M
	rectangulate 218, 121, 002, 001, 1 ; M
	rectangulate 215, 122, 006, 001, 1 ; M
	rectangulate 217, 120, 001, 001, 1 ; M
	
	rectangulate 215, 125, 006, 001, 1 ; E
	rectangulate 215, 126, 001, 003, 1 ; E
	rectangulate 218, 126, 001, 003, 1 ; E
	rectangulate 220, 126, 001, 003, 1 ; E
	
	;
	; Ornamental stuff
	;
	
	rectangulate 101, 075, 073, 009, 3 ; The trail
	
	; The car
	rectangulate 175, 078, 002, 005, 3
	rectangulate 176, 083, 002, 002, 3
	rectangulate 178, 085, 007, 001, 3
	rectangulate 179, 086, 004, 001, 3
	rectangulate 182, 084, 003, 001, 3
	rectangulate 184, 083, 002, 001, 3
	rectangulate 185, 081, 018, 002, 3
	rectangulate 182, 080, 003, 002, 3
	rectangulate 180, 077, 003, 003, 3
	rectangulate 181, 074, 004, 003, 3
	rectangulate 176, 076, 002, 002, 3
	rectangulate 177, 075, 004, 001, 3
	rectangulate 179, 074, 002, 001, 3
	rectangulate 184, 073, 005, 001, 3
	rectangulate 186, 072, 017, 001, 3
	rectangulate 189, 071, 011, 001, 3
	rectangulate 200, 073, 005, 001, 3
	rectangulate 203, 074, 006, 003, 3
	rectangulate 185, 076, 001, 006, 3
	rectangulate 186, 078, 001, 003, 3
	rectangulate 201, 078, 002, 003, 3
	rectangulate 202, 076, 001, 002, 3
	rectangulate 203, 080, 003, 002, 3
	rectangulate 206, 079, 001, 003, 3
	rectangulate 207, 077, 002, 003, 3
	rectangulate 202, 083, 002, 002, 3
	rectangulate 203, 085, 008, 001, 3
	rectangulate 205, 086, 004, 001, 3
	rectangulate 209, 075, 002, 002, 3
	rectangulate 211, 076, 001, 009, 3
	rectangulate 212, 078, 001, 005, 3
	rectangulate 209, 084, 002, 001, 3
	rectangulate 177, 085, 001, 001, 3
	rectangulate 178, 084, 001, 001, 3
	rectangulate 178, 076, 001, 001, 3
	rectangulate 181, 080, 001, 001, 3
	rectangulate 183, 079, 001, 001, 3
	rectangulate 184, 077, 001, 001, 3
	rectangulate 185, 074, 001, 001, 3
	rectangulate 203, 077, 001, 001, 3
	rectangulate 204, 084, 001, 001, 3
	rectangulate 117, 080, 001, 001, 3
	rectangulate 210, 077, 001, 001, 3
	rectangulate 210, 083, 001, 001, 3
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 0
	
GUI_Display_SplashScreen ENDP

GUI_Update_Player_Position PROC NEAR PUBLIC

	;------------------------
	; GUI_Update_Player_Position
	;------------------------
	;ARGUMENTS:
	; -[STACK] xPlayer1Position
	; -[STACK] yPlayer1Position
	; -[STACK] player1Visibility
	; -[STACK] xPlayer2Position
	; -[STACK] yPlayer2Position
	; -[STACK] player2Visibility
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -Video_Draw_Rectangle
	;
	;DESCRIPTION:
	; Draws the players on the screen.
	;
	;DETAILED DESCRIPTION:
	; Gets the colour settings for the players from the SETTINGS file.
	; Draws the players on the screen.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	mov ax, 4[bp] ; Get player 2's visibility
	cmp ax, 1 ; Check if the player is invisible
	je @checkPlayer1
		; Calculate player 2's offset
		mov ax, 6[bp] ; Get the player's Y position
		mov bx, screenW ; Get the width of the screen in pixels
		mul bx ; Get the Y offset in pixels
		add ax, 8[bp] ; Add the X offset
		
		mov di, ax ; Store the offset
		mov al, player2Colour ; Get the colour for player 2
		stosb ; Print the colour to the screen
		
	@checkPlayer1:
	
	mov ax, 10[bp] ; Get player 1's visibility
	cmp ax, 1 ; Check if the player is invisible
	je @done
		; Calculate player 1's offset
		mov ax, 12[bp] ; Get the player's Y position
		mov bx, screenW ; Get the width of the screen in pixels
		mul bx ; Get the Y offset in pixels
		add ax, 14[bp] ; Add the X offset
		
		mov di, ax ; Store the offset
		mov al, player1Colour ; Get the colour for player 1
		stosb ; Print the colour to the screen
	
	@done:
	
	; restore context
	pop di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 12

GUI_Update_Player_Position ENDP

GUI_Refresh_Field PROC NEAR PUBLIC

	;------------------------
	; GUI_Refresh_Field
	;------------------------
	;ARGUMENTS:
	; -None
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -Video_Draw_Rectangle
	;
	;DESCRIPTION:
	; Draws a blank playing arena.
	;
	;DETAILED DESCRIPTION:
	; Gets the colour settings for the arena from the SETTINGS file.
	; Draws the empty arena.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	;Draw the Arenaborder
	mov ax, xPositionArena
	push ax
	mov ax, yPositionArena
	push ax
	mov ax, colourEdge
	push ax
	mov ax, widthArena
	push ax
	mov ax, heightArena
	push ax
	call Video_Draw_Rectangle
	
	;Draw the Arena
	mov ax, xPositionArena
	add ax, 1
	push ax
	mov ax, yPositionArena
	add ax, 1
	push ax
	mov ax, backgroundColour
	push ax
	mov ax, widthArena
	sub ax, 2
	push ax
	mov ax, heightArena
	sub ax, 2
	push ax
	call Video_Draw_Rectangle
	
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 0

GUI_Refresh_Field ENDP

GUI_Update_Score PROC NEAR PUBLIC

	;------------------------
	; GUI_Update_Score
	;------------------------
	;ARGUMENTS:
	; -[STACK] player1Score
	; -[STACK] player2Score
	; -[STACK] matchNumber
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -Video_Draw_Rectangle
	;
	;DESCRIPTION:
	; Updates the scores of players 1 and 2.
	; And updates the current match number.
	;
	;DETAILED DESCRIPTION:
	; Clears player 1's score field.
	; Clears player 2's score field.
	; Clears current match number.
	; Updates player 1's score field.
	; Updates player 2's score field.
	; Updates the current match number.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	widthScore 			equ 30
	heightScore			equ 8
	widthScoreEmpty 	equ 28
	heightScoreEmtpy	equ 6
	
	
	;Draw the empty containers for player 1
		;The border
		mov dx, 2 ;xPositionScore1
		mov cx, maxWin
		ScoreBoard1:
			
			push dx ;Push xPositionScore
			mov bx, 1
			push bx
			mov bx, colourEdge
			push bx
			mov bx, widthScore
			push bx
			mov bx, heightScore
			push bx
			call Video_Draw_Rectangle
		
			add dx, widthScore
			inc dx ;Next position to draw score
			dec cx				
			cmp cx, 0
		jne ScoreBoard1
	
		;The body
		mov dx, 3 ;xPositionScore1
		mov cx, maxWin
		EmptyScoreBoard1:
			
			push dx ;Push xPositionScore
			mov bx, 2
			push bx
			mov bx, backgroundColour
			push bx
			mov bx, widthScoreEmpty
			push bx
			mov bx, heightScoreEmtpy
			push bx
			call Video_Draw_Rectangle
		
			add dx, widthScore
			inc dx ;Next position to draw score
			dec cx				
			cmp cx, 0
		jne EmptyScoreBoard1
	
	;Draw the empty containers for player 2
		;The border
		mov dx, 288 ;xPositionScore2
		mov cx, maxWin
		ScoreBoard2:
			
			push dx
			mov bx, 1
			push bx
			mov bx, colourEdge
			push bx
			mov bx, widthScore
			push bx
			mov bx, heightScore
			push bx
			call Video_Draw_Rectangle
			
			sub dx, widthScore
			dec dx ;Next position to draw score
			dec cx
			cmp cx,0
		jne ScoreBoard2
		
		;The body
		mov dx, 289 ;xPositionScore2
		mov cx, maxWin
		EmptyScoreBoard2:
			
			push dx
			mov bx, 2
			push bx
			mov bx, backgroundColour
			push bx
			mov bx, widthScoreEmpty
			push bx
			mov bx, heightScoreEmtpy
			push bx
			call Video_Draw_Rectangle
			
			sub dx, widthScore
			dec dx ;Next position to draw score
			dec cx
			cmp cx,0
		jne EmptyScoreBoard2
	
	;Draw the score for player 1
	mov ax, 8[bp] ;Score Player1
	mov dx, 3 ;xPositionScore1
	mov cx, ax
	
	cmp cx, 0
	je @Player2
	
	DrawScorePlayer1:
		
		push dx ;Push xPositionScore
		mov bx, 2
		push bx
		mov bx, player1Colour
		push bx
		mov bx, widthScore
		sub bx, 2
		push bx
		mov bx, heightScore
		sub bx, 2
		push bx
		call Video_Draw_Rectangle
	
		add dx, widthScore
		inc dx ;Next position to draw score
		dec cx				
		cmp cx, 0
	jne DrawScorePlayer1
	
	;Draw the score for player 2
	@Player2:
	mov ax, 6[bp] ;Score Player2
	mov dx, 289 ;xPositionScore2
	mov cx, ax
	
	cmp cx, 0
	je @Done
	
	DrawScorePlayer2:
		
		push dx
		mov bx, 2
		push bx
		mov bx, player2Colour
		push bx
		mov bx, widthScore
		sub bx, 2
		push bx
		mov bx, heightScore
		sub bx, 2
		push bx
		call Video_Draw_Rectangle
		
		sub dx, widthScore
		dec dx ;Next position to draw score
		dec cx
		cmp cx,0
	jne DrawScorePlayer2
	
	@Done:
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 6

GUI_Update_Score ENDP

GUI_Draw_Obstacle PROC NEAR PUBLIC

	;------------------------
	; GUI_Draw_Obstacle
	;------------------------
	;ARGUMENTS:
	; -[STACK] xPosition
	; -[STACK] yPosition
	; -[STACK] width
	; -[STACK] height
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -Video_Draw_Rectangle
	;
	;DESCRIPTION:
	; Displays one obstacle on the screen.
	;
	;DETAILED DESCRIPTION:
	; Displays one obstacle on the screen.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov ax, 10[bp] ; xPosition
	mov bx, 8[bp] ; yPosition
	mov dx, 6[bp] ; width
	mov cx, 4[bp] ; height
	
	rectangulate ax, bx, dx, cx, colourEdge ; The borders
	
	inc ax
	inc bx
	sub dx, 2
	sub cx, 2
	rectangulate ax, bx, dx, cx, obstacleColourBody ; Body
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 8

GUI_Draw_Obstacle ENDP


GUI_Declare_Win PROC NEAR PUBLIC
	;----------------------------------------------------
	; Video_Declare_Win
	;----------------------------------------------------
	;ARGUMENTS:
	; -[STACK]  1 when player 2 won
	;			2 when player 1 won
	;			other no player won
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; - Video_Draw_Rectangle
	;
	;DESCRIPTION:
	; Display the winner of the match
	;
	;DETAILED DESCRIPTION:
	; Display the winner of the match
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push bx
	push cx
	push dx
	push si
	
	;rectangulate MACRO xPosition, yPosition, xSize, ySize, colourIndex
	
	; Draw win declaration display
	rectangulate 0,75,320,50,1
	; Draw 'PLAYER ... WON'
	;P
	rectangulate 65,80,2,40,5
	rectangulate 65,80,17,2,5
	rectangulate 65,93,17,2,5
	rectangulate 80,80,2,15,5
	;L
	rectangulate 84,80,2,40,5
	rectangulate 84,118,17,2,5
	;A
	rectangulate 103,80,2,40,5
	rectangulate 118,80,2,40,5
	rectangulate 105,80,13,2,5
	rectangulate 105,97,13,2,5
	;Y
	rectangulate 122,80,2,19,5
	rectangulate 137,80,2,40,5
	rectangulate 122,118,15,2,5
	rectangulate 124,97,13,2,5
	;E
	rectangulate 141,80,2,40,5
	rectangulate 143,80,15,2,5
	rectangulate 143,97,11,2,5
	rectangulate 143,118,15,2,5
	;R
	rectangulate 160,80,2,40,5
	rectangulate 162,80,15,2,5
	rectangulate 162,93,15,2,5
	rectangulate 175,82,2,11,5
	rectangulate 175,101,2,19,5
	rectangulate 169,95,2,2,5
	rectangulate 171,97,2,2,5
	rectangulate 173,99,2,2,5
	;W
	rectangulate 212,80,2,40,5
	rectangulate 223,99,2,19,5
	rectangulate 234,80,2,38,5
	rectangulate 212,118,24,2,5
	;O
	rectangulate 238,80,2,40,5
	rectangulate 253,80,2,40,5
	rectangulate 240,80,13,2,5
	rectangulate 240,118,13,2,5
	;N
	rectangulate 257,80,2,40,5
	rectangulate 267,80,2,40,5
	rectangulate 259,93,2,2,5
	rectangulate 261,95,2,2,5
	rectangulate 263,97,2,2,5
	rectangulate 265,99,2,2,5
	
	cmp ax, 1
	jne @Player1Won
	
	;Player 2 Won
		rectangulate 186,80,17,2,5
		rectangulate 186,99,17,2,5
		rectangulate 186,118,17,2,5
		rectangulate 201,82,2,17,5
		rectangulate 186,101,2,17,5
	
	;Player 1 Won
	@Player1Won:
		cmp ax, 2
		jne @nobodyWon
		rectangulate 186,80,9,2,5
		rectangulate 193,82,2,36,5
		rectangulate 186,118,17,2,5
		
	@nobodyWon:
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return and pop 10 bytes
	ret 2
	
GUI_Declare_Win ENDP

END