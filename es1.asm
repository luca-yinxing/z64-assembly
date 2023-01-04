.org 0x800
.data
array: .quad 10,20,4,19,30,2,8,9,1,0
size: .quad 9
.text
main:
        # copia lo stack pointer nel base pointer
        # il base pointer è utilizzato nel codice non ottimizato dal compilatore
        # il base pointer indica sempre la cima dello stack
        # lo spiazzamento di una variabile nello stack rispetto alla cima dello stack è sempre costante
        movq    %rsp, %rbp
        movq   array, %rbx
        xorq    %r8, %r8
        movq  $1, %rcx
.loop:
       movq array(,%rcx,8), %r8
       cmpq %rbx, %r8
       jns .endif
       movq  %r8, %rbx 
.endif:
       addq  $1, %rcx
       cmpq size, %rcx
       jnz      .loop
       hlt
       