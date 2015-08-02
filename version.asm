;*********************************************
;		Instituto Tecnológico de Costa Rica
;		Ingeniería en Computadores
;		Principios de Sistemas Operativos
;		II Semestre 2015
;		
;		Author: Yeison Arturo Cruz León
;		Carné: 201258348
;*********************************************

%define _osLocation 0x400 ; Direccion donde se alojara el sistema operativo en RAM.

[bits 16] ; Iniciamos en modo real de 16 bits.
[org 0] ; Iniciamos el programa en la posicón 0x0000.

start:

	;Cargamos los registros de segmento para el uso de variables.
	mov ax,cs
	mov ds,ax
	mov es,ax
	;Seteamos la posicion del cursor.
	mov ah, 03
	mov bh, 0
	int 10h

	call printVersionInfo ;Llamamos a la rutina que imprime el mensaje.
	
	jmp _osLocation:0 ; Saltamos a la posicion inicial del sistema operativo.

printVersionInfo:
	mov bp, _versionInfo ; Direccion del segmento que contiene el mensaje.
	mov ah, 013h ; Utilizamos la funcion que despliega una cadena de caracteres en pantalla.
	mov al, 1; Numero de pagina.
	mov bx, 3; Color de letra.
	mov cx, 24 ; Longitud del mensaje.
	int 0x10 ; Llamada a la interrupcion.
	ret ; Nos devolvemos desde donde vino la llamada.


_versionInfo db "Yeison O.S - Version 1.0"
