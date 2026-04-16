.section .data
file:
    .string "input.txt"
mode:
    .string "r"
yes:
    .string "Yes\n"
no:
    .string "No\n"

.section .text
.globl main

main:

    # FILE *f = fopen("input.txt", "r")
    la a0, file
    la a1, mode
    call fopen
    mv s0, a0 # fptr
    
    # fseek(f, 0, SEEK_END)
    mv a0, s0
    li a1, 0
    li a2, 2 # 2 corresponds to SEEK_END
    call fseek
    
    # size = ftell(f);
    mv a0, s0 # a0 = file
    call ftell
    mv s1, a0 # s1 = size of file

    # reset pointer to start
    mv a0, s0
    li a1, 0
    li a2, 0
    call fseek
    
    li s2, 0 # left ptr
    addi s3, s1, -1 # right ptr
    
loop:
    bge s2, s3, palindrome_case # left >= right then palindrome_case
    
    # read left char
    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek
    
    mv a0, s0
    call fgetc
    mv t0, a0
    
    # read right char
    mv a0, s0
    mv a1, s3
    li a2, 0 # 0 corresponds to SEEK_SET -> calcs byte offset
    call fseek
    
    mv a0, s0
    call fgetc
    mv t1, a0
    
    bne t0, t1, not_palindrome_case
    
    addi s2, s2, 1
    addi s3, s3, -1
    j loop
    
palindrome_case:
    la a0, yes
    call printf
    j end
    
not_palindrome_case:
    la a0, no
    call printf
    j end
    
end:
    mv a0, s0   # FILE *f
    call fclose
    
    li a0, 0
    call exit
    ret
