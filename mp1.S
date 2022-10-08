
# mp1.S - missile-command version
# Good luck, and have fun!

.data
	
    # Constants for accessing the fields of a struct missile, 
    # struct missile is defined in rtc.h and mp1.h

	NEXT 	  = 0
	X	  = 4
	Y	  = 8
	VX	  = 12
	VY	  = 16
	DEST_X	  = 20
	DEST_Y	  = 24
	EXPLODED  = 28
	C	  = 32

    # Character to draw for an explosion - '@'

	EXPLOSION = 64


# Data shared between this file and rtc.c helper functions

# This '.globl' directive makes these symbols visible externally
.globl mp1_missile_list, base_alive, mp1_score ,cities

mp1_missile_list:	.long 0x0	# Head of list pointer
base_alive:		.long 0x0	# Array of 3 bytes, plus a padding byte
mp1_score:		.long 0x0	# Player's current score

# Data private to this  file

base_pic:     	    .string "/^^^\\"	# Picture of a live base
dead_base_pic: 	    .string "xxxxx"	# Picture of a dead base
crosshairs_x:		.long 0x0	# X-position of the crosshairs
crosshairs_y:		.long 0x0	# Y-position of the crosshairs

.text

# void mp1_poke(void);
# You can use this function to write to video memory.
#
# Interface: Register-based arguments (not C-style)
#    Inputs: %cl  - The byte you wish to write
#            %eax - Offset from the start of video memory that you wish
#                   to write to
#   Outputs: Text-mode video screen is written to at location %eax with
#            the byte in %cl
# Registers: Clobbers EDX

mp1_poke:
		movl    vmem_base_addr(,1),%edx
		movb    %cl,(%edx,%eax,1)
		ret
# jmp table
jump_table:
.long mp1_ioctl_startgame, mp1_ioctl_addmissile, mp1_ioctl_movexhairs, mp1_ioctl_getstatus, mp1_ioctl_endgame
#   ----------------- Exported functions ---------------------

# void mp1_rtc_tasklet(unsigned long garbage);
# Performs three tasks:
#	(1) updates the list of missiles (implement this in update_missiles,
#           below, and call it from here).
#	(2) Redraw the bases - they may have been overwritten with missiles
#	(3) Redraw the crosshairs - it may have been overwritten with missiles
# Inputs   : none
# Outputs  : none
# Registers: Standard C calling convention

.globl mp1_rtc_tasklet
mp1_rtc_tasklet:
	pushl %ebp
 	movl %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI
# track the linked list
# caller-saved
	pushl %eax
	pushl %ecx
	pushl %edx
	call update_missiles
	popl %edx
	popl %ecx
	popl %eax
draw_cities: # check the alive city
	MOVL base_alive, %EBX
	TEST $0x000000FF,%EBX # check the first city
	JZ draw_deadcity20 # jmp to next compare if the first one is dead
draw_city20:
	movl $base_pic,%EDI # EDI=base_pic
	MOVL $18,%ESI
loop20a: 
	movb (%EDI),%cl
	pushl $24  # y
	pushl %ESI # x
	call draw
	ADDL $8,%esp # 
	ADDL $1,%ESI # x++
	ADDL $1,%EDI # p(c)++
	CMPL $23,%ESI # ESI-23
	JB loop20a
	JMP compare_40
draw_deadcity20:
	movl $dead_base_pic,%EDI # EDI=dead base_pic
	MOVL $18,%ESI
loop20d: 
	movb (%EDI),%cl
	pushl $24  # y
	pushl %ESI # x
	call draw
	ADDL $8,%esp # 9or12?
	ADDL $1,%ESI # x++
	ADDL $1,%EDI # p(c)++
	CMPL $23,%ESI # ESI-23
	JB loop20d
compare_40:
	Test $0x0000FF00,%EBX
	JZ draw_deadcity40
draw_city40:
	movl $base_pic,%EDI # EDI=base_pic
	MOVL $38,%ESI
loop40a: 
	movb (%EDI),%cl
	pushl $24  # y
	pushl %ESI # x
	call draw
	ADDL $8,%esp # 9or12?
	ADDL $1,%ESI # x++
	ADDL $1,%EDI # p(c)++
	CMPL $43,%ESI # ESI-43
	JB loop40a
	JMP compare_60
draw_deadcity40:
	movl $dead_base_pic,%EDI # EDI=dead base_pic
	MOVL $38,%ESI
loop40d: 
	movb (%EDI),%cl
	pushl $24  # y
	pushl %ESI # x
	call draw
	ADDL $8,%esp # 
	ADDL $1,%ESI # x++
	ADDL $1,%EDI # p(c)++
	CMPL $43,%ESI # ESI-43
	JB loop40d
