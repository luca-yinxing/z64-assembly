.org 0x800
.data
array:	.long 30,40,-12,4,43,-17,10,-123,12,1,-13,100,343,41,120,-1,	31,-40,-122,42,5,-7,-190,-90,23,111,-134,160,33,88,128,-91,	32,-41,-125,88,90,-27,0,3,2,37,-22,187,312,314,46,-46,	36,8,9,-8,-9,-5,75,-75,414,-3,118,-118,19,18,-19,-17
size: 	.quad 64
.text
# @param RSI long* arr1
# @param RDI long* arr2
# @param RDX long  size
.memcmp:
	movq %rsp, %rbp
	# save caller-save R8
	pushq %r8
	# save caller-save R9
	pushq %r9
	# set loop counter RBX
	xorq %rbx, %rbx
	# set return value RAX
	xorq %rax, %rax
.memcmp_loop:
	# fetch longword from RDI (Memory1 input)
	movl (%rdi, %rbx, 4), %r8d
	# fetch longword from RDI (Memory2 input)
	movl (%rsi, %rbx, 4), %r9d
	# if fetch values are different, jump to return
	cmpl %r8d,%r9d
	jnz .memcmp_ret_false
	addq $1,%rbx
	# compare loop counter RBX with RDX (Memory Size input)
	cmpq %rbx, %rdx
	jnz .memcmp_loop
	# if end loop set RAX as 1
	movq $1, %rax
.memcmp_ret_false:
	pushq %r9
	# save caller-save R9
	pushq %r8
	ret

# @param RDI long* arr
# @param RSI long size
# @return RAX 0 if array is not sorted, 1 if is sorted
.is_sorted:
	movq %rsp, %rbp
	# save caller-save RCX
	pushq %rcx
	# save caller-save R8
	pushq %r8
	# save caller-save R9
	pushq %r9
	# set 1 R8 (loop array counter)
	movq $1, %r8
	# set 0 RCX (loop array counter always = R8 - 1)
	xorq %rcx, %rcx
	# set 0 RBX (container for RDI[RCX])
	xorq %rbx, %rbx
	# set 0 R9 (container for RDI[R8])
	xorq %r9, %r9
	# set 0 RAX (return value)
	xorq %rax, %rax
.is_sorted_loop:
	# pick RDI[RCX] into RBX 
	movl (%rdi, %rcx, 4), %ebx
	# pick RDI[R8] into R9 
	movl (%rdi, %r8, 4), %r9d
	# if R9 - RBX < 0 then return 0
	cmpl %ebx, %r9d
	js .is_sorted_ret
	# increase both loop counter RCX and R8
	addq $1, %rcx
	addq $1, %r8
	# if R8 not is equal to array size, do another iteration
	cmpq %r8, %rsi
	jnz .is_sorted_loop
	# if exit from loop, set return value as 1
	movq $1, %rax
	# return
.is_sorted_ret:
	popq %r9
	popq %r8
	popq %rcx
	ret

# @param RDI long* arr
# @param long size
.bubble_sort:
	movq %rsp, %rbp
	# save caller-save RCX
	pushq %rcx
	# save caller-save R8
	pushq %r8
	# save caller-save R9
	pushq %r9
	# save caller-save R10
	pushq %r10
	# save caller-save R9
	pushq %r11

	# set 0 RCX (sub loop array counter always = R8 - 1)
	xorq %rcx, %rcx
	# set 1 R8 (sub loop array counter)
	movq $1, %r8

	# set 0 RBX (container for RDI[RCX])
	xorq %rbx, %rbx
	# set 0 R9 (container for RDI[R8])
	xorq %r9, %r9
	# move array size to R10 (main loop starting position)
	movq %rsi, %r10
	# set 0 R11
	xorq %r11, %r11

.bubble_sort_main_loop:
.bubble_sort_sub_loop:
	# pick RDI[RCX] into RBX 
	movl (%rdi, %rcx, 4), %ebx
	# pick RDI[R8] into R9 
	movl (%rdi, %r8, 4), %r9d
	# compare RBX and R9 
	cmpl %ebx, %r9d
	# if R9 - RBX > 0 then skip the swap
	jns .bubble_sort_sub_loop_endif 
	# swap RDI[RCX] with RDI[R8]
	movl %ebx, (%rdi, %r8, 4)
	movl %r9d, (%rdi, %rcx, 4)
.bubble_sort_sub_loop_endif:
	# increase both sub loop counter RCX and R8
	addq $1, %rcx
	addq $1, %r8
	# if not reach maximum for this sub loop
	cmpq %r8, %r10
	# jump to another iteration
	jnz .bubble_sort_sub_loop
	# reset RCX and R8 as starting values
	xorq %rcx, %rcx
	movq $1, %r8
	# decrease by one the maximum loop iteration
	subq $1,%r10
	# check if we didnt reach 1 in the main loop counter iteration
	cmpq $1,%r10
	# jump to another main loop iteration
	jnz .bubble_sort_main_loop
	# reset stack
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	ret
main:
	movq %rsp, %rbp
	movq $array, %rsi
	movq $0x1280,%rdi
	movq size, %rcx 
	movsl
	#movq $64, %rdx
	#movq $array, %rsi
	#movq $0x1280,%rdi
	#call .memcmp
	xorq %rax, %rax
	movq size, %rsi
	movq $0x1280,%rdi
	call .bubble_sort
	call .is_sorted
	hlt