.org 0x800
.data
monete_disponibili: .quad 1024
.comm tiri, 10
index: .byte 0

.equ addr_bilanciere, 0x0001
.equ addr_braccio_int, 0x0002
.equ addr_braccio_num, 0x0003
.equ addr_braccio_can, 0x0004
.equ addr_schermo, 0x0005

.equ val_strike, 20
.equ val_spare, 10
.equ val_max, 10

.equ tiri_max, 10
.text
main:
.main_loop:
.game_loop:
	call game_reset
	hlt
	hlt
	call update_schermo
	cmpb $tiri_max, index
	jnz .game_loop
	jmp .main_loop
game_reset:
	pushq %rax

	movb $val_max, %al 
	outb %al, $addr_braccio_num
.bw:
	inb $addr_braccio_num, %al
	cmpb $val_max, %al
	jnz .bw
	
	sti
	
	popq %rax
	ret

update_schermo:
	pushq %rax
	pushq %rbx
	pushq %rcx
	xorq %rax, %rax
	movb index, %bl
	xorq %rcx, %rcx
.update_schermo_loop:
	addb tiri(, %rcx, 1), %al
	addb $1, %cl
	cmpb %bl, %cl
	jnz .update_schermo_loop
	inb %al, $addr_schermo
	popq %rcx
	popq %rbx
	popq %rax
	ret
# BILANCIERE
.driver 1
	pushq %rax
	outb %al, $addr_bilanciere
	outb %al, $addr_braccio_can
	iret
	
# BRACCIO
.driver 2
	pushb %al
	pushq %rcx
	
	inb $addr_braccio_num, %al
	
	xorq %rcx, %rcx
	movb index, %cl

	cmpb $0, %al
	jnz .braccio_else_1
	movb $val_strike, tiri(, %rcx, 1)
	jmp .braccio_endif
.braccio_else_1:
	cmpb $1, %al
	jnz .braccio_else_2
	movb $val_spare, tiri(, %rcx, 1)
	jmp .braccio_endif
.braccio_else_2:
	subb $val_max, %al
	movb %al, tiri(, %rcx, 1)
.braccio_endif:
	addq $1, index
	popq %rcx
	popb %al
	
	iret
