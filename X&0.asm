.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
msg5     db "                                                     ~~ X&0 ~~",13,10,13,10,13,10,0
msg      db "Player 1 (X)  -  Player 2 (0)",13,10,13,10,13,10,0
msg1     db "     |     |     ",13,10,0
msg2     db "  %c  |",0
msg3     db "_____|_____|_____",13,10,0
msg4     db "  %c  ",13,10,0
msg6     db "     |     |     ",13,10,13,10,0
msg7     db "Player %d, enter a number:  ",0
msg8     db "Invalid move.",13,10,13,10,0
msg9     db "Game draw.",13,10,0
msg10    db "Player %d win.",13,10,0
msg11    db "Play again? YES=1 NO=0",13,10,0
msg12    db "                                               ",13,10,0
square   dw '1','2','3','4','5','6','7','8','9',0
player   dd 1
mark     dw '0'
doi      dd 2
i        dd 0
choice   dd 0
format   db "%d",0
reia     dd 0
ok       db 0
choice_0 db 0
.code

afisare macro msg

	push offset msg
	call printf
	add esp,4
endm
  
                        	
;FUNCTION TO DRAW BOARD OF X&0 WITH PLAYERS MARK

board macro msg1, msg2, msg3, msg4, msg6

	push offset msg1                               
	call printf
	add esp,4

	push [square]
	push offset msg2
	call printf
	add esp,8

	push [square+2]
	push offset msg2
	call printf
	add esp,8

	push [square+4]
	push offset msg4
	call printf
	add esp,8

	push offset msg3
	call printf
	add esp,4

	push offset msg1
	call printf
	add esp,4

	push  [square+6]
	push offset msg2
	call printf
	add esp,8

	push [square+8]
	push offset msg2
	call printf
	add esp,8

	push [square+10]
	push offset msg4
	call printf
	add esp,8

	push offset msg3
	call printf
	add esp,4

	push offset msg1
	call printf
	add esp,4

	push  [square+12]
	push offset msg2
	call printf
	add esp,8

	push [square+14]
	push offset msg2
	call printf
	add esp,8

	push [square+16]
	push offset msg4
	call printf
	add esp,8

	push offset msg6
	call printf
	add esp,4
endm

;FUNCTION TO RETURN GAME STATUS
;1 FOR GAME IS OVER WITH RESULT
;-1 FOR GAME IS IN PROGRESS
;0 GAME IS OVER AND NO RESULT

checkwin proc

	push ebp
	mov ebp, esp 
	xor esi,esi

	mov si,[square+2] 
	cmp si,[square]    ;verificam daca square[2]=square[1]
	jne comparare1
	cmp si,[square+4]  ;verificam daca square[2]=square[3]
	je iesi1

comparare1:
	mov si,[square+8]
	cmp si,[square+6]  ;verificam daca square[4]=square[5]
	jne comparare2
	cmp si,[square+10] ;verificam daca square[5]=square[6]
	je iesi1

comparare2:
	mov si,[square+14]
	cmp si,[square+12] ;verificam daca square[7]=square[8]
	jne comparare3
	cmp si,[square+16] ;verificam daca square[8]=square[9]
	je iesi1

comparare3:
	mov si,[square+6]
	cmp si,[square]    ;verificam daca square[1]=square[4]
	jne comparare4
	cmp si,[square+12] ;verificam daca square[4]=square[7]
	je iesi1

comparare4:
	mov si,[square+8]
	cmp si,[square+2]  ;verificam daca square[2]=square[5]
	jne comparare5
	cmp si,[square+14] ;verificam daca square[5]=square[8]
	je iesi1

comparare5:
	mov si,[square+10]
	cmp si,[square+4]  ;verificam daca square[3]=square[6]
	jne comparare6
	cmp si,[square+16] ;verificam daca square[6]=square[9]
	je iesi1

comparare6:
	mov si,[square+8]
	cmp si,[square]    ;verificam daca square[1]=square[5]
	jne comparare7
	cmp si,[square+16] ;verificam daca square[5]=square[9]
	je iesi1

comparare7:
	mov si,[square+8]
	cmp si,[square+4]  ;verificam daca square[3]=square[5]
	jne comparare8
	cmp si,[square+12] ;verificam daca square[5]=square[7]
	je iesi1
