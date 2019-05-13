.text
.align 2
.global main
.type main, %function

main:
	bl getGpioAddress
	
	mov r0, #17
	mov r1, #0
	bl SetGpioFunction
	
	mov r0, #21
	mov r1, #1
	bl SetGpioFunction
	mov r0, #22
	mov r1, #1
	bl SetGpioFunction
	mov r0, #23
	mov r1, #1
	bl SetGpioFunction
	
loop:
	@Apagar GPIO 17
	mov r0,#17
	mov r1,#0
	bl SetGpio

	@loop:
	@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo 
	@se lee en la direccion 0x3F200034 para los GPIO 0-31
	ldr r6, =myloc
 	ldr r0, [r6]		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34]	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#21
	and r5,r7 		@se revisa el bit 21 (puerto de entrada)

	@Si el boton esta en alto (1), fue presionado y enciende GPIO 15
	teq r5,#0 			@es lo mismo que un CMP
	movne r0,#17		@instrucciones para encender GPIO 15
	movne r1,#1
	blne SetGpio
	blne wait
		
	b loop
	
notEqual:

	mov r0, #21
	mov r1, #1
	bl getGpio
	cmp r0, #1
	beq turn1
	mov r0, #22
	bl getGpio
	cmp r0, #1
	beq turn2
	mov r0, #23
	bl getGpio
	cmp r0, #1
	beq turn3
	
turn1:
	mov r0, #21
	mov r1, #1
	bl setGpio
	
	mov r0, #22
	mov r1, #0
	bl setGpio
	mov r0, #23
	bl setGpio
	b loop
	
turn2:
	mov r0, #22
	mov r1, #1
	bl setGpio
	
	mov r0, #21
	and r1, #0
	bl setGpio
	mov r0, #23
	bl setGpio
	b loop
	
turn3:
	mov r0, #23
	mov r1, #1
	bl setGpio
	
	mov r0, #21
	and r1, #0
	bl setGpio
	mov r0, #22
	bl SetGpioFunction
	b loop
	
	
wait:
	mov r0, #0x4000000 @ big number
sleepLoop:
	subs r0,#1
	bne sleepLoop @ loop delay
	mov pc,lr
	
.data
.align 2

