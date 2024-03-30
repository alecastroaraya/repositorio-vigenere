;--------------------------------------------Portada-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Tarea de ASM: Repositorio Vigenere
; Curso: Arquitectura de Computadores
; Grupo: 2
; Escuela de Computacion
; Instituto Tecnologico de Costa Rica
; Fecha de entrega: 21 de octubre del 2020
; Estudiante: Alejandro Castro Araya
; Carne: 2020034944
; Profesor: Kirstein Gatjens
;--------------------------------------------Manual de Usuario-------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Este programa recibe una letra como opcion, y dependiendo de ella, cumple diferentes funciones con archivos. Dependiendo de la letra se toman diferentes parametros. Se separa todo por medio de un guion (-).
; Significado de los parametros: repositorio -> el repositorio deseado, archivo -> el archivo deseado, "clave" -> un string.
; Las posibles opciones con sus diferentes parametros y la explicacion de lo que hacen son:
; -H                                   Despliega la ayuda del programa. Dice las posibles opciones de letra y lo que hace el programa dependiendo de la opcion escogida. Tambien se despliega si no se escribe nada.
; -C repositorio                       Crea un nuevo repositorio de archivos cifrados. Lo crea vacio, es decir con solo los primeros cinco caracteres del repositorio.
; -A repositorio archivo "clave"       Agrega el archivo solicitado al final del repositorio solicitado. Las comillas dobles se deben escribir pero no son parte de la clave.
; -X repositorio archivo "clvae"       Extrae el archivo solicitado del repositorio solicitado y escribe el texto en un archivo nuevo. Si ya existe el archivo entonces no lo sobreescribe.
; -B repositorio archivo               Elimina la primera aparición del archivo solicitado en el repositorio solicitado.
; -L repositorio                       Despliega el listado de archivos que contiene el repositorio Despliega sus nombres y tamanos en bytes en decimal, y tambien la cantidad de archivos almcadenados.
;--------------------------------------------Analisis de resultados-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;+-----------------------------------------------------------------------------------------------------+------+--------------------------------------------------------------------------------------------------------------------------------+
;|                                            Parte                                                    | Nota | Explicacion Adicional                                                                                                          |
;+-----------------------------------------------------------------------------------------------------+------+--------------------------------------------------------------------------------------------------------------------------------+
;| Mini acerca de.                                                                                     | A    | Funciona correctamente                                                                                                         |
;| Recibir y guardar todas las opciones y sus parametros correspondientes de la linea de comando.      | A    | Funciona correctamente                                                                                                         |
;| Validaciones y desplegar mensajes de error y de éxito.                                              | A    | Funciona correctamente                                                                                                         |
;| Permitir múltiples espacios en blanco entre las diferentes entradas de la línea de comandos.        | A    | Funciona correctamente                                                                                                         |
;| Medidor de tiempo porcentual.                                                                       | A    | Funciona correctamente                                                                                                         |
;| Agregar la extensión .rvg al final del nombre del repositorio sin que uno tenga que escribirla .    | A    | Funciona correctamente                                                                                                         |
;| Revisar si un repositorio sigue el formato adecuado y dar un error en ese caso.                     | A    | Funciona correctamente                                                                                                         |
;| No permitir wild cards en los nombres de archivo.                                                   | A    | Funciona correctamente                                                                                                         |
;| Desplegar la ayuda si se escribe -H o no se escribe nada.                                           | A    | Funciona correctamente                                                                                                         |
;| -C repositorio crea un nuevo repositorio vacio con las estructuras necesarias.                      | A    | Funciona correctamente                                                                                                         |
;| Agregar un nuevo archivo al repositorio con -A repositorio archivo "clave".                         | A    | Funciona correctamente                                                                                                         |
;| Extraer un archivo del repositorio con -X repositorio archivo "clave".                              | B    | Si extrae el texto y lo descifra correctamente, pero si no era el ultimo archivo entonces tambien extrae los textos anteriores.|
;| Borrar un archivo del repositorio con -B repositorio archivo.                                       | C    | Para borrar el archivo y su encabezado los deja como caracteres null en vez de completamente quitar el texto del archivo.      |
;| Listado de archivos, sus tamanos y nombres, y cantidad de archivos almacenados con -L repositorio.  | A    | Funciona correctamente                                                                                                         |
;| Creación correcta de los encabezados del repositorio RVG, cada uno en grupos de 20 bytes.           | A    | Funciona correctamente                                                                                                         |
;| Almacenamiento del texto cifrado en el repositorio sin delimitadores.                               | A    | Funciona correctamente                                                                                                         |
;| Encriptar el texto con la encripción Vigenere correctamente usando sumas.                           | A    | Funciona correctamente                                                                                                         |
;| Desencriptar el texto con la encripción Vigenere correctamente usando restas.                       | A    | Funciona correctamente                                                                                                         |
;| Documentación (Portada, manual de usuario y analisis de resultados con ABCD y comentarios)          | A    | Escrita correctamente                                                                                                          |
;+-----------------------------------------------------------------------------------------------------+------+--------------------------------------------------------------------------------------------------------------------------------+

