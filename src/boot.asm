[org 0x7c00] ;程序从0x7c00开始

;设置屏幕为文本模式，清除屏幕
mov ax, 3
int 0x10

;初始化寄存器 不初始化在一些虚拟机上出错 例如vmvare
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
mov ds, ax
mov sp, 0x7c00 ;栈寄存器

xchg bx, bx ;bochs的魔数断点  调整bochsrc中的magic_break 为1
mov si,booting
call print 

;阻塞
jmp $

print:
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
booting:
    db "Booting Onix...", 10, 13, 0 ;10 ASCII-> \n 换行 13 ASCII-> \r将光标移到开头 0->字符串结束


;其余字节用0填充
times 510 - ($ - $$) db 0

;主引导扇区最后两个字节必须是 55 aa

db 0x55, 0xaa

