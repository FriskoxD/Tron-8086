; Program: TRON
; File: SETTINGS.ASM
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

; For actual settings jump to the second section.

;----- DO NOT EDIT BELOW THIS LINE (unless you're awesome) ---------

	;----- GAME SETTINGS ---------

	public matchNumberHandicap
	public player1ScoreHandicap
	public player2ScoreHandicap
	public player1JumpHandicap
	public player2JumpHandicap

	public maxWin
	public maxMatch

	public minObstacles
	public maxObstacles
	public numberOfObstacles
	public maxHeightObstacle
	public maxWidthObstacle

	public xStartObstacles
	public xEndObstacles
	public yStartObstacles
	public yEndObstacles
	
	public playerJumpTime

	;----- GRAPHICAL SETTINGS ---------

	public screenW
	public screenH
	public screenSize
	public backgroundColour
	public player1Colour
	public player2Colour
	public obstacleColourBody
	public colourEdge
	public palette

	public xPositionArena
	public yPositionArena
	public widthArena
	public heightArena

	;----- TIME SETTINGS ---------

	public splashScreenDelay
	public victoryDelay
	public playerSpeed

	;----- INPUT SETTINGS ---------

	public player1Up
	public player1Down
	public player1Left
	public player1Right
	public player1Special

	public player2Up
	public player2Down
	public player2Left
	public player2Right
	public player2Special

	public gameStart
	public gameQuit
	public gamePause

	public player1UpBit
	public player1DownBit
	public player1LeftBit
	public player1RightBit
	public player1SpecialBit

	public player2UpBit
	public player2DownBit
	public player2LeftBit
	public player2RightBit
	public player2SpecialBit

	public gameStartBit
	public gameQuitBit
	public gamePauseBit
	
;----- GRAPHICAL SETTINGS ---------

; For fun playing consider these tips:
; - Don't give a player the same colour as the background.
; - Don't give a player the same colour as an edge.
; - Don't give the background the same colour as an edge.
; - Don't do anything that might seem like a cool hack to the game. (Except when you want to annoy your friends.)

backgroundColour	equ 0 ; The colour index of the background. (See palette below.)
player1Colour		equ 2 ; The colour index of player 1. (See palette below.)
player2Colour		equ 3 ; The colour index of player 2. (See palette below.)
obstacleColourBody	equ 4 ; The colour index of the body of obstacles. (See palette below.)
colourEdge			equ 5 ; The colour index of borders/edges in the game. (See palette below.)

; Do not change the amount of colours defined here.
; To define a new colour:
; - Choose your desired colour in an editor like GIMP.
; - Get the RGB values from 0->255.
; - Take the R value and divide it by 255. Now multiply it by 63.
; - Take the G value and divide it by 255. Now multiply it by 63.
; - Take the B value and divide it by 255. Now multiply it by 63.
; - Insert these values correspondingly into the colour you want to replace.
; - Make sure that you insert integer numbers only (0->63).

palette db	19, 22, 23, ; Background grey
			63, 63, 63, ; White
			09, 55, 63, ; Blue
			63, 32, 09, ; Orange
			60, 59, 42, ; Yellow
			00, 00, 00  ; Black

; Usually you do not want to change the values below.
; However, it might prove useful if your resolution is higher than 200*320.
; If this is the case you will have to experiment to find the right values.
			
screenW				equ 320 ; The width of the screen.
screenH				equ 200 ; The height of the screen
screenSize			equ screenW*screenH ; Don't edit this. Even IF you think you should, you're wrong.

widthArena			equ screenW ; The width of the effective playing field (-1 pixel for the border).
heightArena			equ 190 ; The height of the effective playing field (-1 pixel for the border).
xPositionArena		equ 0 ; The starting position from the left of the screen for the playing field.
yPositionArena		equ screenH-heightArena ; The starting position from the top of the screen for the playing field. Usually you can keep this at the default value.


;----- GAME SETTINGS ---------

matchNumberHandicap			equ 0 ; If for some reason you want the match number to start at something other than 0... well you're the boss. Just keep it below the maximum match number.
player1ScoreHandicap		equ 0 ; The amount of wins player one defaults to when a new game is started.
player2ScoreHandicap		equ 0 ; The amount of wins player two defaults to when a new game is started.
player1JumpHandicap			equ 0 ; The amount of jump points player one defaults to when a new game is started.
player2JumpHandicap			equ 0 ; The amount of jump points player two defaults to when a new game is started.

maxWin						equ 3 ; The amount of matches a player must win to win the game.
maxMatch					equ 0 ; The maximum amount of matches per game. Usually you would keep this at (maxWin*2)-1. Players don't get awarded a score when they tie, so you might want to make this number higher than (maxWin*2)-1 too. Your choice, really.

minObstacles				equ 1 ; The minimum amount of obstacles on the course. (May never be higher than the maximum amount of obstacles.)
maxObstacles				equ 3 ; The maximum amount of obstacles on the course. (May never be lower than the minimum amount of obstacles.)
maxHeightObstacle			equ 20 ; The maximum height of the obstacles in pixels.
maxWidthObstacle			equ 80 ; The maximum width of the obstacles in pixels.
numberOfObstacles			equ maxObstacles-minObstacles ; Don't edit this. Even IF you think you should, you're wrong.

xStartObstacles				equ 4 ; Take into account that there is a border of 1 pixel AND the player might crash head first into an obstacle when the game begins.
xEndObstacles				equ screenW - maxWidthObstacle - 4 ; Take into account that there is a border of 1 pixel AND the player might crash head first into an obstacle when the game begins.
yStartObstacles				equ yPositionArena + 4 ; Take into account that there is a border of 1 pixel AND the player might crash head first into an obstacle when the game begins.
yEndObstacles				equ screenH - maxHeightObstacle - 4 ; Take into account that there is a border of 1 pixel AND the player might crash head first into an obstacle when the game begins.

playerJumpTime				equ 5 ; The jump time in pixels

;----- TIME SETTINGS ---------

ticksPerSecond 		equ 18 ; The ticks per second counted by the machine.
splashScreenDelay 	equ ticksPerSecond * 3 ; Show the splash screen for X seconds.
victoryDelay		equ ticksPerSecond * 2 ; Show the "Player Y won" screen for X seconds.
playerSpeed			equ 1 ; Time for a player to move one pixel

;----- INPUT SETTINGS ---------

; The modifiable settings in this section are at the bottom.

; Do not modify the settings below unless you know what you're doing.
; If you're not entirely sure, you probably don't know what you're doing.

key_0 equ 48 ; ASCII Code
key_1 equ key_0+1 ; ASCII Code.
key_2 equ key_0+2 ; ASCII Code.
key_3 equ key_0+3 ; ASCII Code.
key_4 equ key_0+4 ; ASCII Code.
key_5 equ key_0+5 ; ASCII Code.
key_6 equ key_0+6 ; ASCII Code.
key_7 equ key_0+7 ; ASCII Code.
key_8 equ key_0+8 ; ASCII Code.
key_9 equ key_0+9 ; ASCII Code.

key_a equ 97 ; ASCII Code
key_b equ key_a+1 ; ASCII Code.
key_c equ key_a+2 ; ASCII Code.
key_d equ key_a+3 ; ASCII Code.
key_e equ key_a+4 ; ASCII Code.
key_f equ key_a+5 ; ASCII Code.
key_g equ key_a+6 ; ASCII Code.
key_h equ key_a+7 ; ASCII Code.
key_i equ key_a+8 ; ASCII Code.
key_j equ key_a+9 ; ASCII Code.
key_k equ key_a+10 ; ASCII Code.
key_l equ key_a+11 ; ASCII Code.
key_m equ key_a+12 ; ASCII Code.
key_n equ key_a+13 ; ASCII Code.
key_o equ key_a+14 ; ASCII Code.
key_p equ key_a+15 ; ASCII Code.
key_q equ key_a+16 ; ASCII Code.
key_r equ key_a+17 ; ASCII Code.
key_s equ key_a+18 ; ASCII Code.
key_t equ key_a+19 ; ASCII Code.
key_u equ key_a+20 ; ASCII Code.
key_v equ key_a+21 ; ASCII Code.
key_w equ key_a+22 ; ASCII Code.
key_x equ key_a+23 ; ASCII Code.
key_y equ key_a+24 ; ASCII Code.
key_z equ key_a+25 ; ASCII Code.

key_space	equ 32 ; ASCII Code.
key_escape	equ 27 ; ASCII Code.
key_enter	equ 13 ; ASCII Code.

key_left	equ 75 ; This is a BIOS scan code, not ASCII!
key_right	equ 77 ; This is a BIOS scan code, not ASCII!
key_up		equ 72 ; This is a BIOS scan code, not ASCII!
key_down	equ 80 ; This is a BIOS scan code, not ASCII!

player1UpBit		equ	00000100b ; This is used internally to determine which keys are pressed.
player1DownBit		equ	00001000b ; This is used internally to determine which keys are pressed.
player1LeftBit		equ	00000010b ; This is used internally to determine which keys are pressed.
player1RightBit		equ	00000001b ; This is used internally to determine which keys are pressed.
player1SpecialBit	equ	00000100b ; This is used internally to determine which keys are pressed.

player2UpBit		equ	01000000b ; This is used internally to determine which keys are pressed.
player2DownBit		equ	10000000b ; This is used internally to determine which keys are pressed.
player2LeftBit		equ	00100000b ; This is used internally to determine which keys are pressed.
player2RightBit		equ	00010000b ; This is used internally to determine which keys are pressed.
player2SpecialBit	equ	00001000b ; This is used internally to determine which keys are pressed.

gameStartBit		equ	00000001b ; This is used internally to determine which keys are pressed.
gameQuitBit			equ	00000010b ; This is used internally to determine which keys are pressed.
gamePauseBit		equ 00010000b ; This is used internally to determine which keys are pressed.

; Pretty self explanatory, isn't it?
; You can map the same key multiple times, but not for the same player.

player1Up		equ key_w
player1Down		equ key_s
player1Left		equ key_a
player1Right	equ key_d
player1Special	equ key_space

player2Up		equ key_up
player2Down		equ key_down
player2Left		equ key_left
player2Right	equ key_right
player2Special	equ key_l

gameStart		equ key_enter
gameQuit		equ key_escape
gamePause		equ key_p

.CODE        ; code segment

END