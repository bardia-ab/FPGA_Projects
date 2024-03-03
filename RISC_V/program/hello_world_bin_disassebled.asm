
hello_world_bin.elf:     file format elf32-littleriscv


Disassembly of section .data:

00000000 <_binary_hello_world_bin_start>:
   0:	05100793          	addi	x15,x0,81
   4:	04800713          	addi	x14,x0,72
   8:	100006b7          	lui	x13,0x10000
   c:	00e68023          	sb	x14,0(x13) # 10000000 <_binary_hello_world_bin_end+0xfffffa1>
  10:	0007c703          	lbu	x14,0(x15)
  14:	00178793          	addi	x15,x15,1
  18:	fe071ae3          	bne	x14,x0,c <_binary_hello_world_bin_start+0xc>
  1c:	0000006f          	jal	x0,1c <_binary_hello_world_bin_start+0x1c>
  20:	100007b7          	lui	x15,0x10000
  24:	00a78023          	sb	x10,0(x15) # 10000000 <_binary_hello_world_bin_end+0xfffffa1>
  28:	00008067          	jalr	x0,0(x1)
  2c:	00054783          	lbu	x15,0(x10)
  30:	00078e63          	beq	x15,x0,4c <_binary_hello_world_bin_start+0x4c>
  34:	00150513          	addi	x10,x10,1
  38:	10000737          	lui	x14,0x10000
  3c:	00f70023          	sb	x15,0(x14) # 10000000 <_binary_hello_world_bin_end+0xfffffa1>
  40:	00054783          	lbu	x15,0(x10)
  44:	00150513          	addi	x10,x10,1
  48:	fe079ae3          	bne	x15,x0,3c <_binary_hello_world_bin_start+0x3c>
  4c:	00008067          	jalr	x0,0(x1)
  50:	6548                	c.flw	f10,12(x10)
  52:	6c6c                	c.flw	f11,92(x8)
  54:	6f57206f          	jal	x0,72f48 <_binary_hello_world_bin_end+0x72ee9>
  58:	6c72                	c.flwsp	f24,28(x2)
  5a:	2164                	c.fld	f9,192(x10)
  5c:	0a0d                	c.addi	x20,3
	...
