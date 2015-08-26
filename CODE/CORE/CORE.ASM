; Program: TRON
; File: CORE.ASM
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
include GUI.INC
include MISC.INC

Core_Move_Players PROC NEAR PUBLIC

	;------------------------
	; CORE_MOVE_PLAYERS
	;------------------------
	;ARGUMENTS:
	; -[STACK] playersInput
	;	-Byte 1: (MSB) b0 b1 b2 b3 b4 b5 b6 b7 (LSB)
	;                	        │  │  │  │
	;                   	    │  │  │  └─> Start Signal
	;                        	│  │  └────> Quit Signal
	;                          	│  └───────> Player 1: Special
	;                          	└──────────> Player 2: Special
	;
	;	-Byte 2: (MSB) b0 b1 b2 b3 b4 b5 b6 b7 (LSB)
	;             	   │  │  │  │  │  │  │  │
	;                  │  │  │  │  │  │  │  └─> Player 1: Right
	;                  │  │  │  │  │  │  └────> Player 1: Left
	;                  │  │  │  │  │  └───────> Player 1: Up
	;                  │  │  │  │  └──────────> Player 1: Down
	;                  │  │  │  └─────────────> Player 2: Right
	;                  │  │  └────────────────> Player 2: Left
	;                  │  └───────────────────> Player 2: Up
	;                  └──────────────────────> Player 2: Down
	;
	;RETURNS:
	; -AX: 0 if no players collided with an object. 
	;		1 if player 1 collided with an object.
	;		2 if player 2 collided with an object.
	;		3 if both players collided at the same time.
	;
	;CALLS ON PROCEDURES:
	; -Core_Check_Collision
	; -GUI_Update_Player_Position
	;
	;DESCRIPTION:
	; Moves the player according to the input received.
	;
	;DETAILED DESCRIPTION:
	; Generates a new position for the player calls on Core_Check_Collision.
	; It then updates the players position on the screen by calling GUI_Update_Player_Position.
	; Once it has done this, it returns with the result of Core_Check_Collision in AX.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push bx
	push cx
	push dx
	push si
	
	; Check if the player wants to change direction
	; Player 1
		mov bx, 4[bp] ; Get the input
		
		test bl, player1UpBit ; Evaluate only the Up direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player1DirectionY, 1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player1DirectionY, -1
				mov player1DirectionX, 0
				jmp @checkPlayer2
		@@:
		test bl, player1DownBit ; Evaluate only the Down direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player1DirectionY, -1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player1DirectionY, 1
				mov player1DirectionX, 0
				jmp @checkPlayer2
		@@:
		test bl, player1LeftBit ; Evaluate only the Left direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player1DirectionX, 1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player1DirectionY, 0
				mov player1DirectionX, -1
				jmp @checkPlayer2
		@@:
		test bl, player1RightBit ; Evaluate only the Right direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player1DirectionX, -1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player1DirectionY, 0
				mov player1DirectionX, 1
				
		@@:
		test bh, player1SpecialBit ; Evaluate only the visibility
		jz @checkPlayer2 ; If the result of the and operation is zero the player did not want to become invisible
			cmp player1Visibility, 1 ; Check is the player is already invisible
			je @checkPlayer2 ; The player is already invisible so he doesn't have to lose another point
				cmp player1JumpPoints, 0
				je @checkPlayer2 ; Player 1 is not eligible for a jump
					dec player1JumpPoints
					dec player1Score
					mov player1Visibility, 1
					mov player1JumpRemaining, playerJumpTime
					xor ah, ah
					mov al, player1Score
					push ax
					mov al, player2Score
					push ax
					mov al, matchNumber
					push ax
					call GUI_Update_Score
			
	;Player 2
		@checkPlayer2:
		test bl, player2UpBit ; Evaluate only the Up direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player2DirectionY, 1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player2DirectionY, -1
				mov player2DirectionX, 0
				jmp @doneCheckingDirection
		@@:
		test bl, player2DownBit ; Evaluate only the Down direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player2DirectionY, -1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player2DirectionY, 1
				mov player2DirectionX, 0
				jmp @doneCheckingDirection
		@@:
		test bl, player2LeftBit ; Evaluate only the Left direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player2DirectionX, 1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player2DirectionY, 0
				mov player2DirectionX, -1
				jmp @doneCheckingDirection
		@@:
		test bl, player2RightBit ; Evaluate only the Right direction
		jz @f ; If the result of the and operation is zero the player did not want to go in this direction
			cmp player2DirectionX, -1 ; Check is the player is going in the opposite direction
			je @f ; We cannot allow a player to turn around 180 degrees
				mov player2DirectionY, 0
				mov player2DirectionX, 1
				
		@@:
		test bh, player2SpecialBit ; Evaluate only the visibility
		jz @doneCheckingDirection ; If the result of the and operation is zero the player did not want to become invisible
			cmp player2Visibility, 1 ; Check is the player is already invisible
			je @doneCheckingDirection ; The player is already invisible so he doesn't have to lose another point
				cmp player2JumpPoints, 0
				je @doneCheckingDirection ; Player 2 is not eligible for a jump
					dec player2JumpPoints
					dec player2Score
					mov player2Visibility, 1			
					mov player2JumpRemaining, playerJumpTime
					xor ah, ah
					mov al, player1Score
					push ax
					mov al, player2Score
					push ax
					mov al, matchNumber
					push ax
					call GUI_Update_Score
	
		@doneCheckingDirection:
	
	; Slow down the players movement
	;==================================================================
	
	mov cx, playerSpeed
	@repeat:
		mov	dx, 03dah	; VGA status port
		@waitVBlank_wait1:		; if already in VB, then wait until VB finishes
		in	al, dx		; read status
		and	al, 8		; test bit 3
		jnz	@waitVBlank_wait1	; busy wait if in VB
		@waitVBlank_wait2:		; wait until begin of a new VB
		in	al, dx		; read status
		and	al, 8		; test bit 3
		jz	@waitVBlank_wait2	; busy wait if NOT in VB
	dec cx
	jcxz @repeatDone
	jmp @repeat
	
	@repeatDone:
	;==================================================================
	; Move the players
		xor ax, ax ; Clear AX since we will be using it
		mov al, player1DirectionX ; Move it into the register so we can add it to a 2 byte number
		cbw ; Sign extend the direction
		add player1PositionX, ax ; Move along the X direction
		mov al, player1DirectionY ; Move it into the register so we can add it to a 2 byte number
		cbw ; Sign extend the direction
		add player1PositionY, ax ; Move along the Y direction
		
		mov al, player2DirectionX ; Move it into the register so we can add it to a 2 byte number
		cbw ; Sign extend the direction
		add player2PositionX, ax ; Move along the X direction
		mov al, player2DirectionY ; Move it into the register so we can add it to a 2 byte number
		cbw ; Sign extend the direction
		add player2PositionY, ax ; Move along the Y direction
	
	; Check if one of the players collided
		mov ax, player1PositionX
		push ax ; First argument
		mov ax, player1PositionY
		push ax ; Second argument
		mov al, player1Visibility
		xor ah, ah
		push ax ; Third argument (the visibility)
		mov ax, player2PositionX
		push ax ; Fourth argument
		mov ax, player2PositionY
		push ax ; Fifth argument
		mov al, player2Visibility
		xor ah, ah
		push ax ; Sixth argument (the visibility)
		
		call Core_Check_Collision ;AX now contains the collision state
	
	; Check if the players should become visible
		cmp player1Visibility, 0
		je @f ; Player is visible
			dec player1JumpRemaining 
			
			cmp player1JumpRemaining, 0 ; Check if the player has used up the invisibility duration
			jne @f
			mov player1Visibility, 0
			
		
		@@:
		cmp player2Visibility, 0
		je @f ; Player is visible
			dec player2JumpRemaining 
			
			cmp player2JumpRemaining, 0 ; Check if the player has used up the invisibility duration
			jne @f
			mov player2Visibility, 0
	
		@@:
	
	;---------------- WARNING ------------------
	; Do NOT modify AX from this point onwards
	;---------------- WARNING ------------------
	
	; Update the playing field
		mov bx, player1PositionX
		push bx ; First argument
		mov bx, player1PositionY
		push bx ; Second argument
		mov bl, player1Visibility
		xor bh, bh
		push bx ; Third argument (the visibility)
		mov bx, player2PositionX
		push bx ; Fourth argument
		mov bx, player2PositionY
		push bx ; Fifth argument
		mov bl, player2Visibility
		xor bh, bh
		push bx ; Sixth argument (the visibility)
		call GUI_Update_Player_Position
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 2

