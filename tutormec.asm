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
%define _maximumLettersOnScreen 5 ; Definimos la cantidad maxima de letras que pueden estar al mismo tiempo en la pantalla.
%define _existingLettersInArray 27 ; Definimos la cantidad de letras que tiene el arreglo de letras.
%define _selectLettersArray 0x1000 ; Definimos donde se encontraran las letras que se encuentran en pantalla.
%define _impactArea 0x1200 ; Definimos donde se encontraran las zonas de impacto.

[bits 16] ; Iniciamos en modo real de 16 bits.
[org 0] ; Iniciamos el programa en la direcion 0x0000.

start:
	call init

	gamePrincipalLoop:
				call detectKeyPress ; Verificamos si hay alguna tecla presionada en el buffer del teclado.
        		cmp ax, 011Bh ; Verificamos si la tecla pulsada corresponde a "esc".
        		je exitGame ; Si la tecla pulsada correspondia a "esc" nos salimos del juego.
        		call verifyCapturedLetter ; Verificamos si se presiono una tecla para capturar una letra.
        		call moveMessage ; Llamamos a la rutina que mueve el mensaje inferior.
        		call moveLetters ; Llamamos a la rutina que mueve las letras por la pantalla.
        		call refreshScreen ; Llamamos a la rutina que refresca la pantalla;
        		mov ax, 1 ; Solicitamos un delay de 110 milisegundos.
        		call makeADelay ; Llamamos a la rutina que realiza el delay en el sistema operativo.
        		jmp gamePrincipalLoop ; Volvemos al inicio del segmento de codigo para repetir el loop.

exitGame:
	call clearScreen ; Limpiamos la pantalla de todo lo que tenga.
	jmp _osLocation:0 ; Saltamos a la posicion inicial del sistema operativo.


init:
	;Cargamos los registros de segmento para el uso de variables.
	mov ax,cs
	mov ds,ax
	mov es,ax
	call startScrean; Llamamos a la rutina que tiene la pantalla de inicio que contiene las instrucciones.
	call waitKey ; Llamamos a la rutina que se encarga de esperar la presion de una tecla.
	call clearScreen ; Limpiamos la pantalla de todo lo que tenga.
	call hideCursor ; Llamamos a la rutina que se encarga de esconder el cursor.
	call lettersArrayToZero ; Seteamos en cero el valor del array de letras que seran seleccionadas para mostrar.
	call buildImpactAreaNumbers ; Montamos en memoria las coordenadas en las que se ubican las zonas de impacto.
	call refreshScreen ; Llamamos a la rutina que refresca la pantalla.
	ret ; Nos devolvemos al inicio de la llamada.

buildImpactAreaNumbers:
				mov byte [_impactArea + 0] , 5 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 1] , 6 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 2] , 7 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 3] , 8 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 4] , 9 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 5] , 10 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 6] , 21 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 7] , 22 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 8] , 23 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 9] , 24 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 10] , 25 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 11] , 26 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 12] , 37 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 13] , 38 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 14] , 39 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 15] , 40 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 16] , 41 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 17] , 42 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 18] , 53 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 19] , 54 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 20] , 55 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 21] , 56 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 22] , 57 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 23] , 58 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 24] , 69 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 25] , 70 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 26] , 71 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 27] , 72 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 28] , 73 ; Definimos una coordenada de zona de impacto.
				mov byte [_impactArea + 29] , 74 ; Definimos una coordenada de zona de impacto.
				ret ; Nos devolvemos al inicio de la llamada.

lettersArrayToZero:
				mov byte [_selectLettersArray + 0] , 0 ; Colocamos un cero en la posicion de la primera letra seleccionada para movimiento.
				mov byte [_selectLettersArray + 1] , 0 ; Colocamos un cero en la posicion de la segunda letra seleccionada para movimiento.
				mov byte [_selectLettersArray + 2] , 0 ; Colocamos un cero en la posicion de la tercera letra seleccionada para movimiento.
				mov byte [_selectLettersArray + 3] , 0 ; Colocamos un cero en la posicion de la cuarta letra seleccionada para movimiento.
				mov byte [_selectLettersArray + 4] , 0 ; Colocamos un cero en la posicion de la quinta letra seleccionada para movimiento.
				ret ; Nos devolvemos al inicio de la llamada.

