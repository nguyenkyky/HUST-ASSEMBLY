# breshenham circle algorithm

    .data
radius:     .word       10
initial_x:   .word       256
initial_y:   .word       256
BLACK:  .word       0x00000000
YELLOW: .word	    0x00FFFF00
.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
 			# Auto clear after lw
    # midpoint circle algorithm variables

bmp:        .space      0x80000
dpy_width:  .word       512
dpy_height: .word       512
dpy_base:   .word       0x10010000

.text

main:
	li 	$k0, KEY_CODE
	li 	$k1, KEY_READY
   	lw	$a0, initial_x
   	lw	$a1, initial_y
   	lw	$a2, YELLOW
   	jal     kdraw
loop:
	lw	$a2, BLACK
	jal	kdraw
WaitForKey: 
	lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
	nop
	beq $t1, 1, ReadKey # if $t1 == 0 then Polling
	nop
erase_old:
	addi	$s3, $0, 0
	j	moves
ReadKey:
	lw $s3, 0($k0) # $t0 = [$k0] = KEY_CODE
	j	moves
moves:
	add	$t9, $a0, $0		# set $t1 = $a0 to avoid losing $a0 when syscall
	### Sleep for 1 ms so frame rate is about 1000
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 10	# 1ms
	syscall
	add	$a0, $t9, $0		#set $a0 back
	j 	rear
no_rear:
	beq	$s3, 0, no_new_dir	# if key press = 'd' branch to moveright
	beq	$s3, 100, moveRight	# if key press = 'd' branch to moveright
	beq	$s3, 97, moveLeft	# else if key press = 'a' branch to moveLeft
	beq	$s3, 119, moveUp	# if key press = 'w' branch to moveUp
	beq	$s3, 115, moveDown	# else if key press = 's' branch to moveDown
no_new_dir:
	beq	$s5, 100, moveRight	# if key press = 'd' branch to moveright
	beq	$s5, 97, moveLeft	# else if key press = 'a' branch to moveLeft
	beq	$s5, 119, moveUp	# if key press = 'w' branch to moveUp
	beq	$s5, 115, moveDown	# else if key press = 's' branch to moveDown
set_old_dir:
end_move: 	
	j 	loop 

rear:
rearLeft:
	addi	$t8, $0, 10
	slt	$t8, $t8, $a0 
	beq	$t8, 1, rearRight
	seq	$t3, $s3, 97
	seq	$t4, $s5, 97
	seq	$t5, $s3, 0
	and	$t4, $t4, $t5
	or	$t3, $t3, $t4
	beq	$t3, 1, moveRight
rearRight:
	addi	$t8, $0, 502
	slt	$t8, $a0, $t8 
	beq	$t8, 1, rearUp
	seq	$t3, $s3, 100
	seq	$t4, $s5, 100
	seq	$t5, $s3, 0
	and	$t4, $t4, $t5
	or	$t3, $t3, $t4
	beq	$t3, 1, moveLeft
rearUp:
	addi	$t8, $0, 10
	slt	$t8, $t8, $a1 
	beq	$t8, 1, rearDown
	seq	$t3, $s3, 119
	seq	$t4, $s5, 119
	seq	$t5, $s3, 0
	and	$t4, $t4, $t5
	or	$t3, $t3, $t4
	beq	$t3, 1, moveDown
rearDown:
	addi	$t8, $0, 502
	slt	$t8, $a1, $t8
	beq	$t8, 1, no_rear
	seq	$t3, $s3, 115
	seq	$t4, $s5, 115
	seq	$t5, $s3, 0
	and	$t4, $t4, $t5
	or	$t3, $t3, $t4
	beq	$t3, 1, moveUp
no_bonuce:
	j	no_rear
								
main_done:
   	li      $v0,10
   	syscall

moveRight:
	addi	$s5, $0, 100
	addi	$a0, $a0, 8
	lw	$a2, YELLOW
	jal	kdraw
	j	set_old_dir
	
moveLeft:
	addi	$s5, $0, 97
	addi	$a0, $a0, -8
	lw	$a2, YELLOW
	jal	kdraw
	j	set_old_dir

