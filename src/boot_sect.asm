org 0x7C00              ;according to BIOS standard
bits 16                 ;

main:
    jmp greet
    hlt                 ;execution stops until interrupt
                        ;jmp $ <-> alternative for inf loop


greet:
    push bp		        ;prolog
    mov sp, bp		    ;

    mov ah, 0x0e        ;BIOS interrupt code for typing to teletype
                        ;int 0x10 -> interrupt for BIOS video services
                        ;the interrupt list is provided by BIOS
    mov al , 'G'
        int 0x10
    mov al , 'O'
        int 0x10
    mov al , 'D'
        int 0x10
    mov al , 'M'
        int 0x10
    mov al , 'O'
        int 0x10
    mov al , 'R'
        int 0x10
    mov al , 'G'
        int 0x10
    mov al , 'O'
        int 0x10
    mov al , 'N'
        int 0x10
    mov al , '!'
        int 0x10
    
    mov bp, sp		    ;epilog
    pop bp		        ;
    ret			        ;

                        ;($-$$) <-> length of the program so far
times 510 -($ -$$) db 0 ;fills the program with empty bits up until
                        ;position 510 with respect to start of sector

dw 0xAA55               ;bootloader signature