compare_60:
	Test $0x00FF0000,%EBX
	JZ draw_deadcity60
draw_city60:
	movl $base_pic,%EDI # EDI=base_pic
	MOVL $58,%ESI
loop60a: 
	movb (%EDI),%cl	
	pushl $24  # y
	pushl %ESI # x
	call draw
	ADDL $8,%esp # 9or12?
	ADDL $1,%ESI # x++
	ADDL $1,%EDI # p(c)++
	CMPL $63,%ESI # ESI-63
	JB loop60a
	JMP Cross
draw_deadcity60:
	movl $dead_base_pic,%EDI # EDI=dead base_pic
	MOVL $58,%ESI
loop60d: 
	movb (%EDI),%cl
	pushl $24  # y
	pushl %ESI # x
	call draw
	ADDL $8,%esp # 9or12?
	ADDL $1,%ESI # x++
	ADDL $1,%EDI # p(c)++
	CMPL $63,%ESI # ESI-63
	JB loop60d
Cross:
	movb $43,%cl
	pushl crosshairs_y
	pushl crosshairs_x
	call draw
	ADDL $8,%esp
DONE:
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
# int mp1_ioctl(unsigned long arg, unsigned int cmd)
# The dispatch function for the MP1 ioctls - should use the cmd argument
# and a jumptable to execute one of the specific ioctls implemented below.
# Inputs   : unsigned long arg - parameter to the mp1_ioctl_....
#          : unsigned int cmd  - specifies which mp1_ioctl_... function 
#          :                     to execute
# Outputs  : Returns an integer - depends on which ioctl() function is called
# Registers: Standard C calling convention
.globl mp1_ioctl
mp1_ioctl:
# choose by cmd
	MOVL 8(%esp),%ECX # ECX = cmd
# check if it is valid
	CMPL $0, %ECX
	JB invalid # cmd < 0
	CMPL $4, %ECX
	JA invalid # cmd > 4
	JMP *jump_table(,%ECX,4) # jump to function
	ret
invalid:
	MOVL $-1,%EAX
	ret
# ----------------- Functions private to this file -------------------
# void draw(unsigned long x, unsigned long y);
# Performs one task:
#	(1) calculate the offset and call mp1_poke to draw a character in the given position
# Inputs   : none
# Outputs  : none
draw: # draw(x,y)
	pushl %ebp
  	movl %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI

	MOVL 8(%ebp),%EBX # EBX=x
	iMULL $2,%EBX # EBX=x*2
	MOVL %EBX,%EAX
	MOVL 12(%ebp),%EBX # EBX=y
	iMULL $160,%EBX # EBX=160y
	ADDL %EBX,%EAX # EAX=EAX+EBX=offset
	call mp1_poke
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
# void update_missiles();
# Performs one task:
#	(1) calculat the information of all missiles and then draw it or clean it
# Inputs   : the text mode position x,y
# Outputs  : none
update_missiles:
	pushl		%ebp
	movl		%esp, %ebp
	pushl		%EBX
	pushl		%ESI
	pushl		%EDI
	MOVL mp1_missile_list, %EBX # EBX=(first) the first point with item
loop1: # through all the list
	CMPL $0, %EBX # check if it is null
	JE DONE
	CMPL $0,EXPLODED(%EBX)   # check if it is exploded
	JNE explod
# first clean those unexploded missiles 
clean: 
	pushl %EBX
	call mp1_clean
	ADDL $4,%esp
update: # update unexploded missiles 
	MOVL X(%EBX), %ESI
	ADDL VX(%EBX),%ESI
	MOVL %ESI, X(%EBX) # update x=x+vy
	MOVL Y(%EBX), %ESI
	ADDL VY(%EBX),%ESI
	MOVL %ESI, Y(%EBX) # update y=y+vy
compare1: # check if in the screen
	movl X(%EBX),%ESI
	movl Y(%EBX),%EDI
	roll $16,%ESI # make high 16b be the low 16b
	roll $16,%EDI
	andl $0x0000FFFF,%ESI # x=ESI
	andl $0x0000FFFF,%EDI # y=EDI
	CMPL $79,%ESI
	JA remove	# x>79
	CMPL $0,%ESI
	JB remove # x<0
	CMPL $24,%EDI
	JA remove # Y>24
	CMPL $0, %EDI
	JB remove # Y<0
compare2: # check if reach destination
	CMPL DEST_X(%EBX),%ESI
	JNE normal_move # x <> dest_x
	CMPL DEST_Y(%EBX),%EDI	# ESI=dest_y  
	JNE normal_move # y<>dest_y
# it has reached its detination 
	pushl %EBX
	call missile_explode
	ADDL $4,%esp
	CMPL $0,%EAX
	JE next2 # EAX=0
	pushl %EBX
	call mp1_notify_user
	addl $4,%esp
