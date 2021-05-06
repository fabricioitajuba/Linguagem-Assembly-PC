Comparação entre programa feito em C com programa feito em assembly

- Para compilar o programa feito em C

$ make progC

- Para executar o programa feito em C

$ ./progC

- Para ver o retorno do programa:

$ echo $?

- Para compilar o programa feito em assembly para funcionar em 64 bits

$ nasm -f elf64 progA.asm

- Para gerar o executável para 64 bits

$ ld -s -o progA64 progA.o

- Para compilar o programa feito em assembly para funcionar em 32 bits

$ nasm -f elf32 progA.asm

- Para gerar o executável para 32 bits

$ ld -m elf_i386 -o progA32 progA.o

- Para saber informações sobre um arquivo (inclusive dependências):

$ file "nome do arquivo"

- Para saber as dependências do arquivo:

$ ldd "nome do arquivo"

- Para vermos o código fonte:

$ objdump -dM intel "nome do arquivo"
