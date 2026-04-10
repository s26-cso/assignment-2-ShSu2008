.section .data
scan_fmt:
    .string "%d"
print_fmt:
    .string "%d "
newline:
    .string "\n"
.section .text
.globl main
.extern scanf
.extern printf
.extern malloc
main:
    addi sp, sp, -32
    sd ra, 0(sp)
    
    li s3, 0 # s3 = n = 0 / no of args / since we need it so stay across fns
    
    li a0, 400000000 # max size for all (arr, res, stack) * 4 (for byte)
    call malloc
    mv s0, a0  # base of array
    
input_loop:
    la a0, scan_fmt
    
    slli s5, s3, 2 # offset for arr
    add s5, s0, s5 # address = arraybase + offset
    mv a1, s5
    call scanf
    
    li t1, 1
    bne t1, a0, input_over # if number of items read is not 1
    
    addi s3, s3, 1 # n++
    j input_loop

input_over:
    
    slli a0, s3, 2
    call malloc
    mv s1, a0 # result array
    
    slli a0, s3, 2
    call malloc
    mv s2, a0 # stack
    
    li s4, -1 # top = -1
    addi s5, s3, -1 # i = n-1 since we check r to l
    

    
main_for_loop:
    blt s5, x0, end_loop

while_loop:
    blt s4, x0, end_while # if stack is empty (top<0)
    
    slli t1, s4, 2
    add t1, s2, t1
    lw t2, 0(t1) # t2 = stack[top]
    
    slli t3, t2, 2
    add t3, s0, t3
    lw t4, 0(t3) # t4 = arr[stack[top]]
    
    slli t5, s5, 2
    add t5, s0, t5
    lw t6, 0(t5) # t6 = arr[i]
    
    ble t4, t6, pop_stack # if arr[top] <= arr[i] -> pop
    j end_while

pop_stack:
    addi s4, s4, -1 # top--
    j while_loop

end_while:
    blt s4, x0, case_stack_empty

    slli t1, s4, 2
    add t1, s2, t1
    lw t2, 0(t1) # from stack take index

    slli t3, s5, 2
    add t3, s1, t3
    sw t2, 0(t3) # store index in res arr
    
    j push_i

case_stack_empty:
    li t2, -1
    slli t3, s5, 2
    add t3, s1, t3
    sw t2, 0(t3)

push_i:
    addi s4, s4, 1 # top++
    slli t1, s4, 2
    add t1, s2, t1
    sw s5, 0(t1) # storenew top

    addi s5, s5, -1 # i--
    j main_for_loop


end_loop:
    li s5, 0
    
print_loop:
    bge s5, s3, print_done # if index >= n done

    slli t1, s5, 2
    add t1, s1, t1
    lw t2, 0(t1)

    la a0, print_fmt
    mv a1, t2
    call printf

    addi s5, s5, 1
    j print_loop

print_done:
    la a0, newline
    call printf

    ld ra, 0(sp)
    addi sp, sp, 32
    li a0, 0
    ret

