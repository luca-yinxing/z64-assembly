.org 0x800
.data
.equ size_prezzi, 512
.comm prezzi, size_prezzi*2

.equ size_carrello, 512
.comm carrello, size_carrello*2

index: .quad 0

.equ reg_lettore, 0x0001
.equ reg_stampante_buffer, 0x0002
.equ reg_stampante_status, 0x0003
.text
main:
	sti
	hlt

# LETTORE
.driver 1
	cli
	pushq %rax
	pushq %rbx
	
	inw $reg_lettore, %ax # non funziona operando implicito
	outb %ax, $reg_lettore
	movzwq %ax, %rax
	movw prezzi(,%rax, 2), %bx
	
	movq $index, %rax
	movw %bx, carrello(, %rax, 2)

	popq %rbx
	popq %rax
	iret
#PULSANTE
.driver 2
	cli
	pushq %rcx
	pushq %rbx
	pushq %rax

	xorq %rcx, %rcx
	xorq %rbx, %rbx
	xorq %rax, %rax
.pulsante_loop:
	movw carrello(, %rcx, 2), %ax
	addq %rax, %rbx

	outw %ax, $reg_stampante_buffer
	outb %al, $reg_stampante_status
.pulsante_loop_bw:
	inb $reg_stampante_status, %al
	btb $0, %al
	jc .pulsante_loop_bw

	addq $1, %rcx
	cmpq index, %rcx
	jnz .pulsante_loop

	movw %bx, %ax
	outw %ax, $reg_stampante_buffer
	outb %al, $reg_stampante_status
.pulsante_bw:
	inb $reg_stampante_status, %al
	btb $0, %al
	jc .pulsante_bw

	movq $0, index
	
	popq %rax
	popq %rbx
	popq %rcx
	iret
