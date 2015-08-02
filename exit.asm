;*********************************************
;		Instituto Tecnológico de Costa Rica
;		Ingeniería en Computadores
;		Principios de Sistemas Operativos
;		II Semestre 2015
;		
;		Author: Yeison Arturo Cruz León
;		Carné: 201258348
;*********************************************

[bits 16] ; Iniciamos en modo real de 16 bits.
[org 0] ; Iniciamos el programa en la posicón 0x0000.

int 19h ; Llama a la interrupcion 19h del BIOS que se encarga de reiniciar el Sistema Operativo.
