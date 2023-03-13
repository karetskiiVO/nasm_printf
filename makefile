#compile
COMPILE := nasm

#source
SOURCE := buf.asm

#executable
EXECUTABLE := test

all:
	@$(COMPILE) -f elf64 $(SOURCE) -o test.o
	@ld test.o -o test
	@rm test.o