refreshScreen:
		call drawLettersBlock ; Llamamos a la rutina que dibuja el bloque de letras en pantalla.
		call drawImpactBlockBackground ; Llamamos a la rutina que dibuja el fondo donde se encuentran los bloques de impacto.
		call drawImpactBlock ; Llamamos a la rutina que dibuja los bloques de impacto.
		call drawHandBackground ; Llamamos a la rutina que dibuja el fondo de la parte baja de la pantalla.
		xor cx, cx ; Iniciamos el registro "cx" en cero para que nos sirva de contador.
		refreshLettersLoop:
					cmp cl, _maximumLettersOnScreen ; Verificamos si ya hemos refrescado todas las letras en pantalla.
			        je refreshScore ; Si todas las letras fueron refrescadas brincamos al segmento de codigo "refreshScore".
			        mov bx, _letters ; Colocamos el array de letras en el registro "bx".
			        mov di, _lettersFingerPressure ; Colocamos el array de letras con su respectivo dedo de presion en "di".
					push bx ; Guardamos el valor del registro "bx" para su posterior reutilizacion ya que lo usaremos como registro de indice.
					xor bx, bx ; Colocamos el registro "bx" a ceros.
					xor dx, dx ; Ponemos el registro "dx" a ceros.
					xor ax, ax ; Iniciamos el registro "ax" en cero para su posterior utilizacion.
					mov bx , _selectLettersArray ; Movemos el valor de la variable "_selectLettersArray" al registro "bx". 
			        add bx, cx ; Sumamos el registro "bx" y el registro "cx".
			        cmp byte [bx] , 0 ; Comparamos si ya hay una letra selecionada para refrescar en pantalla.
			        jnz normalFlow ; Si ya existe una letra asignada entonces continue el flujo normal.
			        mov al , 2 ; Guardamos el numero 2 en la parte baja del registro "ax" para realizar una multiplicacion.
					mul cl ; Multiplicamos el valor del registro "cl" por el valor del registro "al" con el resultado almacenado en "ax".
					add ax, 1 ; Le sumamos una unidad al registro "ax".
					mov dx, ax ; Guardamos en el registro "dx" el valor del resultado de la multiplicacion.
					generatedNewLetter:
								cmp byte [_lettersArrayCount] , 27 ; Comprobamos si el contador esta al final del abecedario.
								jnz generatedNewLetterAux ; Si aun no ha llegado al limite entonces continue con el flujo normal.
								mov byte [_lettersArrayCount] , 0 ; Si ya llego al limite del abecedario reiniciamos el contador al inicio.
								generatedNewLetterAux:
												mov si, _letters ; Colocamos en el registro "si" el arreglo de letras que tenemos para mostrar en pantalla.
												inc byte [_lettersArrayCount] ; Incrementamos en una unidad la variable que dice cual letra es la siguiente para mostrar  
																			  ; en pantalla una vez que se capture una.
												mov al, [_lettersArrayCount] ; Movemos al registro "al" el valor de la variable "_lettersArrayCount".
						        				mov byte [bx] , al; Movemos el valor del registro "al" a la posicion de memoria que tiene guardada "bx".
						        				push dx ; Guardamos el valor actual del registro "dx" pues la rutina "makeMovementInLetterArray" lo modifica y no 
						        				        ; necesitamos eso.						  
												call makeMovementInLetterArray ; Realizamos el movimiento correspondiente en el arreglo de letras.
												pop dx ; Restauramos el valor del registro "dx" guardado en la pila.
												add si, ax ; Le sumamos al registro "si" el resultado de la multiplicacion anterior en la llamada anterior que se almaceno
													   	   ; en "ax".
												cmp byte [si + 3] , dl ; Comparamos si la letra generada corresponde con el renglon de la que acaba de ser borrada.
												jnz generatedNewLetter ; Si no corresponde genera una nueva letra.
			        normalFlow:
			        		call makeMovementInLetterArray ; Realizamos el movimiento correspondiente en el arreglo de letras.
			        		pop bx ; Restauramos el valor original del registro "bx" que teniamos guardado en la pila.
			        		add bx , ax ; Le sumamos al registro "bx" el resultado de la multiplicacion anterior que estaba almacenada en "ax".
			        		add di, ax ; Le sumamos al registro "di" el resultado de la multiplicacion anterior que estaba almacenada en "ax".
			        		mov dl, 8 ; Movemos el numero "2" al registro "dl" para realizar una division.
			        		div dl ; Divimos el registro "ax" entre el registro "dl" con resultado (cociente) almacenado en el registro "al".
			        		mov ah, al ; Movemos el resutado de la division al registro "ah".
			        		mov al, 9 ; Guardamos el numero "9" en la parte baja del registro "ax" para una posterior multiplicacion.
			        		mul ah ; Multiplicamos el valor del registro "ah" por el valor del registro "al" con el resultado almacenado en "ax", de esta forma corregimos
			        			   ; el desfase.
			        		add di, ax ; Le sumamos al registro "di" el resultado de la multiplicacion anterior que estaba almacenada en "ax".
					        mov byte dl, [bx] ; Movemos el contenido del primer byte del registro "bx" a dl.
					        mov byte dh, [bx + 1] ; Movemos el contenido del segundo byte del registro "bx" a dh.
					        call moveCursor ; Movemos el cursor a la posicion "X" y "Y" definida en la linea anterior.
					        mov si, bx ; Movemos el registro "bx" al registro "si" para la impresion de la letra en pantalla.
					        add si, 4 ; Le sumamos "4" al registro "si" para posicionarlo en la letra que debe imprimir.
					        call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.
					        mov byte dl, [di] ; Movemos el contenido del primer byte del registro "di"a dl.
					        mov byte dh, [di + 1] ; Movemos el contenido segundo byte del registro "di" a dh.
					        call moveCursor ; Movemos el cursor a la posicion "X" y "Y" definida en la linea anterior.
					        mov si, di ; Movemos el registro "di" al registro "si" para la impresion de la letra en pantalla.
					        add si, 2 ; Le sumamos "2" al registro "si" para posicionarlo en la letra que debe imprimir.
					        call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.
					        mov byte dl, [di + 4] ; Movemos el contenido del quinto byte del registro "di" a dl.
					        mov byte dh, [di + 5] ; Movemos el contenido del sexto byte del registro "di" a dh.
					        call moveCursor ; Movemos el cursor a la posicion "X" y "Y" definida en la linea anterior.
					        mov si, di ; Movemos el registro "di" al registro "si" para la impresion de la letra en pantalla.
					        add si, 6 ; Le sumamos "6" al registro "si" para posicionarlo en el mensaje que debe imprimir.
					        call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.
					        mov byte dl, [_note] ; Movemos el contenido del primer byte de la variable "note" a dl.
					        mov byte dh, 24 ; Definimos en el registro "dh" que el mensaje siempre se imprimira en la parte baja de la pantalla.
					        call moveCursor ; Movemos el cursor a la posicion "X" y "Y" definida en al linea anterior.
					        mov si, _note ; Movemos la variable "note" al registro "si" para su impresion en pantalla.
					        add si, 2 ; Le sumamos "1" al registro "si" para posicionarlo en el mensaje a imprimir.
					        call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.
					        inc cl ; Incrementamos el contador de loops pues ya hemos refrescado una letra.
					        jmp refreshLettersLoop ; Nos devolvemos para volver a repetir el proceso.
		refreshScore:
				mov dl, 0 ; Colocamos el puntaje en la columna "0".
				mov dh, 0 ; Colocamos el puntaje en el renglon "0".
				call moveCursor ; Llamamos a la rutia que coloca el cursor en esa posicion.
				mov si, _score; Movemos la variable que contiene el texto de puntaje al registro "si".
				call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.
		    	mov bl, 0x70 ; Definimos el color de borrado que es blanco en fondo negro.
		        mov dl, 9 ; Definimos la posicion en "X" donde empieza la limpieza la cual es la posicion "9".
		        mov dh, 0 ; Definimos que debe limpiar el score que se encuentra en el renglon "0".
		        mov si, 6 ; Definimos el tamaño que debe tener el bloque de limpieza.
		        mov di, 1 ; Definimos el "Y" maximo hasta donde llegara el bloque de limpieza.
		        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla, en este caso lo usaremos como bloque de limpieza.
				mov dl, 9 ; Movemos el curso a la posicion donde se escribira el nuevo score la cual es la posicion "9".
		        mov dh, 0 ; El score se encuentra en el renglon "0" por tanto movemos aca el cursor.
		        call moveCursor ; Llamos a la rutina que se encarga de mover el curso a la posicion antes indicada.
		        mov ax, [_scoreCount] ; Movemos el puntaje al registro "ax".
		        call intToStringConversion ; Llamamos a la rutina que se encarga de convertir un numero sin signo entero en un string para poder imprimirlo en pantalla.
		        mov si, ax ; Movemos el registro "ax" al registro "si" para la impresion de la letra en pantalla.
		        call print ; Llamamos a la rutina que se encarga de imprimir el mensaje en pantalla.
				ret ; Nos devolvemos al inicio de la llamada.

