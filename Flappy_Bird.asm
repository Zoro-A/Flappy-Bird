[org 0x0100]


; Up key-> Bird goes up
; releasing Up key->bird goes down
; Esc->Confirmation screen-> 
; Press Y to exit the game or N to continue to the game

jmp start
gameName:db 'Flappy Bird'
groupname:db 'Hawk Tuah'
name1:db 'Mahhee Ibn Ahmar Bukhari '
rollNumber1:db '23L-0990'
name2:db 'Muhammad Ali Mahoon'
rollNo2:db '23L-0531'
instruction_heading: db 'INSTRUCTIONS'
instructions: db 'Up key -> Bird goes Up'
instructions2: db 'Releasing up key -> bird goes down'
instructions3: db 'Escape -> pauses the game and gives option to resume or quit'
presstoplay: db 'press any key to start the game'

birdPosition:dw 1930
birdDirection:db'D'

upperpillarRow: dw 0
lowerpillarRow:dw 22
pillarWidth:dw 14		;The width of the pillar is in bytes of the screen 
pillarHeight:dw 8
firstPillarOffset:dw 50
secondPillarOffset:dw 96
thirdPillarOffset:dw 142

firstPillarHeight:dw 7
secondPillarHeight:dw 10
thirdPillarHeight:dw 4

firstLowerHeight:dw 10
secondLowerHeight:dw 7
thirdLowerHeight:dw 13

pauseScreenString:db 'Press Y to end the game or press N to resume',0 ;44
randomUpper:dw 13,5,9,4,10,7
randomLower:dw 4,12,9,13,7,10
count:dw 0
scoreString: db 'Score:'
score:dw 0
endGameString:db 'GAME IS OVER',0;12
oldisr:dd 0
oldTimer: dd 0

isNpressed:db 0
isYpressed:db 0
isEscapepressed:db 0

collisionDetected:db 0
seconds:dw 0
isReleased:dw 0
delay:
    push cx
    push bx
    push ax

    mov cx, 03H  ; Reduced outer loop counter
    mov bx, 03H  ; Reduced inner loop counter

delay_loop:
    mov ax, 0
inner_delay_loop:
    dec ax
    jnz inner_delay_loop  ; Inner delay loop
    loop delay_loop       ; Outer delay loop

    pop ax
    pop bx
    pop cx
ret

birdDrop:
	mov cx,15
	
_bird_drop:
	mov di,[birdPosition]
	mov word[es:di],0x9720
	
	mov ax,[birdPosition]
	sub ax,160
	mov [birdPosition],ax
	call bird
	loop _bird_drop
	
ret
clrscreen:
    pusha
    mov ax, 0xb800         ; Video memory segment
    mov es, ax
    xor di, di             ; Start at the beginning of video memory

	loop_clear:
		mov word [es:di], 0x0720 ; 0x07 (black background, grey text), 0x20 (space)
		add di, 2              ; Move to the next character cell
		cmp di, 4000           ; 4000 bytes = 80 columns * 25 rows * 2 bytes per cell
		jne loop_clear         ; Loop until all cells are cleared

	popa
ret


background:
	push ax
	mov di,0
	mov ax,0xb800
	mov es,ax

	loop1:
		mov word[es:di],0x9720
		add di,2
		cmp di,4000
	jne loop1


	pop ax
ret

pauseScreen:
	push 0xb800
	pop es
	mov di,0
	
	mov cx,4000

_loop3:
		mov word[es:di],0xBF20
		add di,2
		loop _loop3
	
	mov ah,0x13
	mov al,0x1
	mov bh,0
	mov bl,0xc
	mov dx,0x0A80
	mov cx,37
	push cs
	pop es
	mov bp,pauseScreenString
	int 0x10	
	
ret

collisionDetecting:
    push bp
	mov bp,sp
	push ax
	push di
	push es

   mov di,[bp+4]

    mov ax, 0xb800
    mov es, ax

    ; Check for collision
    mov ax, [es:di]
    cmp ax, 0x9720         ; Check if it's blue sky
    je next_check

    call birdDrop
	jmp exit
   

