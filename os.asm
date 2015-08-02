;*********************************************
;		Instituto Tecnológico de Costa Rica
;		Ingeniería en Computadores
;		Principios de Sistemas Operativos
;		II Semestre 2015
;		
;		Author: Yeison Arturo Cruz León
;		Carné: 201258348
;*********************************************

%define _drive 0x80 ; Direccion del dispositivo USB.
%define _executableDirection 0x2000 ; Direccion en memoria RAM donde sera cargado un ejecutable cuando se llame.
%define _executablesTableLocation 0x800 ; Direccion donde se alojara la tabla en RAM que guarda los sectores donde se encuentran los ejecutables.
%define _stackDirection 0x1000 ; Direccion de memoria en RAM donde se colocara la pila del sistema.
[bits 16] ; Iniciamos en modo real de 16 bits.
[org 0] ; Iniciamos el programa en la direcion 0x0000.

start:
	;Cargamos los registros de segmento para el uso de variables.
	mov ax, cs
	mov ds, ax
	mov es, ax

	mov ax, _stackDirection ; Colocamos la pila en la direccion de memoria 0x1000
	mov ss, ax	; Inicializamos la pila.
	mov sp, ss ; Inicializamos el registro stack pointer.

	cmp byte [_firstExecution], 0 ; Revisamos si es la primera vez que ejecutamos el programa.
	jnz initializeTable ; Si el flag "zf" esta en "1" brincamos al segmento de codigo

	call clearScreen ; Limpiamos la pantalla de todo lo que tenga.

	push _welcomeMessaje ; Colocamos el mensaje de bienvenida en la pila para su impresion.
	call print ; Llamamos a la rutina encargada de imprimir el mensaje.

	mov byte [_firstExecution], 1 ; Colocamos en "1" la variable indicando que ya se ha iniciado el S.O por primera vez, asimismo, indicamos el tamaño del movimiento por ser una direccion.
	
	initializeTable:
			mov ax, _executablesTableLocation ; Se carga en el registro "ax" la direccion donde la tabla de ejecutable esta cargada.
			mov gs, ax ; Se traslada la direccion del registro "ax" al registro "gs" encargado del manejo de segmentos relacionados con estructuras de control.
			mov bx, 0 ; Se inicializa el registro bx a "0".

	showConsole:

			push _consoleSymbol ; Colocamos el simbolo de la consola en la pila. 	
			call print ; Llamamos a la rutina encargada de imprimir el mensaje.
		
			push _querySearch ; Colocamos en la pila el tamaño necesario de espacio para poder capturar el nombre completo del programa introducido por el usuario.
			call readExecutableName ; Llamamos a la rutina encargada de leer el nombre del programa introducido por el usuario.
		
			call validateExecutableName ; Llamamos a la rutina encargada de validar si el nombre del programa introducido por el usuario existe en la lista de programas validos.
		
			jmp showConsole ; Nos devolvemos al inicio para repetir el proceso.

clearScreen:
		pusha ; Metemos en la pila todos los registros para guardar su estado.
		mov dx, 0 ; Llenamos la parte baja y la parte alta del registro "ax" con "0".
		call moveCursor ; Llamamos a la rutina que setea el curso en la posicion 0:0 (dh:dl).
		mov ah, 6 ; Usamos la funcion 06h de la interrupcion 0x10 del BIOS para recorrer toda la pantalla entera.
		mov al, 0 ; Indicamos que es TODA la pantalla con un "0".
		mov bh, 7 ; Lineas de limpieza en negro.
		mov cx, 0 ; Empezamos la limpieza desde 0:0.
		mov dx, 184Fh ; Como estamos en modo de video 03h es decir una resolucion de 80x25 entonces colocamos en la parte baja del registro "dx" el valor de "79" y en la parte alta "24" y hasta 				 ; ahi terminamos la limpieza de pantalla.
		int 10h ; Llamamos a la interrupcion del BIOS que maneja la pantalla.
		popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
		ret ; Nos devolvemos hasta donde nos llamaron.

moveCursor:
		pusha ; Metemos en la pila todos los registros para guardar su estado.
		mov bh, 0 ; Seteamos la pagina en "0".
		mov ah, 2 ; Usamos la funcion "02h" de la interrupcion 0x10 del BIOS para setear la posicion del cursor.
		int 10h	; Llamamos a la interrupcion 0x10 del BIOS.
		popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
		ret ; Nos devolvemos hasta donde nos llamaron.



