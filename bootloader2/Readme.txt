- Para compilar:
nasm boot.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin

- Para contatenar os dois arquivos em um:
cat boot.bin kernel.bin > binario.bin

- Criando o arquivo imagem:
sudo dd if=binario.bin of=bootsec.flp
sudo qemu-system-x86_64 -fda bootsec.flp