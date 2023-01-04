.org 0x800
.data
array: .quad -100,43,5,15,32,42,2,3,6
size:  .quad 9
.text
main:
     movq %rsp, %rbp
     xorq %rbx, %rbx
     movq $array, %rdi
     movq size, %rsi
     call max
     movq %rax, %rbx
     hlt

max:
       movq %rsp, %rbp
       movq (%rdi), %rbx
       movq $1, %rcx
.loop:
       movq (%rdi, %rcx, 8), %r8
       cmpq %r8, %rbx
       jns  .endif
       movq %r8, %rbx
.endif:
      addq $1,  %rcx
      cmpq %rsi, %rcx
      jnz .loop
      movq %rbx, %rax
      ret