readExecutableName:
				pusha ; Metemos en la pila todos los registros para guardar su estado.
	 			mov bp, sp ; Salvamos el valor del registro "sp" en el registro "bp".
				cld ; Limpiamos el flag de direccion poniendolo a "0".
				mov byte [_charCount], 0 ; Seteamos la variable que llevara el conteo de caracteres introducidos a cero.
				mov di, [bp + 18] ; Movemos el registro "di" a la posicion "[bp + 18]" pues es donde se encuentra el espacio para el nombre del programa que sera introducido, ademas, sera
								  ; en "di" donde se vayan guardando los caracteres.
				continueRead:
							mov ah, 0 ; Iniciamos la interrupcion BIOS de teclado 16h en el modo de lectura de caracter (ah = 0h).
							int 16h ; Ejecutamos la interrupcion del BIOS.
							cmp al, 0dh ; Se compara el caracter introducido el cual se guarda por defecto en el registro "al" con "0dh" el cual segun la tabla ASCII indica un caracter 
										; de retorno o mejor conocido como "enter".
							jz finishRead ; Brinca al segmento "finishRead" si la bandera "zf" es "1".
							mov ah, 0x0e ; Definimos que se usara el modo TYY para la impresion de un caracter en pantalla perteneciente a la interrupcion BIOS 10h.
		 					mov bx, 0 ; Definimos el color NEGRO para la impresión del caracter en pantalla.
		 					int 10h ; Llamamos a la interrupcion del BIOS encarga de imprimir el caracter en pantalla.
							stosb ; Se encarga de guardar el caracter introducido en el registro "di" e incrementarlo automaticamente.
							inc byte [_charCount] ; Incrementamos en una unidad la variable "_charCount" pues se ha leido un nuevo caracter.
							jmp continueRead ; Nos devolvemos al inicio para repetir el proceso.
				finishRead:
						push _newLine ; Colocamos una nueva linea en la pila.
						call print ; Llamamos a la rutina encargada de imprimir el mensaje.
						mov sp, bp ; Restauramos el valor del registro "sp" con el valor que guardamos en "bp".
						popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
						ret ; Nos devolvemos hasta donde nos llamaron.

validateExecutableName:
					pusha ; Metemos en la pila todos los registros para guardar su estado.
	 				mov bp, sp ; Salvamos el valor del registro "sp" en el registro "bp".
					cmp ax, ax ; Seteamos la variable "zf" a cero. 
					mov di, _querySearch ; Movemos la direccion de la variable "_querySearch" al registro "di" pues este ultimo apuntaba al final del nombre del programa anteriormente.
					mov bx, 0 ; Se inicializa el registro "bx" a cero.
					cld ; Limpiamos el flag de direccion poniendolo a "0".
					verifyCharacter:
								mov al, [gs:bx] ; Extraemos el caracter correspondiente al offset "bx" que se encuentra en la tabla de ejecutables.
								cmp al, '}' ; Comparamos el caracter con "}" para cerciorarnos si es el caracter de fin.
								je executableNameNotFound ; En caso de que el flag "zf" tenga un valor de "1" brincara al segmento "executableNameNotFound"
								cmp al, [di] ; Compara el valor que tiene el registro "di" con valor actual del registro "al".
								je equalCharacter ; En caso de que el flag "zf" tenga un valor de "1" bricara al segmento "equalCharacter"
								inc bx ; Incrementa en una unidad el offset que se encuentra en el registro "bx" para extraer el siguiente caracter de la tabla de ejecutables.
								jmp verifyCharacter ; Nos devolvemos al inicio para repetir el proceso.
					equalCharacter:
								push bx ; Colocamos el offset actual en la pila para poder restaurarlo luego.
								mov cx, [_charCount] ; Almacenamos la cantidad de caracteres de la palabra insertada en el registro "cx".
					verifyCompleteName:
									mov al, [gs:bx] ; Extraemos el primer caracter que se encuentra en la tabla de ejecutables.
									inc bx ; Incrementa en una unidad el offset que se encuentra en el registro "bx" para extraer el siguiente caracter de la tabla de ejecutables.
									scasb ; Internamente hace la comparacion "cmp al, [di]" y posteriormente incrementa automaticamente el registro "di".
									loope verifyCompleteName ; Si el flag "zf" es "1" y ademas "cx" es diferente de "0" brinca al segmento "verifyCompleteName", ademas decrementa automaticamente
															 ; el registro "cx".
									je verifyExecutableNamePass ;  En caso de que el flag "zf" tenga un valor de "1" brincara al segmento "verifyExecutableNamePass"
									mov di, _querySearch ; Movemos la direccion de la variable "_querySearch" al registro "di" pues este ultimo apuntaba al final del nombre del programa 								 ; anteriormente.
									pop bx ; Recuperamos de la pila el valor de "bx" que habiamos guardado anteriormente.
									inc bx ; Incrementa en una unidad el offset que se encuentra en el registro "bx" para extraer el siguiente caracter de la tabla de ejecutables.
									jmp verifyCharacter ; Nos devolvemos al inicio para repetir el proceso.
					executableNameNotFound:
										push _fileNotFound ; Colocamos en la pila el mensaje que corresponde a "archivo no encontrado".
										call print ; Llamamos a la rutina encargada de imprimir el mensaje.
										jmp finalySearch ; Terminamos la ejecucion de la busqueda y brincamos al segmento "finalySearch".
					verifyExecutableNamePass:
											inc bx ; Incrementa en una unidad el offset que se encuentra en el registro "bx" para extraer el siguiente caracter de la tabla de ejecutables
												   ; para este momento nos encontramos en el numero que corresponde al sector.
											push  bx ; Guardamos el offset en la pila para su posterior recuperacion.
											call findExecutableSector ; Llamamos al segmento "findExecutableSector".
					finalySearch:
								mov sp, bp ; Restauramos el valor del registro "sp" con el valor que guardamos en "bp".
								popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
								ret ; Nos devolvemos hasta donde nos llamaron (A imprimir nuevamente la shell).

