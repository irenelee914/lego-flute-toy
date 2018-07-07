.equ AUDIO, 0xFF203040
.equ addr_JP1, 0xFF200060
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ JP1_DataReg, 0
.equ JP1_DirReg, 0x07f557ff
.equ TERMINAL, 0XFF201000
.equ JTAG_DR, 0
.equ JTAG_CR, 4
 .equ CTRL, 0
 .equ FIFO, 4
 .equ LEFT, 8
 .equ RIGHT, 12

# Note Assignments w/ Freq
.equ f_C4, 92
.equ f_D, 82
.equ f_E, 73
.equ f_F, 69
.equ f_G, 61
.equ f_A, 54
.equ f_B, 49
.equ f_C, 46
.equ f_h_D, 41
.equ f_h_E, 36
.equ f_h_F, 34
.equ f_h_G, 31

# Fingering
.equ fingering_C4, 0b00010 #CHANGED
.equ fingering_D, 0b01111
.equ fingering_E, 0b01110 #CHANGED
.equ fingering_F, 0b00110 #CHANGED
.equ fingering_G, 0b10111 #CHANGED
.equ fingering_A, 0b00011
.equ fingering_B, 0b11011 #CHANGED
.equ fingering_C, 0b00111
.equ fingering_h_D, 0b11110 #CHANGED
.equ fingering_h_E, 0b01011
.equ fingering_h_F, 0b10011
.equ fingering_h_G, 0b11010 #CHANGED

.align 2
.data
last_position: .word 0b11111

current_note: .word 'E'

 track: .word 1 #phase
        .word 1 #sample
   		.word 0 #amp

    .section .exceptions, "ax"
 Interrupt: 
    subi sp,sp, 28 #change sp
 	stw r9,0(sp)
    stw r5,4(sp)
    stw r4,8(sp) 
    stw r2,12(sp)
    stw r3,16(sp)
    stw r7,20(sp)
	stw r20,24(sp)

    keep_track:
    ldw r5,0(r17) #load r5 with current phase
    beq r5,r0,EXIT_if_FULL_PHASE1

	PHASE_IS_1:
	stw r6,4(r17) #store sample
	stw r0,0(r17) #change phase==0

	mic:
	movia r8,AUDIO
	ldwio r4,8(r8)
	movia r2,0x60000000
	blt r4,r2,mic
	ldwio r4,12(r8)
	blt r4,r2,mic

	movia r4,0x60000000
	stw r4,8(r17)	

    EXIT_if_FULL_PHASE1:
    ldwio r2, 4(r8)
    andhi r3, r2, 0xff00
    beq r3, r0, EXIT
    andhi r3, r2, 0xff
    beq r3, r0, EXIT

    phase1:
 	ldw r5,4(r17) #load r5 with current sample index
 	ldw r4,8(r17) #load r4 with current amplitude
    stwio r4, 8(r8)
    stwio r4, 12(r8)
    subi r5, r5, 1
    stw r5,4(r17) #update sample index
    bne r5, r0, EXIT_if_FULL_PHASE1
	movia r7,0x60000000	
	bne r4,r7, change_phase #branch if amp is negative

    #if sample index==0
    stw r6,4(r17) #reload sample index

    
    phase2:
 	ldw r4,8(r17) #get current amp
    sub r4, r0, r4
 	stw r4,8(r17) #update amplitude to inverse/negative amp 
    br EXIT_if_FULL_PHASE1

   change_phase:
	movia r7,1	
	stw r7, 0(r17) #change phase==1

	

   

    EXIT:
    ldw r9,0(sp)
    ldw r5,4(sp)
    ldw r4,8(sp) 
    ldw r2,12(sp)
    ldw r3,16(sp)
    ldw r7,20(sp)
	ldw r20,24(sp)
 	addi sp, sp, 28 
 	subi ea, ea, 4
 	eret

   

   

    .section .text
    .global _start
     _start:
	 
	 