Core_Move_Players ENDP

Core_Check_Collision PROC NEAR PUBLIC

	;------------------------
	; CORE_CHECK_COLLISION
	;------------------------
	;ARGUMENTS:
	; -[STACK] xPlayer1Position 14
	; -[STACK] yPlayer1Position 12
	; -[STACK] player1Visibility 10
	; -[STACK] xPlayer2Position 8
	; -[STACK] yPlayer2Position 6
	; -[STACK] player2Visibility 4
	;
	;RETURNS:
	; -AX:  0 if no players collided with an object. 
	;		1 if player 1 collided with an object.
	;		2 if player 2 collided with an object.
	;		3 if both players collided at the same time.
	;
	;CALLS ON PROCEDURS:
	; -Video_Get_Colour
	;
	;DESCRIPTION:
	; Checks if a player has hit an object. In case the player is invisible,
	; he cannot hit the opponent
	;
	;DETAILED DESCRIPTION:
	; AX gets reset to 0.
	; For each player the colour on the screen gets fetched by Video_Get_Colour.
	; If player one's position contains a colour other than the background colour 1 gets added to AX.
	; If player two's position contains a colour other than the background colour 2 gets added to AX.
	; The procedure then returns with AX.
	
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push bx
	push cx
	push dx
	push si
	
	mov cx, 0 ;CX keeps count of which players crashed
	
	mov bx, 14[bp] ;Get the xPlayer1Position
	push bx
	mov bx, 12[bp] ;Get the yPlayer1Position
	push bx
	call Video_Get_Colour
	cmp ax, backgroundColour ;Check if the player is in a blank spot
	je @checkPlayer2
	
	cmp ax, colourEdge ;Check if the player hit an edge (This always results in a player crash)
	je @collided1
	
	mov dx, 10[bp] ;Get the player's visibility
	cmp dx, 1 ;Player is invisible
	je @checkPlayer2 ;If the player is invisible he cannot collide

	@collided1:
	inc cx ;Player one collided. CX now contains 1
	
	@checkPlayer2:
		mov bx, 8[bp] ;Get the xPlayer2Position
		push bx
		mov bx, 6[bp] ;Get the yPlayer2Position
		push bx
		call Video_Get_Colour
		cmp ax, backgroundColour ;Check if the player is in a blank spot
		je @doneChecking
		
		cmp ax, colourEdge ;Check if the player hit an edge (This always results in a player crash)
		je @collided2
		
		mov dx, 4[bp]
		cmp dx, 1 ;Player is invisible
		je @doneChecking ;If the player is invisible he cannot collide

		@collided2:
		add cx, 2 ;Player two collided. CX now contains 2 or 3 if player one also crashed.
	
	@doneChecking:
		mov ax, cx ;Return the player crashes in AX
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 12