next2:
	MOVL NEXT(%EBX),%EBX  # EBX=M[EBX] next pointer
	JMP loop1
normal_move: # continue its move clean the 
			 # previous one and draw the new one
	pushl %EBX
	call mp1_draw
	ADDL $4,%esp
	MOVL (%EBX),%EBX
	JMP loop1
remove: # delete from the linked list
	pushl %EBX
	call mp1_clean
	popl %EBX
	MOVL (%EBX),%EDI
	pushl %EBX
	call mp1_missile_remove 
	ADDL $4, %esp
	MOVL %EDI,%EBX  # EBX= next pointer
	JMP loop1
explod: # it is exploded
	pushl %EBX
	call mp1_draw_exp
	popl %EBX
	pushl %EBX
	call missile_explode
	popl %EBX
	CMPL $0,%EAX
	JE next1
	pushl %EBX
	call mp1_notify_user
	popl %EBX	

next1:
	subL $1,EXPLODED(%EBX)
# how to draw exploding missiles?
	CMPL $0,EXPLODED(%EBX) # 00?
	JE remove
	MOVL (%EBX),%EBX  # EBX=M[EBX] next pointer
	JMP loop1

	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
# void mp1_ioctl_startgame();
# Performs one task:
#	(1) calculat the information of all missiles and then draw it or clean it
# Inputs   : the text mode position x,y
# Outputs  : none
mp1_ioctl_startgame:
	pushl %ebp
  	movl %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI
# initialize
	MOVL $0,mp1_missile_list # next(mp1_missile_list)=0
	movl $0, mp1_score
	movl $0x00111111,base_alive
	MOVL $12,crosshairs_y
	MOVL $40,crosshairs_x
# draw the crosshairs
	# movb $43,%cl
	# pushl crosshairs_y # crosshairs_y
	# pushl crosshairs_x # crosshairs_x
	# call draw
	# ADDL $8,%esp
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret

mp1_ioctl_addmissile:
	pushl %ebp
	MOVL %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI

	MOVL 8(%ebp),%EBX # EBX=pointer
	pushl $33 # 33b 32C
	call mp1_malloc
	ADDL $4,%esp
	pushl $33
	pushl %EBX # input point ()
	pushl %EAX
	call mp1_copy_from_user # (*to *from n)_
	CMPL $0,%EAX
	JNE failed
	popl %EAX
	ADDL $8, %esp
	# EAX=new struct pointer
	# add to list
	movl mp1_missile_list,%EDI # EDI= M[mp1_missile_list]=mp1_misslie_list->next
	movl %EDI,NEXT(%EAX) # nex
	movl %EAX,mp1_missile_list
	movl $0,%EAX
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
failed:
	pushl %EAX
	call mp1_free
	ADDL $4,%esp
	MOVL $-1,%EAX
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret

mp1_ioctl_movexhairs:
	pushl %ebp
	MOVL %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI
	movl 8(%ebp),%EBX
	cmpl $0,%EBX
	JE Donel
	andl $0,%EBX
	MOVW 8(%ebp),%BX # low 16x,high 16y
	MOVL crosshairs_x,%ESI #  ESI= previous x
	addw %BX,%SI # crossharis_x+
	CMPL $79, %ESI
	JA Donel # new x>79
	CMPL $0, %ESI
	JB Donel # new x<0
	andl $0,%EBX
	MOVL crosshairs_y,%EDI
	MOVW 10(%ebp),%BX
	addw %BX,%DI # crosshairs_y+
	CMPL $24,%EDI
	JA Donel
	CMPL $0, %EDI
	JL Donel
	movb $32,%cl # space
	pushl crosshairs_y
	pushl crosshairs_x # clean
	call draw
	ADDL $8,%esp
	MOVL %EDI,crosshairs_y
	MOVL %ESI,crosshairs_x
	movb $43,%cl
	pushl crosshairs_y # crosshairs_y
	pushl crosshairs_x # crosshairs_x
	call draw
	ADDL $8,%esp
Donel:
	MOVL $0,%EAX
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
mp1_ioctl_getstatus:
	pushl %ebp
	MOVL %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI
	pushl $4
	call mp1_malloc
	addl $4,%esp # EAX=a pointer to 4 bit space
	movl $0,%EDI
	MOVL 8(%ebp),%EBX # EBX= pointer to user_status
	movl $base_alive,%EDX
# test whether the city is alive
	cmpb $0,(%EDX)  # the first city
	JE city_2
	addl $1,%EDI
city_2:
	cmpb $0,1(%EDX)
	JE city_3
	addl $2,%EDI
city_3:
	cmpb $0,2(%EDX)
	JE get_score
	addl $4,%EDI
