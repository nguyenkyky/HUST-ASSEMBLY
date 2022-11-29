.data
	
	mes1:	.asciiz	"Nhap so phan tu N: "
	mes2:	.asciiz	"Nhap vao cac gia tri cua mang N phan tu : " 
	mes3: 	.asciiz	"Cac chu so xuat hien it nhat la : "
	mes4:	.asciiz	"\n"
	a:	.word

.text
	# Nhap N
	li	$v0, 4
	la	$a0, mes1
	syscall
	li	$v0, 5
	syscall
	add	$s0, $v0, $zero	# s0 = n
	li 	$v0 , 4
	la	$a0 , mes2
	
	# t2 : address of a
	la	$s1, a
	
	# set address of a[0] to be divided by 4
	srl	$t1, $s1, 2
	sll	$t1, $t1, 2
	addi	$s1, $t1, 4
	
	add	$t0, $zero, $zero # t0 = i = 0
	add	$t2, $s1, $zero	# t2 = s1 = address of arr[i]
	
	input_loop:
		slt	$t1, $t0, $s0
		beq	$t1, $zero, end_input # if i == n then end_input
		li	$v0, 5
		syscall
		sw	$v0, 0($t2) # store value of arr[i]
		addi	$t2, $t2, 4 # t2 = address of arr[i + 1]
		addi	$t0, $t0, 1 # i = i + 1
		j 	input_loop
	end_input:
	
	add	$s2, $t2, $zero	# s2 is address of res[0], res[i] is number of occurence of i in arr
	
	main:
		add	$t0, $zero, $zero 	# i = t0 = 0
		add	$t2, $s1, $zero	# t2 = s1 = address of arr[i]
		addi	$t3, $zero, 10	# t3 = 10
		loop:
			slt	$t1, $t0, $s0
			beq	$t1, $zero, end # if i == n then end
			lw	$t4, 0($t2) # t4 = arr[i]
			addi	$t2, $t2, 4 # t2 = address of a[i + 1]
			addi	$t0, $t0, 1 # i = i + 1
			
			
			addi	$sp, $sp, -8	#tao 2 vi tri stack
			sw	$t4, 0($sp)
			jal	process	
			j 	loop	
			
		end:
			j	print_result
		
		process:
			sw	$ra, 4($sp) # store $ra to sp + 4
			lw	$t5, 0($sp) # t5 = x in process(x)
			slt	$t1, $t5, $t3
			bne	$t1, $zero, main_process # if x < 10 then main_process
			# if x >= 10
			div	$t5, $t3
			mflo	$t5 # t5 = x / 10
				
			addi	$sp, $sp, -8
			sw	$t5, 0($sp)
			jal 	process
			
		main_process:
			lw	$t5, 0($sp)
			div	$t5, $t3		# t5 / 10
			mfhi	$t5		# remainder
			sll	$t5, $t5, 2	
			add	$t5, $t5, $s2	# t5 is address of res[x]
			lw	$t6, 0($t5)	# t6 = res[x]
			addi	$t6, $t6, 1	# t6 = res[x] + 1
			sw	$t6, 0($t5)	# res[x] = res[x] + 1
				
				# jump back to $ra
			lw	$ra, 4($sp) # load $ra 
			addi	$sp, $sp, 8
			jr	$ra
		print_result:
			addi	$t0, $zero, 1	# i = t0 = 1
			lw	$t4, 0($s2)	# t4 = res[0] = current min
				
			addi	$s3, $zero, 10	# s3 = 10
			loop_result:
				slt	$t1, $t0, $s3
				beq	$t1, $zero, get_all_min
				sll	$t2, $t0, 2
				add	$t2, $s2, $t2	# t2 is address of res[i]
				lw	$t2, 0($t2)	# t2 = res[i]
				beq	$t2, $zero, continue_result	# if res[i] == 0 then continue;
				slt	$t3, $t2, $t4	# t3 = (t2 < min)
				bne	$t3, $zero, update_result		#t2 < t4 -> update
				beq	$t4, $zero, update_result		#res[0] = 0 -> update
				addi	$t0, $t0, 1	# i = i + 1
				j	loop_result
			
			continue_result:
				addi	$t0, $t0, 1	# i = i + 1
				j	loop_result
			
			update_result:
				add	$t4, $t2, $zero	# update min = res[i]
				addi	$t0, $t0, 1	# i = i + 1
				j 	loop_result
			
		get_all_min:
			addi	$t0, $zero, 0	# i = t0 equals 0
			addi	$t2, $zero, 10	# t2 equals 10
			addi	$s3, $s2, 40	# s3 is based address of final output, final output is an array
			addi	$t3, $s3, -4	# t3 = s3 - 4
			addi	$s4, $zero, 0	# s4 is length of final output array
			get_all_min_loop:
				slt	$t1, $t0, $t2	# t1 = (t0 < 10)
				beq	$t1, $zero, end_result
				sll	$t1, $t0, 2
				add	$t1, $t1, $s2	# t1 is address of res[i]
				lw	$t1, 0($t1)	# t1 = res[i]
				beq	$t1, $t4, add_to_final_output	# if res[i] = current min then add i to final output array
				addi	$t0, $t0, 1	# i = i + 1
				j	get_all_min_loop
				
			add_to_final_output:
				addi	$t3, $t3, 4	# increase address in final output array
				addi	$s4, $s4, 1	# increase final output length
				sw	$t0, 0($t3)	# store i to current address in final output array
				addi	$t0, $t0, 1	# i = i + 1
				j	get_all_min_loop
				
		end_result:
			addi	$t0, $zero, 0	# i = t0 = 0
			li	$v0 , 4
				la	$a0 , mes3
				syscall
			end_result_loop:
				slt	$t1, $t0, $s4	# t1 = (t0 < s4)
				beq	$t1, $zero, get_A_plus
				sll	$t1, $t0, 2
				add	$t1, $t1, $s3
				lw	$t1, 0($t1)
				li	$v0, 1
				add	$a0, $t1, $zero
				syscall
				li	$v0 , 4
				la	$a0 , mes4
				syscall	
				addi	$t0, $t0, 1
				j	end_result_loop
			get_A_plus:	# end of program