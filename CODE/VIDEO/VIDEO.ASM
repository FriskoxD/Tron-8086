; Program: TRON
; File: VIDEO.ASM
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

Video_Initialize PROC NEAR PUBLIC

	;----------------------------------------------------
	; Video_Get_Colour
	;----------------------------------------------------
	;ARGUMENTS:
	; -None
	;
	;RETURNS:
	; -AX: Current video mode.
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; Initialized the video mode for graphical editing.
	;
	;DETAILED DESCRIPTION:
	; Saves the old video mode.
	; Then sets the new video mode.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push bx
	push cx
	push dx
	push si
	push ds
	
	; Get the current video mode.
	xor al, al
	mov ah, 0Fh
	int 10h
	
	xor ah, ah ; We don't need the data in ah.
	push ax ; Push it to the stack for later use.
	
	mov ah, 00h ; set the video mode
	mov al, 13h ; mode 13h
	int 10h ; change the video mode
	
	mov ax, @data ; set data segment
	mov ds, ax ; in ds
	mov es, ax ; and in es
	mov dx, offset palette ; set the palette (DAC) (offset relative to es)
	xor bx, bx ; set bx to zero (start at colour index 0)
	mov cx, 6 ; set colour 0, 1 and 2 (3 indexes in total)
	
	mov ax, 1012h ; function 1012h of int 10h (set DAC palette)
	int 10h ; call Video BIOS
	
	mov ax, 0a000h ; the start of the video segment
	mov es, ax ; put the video segment into es
	
	pop ax ; It returns the old video mode
	
	; restore context
	pop ds
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 0
	
Video_Initialize ENDP

Video_Restore PROC NEAR PUBLIC

	;----------------------------------------------------
	; Video_Get_Colour
	;----------------------------------------------------
	;ARGUMENTS:
	; -[STACK] Old video mode.
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; Restore the original video mode.
	;
	;DETAILED DESCRIPTION:
	; REstore the original video mode.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	push ds
	
	; Restore the old video mode
	mov ax, 4[bp]
	xor ah, ah ; We don't need the data in ah
	int 10h
	
	; restore context
	pop ds
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
	
Video_Restore ENDP

Video_Draw_Rectangle PROC NEAR PUBLIC
	
	;----------------------------------------------------
	; Video_Draw_Rectangle
	;----------------------------------------------------
	;ARGUMENTS:
	; -[STACK] xPosition
	; -[STACK] yPosition
	; -[STACK] colourIndex
	; -[STACK] width
	; -[STACK] height
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; Colours a solid rectangle on the screen.
	;
	;DETAILED DESCRIPTION:
	; Calculates the starting offset for the rectangle.
	; Calculate the offset to get the the next line of the rectangle.
	; Draws a solid rectangle.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	

	; First we calculate the row offset for the y value
	mov ax, 10[bp]
	xor dx, dx ; we are going to multiply, so we have to clear dx
	mov bx, screenW
	mul bx
	
	; Now we add the offset for the x value
	add ax, 12[bp]
	mov di, ax ; and save the resulting offset for use
	
	; Calculate the line skip
	sub bx, 6[bp] ; 6[bp] is the width of the rectangle
	
	; Get the colour of the rectangle
	mov ax, 8[bp]
	
	; Get the height of the rectangle
	mov dx, 4[bp]
	 
	@loopNextRow:
		mov cx, 6[bp] ; Set the width of the rectangle
		rep stosb ; Colour the pixels
		
		add di, bx ; Set the offset to the next line
		dec dx
	cmp dx, 0
	jne @loopNextRow

		
	; restore context
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return and pop 10 bytes
	ret 10
	
Video_Draw_Rectangle ENDP

Video_Clear_Screen PROC NEAR PUBLIC

	;----------------------------------------------------
	; Video_Clear_Screen
	;----------------------------------------------------
	;ARGUMENTS:
	; -[STACK] colourIndex
	;
	;RETURNS:
	; -None
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; Changes the screen to one single colour.
	;
	;DETAILED DESCRIPTION:
	; Changes the screen to one single colour.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov ax, 4[bp] ; the colour we want to display
	mov ah, al ; the colour we want to display (since we are storing a word, we need ah too)
	mov cx, screenSize ; the amount of pixels
	mov di, 0 ; the initial offset within the memory

	; move ax to [es:di] and increase di afterwards
	rep stosw ; repeat stosw until cx = 0
	
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
	ret 2

Video_Clear_Screen ENDP

Video_Get_Colour PROC NEAR PUBLIC

	;----------------------------------------------------
	; Video_Get_Colour
	;----------------------------------------------------
	;ARGUMENTS:
	; -[STACK] xPosition
	; -[STACK] yPosition
	;
	;RETURNS:
	; -AX: The index on the colour palette of the pixel.
	;
	;CALLS ON PROCEDURES:
	; -None
	;
	;DESCRIPTION:
	; Returns the colour of a pixel on the screen.
	;
	;DETAILED DESCRIPTION:
	; Reads the colour from the video memory.
	; Returns the colour in AX.
	
	push bp	; save dynamic link
	mov	bp, sp	; update bp
	; save context on stack
	push bx
	push cx
	push dx
	push si
	push ds
	
   	; Calculate the offset
	mov ax, 4[bp] ; Get the Y position
	mov bx, screenW ; Get the width of the screen in pixels
	mul bx  ; Get the Y position in pixels
	add ax, 6[bp] ; Add the X offset
	
	mov si, ax ; Set the offset
	mov ax, 0a000h
	mov ds, ax ; Set the video memory segment
	lodsb ; Get the pixel value
	xor ah, ah ; Clear junk out of the MSB
	
	; restore context
	pop ds
	pop	si
	pop	dx
	pop	cx
	pop	bx
	; restore sp and bp
	mov	sp, bp
	pop	bp
	; return
	ret 4

Video_Get_Colour ENDP

END