# JUEGO ESQUIVA MINAS ASSEMBLER PARA MIPS 32 BITS EN UN BITMAP DE 16 BITS.

# DESARROLADO PARA LA CLASE DE MAQUINAS DIGITALES 2020-3 PONTIFICIA UNIVERSIDAD JAVERIANA BOGOTA D.C.
# PROFESOR RESPONSABLE:ING. DEIVY JOHNATAN MAYORQUIN BEJARANO.

# ESTUDIANTES AUTORES: DIANA SOFIA CARRILLO GÓMEZ & PAULA VALENTINA LOPEZ CUBILLOS & ALEJANDRO SACRISTÁN LEAL.

# Registers que no se pueden usar:
#$s1(COLOR), $s2(X), $s3(Y), $t0(VECTOR X), $t1(DIR_BASE), $t2 (VECTOR Y), $t3 (TamaÃ±o Array).
 

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# VALORES CONSTANTES PARA EL PROGRAMA.

.eqv DIR_BASE		0x10000000
.eqv AZUL		0x00A2F5F5
.eqv ROJO		0x00FF0000
.eqv VERDE		0x0075FA66
.eqv AMARILLO		0x00E8F606
.eqv NEGRO		0x00000000
.eqv BLANCO		0x00FFFFFF
.eqv ROSADITO		0X00F1C2EF
.eqv a			97
.eqv s			115
.eqv d			100
.eqv w 			119

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
    .data
    
# MENSAJES PARA INTERACTUAR CON EL USUARIO
mensaje_Cero:       	.asciiz "\nBienvenida, para Iniciar Elige el Nivel "
mensaje_Uno:        	.asciiz "\nFacil -> 1"
mensaje_Dos:       	.asciiz "\nDificil -> 2\n"
mensajeReInicio:	.asciiz "\n¿Deseas Jugar otra vez?\n Digita 1 -> SI\n Digita 2 -> NO\n"
mensajeGameOver:	.asciiz "\nGAME OVER"
mensajeGameWin:		.asciiz "\nHAS GANADO"

# MAPA FACIL DE MINAS
vectorFacilX: 			.word 10
					.word 7
 					.word 4
 					.word 14
					.word 11
					.word 8
					.word 5
					.word 2
					.word 12
					.word 9
					.word 6
					.word 3
					.word 0
					.word 13
					.word 10
					.word 8


vectorFacilY: 			.word 1
 					.word 2
					.word 3
					.word 4
					.word 5
					.word 6
					.word 7
					.word 8
					.word 9
					.word 10
					.word 11
					.word 12
					.word 13
					.word 13
					.word 14
					.word 15
			
# MAPA DIFICIL DE MINAS			
vectorDificilX:			.word 7
					.word 14
					.word 5
 					.word 10
 					.word 1
					.word 15
					.word 6
					.word 13
					.word 11
					.word 2
					.word 9
					.word 0
					.word 7
					.word 14
					.word 5
					.word 12
					.word 3
					.word 10
					.word 1
 					.word 8
 					.word 15
					.word 6
					.word 13
					.word 4
					.word 11
					.word 2
					.word 9
					.word 0
					.word 7
					.word 14
					.word 5
					.word 12
			
vectorDificilY: 		.word 0
					.word 0
					.word 1
 					.word 1
 					.word 3
					.word 3
					.word 4
					.word 4
					.word 5
					.word 6
					.word 6
					.word 7
					.word 7
					.word 7
					.word 8
					.word 8
					.word 9
					.word 9
					.word 10
 					.word 10
 					.word 10
					.word 11
					.word 11
					.word 12
					.word 12
					.word 13
					.word 13
					.word 14
					.word 14
					.word 14
					.word 15
					.word 15

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
    .text
main:
	# PINTA MAPA DE BITS DE BLANCO
	li $s1, BLANCO
	jal BorrarDisplay
	
	# PINTA MENU
	jal menu
	
	# BUCLE RESPUESTA DEL MENU
	li $v0, 5
	syscall
	add $s0, $v0, $zero
	beq $s0, 1, modoFacil
	beq $s0, 2, modoDificil	
	j main
	
	