makeMovementInLetterArray:
					mov dx , [bx] ; Movemos al registro "dx" el valor que tiene asociado la direccion de memoria que se encuentra guardada en "bx".
	        		dec dx ; Decrementamos en una unidad "dx".
	        		mov al , 8 ; Guardamos el numero 8 en la parte baja del registro "ax" para realizar una multiplicacion.
	        		mul dl ; Multiplicamos el valor del registro "dl" por el valor del registro "al" con el resultado almacenado en "ax".
	        		ret ; Nos devolvemos al inicio de la llamada.

detectKeyPress:
		    mov ah, 01h ; Usamos la funcion 01h de la interrupcion del BIOS 16h para leer el buffer del teclado para teclas que han sido presionadas.
	        int 16h ; Llamamos a la interrupcion del BIOS y en caso de que el buffer tenga alguna teclado el flag "zf" tomara un valor de "1".
	        jz noKeyInBuffer ; Si no hay ninguna teclado en el buffer brincamos al segmento de codigo llamado "noKeyInBuffer".
	        xor ah, ah ; En caso que si exista una tecla en el buffer de teclado usaremos la funcion 00h de la interrupcion del BIOS 16h para leer la tecla presionada del buffer.
	        int 16h ; Llamamos a la interrupcion del BIOS para leer la tecla del buffer.
	        jmp exitKeyPress ; Nos salimos de la rutina.
			noKeyInBuffer:
			  		xor ax, ax  ; En caso de que no haya ninguna tecla presionada en el buffer de teclado colocamos el registro "ax" a "0".
			exitKeyPress:   
				ret ; Nos devolvemos al inicio de la llamada.

waitKey:
	pusha ; Metemos en la pila todos los registros para guardar su estado.
	mov ah, 00h
	int 16h
	popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
	ret ; Nos devolvemos al inicio de la llamada.

intToStringConversion:
				pusha ; Metemos en la pila todos los registros para guardar su estado.
				mov cx , 0 ; Colocamos el registro "cx" a cero para usarlo como contador.
				mov bx, 10 ; Colocamos el registro "bx" a 10 para usarlo como divisor.
				mov di, _intToString ; Colocamos el registro "di" apuntando a la variable "_intToString" que es la variable donde guardaremos el string.
				pushNumberInStack:
							mov dx, 0 ; Como nuestro divisor es de 16 bits se tomara como dividendo el part dx:ax por usando como parte alta dx y parte baja ax por tanto colocamos la parte 
									  ; alta dx a cero para que no afecte la division.
							div bx ; Dividimos dx:ax entre bx.
							inc cx ; Incrementamos el contador "cx" en una unidad para indicar que hemos realizado una division.
							push dx ; Guardamos el residuo de nuestra division en la pila ya que por defecto la instruccion DIV almacena el residuo en el registro dx.
							test ax, ax	; La instruccion DIV almacena el cociente de la division en el registro ax por ende revisamos si es cero mediante la instruccion TEST la cual se 
										; comporta igual que una AND pero sin modificar el origen a ceros o unos, en caso de que ax sea cero encendera la badera ZF a "1".
							jnz pushNumberInStack ; Si la bandera ZF es cero brinca al segmento de codigo "pushNumberInStack" de lo contrario continua.
				popNumberOfStack:
							pop dx ; Iremos sacando los numeros a la inversa desde la pila, es decir, del dividendo original el digito mas significativo sera el primero en salir de la pila.
							add dl, '0' ; Una vez que sacamos el digito debemos recordar que este digito internamente es tratado como un hexadecimal, y no como un numero decimal, por tanto
										; debemos convertirlo a decimal sumandole 48 que es lo mismo que sumarle '0', esto se puede ver en una tabla ASCII ya que un digito hexadecimal con
										; un valor de 5 por ejemplo, al sumarle 48 pasa a ser 53 el cual tiene un simbolo de 5 pero en decimal.
							mov [di], dl ; Movemos este nuevo numero al regitro "di" el cual ira guardado nuestro nuevo string.
							inc di ; Incrementamos el registro di para apuntar al siguiente byte libre para guarda un nuevo numero.
							dec cx ; Decrementamos el valor del contador "cx", debemos recordar que la instruccion DEC modificar el valor del flag ZF cuando su operando se vuelve cero,
								   ; es decir, cuando "cx" se vuelva cero ZF tomara un valor de "1".
							jnz popNumberOfStack ; Si ZF tiene un valor de cero muevase al segmento de codigo "popNumberOfStack" de lo contrario continue.
							
							mov byte [di], 0 ; Colocamos un byte de finalizacion de string que generalmente es un cero.

							popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
							mov ax, _intToString ; Movemos nuestro nuevo string al regitro "ax" para su posterior tratamiento.
							ret ; Nos devolvemos al inicio de la llamada.

startScrean:
		pusha ; Metemos en la pila todos los registros para guardar su estado.
		call clearScreen ; Limpiamos la pantalla de todo lo que tenga.
		mov ax, _tutormec ; Definimos lo que aparecera en la parte alta del fondo.
	    mov bx, _creator; Definimos lo que aparecera en la parte baja del fondo.
	    mov cx, 0x10; Definimos el color que tendra la letra.
		call drawStartScreenBackground ; Dibujamos el fondo de la pantalla de instrucciones.
		mov bl, 0x70 ; Definimos el color blanco sobre negro.             
	    mov dl, 15 ; Definimos la columna "15" para el cursor.
	    mov dh, 6 ; Definimos el renglon "6" para el cursor.
	    mov si, 50 ; Definimos un ancho de cuadrado de "50".
	    mov di, 20 ; Definimos una coordenada Y maxima de "20";
	    call drawBlock ; Llamamos a la rutina que dibuja el bloque de instrucciones.
		preparateMessage: 
					mov dl, 16 ; Seteamos la posicion de la columna.
			        mov dh, 6 ; Seteamos la posicion del renglon.
			        xor cl, cl ; Inicializamos la parte baja del registro "cx" a "0".
			        mov si, _instructions ; Movemos la direccion de memoria de la variable "_instructions" al regitro "si".
		loop:
			cmp cl, 12 ; Comparamos si el registro "cl" ha alcanzado las 12 lineas que tiene el mensaje.
	        je exit ; Si las 12 lineas han sido alcanzadas nos movemos al segmento "exit".
	        xor ax, ax ; Iniciamos el registro "ax" a "0".
	        mov al, byte [si] ; Obtenemos el numeros de caracteres que tiene la linea accediendo al primer byte de la misma.
	        inc si ; Nos posicionamos en el primer caracter de la linea (caracter alfabetico).
	        inc dh ; Incrementamos la posicion del puntero con respecto al renglon para dejar un espacio en la parte superior y cambiar de renglon.
	        call moveCursor ; Llamamos a la rutina que se encarga de setear el curso en la posicion indicada.
	        call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.
	        add si, ax ; Apuntamos el registro "si" a la siguiente fila del mensaje sumandole la cantidad de caracteres que tenia la fila anterior (guardados en el registro "ax").
	        inc cl ; Incrementamos el contador de filas "cl".
	        jmp loop ; Nos devolvemos al punto de partida para repetir el proceso.
		exit:
			popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
		    ret ; Nos devolvemos al inicio de la llamada.

