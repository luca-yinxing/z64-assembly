.org 0x800
.data
#array:	.long 30,40,-12,4,43,-17,10,-123,12,1,-13,100,343,41,120,-1,	31,-40,-122,42,5,-7,-190,-90,23,111,-134,160,33,88,128,-91,	32,-41,-125,88,90,-27,0,3,2,37,-22,187,312,314,46,-46,	36,8,9,-8,-9,-5,75,-75,414,-3,118,-118,19,18,-19,-17
array:	.long 30,40,12,4,43,17,10,2
size: 	.quad 8
.text
# @param RDI long* array
# @param RSI quad size
.pari_posizioni_dispari:
	movq %rsp, %rbp
	# set 0 RAX (return value)
	xorq %rax, %rax
	# push caller save RCX
	pushq %rcx
	# set 0 RCX (loop counter)
	xorq %rcx, %rcx
.pari_posizioni_dispari_loop:
	movl (%rdi, %rcx, 4), %ebx
	movq %rcx, %r12
	# check if position is even, if so jump to endif
	andq $0x1, %r12
	jz .pari_posizioni_dispari_endif
	# check if value is not even, if so jump to endif
	andl $0x1, %ebx
	jnz .pari_posizioni_dispari_endif
	# if position is not even, and value is even, add 1 to RAX
	addq $1, %rax
.pari_posizioni_dispari_endif:
	# increase loop counter RCX
	addq $1, %rcx
	# if RSI is not equal to RCX, then do another iteration
	cmpq %rcx, %rsi
	jnz .pari_posizioni_dispari_loop
	popq %rcx
	ret
main:
	movq %rsp, %rbp
	movq $array, %rsi
	movq $0x5555,%rdi
	movq size, %rcx 
	movsl
	movq $0x5555,%rdi
	movq size,%rsi
	call .pari_posizioni_dispari
	hlt