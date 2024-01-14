# Snake512
Snake in boot sector of an diskette drive

## How to compile & run

`nasm -f bin main.asm # Compiles the file as 16bit binary file`
`qemu-system-i386 main # Run the binary file`

## Btw, this only works for bios, not UEFI (legacy boot might tho)