drawLettersBlock:
			pusha ; Metemos en la pila todos los registros para guardar su estado.
	        mov bl, 0x70 ; Definimos el color blanco sobre fondo negro para el bloque donde se moveran las letras.
	        mov dl, 0 ; Iniciamos el bloque en la columna "0" de la pantalla.
	        mov dh, 0; Iniciamos el bloquea en el renglon "0" de la pantalla.
	        mov si, 80; Definimos un tamaño de bloque de "80".
	        mov di, 10; Definimos el bloque de letras las primeras "10" lineas de la pantalla.
	        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
	        popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
	        ret ; Nos devolvemos al inicio de la llamada.

drawImpactBlockBackground:
					pusha ; Metemos en la pila todos los registros para guardar su estado.
			        mov bl, 0x40 ; Definimos el color rojo sobre fondo negro para el bloque donde se moveran las letras.
			        mov dl, 0 ; Iniciamos el bloque en la columna "0" de la pantalla.
			        mov dh, 10; Iniciamos el bloque en el renglon "10" de la pantalla.
			        mov si, 80; Definimos un tamaño de bloque de "80".
			        mov di, 15; Definimos el fondo para 5 lineas unicamente.
			        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
			        popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
	        		ret ; Nos devolvemos al inicio de la llamada.

drawImpactBlock:
			pusha ; Metemos en la pila todos los registros para guardar su estado.
			mov bl, 0x00 ; Definimos el color negro sobre fondo rojo para el bloque donde se moveran las letras.
			mov si, 6; Definimos un tamaño de bloque de "6".
	        mov di, 14; Definimos el fondo para 5 lineas unicamente.
	        mov dh, 11; Iniciamos el primer bloque en el renglon "11" de la pantalla.
	        mov dl, 5 ; Iniciamos el primer bloque en la columna "5" de la pantalla.
	        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
	        mov dl, 21 ; Iniciamos el segundo bloque en la columna "21" de la pantalla.
	        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
	        mov dl, 37; Iniciamos el tercer bloque en la columna "37" de la pantalla;
	        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
	        mov dl, 53; Iniciamos el cuarto bloque en la columna "53" de la pantalla.
	        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
	        mov dl, 69; Iniciamos el quinto bloque en la columna "69" de la pantalla.
	        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
	        popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
	        ret ; Nos devolvemos al inicio de la llamada.

drawHandBackground:
			pusha ; Metemos en la pila todos los registros para guardar su estado.
			mov bl, 0x30 ; Definimos el color negro sobre fondo rojo para el bloque donde se moveran las letras.
			mov si, 80; Definimos un tamaño de bloque de "6".
	        mov di, 25; Definimos el fondo para 5 lineas unicamente.
	        mov dl, 0 ; Iniciamos el bloque en la columna "0" de la pantalla.
	        mov dh, 15; Iniciamos el bloque en el renglon "15" de la pantalla.
	        call drawBlock ; Llamamos a la rutina que dibuja el bloque en pantalla.
	        popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
	        ret ; Nos devolvemos al inicio de la llamada.
	
clearScreen:
		pusha ; Metemos en la pila todos los registros para guardar su estado.
		mov dx, 0 ; Llenamos la parte baja y la parte alta del registro "dx" con "0".
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

print:
	pusha ; Metemos en la pila todos los registros para guardar su estado.
	mov bp, sp ; Salvamos el valor del registro "sp" en el registro "bp".
	cont:
		lodsb ; Lee un byte almacenado en la direccion "ds:si" y lo transfiere al registro "al" incrementando "si" automaticamente.
		or al, al ; La bandera "zf" sera "1" cuando el registro "al" tenga un valor de "0".
		jz done ; Brinca al segmento "done" si la bandera "zf" es "1".
		mov ah, 0eh	; Definimos que se usara el modo TYY para la impresion de un caracter en pantalla perteneciente a la interrupcion BIOS 10h.
		int 10h ; Llamamos a la interrupcion del BIOS encarga de imprimir el caracter en pantalla.
		jmp cont ; Volvemos al segmento "cont".

	done:
		mov sp, bp ; Restauramos el valor del registro "sp" con el valor que guardamos en "bp".
		popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
		ret ; Nos devolvemos hasata donde nos llamaron.

drawBlock:
		pusha ; Metemos en la pila todos los registros para guardar su estado.
		draw:
			call moveCursor ; Seteamos la posicion del cursor.

			;Usamos la interrupcion 10h con la funcion 09h para copiar el caracter ' ' cx veces y dado que estamos en una resolucion de 80x25 se repite el caracter 80 veces hacia la derecha.
			mov ah, 09h ; Usamos la funcion 09h.
			mov bh, 0 ; Seteamos el numero de pagina a 0.
			mov cx, si ; Copiamos el caracter "si" veces.
			mov al, ' ' ; El caracter a copiar.
			int 10h ; Llamamos a la interrupcion del BIOS que hace la impresion del caracter repetidas veces.

			inc dh ; Incrementamos el renglon.

			mov ax, 0 ; Seteamos la parte alta y la parte baja del registro "ax" a "0".
			mov al, dh ; Copiamos el valor del renglon actual a la parte baje del registro "ax".
			cmp ax, di ; Comparamos si el renglon actual es el limite maximo en Y establecido por el valor del registro "di".
			jne draw ; Si aun no es el limite establecido entonces se continua dibujando.

			popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
			ret ; Nos devolvemos hasata donde nos llamaron.