;verificam daca mai sunt pozitii care se pot ocupa cu X sau 0
comparare8:
	cmp [square],'1'
	je iesi2
	cmp [square+2],'2'
	je iesi2
	cmp [square+4],'3'
	je iesi2
	cmp [square+6],'4'
	je iesi2
	cmp [square+8],'5'
	je iesi2
	cmp [square+10],'6'
	je iesi2
	cmp [square+12],'7'
	je iesi2
	cmp [square+14],'8'
	je iesi2
	cmp [square+16],'9'
	je iesi2

iesi3:
	mov eax,0
	jmp checkwin_final

iesi2:
	mov eax,-1
	jmp checkwin_final

iesi1:
	mov eax,1
	jmp checkwin_final 

checkwin_final:
	mov esp, ebp
	pop ebp
	ret  	
checkwin endp

think macro 

local gandeste,final
	push ecx
	mov choice_0,0
gandeste:
;verificam daca square[1]=square[2]=0 si square[3] e liber
	mov cx,[square]      
	cmp cx,[square+2]
	jne mai_verifica1
	cmp cx,'0'
	jne mai_verifica1
	cmp [square+4],'3'
	jne mai_verifica1
	mov [square+4],'0'
	mov choice_0,1
	jmp final
;verificam daca square[2]=square[3]=0 si square[1] e liber
mai_verifica1:
	mov cx,[square+2]
	cmp cx,[square+4]
	jne mai_verifica2
	cmp cx,'0'
	jne mai_verifica2
	cmp [square],'1'
	jne mai_verifica2
	mov [square],'0'
	mov choice_0,1
	jmp final
;verificam daca square[3]=square[1]=0 si square[2] e liber
mai_verifica2:
	mov cx,[square+4]
	cmp cx,[square]
	jne mai_verifica3
	cmp cx,'0'
	jne mai_verifica3
	cmp [square+2],'2'
	jne mai_verifica3
	mov [square+2],'0'
	mov choice_0,1
	jmp final
;verificam daca square[4]=square[5]=0 si square[6] e liber
mai_verifica3:
	mov cx,[square+6]
	cmp cx,[square+8]
	jne mai_verifica4
	cmp cx,'0'
	jne mai_verifica4
	cmp [square+10],'6'
	jne mai_verifica4
	mov [square+10],'0'
	mov choice_0,1
	jmp final
;verificam daca square[5]=square[6]=0 si square[4] e liber
mai_verifica4:
	mov cx,[square+8]
	cmp cx,[square+10]
	jne mai_verifica5
	cmp cx,'0'
	jne mai_verifica5
	cmp [square+6],'4'
	jne mai_verifica5
	mov [square+6],'0'
	mov choice_0,1
	jmp final
;verificam daca square[6]=square[4]=0 si square[5] e liber
mai_verifica5:
	mov cx,[square+10]
	cmp cx,[square+6]
	jne mai_verifica6
	cmp cx,'0'
	jne mai_verifica6
	cmp [square+8],'5'
	jne mai_verifica6
	mov [square+8],'0'
	mov choice_0,1
	jmp final
;verificam daca square[7]=square[8]=0 si square[9] e liber
mai_verifica6:
	mov cx,[square+12]
	cmp cx,[square+14]
	jne mai_verifica7
	cmp cx,'0'
	jne mai_verifica7
	cmp [square+16],'9'
	jne mai_verifica7
	mov [square+16],'0'
	mov choice_0,1
	jmp final
;verificam daca square[8]=square[9]=0 si square[7] e liber
mai_verifica7:
	mov cx,[square+14]
	cmp cx,[square+16]
	jne mai_verifica8
	cmp cx,'0'
	jne mai_verifica8
	cmp [square+12],'7'
	jne mai_verifica8
	mov [square+12],'0'
	mov choice_0,1
	jmp final
;verificam daca square[9]=square[7]=0 si square[8] e liber
mai_verifica8:
	mov cx,[square+16]
	cmp cx,[square+12]
	jne mai_verifica9
	cmp cx,'0'
	jne mai_verifica9
	cmp [square+14],'8'
	jne mai_verifica9
	mov [square+14],'0'
	mov choice_0,1
	jmp final