end:
	# FIN DEL PROGRAMA
	li $s1, BLANCO
	jal BorrarDisplay
	li $v0, 10
	syscall
    
# - - - - - - - - - - - - - - FUNCIONES - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#

pisaMina:

	# BUCLE QUE CONSTANTEMENTE EVALUA SI PISA MINA EN MAPA FACIL
	la $t4, 0
	add $t8, $t0, $zero
	add $t9, $t2, $zero
	add $t9, $t9, -4
	checkX:
	lw $s6, 0($t8)
	add $t4, $t4, 1	
	beq $t4, $t3, continuar
	add $t8, $t8, 4
	add $t9, $t9, 4
	bne $s6, $s2,checkX
	j checkY
	
	checkY:
	lw $s7, 0($t9)
	beq $s7, $s3,gameOver
	j checkX

 	continuar:
	li $s1, ROSADITO
	jal pintarPunto
	j puntito

gameOver:
	# PINTA EL MAPA DE MINAS FACIL
	li $t5, 2
	j pintarMapaMina
	
	# MENSAJE GAME OVER
	MensajeGameOver:
	li $v0, 4
   	la $a0, mensajeGameOver
   	syscall
   	j MensajeReInicio
   	
   	# ¿QUIERES JUGAR OTRA VEZ?
   	MensajeReInicio:
   	li $v0, 4
   	la $a0, mensajeReInicio
   	syscall
   	
   	# RECIBE RESPUESTA DE LA PREGUNTA
   	li $v0, 5
	syscall
	add $s0, $v0, $zero
	beq $s0, 1, main
	beq $s0, 2, end
	j MensajeReInicio

movimiento:

	# REPRESENTACION DEL PERSONAJE CUANDO SE MUEVE POR EL TABLERO
	li $s1, NEGRO
	jal BorrarDisplay
	
	li $s2, 0				# X
	li $s3, 0				# Y
	li $s1, ROSADITO
	jal pintarPunto
	
puntito:
	# BUCLE QUE ESTA CONSTANTEMENTE RECIBIENDO TECLAS DE NAVEGACION
	li $v0, 12
	syscall
	add $s0, $v0, $zero
	beq $s0, w,moverArriba			# w
	beq $s0, a,moverIzquierda		# a
	beq $s0, d,moverDerecha			# d
	beq $s0, s,moverAbajo			# s
	
	j puntito

inicio:	
	li $t5, 1
	j pintarMapaMina
	
pintarMapaMina:					# X*4 + Y*(4)(16)
	li $s1, ROJO
	li $t1, DIR_BASE

	la $t4, 0
	add $t8, $t0, $zero
	add $t9, $t2, $zero
	
	pintar:
	lw $s2, 0($t8)
	lw $s3, 0($t9)
	add $t4, $t4, 1
	beq $t4, $t3, inicioOGO
	jal pintarPunto
	add $t8, $t8, 4
	add $t9, $t9, 4
	j pintar
	
inicioOGO:  #inicio o game over
	beq $t5, 1, esperar
	j MensajeGameOver
	
esperar:
	# TIEMPO DE ESPERA 2 SEGUNDOS
	li $v0, 32
	li $a0, 2000
	syscall	
	j movimiento

menu:   # MENU PARA INICIAR EL JUEGO CON DIFICULTAD
	li $v0, 4
	la $a0, mensaje_Cero
   	syscall
    
	la $a0, mensaje_Uno
	syscall

	la $a0, mensaje_Dos
	syscall
    
	jr $ra
    
modoFacil:
	la $t0, vectorFacilX
	la $t2, vectorFacilY
	la $t3, 17
	j inicio
	
modoDificil:
	la $t0, vectorDificilX
	la $t2, vectorDificilY
	la $t3, 33
	j inicio

checkVictoria:
	bne $s2, 15, pisaMina
	bne $s3, 15, pisaMina
	
	j victoria

