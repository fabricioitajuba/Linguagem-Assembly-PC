FILENAME=hello

all: cleanup
	nasm -f elf64 $(FILENAME).asm
	ld -s -o $(FILENAME) $(FILENAME).o
	./$(FILENAME)

cleanup:
	rm -f $(FILENAME).o
	rm -f $(FILENAME)