moveUp:
	addi	$s5, $0, 119
	addi	$a1, $a1, -8
	lw	$a2, YELLOW
	jal	kdraw
	j	set_old_dir

moveDown:
	addi	$s5, $0, 115
	addi	$a1, $a1, 8
	lw	$a2, YELLOW
	jal	kdraw
	j	set_old_dir

 
kdraw:
	subi    $sp,$sp,12
	sw      $ra,0($sp)
	sw      $a0,4($sp)
	sw      $a1,8($sp)
    

	lw      $s0,radius              # x = radius
	li      $s1,0                   # y = 0

    # initialize: xchg = 1 - (2 * r)
	li      $s3,1                   # xchg = 1
 	sll     $t0,$s0,1               # get 2 * r
	sub     $s3,$s3,$t0             # xchg -= (2 * r)

	li      $s4,1                   # ychg = 1
	li      $s2,0                   # raderr = 0

kdraw_loop:
    	blt     $s0,$s1,kdraw_done      # x >= y? if no, fly (we're done)

    # draw pixels in all 8 octants
    	jal     draw8
	
    	addi    $s1,$s1,1               # y += 1
    	add     $s2,$s2,$s4             # raderr += ychg
    	addi    $s4,$s4,2               # ychg += 2

    	sll     $t0,$s2,1               # get 2 * raderr
    	add     $t0,$t0,$s3             # get (2 * raderr) + xchg
    	blez    $s2,kdraw_loop          # >0? if no, loop

    	subi    $s0,$s0,1               # x -= 1
    	add     $s2,$s2,$s3             # raderr += xchg
    	addi    $s3,$s3,2               # xchg += 2
    	j       kdraw_loop

kdraw_done:
    	lw	    $a1,8($sp)
    	lw	    $a0,4($sp)
    	lw      $ra,0($sp)
    	addi    $sp,$sp,12
    	jr      $ra

# draw8 -- draw single point in all 8 octants
#
# arguments:
#   s0 -- X coord
#   s1 -- Y coord
#
# registers:
#   t8 -- center_x
#   t9 -- center_y
draw8:
    	subi    $sp,$sp,4
    	sw      $ra,0($sp)

    #+drawctr $t8,$t9
    	lw      $t8,8($sp)         # load the value of x
    	lw      $t9,12($sp)        # load the value of y

    # draw [+x,+y]
    	add     $a0,$t8,$s0
    	add     $a1,$t9,$s1
    	jal     setpixel

    # draw [+y,+x]
   	add     $a0,$t8,$s1
    	add     $a1,$t9,$s0
    	jal     setpixel

    # draw [-x,+y]
    	sub     $a0,$t8,$s0
    	add     $a1,$t9,$s1
    	jal     setpixel

    # draw [-y,+x]
    	add     $a0,$t8,$s1
    	sub     $a1,$t9,$s0
    	jal     setpixel

    # draw [-x,-y]
    	sub     $a0,$t8,$s0
    	sub     $a1,$t9,$s1
    	jal     setpixel

    # draw [-y,-x]
    	sub     $a0,$t8,$s1
    	sub     $a1,$t9,$s0
    	jal     setpixel

    # draw [+x,-y]
    	add     $a0,$t8,$s0
    	sub     $a1,$t9,$s1
    	jal     setpixel

    # draw [+y,-x]
    	sub     $a0,$t8,$s1
    	add     $a1,$t9,$s0
    	jal     setpixel

    	lw      $ra,0($sp)
    	addi    $sp,$sp,4
    	jr      $ra

# setpixel -- draw pixel on display
#
# arguments:
#   a0 -- X coord
#   a1 -- Y coord
#
# clobbers:
#   v0 -- bitmap offset/index
#   v1 -- bitmap address
# trace:
#   v0,a0
setpixel:
   

setpixel_go:
    	lw      $v0,dpy_width           # off = display width

   	mul     $v0,$a1,$v0             # off = y * width
    	add     $v0,$v0,$a0             # off += x
    	sll     $v0,$v0,2               # convert to offset

    	lw      $v1,dpy_base            # ptr = display base address
    	add     $v1,$v1,$v0             # ptr += off

    	move    $v0, $a2           	# color
    	sw      $v0,($v1)               # store pixel
    	jr      $ra
