; Converts an LBA address to a CHS address
; Parameters:
;   -ax: LBA address
; Returns:
;   -cx [bits 0-5]: sector number
;   -cx [bits 6-15]: cylinder number
;   -dh: head
;

lba_to_chs:

    push ax
    push dx

    xor dx, dx                              ; dx = 0 
                                            ; div: ax := result, dx := remainder
    div word [bdb_sectors_per_track]        ; ax = LBA / sectors per track
                                            ; dx = LBA % sectors per track
    
    inc dx                                  ; dx = (LBA % sectors per track) + 1 = sector
    mov cx, dx                              ; cx = sector

    xor dx, dx
    div word [bdb_heads]                    ; ax = (LBA / sectors per track) / heads = cylinder
                                            ; dx = (LBA / sectors per track) % heads = head
    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax
    ret


; Read sectors from a disk
; Parameters:
;   -ax: LBA address
;   -cl: number of sectors to read
;   -dl: drive number
;   -es:bx: memory address where to store and read data
;

disk_read:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx
    call lba_to_chs
    pop ax                                  ; al = number of sectors to read

    mov ah, 02h
    mov di, 3


.retry:
    pusha                                   ; push all registers
    stc                                     ; set carry flag

    int 13h                                 ; 13h -> low level disk services
                                            ;   02h -> read sectors
                                            ;   parameters:
                                            ;       - al := number of sectors to read
                                            ;       - ch := cylinder, cl := sector
                                            ;       - dh := head, dl := drive
                                            ;

    jnc .done                               ; operation succeeded if carry flag not set

    ; read failed
    popa 
    call disk_reset

    dec di
    test di, di                             ; 'and' operation testing for zero register 
    jnz .retry

.fail:
    ; all attempts failed
    jmp floppy_error

.done:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

floppy_error:
    mov si, readFailedMessage
    call puts
    jmp wait_key_and_reboot



; Resets disk controller
; parameters:
;   - dl: drive number
;

wait_key_and_reboot:
    mov ah, 0 
    int 16h                                 ; read character
    jmp 0FFFFh:0                            ; jump to beginning of BIOS, reboot

.halt:
    cli
    hlt

disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h                                 ; reset disk system
    jc floppy_error
    popa 
    ret


