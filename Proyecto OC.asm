  # .data se usa para declarar los datos que serán usados a lo largo del programa. En este caso se usaron para definir los mensajes a imprimir.
  .data
  # Definimos strings para el menú y mensajes
  # .ascizz es para declarar una cadena de texto terminada con un carácter nulo.
menu:           .asciiz "\nMenú Interactivo:\n1. Convertir Decimal a Binario\n2. Convertir Binario a Decimal\n3. Generar un número aleatorio\n4. Salir\n\nSeleccione una opción: "
ingresarDec:    .asciiz "\nIngrese un número decimal: "
ingresarBin:    .asciiz "\nIngrese un número binario de 8 bits: "
errorBin:       .asciiz "\nError: El número binario debe contener solo '0' o '1'.\n"
decimalOut:     .asciiz "Decimal: "
binarioOut:     .asciiz "Binario: "
salida:         .asciiz "\nSaliendo del programa.\n"
aleatorio:      .asciiz "\nNúmero aleatorio: "
newLine:        .asciiz "\n"
newSection:     .asciiz "\n---------------------------------\n"
  # buffer quiere que el usuario digite 1 y 0's hasta llegar a un número en binario de 8 dígitos para proceder a calcular...
buffer:         .space 9 # Espacio para 8 caracteres + terminador nulo

  # .text no es necesario
  .text

  # .globl es una etiqueta global para poder recurrir a ella en cualquier parte del programa
  .globl main

main:

  li $v0, 4
  la $a0, newLine
  syscall
  
  li $v0, 4
  la $a0, newSection
  syscall

  # Imprimir el menú
  # Se usa li v0, 4 para determinar el código de servicio 4, el cual significa Imprimir string.
  li $v0, 4                   # Código de servicio 4: Imprimir string
  la $a0, menu                # Cargar dirección del menú
  # syscall llama al sistema para imprimir lo que esté en a0
  syscall                     

  # Leer opción del usuario
  # Cambiamos al código de servicio 5 para LEER un entero.
  li $v0, 5                   # Código de servicio 5: Leer un entero
  # syscall espera un input para ponerlo en v0
  syscall
  # El input del usuario lo movemos.
  move $t0, $v0               # Guardar la opción en $t0

  # Verificar la opción y saltar a la función adecuada
  beq $t0, 1, decimalToBin
  beq $t0, 2, binToDecimal
  beq $t0, 3, generateRand
  beq $t0, 4, exit
  j main                      # Opción no válida, volver al menú

  # Convertir Decimal a Binario
decimalToBin:

  li $v0, 4
  la $a0, newSection
  syscall

  # Imprimir mensaje para ingresar un número decimal
  li $v0, 4
  la $a0, ingresarDec
  syscall

  # Leer número decimal del usuario
  li $v0, 5
  syscall
  move $t1, $v0               # Guardar número decimal en $t1

  # Imprimir "Binario: "
  li $v0, 4
  la $a0, binarioOut
  syscall

  # Inicializar registros
  li $t2, 128                 # $t2 = 2^7 (128), usado para verificar cada bit de 8 bits

convertToBinaryLoop:
  beqz $t2, endConversion     # Si $t2 es 0, hemos terminado

  # Verificar si el bit correspondiente en $t1 es 1 o 0
  and $t3, $t1, $t2           # $t3 = $t1 & $t2 (verificar si el bit está encendido)
  beqz $t3, printZero         # Si $t3 es 0, imprimir 0
  li $v0, 11                  # Código de servicio 11: Imprimir carácter
  li $a0, '1'                 # Imprimir '1'
  syscall
  j nextBit

printZero:
  li $v0, 11                  # Código de servicio 11: Imprimir carácter
  li $a0, '0'                 # Imprimir '0'
  syscall

nextBit:
  srl $t2, $t2, 1             # Desplazar $t2 a la derecha (dividir por 2)
  j convertToBinaryLoop       # Repetir el bucle

endConversion:
  j main                      # Volver al menú principal

  # Convertir Binario a Decimal
binToDecimal:

  li $v0, 4
  la $a0, newSection
  syscall

  # Imprimir mensaje para ingresar un número binario de 8 bits
  li $v0, 4
  la $a0, ingresarBin
  syscall

  # Leer la cadena binaria de 8 caracteres
  li $v0, 8
  la $a0, buffer
  li $a1, 9
  syscall

  li $v0, 4
  la $a0, newLine
  syscall

  li $t0, 0                   # Inicializar el resultado decimal
  li $t1, 0                   # Índice de la cadena

convertLoopBinToDec:
  lb $t2, buffer($t1)
  beqz $t2, endBinToDec
  li $t3, '0'
  sub $t2, $t2, $t3           # Convertir '0' o '1' a número
  sll $t0, $t0, 1             # Desplazar decimal a la izquierda
  or $t0, $t0, $t2            # Agregar el bit actual
  addi $t1, $t1, 1
  j convertLoopBinToDec

endBinToDec:
  # Imprimir el resultado decimal
  li $v0, 4
  la $a0, decimalOut
  syscall

  li $v0, 1
  move $a0, $t0
  syscall
  j main

  # Generar Número Aleatorio
generateRand:
  # Simular la generación de un número aleatorio (usaremos un valor fijo para simplicidad)
  li $t0, 25                  # Usar un valor fijo como ejemplo de número aleatorio

  li $v0, 4
  la $a0, newSection
  syscall

  # Imprimir "Número aleatorio: "
  li $v0, 4
  la $a0, aleatorio
  syscall

  # Imprimir el número aleatorio en formato decimal
  li $v0, 1
  move $a0, $t0
  syscall

  li $v0, 4
  la $a0, newLine
  syscall


  # Llamar a la función decimalToBinRand para imprimir el número en binario
  jal decimalToBinRand        # Llamar a la función para convertir y mostrar en binario

  j main                      # Volver al menú principal

decimalToBinRand:
  # Imprimir "Binario: "
  li $v0, 4
  la $a0, binarioOut
  syscall

  # Inicializar registros
  move $t1, $t0               # Usar el número aleatorio en $t0 y copiarlo a $t1
  li $t2, 128                 # $t2 = 2^7 (128), usado para verificar cada bit de 8 bits

convertToBinaryLoopRand:
  beqz $t2, endConversionRand # Si $t2 es 0, hemos terminado

  # Verificar si el bit correspondiente en $t1 es 1 o 0
  and $t3, $t1, $t2           # $t3 = $t1 & $t2 (verificar si el bit está encendido)
  beqz $t3, printZeroRand     # Si $t3 es 0, imprimir 0
  li $v0, 11                  # Código de servicio 11: Imprimir carácter
  li $a0, '1'                 # Imprimir '1'
  syscall
  j nextBitRand

printZeroRand:
  li $v0, 11                  # Código de servicio 11: Imprimir carácter
  li $a0, '0'                 # Imprimir '0'
  syscall

nextBitRand:
  srl $t2, $t2, 1             # Desplazar $t2 a la derecha (dividir por 2)
  j convertToBinaryLoopRand   # Repetir el bucle

endConversionRand:
  jr $ra                      # Volver a la función que llamó



  # Salir del programa
exit:
  li $v0, 4
  la $a0, salida
  syscall
  li $v0, 10                  # Código de servicio 10: Salir
  syscall
