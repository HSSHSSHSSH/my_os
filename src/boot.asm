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
mov ax, 0xb800 ;0xb800是文本显示器的内存区域
mov ds, ax ;数据段
mov byte [0], 'H'

;阻塞
jmp $


;其余字节用0填充
times 510 - ($ - $$) db 0

;主引导扇区最后两个字节必须是 55 aa

db 0x55, 0xaa

