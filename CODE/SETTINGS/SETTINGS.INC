; Program: TRON
; File: SETTINGS.INC
;
; Author: Jan De Groot <jan.degroot@live.be>
; Author: Khaled Radmal
;
; Copyright 2015 under the Raindrop License Agreement V1.1.
; If you did not receive a copy of the Raindrop License Agreement 
; with this Software, please contact the Author of the Software.
;


;----- GAME SETTINGS ---------

extern matchNumberHandicap:abs
extern player1ScoreHandicap:abs
extern player2ScoreHandicap:abs
extern player1JumpHandicap:abs
extern player2JumpHandicap:abs

extern maxWin:abs
extern maxMatch:abs

extern minObstacles:abs
extern maxObstacles:abs
extern numberOfObstacles:abs
extern maxHeightObstacle:abs
extern maxWidthObstacle:abs

extern xStartObstacles:abs
extern xEndObstacles:abs
extern yStartObstacles:abs
extern yEndObstacles:abs

extern playerJumpTime:abs

;----- GRAPHICAL SETTINGS ---------

extern screenW:abs
extern screenH:abs
extern screenSize:abs
extern backgroundColour:abs
extern player1Colour:abs
extern player2Colour:abs
extern obstacleColourBody:abs
extern colourEdge:abs
extern palette:byte

extern xPositionArena:abs
extern yPositionArena:abs
extern widthArena:abs
extern heightArena:abs

;----- TIME SETTINGS ---------

extern splashScreenDelay:abs
extern victoryDelay:abs
extern playerSpeed:abs

;----- INPUT SETTINGS ---------

extern player1Up:abs
extern player1Down:abs
extern player1Left:abs
extern player1Right:abs
extern player1Special:abs

extern player2Up:abs
extern player2Down:abs
extern player2Left:abs
extern player2Right:abs
extern player2Special:abs

extern gameStart:abs
extern gameQuit:abs
extern gamePause:abs

extern player1UpBit:abs
extern player1DownBit:abs
extern player1LeftBit:abs
extern player1RightBit:abs
extern player1SpecialBit:abs

extern player2UpBit:abs
extern player2DownBit:abs
extern player2LeftBit:abs
extern player2RightBit:abs
extern player2SpecialBit:abs

extern gameStartBit:abs
extern gameQuitBit:abs
extern gamePauseBit:abs