movia r2,ADDR_VGA
  movia r3, ADDR_CHAR
  movui r4,0xffff  /* White pixel */
  movi  r5, 'P'
  stbio r5,3491(r3)

  movi  r5, '1'
  stbio r5,3492(r3)

    movi  r5, 'E'
  stbio r5,3493(r3)

    movi  r5, 'A'
  stbio r5,3494(r3)

    movi  r5, 'S'
  stbio r5,3495(r3)

    movi  r5, 'E'
  stbio r5,3496(r3)

    movi  r5, 'G'
  stbio r5,3620(r3)

    movi  r5, 'I'
  stbio r5,3621(r3)

    movi  r5, 'V'
  stbio r5,3622(r3)

    movi  r5, 'E'
  stbio r5,3623(r3)

    movi  r5, 'U'
  stbio r5,3750(r3)

    movi  r5, 'S'
  stbio r5,3751(r3)

    movi  r5, 'V'
  stbio r5,3877(r3)

    movi  r5, 'G'
  stbio r5,3878(r3)

    movi  r5, 'A'
  stbio r5,3879(r3)

    movi  r5, 'M'
  stbio r5,4004(r3)

    movi  r5, 'A'
  stbio r5,4005(r3)

    movi  r5, 'R'
  stbio r5,4006(r3)

    movi  r5, 'K'
  stbio r5,4007(r3)

    movi  r5, 'S'
  stbio r5,4008(r3)
	 
	
	 
    movia sp, 0x00400000

		Initialize_SENSORS_JP1:
        movia r8, addr_JP1

        # set DIR
        movia r9,JP1_DirReg
        stwio r9,4(r8)

        # set Threshold Value=F to sensor0
        movia r9,0b00000111101001010101001111111111    # 0b 0 0000 1111 0 1 0 01 01 01 01 00 1111111111
        stwio r9,0(r8) #store

        # set Threshold Value=F to sensor1
        movia r9,0b00000111101001010100011111111111    # 0b 0 0000 1111 0 1 0 01 01 01 00 01 1111111111
        stwio r9,0(r8) #store

        # set Threshold Value=F to sensor12
        movia r9,0b00000111101001010001011111111111    # 0b 0 0000 1111 0 1 0 01 01 00 01 01 1111111111
        stwio r9,0(r8) #store

        # set Threshold Value=F to sensor3
        movia r9,0b00000111101001000101011111111111    #  0b 0 0000 1111 0 1 0 01 00 01 01 01 1111111111
        stwio r9,0(r8) #store

        # set Threshold Value=F to sensor4
        movia r9,0b00000111101000010101011111111111    # 0b 0 0000 1111 0 1 0 00 01 01 01 01 1111111111
        stwio r9,0(r8) #store

        # goto STATE MODE and disable sensors
         movia r9,0b00000000010001010101011111111111
         stwio r9,0(r8) #store






    #initialize Interrupt for Audio
    movia r8, AUDIO
    movia r9, 2 #enable write interrupt
    stwio r9, CTRL(r8)
	movia r6,1
    movia r17, track

    #initialize processor interrupt
    movia r9,0x40 #IRQ 8 and 6
    wrctl ctl3,r9
    movia r9,1
    wrctl ctl0,r9
 
 	movia r4, 0x60000000 # Amplitude/volume
  	stw r4,8(r17)




    Write_to_audio1:
	# get contents of lego DR
    movia r18, addr_JP1
    ldwio r18, JP1_DataReg(r18)
    # shift to isolate for top 5 bits
    srli r18, r18, 27

    # these two registers will point to the current node and freq
    movia r12, current_note
    movia r13, last_position

    # check which sensors have been tripped
	ldw r9, 0(r13)
    beq r18, r9, skip # skip if this note = last note
    movi r9, fingering_C4
    beq r18, r9, C4
    movi r9, fingering_D
    beq r18, r9, D
    movi r9, fingering_E
    beq r18, r9, E
    movi r9, fingering_F
    beq r18, r9, F
    movi r9, fingering_G
    beq r18, r9, G
    movi r9, fingering_A
    beq r18, r9, A
    movi r9, fingering_B
    beq r18, r9, B
    movi r9, fingering_C
    beq r18, r9, C
    movi r9, fingering_h_D
    beq r18, r9, h_D
    movi r9, fingering_h_E
    beq r18, r9, h_E
    movi r9, fingering_h_F
    beq r18, r9, h_F
    movi r9, fingering_h_G
    beq r18, r9, h_G
    br Other

  C4:
    movi r6, f_C4
    movia r9, 'C'
    stw r9, 0(r12)
    br print_char
  D:
    movi r6, f_D
    movia r9, 'D'
    stw r9, 0(r12)
    br print_char
  E:
    movi r6, f_E
    movi r9, 'E'
    stw r9, 0(r12)
    br print_char
  F:
    movi r6, f_F
    movi r9, 'F'
    stw r9, 0(r12)
    br print_char
  G:
    movi r6, f_G
    movi r9, 'G'
    stw r9, 0(r12)
    br print_char
  A:
    movi r6, f_A
    movi r9, 'A'
    stw r9, 0(r12)
    br print_char
  B:
    movi r6, f_B
    movi r9, 'B'
    stw r9, 0(r12)
    br print_char
  C:
    movi r6, f_C
    movi r9, 'C'
    stw r9, 0(r12)
    br print_char
  h_D:
    movi r6, f_h_D
    movi r9, 'D'
    stw r9, 0(r12)
    br print_char
  h_E:
    movi r6, f_h_E
    movi r9, 'E'
    stw r9, 0(r12)
    br print_char
  h_F:
    movi r6, f_h_F
    movi r9, 'F'
    stw r9, 0(r12)
    br print_char
  h_G:
    movi r6, f_h_G
    movi r9, 'G'
    stw r9, 0(r12)
    br print_char
  Other:
	movi r6, 1
    movi r9, 'Z'
    stw r9, 0(r12)
  

	print_char:
	stw r18, 0(r13)

	movia r20, TERMINAL
	call check_WRITE_FIFO
	movi r5,27
	call check_WRITE_FIFO
	stwio r5,0(r20)
	movi r5,'['
	call check_WRITE_FIFO
	stwio r5,0(r20)
	movi r5,'2'
	call check_WRITE_FIFO
	stwio r5,0(r20)
	movi r5,'J'
	call check_WRITE_FIFO
	stwio r5,0(r20)
	ldb r5,0(r12)
	call check_WRITE_FIFO
	stwio r5,0(r20)

	skip:
	br Write_to_audio1

	check_WRITE_FIFO:
	addi sp,sp,-8
	stw ra,0(sp)
	stw r22,4(sp)

	movia r20,TERMINAL
	ldwio r22,4(r20)
	srli r22,r22,16
	beq r22,r0,check_WRITE_FIFO

	ldw r22,4(sp)
	ldw ra,0(sp)
	addi sp,sp,8
	ret






   
