.org 0x800
.data
.comm carrello, 512
carrello_idx: .word 0
prezzi: .fill 512, 2, 8

lettore_ivn: .byte 1
lettore_reg: .word 1

pulsante_ivn: .byte 2

stampante_ivn: .byte 3
stampante_reg: .word 1

.text
main:
	sti
	call .driver_lettore_main
	call .driver_lettore_main
	call .driver_pulsante_main
	hlt

.driver_lettore_main:
	cli
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %r8

	xorq %rax, %rax
	#legge indice articolo a 16 bit
	inw $lettore_reg, %ax
	movq $prezzi, %r8
	# preleva dall'array dei prezzi l'elemento in posizione RAX e lo si mette dentro RBX 
	movw (%r8, %rax, 2), %bx
	# si prende l'indice del carrello
	movw carrello_idx, %cx
	movq $carrello, %r8
	# si aggiunge un elemento al carrello
	movw %bx, (%r8, %rcx, 2)
	addw $1, %cx
	movw %cx, carrello_idx

	popq %r8
	popq %rcx
	popq %rbx	
	popq %rax
	ret

.driver_pulsante_main:
	cli
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %r8
	pushq %r9

	xorq %rcx, %rcx
	xorq %rbx, %rbx
	movq $carrello, %r8
	movw carrello_idx, %r9w
	sti
.driver_pulsante_loop:
	movw (%r8, %rcx, 2), %ax
	addw %ax, %bx 
	outw %ax, $stampante_reg
	movb $1, %al
	outb %al, $stampante_reg
.driver_pulsante_loop_bw:
	inb $stampante_reg, %al
	btb $0, %al
	jnc .driver_pulsante_loop_bw

	addw $1, %cx
	cmpw %cx, %r9w
	jnz .driver_pulsante_loop

	movw %bx, %ax
	outw %ax, $stampante_reg
	movb $1, %al
	outb %al, $stampante_reg
.driver_pulsante_bw:
	inb $stampante_reg, %al
	btb $0, %al
	jnc .driver_pulsante_bw
	
	popq %r9
	popq %r8
	popq %rcx
	popq %rbx	
	popq %rax
	ret