data segment

	acercade db 'Arquitectura de Computadores Gr 2 Alejandro Castro Araya ' ,13, 10, 'Carne 2020034944 Ver. 0.74-3 10/10/2020 Tarea Repositorio Vigenere', 13, 10, ' ', 13, 10, '$'
	ayuda1 db 'Este programa empaqueta archivos en uno solo codificandolos con el algoritmo Vigenere y recibe varios parametros en la linea de comandos. Opciones:',13,10, 13,10, '-H -> Despliega la ayuda.',13,10, '-C repositorio -> Crea un nuevo repositorio de archivos cifrados.',13,10, '-A repositorio archivo "clave" -> Agrega el archivo al final del repositorio.',13,10, '$'
	ayuda2 db '-X repositorio "clave" -> Extrae el archivo solicitado del repositorio.',13,10, '-B repositorio archivo -> Elimina la primera aparicion del archivo del repositorio.',13,10, '$'
	ayuda3 db '-L repositorio -> Despliega el listado de archivos que contiene el repositorio.',13,10,'$'
	letra db 80, 0, 80 dup('$')
	errorletra db 'No ingreso una letra correcta. Terminando el programa...$'
	errorrepositorio db 'El repositorio no existe. Terminando el programa...$'
	errorarchivo db 'El archivo no existe. Terminando el programa...$'
	repositorio db 128 dup ( ? )
	archivo db 128 dup ( ? )
	clave db 128 dup ( ? )
	handleS dw ?
	handleE dw ?
	handleT dw ?
	buffy db 128 dup (?)
	msgerror db 'Error al procesar.$'
	msgcreado db 'El repositorio ha sido creado con exito.$'
	repnuevo db 'RVg'
	tamano dw 0
	nombre db 128 dup ( ? )
	extension db 128 dup ( ? )
	desplazamiento db 0
	numarchivos db 128 dup ( ? )
	nulo db 0
	cifrado db 128 dup ( ? )
	largonombre dw ?
	dspz dw 16
	inicial dw 5
	contador db 0
	contadorW dw 0
	totalsize dw 0
	buffyW dw 0
	texto db 128 dup ( ? )
	posicion dw 5
	msgcreado2 db 'El archivo ha sido creado con exito.$'
	noesta db 'El archivo solicitado no existe.$'
	msgextraido db 'El archivo ha sido extraido.$'
	vacio db 'Hay 0 archivos almacenados en el repositorio.$'
	espacio db ' $'
	msgnumfiles db ' --> Cantidad de archivos en el repositorio.$'
	cantidad db ' --> Tamano en bytes: $'
	extraer1 dw 0
	extraer2 dw 0
	msgborrado db 'El archivo ha sido borrado.$'
	barraprogreso db '|$'
	repexiste db 'Este repositorio ya existe!$'
	fileexiste db 'Este archivo ya existe!$'
	msgformato db 'El repositorio tiene un formato invalido!$'
	errornombre db 'El nombre del archivo es invalido.$'

data ends


pila segment stack 'stack'
   dw 256 dup(?)

pila ends


code segment

        assume  cs:code, ds:data, ss:pila

mostrarAyudaH Proc
	cmp letra,20h ; Se compara la letra con null para ver si no se escribio nada. Si no se escribio nada se desplega la ayuda.
	jl desplegarAyuda
	cmp letra,48h ; Se compara la letra con H en hexadecimal. Si se escribio H se desplega la ayuda.
	je desplegarAyuda
	jmp volverMostrarAyuda
desplegarAyuda:	
	lea dx,ayuda1 ; Despliega los mensajes de ayuda.
	mov ah,9h
	int 21h
	lea dx,ayuda2
	mov ah,9h
	int 21h
	lea dx,ayuda3
	mov ah,9h
	int 21h
	jmp terminarAyuda
terminarAyuda:	
	mov ah,4ch ; Hace interrupt para hacer exit hacia DOS para terminar el programa.
	int 21h
volverMostrarAyuda:
	ret
mostrarAyudaH endP

revisarExisteRep Proc
	push dx
	push ax
	push bx
	
	mov ah,3Dh ; intenta abrir el archivo del repositorio. si no da error, eso significa que ya existe.
	mov al,2
	lea dx,repositorio
	int 21h
	
	cmp ax,2 ; el error 2 en el ax al intentar abrir un archivo significa que el archivo no existe
	jne yaExisteRep
	jmp volverRevisarExisteRep
yaExisteRep:
	call CamLin
	lea dx,repexiste
	mov ah,9h
	int 21h
	mov ah,4ch
	int 21h
volverRevisarExisteRep:	
	pop dx
	pop ax
	pop bx
	
	ret
revisarExisteRep endP

revisarExisteFile Proc
	push dx
	push ax
	push bx
	
	mov ah,3Dh ; intenta abrir el archivo del texto que se quiere cifrar o extraer. si no da error, eso significa que ya existe.
	mov al,2
	lea dx,archivo
	int 21h
	
	cmp ax,2 ; el error 2 en el ax al intentar abrir un archivo significa que el archivo no existe
	jne yaExisteFile
	jmp volverRevisarExisteFile
yaExisteFile:
	call CamLin
	lea dx,fileexiste
	mov ah,9h
	int 21h
	mov ah,4ch
	int 21h
volverRevisarExisteFile:	
	pop dx
	pop ax
	pop bx
	
	ret
revisarExisteFile endP

revisarFormato Proc
	push dx
	push cx
	push bx
	push ax

	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio
	int 21h
	mov handleS,ax
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,0
	int 21h

	mov ah, 3Fh  ; se van leyendo los primeros tres caracteres del repositorio. 
    mov cx, 1
    lea dx,buffy
    mov bx,handleS
    int 21h
	
	cmp byte ptr buffy,'R' ; si no tiene una R de primer byte, el formato es invalido
	jne wrongFormato
	
	mov ah, 3Fh  ; leemos el caracter del archivo
    mov cx, 1
    lea dx,buffy
    mov bx,handleS
    int 21h
	
	cmp byte ptr buffy,'V' ; Si no tiene una V de segundo byte el formato es invalido
	jne wrongFormato
	
	mov ah, 3Fh  ; leemos el caracter del archivo
    mov cx, 1
    lea dx,buffy
    mov bx,handleS
    int 21h
	
	cmp byte ptr buffy,'g' ; Si no tiene una g de tercer byte el formato es invalido
	jne wrongFormato
	
	jmp volverRevisarFormato ; Si tiene los tres caracteres correctos entonces el formato es valido
wrongFormato:
	call CamLin
	lea dx,msgformato
	mov ah,9h
	int 21h
	mov ah,4ch
	int 21h
