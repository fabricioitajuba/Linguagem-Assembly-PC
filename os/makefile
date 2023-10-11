all: build run

clean:
	rm -rf *./bin
build:
	nasm boot.asm -f bin -o boot.bin
	nasm kernel.asm -f bin -o kernel.bin
	cat boot.bin kernel.bin > os.bin
	dd if=/dev/zero of=floppy.img bs=1024 count=1440
	dd if=os.bin of=floppy.img seek=0 count=3 conv=notrunc
	cp floppy.img iso/
	genisoimage -quiet -V 'MYOS' -input-charset iso8859-1 -o myos.iso -b floppy.img -hide floppy.img iso/
run:
	#qemu-system-i386 -fda os.bin
	qemu-system-i386 -cdrom ./myos.iso
