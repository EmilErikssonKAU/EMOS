org 0x7C00              ;according to BIOS standard
bits 16                 ;

main:
    hlt                 ;execution stops until interrupt

.halt:                  ;local lable
    jmp .halt            ;infinite loop, in case of interrupt

                        ;($-$$) <-> length of the program so far
times 510 -($ -$$) db 0 ;fills the program with empty bits up until
                        ;position 510 with respect to start of sector

dw 0xAA55               ;bootloader signature

