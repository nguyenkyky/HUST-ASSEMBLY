.eqv 	IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv 	OUT_ADRESS_HEXA_KEYBOARD  0xFFFF0014

.eqv 	HEADING 0xffff8010
.eqv 	MOVING 0xffff8050
.eqv 	LEAVETRACK 0xffff8020
.eqv 	WHEREX 0xffff8030
.eqv 	WHEREY 0xffff8040

.data
post1:	.word 90,3000,0,180,4000,0,180,3000,1,0,1500,0,45,2100,1,225,2100,0,135,2120,1,90, 1500, 0, 0, 2950, 1, 270, 800, 1, 90, 800, 0, 90, 800, 1, 90, 1000, 0, 180, 2950, 1, 0, 2950, 0, 150, 3000, 1, 30, 3000, 1, 180, 2950, 1, 90, 1500, 0,, 0, 2950, 1, 270, 800, 1, 90, 800, 0, 90, 800, 1, -1
post2:	.word 90,3000,0,180,4000,0, 90, 500, 0, 210, 3500, 1, 30, 2000, 0, 90, 1500, 1, 330, 1500, 1, 150, 3500, 1, 90, 1000, 0, 0, 3000, 1, 180, 1500, 0, 270, 1500, 1, 90, 1500, 0, 90, 1500, 1, 180, 1500, 0, 90, 2000, 0, 0, 3500, 1, 90, 1500, 1, 180, 1500, 1, 270, 1500, 1, 180, 2000, 0, 90, 2000, 0, 0, 3500, 1, 180, 3500, 0, 90, 1500, 1, 90, 1000, 0, 90, 1500, 1, 0, 1750, 1, 270, 1500, 1, 0, 1750, 1, 90, 1500, 1, -1
post3:	.word 90,3000,0,180,7500,0,0, 3500, 1, 180, 3500, 0, 90, 1500, 1, 90, 1500, 0, 0, 3500, 1, 180, 1750, 0, 45, 2400, 1, 225, 2400, 0, 135, 2450, 1, 90, 1500, 0, 0, 3500, 1, 180, 3500, 0, 90, 1500, 1, -1

log: .asciiz "No availabel postscript, please choose 0, 4 or 8 \n"

.text

# choosing processing

       li 	$t3, IN_ADRESS_HEXA_KEYBOARD
       li 	$t4, OUT_ADRESS_HEXA_KEYBOARD
main_choosing:
       addi 	$at, $0, 0x01
       sb 	$at, 0($t3)                     
       lb 	$t0, 0($t4)                     
       bne 	$t0, 0x11, not_0
                                          
       la 	$s0, post1			  
       j 	main                           
       
       not_0:
       addi 	$at, $0, 0x02
       sb 	$at, 0($t3)                     
       lb 	$t0, 0($t4)                     
       bne 	$t0, 0x12, not_4
                                          
       la 	$s0, post2       
       j 	main                            
       
       not_4:
       addi 	$at, $0, 0x04
       sb 	$at, 0($t3)                     
       lb 	$t0, 0($t4)                     
       bne 	$t0, 0x14, not_8
                                          
       la 	$s0, post3       
       j 	main                            
       
       not_8:         
       li 	$v0, 4
       la 	$a0, log
       syscall      
       
        li 	$v0, 32
        li 	$a0, 2000
        syscall 
       	j 	main_choosing                          
# <-- end choosing -->

# main process after choosing which post script

rotate:
	li	$t1, HEADING
	lw	$t2, 4($sp)
	sw	$t2, 0($t1)
	
	jr	$ra
	
track:
	li	$t1, LEAVETRACK
	lw	$t2, 12($sp)
	#li	$t2, 1
	sb	$t2, 0($t1)
	jr	$ra
	
moving:
	li	$t1, MOVING
	addi	$t2, $zero, 1
	sb	$t2, 0($t1)
	
	li	$v0, 32
	lw	$a0, 8($sp)
	syscall
	
	li	$t1, MOVING
	sb	$zero, 0($t1)
	
	jr	$ra
	
	
process:	# function process(heading, time, cut)
	addi	$sp, $sp, -16	# tao 2 vi tri trong stack
	sw	$ra, 0($sp)	# save $ra to $sp
	sw	$t1, 4($sp)	# save heading to $sp + 4
	sw	$t2, 8($sp)	# save time to $sp + 8
	sw	$t3, 12($sp)	# save cut to $sp + 12
	
	jal	rotate
	
	jal	track
	
	jal 	moving
	
	li	$t1, LEAVETRACK
	sb	$zero, 0($t1)
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 16
	jr	$ra	

main:

	li	$t0, 0	# i = 0
	li	$t7, -1
loop:
	sll	$t1, $t0, 2
	add	$t1, $s0, $t1	# t1 is address of post1[i]
	lw	$t1, 0($t1)	# t1 = post1[i]
	beq	$t1, $t7	, end	# if(post1[i] == -1) then end
	
	addi	$t0, $t0, 1	# i = i + 1
	sll	$t2, $t0, 2
	add	$t2, $s0, $t2
	lw	$t2, 0($t2)
	
	addi	$t0, $t0, 1	# i = i + 1
	sll	$t3, $t0, 2
	add	$t3, $s0, $t3
	lw	$t3, 0($t3)
	
	addi	$t0, $t0, 1	# i = i + 1
	
	jal	process
	j	loop
	

end:
	
	
	
	
	
	
