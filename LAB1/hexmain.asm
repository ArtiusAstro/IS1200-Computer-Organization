  # AA

	.text
main:
	li	$a0,42		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register
	
	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #
 
hexasc:
	
	addi	$v0, $0, 0x30	# 0x30 is the value for zero in ascii
	
	addi	$t0, $0, 0x9	# if a greater than 0x9, a+=0x7
	
	andi	$a0, $a0, 0xF	# remove all bits except the 4 lsb.
	
	ble	$a0, $t0, ascii	# branch for getting ascii A-F
	nop
	
	addi	$v0, $v0, 0x7	# skips a couple symbols to get to the letters
	
ascii:
	add	$v0, $a0, $v0	# get the ascii code and set it to return reg
	
	jr	$ra		# back to where we left off in main
	add	$ra,$0,$0		# reset ra

	




