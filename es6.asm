.org 0x800
.data
array:	.byte 30,40,-12,4,43,-17,10,-123,12,1,-13,100,33,41,120,-1,	31,-40,-122,42,5,-7,32,-90,23,111,2,160,33,88,128,-91
size: 	.byte 32
.text
# @param RDI long* array
# @param RSI quad size
.pari_posizioni:
	movq %rsp, %rbp
	# set 0 RAX (return value)
	xorq %rax, %rax
	# push caller save RCX
	pushq %rcx
	# set 0 RCX (loop counter)
	xorq %rcx, %rcx
	movq $1, %r12
.pari_posizioni_loop:
	movb (%rdi, %rcx, 1), %bl
	# check if value is even, if so jump to even
	andb $1, %bl
	jnz .pari_posizioni_endif
	orl %r12d, %eax
	# check if value is not even, if so jump to endif
	andl $0x1, %ebx
.pari_posizioni_endif:
	salq $1, %r12
	addb $1, %cl
	# if size is not equal to RCX, then do another iteration
	cmpb %cl, size
	jnz .pari_posizioni_loop
	popq %rcx
	ret
main:
	movq %rsp, %rbp
	movq $array,%rdi
	call .pari_posizioni
	hlt