volverRevisarFormato:
	mov ah,3Eh
	mov bx,handleS
	int 21h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
revisarFormato endP

getRepositorio Proc
	mov si,84h ; Se mueve la linea de comandos al source index
	xor di,di
loopearRepositorio:
	mov al,byte ptr es:[si] ; Se busca el comienzo del parametro de repositorio recorriendo los espacios hasta que se llegue a un caracter que no sea un espacio
	cmp al,' '
	jne esParametro
	inc si
	jmp loopearRepositorio
esParametro:
	mov al,byte ptr es:[si] ; Se van agarrando los caracteres del nombre del repositorio y moviendo a al hasta que se encuentra un espacio o hasta que se acabo el texto ingresado
	cmp al,20h
	jl strParametro
	cmp al,' '
	je strParametro
	mov byte ptr repositorio[di],al
	inc di
	inc si
	jmp esParametro
strParametro:
	mov byte ptr repositorio[di],'.' ; Cuando ya se agarro el nobmre del repositorio, se le agrega .rvg al final para que esa sea la extension y que asi no se tenga que escribir manualmente
	inc di
	mov byte ptr repositorio[di],'R'
	inc di
	mov byte ptr repositorio[di],'V'
	inc di
	mov byte ptr repositorio[di],'G'
	inc di
	mov byte ptr repositorio[di],'$'
volverGetRepositorio:
	lea dx,barraprogreso ; Se despliega la barra de progreso
	mov ah,9h
	int 21h
	ret
getRepositorio endP

getArchivo Proc
	xor di,di
loopearArchivo:
	mov al,byte ptr es:[si] ; Se recorren los espacios hasta llegar al nombre del archivo
	cmp al,' '
	jne esArchivo
	inc si
	jmp loopearArchivo
esArchivo:
	inc largonombre
	mov al,byte ptr es:[si] ; Primero se revisa si el nombre del archivo tiene algun caracter invalido. Si lo tiene entonces da error y termina el programa.
	cmp al, '*'
	je errorNombreArchivo
	cmp al, '/'
	je errorNombreArchivo
	cmp al, '"'
	je errorNombreArchivo
	cmp al, '<'
	je errorNombreArchivo
	cmp al, '>'
	je errorNombreArchivo
	cmp al, '?'
	je errorNombreArchivo
	cmp al, '|'
	je errorNombreArchivo
	cmp al, '?'
	je errorNombreArchivo
	cmp al, ':'
	je errorNombreArchivo
	cmp al,20h ; Si no tenia caracteres invalido entonces se agarran caracteres hasta que se acabe el texto o llegar a un espacio.
	jl strArchivo
	cmp al,' '
	je strArchivo
	mov byte ptr archivo[di],al
	inc di
	inc si
	jmp esArchivo
strArchivo:
	mov byte ptr archivo[di],'$' ; Al final se le pune un caracter null al final del nombre para que se pueda usar como string.
	jmp volverGetArchivo
errorNombreArchivo:
	call CamLin
	lea dx,errornombre
	mov ah,9h
	int 21h
	mov ah,4ch
	int 21h
volverGetArchivo:
	lea dx,barraprogreso ; Se despliega la barra de progreso.
	mov ah,9h
	int 21h
	ret
getArchivo endP

getClave Proc
	xor di,di
loopearClave:
	mov al,byte ptr es:[si] ; Recorre los espacios hasta llegar a la clave.
	cmp al,'"'
	je esClave
	inc si
	jmp loopearClave
esClave:
	inc si
	mov al,byte ptr es:[si] ; Mueve los caracteres del nombre del archivo a la variable clave caracter por caracter hasta llegar al segundo caracter de doble comilla
	cmp al,'"'
	je strClave
	mov byte ptr clave[di],al
	inc di
	jmp esClave
strClave:
	mov byte ptr clave[di],'$' ; Cuando ya tiene el nombre, se le agrega un signo de dolar para terminar el string con un caracter null
volverGetClave:
	lea dx,barraprogreso ; Se despliega la barra de progreso
	mov ah,9h
	int 21h
	ret
getClave endP

crearRepositorioC Proc
	call getRepositorio ; Se obtiene el nombre del repositorio
	xor di,di
	mov ah,3Ch
	lea dx,repositorio ; Se crea un archivo con el nombre del repositorio
	xor cx,cx
	int 21h
	jnc seguirC
	jmp darError
seguirC:
	mov handleS,ax ; Si no dio error entonces se mueve el handle a la variable handleS
	mov bx,handleS
	mov cx,5 ; Se mueve un 5 a cx porque esa es la cantidad de caracteres que debe tener un repositorio vacio al ser creado (RVg y el tamano en complemento a la base)
	
	mov al,52h ; Se mueve la R al inicio del buffer
	mov byte ptr buffy[di],al
	
	lea dx,barraprogreso ; Se va desplegando la barra de progreso cada vez que se mueve un caracter al buffer
	mov ah,9h
	int 21h
	
	inc di ; S mueve la V
	mov al,56h
	mov byte ptr buffy[di],al
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	inc di
	mov al,67h ; Se mueve la g
	mov byte ptr buffy[di],al
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	inc di
	mov al,00h ; Se mueve un 0 porque inicialmente tiene 0 archivos
	mov byte ptr buffy[di],al
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	inc di
	mov al,00h ; Se mueve otro 0 porque es en complemento a la base
	mov byte ptr buffy[di],al
	
	mov ah,40h ; Luego, se escriben todos esos caracteres que estan en el buffer al archivo en si
	lea dx,buffy
	int 21h
cerrarC:
	mov ah,3Eh ; Se cierra el archivo
	mov bx,handleS
	int 21h
volverCrearRepositorioC:

	lea dx,barraprogreso ; Se despliega la barra de progreso
	mov ah,9h
	int 21h

	ret
crearRepositorioC endP

