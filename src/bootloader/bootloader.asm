org 0x7C00              
bits 16   

;
;   Prints string to the screen
;   Params: 
;       - ds:si points to string
;

%define ENDL 0x0D, 0x0A
%include "/root/OSDev/src/bootloader/FAT12_headers.asm"

start:
    jmp main

puts:
                        ;save registers we will modify
    push si
    push ax

.loop:
    lodsb
    or al, al           ;testa ifall al = 0
    jz .done

    mov ah, 0x0e    
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret


main:
    mov ax, 0
    mov ds, ax          ; flyttar ds till segment 0
    mov es, ax          ; flyttar es till segment 0

    mov ss, ax
    mov sp, 0x7C00      ; 0x7C00 är start av boot_sect, stack växer nedåt

    ;read something from floppy disk
    mov [ebr_drive_number], dl

    mov ax, 1           ; LBA = 1
    mov cl, 1           ; One sector to read
    mov bx, 0x7E00      
    call disk_read


    ; print 'Hello World'
    mov si, message
    call puts

    cli
    hlt

%include "/root/OSDev/src/bootloader/diskreader.asm"

message: db 'Hello World', ENDL, 0
readFailedMessage: db 'Read failed', ENDL, 0
	        

times 510 -($ -$$) db 0 
dw 0xAA55   
