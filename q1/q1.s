# node contains val, node* left, node* right = 24 bytes

.globl make_node
.globl get
.globl insert
.globl getAtMost

# function make_node(int val)

make_node:
    addi sp, sp, -16
    sd ra, 8(sp) # store return address
    sd a0, 0(sp) # store val
    
    li a0, 24 # size of node
    call malloc
    # now a0 points to the start of the new node
    
    ld t0, 0(sp) # t0 = val
    sd t0, 0(a0) # node->val
    sd x0, 8(a0) # node->left = x0 (ie null)
    sd x0, 16(a0) # node->right = x0
    
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# function insert(node* root, int val)

insert:
    addi sp, sp, -24
    sd a0, 0(sp) # store root
    sd a1, 8(sp) # store val
    sd ra, 16(sp)
    
    # if root==NULL return node(val)
    beq a0, x0, return_newnode
    
    ld t0, 0(a0) # t0 = root->val
    blt a1, t0, search_left
    bgt a1, t0, search_right
    
    # if val==root->val
    ld a0, 0(sp) # put og root
    j return_root
    
search_left:
    ld t1, 8(a0) # t1 = root->left
    mv a0, t1
    ld a1, 8(sp)
    call insert
    ld t2, 0(sp)
    sd a0, 8(t2) # root->left = result
    mv a0, t2
    j return_root

search_right:
    ld t1, 16(a0) # t1 = root->right
    mv a0, t1
    ld a1, 8(sp)
    call insert
    ld t2, 0(sp)
    sd a0, 16(t2) # root->right = result
    mv a0, t2
    j return_root
    
return_newnode:
    ld a0, 8(sp) # a0 = val
    call make_node # now a0 = newnode ie root
    j return_root
    
return_root:
    ld ra, 16(sp)
    addi sp, sp, 24
    ret

# function get(root, val)

get:
    # if node==NULL return null
    beq a0, x0, return_null
    
    ld t0, 0(a0) # t0 = root->value
    
    blt a1, t0, get_left
    bgt a1, t0, get_right
    ret
    
get_left:
    ld a0, 8(a0)
    j get

get_right:
    ld a0, 16(a0)
    j get

return_null:
    li a0, 0
    ret

# function getAtMost(val, root)

getAtMost:
    li t0, -1

loop:
    beq x0, a1, return_val # if root = NULL return -1
    
    ld t1, 0(a1)
    
    beq t1, a0, equal_case
    blt t1, a0, lessthan_case
    
    # if num is greater then go left
    ld a1, 8(a1)
    j loop

lessthan_case:
    mv t0, t1
    ld a1, 16(a1) # go right
    j loop

equal_case:
    mv a0, t1
    ret
    
return_val:
    mv a0, t0
    ret
    