agregarArchivoA Proc
	call getRepositorio
	call getArchivo
	call getClave
abrirRepositorioA1:
	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio
	int 21h
	jnc abrirRepositorioA2
	jmp darErrorArchivoA
abrirRepositorioA2:
	mov handleS,ax
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
abrirArchivoA1:
	mov ah,3Dh
	mov al,0
	lea dx,archivo ; Se abre el archivo y se mueve su handle a handleE porque esta es la entrada
	int 21h
	jnc abrirArchivoA2
	jmp darErrorArchivoA
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
abrirArchivoA2:
	mov handleE,ax
	mov si,0
leerCaracter:
	mov ah,42h
	mov bx,handleS ; Se pone el pointer al inicio del archivo y se van leyendo sus caracteres uno por uno en un ciclo
	mov al,00h
	mov cx,0
	mov dx,0
	int 21h
	
	mov ah,3Fh
	mov cx,1
	lea dx,buffy
	mov bx,handleE
	int 21h
	jc darErrorArchivoA
	cmp ax,1
	jne cerrarArchivoA
	
ponerPointer:
	mov ah,42h
	mov bx,handleS ; Luego de leer un caracter del archivo que se quiere cifrar, pongo el pointer al final del repositorio para escribirlo ahi
	mov al,02h
	mov cx,0
	mov dx,0
	int 21h
cifrarTexto:
	mov al,byte ptr clave[si] ; Cifro el texto mediante sumarle los caracteres de la clave a los diferentes bytes del texto que se quiere cifrar hasta llegar al caracter null $.
	cmp al,'$'
	je resetearClave
	add byte ptr buffy,al
	
	mov ah,40h
	mov cx,1
	lea dx,buffy
	mov bx,handleS
	int 21h
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	inc si
	jmp leerCaracter
	jc darErrorArchivoA
resetearClave:
	mov si,0 ; Si la clave se acabo, se repite poniendo el si como 0 para empezar desde el primer byte de la clave.
	jmp cifrarTexto
cerrarArchivoA:
	mov ah,3Eh
	mov bx,handleS ; Se cierran ambos archivos, el del repositorio y el del texto que se queria cifrar.
	int 21h
	mov ah,3Eh
	mov bx,handleE
	int 21h
	jmp volverAgregarArchivoA
darErrorArchivoA:
	lea dx,msgerror ; Se da un error si el archivo no existia o era invalido.
	mov ah,9h
	int 21h
	mov ah,4ch
	int 21h
volverAgregarArchivoA:
	lea dx,barraprogreso
	mov ah,9h
	int 21h

	ret
agregarArchivoA endP

printAX proc
; imprime a la salida estándar un número que supone estar en el AX
; supone que es un número positivo y natural en 16 bits.
; lo imprime en decimal.  
    
    push AX
    push BX
    push CX
    push DX

    xor cx, cx
    mov bx, 10
ciclo1PAX: xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne ciclo1PAX
    mov ah, 02h
ciclo2PAX: pop DX
    add dl, 30h
    int 21h
    loop ciclo2PAX

    pop DX
    pop CX
    pop BX
    pop AX
    ret
printAX endP

getTamano Proc
	push dx
	push ax
	push cx
	
	mov ah,3Dh ; Se abre el archivo
	xor al,al
	lea dx,archivo
	int 21h
	jc darErrorTamano
	mov handleE,ax
	
	mov ah,42h ; Se saca el tamano ya que va a quedar en el registro ax
	mov al,2
	mov bx,handleE
	xor dx,dx
	xor cx,cx
	int 21h
	mov tamano,ax
	
	jmp volverTamano

darErrorTamano:
	lea dx,msgerror ; Si hizo carry se despliega un error
	mov ah,09h
	int 21h
volverTamano:
	lea dx,barraprogreso
	mov ah,9h
	int 21h

	pop dx
	pop ax
	pop cx

	mov ah, 3Eh ; cerrar el archivo de entrada
    mov bx, handleE
    int 21h 
	ret
getTamano endP

getTamano2 Proc
	push dx
	push ax
	push cx
	
	mov ah,3Dh ; Es el mismo procedimiento para obtener el tamano pero usa un handle diferente para que no tenga conflictos si ya se estaba usando otro handle
	xor al,al
	lea dx,archivo
	int 21h
	jc darErrorTamano2
	mov handleT,ax
	
	mov ah,42h
	mov al,2
	mov bx,handleT
	xor dx,dx
	xor cx,cx
	int 21h
	mov tamano,ax
	
	jmp volverTamano2

darErrorTamano2:
	lea dx,msgerror
	mov ah,09h
	int 21h
volverTamano2:

	pop dx
	pop ax
	pop cx

	mov ah, 3Eh ; cerrar el archivo de entrada
    mov bx, handleT
    int 21h 
	ret
getTamano2 endP

getNombreExtension Proc
	push si
	push di
	mov si,0
	mov di,0
loopNombre:
	mov al,byte ptr archivo[si] ; Se recorren los caracteres hasta llegar al punto, y lo que estaba antes del punto es el nombre
	cmp al,'.'
	je esExtension1
	mov byte ptr nombre[di], al
	inc si
	inc di
	jmp loopNombre
esExtension1:
	mov byte ptr nombre[di],'$' ; Se agrega un $ para terminar el string
	mov di,0
esExtension2:
	mov al,byte ptr archivo[si] ; Se mueven los caracteres de la extension a la variable extension
	cmp al,20h
	jl volverGetNombreExtension
	mov byte ptr extension[di],al
	inc si
	inc di
	jmp esExtension2
volverGetNombreExtension:
	mov byte ptr extension[di],'$' ; Se agrega un $ para terminar el string
	pop si
	pop di
	ret
getNombreExtension endP

crearEncabezado Proc
abrirRepositorioEncabezado1:
	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio
	int 21h
	jnc abrirRepositorioEncabezado2
	jmp darErrorArchivoA
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
abrirRepositorioEncabezado2:
	mov handleS,ax
