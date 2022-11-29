.eqv MONITOR_SCREEN 0x10010000
.eqv RED            0x00FF0000
.eqv GREEN          0x0000FF00
.eqv BLUE           0x000000FF
.eqv WHITE          0x00FFFFFF
.eqv YELLOW         0x00FFFF00
.eqv KEYCODE	 0xFFFF0004
.eqv KEYREADY	 0xFFFF0000


.data
frameBuffer: 	.space 	0x80000		# 512 wide x 256 high pixels
duoi:		.word	6000		# location of duoi 
dau: 		.word 	4720		# location of dau
snakeUp:		.word	0x000000ff	# snake moving up
snakeDown:	.word	0x010000ff	# snake moving down
snakeLeft:	.word	0x020000ff	# snake moving left
snakeRight:	.word	0x030000ff	# snake moving right
appleX	: 	.word 	40		# First Column
appleY	:	.word	20		# First Row
applecolor:	.word	0x00ff0000	# Red color
xConvert:		.word	64		# Convert (x,y) to Address
yConvert:		.word	4		# Convert (x,y) to Address



.text

VeKhung:
	
	# Top wall 
	la	$t0, frameBuffer		# load frame buffer addres
	addi	$t1, $zero, 64		# t1 = 64 length of row
	la 	$t2, YELLOW		# load YELLOW color
KhungTop:
	sw	$t2, 0($t0)		
	addi	$t0, $t0, 4		# go to next pixel
	addi	$t1, $t1, -1		# decrease pixel count
	bnez	$t1, KhungTop		# repeat unitl pixel count == 0
	
	# Bottom wall 
	la	$t0, frameBuffer		# load frame buffer addres
	addi	$t0, $t0, 7936		# set pixel to be near the bottom left
	addi	$t1, $zero, 64		# t1 = 512 length of row

KhungBot:
	sw	$t2, 0($t0)		
	addi	$t0, $t0, 4		# go to next pixel
	addi	$t1, $t1, -1		# decrease pixel count
	bnez	$t1, KhungBot		# repeat unitl pixel count == 0
	
	# Left wall 
	la	$t0, frameBuffer		# load frame buffer address
	addi	$t1, $zero, 32		# t1 = 512 length of col

KhungLeft:
	sw	$t2, 0($t0)		
	addi	$t0, $t0, 256		# go to next pixel
	addi	$t1, $t1, -1		# decrease pixel count
	bnez	$t1, KhungLeft		# repeat unitl pixel count == 0
	
	# Right wall 
	la	$t0, frameBuffer		# load frame buffer address
	addi	$t0, $t0, 252		# make starting pixel top right
	addi	$t1, $zero, 32		# t1 = 512 length of col

KhungRight:
	sw	$t2, 0($t0)		
	addi	$t0, $t0, 256		# go to next pixel
	addi	$t1, $t1, -1		# decrease pixel count
	bnez	$t1, KhungRight		# repeat unitl pixel count == 0
	
	
	### Ve ran theo huong di len
	la	$t0, frameBuffer		# load frame buffer address
	lw	$s2, duoi			# s2 = dia chi duoi ran
	lw	$s3, snakeUp		# s3 = mau ran ( xanh di len )
	
	add	$t1, $s2, $t0		# t1 = dia chi ran tren bitmap
	sw	$s3, 0($t1)		# ve duoi ran
	addi	$t1, $t1, -256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, -256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, -256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, -256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, -256		# set t1 to pixel above
	sw	$s3, 0($t1)		# ve dau ran
	
	jal	drawApple
	
	
	## Nhap vao ' a , s , w , d ' de khoi dong 
	li	$k0 , KEYCODE
	li	$k1 , KEYREADY
firstloop:	 	nop
	

ReadKey:     
	lw	$t3, 0($k0)
	beq	$t3, 100, mainLoop		# if key press = 'd' branch to moveright
	beq	$t3, 119, mainLoop		# key = w
	beq	$t3, 97, mainLoop		# key = a
	beq	$t3, 115, Convert		# else if key press = 's' convert the snake
	j	firstloop
	
