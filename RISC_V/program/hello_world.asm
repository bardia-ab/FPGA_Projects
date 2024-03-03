
hello_world.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <main>:
   0:	05100793          	li	a5,81
   4:	04800713          	li	a4,72
   8:	100006b7          	lui	a3,0x10000
   c:	00e68023          	sb	a4,0(a3) # 10000000 <__global_pointer$+0xfffe7a1>
  10:	0007c703          	lbu	a4,0(a5)
  14:	00178793          	addi	a5,a5,1
  18:	fe071ae3          	bnez	a4,c <main+0xc>
  1c:	0000006f          	j	1c <main+0x1c>

00000020 <uart_write>:
  20:	100007b7          	lui	a5,0x10000
  24:	00a78023          	sb	a0,0(a5) # 10000000 <__global_pointer$+0xfffe7a1>
  28:	00008067          	ret

0000002c <uart_print>:
  2c:	00054783          	lbu	a5,0(a0)
  30:	00078e63          	beqz	a5,4c <uart_print+0x20>
  34:	00150513          	addi	a0,a0,1
  38:	10000737          	lui	a4,0x10000
  3c:	00f70023          	sb	a5,0(a4) # 10000000 <__global_pointer$+0xfffe7a1>
  40:	00054783          	lbu	a5,0(a0)
  44:	00150513          	addi	a0,a0,1
  48:	fe079ae3          	bnez	a5,3c <uart_print+0x10>
  4c:	00008067          	ret
