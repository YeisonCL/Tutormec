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
%define _executablesTableLocation 0x800 ; Direccion donde se alojara la tabla en RAM que guarda los sectores donde se encuentran los ejecutables.
%define _drive 0x80 ; Direccion del dispositivo USB.
%define _osSect 3 ; Sector donde esta alojado el sistema operativo en el USB.
%define _executablesTableSector 2 ; Sector donde esta alojado la tabla de ejecutables en el USB.
[bits 16] ; Iniciamos en modo real de 16 bits.
[org 0] ; Iniciamos el programa en la posicón 0x0000.

jmp 0x7c0:start ; Realizamos un salto al segmento 0x7C00 el cual es donde carga el BIOS el cargador de arranque.

start:
	;Cargamos los registros de segmento para el uso de variables.
	mov ax, cs 
	mov ds, ax
	mov es, ax

	;Iniciamos la interrupcion BIOS de video 10h en el modo de establecimiento de video (ah = 0) con una resolucion de 80x25 (al = 03h)
	mov al, 03h 
	mov ah, 00h
	int 10h	

	;Imprimimos el mensaje de booteo inicial.
	mov si, _bootSuccessful
	call print

	;Iniciamos la interrupcion BIOS de teclado 16h en el modo de lectura de caracter (ah = 0h).
	mov ah, 00h
	int 16h

	mov ax, _osLocation ; Movemos la direccion del sistema operativo al registro "ax".
	mov es, ax ; Movemos el registro de segmento "es" a la direccion del sistema operativo alojada en "ax".
	mov cl, _osSect ; Colocamos en el registro "cl" el sector desde el cual se va a iniciar la lectura.
	mov al, 2 ; Colocamos en el registro "al" la cantidad de sectores que vamos a leer.

	call loadSector ; Cargamos el sector donde se encuentra el sistema operativo en memoria RAM.

	mov ax, _executablesTableLocation ; Movemos la direccion de la tabla de ejecutables al registro "ax".
	mov es, ax ; Movemos el registro de segmento "es" a la direccion de la tabla de ejecutables alojada en "ax".
	mov cl, _executablesTableSector ; Colocamos en el registro "cl" el sector desde el cual se va a iniciar la lectura.
	mov al, 1 ; Colocamos en el registro "al" la cantidad de sectores que vamos a leer.

	call loadSector ; Cargamos el sector donde se encuentra la tabla de ejecutables en memoria RAM.
	

	jmp _osLocation:0000 ; Brincamos a la direccion 0x400:0000 donde alojamos nuestro sistema operativo dandole el control al mismo.

loadSector:
		mov bx, 0 ; Ponemos el offset que sera leido tomando como base el registro de segmento "es" en cero.
		mov dl, _drive ; Indicamos la direccion donde se encuentra el dispositivo USB.
		mov dh, 0 ; Indicamos la cabeza donde se hara la lectura en el dispositivo USB.
		mov ch, 0 ; Indicamos la pista donde se hara la lectura en el dispositivo USB.
		mov ah, 02h ; Indicamos que vamos a leer un sector.
		int 0x13 ; Llamamos a la interrupcion del BIOS encargada del manejo de los servicios de disco.
		jc loadError ; En caso que no se haya podido carga el sector indicamos el error.
		ret ; Si todo salio bien nos devolvemos donde se dio la llamada.

		loadError:
				;Se imprime un mensaje de error.
				mov si, _loadError
				call print
				ret

print:
	 pusha ; Metemos en la pila todos los registros para guardar su estado.
	 mov bp, sp ; Salvamos el valor del registro "sp" en el registro "bp".
	 cont:
		 lodsb ; Lee un byte almacenado en la direccion "ds:si" y lo transfiere al registro "al" incrementando "si" automaticamente.
		 or al, al ; La bandera "zf" sera "1" cuando el registro "al" tenga un valor de "0".
		 jz done ; Brinca al segmento "done" si la bandera "zf" es "1".
		 mov ah, 0x0e ; Definimos que se usara el modo TYY para la impresion de un caracter en pantalla perteneciente a la interrupcion BIOS 10h.
		 mov bx, 0 ; Definimos el color NEGRO para la impresión del caracter en pantalla.
		 int 10h ; Llamamos a la interrupcion del BIOS encarga de imprimir el caracter en pantalla.
		 jmp cont ; Volvemos al segmento "cont".
	done:
		mov sp, bp ; Restauramos el valor del registro "sp" con el valor que guardamos en "bp".
		popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
		ret ; Nos devolvemos hasata donde nos llamaron.

_bootSuccessful db "Boot realizado con exito... ", 10, 13, "Por favor presione cualquier tecla para continuar... ", 10, 13, 10, 13, 0
_loadError db "Se ha presentado un error cargando el sector especificado...", 10, 13, 0

times 510 - ($-$$) db 0 ; Dado que el gestor de arranque debe pesar EXACTAMENTE 512 bytes rellenamos los bytes que no hemos ocupado con ceros.

dw 0xaa55 ; Agregamos la firma para que el BIOS pueda reconocer el gestor de arranque como uno valido.