Convert:
	lw	$t1 , dau			# dia chi dau
	addi	$t1 , $t1 , 1280		# Dau = Duoi
	lw	$t2 , duoi		# dia chi duoi
	addi	$t2 , $t2 , -1280		# Duoi = Dau
	sw	$t1 , dau			# Save
	sw	$t2 , duoi		# Save
		
	la	$t0, frameBuffer		# load frame buffer address
	lw	$s2, duoi			# s2 = dia chi ran
	lw	$s3, snakeDown		# s3 = mau ran ( xanh )
	add	$t1, $s2, $t0		# t1 = dia chi ran tren bitmap
	sw	$s3, 0($t1)		# ve duoi ran
	addi	$t1, $t1, 256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, 256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, 256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, 256		
	sw	$s3, 0($t1)		
	addi	$t1, $t1, 256		# set t1 to pixel under
	sw	$s3, 0($t1)		# ve dau ran
	
	j	mainLoop
	
mainLoop:

	lw	$t3, 0xffff0004		# get keypress from keyboard input
	
mainLoop1:
	### Sleep 
	addi	$v0, $zero, 32	
	addi	$a0, $zero, 60
	syscall
	
	
	beq	$t3, 100, moveRight		# key = ' d '
	beq	$t3, 119, moveUp		# if key press = 'w' branch to moveUp
	beq	$t3, 97, moveLeft		# key = ' a '
	beq	$t3, 115, moveDown		# key = ' s '
	
	
	moveUp:
	lw	$s3, snakeUp		# s3 = direction of snake
	add	$a0, $s3, $zero		# a0 = direction of snake
	jal	updateSnake
	lw	$t3, 0xffff0004
	beq	$t3, 115, ChangetomoveUp
	j	Loop 	
	
ChangetomoveUp:
	addi	$t3 , $t3 , 4
	j	mainLoop1
	
	moveDown:
	lw	$s3, snakeDown		# s3 = direction of snake
	add	$a0, $s3, $zero		# a0 = direction of snake
	jal	updateSnake
	lw	$t3, 0xffff0004
	beq	$t3, 119, ChangetomoveDown
	j	Loop
	
ChangetomoveDown:
	addi	$t3 , $t3 , -4
	j	mainLoop1
	
	moveLeft:
	lw	$s3, snakeLeft		# s3 = direction of snake
	add	$a0, $s3, $zero		# a0 = direction of snake
	jal	updateSnake
	lw	$t3, 0xffff0004
	beq	$t3, 100, ChangetomoveLeft
	j	Loop
	
ChangetomoveLeft:
	addi	$t3 , $t3 , -3
	j	mainLoop1
	
	moveRight:
	lw	$s3, snakeRight		# s3 = direction of snake
	add	$a0, $s3, $zero		# a0 = direction of snake
	jal	updateSnake
	lw	$t3, 0xffff0004
	beq	$t3, 97, ChangetomoveRight
	j	Loop
	
ChangetomoveRight:
	addi	$t3 , $t3 , 3
	j 	mainLoop1

Loop:
	j 	mainLoop			# loop back to beginning			
	
	
	
updateSnake:
	
	addiu 	$sp, $sp, -4		# Tao vi tri tren stack
	sw 	$ra, 0($sp)		# Save $ra
	
	### CHANGE HEAD DiRECTION
	lw	$t0 , dau
	la 	$t1, frameBuffer		# load frame buffer address
	add	$t2, $t0, $t1		# t2 = Address of Dau in bitmap
	sw	$a0, 0($t2)		# ve dau ran = a0 = s3 ban dau` nhap vao
	lw	$t4, 0($t2)		# save dau` = t4
	add	$s4 , $a0 , $zero
	
	
	#Kiem tra huong di
	lw	$t0 , snakeUp
	beq	$t0 , $a0 , NewHeadUp
	lw	$t0 , snakeDown
	beq	$t0 , $a0 , NewHeadDown
	lw	$t0 , snakeLeft
	beq	$t0 , $a0 , NewHeadLeft
	lw	$t0 , snakeRight
	beq	$t0 , $a0 , NewHeadRight
	
	
NewHeadUp:
	lw 	$t0 , dau			# Vi tri cua dau
	addi	$t0 , $t0 , -256		# Dau moi ben tren dau cu
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1		# Dia chi cua dau moi tren bitmap
	lw	$t4 , 0($t2)		# Lay ra mau hien tai cua dau moi
	j	CheckWall 		# Kiem tra xem mau hien tai co phai wall hay khong
	
