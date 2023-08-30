NOME = string_int

all: $(NOME).o
	ld -s -o $(NOME) $(NOME).o
	rm -rf *.o;

%.o: %.asm
	nasm -f elf64 $<