victoria:
	#PRADERA
	li $s1, VERDE
	jal BorrarDisplay
	
	li $s1, AZUL
	jal BorrarDisplayMitad
	
	li $s0, DIR_BASE
	li $s1, AZUL
	sw $s1, 0($s0)
	
	li $s1 BLANCO
	add $s2, $s0, 68	
	sw $s1, 0($s2)
	
	li $s1 BLANCO
	add $s2, $s0, 72	
	sw $s1, 0($s2)
	
	li $s1 BLANCO
	add $s2, $s0, 128	
	sw $s1, 0($s2)
	
	li $s1 BLANCO
	add $s2, $s0, 132	
	sw $s1, 0($s2)
	
	li $s1 BLANCO
	add $s2, $s0, 136	
	sw $s1, 0($s2)
	
	li $s1 BLANCO
	add $s2, $s0, 140	
	sw $s1, 0($s2)
	
	li $s1 BLANCO
	add $s2, $s0, 196	
	sw $s1, 0($s2)
	
	li $s1 BLANCO
	add $s2, $s0, 200	
	sw $s1, 0($s2)
	
	li $s1 AMARILLO
	add $s2, $s0, 48	
	sw $s1, 0($s2)
	
	li $s1 AMARILLO
	add $s2, $s0, 56	
	sw $s1, 0($s2)
	li $s1 AMARILLO
	sw $s1, 60($s0)
	
	li $s1 AMARILLO
	add $s2, $s0, 120	
	sw $s1, 0($s2)
	
	li $s1 AMARILLO
	add $s2, $s0, 124	
	sw $s1, 0($s2)
	
	li $s1 AMARILLO
	add $s2, $s0, 240	
	sw $s1, 0($s2)
	
	li $s1 AMARILLO
	add $s2, $s0, 252	
	sw $s1, 0($s2)
	
	# MENSAJE GAME WIN
	li $v0, 4
   	la $a0, mensajeGameWin
   	syscall
	
	# MENU PARA VOLVER A JUGAR
	j MensajeReInicio
	
moverArriba:
	beq $s3, 0, puntito
	li $s1, BLANCO
	jal pintarPunto
	add $s3, $s3, -1
	j checkVictoria

moverAbajo:
	beq $s3, 15, puntito
	li $s1, BLANCO
	jal pintarPunto
	add $s3, $s3, 1
	j checkVictoria
	
moverDerecha:
	beq $s2, 15, puntito
	li $s1, BLANCO
	jal pintarPunto
	add $s2, $s2, 1
	j checkVictoria

moverIzquierda:
	beq $s2, 0, puntito
	li $s1, BLANCO
	jal pintarPunto
	add $s2, $s2, -1
	j checkVictoria
	
# Pinta un punto en la coordenada X, Y, de un color determinado
# s2 = coordenada X
# s3 = coordenada Y
# s1 = color
pintarPunto:
	li $t1, DIR_BASE
	sll $s4, $s2, 2				# x = x << 2; //x = x*4;
	sll $s5, $s3, 6				# y = y << 6; //y = y*64;
	add $t1, $t1, $s4			# DIR_BASE + x*4
	add $t1, $t1, $s5			# DIR_BASE + x*4 + y*64
	sw $s1, 0($t1)				# Pintar en la posiciÃ³n calculada
	jr $ra					# Retornar	
	
BorrarDisplay:
	li $t1, DIR_BASE
	li $t5, 0				# Contador
	
 buclePintarPantalla:				# for(i = 0, i < 1020, i += 4)
	sw $s1, 0($t1)
	add $t5, $t5, 4				# t2 = t2 + 4
	add $t1, $t1, 4				# t1 = t1 + 4
	ble $t5, 1020, buclePintarPantalla
	jr $ra

# PINTA PRADERA
BorrarDisplayMitad:
	li $t1, DIR_BASE
	li $t5, 0				# Contador
	
 buclePintarPantallaMitad:			# for(i = 0, i < 510, i += 4)
	sw $s1, 0($t1)
	add $t5, $t5, 4				# t2 = t2 + 4
	add $t1, $t1, 4				# t1 = t1 + 4
	ble $t5, 508, buclePintarPantallaMitad
	jr $ra 
	