NewHeadDown:
	lw 	$t0 , dau
	addi	$t0 , $t0 , 256
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1
	lw	$t4 , 0($t2)
	j	CheckWall 
	
NewHeadLeft:
	lw 	$t0 , dau
	addi	$t0 , $t0 , -4
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1
	lw	$t4 , 0($t2)
	j	CheckWall 
	
NewHeadRight:
	lw 	$t0 , dau
	addi	$t0 , $t0 , 4
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1
	lw	$t4 , 0($t2)
	j	CheckWall
	
CheckWall:
 	la	$t2 , YELLOW			# Wall color = YELLOW
	bne	$t2 , $t4 , CheckTao		# NewHead = Wall color => exit
	addi 	$v0, $zero, 10			# exit the program
	syscall
	
CheckTao:
	lw	$t2 , applecolor			# apple color  = red
	bne	$t2 , $t4 , CheckExit		# NewHead = Red ?
	jal	randomApple			# Random Position of Apple
	jal 	drawApple				# Draw Apple
	j 	CheckDirection			# Insert NewHead and JumpBack to Update Snake
	
CheckExit:
	li	$t2, 0x00000000			# Black color
	beq	$t2, $t4, validHeadSquare		# NewHead = Black => ValidHead
	
	addi 	$v0, $zero, 10			# Truong hop cuoi cung, NewHead != Red != Yellow != Black => ran dam phai chinh minh
	syscall					# Exit
	
	
validHeadSquare:

	lw	$t0 , snakeUp			# Kiem tra huong dang di cua ran
	beq	$t0 , $a0 , InsertUp
	lw	$t0 , snakeDown
	beq	$t0 , $a0 , InsertDown
	lw	$t0 , snakeLeft
	beq	$t0 , $a0 , InsertLeft
	lw	$t0 , snakeRight
	beq	$t0 , $a0 , InsertRight
	
	
InsertUp:
	lw 	$t0 , dau				
	addi	$t0 , $t0 , -256
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1
	lw	$t4 , 0($t2)
	sw	$a0 , 0($t2)			# Ve dau ran tren bitmap
	j	XoaDuoi
	
InsertDown:
	lw 	$t0 , dau
	addi	$t0 , $t0 , 256
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1
	lw	$t4 , 0($t2)
	sw	$a0 , 0($t2)			# Ve dau ran tren bitmap
	j	XoaDuoi 
	
InsertLeft:
	lw 	$t0 , dau
	addi	$t0 , $t0 , -4
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1
	lw	$t4 , 0($t2)
	sw	$a0 , 0($t2)			# Ve dau ran tren bitmap
	j	XoaDuoi 
	
InsertRight:
	lw 	$t0 , dau
	addi	$t0 , $t0 , 4
	la	$t1 , frameBuffer
	add	$t2 , $t0 , $t1
	lw	$t4 , 0($t2)
	sw	$a0 , 0($t2)			# Ve dau ran tren bitmap
	j	XoaDuoi
	

XoaDuoi:

	lw	$t0, duoi				# t0 = vi tri duoi
	la 	$t1, frameBuffer			
	add	$t2, $t0, $t1			# t2 = dia chi duoi tren bitmap
	li 	$t3, 0x00000000			# load black color
	lw	$t4, 0($t2)			# Luu mau duoi hien tai  = t4 ( the hien huong di cua ran )
	sw	$t3, 0($t2)			# Xoa duoi ( thay the mau duoi hien tai = black )
	
	### Kiem tra huong di cua duoi ran
	lw	$t5, snakeUp			# t5 = di len
	beq	$t5, $t4, setNextTailUp		
	
	lw	$t5, snakeDown			# t5 = di xuong
	beq	$t5, $t4, setNextTailDown		
	
	lw	$t5, snakeLeft			# t5 = sang trai
	beq	$t5, $t4, setNextTailLeft		
	
	lw	$t5, snakeRight			# t5 = sang phai
	beq	$t5, $t4, setNextTailRight		
	
setNextTailUp:
	addi	$t0, $t0, -256			# duoi = duoi - 256
	sw	$t0, duoi				# store  duoi 
	j 	CheckDirection
