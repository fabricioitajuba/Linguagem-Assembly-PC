all: build run

build: boot

boot: boot.asm
    nasm boot.asm

run: boot
    qemu-system-i386 boot

clean:
    -rm boot