findExecutableSector:
				pusha ; Metemos en la pila todos los registros para guardar su estado.
	 			mov bp, sp ; Salvamos el valor del registro "sp" en el registro "bp".
				mov bx, [bp + 18] ; Movemos el registro "bx" a la posicion "[bp + 18]" pues es donde se encuentra el ultimo valor del offset utilizado.
				cld ; Limpiamos el flag de direccion poniendolo a "0".
				mov word [_sectorExecutable], 0 ; Inicializamos la variable "_sectorExecutable" la cual contendra el sector donde se ubica el programa solicitado a cero.
				mov cl, 10 ; Inicializamos el registro "cl" a "10".
				searchSectorNumber:
								mov al, [gs:bx] ; Extraemos el caracter correspondiente al offset "bx" que se encuentra en la tabla de ejecutables.
								inc bx ; Incrementa en una unidad el offset que se encuentra en el registro "bx" para extraer el siguiente caracter de la tabla de ejecutables.
								cmp al, ',' ; Comparamos si el valor del caracter actual almacenado en "al" es una "," pues de esta forma sabremos que hemos leido el numero del sector. 
								jz loadExecutable ; Si el flag "zf" esta en "1" brincamos al segmento "loadExecutable".
								cmp al, 48 ; Verificamos si el numero obtenido es menor a "0".
								jl errorLoadNumberSector ; Si es menor a "0" brincamos al segmento "errorLoadNumberSector".
								cmp al, 58 ; Verificamos si el numero obtenido es mayor a "9".
								jg errorLoadNumberSector ; Si es mayor a "9" brincamos al segmento "errorLoadNumberSector".
								sub al, 48 ; Restamos "0" al registro "al".
								mov ah, 0 ; Colocamos a cero la parte alta del registro "ax".
								mov dx, ax ; Almacenamos en el registro "dx" el valor de "ax".
								mov ax, word [_sectorExecutable] ; Movemos el valor de la variable "_sectorExecutable" al registro "ax".
								mul cl ; Multiplicamos el registro "cl" con el registro "ah" y el valor se almacena en el registro "ax".
								add ax, dx ; Sumamos el valor del registro "dx" al registro "ax".
								mov word [_sectorExecutable], ax ; Movemos el valor del registro "ax" a la variable "_sectorExecutable" de esta forma tomando el valor del sector que contiene al 									 ; programa.
								jmp searchSectorNumber ; Nos devolvemos al inicio para repetir el proceso.
								loadExecutable:
											push word [_sectorExecutable] ; Guardamos el sector que contiene al ejecutable en la pila para cargarlo en memoria RAM.
											call loadExecutableInRAM ; Llamamos a la rutina que se encarga de cargar el ejecutable en memoria RAM.
											jmp _executableDirection:0000 ; Nos movemos a la direccion de memoria 0x2000:0000 que contiene nuestro programa cargado.
								errorLoadNumberSector:
												push _sectorNotFound ; Colocamos en la pila el error correspondiente a sector no valido.
												call print ; Llamamos a la rutina encargada de imprimir el mensaje.
												mov sp, bp ; Restauramos el valor del registro "sp" con el valor que guardamos en "bp".
												popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
												ret ; Nos devolvemos hasta donde nos llamaron.