;verificam daca square[1]=square[4]=0 si square[7] e liber
mai_verifica9:
	mov cx,[square]
	cmp cx,[square+6]
	jne mai_verifica10
	cmp cx,'0'
	jne mai_verifica10
	cmp [square+12],'7'
	jne mai_verifica10
	mov [square+12],'0'
	mov choice_0,1
	jmp final
;verificam daca square[4]=square[7]=0 si square[1] e liber
mai_verifica10:
	mov cx,[square+6]
	cmp cx,[square+12]
	jne mai_verifica11
	cmp cx,'0'
	jne mai_verifica11
	cmp [square],'1'
	jne mai_verifica11
	mov [square],'0'
	mov choice_0,1
	jmp final
;verificam daca square[7]=square[1]=0 si square[4] e liber
mai_verifica11:
	mov cx,[square+12]
	cmp cx,[square]
	jne mai_verifica12
	cmp cx,'0'
	jne mai_verifica12
	cmp [square+6],'4'
	jne mai_verifica12
	mov [square+6],'0'
	mov choice_0,1
	jmp final
;verificam daca square[2]=square[5]=0 si square[8] e liber
mai_verifica12:
	mov cx,[square+2]
	cmp cx,[square+8]
	jne mai_verifica13
	cmp cx,'0'
	jne mai_verifica13
	cmp [square+14],'8'
	jne mai_verifica13
	mov [square+14],'0'
	mov choice_0,1
	jmp final
;verificam daca square[5]=square[8]=0 si square[2] e liber
mai_verifica13:
	mov cx,[square+8]
	cmp cx,[square+14]
	jne mai_verifica14
	cmp cx,'0'
	jne mai_verifica14
	cmp [square+2],'2'
	jne mai_verifica14
	mov [square+2],'0'
	mov choice_0,1
	jmp final
;verificam daca square[8]=square[2]=0 si square[5] e liber
mai_verifica14:
	mov cx,[square+14]
	cmp cx,[square+2]
	jne mai_verifica15
	cmp cx,'0'
	jne mai_verifica15
	cmp [square+8],'5'
	jne mai_verifica15
	mov [square+8],'0'
	mov choice_0,1
	jmp final
;verificam daca square[3]=square[6]=0 si square[9] e liber
mai_verifica15:
	mov cx,[square+4]
	cmp cx,[square+10]
	jne mai_verifica16
	cmp cx,'0'
	jne mai_verifica16
	cmp [square+16],'9'
	jne mai_verifica16
	mov [square+16],'0'
	mov choice_0,1
	jmp final
;verificam daca square[6]=square[9]=0 si square[3] e liber
mai_verifica16:
	mov cx,[square+10]
	cmp cx,[square+16]
	jne mai_verifica17
	cmp cx,'0'
	jne mai_verifica17
	cmp [square+4],'3'
	jne mai_verifica17
	mov [square+4],'0'
	mov choice_0,1
	jmp final
;verificam daca square[9]=square[3]=0 si square[6] e liber
mai_verifica17:
	mov cx,[square+4]
	cmp cx,[square+16]
	jne mai_verifica18
	cmp cx,'0'
	jne mai_verifica18
	cmp [square+10],'6'
	jne mai_verifica18
	mov [square+10],'0'
	mov choice_0,1
	jmp final
;verificam daca square[1]=square[5]=0 si square[9] e liber
mai_verifica18:
	mov cx,[square]
	cmp cx,[square+8]
	jne mai_verifica19
	cmp cx,'0'
	jne mai_verifica19
	cmp [square+16],'9'
	jne mai_verifica19
	mov [square+16],'0'
	mov choice_0,1
	jmp final
;verificam daca square[5]=square[9]=0 si square[1] e liber
mai_verifica19:
	mov cx,[square+8]
	cmp cx,[square+16]
	jne mai_verifica20
	cmp cx,'0'
	jne mai_verifica20
	cmp [square],'1'
	jne mai_verifica20
	mov [square],'0'
	mov choice_0,1
	jmp final