escribirNumArchivos:
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,3 ; Se pone el pointer en el caracter del numero de archivos en el repositorio
	int 21h

	mov ah, 3Fh  ; Se lee el numero de archivos
    mov cx, 1
    lea dx,buffy
    mov bx,handleS
    int 21h
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	inc byte ptr buffy ; Se suma uno al tamano de archivos porque se metio uno, se mete en el buffer el tamano de archivos y luego se mueve a numarchivos y contador para usar como contador y para comparaciones
	mov cl,byte ptr buffy
	mov numarchivos,cl
	mov contador,cl

	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,3 ; Luego se vuelve a poner el pointer en el numero de archivos
	int 21h
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	mov ah, 40h ; Se sobreescribe el numero de archivos sumandole uno porque se acaba de agregar un archivo
    mov cx, 1
    lea dx,buffy
    mov bx, handleS
    int 21h
	
getTotalSize1:
	mov cl,numarchivos
	mov contador,cl
	mov dx,5 ; Se mueve el desplazamiento inicial para conseguir el tamano total, que es 5 para que este en el byte 6
getTotalSize2:
	cmp contador,1
	je getTotalSize3
	
	mov ah,42h ; Se pone el pointer en el byte 6
	mov bx,handleS
	mov al,00h
	mov cx,0
	int 21h

	mov ah, 3Fh  ; Se lee el caracter del tamano del archivo
    mov cx, 1
    lea dx,buffyW
    mov bx,handleS
    int 21h
	
	mov ax,buffyW
	add totalsize,ax
	dec contador
	add dx,20 ; Se agrega 20 al desplazamiento del pointer porque ahi empieza el siguiente grupo de 20 bytes del encabezado
	jmp getTotalSize2
getTotalSize3:
	mov dx,25 ; Se mueve 25 al desplazamiento y se resetea el contador
	mov cl,numarchivos
	mov contador,cl
moverCifrado:
	cmp contador,2
	je moverCifrado2
	add dx,20 ; Se suma 20 al desplazamiento
	dec contador
	jmp moverCifrado
moverCifrado2:
	mov cl,numarchivos
	mov contador,cl
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	int 21h
	
	mov ah, 3Fh ; Se leen los caracteres en el buffer por la cantidad del tamano
    mov cx,totalsize
    lea dx,buffy
    mov bx,handleS
    int 21h
	mov desplazamiento,24
sumar20:
	cmp contador,1
	je escribirTamano1
	
	add inicial,20 ; Se suma 20 por cada archivo que hay
	add desplazamiento,20
	dec contador
	jmp sumar20
escribirTamano1:
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,inicial
	int 21h
	
	mov ah, 40h
    mov cx, 1
    lea dx,tamano ; Se escribe el tamano del archivo
    mov bx, handleS
    int 21h
escribirTamano2:
	mov ah,42h
	mov bx,handleS ; Escribe nulo para seguir escribiendo el encabezado
	mov al,00h
	mov cx,0
	mov dx,inicial
	inc dx
	int 21h
	
	mov ah, 40h
    mov cx, 1
    lea dx,nulo
    mov bx, handleS
    int 21h
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,inicial
	inc dx
	inc dx
	int 21h
	
	mov ah, 40h
    mov cx, 1
    lea dx,nulo
    mov bx, handleS
    int 21h
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,inicial
	inc dx
	inc dx
	inc dx
	int 21h
	
	mov ah, 40h
    mov cx, 1
    lea dx,nulo
    mov bx, handleS
    int 21h
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,inicial
	inc dx
	inc dx
	inc dx
	inc dx
	int 21h
escribirNombreEncabezado1:
	mov ah, 40h
    mov cx,largonombre ; Ahora, por el largo del nombre del archivo, escribe el nombre del archivo
	dec cx
    lea dx,archivo
    mov bx, handleS
    int 21h
escribirNombreEncabezado2:
	mov ah, 40h
	mov cx,12
	sub cx,largonombre  ; Escribe nulo en los caracteres que faltan para que llegue a los 12 bytes
	inc cx
    lea dx,nulo
    mov bx, handleS
    int 21h
escribirDesplazamiento1:
	mov ah, 40h
	mov cx,3
    lea dx,nulo ; Se escribe nulo hasta llegar al byte del desplazamiento del archivo
    mov bx, handleS
    int 21h

	mov ah, 40h
	mov cx,1
    lea dx,desplazamiento ; Se escribe el desplazamiento inicial para llegar al archivo con el pointer
    mov bx, handleS
    int 21h
	
	cmp numarchivos,1 ; Si solo habia un archivo, ya se acaba el proceso porque no habia texto que guardar
	je cerrarRepositorioEncabezado
escribirFinalTexto:
	mov ah,42h
	mov bx,handleS ; Si habia mas de un archivo, se sigue
	mov al,01h
	mov cx,0
	mov dx,0
	int 21h
	
	mov ah, 40h
    mov cx,totalsize ; Se escribe el texto de los archivos que faltaban al final del archivo
    lea dx,buffy
    mov bx, handleS
    int 21h
	lea dx,barraprogreso
	mov ah,9h
	int 21h
cerrarRepositorioEncabezado:
	mov ah, 3Eh ; cerrar el archivo de salida
    mov bx, handleS
    int 21h 
	lea dx,barraprogreso
	mov ah,9h
	int 21h
volverCrearEncabezado:
	mov largonombre,0 ; desplegar barra de progreso y return
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	ret
crearEncabezado endP

cambiarDesplazamientos Proc
	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio
	int 21h
	mov handleS,ax
	
	mov desplazamiento,5 ; Se escribe el desplazamiento inicial 5 para luego sumarle 20 y llegar al byte del desplazamiento del primer archivo
	mov cl,numarchivos
	mov contador,cl