Core_Check_Collision ENDP

Core_Start_Game PROC NEAR PUBLIC

	;------------------------
	; CORE_START_GAME
	;------------------------
	;ARGUMENTS:
	; -None
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; This procedure does nothing. It is implemented only for possible future support.
	;
	;DETAILED DESCRIPTION:
	; This procedure does nothing. It is implemented only for possible future support.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	;-----------
	; CODE HERE
	;-----------
	
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

Core_Start_Game ENDP

Core_New_Game PROC NEAR PUBLIC

	;------------------------
	; CORE_NEW_GAME
	;------------------------
	;ARGUMENTS:
	; -[STACK] player1Score*
	; -[STACK] player2Score*
	; -[STACK] player1Jumps*
	; -[STACK] player2Jumps*
	; -[STACK] matchNumber*
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; Resets all variables to their original state.
	;
	;DETAILED DESCRIPTION:
	; Inserts the default variable states from the SETTINGS file into the variable pointers.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov bx, 4[bp] ; Get the pointer to the match number
	mov ax, player1JumpHandicap
	mov [bx], ax ; Restore the match number with the original number in the SETTINGS file
	mov bx, 6[bp] ; Get the pointer to player 2's jumps
	mov ax, player2JumpHandicap
	mov [bx], ax ; Restore the jump number with the original number in the SETTINGS file
	mov bx, 8[bp] ; Get the pointer to player 1's jumps
	mov ax, player1ScoreHandicap
	mov [bx], ax ; Restore the jump number with the original number in the SETTINGS file
	mov bx, 10[bp] ; Get the pointer to player 2's score
	mov ax, player2ScoreHandicap
	mov [bx], ax ; Restore the score number with the original number in the SETTINGS file
	mov bx, 12[bp] ; Get the pointer to player 1's score
	mov ax, matchNumberHandicap
	mov [bx], ax ; REstore the score number with the original number in the SETTINGS file
	
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
	ret 10

Core_New_Game ENDP

