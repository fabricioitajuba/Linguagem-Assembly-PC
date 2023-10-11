all: build run

clean:
	rm -rf *./bin
build:
	nasm boot.asm -f bin -o boot.bin
	nasm kernel.asm -f bin -o kernel.bin
	cat boot.bin kernel.bin > os.bin
run:
	qemu-system-i386 os.bin
