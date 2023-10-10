all: build run

clean:
	rm -rf ./*.bin
build:
	nasm boot.asm -f bin -o boot.bin
	nasm kernel.asm -f bin -o kernel.bin
	cat boot.bin kernel.bin > os.bin
	dd if=os.bin of=bootsec.flp
run:
	qemu-system-i386 -fda os.bin