getDesplazamientoInicial:
	cmp contador,0
	je cicloDesplazamientos1
	
	add desplazamiento,20 ; este sera el inicio de la parte del texto cifrado
	dec contador
	jmp getDesplazamientoInicial
cicloDesplazamientos1:
	mov cl,numarchivos
	mov contador,cl ; hace loop hasta que se haya hecho para todos los archivos
	mov dx,24 ; se mueve 24 al dx para poder hacer loop sumandoele 20 porque en ese byte esta el desplazamiento de cada archivo
	mov posicion,5
cicloDesplazamientos2:
	cmp contador,0
	je volverCambiarDesplazamientos

	push dx

	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	int 21h
	
	mov ah, 40h
    mov cx,1
    lea dx,desplazamiento ; escribo el desplazamiento para cada archivo
    mov bx, handleS
    int 21h
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	mov dx,posicion
	int 21h
	
	mov ah,3Fh 
    mov cx,1
    lea dx,buffy
    mov bx,handleS
    int 21h
	
	pop dx
	add al,buffy ; le sumo el tamano de los archivos anteriores al desplazamiento asi tengo el verdadero desplazamiento
	add desplazamiento,al
	dec desplazamiento
	add dx,20
	add posicion,20
	dec contador
	jmp cicloDesplazamientos2
volverCambiarDesplazamientos:
	mov ah, 3Eh ; cerrar el archivo de salida
    mov bx, handleS
    int 21h 
	ret
cambiarDesplazamientos endP

getNumArchivos Proc
	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio
	int 21h
	mov handleS,ax
	
	mov ah,42h
	mov bx,handleS ; se mueve el pointer al numero de archivos que hay
	mov al,00h
	mov cx,0
	mov dx,3
	int 21h

	mov ah, 3Fh  ; se lee la cantidad de archivos
    mov cx, 1
    lea dx,buffy
    mov bx,handleS
    int 21h
	
	mov cl,byte ptr buffy
	mov numarchivos,cl ; se mueve a la variable numarchivos
	mov contador,cl
	
	lea dx,barraprogreso ; despliega barra de progreso
	mov ah,9h
	int 21h

volverEndGetNumArchivos:
	mov ah, 3Eh ; cerrar el archivo de salida
    mov bx, handleS
    int 21h 
	ret
getNumArchivos endP

extraerArchivoX Proc
	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio 
	int 21h 
	mov handleE,ax
	
	mov di,0
	mov si,0
	mov dx,8
	dec largonombre
	mov cx,largonombre ; Se usa el largo del nombre del archivo como contador
	mov contadorW,cx
	
	mov bl,numarchivos
	mov contador,bl
buscarArchivo:
	cmp contadorW,0
	je encontrado1

	mov ah,42h
	mov bx,handleE ; Se tiene que mover 8 desde el final del nombre del archivo en el repositorio para llegar al byte donde dice su desplazamiento
	mov al,00h
	mov cx,0
	inc dx ; pongo el primer byte con el nombre del primer archivo
	push dx
	int 21h

	
	mov ah, 3Fh  ; leemos el caracter del archivo
    mov cx, 1
    lea dx,buffy ; Se mete en el buffer
    mov bx,handleE
    int 21h
	pop dx
	
	mov al,buffy
	
	
	cmp byte ptr archivo[di],al ; Se compara el nombre ingresado de archivo y se comapra con los caracteres leidos del buffer. Si no se encuentra el archivo en el repositorio entonces se prueba con todos los archivos y si aun asi no se encontro, da error.
	jne noEncontrado
	
	dec contadorW
	inc di

	jmp buscarArchivo
noEncontrado:
	cmp contador,0
	je noEstaba

	add dx,19 ; Se agrega 19 al desplazamiento para luego usar el pointer
	dec contador
	jmp buscarArchivo
noEstaba:
	lea dx,noesta ; Si no se encontro el archivo da error y termina
	mov ah,9h
	int 21h
	jmp terminarMain
encontrado1:
	push dx
	
	mov ah, 3Ch  ; Si se encontro el archivo entonces crea un archivo con ese nombre
    lea dx, archivo
    xor cx, cx
    int 21h
	mov handleS,ax
	
	pop dx
	
	mov ax,dspz 
	sub ax,largonombre ; ese es el desplazamiento necesario para llegar al byte que dice la posicion del texto cifrado en el archivo
	add dx,ax
	
	mov ah,42h
	mov bx,handleE
	mov al,00h
	mov cx,0 ; El dx tiene el desplazamiento necesario para llegar al caracter que dice el desplazamiento para llegar al archivo
	int 21h
	
	push dx
	
	mov ah, 3Fh  ; leemos el caracter  que dice el desplazamiento para llegar a la posicion del texto cifrado
    mov cx, 1
    lea dx,buffyW
    mov bx,handleE
    int 21h
	
	mov si,0
getCharTamano:
	mov ah,42h
	mov bx,handleE ; Resto 19 para irme 19 bytes atras, asi llego al caracter que dice el tamano del archivo
	mov al,00h
	mov cx,0
	pop dx
	sub dx,19
	int 21h
	
	mov ah, 3Fh  ; leemos el caracter que dice el tamano
    mov cx, 1
    lea dx,buffyW
    mov bx,handleE
    int 21h
	
	mov ah, 3Fh 
    mov cx, 1
    lea dx,buffyW
    mov bx,handleE
    int 21h
SetPointer:
	mov ah,42h
	mov bx,handleE
	mov al,00h
	mov cx,0
	mov dx,buffyW ; Se pone el puntero
	int 21h
	
extraerTexto:	
	mov ah,3Fh
	mov cx,1
	lea dx,buffyW
	mov bx,handleE ; Se lee caracter por caracter el texto para escribirlo en el archivo creado
	int 21h
	cmp ax,1
	jne volverExtraerArchivoX
