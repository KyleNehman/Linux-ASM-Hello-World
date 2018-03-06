	section .data
msg:	db 	"Hello, world!", 0x0a
msgLen:	equ	$-msg

	section .text
	global _start
_start:
	mov	ecx, msg
	mov	edx, msgLen

	call print
	call exit

print:
	push 	eax
	push 	ebx

	mov	eax, 4
	mov	ebx, 1
	int 	0x80

	pop	ebx
	pop	eax
	ret

exit:
	mov	eax, 1
	mov	ebx, 0
	int	0x80