;verificam daca square[9]=square[1]=0 si square[5] e liber
mai_verifica20:
	mov cx,[square+16]
	cmp cx,[square]
	jne mai_verifica21
	cmp cx,'0'
	jne mai_verifica21
	cmp [square+8],'5'
	jne mai_verifica21
	mov [square+8],'0'
	mov choice_0,1
	jmp final
;verificam daca square[3]=square[5]=0 si square[7] e liber
mai_verifica21:
	mov cx,[square+4]
	cmp cx,[square+8]
	jne mai_verifica22
	cmp cx,'0'
	jne mai_verifica22
	cmp [square+12],'7'
	jne mai_verifica22
	mov [square+12],'0'
	mov choice_0,1
	jmp final
;verificam daca square[5]=square[7] si square[3] e liber
mai_verifica22:
	mov cx,[square+8]
	cmp cx,[square+12]
	jne mai_verifica23
	cmp cx,'0'
	jne mai_verifica23
	cmp [square+4],'3'
	jne mai_verifica23
	mov [square+4],'0'
	mov choice_0,1
	jmp final
;verificam daca square[7]=square[3]=0 si square[5] e liber
mai_verifica23:
	mov cx,[square+12]
	cmp cx,[square+4]
	jne final
	cmp cx,'0'
	jne final
	cmp [square+8],'5'
	jne final
	mov [square+8],'0'
	mov choice_0,1
	jmp final

final:
	pop ecx
endm 
 
start:
	;aici se scrie codul

afisare msg12
afisare msg5
afisare msg

repeta:
board msg1, msg2, msg3, msg4, msg6

	mov eax,player
	mov edx,0
	mov ecx,2
	div ecx
	cmp edx,0
	jne pune_x
	jmp pune_0

pune_x:
	mov player,1
	mov mark,'X'
	push player
	push offset msg7
	call printf
	add esp,8

	push offset choice
	push offset format
	call scanf
	add esp,8

	cmp choice,1
	jne comp1
	cmp [square],'1'
	jne scrie

;pune X pe pozitia 1
	mov bx,mark
	mov [square],bx
	mov ok,1
	jmp verificare

comp1:
	cmp choice,2
	jne comp2
	cmp [square+2],'2'
	jne scrie

;pune X pe pozitia 2
	mov bx,mark
	mov [square+2],bx
	mov ok,2
	jmp verificare

comp2:
	cmp choice,3
	jne comp3
	cmp [square+4],'3'
	jne scrie

;pune X pe pozitia 3
	mov bx,mark
	mov [square+4],bx
	mov ok,3
	jmp verificare

comp3:
	cmp choice,4
	jne comp4
	cmp [square+6],'4'
	jne scrie

;pune X pe pozitia 4
	mov bx,mark
	mov [square+6],bx
	mov ok,4
	jmp verificare

comp4:
	cmp choice,5
	jne comp5
	cmp [square+8],'5'
	jne scrie

;pune X pe pozitia 5
	mov bx,mark
	mov [square+8],bx
	mov ok,5
	jmp verificare

comp5:
	cmp choice,6
	jne comp6
	cmp [square+10],'6'
	jne scrie

;pune X pe pozitia 6
	mov bx,mark
	mov [square+10],bx
	mov ok,6
	jmp verificare

comp6:
	cmp choice,7
	jne comp7
	cmp [square+12],'7'
	jne scrie

;pune X pe pozitia 7
	mov bx,mark
	mov [square+12],bx
	mov ok,7
	jmp verificare

comp7:
	cmp choice,8
	jne comp8
	cmp [square+14],'8'
	jne scrie

;pune X pe pozitia 8
	mov bx,mark
	mov [square+14],bx
	mov ok,8
	jmp verificare

comp8:
	cmp choice,9
	jne scrie
	cmp [square+16],'9'
	jne scrie

;pune X pe pozitia 9
	mov bx,mark
	mov [square+16],bx
	mov ok,9
	jmp verificare

scrie:
afisare msg8
	dec player
	jmp verificare

pune_0:
	mov player,2
	mov mark,'0'
think
	cmp choice_0,1
	je verificare
;punem 0 in square[3] sau in square[7] sau in square[9]
	cmp ok,1
	jne ok2
	cmp [square+4],'3'
	je pune_03
	cmp [square+12],'7'
	je pune_07
	cmp [square+16],'9'
	je pune_09