setNextTailLeft:
	addi	$t0, $t0, -4			# duoi = duoi - 4
	sw	$t0, duoi				# store  tail 
	j 	CheckDirection
	
setNextTailDown:
	addi	$t0, $t0, 256			# duoi = duoi + 256
	sw	$t0, duoi				# store  duoi
	j 	CheckDirection
	
setNextTailRight:
	addi	$t0, $t0, 4			# duoi = duoi + 4
	sw	$t0, duoi				# store  duoi
	j 	CheckDirection
	
	
CheckDirection:
	# Kiem tra huong di cua dau ran
	lw	$t2, snakeUp			# Di len
	beq	$s4, $t2, UpDirection		
	
	lw	$t2, snakeDown			# Di xuong
	beq	$s4, $t2, DownDirection		
	
	
	lw	$t2, snakeLeft			# Sang trai
	beq	$s4, $t2, LeftDirection		
	
	lw	$t2, snakeRight			# Sang phai
	beq	$s4, $t2, RightDirection		
	
UpDirection:
	lw	$t0 , dau
	addi	$t0 , $t0 , -256			# Dau moi ben tren dau cu
	sw	$t0 , dau
	j	exitUpdateSnake
	
	
DownDirection:
	lw	$t0 , dau
	addi	$t0 , $t0 , 256			# Dau moi ben duoi dau cu
	sw	$t0 , dau
	j	exitUpdateSnake
	
	
LeftDirection:
	lw	$t0 , dau
	addi	$t0 , $t0 , -4			# Dau moi ben trai dau cu
	sw	$t0 , dau
	j	exitUpdateSnake


RightDirection:
	lw	$t0 , dau
	addi	$t0 , $t0 , 4			# Dau moi ben phai dau cu
	sw	$t0 , dau
	j	exitUpdateSnake
	

exitUpdateSnake:
	
	
	lw 	$ra, 0($sp)			# load caller's return address
	
	addiu 	$sp, $sp, 4			# restores caller's stack pointer
	jr 	$ra				# return to caller's code
	

	
drawApple :

	lw	$t0, appleX		# t0 = xPos of apple
	lw	$t1, appleY		# t1 = yPos of apple
	lw	$t2, xConvert		# t2 = 64
	mult	$t1, $t2			# appleY * 64
	mflo	$t3			# t3 = appleY * 64
	add	$t3, $t3, $t0		# t3 = appleY * 64 + appleX
	lw	$t2, yConvert		# t2 = 4
	mult	$t3, $t2			# (yPos * 64 + appleX) * 4
	mflo	$t0			# t0 = (appleY * 64 + appleX) * 4
	la 	$t1, frameBuffer		# load frame buffer address
	add	$t0, $t1, $t0		# t0 = (appleY * 64 + appleX) * 4 + frame address
	lw	$t4 , applecolor
	sw	$t4, 0($t0)		# store direction plus color on the bitmap display
	jr	$ra
	
	
randomApple :

	addi	$v0, $zero, 42		# random int 
	addi	$a1, $zero, 63		# 0-63
	syscall
	add	$t1, $zero, $a0		# random appleX
	addi	$v0, $zero, 42		# random int 
	addi	$a1, $zero, 31		# 0-31
	syscall
	add	$t2, $zero, $a0		# random appleY
	lw	$t3, xConvert		# t3 = 64
	mult	$t2, $t3			# random appleY * 64
	mflo	$t4			# t4 = random appleY * 64
	add	$t4, $t4, $t1		# t4 = random appleY * 64 + random appleX
	lw	$t3, yConvert		# t3 = 4
	mult	$t3, $t4			# (random appleY * 64 + random appleX) * 4
	mflo	$t4			# t1 = (random appleY * 64 + random appleX) * 4
	la 	$t0, frameBuffer		# load frame buffer address
	add	$t0, $t4, $t0		# t0 = (appleY * 64 + appleX) * 4 + frame address
	lw	$t5, 0($t0)		# t5 = value of pixel at t0
	li	$t6 , 0x00000000		# Black
	beq	$t5, $t6, exist		# Ton tai vi tri cua Apple
	j 	randomApple
	
	
exist:
	sw	$t1, appleX
	sw	$t2, appleY	
	jr	$ra
	
	