next_check:
	mov di,[bp+6]
	add di,2
	
	mov ax, 0xb800
	mov es, ax

    ; Check for collision
    mov ax, [es:di]
    cmp ax, 0x9720 
	je no_collision
	
	;call endGameScreen
	call birdDrop
	jmp exit
no_collision:
    pop es
	pop di
	pop ax
	pop bp
ret 4
	
endGameScreen:
	push 0xb800
	pop es
	mov di,0
	
	mov cx,4000
		
	_loop1:
		mov word[es:di],0xCF20
		add di,2
		loop _loop1
		
	mov ah,0x13
	mov al,0x1
	mov bh,0
	mov bl,0xF
	mov dx,0x0470
	mov cx,12
	push cs
	pop es
	mov bp,endGameString
	int 0x10
	
	mov dx,0x0674
	mov cx,6
	mov bp,scoreString
	int 0x10
	
	push 1208
	mov ax,[score]
	push ax
	call printScore
	
ret
		
printstr:
		push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax				; point es to video base

		mov di, 3982			; point di to required location
		mov si, [bp+6]			; point si to string
		mov cx, [bp+4]			; load length of string in cx
		mov ah,0x6F		; load attribute in ah

	nextchar:	
		mov al, [si]			; load next char of string
		mov [es:di], ax			; show this char on screen
		add di, 2				; move to next screen location
		add si, 1				; move to next char in string
		call delay
		loop nextchar			; repeat the operation cx times

	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
ret 4

upperpillar:
	push bp
	mov bp,sp
	mov ax,0xb800
	mov es,ax
	mov di,0
	add di,[firstPillarOffset]
	mov bx,di
	add bx,[pillarWidth]
	mov dx,[firstPillarHeight]
	mov ax,[bp+4]
	push di
	push bx
loopu:
	mov word[es:di],ax
	add di,2
	
	cmp di,bx
	jne loopu
	
pushing:
	pop bx
	pop di
	add bx,160
	add di,160
	
	push di
	push bx
	
	sub dx,1
	cmp dx,0
	jne loopu

pop bx
pop di


secondPillar:
	mov ax,0xb800
	mov es,ax
	mov di,0
	add di,[secondPillarOffset]
	mov bx,di
	add bx,[pillarWidth]
	mov dx,[secondPillarHeight]
	push di
	push bx
	mov ax,[bp+4]
loop2:
	mov word[es:di],ax
	add di,2
	
	cmp di,bx
	jne loop2
	
pushing2:
	pop bx
	pop di
	add bx,160
	add di,160
	
	push di
	push bx
	
	sub dx,1
	cmp dx,0
	jne loop2
	
pop bx
pop di


thirdPillar:
	mov ax,0xb800
	mov es,ax
	mov di,0
	add di,[thirdPillarOffset]
	mov bx,di
	add bx,[pillarWidth]
	mov dx,[thirdPillarHeight]
	push di
	push bx
	mov ax,[bp+4]
loop3:
	mov word[es:di],ax
	add di,2
	
	cmp di,bx
	jne loop3
	
pushing3:
	pop bx
	pop di
	add bx,160
	add di,160
	
	push di
	push bx
	
	sub dx,1
	cmp dx,0
	jne loop3
	
pop bx
pop di
pop bp

ret 2


lowerpillar:
	push bp
	mov bp,sp
	mov ax,0xb800
	mov es,ax
	mov di,[lowerpillarRow]
	mov ax,80
	mul di
	shl ax,1
	mov di,ax
	add di,[firstPillarOffset]
	mov bx,di
	add bx,[pillarWidth]
	mov dx,[firstLowerHeight]
	push di
	push bx
	mov ax,[bp+4]
lowerLoop1:
	mov word[es:di],ax
	add di,2
	
	cmp di,bx
	jne lowerLoop1
	
pushingL1:
	 pop bx
	 pop di
	
	 sub bx,160
	 sub di,160
	
	 push di
	 push bx
	
	 sub dx,1
	 cmp dx,0
	 jne lowerLoop1

pop bx
pop di

