[org 0x1000]

dw 0x55aa ;魔数 用于判断错误

mov si, loading
call print
print:  ; 在屏幕上输出字符
    mov ah, 0x0e
.next:
    mov al, [si]
    cmp al, 0
    jz .done
    int 0x10
    inc si
    jmp .next
.done:
    ret
loading:
    db "loading Onix...", 10, 0 ;10 ASCII-> \n 换行 13 ASCII-> \r将光标移到开头 0->字符串结束