hideCursor:
		pusha ; Metemos en la pila todos los registros para guardar su estado.
		mov ch, 32 ; Colocamos el cursor en modo "invisible".
		mov ah, 01h ; Usamos la funcion "01h" de la interrupcion del BIOS 10h para establecer el tamaño del cursor.
		mov al, 3 ; Colocamos el cursor en modo video.
		int 10h ; Llamamos a la interrupcion del BIOS.
		popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
		ret ; Nos devolvemos hasata donde nos llamaron.

verifyCapturedLetter:
				pusha ; Metemos en la pila todos los registros para guardar su estado.
				cmp ax, 0 ; Verificamos sino hay ninguna letra en el buffer pues de ser asi tiene sentido hacer las verificaciones siguientes.
				je exitVerifyCapturedLetter ; Sino la hay brincamos al segmento de codigo "exitVerifyCapturedLetter".
				cmp al, 97 ; Verificamos si la tecla que vamos a leer tiene un ASCII menos a "97".
				jl exitVerifyCapturedLetter ; Si es menor a "97" brincamos al segmento "exitVerifyCapturedLetter".
				cmp al, 122 ;  Verificamos si la tecla que vamos a leer tiene un ASCII mayor a "122".
				jg exitVerifyCapturedLetter ; Si es mayor a "122" brincamos al segmento "exitVerifyCapturedLetter".
				xor dx, dx ; Ponemos a cero el registro "dx" para su posterior uso.
				xor bx, bx ; Colocamos el registro "bx" a ceros.
				sub al, 96 ; Le restamos 96 al caracter ASCII que se encuentra guardado en el registro "al" para hacerlo cooncordar con nuestro arreglo de letras.
				mov bx, _letters ; Colocamos el array de letras en el registro "bx".
				push bx ; Guardamos el valor del registro "bx" para su posterior reutilizacion ya que lo usaremos como registro de indice.
				mov bx , _selectLettersArray ; Movemos el valor de la variable "_selectLettersArray" al registro "bx". 
				cmp [_selectLettersArray + 0], al ; Comparamos si la letra presionada se encuentra en pantalla en este momento.
		        je activeFlagCapturedLetter ; Si la letra se encuentra en pantalla se activa el flag para que comience la animacion de descenso.
		        cmp [_selectLettersArray + 1], al ; Comparamos si la letra presionada se encuentra en pantalla en este momento.
		        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
		        inc bx ; Le sumamos uno al registro "bx" por si la letra se encontrara en esta posicion.
		        popf ; Recuperamos el valor de las flags que habiamos guardado.
		        je activeFlagCapturedLetter ; Si la letra se encuentra en pantalla se activa el flag para que comience la animacion de descenso.
		        cmp [_selectLettersArray + 2], al ; Comparamos si la letra presionada se encuentra en pantalla en este momento.
		        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
		        inc bx ; Le sumamos uno al registro "bx" por si la letra se encontrara en esta posicion.
		        popf ; Recuperamos el valor de las flags que habiamos guardado.
		        je activeFlagCapturedLetter ; Si la letra se encuentra en pantalla se activa el flag para que comience la animacion de descenso.
		        cmp [_selectLettersArray + 3], al ; Comparamos si la letra presionada se encuentra en pantalla en este momento.
		        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
		        inc bx ; Le sumamos uno al registro "bx" por si la letra se encontrara en esta posicion.
		        popf ; Recuperamos el valor de las flags que habiamos guardado.
		        je activeFlagCapturedLetter ; Si la letra se encuentra en pantalla se activa el flag para que comience la animacion de descenso.
		        cmp [_selectLettersArray + 4], al ; Comparamos si la letra presionada se encuentra en pantalla en este momento.
		        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
		        inc bx ; Le sumamos uno al registro "bx" por si la letra se encontrara en esta posicion.
		        popf ; Recuperamos el valor de las flags que habiamos guardado.
		        je activeFlagCapturedLetter ; Si la letra se encuentra en pantalla se activa el flag para que comience la animacion de descenso.
				pop bx ; Sacamos el bx que habiamos metido en la pila pues ninguna comparacion anterior se cumplio.
		        jmp exitVerifyCapturedLetter ; Si no se encuentra en pantalla entonces nos salimos de la verificacion.
		        activeFlagCapturedLetter:
		        					xor ax, ax ; Colocamos el reigstro "ax" a ceros para utilizarlo en la multiplicacion.
		        					mov dx , [bx] ; Movemos al registro "dx" el valor que tiene asociado la direccion de memoria que se encuentra guardada en "bx".
					        		dec dx ; Decrementamos en una unidad "dx".
					        		mov al , 8 ; Guardamos el numero 8 en la parte baja del registro "ax" para realizar una multiplicacion.
					        		mul dl ; Multiplicamos el valor del registro "dl" por el valor del registro "al" con el resultado almacenado en "ax".
					        		pop bx ; Restauramos el valor original del 
					        		add bx , ax ; Le sumamos al registro "bx" el resultado de la multiplicacion anterior que estaba almacenada en "ax".
					        		add bx, 7 ; Nos colocamos sobre el flag de bandera capturada.
					        		mov byte [bx] , 1 ; Ponemos el flag a "1" para indicar que ha sido capturada.
		        exitVerifyCapturedLetter:
		        					popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
									ret ; Nos devolvemos hasta donde nos llamaron.

moveMessage:
		cmp byte [_note + 1], 0 ; Verificamos hacia donde se esta movimiendo nuestro mensaje.
		je moveMessageLeft ; Si el flag de direccion era cero se esta movimiento hacia la izquierda.
		moveMessageRight:
					cmp byte [_note], 48 ; Verificamos si ya esta al limite de la pantalla.
					jb moveMessageRightAux ; En caso que no lo este muevase hacia la derecha.
					mov byte [_note + 1], 0 ; Si llego al limite cambiemos el flag de direccion para que se mueva en la otra direccion.
					jmp exitMoveMessage ; Nos salimos de la rutina.
		moveMessageRightAux:
						inc byte [_note] ; Realizamos el movimiento hacia la derecha.
						jmp exitMoveMessage ; Nos salimos de la rutina.
		moveMessageLeft:
					cmp byte [_note], 0 ; Verificamos si ya esta al limite de la pantalla.
					ja moveMessageLeftAux ; En caso que no lo este muevase hacia la izquierda.
					mov byte [_note + 1], 1 ; Si llego al limite cambiemos el flag de direccion para que se mueva en la otra direccion.
					jmp exitMoveMessage ; Nos salimos de la rutina.
		moveMessageLeftAux:
						dec byte [_note] ; Realizamos el movimiento hacia la izquierda.
		exitMoveMessage:
				ret ; Nos devolvemos hasta donde nos llamaron.

