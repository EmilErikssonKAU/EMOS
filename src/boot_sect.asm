org 0x7C00              
bits 16   

;Prints string to the screen
;Params: 
;   - ds:si points to string

puts:
    ;save registers we will modify
    push si
    push ax

.loop:
    lodsb
    or al, al       ;testa ifall al = 0
    jz .done
    jmp .loop

.done:
    pop ax
    pop si
    ret


main:
    mov ax, 0
    mov ds, ax          ;flyttar ds till segment 0
    mov es, ax          ;flyttar es till segment 0

    mov ss, ax
    mov sp, 0x7C00      ;0x7C00 är start av boot_sect, stack växer nedåt

    hlt
	        

times 510 -($ -$$) db 0 
dw 0xAA55   
