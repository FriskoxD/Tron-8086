; Program: TRON
; File: VAR.ASM
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
public player1DirectionX
public player1DirectionY
public player2DirectionX
public player2DirectionY

public player1PositionX
public player1PositionY
public player2PositionX
public player2PositionY

public player1Visibility
public player2Visibility

public player1JumpPoints
public player2JumpPoints

public player1Score
public player2Score

public player1JumpRemaining
public player2JumpRemaining

public matchNumber

public timeHigh
public timeLow

public bitShiftRandom

public oldVideoMode

player1DirectionX db 1
player1DirectionY db 0
player2DirectionX db -1
player2DirectionY db 0

player1PositionX dw 0
player1PositionY dw 100
player2PositionX dw 319
player2PositionY dw 100

player1Visibility db 0
player2Visibility db 0

player1JumpPoints db 0
player2JumpPoints db 0

player1JumpRemaining db 0
player2JumpRemaining db 0

player1Score db 0
player2Score db 0

matchNumber	db	0

timeHigh	dw 0
timeLow		dw 0

bitShiftRandom db 0

oldVideoMode dw 0

.CODE        ; code segment

END