moveLetters:
		loadLetterArray:
			        xor cx, cx ; Iniciamos el registro "cx" a "0".
			        mov cl , 1; Iniciamos la parte baja del registro "cx" en "1" con el fin que el contador inicie en uno y no cero.
			        mov bx, _letters ; Cargamos el arreglo de letras en el registro "bx".
		moveLettersLoop: 
					cmp cl, _existingLettersInArray ; Verificamos si ya movimos la ultima letra.
			        je exitMove ; Si ya movimos todas las letras nos movemos al segmento de codigo "exitMove".
			        mov si , _selectLettersArray ; Colocamos en el registro "si" la posicion inicial donde se encuentran las letras en pantalla.
			        cmp [_selectLettersArray + 0], cl ; Comparamos si el contador de letras guardado en "cl" que indica la letra actual existe dentro de las letras actuales en pantalla.
			        je moveLetter ; Si son iguales entonces brinque al segmento de codigo encargado de mover la letra.
			        cmp [_selectLettersArray + 1], cl ; Comparamos si el contador de letras guardado en "cl" que indica la letra actual existe dentro de las letras actuales en pantalla.
			        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
			        inc si ; Incrementamos el valor del registro "si" a la siguiente posicion.
			        popf ; Recuperamos el valor de las flags que habiamos guardado.
			        je moveLetter ; Si son iguales entonces brinque al segmento de codigo encargado de mover la letra.
			        cmp [_selectLettersArray + 2], cl ; Comparamos si el contador de letras guardado en "cl" que indica la letra actual existe dentro de las letras actuales en pantalla.
			        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
			        inc si ; Incrementamos el valor del registro "si" a la siguiente posicion.
			        popf ; Recuperamos el valor de las flags que habiamos guardado.
			        je moveLetter ; Si son iguales entonces brinque al segmento de codigo encargado de mover la letra.
			        cmp [_selectLettersArray + 3], cl ; Comparamos si el contador de letras guardado en "cl" que indica la letra actual existe dentro de las letras actuales en pantalla.
			        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
			        inc si ; Incrementamos el valor del registro "si" a la siguiente posicion.
			        popf ; Recuperamos el valor de las flags que habiamos guardado.
			        je moveLetter ; Si son iguales entonces brinque al segmento de codigo encargado de mover la letra.
			        cmp [_selectLettersArray + 4], cl ; Comparamos si el contador de letras guardado en "cl" que indica la letra actual existe dentro de las letras actuales en pantalla.
			        pushf ;	Guardamos las flags actuales en la pila para recuperarlas despues.
			        inc si ; Incrementamos el valor del registro "si" a la siguiente posicion.
			        popf ; Recuperamos el valor de las flags que habiamos guardado.
			        je moveLetter ; Si son iguales entonces brinque al segmento de codigo encargado de mover la letra.
			        jmp nextLetter ; Si ninguna de las condiciones anterior se cumplio es porque la letra actual no se encuentra en pantalla entonces tomamos la siguiente letra.
		moveLetter:
				mov al, [ bx + 7] ; Verificamos el estado del flag de captura, en caso que sea "1" la letra se movera hacia abajo y no hacia los costados.
				cmp al , 1 ; Si el flag es "1" se procede a realizar el movimiento.
				je checkDownMove ; Movemos la letra hacia abajo.
			    mov al, [bx + 6] ; Comprobamos el flag de direccion para ver hacia donde se tienen que mover nuestras letras.
			    cmp al, 0 ; Si es "0" se movera hacia la izquierda, si es "1" se movera hacia la derecha.
			    je checkLeftMove ; Mandamos la letra a moverse a la izquierda.
				checkRightMove:
							mov al, [bx] ; Colocamos la posicion X de la letra en el registro "al";
							cmp al , 79 ; Verificamos si la letra se encuentra en el final de la pantalla.
							jb rightMove ; Si la posicion de la letra esta por debajo de la posicion "79" entonces muevala.
							jmp restartLetter ; Restauramos la letra a su posicion original.
				rightMove:
						inc al ; Incrementamos la posicion "X" de la letra.
						mov [bx] , al; Guardamos la posicion "X" en el arreglo de la letra para que sea posteriormente refrescada su posicion.
						jmp nextLetter; Cargamos la siguiente letra.
				checkLeftMove:
						mov al, [bx] ; Colocamos la posicion X de la letra en el registro "al";
						cmp al , 0 ; Verificamos si la letra se encuentra al inicio de la pantalla.
						ja leftMove ; Si la posicion de la letra esta por encima de "0" entonces muevala.
						jmp restartLetter ; Restauramos la letra a su posicion original.
				leftMove:
						dec al ; Decrementamos la posicion "X" de la letra.
						mov [bx] , al; Guardamos la posicion "X" en el arreglo de la letra para que sea posteriormente refrescada su posicion.
						jmp nextLetter ; Cargamos la siguiente letra.
				checkDownMove:
						mov al, [bx + 1] ; Colocamos la posicion Y de la letra en el registro "al".
						cmp al, 11 ; Verificamos si la letra se encuentra exactamente donde inicia un bloque de impacto.
						jnz checkDownMoveAux ; Si no se cumple la condicion anterior saltamos al segmento de codigo "checkDownMoveAux".
						xor dx, dx ; Colocamos el registro "dx" a ceros para que nos sirva de contador.
						verifyImpactArea:
										cmp dl, 30 ; Verificamos si ya recorrio todas las zonas de impacto.
										je checkDownMoveAux ; Si recorrio ya todas las zonas de impacto es porque la letra no se encontraba en ninguna de ellas, entonces 
															; continua con el flujo normal.
										xor dh, dh ; Reseamos la parte alta del registro "dx" para que no afecte la suma con basura.
										mov di , _impactArea ; Colocamos en el registro "si" el inicio de memoria donde se encuentran las zonas de impacto para cada letra.
										add di, dx ; Le sumamos al registro "si" lo que hay en "dl" para irnos moviendo por la memoria que contiene las zonas de impacto.
										mov dh, [di] ; Movemos a la parte alta del registro "dx" la zona de impacto actual que estamos verificando.
										cmp byte [bx], dh ; Verificamos si la letra se encontraba en una zona de impacto.
										je restartMemory ; Si era zona de impacto restauramos la letra a su posicion original y modificamos la direccion en la 
														 ; cual se encuentra la letra a cero.
										inc dl ; Sumamos uno al contador.
										jmp verifyImpactArea ; Volvermos a verificar con la siguiente zona de impacto.
						checkDownMoveAux:
									cmp al , 14 ; Verificamos si la letra se encuentra debajo de el borde de la zona de impacto.
									jb moveDown ; Movemos la letra hacia abajo.
									add byte [_scoreCount], 1 ; Incrementamos en una unidad el puntaje de letras atrapadas.
						restartMemory:
									mov byte [si], 0 ; Ponemos esa direccion de memoria a "0" para que se asigne una nueva letra a esa posicion.
									jmp restartLetter; Si es asi restauramos la letra a su posicion original y modificamos la direccion en la cual se encuentra la 
													 ; letra a cero.
				moveDown:
						inc al ; Incrementamos la posicion Y de la letra.
						mov [bx + 1], al ; Guardamos la posicion "Y" en el arreglo de la letra para que sea posteriormente refrescada su posicion.
						jmp nextLetter; Cargamos la siguiente letra.D
				restartLetter:
							mov byte [bx + 7], 0 ; Reiniciamos la letra para que ya no se mueva hacia abajo.
							mov al, [bx + 3] ; Movemos al registro "al" la posicion Y original de la letra.
							mov byte [bx + 1], al ; Guardamos en Y la posicion original.
							mov al, [ bx + 2] ; Movemos al registro "al" la posicion X original de la letra.
							mov byte [bx], al ; Guardamos en X la posicion original.
							jmp nextLetter ; Cargamos la siguiente letra.
		nextLetter: 
				add bx, 8 ; Nos movemos a la posicion "X" de la siguiente letra.
		        inc cl ; Incrementamos el contador de letras movidas.
		        jmp moveLettersLoop ; Nos movemos al inicio para mover otra letra.
		exitMove:
				ret ; Nos devolvemos hasata donde nos llamaron.

