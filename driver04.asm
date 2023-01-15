.org 0x800
.data
addr_a: .byte 0
addr_b: .byte 0
addr_c: .byte 0
addr_d: .byte 0

.equ eof_value, 0xFFFFFFFF
data_eof: .byte 0

data_push: .quad 0x8000

.equ v_sz, 256
.comm v, v_sz*8

.equ inet 0x0001
.text
merge_addr:
	pushq %rbx

	xorq %rax, %rax
	xorq %rbx, %rbx
	movb addr_a, %al

	movb addb_b, %bl
	shlq $8, %rbx
	orq %rbx, %rax

	movb addb_c, %bl
	shlq $16, %rbx
	orq %rbx, %rax

	movb addb_d, %bl
	shlq $24, %rbx
	orq %rbx, %rax

	popq %rbx
	ret
main:
.main_loop:
	call merge_addr
	outl %eax, $inet
	xorq %rcx, %rcx
	movb addr_d, %cl
	movq data_push, v(,%rcx, 8)
	sti
.file_loop:
	hlt
	btb $0, data_eof
	jc .file_loop

	addb $1, addr_d
	jmp .main_loop
.driver 1
	cli
	pushq %rax
	pushq %rbx
	pushq %rcx

	inl $inet, %eax
	movq data_push, %rbx
	movl %eax, (%rbx)
	addq $4, %rbx
	movq %rbx, data_push

	cmpl %eax, $eof_value
	jnz .inet_else
	movb $1, data_eof
	jmp .inet_endif
.inet_else:
	movb $0, data_eof
.inet_endif:
	
	popq %rcx
	popq %rbx
	popq %rax
	
	iret