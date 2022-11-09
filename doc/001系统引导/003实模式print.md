# 实模式print

    -ah: 0x0e
    -al: 字符
    -int 0x10

```
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
```

