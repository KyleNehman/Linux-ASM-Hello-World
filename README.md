# Linux-ASM-Hello-World
#### A simplistic Hello World for nasm w/ intel syntax

### Note:
The makefile assumes you've got nasm and ld installed, and uses the '-m elf_i386' linker flag for my own pc, you'll probably have to adjust this.

### How to run?
    git clone https://github.com/KyleNehman/Linux-ASM-Hello-World.git
    cd Linux-ASM-Hello-World/
    make
    make run


### What's this crazy code do? (Breakdown)
##### [What's assembly anyway?](https://en.wikipedia.org/wiki/Assembly_language)

This program is more or less the equivalent of the following python:

     print 'Hello, World!'

Let's go line by line, since this is for total beginners.

1. Data Section:

			section .data
		msg:    db      "Hello, world!", 0x0a
		msgLen: equ     $-msg

    The section '.data' tells the computer that data, similar to variables, are to be stored here.

    'msg' and 'msgLen' act similar to variables, but they are actually there just for the programmer to mark specific memory offsets of where we've stored data.

    db defines _bytes_, generally (with ascii), each character is stored as 1 byte. So here we list the bytes we want to store in order. In this case "Hello, World!" followed by 0x0a, the newline character.

    equ says that we want to evaulate the expression '$-msg' which takes the current memory address (represented by the '$' character) and subtracts the address labeled 'msg'. Since msgLen is stored directly after msg in memory this difference will actually be the *length*, or number of elements in, the array of bytes we stored as 'msg'.



2. Text Section (The first chunk):

    The remainder of the program is technically the text section so we'll go at it in chunks

                section .text
		global _start
        _start:
                mov     ecx, msg
                mov     edx, msgLen

                call print
                call exit

   Similar to '.data', '.text' is where our instructions (and the bulk of the program) go. Defining the global '_start' is similar, and is like a main() function in other languages. It's the required entry point for the program.

   The program begins execution at the '_start' label, by moving the data from 'msg' and 'msgLen' into the [registers](https://en.wikipedia.org/wiki/Processor_register) 'ecx' and 'edx' respectively. Similar to how you pass a string into python's print function the string and length must be passed into these registers in order to output them to the screen.

   After moving our data into those registers we call the print subroutine (think of subroutines like functions) and then the exit subroutine. But those haven't been defined! How does our program know what that even means? It wouldn't if we didn't define them, but thankfully we did lower down. Since the assembler and linker will rearrange our subroutine definitions for us you can define them in whatever order makes the most sense (and looks cleanest) to you.


3. Text Section (The second chunk -- print):

        print:
                push    eax
                push    ebx

                mov     eax, 4
                mov     ebx, 1
                int     0x80

                pop     ebx
                pop     eax
                ret

    So we defined the print label, now our program knows where to go when we call print, what's up with pushing those registers?  This step is actually totally unecessisary for our program, but it's good practice. We push the current values of eax and ebx onto the stack so that when we write to them in a second the data isn't lost. The last thing you want to do is lose data in a register because you called a subroutine that modified it without your knowledge.

    Similar to how we ~just had to~ put the string and length in ecx and edx, eax needs to contain the int 4 in it so the computer knows we want to print, and ebx needs 1 so it knows the printed data is going to stdout. Simple stuff!

    int 0x80 actually ins't the integer 128, I mean it is, but not as a variable. int here means interrupt, so the program triggers a cpu interrupt, causing the computer to read eax and determine what to do. It sees 4 in eax, checks ebx for the output  (stdout here) and then prints what's in ecx, up to the number of chars specified by edx. Get it? Good!

    Then we pop the values off the stack back into the registers that we modified and return! Notice we don't return a value? ret is required here to specify the end of our function, now the stack pointer can do it's magic and get us back to where we originally called the print subroutine.

4. Text Section (The last chunk -- exit):

        exit:
		mov	eax, 1
		mov	ebx, 0
		int     0x80

   At this point you should see what's going on but we'll run through it. The label exit is defined so that we can refer to this memory address in our program. Then we move the value 1 into eax and trigger a cpu interrupt causing something to happen based on the value of eax. What happens with interrupt code 1 on linux? The program exits with the code specified in ebx (0 for successful exit by standard).



    