cifrarTextoExtraer:
	mov al,byte ptr clave[si]
	cmp al,'$' ; Se mueven los caracteres del texto uno por uno hasta llegar al caracter null $
	je resetearClaveExtraer
	sub byte ptr buffyW,al
	
	mov ah,40h
	mov cx,1
	lea dx,buffyW ; Se escribe caracter por caracter en el archivo creado
	mov bx,handleS
	int 21h
	
	inc si
	jmp extraerTexto
resetearClaveExtraer:
	mov si,0 ; Se resetea la clave al descifrar archivos
	jmp cifrarTextoExtraer
volverExtraerArchivoX:
	mov ah, 3Eh ; cerrar el archivo de salida
    mov bx, handleE
    int 21h 
	
	mov ah, 3Eh ; cerrar el archivo de salida
    mov bx, handleS
    int 21h 
	
	ret
extraerArchivoX endP

CamLin proc
; despliega a la salida estandar un Cambio de Línea

  push ax
  push dx

  mov dl, 0Dh
  mov ah, 02h
  int 21h

  mov dl, 0Ah
  mov ah, 02h
  int 21h


  pop dx
  pop ax
  ret

CamLin endP

getListado Proc
	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio ; 
	int 21h
	mov handleE,ax
	
	mov cl,numarchivos ; Se usa el numero de archivos del repositorio como contador
	mov contador,cl
	
	mov dx,9 ; Se mueve 9 al dx para usar como desplazamiento ya que ahi esta el nombre del primer archivo
	push dx ; Se guarda dx
getPrimerListado:
	mov ah,42h
	mov bx,handleE ; Se pone el puntero en el byte del nombre del primer archivo
	mov al,00h
	mov cx,0
	int 21h
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h

	mov di,0
cicloListado:
	mov ah,3Fh ; Se va leyendo los caracteres del nombre hasta llegar a un caracter null
	mov cx,1
	lea dx,buffy
	mov bx,handleE
	int 21h
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	cmp byte ptr buffy,0
	je listarArchivo
	
	mov al,buffy
	mov byte ptr archivo[di],al
	inc di
	
	jmp cicloListado
listarArchivo:
	mov byte ptr archivo[di],'$' ; Se mueve el nombre del archivo a la variable archivo y se le agrega un $ al nombre del archivo para terminar el string
	call CamLin ; Despliega un cambio de linea
	lea dx,archivo ; Despliega el nombre del archivo
	mov ah,9h
	int 21h
	call getTamano2 ; Consigue el tamano del archivo para desplegarlo luego
	
	lea dx,espacio
	mov ah,9h
	int 21h
	
	lea dx,cantidad
	mov ah,9h
	int 21h
	mov ax,tamano ; Despliega el tamano del archivo
	call printAX
	call CamLin
	
	dec contador
	cmp contador,0
	je volverGetListado
	
	mov archivo,0
	mov buffy,0
	pop dx
	add dx,20
	jmp getPrimerListado ; Hace esto para todos los archivos del repositorio
volverGetListado:
	call CamLin ; Cuando ya se salio del ciclo, dice la cantidad de archivos que hay
	mov al, numarchivos
	call printAX
	
	lea dx,msgnumfiles
	mov ah,9h
	int 21h

	mov ah, 3Eh ; cerrar el archivo de salida
    mov bx, handleE
    int 21h 

	ret
getListado endP

borrarArchivoB Proc
	mov ah,3Dh ; abrir archivo de salida (el repositorio)
	mov al,2
	lea dx,repositorio
	int 21h 
	mov handleS,ax
	
	mov di,0
	mov si,0
	mov dx,8 ; Se mueve el desplazamiento a 8 para luego incrementarle 1 para que se haga 9 y asi llegar al primer caracter del nombre del archivo
	dec largonombre
	mov cx,largonombre
	mov contadorW,cx
	
	
	mov bl,numarchivos
	mov contador,bl
	mov bl,contador
buscarArchivoBorrar:
	cmp contadorW,0
	je encontrado1Borrar

	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	inc dx ; pongo el primer byte con el nombre del primer archivo
	push dx ; guardo el valor del desplazamiento
	int 21h
	
	mov ah, 3Fh  ; leemos el caracter del archivo
    mov cx, 1
    lea dx,buffy
    mov bx,handleS
    int 21h
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	pop dx ; restauro el dx con el valor del desplazamiento
	
	mov al,buffy
	cmp byte ptr archivo[di],al ; comparo los caracteres del archivo solicitado con los del repositorio para ver si el archivo existe en el repositorio o no
	jne noEncontradoBorrar
	
	dec contadorW
	inc di
	
	jmp buscarArchivoBorrar
noEncontradoBorrar:
	cmp contador,0
	je noEstabaBorrar

	add dx,19
	dec contador
	jmp buscarArchivoBorrar ; si no lo encontro de primero, busca hasta que ya no hayan archivos que buscar
noEstabaBorrar:
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	lea dx,noesta ; despliega un error diciendo que el archivo no existe y termina
	mov ah,9h
	int 21h
	jmp terminarMain
encontrado1Borrar:
	push dx
	pop dx
	
	mov ax,dspz
	sub ax,largonombre ; ese es el desplazamiento necesario para llegar al byte que dice la posicion del texto cifrado en el archivo
	add dx,ax
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	int 21h
	
	mov ah, 3Fh  ; leemos el caracter  que dice el desplazamiento para llegar a la posicion del texto cifrado
    mov cx, 1
    lea dx,buffyW
    mov bx,handleS
    int 21h
	
	mov ax,buffyW
	mov dspz,ax
	
	mov dx,buffyW
	sub dx,21
	
	mov ah,42h
	mov bx,handleS
	mov al,00h
	mov cx,0
	int 21h
	
	mov ah, 3Fh  ; lee el caracter del tamano del archivo
    mov cx, 1
    lea dx,tamano
    mov bx,handleS
    int 21h
	
	mov ah,40h
	mov cx,20 ; se escriben 20 caracteres null para asi borrar todo el encabezado para ese archivo
	lea dx,nulo
	mov bx,handleS
	int 21h