secondLower:
	mov ax,0xb800
	mov es,ax
	mov bx,[lowerpillarRow]
	mov ax,80
	mul bx
	shl ax,1
	mov di,ax
	add di,[secondPillarOffset]
	mov bx,di
	add bx,[pillarWidth]
	mov dx,[secondLowerHeight]
	push di
	push bx
	mov ax,[bp+4]
lowerLoop2:
	mov word[es:di],ax
	add di,2
	
	cmp di,bx
	jnz lowerLoop2
	
pushingL2:
	 pop bx
	 pop di
	
	 sub bx,160
	 sub di,160
	
	 push di
	 push bx
	
	 sub dx,1
	 cmp dx,0
	 jne lowerLoop2

pop bx
pop di

thirdLower:
	mov ax,0xb800
	mov es,ax
	mov bx,[lowerpillarRow]
	mov ax,80
	mul bx
	shl ax,1
	mov di,ax
	add di,[thirdPillarOffset]
	mov bx,di
	add bx,[pillarWidth]
	mov dx,[thirdLowerHeight]
	push di
	push bx
	mov ax,[bp+4]
lowerLoop3:
	mov word[es:di],ax
	add di,2
	
	cmp di,bx
	jnz lowerLoop3
	
pushingL3:
	 pop bx
	 pop di
	
	 sub bx,160
	 sub di,160
	
	 push di
	 push bx
	
	 sub dx,1
	 cmp dx,0
	 jne lowerLoop3

pop bx
pop di
pop bp

ret 2
	
ground:
	mov ax,0xb800
	mov es,ax
	mov bx,[lowerpillarRow]
	add bx,1
	mov ax,80
	mul bx
	shl ax,1
	mov di,ax
	
groundLoop:
	mov word[es:di],0x6720
	add di,2
	
	cmp di,4000
	
	jnz groundLoop
	
ret
	
scrollLeft:
	pusha
	
	push 0x9720
	call upperpillar
	push 0x9720
	call lowerpillar
	sub word[firstPillarOffset],2
	sub word[secondPillarOffset],2
	sub word[thirdPillarOffset],2
	
	cmp word[firstPillarOffset],0
	jnz compare2
	
	cmp word[count],12
	jnz moveAsitis
	mov word[count],0
	
moveAsitis:	
	mov si,[count]
	mov bx,randomUpper
	mov ax,[bx+si]
	mov [firstPillarHeight],ax
	
	mov bx,randomLower
	mov ax,[bx+si]
	mov [firstLowerHeight],ax
	
	add si,2
	mov [count],si
	
	mov ax,146
	mov [firstPillarOffset],ax

compare2:	
	cmp word[secondPillarOffset],0
	jnz compare3
	
	
	mov si,[count]
	mov bx,randomUpper
	mov ax,[bx+si]
	mov [secondPillarHeight],ax
	
	mov bx,randomLower
	mov ax,[bx+si]
	mov [secondLowerHeight],ax
	
	add si,2
	mov [count],si
	mov ax,146
	mov [secondPillarOffset],ax
	
compare3:
	cmp word[thirdPillarOffset],0
	jnz draw
	
	
	mov si,[count]
	mov bx,randomUpper
	mov ax,[bx+si]
	mov [thirdPillarHeight],ax
	
	mov bx,randomLower
	mov ax,[bx+si]
	mov [thirdLowerHeight],ax
	
	add si,2
	mov [count],si
	mov ax,146
	mov [thirdPillarOffset],ax

draw:
	push 0xA720
	call upperpillar
	push 0xA720
	call lowerpillar
	popa
ret

printScore: 
		push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax			; point es to video base

		mov ax, [bp+4]		; load number in ax= 4529
		mov bx, 10			; use base 10 for division
		mov cx, 0			; initialize count of digits

	nextdigit:		
		mov dx, 0			; zero upper half of dividend
		div bx				; divide by 10 AX/BX --> Quotient --> AX, Remainder --> DX ..... 
		add dl, 0x30		; convert digit into ascii value
		push dx				; save ascii value on stack

		inc cx				; increment count of values
		cmp ax, 0			; is the quotient zero
		jnz nextdigit		; if no divide it again


		mov di, [bp+6]			; point di to top left column
	nextpos:	
		pop dx				; remove a digit from the stack
		mov dh, 0x6F		; use normal attribute
		mov [es:di], dx		; print char on screen
		add di, 2			; move to next screen location
		loop nextpos		; repeat for all digits on stack

pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 4

calculateScore:

	cmp word[firstPillarOffset],2
	jnz pillar2
	mov ax,[score]
	add ax,1
	mov [score],ax
	
pillar2:
	cmp word[secondPillarOffset],2
	jnz pillar3
	mov ax,[score]
	add ax,1
	mov [score],ax
	
pillar3:
	cmp word[thirdPillarOffset],2
	jnz end1
	mov ax,[score]
	add ax,1
	mov [score],ax
	
end1:
	ret 
	
bird:
	push ax
	push di
	push es
	mov ah,0x14
	mov al,0xDB
	
	push 0xb800
	pop es
	
	mov di,[birdPosition]
	mov word[es:di],ax
	pop es 
	pop di
	pop ax 
	ret
	
kbisr:
	push ax
	push es
	
	mov ax,0xb800
	mov es,ax
	
	in al,0x60
	cmp al,0x48
	
	jne nextcomp
	mov word[isReleased],0
	mov byte[birdDirection],'U'
	jmp nomatch
	
nextcomp:
	cmp al,0xc8
	jne nomatch
	
	;mov byte[birdDirection],'D'
	mov word[isReleased],1
		
nomatch:
	cmp al,0x01     ;escape key 
	je escape_pressed

	mov al,0x20
	out 0x20,al
	pop es
	pop ax
	iret
	;jmp far[cs:oldisr]
escape_pressed:
		mov byte[isEscapepressed],1
		call clrscreen          ; Clear the screen

		; Display confirmation message
		mov ax, 0xb800          ; Set video memory segment
		mov es, ax
		mov di, 160 * 12 + 30   ; Position at row 12, column 30

		lea si, pauseScreenString
.print_message:
		lodsb
		cmp al, 0
		je wait_choice         ; End of message
		mov ah, 0x0F            ; Set text attribute (white on black)
		mov word [es:di], ax
		add di, 2
		jmp .print_message

wait_choice:
		in al, 0x60             ; Wait for another keypress
		cmp al, 0x15            ; Check for 'Y'
		jnz Ncheck 
		mov byte[isYpressed],1
		jmp khatam

Ncheck:		
		cmp al, 0x31            ; Check for 'N'
		jnz wait_choice
		mov byte[isNpressed],1
								; Loop if invalid key
khatam:
		mov al,0x20
		out 0x20,al
		pop es
		pop ax
		iret
		
timer:		
	;mov word[cs:seconds],0
	push ax
	cmp word [cs:isReleased],1; is the printing flag set
	jne skipall ; no, leave the ISR
	
	push 152
	inc word [cs:seconds] ; increment tick count
	push word [cs:seconds]
	call printScore ; print tick count
	cmp word[cs:seconds],2
	jne skipall
	
	mov word[cs:seconds],0
	mov byte[birdDirection],'D'

skipall:
	mov al, 0x20
	out 0x20, al ; send EOI to PIC
	pop ax
	iret ; return from interrupt

InstructionScreen:
	push cs
	pop ds
	push es
	push 0xb800
	pop es
	mov di,0
	
	mov cx, 4000
	_loopu:
		mov word[es:di], 0xBF20
		add di,2
		loop _loopu
	
	mov ah,0x13
	mov al,0x1
	mov bh,0
	mov bl,0xc
	
	mov dx,0x0572
	mov cx,12
	push cs
	pop es
	mov bp,instruction_heading
	int 0x10
	
	mov dx, 0x076D
	mov cx,22
	mov bp,instructions
	int 0x10
	
	mov dx,0x0967
	mov cx,34
	mov bp,instructions2
	int 0x10
	
	mov dx,0x0B5B
	mov cx,60
	mov bp,instructions3
	int 0x10

	
	pop es