makeADelay:
		pusha ; Metemos en la pila todos los registros para guardar su estado.
		cmp ax, 0 ; Verificamos si el retraso solicitado es de cero.
		je endDelay ; Si el retraso solicitado SI era de cero terminamos el delay brincando al segmento "endDelay".
		mov cx, 0 ; Iniciamos el registro "cx" a cero.
		mov [_delayCounter], cx ; Iniciamos la variable "_delayCounter" a cero.
		mov bx, ax ; Guardamos el valor del registro "ax" en "bx" pues se necesita que el retraso sea multiplo de "110ms" por tanto hay que realizar una multiplicacion.
		mov ax, 0 ; Iniciamos el registro "ax" a "0".
		mov al, 2 ; Guardamos en la parte baja del registro "ax" un valor de "2".
		mul bx ; Multiplicamos el registro "bx" contra el registro "ax" y el resultado es guardado en el registro "ax" de esta forma creando el multiplo de "110ms" necesitado.
		mov [_requestedDelay], ax ; Guardamos el valor de la multiplicacion en la variable "_requestedDelay".
		;Solicitamos el "tick count" actual usando la interrupcion 1AH con la funcion 00h para almacenarlo (en el registro dx) y realizar la posterior comparacion.
		mov ah, 0
		int 1Ah
		mov [_previousTickRequested], dx ; Guardamos el resultado del "tick count" solicitado.
		loopRequestTickCount:
						; Volvemos a solicitar el "tick count" para verificar si ha cambiado.
						mov ah,0
						int 1Ah
						cmp [_previousTickRequested], dx ; Comparamos el "tick count" actua obtenido con el anterior solicitado.
						jne checkRequestedDelay ; En caso que el "tick count" haya cambiado Verificamos si corresponde con el delay solicitado.
						jmp loopRequestTickCount ; En caso de que el "tick count" aun no haya cambiado lo volvemos a solicitar.
	    endDelay:
				popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
				ret ; Nos devolvemos hasata donde nos llamaron.
		checkRequestedDelay:
						;Incrementamos el valor de la variable "_delayCounter" en una unidad para denotar que el "tick count" ya cambio.
						mov ax, [_delayCounter]
						inc ax
						mov [_delayCounter], ax
						cmp ax, [_requestedDelay] ; Verificamos si el delay que ha pasado es el solicitado.
						jge endDelay ; Si es el delay solicitado terminamos el delay.
						mov [_previousTickRequested], dx ; Si aun no es el delay solicitado actualizamos el "tick count" al ultimo solicitado y pedimos uno nuevo.
						jmp loopRequestTickCount ; Nos movemos para pedir un nuevo "tick count".

drawStartScreenBackground:
					pusha ; Metemos en la pila todos los registros para guardar su estado.

					;Guardamos todos los parametros que definimos antes para su posterior utilizacion
					push ax	
					push bx
					push cx

					;Seteamos el curso en la posicion 0:0 de la pantalla.
					mov dl, 0
					mov dh, 0
					call moveCursor

					;Usamos la interrupcion 10h con la funcion 09h para copiar el caracter ' ' cx veces y dado que estamos en una resolucion de 80x25 se repite el caracter 80 veces hacia la derecha.
					mov ah, 09h ; Usamos la funcion 09h.
					mov bh, 0 ; Seteamos el numero de pagina a 0.
					mov cx, 80 ; Copiamos el caracter 80 veces.
					mov bl, 70h ; Definimos el color blanco sobre negro.
					mov al, ' ' ; El caracter a copiar.
					int 10h ; Llamamos a la interrupcion del BIOS que hace la impresion del caracter repetidas veces.

					;Movemos el cursor a la posicion de renglon "1" y columna "0".
					mov dh, 1
					mov dl, 0
					call moveCursor

					;Usamos la interrupcion 10h con la funcion 09h para copiar el caracter ' ' cx veces y dado que estamos en una resolucion de 80x25 se repite el caracter 1840 veces hacia la derecha
					;que corresponden a los pixeles que hay hasta el renglon 24.
					mov ah, 09h ; Usamos la funcion 09h.
					mov cx, 1840 ; Copiamos el caracter 1840 veces.
					pop bx; Obtenemos el color original que habiamos definido en cx cuando lo agregamos a la pila (0x10).
					mov bh, 0 ; Seteamos la pagina a "0".
					mov al, ' ' ; El caracter a copiar.
					int 10h ; Llamamos a la interrupcion del BIOS que hace la impresion del caracter repetidas veces.

					;Movemos el cursor a la posicion de renglon "24" y columna "0".
					mov dh, 24
					mov dl, 0
					call moveCursor

					;Usamos la interrupcion 10h con la funcion 09h para copiar el caracter ' ' cx veces y dado que estamos en una resolucion de 80x25 se repite el caracter 80 veces hacia la derecha.
					mov ah, 09h ; Usamos la funcion 09h.
					mov bh, 0 ; Seteamos el numero de pagina a 0.
					mov cx, 80 ; Copiamos el caracter 80 veces.
					mov bl, 70h ; Definimos el color blanco sobre negro.
					mov al, ' ' ; El caracter a copiar.
					int 10h ; Llamamos a la interrupcion del BIOS que hace la impresion del caracter repetidas veces.

					;Movemos el curso a la posicion de renglon "24" y columna "1".
					mov dh, 24
					mov dl, 1
					call moveCursor

					pop bx ; Sacamos de la pila el valor que habiamos almacenado correspondiente al titulo de la parte baja del fondo.
					mov si, bx ; Movemos la direccion del registro "bx" a "si".
					call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.

					;Movemos el cursor al renglon "0" y columna "1".
					mov dh, 0
					mov dl, 1
					call moveCursor

					pop ax ; Sacamos de la pila el valor que habiamos almacenado correspondiente al titulo de la parte alta del fondo.
					mov si, ax ; Movemos la direccion del registro "ax" a "si".
					call print ; Llamamos a la rutina que se encarga de imprimir el mensaje.

					;Movemos el cursor a la zona de escritura del fondo.
					mov dh, 1			
					mov dl, 0
					call moveCursor

					popa ; Sacamos de la pila todos los registro para devolver a su estado anterior.
					ret ; Nos devolvemos hasata donde nos llamaron.

