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

mov si,booting
call print 
xchg bx, bx ;bochs的魔数断点  调整bochsrc中的magic_break 为1

; ; 读硬盘 从 ecx 扇区开始, 读取 bl 个扇区到 edi 的位置
mov edi, 0x1000 ;读取的目标内存

mov ecx, 2 ;起始扇区

mov bl, 4 ;扇区数量

xchg bx, bx

call read_disk



;阻塞
jmp $
     
 


read_disk: ;读硬盘
    ; 设置读写扇区的数量
    mov dx, 0x1f2  
    mov al, bl 
    out dx, al

    ;设置起始扇区的低8位
    inc dx ;0x1F3
    mov al, cl 
    out dx, al

    ;设置起始扇区的中8位
    inc dx ;0x1F4
    shr ecx, 8
    mov al, cl 
    out dx, al

    ;设置起始扇区的高8位
    inc dx ;0x1F5
    shr ecx, 8
    mov al, cl 
    out dx, al 

    ; 硬盘为主盘  LBA模式
    inc dx ; 0x1F6 
    shr ecx, 8
    and ecx, 0b0000_1111 ;将高四位设置为0
    mov al, 0b1110_0000
    or al, cl 
    out dx, al 

    ;设置为 读硬盘操作
    inc dx ;0x1F7
    mov al, 0x20 ;mark al ax
    out dx, al

    xor ecx, ecx ;异或 将ecx清空
    mov cl, bl ;获取读写扇区的数量

    .read:
        push cx
        call .wait ;等待数据准备完毕
        call .reads ; 读取硬盘
        pop cx
        loop .read
    ret

    .wait:
        mov dx, 0x1F7
        .check:
            in al, dx 
            jmp $ + 2  ;延迟
            jmp $ + 2
            jmp $ + 2
            and al, 0b1000_1000
            cmp al, 0b0000_1000
            jnz .check
        ret
    .reads:
        mov dx, 0x1f0
        mov cx, 256 ;一个扇区256个字
        .readw:
            in ax, dx
            jmp $ + 2
            jmp $ + 2
            jmp $ + 2
            mov [edi], ax
            add edi, 2
            loop .readw
        ret

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
booting:
    db "Booting Onix...", 10, 13, 0 ;10 ASCII-> \n 换行 13 ASCII-> \r将光标移到开头 0->字符串结束

error:
    mov si, .msg
    call print
    hlt ; cpu 停止工作
    jmp $
    .msg db "Booting Error...", 10, 13, 0

;其余字节用0填充
times 510 - ($ - $$) db 0

;主引导扇区最后两个字节必须是 55 aa

db 0x55, 0xaa