ret
	

	
IntroScreen:
	push  es
	push 0xb800
	pop es
	mov di,0
	
	mov cx,4000
	
	_loop2:
		mov word[es:di],0xBF20
		add di,2
		loop _loop2
	
	mov ah,0x13
	mov al,0x1
	mov bh,0
	mov bl,0xc
	mov dx,0x0470
	mov cx,11
	push cs
	pop es
	mov bp,gameName
	int 0x10
	
	mov dx,0x0671
	mov cx,9
	mov bp,groupname
	int 0x10
	
	mov dx,0x086a
	mov cx,24
	mov bp,name1
	int 0x10
	
	mov dx,0x0a71
	mov cx,8
	mov bp,rollNumber1
	int 0x10
	
	mov dx,0x0c6c
	mov cx,19
	mov bp,name2
	int 0x10
	
	mov dx,0x0e71
	mov cx,8
	mov bp,rollNo2
	int 0x10
	
	pop es
ret

updateBird:
	mov dx,[birdPosition]
	cmp byte[birdDirection],'U'
	jne continue
	
	mov di,dx
	push di
	sub dx,160
	push dx
	call collisionDetecting
	
	mov word[es:di],0x9720
	mov [birdPosition],dx
	call bird
here:
ret
continue:
	mov di,dx
	
	push di
	add dx,160
	push dx
	call collisionDetecting
	
	mov word[es:di],0x9720
	mov [birdPosition],dx
	call bird
jmp here


mainScreen:
	call background
	push 0xA720
	call upperpillar
	push 0xA720
	call lowerpillar
	call ground
	call bird
	
	mov ax,scoreString
	push ax
	push 6
	call printstr
ret

animation:
	call updateBird
	call scrollLeft
	call delay

	call calculateScore
	push 3996
	push word[score]
	call printScore
	
ret

wait_for_retrace:
    mov dx, 0x03DA        ; VGA status register
.wait_not_retrace:
    in al, dx
    test al, 0x08         ; Check if in vertical retrace
    jz .wait_not_retrace  ; Loop until retrace starts
.wait_retrace:
    in al, dx
    test al, 0x08         ; Wait until retrace ends
    jnz .wait_retrace
ret
	
start:
	mov ax,1003h
	mov bx,0
	int 10h
;saving old isr so that we can come back to it
	call IntroScreen
	mov ah,0
	int 0x16
	call InstructionScreen
	mov ah,0
	int 0x16
	call mainScreen
	mov ah,0x13
	mov al,0x1
	mov bh,0
	mov bl,0xc
	mov dx,0x0a68
	mov cx,31
	push cs
	pop es
	mov bp,presstoplay
	int 0x10
	
	mov ah,0
	int 0x16

	xor ax,ax
	mov es,ax
	mov ax,[es:9*4]
	mov [oldisr],ax
	mov ax,[es:9*4+2]
	mov [oldisr+2],ax
	
	mov ax, [es: 8*4]
	mov [oldTimer], ax
	mov ax, [es: 8*4+2]
	mov [oldTimer+2], ax
	
	cli
	mov word[es:9*4],kbisr
	mov word[es:9*4+2],cs
	
	xor ax,ax
	mov es,ax
	
	mov word[es:8*4],timer
	mov [es:8*4+2],cs
	sti
	
	call mainScreen

	call wait_for_retrace
	call wait_for_retrace
	_loop:
		call animation
		cmp byte[isEscapepressed],1
		jnz _loop
		
		cmp byte[isNpressed],1
		jnz next
		call mainScreen
		mov byte[isNpressed],0
		
		next:
		cmp byte[isYpressed],1
		je exit
		
	jmp _loop

exit:
	call endGameScreen
	mov ax,[oldisr]
	mov bx,[oldisr+2]
	
	push 0
	pop es
	
	mov [es:9*4],ax
	mov [es:9*4+2],bx
	
	mov ax,[oldTimer]
	mov bx,[oldTimer+2]
	
	push 0
	pop es
	
	mov [es:8*4],ax
	mov [es:8*4+2],bx
	
	
mov ax,0x4c00
int 0x21