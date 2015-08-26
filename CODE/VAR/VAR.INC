; Program: TRON
; File: VAR.INC
;
; Author: Jan De Groot <jan.degroot@live.be>
; Author: Khaled Radmal
;
; Copyright 2015 under the Raindrop License Agreement V1.1.
; If you did not receive a copy of the Raindrop License Agreement 
; with this Software, please contact the Author of the Software.
;

extern player1DirectionX:byte
extern player1DirectionY:byte
extern player2DirectionX:byte
extern player2DirectionY:byte

extern player1PositionX:word
extern player1PositionY:word
extern player2PositionX:word
extern player2PositionY:word

extern player1Visibility:byte
extern player2Visibility:byte

extern player1JumpPoints:byte
extern player2JumpPoints:byte

extern player1JumpRemaining:byte
extern player2JumpRemaining:byte

extern player1Score:byte
extern player2Score:byte

extern matchNumber:byte

extern timeHigh:word
extern timeLow:word

extern bitShiftRandom:byte

extern oldVideoMode:word