get_score:
	shll $16,%EDI # 18 17 16 bit represent the cities
	movl mp1_score,%EDX
	addw %DX,%DI # low 16bit represents scores
	movl %EAX,%ESI
	movl %EDI,(%ESI) # from address got
copy:	
	pushl $4
	pushl %ESI
	pushl %EBX
	call mp1_copy_to_user
	ADDL $12,%esp
	cmpl $0,%EAX
	JNE fail
	pushl %ESI # free pointer
	call mp1_free
	popl %ESI
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
fail:
	pushl %ESI # free pointer
	call mp1_free
	popl %ESI
	MOVL $-1,%EAX
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret

mp1_ioctl_endgame:
	pushl %ebp
	movl %esp,%ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI
freeloop:
	movl mp1_missile_list,%EBX
	cmpl $0,%EBX
	JE DONEend
	movl (%EBX),%ESI # next pointer
	movl %ESI,mp1_missile_list
	pushl %EBX
	call mp1_free
	addl $4,%esp
	JMP freeloop
DONEend:
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
# void missile_remove(*missile);
# Performs one task:
#	(1) delete the missile in the linked list 
# Inputs   : the pointer of the missile that should be deleted
# Outputs  : none
mp1_missile_remove:
	pushl %ebp
  	movl %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI

	MOVL 8(%ebp),%EBX # EBX=pointer
	MOVL mp1_missile_list,%ESI
	CMPL %EBX,%ESI # check if it is the head pointer
	JE changehead
# not head pointer
findloop:
	CMPL (%ESI),%EBX # check the point pointing to the current one
	JE removepointer
	MOVL (%ESI),%ESI # ESI=missle->next
	JMP findloop
removepointer: # ESI is the previous point
	MOVL (%EBX),%EDI # M[ESI]=M[EBX]
	MOVL %EDI,(%ESI)
	pushl %EBX	# free EBX 
	call mp1_free
	ADDL $4,%esp
	JMP Done
changehead:
	MOVL NEXT(%EBX),%EDI # the head should change second one be the head
	pushl %EBX
	call mp1_free
	addl $4,%esp
	movl %EDI,mp1_missile_list
Done:								 
	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
# void mp1_draw_exp(*missile);
# Performs one task:
#	(1) calculate the offset and call mp1_poke to draw a space in the given position for missile to move or leave
# Inputs   : the pointer of the missile
# Outputs  : none
mp1_clean:
	pushl %ebp
 	movl %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI

	movl 8(%ebp),%EBX
	MOVL X(%EBX),%ESI 
	roll $16,%ESI
	andl $0x0000FFFF,%ESI
	imull $2,%ESI 
	MOVL %ESI,%EAX # EAX=2*x
	MOVL Y(%EBX),%ESI
	roll $16,%ESI
	andl $0x0000FFFF,%ESI
	imull $160,%ESI
	movb $32,%cl
	ADDL %ESI,%EAX # EAX=EAX+160y
	call mp1_poke

	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
# void mp1_draw(*missile);
# Performs one task:
#	(1) calculate the offset and call mp1_poke to draw a character in the given position for any missiles
# Inputs   : the pointer of the missile
# Outputs  : none
mp1_draw:
	pushl %ebp
	movl %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI
	movl 8(%ebp),%EBX
	MOVL X(%EBX),%ESI 
	roll $16,%ESI
	andl $0x0000FFFF,%ESI #
	imull $2,%ESI 
	MOVL %ESI,%EAX # EAX=2*x
	MOVL Y(%EBX),%ESI
	roll $16,%ESI
	andl $0x0000FFFF,%ESI
	imull $160,%ESI
	ADDL %ESI,%EAX # EAX=EAX+160y
	movb C(%EBX),%cl
	call mp1_poke

	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret
# void mp1_draw_exp(*missile);
# Performs one task:
#	(1) calculate the offset and call mp1_poke to draw a character in the given position for an explosion
# Inputs   : the pointer of the missile
# Outputs  : none
mp1_draw_exp:
	pushl %ebp
	movl %esp, %ebp
	pushl %EBX
	pushl %ESI
	pushl %EDI
	movl 8(%ebp),%EBX
	MOVL X(%EBX),%ESI 
	roll $16,%ESI
	andl $0x0000FFFF,%ESI #
	imull $2,%ESI 
	MOVL %ESI,%EAX # EAX=2*x
	MOVL Y(%EBX),%ESI
	roll $16,%ESI
	andl $0x0000FFFF,%ESI
	imull $160,%ESI
	ADDL %ESI,%EAX # EAX=EAX+160y
	movb $64,%cl
	call mp1_poke

	popl %EDI
	popl %ESI
	popl %EBX
		leave
		ret