helloWorld.out: helloWorld.o
	ld -m elf_i386 -s -o helloWorld.out helloWorld.o
	chmod +x helloWorld.out

helloWorld.o: helloWorld.asm
	nasm -f elf helloWorld.asm

run:
	./helloWorld.out

clean:
	rm -rf *.o *.out *~