pune_03:
	mov bx,mark
	mov [square+4],bx
	jmp verificare
pune_07:
	mov bx,mark
	mov [square+12],bx
	jmp verificare
pune_09:
	mov bx,mark
	mov [square+16],bx
	jmp verificare
;punem 0 in square[4] sau in square[6] sau in square[8]
ok2:
	cmp ok,2
	jne ok3
	cmp [square+6],'4'
	je pune_04
	cmp [square+10],'6'
	je pune_06
	cmp [square+14],'8'
	je pune_08
	pune_04:
	mov bx,mark
	mov [square+6],bx
	jmp verificare
	pune_06:
	mov bx,mark
	mov [square+10],bx
	jmp verificare
	pune_08:
	mov bx,mark
	mov [square+14],bx
	jmp verificare
;punem 0 in square[1] sau in square[7] sau in square[9]
ok3:
	cmp ok,3
	jne ok4
	cmp [square],'1'
	je pune_01
	cmp [square+12],'7'
	je pune_07
	cmp [square+16],'9'
	je pune_09
pune_01:
	mov bx,mark
	mov [square],bx
	jmp verificare
;punem 0 in square[2] sau in square[6] sau in square[8]
ok4:
	cmp ok,4
	jne ok5
	cmp [square+2],'2'
	je pune_02
	cmp [square+10],'6'
	je pune_06
	cmp [square+14],'8'
	je pune_08
	pune_02:
	mov bx,mark
	mov [square+2],bx
	jmp verificare
;punem 0 in square[1] sau in square[2] sau in square[3] sau in sqare[4] sau in sqare[6]
;sau in sqare[7] sau in sqare[8] sau in sqare[9]
ok5:
	cmp ok,5
	jne ok6
	cmp [square],'1'
	je pune_01
	cmp [square+2],'2'
	je pune_02
	cmp [square+4],'3'
	je pune_03
	cmp [square+6],'4'
	je pune_04
	cmp [square+10],'6'
	je pune_06
	cmp [square+12],'7'
	je pune_07
	cmp [square+14],'8'
	je pune_08
	cmp [square+16],'9'
	je pune_09
;punem 0 in square[2] sau in square[4] sau in square[8]
ok6:
	cmp ok,6
	jne ok7
	cmp [square+2],'2'
	je pune_02
	cmp [square+6],'4'
	je pune_04
	cmp [square+14],'8'
	je pune_08
;punem 0 in square[1] sau in square[3] sau in square[9]
ok7:
	cmp ok,7
	jne ok8
	cmp [square],'1'
	je pune_01
	cmp [square+4],'3'
	je pune_03
	cmp [square+16],'9'
	je pune_09
;punem 0 in square[2] sau in square[4] sau in square[6]
ok8:
	cmp ok,8
	jne ok9
	cmp [square+2],'2'
	je pune_02
	cmp [square+6],'4'
	je pune_04
	cmp [square+10],'6'
	je pune_06
;punem 0 in square[1] sau in square[3] sau in square[7]
ok9:
	cmp [square],'1'
	je pune_01
	cmp [square+4],'3'
	je pune_03
	cmp [square+12],'7'
	je pune_07

verificare:
	inc player
	call checkwin
	mov i,eax
	cmp i,-1
	je repeta

board msg1, msg2, msg3, msg4, msg6
	cmp i,1
	je scrie1
afisare msg9
	jmp reluare

scrie1:
	dec player
	push [player]
	push offset msg10
	call printf
	add esp,8

reluare:
afisare msg11
	push offset reia
	push offset format
	call scanf
	add esp,8 

	cmp reia,1
	je rejoaca
jmp exit
rejoaca:
	mov [square],'1'
	mov [square+2],'2'
	mov [square+4],'3'
	mov [square+6],'4'
	mov [square+8],'5'
	mov [square+10],'6'
	mov [square+12],'7'
	mov [square+14],'8'
	mov [square+16],'9'
	mov player,1
	mov i,0
	mov choice,0
	mov choice_0,0
	mov mark,'0'
	jmp start
;terminarea programului
	push 0
	call exit
end start