borrarTexto:
	mov ah,40h
	mov cx,tamano ; borra el texto escribiendo null por la cantidad de caracteres del archivo
	lea dx,nulo
	mov bx,handleS
	int 21h
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
volverBorrarArchivoB:
	mov ah, 3Eh ; cerrar el archivo de salida
    mov bx, handleS
    int 21h 
	
	lea dx,barraprogreso
	mov ah,9h
	int 21h
	
	ret
borrarArchivoB endP

getTamanoBorrar Proc

	ret
getTamanoBorrar endP

main:

	mov ax,ds ; Se mueve ds a es
	mov es,ax

	mov ax,data ; Inicializa el data segment mandandolo al ds register
	mov ds,ax

	mov ax,pila ; Inicializa la pila mandandola al ss register
	mov ss,ax
	
	lea dx,acercade ; Despliega el acerca de
	mov ah,9h
	int 21h

	mov si,81h
getLetra1:
	mov al,byte ptr es:[si] ; Se recorren los espacios hasta que se llegue a un caracter que no sea un espacio, lo que significa que es una letra
	cmp al,' '
	jne getLetra2
	inc si
	jmp getLetra1
getLetra2:
	inc si
	mov al,byte ptr es:[si] ; Se mueve la letra a la variable letra
	mov letra,al
compararLetra:
	cmp letra,'H' ; Si la letra que se escribio es H, o no se escribio nada, entonces muestra la ayuda
	je mostrarAyuda
	cmp letra,20h
	jl mostrarAyuda
	
	cmp letra,'C' ; Si la letra es C entonces crea un repositorio
	je crearRepositorio
	
	cmp letra,'A' ; Si la letra es A entonces agrega un archivo al repositorio
	je agregarArchivo
	
	cmp letra,'X' ; Si la letra es X entonces extrae un archivo del repositorio
	je extraerArchivo
	
	cmp letra,'B' ; Si la letra es B entonces borra un archivo del repositorio
	je borrarArchivo
	
	cmp letra,'L' ; Si la letra es L entonces hace un listado de los archivos del repositorio
	je listadoArchivo1
	
	jmp darError ; Si no se escribio ninguna de las letras aceptadas, entonces da error de que la letra es invalida

mostrarAyuda:                  ; Todos estos procedimientos simplemente llaman a la rutina que se escogio dependiendo de la letra escrita, y luego del return saltan al procedimiento de terminar el programa
	call mostrarAyudaH ; Muestra la ayuda
	jmp terminarMain
	
listadoArchivo1:
	jmp listadoArchivo2 ; Hace un salto al proceso de listado de archivos

crearRepositorio:
	call getRepositorio ; Obtiene el repositorio
	call revisarExisteRep ; Revisa si el repositorio ya existe
	call crearRepositorioC ; Si no existem, lo crea
	call CamLin
	lea dx,msgcreado ; Despliega el mensaje de que se creo el repositorio
	mov ah,9h
	int 21h
	jmp terminarMain

agregarArchivo:
	push si
	push di
	push dx
	call getRepositorio ; Obtiene el repositorio
	call revisarFormato ; Revisa si el formato del repositorio es valido
	call getArchivo ; Obtiene el archivo
	call getClave ; Obtiene la clave
	call getTamano ; Obtiene el tamano del archivo
	call getNombreExtension ; Obtiene el nombre y la extension del archivo
	call crearEncabezado ; luego de esta ocupo hacer una rutina que cambia los desplazamientos porque se buggea si no
	pop si
	pop di
	pop dx
	call cambiarDesplazamientos ; Actualiza los desplazamientos de los archivos del repositorio
	call agregarArchivoA ; luego de esta ocupo hacer una rutina que cambia los desplazamientos porque se buggea si no
	call CamLin
	lea dx,msgcreado2 ; Despliega que se creo el archivo
	mov ah,9h
	int 21h
	jmp terminarMain

extraerArchivo:
	call getRepositorio ; Se obtiene el repositorio
	call revisarFormato ; Revisa si el formato del repositorio es valido
	call getArchivo ; Obtiene el archivo
	call revisarExisteFile ; Revisa si el archivo existe
	call getClave ; Obtiene la clave
	call getNumArchivos ; Consigue el numero de archivos
	call extraerArchivoX ; Extrae el texto y lo descifra
	call CamLin
	lea dx,msgextraido ; Despliega que se extrajo el archivo
	mov ah,9h
	int 21h
	jmp terminarMain

borrarArchivo:
	call getRepositorio ; Se obtiene el repositorio
	call revisarFormato ; Revisa si el formato del repositorio es valido
	call getArchivo ; Obtiene el archivo
	call getNumArchivos ; Consigue el numero de archivos
	call borrarArchivoB ; Borra el archivo del repositorio
	call CamLin
	lea dx,msgborrado ; Despliega que se borro el archivo
	mov ah,9h
	int 21h
	jmp terminarMain

listadoArchivo2:
	call getRepositorio ; Obtiene el repositorio
	call revisarFormato ; Revisa si el formato del repositorio es valido
	call getNumArchivos ; Obtiene la cantidad de archivos
	
	cmp numarchivos,0 ; Si no tiene archivos, dice que no hay archivos
	je noHayArchivos
	
	call getListado ; Muestra el listado y termina
	jmp terminarMain
noHayArchivos:
	call CamLin
	lea dx,vacio
	mov ah,9h
	int 21h
	jmp terminarMain

darError:
	lea dx,errorletra ; Si no se escogio ninguna letra de opcion valida, se despliega un error diciendo eso y luego termina
	mov ah,9h
	int 21h
terminarMain:
	mov ah,4ch ; Hace interrupt para hacer exit hacia DOS para terminar el programa
	int 21h

code ends

end main