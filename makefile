#compile
COMPILE := nasm

#source
SOURCE := buf.asm

#executable
EXECUTABLE := test

all:
	nasm -f elf64 -g asmprintf.asm -o asmprintf.o
#	nasm -f elf64 -g asmprint.asm -o asmprintf.o
	gcc -ffreestanding -c -s -g main.c
	gcc -no-pie asmprintf.o main.o -o test
	rm asmprintf.o main.o

asm:
	@nasm -f elf64 buf.asm -o test.o
	@ld test.o -o test
	@rm test.o