_tutormec db "Tutormec", 0
_creator db "Yeison Cruz", 0
_score db "Puntaje: ", 0
_lettersArrayCount db 0
_scoreCount dw 0
_requestedDelay dw 0
_delayCounter dw 0
_previousTickRequested dw 0
_intToString times 7 db 0
_instructions:  db 9, "Tutormec", 0
		        db 1, 0
		        db 46, "Bienvenido (a) al mejor juego de mecanografia", 0
		        db 45, "que has jugado en tu vida, captura todas las", 0
		        db 46, "letras que te sean posible usando el teclado,", 0
		        db 46, "pero ten cuidado, no choques con los bloques.", 0
		        db 1, 0
		        db 41, "Es hora de aprender jugando, diviertete.", 0
		        db 1, 0
		        db 46, "Presiona esc para salir en cualquier momento.", 0
		        db 29, "Presiona enter para iniciar.", 0
		        db 1, 0

		   ; X, Y, ORIGINAL X, ORIGINAL Y, LETTER, FINALE, DIRECTION (LEFT = 0 OR RIGHT = 1), CAPTURED.
_letters: db 79, 1, 79, 1, "A", 0, 0, 0 ; 1
		  db 0, 3, 0, 3, "B", 0, 1, 0
		  db 79, 5, 79, 5, "C", 0, 0, 0
		  db 0, 7, 0, 7, "D", 0, 1, 0
		  db 79, 9, 79, 9, "E", 0, 0, 0 ; 5
		  db 79, 1, 79, 1, "F", 0, 0, 0
		  db 0, 3, 0, 3, "G", 0, 1, 0
		  db 79, 5, 79, 5, "H", 0, 0, 0
		  db 0, 7, 0, 7, "I", 0, 1, 0
		  db 79, 9, 79, 9, "J", 0, 0, 0 ; 10
		  db 79, 1, 79, 1, "K", 0, 0, 0
		  db 0, 3, 0, 3, "L", 0, 1, 0
		  db 79, 5, 79, 5, "M", 0, 0, 0
		  db 0, 7, 0, 7, "N", 0, 1, 0
		  db 79, 9, 79, 9, "O", 0, 0, 0 ; 15
		  db 79, 1, 79, 1, "P", 0, 0, 0
		  db 0, 3, 0, 3, "Q", 0, 1, 0
		  db 79, 5, 79, 5, "R", 0, 0, 0
		  db 0, 7, 0, 7, "S", 0, 1, 0
		  db 79, 9, 79, 9, "T", 0, 0, 0 ; 20
		  db 79, 1, 79, 1, "U", 0, 0, 0
		  db 0, 3, 0, 3, "V", 0, 1, 0
		  db 79, 5, 79, 5, "W", 0, 0, 0
		  db 0, 7, 0, 7, "X", 0, 1, 0
		  db 79, 9, 79, 9, "Y", 0, 0, 0 ; 25
		  db 79, 1, 79, 1, "Z", 0, 0, 0  

		  				; X LETTER, Y LETTER, LETTER, FINALE, X MSJ, Y MSJ, MSJ, FINALE
_lettersFingerPressure: db 7, 17, "A", 0, 3, 19, "* O O O O.", 0 ; 1
						db 23, 17, "B", 0, 19, 19, "O O O * O.", 0
						db 39, 17, "C", 0, 35, 19, "O O * O O.", 0
						db 55, 17, "D", 0, 51, 19, "O O * O O.", 0
						db 71, 17, "E", 0, 67, 19, "O O * O O.", 0 ; 5
						db 7, 17, "F", 0, 3, 19, "O O O * O.", 0
						db 23, 17, "G", 0, 19, 19, "O O O * O.", 0
						db 39, 17, "H", 0, 34, 19, ".O * O O O", 0
						db 55, 17, "I", 0, 50, 19, ".O O * O O", 0
						db 71, 17, "J", 0, 66, 19, ".O * O O O", 0 ; 10
						db 7, 17, "K", 0, 2, 19, ".O O * O O", 0
						db 23, 17, "L", 0, 18, 19, ".O O O * O", 0
						db 39, 17, "M", 0, 34, 19, ".O * O O O", 0
						db 55, 17, "N", 0, 50, 19, ".O * O O O", 0
						db 71, 17, "O", 0, 66, 19, ".O O O * O", 0 ; 15
						db 7, 17, "P", 0, 2, 19, ".O O O O *", 0
						db 23, 17, "Q", 0, 19, 19, "* O O O O.", 0
						db 39, 17, "R", 0, 35, 19, "O * O O O.", 0
						db 55, 17, "S", 0, 51, 19, "O * O O O.", 0
						db 71, 17, "T", 0, 67, 19, "O O O * O.", 0 ; 20
						db 7, 17, "U", 0, 2, 19, ".O * O O O", 0
						db 23, 17, "V", 0, 19, 19, "O O O * O.", 0
						db 39, 17, "W", 0, 35, 19, "O * O O O.", 0
						db 55, 17, "X", 0, 51, 19, "O * O O O.", 0
						db 71, 17, "Y", 0, 66, 19, ".O * O O O", 0 ; 25
						db 7, 17, "Z", 0, 3, 19, "* O O O O.", 0
_note db 48, 0, "Este programa es software libre", 0