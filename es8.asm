.org 0x800
.data
num: .quad 100
div: .quad 10
.text
# @param RDI quad num
# @param RSI quad div
.divisione:
	movq %rsp, %rbp
	# set 0 RAX (return value)
	movq $-1, %rax
	pushq %rdi

	addq $0, %rsi
	js .divisione_ret
	jz .divisione_ret

.divisione_loop:
	addq $1, %rax
	subq %rsi, %rdi
	# if div is not equal to RCX, then do another iteration
	jns .divisione_loop
.divisione_ret:
	popq %rdi
	ret
main:
	movq %rsp, %rbp
	movq num,%rdi
	movq div,%rsi
	call .divisione
	hlt