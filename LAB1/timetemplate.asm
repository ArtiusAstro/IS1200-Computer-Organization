# AA

.macro	PUSH(%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP(%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2 
mytime:	.word 0x4723
timstr:	.ascii 		"text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)		# get time
	addiu	$t0,$t0,1		# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)		# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
  
hexasc:
	addi	$v0, $0, 0x30	# 0x30 is the value for zero in ascii
	addi	$t0, $0, 0x9	# if a greater than 0x9, a+=0x7
	andi	$a2, $a2, 0xF	# remove all bits except the 4 lsb.
	ble	$a2, $t0, ascii	# branch for getting ascii A-F
	nop
	
	addi	$v0, $v0, 0x7	# skips a couple symbols to get to the letters
	
ascii:
	add	$v0, $a2, $v0	# get the ascii code and set it to return reg
	jr	$ra		# back to where we left off in main
	nop
	
delay:
	PUSH($a0)
	li	$t1,0		# i variable
	li	$t2,4711		# that constant
	
loop:
	ble	$a0,$0,done	# x ms later
	nop
	subi 	$a0,$0,1
	
for:
	ble	$t2,$t1,loop	# one ms later
	nop
	addi	$t1,$t1,1
	j	for
	nop
	
done:
	POP($a0)
	jr	$ra
	nop
time2string:
	PUSH($ra)	
	PUSH($s1)
	PUSH($s2)
	PUSH($s3)
	PUSH($s4)
	
	andi	$a1, $a1, 0xffff	# last 16
	srl	$s1,$a1,4		# seconds ten
	srl	$s2,$a1,8		# minutes one
	srl	$s3,$a1,12		# minutes ten
	addi	$s4,$0,0x3a	# store the code for :
	
	move	$a2,$s3		# argument is seconds one
	jal 	hexasc		# go to hexasc and link
	nop
	sb	$v0,0($a0)		# put a byte of the return into a0

	move	$a2,$s2		# argument is seconds one	
	jal 	hexasc		# go to hexasc and link
	nop
	sb	$v0,1($a0)		# put a byte of the return into a0

	sb	$s4,2($a0)		# store the :
	
	move	$a2,$s1		# argument is seconds one
	jal 	hexasc		# go to hexasc and link
	nop
	sb	$v0,3($a0)		# put a byte of the return into a0
	
	move	$a2,$a1		# argument is seconds one
	jal 	hexasc		# go to hexasc and link
	nop
	sb	$v0,4($a0)		# put a byte of the return into a0

	la	$s4,($0)		# null byte
	sb	$s4,5($a0)		# put a byte of the return into a0
	
	POP($s4)
	POP($s3)
	POP($s2)
	POP($s1)
	POP($ra)
	jr	$ra
	nop
