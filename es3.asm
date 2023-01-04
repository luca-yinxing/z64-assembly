.org 0x800
.data
array:	.long 10,43,54,24,756,4553,1,57,19
size:	.byte 9
.text
main:
	movq %rsp, %rbp
	movb size, %cl
	#subq %rcx, %rsp
	#subq %rcx, %rsp
	#subq %rcx, %rsp
	#subq %rcx, %rsp
	movq %rbp, %rax
	subb $1, %cl
.loop:
	pushq array(,%rcx,4)
	subb $1, %cl
	jnz .loop
	hlt