Core_New_Match PROC NEAR PUBLIC

	;------------------------
	; CORE_NEW_MATCH
	;------------------------
	;ARGUMENTS:
	; -[STACK] player1Score
	; -[STACK] player1Jumps
	; -[STACK] player2Score
	; -[STACK] player2Jumps
	; -[STACK] matchNumber
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURE:
	; -Core_Place_Obstacle
	; -GUI_Refresh_Field
	; -GUI_Update_Score
	; -Video_Clear_Screen
	;
	;DESCRIPTION:
	; Starts a new match with a clean playing field.
	;
	;DETAILED DESCRIPTION:
	; Clears the screen by calling Video_Clear_Screen.
	; Draws a fresh playing field by calling GUI_Refresh_Field.
	; Displays the score by calling GUI_Update_Score.
	; Generates a random number between the minimum and maximum settings for the obstacles in the SETTINGS file.
	; Calls upon Core_Place_Obstacle for the amount of times generated in the previous step.
	
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
	call GUI_Refresh_Field
	mov bx, 12[bp]
	push bx
	mov bx, 8[bp]
	push bx
	mov bx, 4[bp]
	push bx
	call GUI_Update_Score
	
	mov player1PositionX, 3
	mov ax, player1PositionX
	push ax
	mov player1PositionY, yPositionArena
	add player1PositionY, 3
	mov ax, player1PositionY
	push ax
	mov player1Visibility, 0
	xor ah,ah
	mov al, player1Visibility
	push ax
	mov player2PositionX, 316
	mov ax, player2PositionX
	push ax
	mov player2PositionY, 196
	mov ax, player2PositionY
	push ax
	xor ah,ah
	mov player2Visibility, 0
	mov al, player2Visibility
	push ax
	mov player1DirectionX, 1
	mov player1DirectionY, 0
	mov player2DirectionX, -1
	mov player2DirectionY, 0
	
	call GUI_Update_Player_Position
	
	;Generate random amount of obstacles
	mov ax, minObstacles
	push ax
	mov ax, numberOfObstacles
	push ax
	call generateRandom  ;amount of obstacles to be placed
	mov cx, ax
	
	jcxz @Done
	@PlacesObstacles:
		call Core_Place_Obstacle
		dec cx
	jcxz @Done
	jmp @PlacesObstacles
	
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
	ret 10

Core_New_Match ENDP

Core_End_Match PROC NEAR PUBLIC

	;------------------------
	; CORE_END_MATCH
	;------------------------
	;ARGUMENTS:
	; -[STACK] player1Score
	; -[STACK] player2Score
	; -[STACK] matchNumber
	;
	;RETURNS:
	; -AX: 0 if another match will be played within the same game.
	;		1 if a new game has to be started.
	;
	;CALLS ON PROCEDURES:
	; -Core_Display_Victory
	;
	;DESCRIPTION:
	; Checks if the played match was the last in the game, or if another match should be initiated within the same game.
	;
	;DETAILED DESCRIPTION:
	; Resets AX to 0.
	; Compares players1Score to the maximum wins set in the SETTINGS file.
	; Compares players2Score to the maximum wins set in the SETTINGS file.
	; Compares the match number to the maximum matches set in the SETTINGS file.
	; If either of the 3 previous comparisons are equal AX is set to 1.
	; 
	; The maximum number of matches is also checked because, when the players tie, their score isn't incremented.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack=
	push bx
	push cx
	push dx
	push si
	
	mov cx, 0
	
	mov bx, [bp+4][4] ;Get player1Score
	cmp bx, maxWin
	jne @checkPlayer2
	mov cx, 2
	
	@checkPlayer2:
	mov bx, [bp+4][2] ;Get player2Score
	cmp bx, maxWin
	jne @determineCrashes
	add cx, 1
	
	@determineCrashes:
	cmp cx, 0
	je @checkMatchNumber
	jmp @newGame
	
	@checkMatchNumber:
	mov bx, [bp+4][0] ;Get matchNumber
	cmp bx, maxMatch
	je @newGame
	mov ax,0
	jmp @newMatch
	
	@newGame:
	mov ax, 1
	push cx
	call Core_Display_Victory
	
	@newMatch:
	
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 6

Core_End_Match ENDP