loadExecutableInRAM:
				pusha ; Metemos en la pila todos los registros para guardar su estado.
	 			mov bp, sp ; Salvamos el valor del registro "sp" en el registro "bp".
				
				;Reiniciamos el controlador del dispositivo USB.
				mov ah, 0 
				mov dl, _drive
				int 0x13

				mov ax, _executableDirection ; Movemos la direccion donde se cargara el ejecutable al registro "ax".
				mov es, ax ; Cargamos el valor del registro "ax" al registro de segmento "es".
				mov cl, [bp + 18] ; Movemos al registro "cl" a la direccion [bp + 18] en la cual se encuentra el valor del sector que debe cargar.
				call defineNumberOfSectorsToLoad ; Llamamos a la rutina que nos define cuantos sectores debemos cargar del dispositivo USB.
				mov bx, 0 ; Seteamos el offset a 0;
				mov dl, _drive ; Seteamos la direccion del dispositivo USB.
				mov dh, 0 ; Indicamos la cabeza donde se hara la lectura en el dispositivo USB.
				mov ch, 0 ; Indicamos la pista donde se hara la lectura en el dispositivo USB.
				mov ah, 2 ; Indicamos que vamos a leer un sector.
				int 0x13 ; Llamamos a la interrupcion del BIOS encargada del manejo de los servicios de disco.
				jnc sectorLoadSucceful ; Si el sector fue cargado con exito nos movemos al segmento "sectorLoadSucceful". 
				errorLoadSector:
							push _loadError ; Colocamos en la pila el mensaje de error correspondiente a sector corrupto.
							call print ; Llamamos a la rutina encargada de imprimir el mensaje.
							call waitKey ; Llamamos a la rutia que espera la presion de una tecla.
							int 19h ; Llamamos a la interrupcion del BIOS que reinicia el Sistema Operativo.
				sectorLoadSucceful:
								mov sp, bp ; Restauramos el valor del registro "sp" con el valor que guardamos en "bp".
								popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
								ret ; Nos devolvemos hasta donde nos llamaron.

defineNumberOfSectorsToLoad:
						cmp byte [bp + 18], 9 ; Verificamos si el sector a cargar corresponde al sector del dispositivo USB que contiene el programa "Tutormec".
						jz loadTutormec ; Brincamos al segmento de codigo que define que debemos cargar dos sectores del dispositivo USB.
						mov al, 1 ; Se define la cantidad de sectores a leer.
						ret ; Nos devolvemos donde nos llamaron.
						loadTutormec:
								mov al, 5 ; Se define la cantidad de sectores a leer.
								ret ; Nos devolvemos hasta donde nos llamaron.

waitKey:
	pusha ; Metemos en la pila todos los registros para guardar su estado.
	mov ah, 00h
	int 16h
	popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
	ret ; Nos devolvemos al inicio de la llamada.
		
print:
	pusha ; Metemos en la pila todos los registros para guardar su estado.
	mov bp, sp ; Salvamos el valor del registro "sp" en el registro "bp".
	mov si, [bp + 18] ; Movemos el registro "si" a la posicion  [bp + 18] pues es la posicion en la que se encuentra el mensaje de bienvenida luego de hacer el "pusha".
	cont:
		lodsb ; Lee un byte almacenado en la direccion "ds:si" y lo transfiere al registro "al" incrementando "si" automaticamente.
		or al, al ; La bandera "zf" sera "1" cuando el registro "al" tenga un valor de "0".
		jz done ; Brinca al segmento "done" si la bandera "zf" es "1".
		mov ah, 0x0e ; Definimos que se usara el modo TYY para la impresion de un caracter en pantalla perteneciente a la interrupcion BIOS 10h.
		mov bx, 0 ; Definimos el color NEGRO para la impresión del caracter en pantalla.
		mov bl, 7 ; Colocamos "7" como color de fondo.
		int 10h ; Llamamos a la interrupcion del BIOS encarga de imprimir el caracter en pantalla.
		jmp cont ; Volvemos al segmento "cont".
	done:
		mov sp, bp ; Restauramos el valor del registro "sp" con el valor que guardamos en "bp".
		popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
		ret ; Nos devolvemos hasata donde nos llamaron.

_welcomeMessaje db "Bienvenido a Yeison O.S", 10, 13, "Digita help para obtener ayuda", 10, 13, 10, 13, 0
_loadError db "Se ha presentado un error cargando el sector especificado...", 10, 13, 0
_sectorNotFound db "El sector encontrado no existe dentro de la tabla de ejecutables...", 10, 13, 0
_fileNotFound db "El programa especificado parece que no existe, intenta de nuevo", 0
_querySearch times 30 db 0
_newLine db 10, 13, 0
_consoleSymbol db 10, 13, ">>", 0
_charCount dw 0
_firstExecution db 0
_sectorExecutable dw 0