Core_Display_Splash PROC NEAR PUBLIC

	;------------------------
	; CORE_DISPLAY_SPLASH
	;------------------------
	;ARGUMENTS:
	; -None
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURE:
	; -GUI_Display_SplashScreen
	;
	;DESCRIPTION:
	; Displays the splash screen for a certain amount of time.
	;
	;DETAILED DESCRIPTION:
	; Calls upon GUI_Display_SplashScreen to display the splash screen on the screen.
	; Loops until the delay set in the SETTINGS file is met.
	
	;Local variables
	timeKeeperHigh equ [bp-12]
	timeKeeperLow equ [bp-14]
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	sub sp, 4 ; Allocate local variables
	
	call GUI_Display_SplashScreen ; Print the splash screen
	
	; Get the ticks since midnight.
	; These are returned in CX:DX.
	mov ah, 00
	int 1Ah
	
	; Add the number of desired display seconds
	add dx, splashScreenDelay
	adc cx, 0 ; In case the previous result overflowed this will add 1 to timeKeeperHigh. Otherwise it will add 0.
	
	; Store the ticks since midnight
	mov timeKeeperLow, dx
	mov timeKeeperHigh, cx
	
	@checkTime:
		int 1Ah
		mov bx, timeKeeperHigh
	cmp bx, cx ; If the high ticks are lower than the desired ticks it loops back
	ja @checkTime
		mov bx, timeKeeperLow
	cmp bx, dx ; If the low ticks are lower than the desired ticks it loops back
	ja @checkTime
	
	add sp, 4 ; Deallocate local variables
	
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

Core_Display_Splash ENDP

Core_Display_Victory PROC NEAR PUBLIC

	;------------------------
	; CORE_DISPLAY_VICTORY
	;------------------------
	;ARGUMENTS:
	; -[STACK] Winning player	1 for player 2
	;							2 for player 1
	;							other for a tie
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURE:
	; -GUI_Declare_Win
	;
	;DESCRIPTION:
	; Displays the splash screen for a certain amount of time.
	;
	;DETAILED DESCRIPTION:
	; Calls upon GUI_Display_SplashScreen to display the splash screen on the screen.
	; Loops until the delay set in the SETTINGS file is met.
	
	;Local variables
	timeKeeperHigh equ [bp-12]
	timeKeeperLow equ [bp-14]
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	sub sp, 4 ; Allocate local variables
	
	mov ax, [bp+4] ; Get the winning player
	push ax
	
	call GUI_Declare_Win ; Print the splash screen
	
	; Get the ticks since midnight.
	; These are returned in CX:DX.
	mov ah, 00
	int 1Ah
	
	; Add the number of desired display seconds
	add dx, victoryDelay
	adc cx, 0 ; In case the previous result overflowed this will add 1 to timeKeeperHigh. Otherwise it will add 0.
	
	; Store the ticks since midnight
	mov timeKeeperLow, dx
	mov timeKeeperHigh, cx
	
	@checkTime:
		int 1Ah
		mov bx, timeKeeperHigh
	cmp bx, cx ; If the high ticks are lower than the desired ticks it loops back
	ja @checkTime
		mov bx, timeKeeperLow
	cmp bx, dx ; If the low ticks are lower than the desired ticks it loops back
	ja @checkTime
	
	add sp, 4 ; Deallocate local variables
	
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
	ret 2

Core_Display_Victory ENDP

Core_Place_Obstacle PROC NEAR PUBLIC

	;------------------------
	; CORE_PLACE_OBSTACLE
	;------------------------
	;ARGUMENTS:
	; -None
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -GUI_Draw_Obstacle
	;
	;DESCRIPTION:
	; Generates a random position and size for an obstacle,
	; and then has it drawn.
	;
	;DETAILED DESCRIPTION:
	; Generates a random X position for an object according to the settings set in the SETTINGS file.
	; Generates a random Y position for an object according to the settings set in the SETTINGS file.
	; Generates a random height for an object according to the settings set in the SETTINGS file.
	; Generates a random width for an object according to the settings set in the SETTINGS file.
	; Calls GUI_Draw_Obstacle to draw the obstacle on the screen.
	;
	; Obstacles may overlap.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	;Generate random X Position
	mov ax, xStartObstacles
	push ax
	mov ax, xEndObstacles
	push ax
	call generateRandom
	push ax
	;Generate random Y Position
	mov ax, yStartObstacles
	push ax
	mov ax, yEndObstacles
	push ax
	call generateRandom
	push ax
	;Generate random obstacle width
	diff1 equ maxWidthObstacle-4 ; To prevent only the borders showing.
	mov ax, 4
	push ax
	mov ax, diff1
	push ax
	call generateRandom
	push ax
	;Generate random obstacle height
	diff2 equ maxHeightObstacle-4 ; To prevent only the borders showing.
	mov ax, 4
	push ax
	mov ax, diff2
	push ax
	call generateRandom
	push ax
	
	call GUI_Draw_Obstacle	
	
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

Core_Place_Obstacle ENDP

END