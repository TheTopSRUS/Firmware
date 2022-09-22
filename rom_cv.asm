
;CodeVisionAVR C Compiler V2.04.8b Evaluation
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 5,120000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _On=R6
	.DEF _Off=R9
	.DEF _Fan1_Status=R8
	.DEF _Fan2_Status=R11
	.DEF _Fan3_Status=R10
	.DEF _PWM1_Value=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0xB:
	.DB  0xFF,0x3
_0x69:
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0xFF,0x3
_0x0:
	.DB  0x4E,0x4F,0x0,0x4F,0x4B,0x0,0x46,0x25
	.DB  0x64,0x25,0x64,0x0,0x50,0x25,0x64,0x25
	.DB  0x30,0x34,0x64,0x0,0x54,0x25,0x64,0x25
	.DB  0x30,0x33,0x64,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  _PWM2_Value
	.DW  _0xB*2

	.DW  0x08
	.DW  0x06
	.DW  _0x69*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V1.25.5 Professional
;Automatic Program Generator
;© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 01.10.2009
;Author  : F4CG
;Company : F4CG
;Comments:
;
;
;Chip type           : ATmega8
;Program type        : Application
;Clock frequency     : 16,000000 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 100
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0037 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0038 char status,data;
; 0000 0039 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 003A data=UDR;
	IN   R16,12
; 0000 003B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 003C    {
; 0000 003D    rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	RCALL SUBOPT_0x0
	ST   Z,R16
; 0000 003E    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(100)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 003F    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(100)
	CP   R30,R7
	BRNE _0x5
; 0000 0040       {
; 0000 0041       rx_counter=0;
	CLR  R7
; 0000 0042       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0043       };
_0x5:
; 0000 0044    };
_0x3:
; 0000 0045 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 004C {
_getchar:
; 0000 004D char data;
; 0000 004E while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 004F data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	RCALL SUBOPT_0x0
	LD   R17,Z
; 0000 0050 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(100)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0051 #asm("cli")
_0x9:
	cli
; 0000 0052 --rx_counter;
	DEC  R7
; 0000 0053 #asm("sei")
	sei
; 0000 0054 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0055 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;#include <delay.h>
;
;
;#define FIRST_ADC_INPUT 2
;#define LAST_ADC_INPUT 3
;unsigned char adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
;#define ADC_VREF_TYPE 0x20
;
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0067 {
_adc_isr:
	ST   -Y,R24
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0068 static unsigned char input_index=0;
; 0000 0069 // Read the 8 most significant bits
; 0000 006A // of the AD conversion result
; 0000 006B adc_data[input_index]=ADCH;
	LDS  R26,_input_index_S0000002000
	LDI  R27,0
	SUBI R26,LOW(-_adc_data)
	SBCI R27,HIGH(-_adc_data)
	IN   R30,0x5
	ST   X,R30
; 0000 006C // Select next ADC input
; 0000 006D if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
	LDS  R26,_input_index_S0000002000
	SUBI R26,-LOW(1)
	STS  _input_index_S0000002000,R26
	CPI  R26,LOW(0x2)
	BRLO _0xA
; 0000 006E    input_index=0;
	LDI  R30,LOW(0)
	STS  _input_index_S0000002000,R30
; 0000 006F ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
_0xA:
	LDS  R30,_input_index_S0000002000
	SUBI R30,-LOW(34)
	OUT  0x7,R30
; 0000 0070 // Delay needed for the stabilization of the ADC input voltage
; 0000 0071 delay_us(10);
	__DELAY_USB 17
; 0000 0072 // Start the AD conversion
; 0000 0073 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0074 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R24,Y+
	RETI
;
;
;
;// Declare your global variables here
;
;unsigned char On = 1;
;unsigned char Off = 0;
;unsigned char Fan1_Status;
;unsigned char Fan2_Status;
;unsigned char Fan3_Status;
;unsigned  int PWM1_Value = 0x3FF;;
;unsigned  int PWM2_Value = 0x3FF;;

	.DSEG
;unsigned char Tmp1_Value;
;unsigned char Tmp2_Value;
;
;
;
;unsigned char enterchar(void)
; 0000 0087 {

	.CSEG
_enterchar:
; 0000 0088 while(!rx_counter);
_0xC:
	TST  R7
	BREQ _0xC
; 0000 0089 return getchar();
	RCALL _getchar
	RET
; 0000 008A }
;
;unsigned int enterdata(unsigned char cnt)
; 0000 008D {
_enterdata:
; 0000 008E unsigned char i = 0;
; 0000 008F unsigned int k = 0;
; 0000 0090 unsigned char a;
; 0000 0091 
; 0000 0092 for (i=1; i<= cnt; i++)
	RCALL __SAVELOCR4
;	cnt -> Y+4
;	i -> R17
;	k -> R18,R19
;	a -> R16
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R17,LOW(1)
_0x10:
	LDD  R30,Y+4
	CP   R30,R17
	BRSH PC+2
	RJMP _0x11
; 0000 0093 {
; 0000 0094 a=enterchar();
	RCALL _enterchar
	MOV  R16,R30
; 0000 0095 
; 0000 0096 switch (a)
	MOV  R30,R16
; 0000 0097 {
; 0000 0098  case '1': { k = k*10+1; break;}
	CPI  R30,LOW(0x31)
	BRNE _0x15
	RCALL SUBOPT_0x1
	ADIW R30,1
	MOVW R18,R30
	RJMP _0x14
; 0000 0099  case '2': { k = k*10+2; break;}
_0x15:
	CPI  R30,LOW(0x32)
	BRNE _0x16
	RCALL SUBOPT_0x1
	ADIW R30,2
	MOVW R18,R30
	RJMP _0x14
; 0000 009A  case '3': { k = k*10+3; break;}
_0x16:
	CPI  R30,LOW(0x33)
	BRNE _0x17
	RCALL SUBOPT_0x1
	ADIW R30,3
	MOVW R18,R30
	RJMP _0x14
; 0000 009B  case '4': { k = k*10+4; break;}
_0x17:
	CPI  R30,LOW(0x34)
	BRNE _0x18
	RCALL SUBOPT_0x1
	ADIW R30,4
	MOVW R18,R30
	RJMP _0x14
; 0000 009C  case '5': { k = k*10+5; break;}
_0x18:
	CPI  R30,LOW(0x35)
	BRNE _0x19
	RCALL SUBOPT_0x1
	ADIW R30,5
	MOVW R18,R30
	RJMP _0x14
; 0000 009D  case '6': { k = k*10+6; break;}
_0x19:
	CPI  R30,LOW(0x36)
	BRNE _0x1A
	RCALL SUBOPT_0x1
	ADIW R30,6
	MOVW R18,R30
	RJMP _0x14
; 0000 009E  case '7': { k = k*10+7; break;}
_0x1A:
	CPI  R30,LOW(0x37)
	BRNE _0x1B
	RCALL SUBOPT_0x1
	ADIW R30,7
	MOVW R18,R30
	RJMP _0x14
; 0000 009F  case '8': { k = k*10+8; break;}
_0x1B:
	CPI  R30,LOW(0x38)
	BRNE _0x1C
	RCALL SUBOPT_0x1
	ADIW R30,8
	MOVW R18,R30
	RJMP _0x14
; 0000 00A0  case '9': { k = k*10+9; break;}
_0x1C:
	CPI  R30,LOW(0x39)
	BRNE _0x1D
	RCALL SUBOPT_0x1
	ADIW R30,9
	MOVW R18,R30
	RJMP _0x14
; 0000 00A1  case '0': { k = k*10+0; break;}
_0x1D:
	CPI  R30,LOW(0x30)
	BRNE _0x1F
	RCALL SUBOPT_0x1
	ADIW R30,0
	MOVW R18,R30
	RJMP _0x14
; 0000 00A2  default:{ i--; printf("NO"); }
_0x1F:
	SUBI R17,1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 00A3 }
_0x14:
; 0000 00A4 }
	SUBI R17,-1
	RJMP _0x10
_0x11:
; 0000 00A5 
; 0000 00A6 return k;
	MOVW R30,R18
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; 0000 00A7 }
;
;void Set_Fan(unsigned char num, unsigned char status)   //Устанавливает статус куллера num - номер куллера, status - вкл/выкл
; 0000 00AA {
_Set_Fan:
; 0000 00AB switch (num)
;	num -> Y+1
;	status -> Y+0
	LDD  R30,Y+1
; 0000 00AC {
; 0000 00AD         case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x23
; 0000 00AE         {
; 0000 00AF         if (status == Off)
	LD   R26,Y
	CP   R9,R26
	BRNE _0x24
; 0000 00B0                 {
; 0000 00B1                 PORTD.2=Off;
	MOV  R30,R9
	CPI  R30,0
	BRNE _0x25
	CBI  0x12,2
	RJMP _0x26
_0x25:
	SBI  0x12,2
_0x26:
; 0000 00B2                 Fan1_Status=Off;
	MOV  R8,R9
; 0000 00B3                 } else
	RJMP _0x27
_0x24:
; 0000 00B4                 {
; 0000 00B5                 PORTD.2=On;
	MOV  R30,R6
	CPI  R30,0
	BRNE _0x28
	CBI  0x12,2
	RJMP _0x29
_0x28:
	SBI  0x12,2
_0x29:
; 0000 00B6                 Fan1_Status=On;
	MOV  R8,R6
; 0000 00B7                 }
_0x27:
; 0000 00B8         break;
	RJMP _0x22
; 0000 00B9         }
; 0000 00BA         case 2:
_0x23:
	CPI  R30,LOW(0x2)
	BRNE _0x2A
; 0000 00BB         {
; 0000 00BC         if (status == Off)
	LD   R26,Y
	CP   R9,R26
	BRNE _0x2B
; 0000 00BD                 {
; 0000 00BE                 PORTD.3=Off;
	MOV  R30,R9
	CPI  R30,0
	BRNE _0x2C
	CBI  0x12,3
	RJMP _0x2D
_0x2C:
	SBI  0x12,3
_0x2D:
; 0000 00BF                 Fan2_Status=Off;
	MOV  R11,R9
; 0000 00C0                 } else
	RJMP _0x2E
_0x2B:
; 0000 00C1                 {
; 0000 00C2                 PORTD.3=On;
	MOV  R30,R6
	CPI  R30,0
	BRNE _0x2F
	CBI  0x12,3
	RJMP _0x30
_0x2F:
	SBI  0x12,3
_0x30:
; 0000 00C3                 Fan2_Status=On;
	MOV  R11,R6
; 0000 00C4                 }
_0x2E:
; 0000 00C5         break;
	RJMP _0x22
; 0000 00C6         }
; 0000 00C7         case 3:
_0x2A:
	CPI  R30,LOW(0x3)
	BRNE _0x22
; 0000 00C8         {
; 0000 00C9         if (status == Off)
	LD   R26,Y
	CP   R9,R26
	BRNE _0x32
; 0000 00CA                 {
; 0000 00CB                 PORTD.4=Off;
	MOV  R30,R9
	CPI  R30,0
	BRNE _0x33
	CBI  0x12,4
	RJMP _0x34
_0x33:
	SBI  0x12,4
_0x34:
; 0000 00CC                 Fan3_Status=Off;
	MOV  R10,R9
; 0000 00CD                 } else
	RJMP _0x35
_0x32:
; 0000 00CE                 {
; 0000 00CF                 PORTD.4=On;
	MOV  R30,R6
	CPI  R30,0
	BRNE _0x36
	CBI  0x12,4
	RJMP _0x37
_0x36:
	SBI  0x12,4
_0x37:
; 0000 00D0                 Fan3_Status=On;
	MOV  R10,R6
; 0000 00D1                 }
_0x35:
; 0000 00D2         break;
; 0000 00D3         }
; 0000 00D4 
; 0000 00D5 }
_0x22:
; 0000 00D6 
; 0000 00D7 }
	ADIW R28,2
	RET
;
;void Set_PWM_Value(unsigned char num, unsigned  int PWM)//Устанавливает величину ШИМ нагревателя num - номер нагревателя, PWM - величина ШИМ
; 0000 00DA {
_Set_PWM_Value:
; 0000 00DB switch (num)
;	num -> Y+2
;	PWM -> Y+0
	LDD  R30,Y+2
; 0000 00DC {
; 0000 00DD case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x3B
; 0000 00DE         {
; 0000 00DF         PWM1_Value=PWM;
	__GETWRS 12,13,0
; 0000 00E0         OCR1AH=(unsigned char) (PWM1_Value>>8);
	MOV  R30,R13
	ANDI R31,HIGH(0x0)
	OUT  0x2B,R30
; 0000 00E1         OCR1AL=(unsigned char) (PWM1_Value);
	OUT  0x2A,R12
; 0000 00E2         break;
	RJMP _0x3A
; 0000 00E3         }
; 0000 00E4 case 2:
_0x3B:
	CPI  R30,LOW(0x2)
	BRNE _0x3A
; 0000 00E5         {
; 0000 00E6         PWM2_Value=PWM;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _PWM2_Value,R30
	STS  _PWM2_Value+1,R31
; 0000 00E7         OCR1BH=(unsigned char) (PWM2_Value>>8);
	LDS  R30,_PWM2_Value+1
	ANDI R31,HIGH(0x0)
	OUT  0x29,R30
; 0000 00E8         OCR1BL=(unsigned char) (PWM2_Value);
	LDS  R30,_PWM2_Value
	OUT  0x28,R30
; 0000 00E9         break;}
; 0000 00EA }
_0x3A:
; 0000 00EB }
	RJMP _0x2060001
;
;unsigned char Get_Fan_Status(unsigned char num) // Возвращает статус куллера, num - номер куллера
; 0000 00EE {
_Get_Fan_Status:
; 0000 00EF switch (num)
;	num -> Y+0
	LD   R30,Y
; 0000 00F0 {
; 0000 00F1         case 1:return Fan1_Status;
	CPI  R30,LOW(0x1)
	BRNE _0x40
	MOV  R30,R8
	RJMP _0x2060002
; 0000 00F2         case 2:return Fan2_Status;
_0x40:
	CPI  R30,LOW(0x2)
	BRNE _0x41
	MOV  R30,R11
	RJMP _0x2060002
; 0000 00F3         case 3:return Fan3_Status;
_0x41:
	CPI  R30,LOW(0x3)
	BRNE _0x3F
	MOV  R30,R10
	RJMP _0x2060002
; 0000 00F4  break;
; 0000 00F5 }
_0x3F:
; 0000 00F6 
; 0000 00F7 }
	RJMP _0x2060002
;
;unsigned int Get_PWM(unsigned char num)        // Возвращает величину ШИМ нагревателя, num - номер нагревателя
; 0000 00FA {
_Get_PWM:
; 0000 00FB switch (num)
;	num -> Y+0
	LD   R30,Y
; 0000 00FC {
; 0000 00FD         case 1:return PWM1_Value;
	CPI  R30,LOW(0x1)
	BRNE _0x46
	MOVW R30,R12
	RJMP _0x2060002
; 0000 00FE         case 2:return PWM2_Value;
_0x46:
	CPI  R30,LOW(0x2)
	BRNE _0x45
	LDS  R30,_PWM2_Value
	LDS  R31,_PWM2_Value+1
	RJMP _0x2060002
; 0000 00FF 
; 0000 0100 }
_0x45:
; 0000 0101 }
	RJMP _0x2060002
;
;unsigned char Get_Tmp(unsigned char num)       //Возвращает значение температуры термопары, num - номер термопары
; 0000 0104 {
_Get_Tmp:
; 0000 0105 switch (num)
;	num -> Y+0
	LD   R30,Y
; 0000 0106 {
; 0000 0107         case 1:{Tmp1_Value=adc_data[0]; return Tmp1_Value;}
	CPI  R30,LOW(0x1)
	BRNE _0x4B
	LDS  R30,_adc_data
	STS  _Tmp1_Value,R30
	RJMP _0x2060002
; 0000 0108         case 2:{Tmp2_Value=adc_data[1]; return Tmp2_Value;}
_0x4B:
	CPI  R30,LOW(0x2)
	BRNE _0x4D
	__GETB1MN _adc_data,1
	STS  _Tmp2_Value,R30
	RJMP _0x2060002
; 0000 0109         default:;
_0x4D:
; 0000 010A break;
; 0000 010B }
; 0000 010C }
	RJMP _0x2060002
;
;
;void UART(void)
; 0000 0110 {
_UART:
; 0000 0111 unsigned int buff=0;
; 0000 0112 unsigned int buff1=0;
; 0000 0113 unsigned int buff2=0;
; 0000 0114 unsigned int buff3=0;
; 0000 0115 unsigned int f=0;
; 0000 0116 unsigned int p=0;
; 0000 0117 unsigned int t=0;
; 0000 0118 
; 0000 0119 if (rx_counter)
	SBIW R28,8
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	RCALL __SAVELOCR6
;	buff -> R16,R17
;	buff1 -> R18,R19
;	buff2 -> R20,R21
;	buff3 -> Y+12
;	f -> Y+10
;	p -> Y+8
;	t -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	TST  R7
	BRNE PC+2
	RJMP _0x4E
; 0000 011A {
; 0000 011B         buff = getchar();
	RCALL _getchar
	MOV  R16,R30
	CLR  R17
; 0000 011C         if (buff == '#')
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x4F
; 0000 011D         {                                      //Начало  приема команды
; 0000 011E 
; 0000 011F         buff1 = enterchar();                    // Определяем тип команды SET/GET
	RCALL _enterchar
	MOV  R18,R30
	CLR  R19
; 0000 0120         switch (buff1)
	MOVW R30,R18
; 0000 0121         {
; 0000 0122                 case 'S':
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x53
; 0000 0123                  {                             // Определяем устанавливаемый параметр Fan/PWM
; 0000 0124                  buff2 = enterchar();
	RCALL _enterchar
	MOV  R20,R30
	CLR  R21
; 0000 0125                  switch (buff2)
	MOVW R30,R20
; 0000 0126                    {
; 0000 0127                         case 'F': { Set_Fan(((unsigned char) enterdata(1)),((unsigned char) enterdata(1))); printf("OK"); break;}
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0x57
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL _Set_Fan
	__POINTW1FN _0x0,3
	RJMP _0x68
; 0000 0128                         case 'P': { Set_PWM_Value(((unsigned char) enterdata(1)),(enterdata(4))); printf("OK"); break;}
_0x57:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x59
	RCALL SUBOPT_0x5
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3
	RCALL _Set_PWM_Value
	__POINTW1FN _0x0,3
	RJMP _0x68
; 0000 0129                         default:printf("NO");
_0x59:
	RCALL SUBOPT_0x2
_0x68:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x4
; 0000 012A                    }
; 0000 012B                  break;
	RJMP _0x52
; 0000 012C                  }
; 0000 012D 
; 0000 012E 
; 0000 012F                  case 'G':                      // Определяем запрашиваемый параметр Fan/PWM/Tmp
_0x53:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x62
; 0000 0130                  {
; 0000 0131                  buff3 = enterchar();
	RCALL _enterchar
	LDI  R31,0
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0132                  switch (buff3)
; 0000 0133                    {
; 0000 0134                         case 'F': { f=enterdata(1); printf("F%d%d",f,Get_Fan_Status(f)); break;}
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0x5E
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x3
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL SUBOPT_0x8
	LDD  R30,Y+16
	ST   -Y,R30
	RCALL _Get_Fan_Status
	RCALL SUBOPT_0x9
	RJMP _0x5D
; 0000 0135                         case 'P': { p=enterdata(1); printf("P%d%04d",p,Get_PWM(p)); break;}
_0x5E:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x5F
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
	STD  Y+8,R30
	STD  Y+8+1,R31
	__POINTW1FN _0x0,12
	RCALL SUBOPT_0x3
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x8
	LDD  R30,Y+14
	ST   -Y,R30
	RCALL _Get_PWM
	RCALL SUBOPT_0x8
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
	RJMP _0x5D
; 0000 0136                         case 'T': { t=enterdata(1); printf("T%d%03d",t,Get_Tmp(t));  break;}
_0x5F:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x61
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x3
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x8
	LDD  R30,Y+12
	ST   -Y,R30
	RCALL _Get_Tmp
	RCALL SUBOPT_0x9
	RJMP _0x5D
; 0000 0137                         default:printf("NO");
_0x61:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 0138                    }
_0x5D:
; 0000 0139                   break;
	RJMP _0x52
; 0000 013A                  }
; 0000 013B             default:printf("NO");
_0x62:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 013C         }
_0x52:
; 0000 013D         }   else printf("NO");
	RJMP _0x63
_0x4F:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 013E }
_0x63:
; 0000 013F }
_0x4E:
	RCALL __LOADLOCR6
	ADIW R28,14
	RET
;
;
;void main(void)
; 0000 0143 {
_main:
; 0000 0144 // Declare your local variables here
; 0000 0145 
; 0000 0146 // Input/Output Ports initialization
; 0000 0147 // Port B initialization
; 0000 0148 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=In
; 0000 0149 // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=T
; 0000 014A PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 014B DDRB=0x06;
	LDI  R30,LOW(6)
	OUT  0x17,R30
; 0000 014C 
; 0000 014D // Port C initialization
; 0000 014E // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014F // State6=P State5=P State4=P State3=T State2=T State1=P State0=P
; 0000 0150 PORTC=0x73;
	LDI  R30,LOW(115)
	OUT  0x15,R30
; 0000 0151 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0152 
; 0000 0153 // Port D initialization
; 0000 0154 // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0000 0155 // State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=T
; 0000 0156 PORTD=0x00;
	OUT  0x12,R30
; 0000 0157 DDRD=0x1E;
	LDI  R30,LOW(30)
	OUT  0x11,R30
; 0000 0158 
; 0000 0159 // Timer/Counter 0 initialization
; 0000 015A // Clock source: System Clock
; 0000 015B // Clock value: Timer 0 Stopped
; 0000 015C TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 015D TCNT0=0x00;
	OUT  0x32,R30
; 0000 015E 
; 0000 015F 
; 0000 0160 
; 0000 0161 // Timer/Counter 1 initialization
; 0000 0162 // Clock source: System Clock
; 0000 0163 // Clock value: 5120,000 kHz
; 0000 0164 // Mode: Ph. correct PWM top=03FFh
; 0000 0165 // OC1A output: Inverted
; 0000 0166 // OC1B output: Inverted
; 0000 0167 // Noise Canceler: Off
; 0000 0168 // Input Capture on Falling Edge
; 0000 0169 // Timer1 Overflow Interrupt: Off
; 0000 016A // Input Capture Interrupt: Off
; 0000 016B // Compare A Match Interrupt: Off
; 0000 016C // Compare B Match Interrupt: Off
; 0000 016D TCCR1A=0xF3;
	LDI  R30,LOW(243)
	OUT  0x2F,R30
; 0000 016E TCCR1B=0x01;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 016F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0170 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0171 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0172 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0173 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0174 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0175 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0176 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0177 
; 0000 0178 // Timer/Counter 2 initialization
; 0000 0179 // Clock source: System Clock
; 0000 017A // Clock value: Timer 2 Stopped
; 0000 017B // Mode: Normal top=FFh
; 0000 017C // OC2 output: Disconnected
; 0000 017D ASSR=0x00;
	OUT  0x22,R30
; 0000 017E TCCR2=0x00;
	OUT  0x25,R30
; 0000 017F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0180 OCR2=0x00;
	OUT  0x23,R30
; 0000 0181 
; 0000 0182 // External Interrupt(s) initialization
; 0000 0183 // INT0: Off
; 0000 0184 // INT1: Off
; 0000 0185 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0186 
; 0000 0187 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0188 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0189 
; 0000 018A 
; 0000 018B // USART initialization
; 0000 018C // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 018D // USART Receiver: On
; 0000 018E // USART Transmitter: On
; 0000 018F // USART Mode: Asynchronous
; 0000 0190 // USART Baud Rate: 9600
; 0000 0191 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0192 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0193 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0194 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0195 UBRRL=0x20;
	LDI  R30,LOW(32)
	OUT  0x9,R30
; 0000 0196 
; 0000 0197 
; 0000 0198 
; 0000 0199 // Analog Comparator initialization
; 0000 019A // Analog Comparator: Off
; 0000 019B // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 019C ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 019D SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 019E 
; 0000 019F 
; 0000 01A0 // ADC initialization
; 0000 01A1 // ADC Clock frequency: 160,000 kHz
; 0000 01A2 // ADC Voltage Reference: AREF pin
; 0000 01A3 // Only the 8 most significant bits of
; 0000 01A4 // the AD conversion result are used
; 0000 01A5 ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(34)
	OUT  0x7,R30
; 0000 01A6 ADCSRA=0xCD;
	LDI  R30,LOW(205)
	OUT  0x6,R30
; 0000 01A7 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 01A8 
; 0000 01A9 // Global enable interrupts
; 0000 01AA #asm("sei")
	sei
; 0000 01AB 
; 0000 01AC 
; 0000 01AD 
; 0000 01AE Set_Fan(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _Set_Fan
; 0000 01AF Set_PWM_Value(1,1023);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xB
; 0000 01B0 Set_PWM_Value(2,1023);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xB
; 0000 01B1 
; 0000 01B2 while (1)
_0x64:
; 0000 01B3         {
; 0000 01B4 
; 0000 01B5    UART();
	RCALL _UART
; 0000 01B6 
; 0000 01B7 
; 0000 01B8 
; 0000 01B9         }
	RJMP _0x64
; 0000 01BA }
_0x67:
	RJMP _0x67
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060002:
	ADIW R28,1
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060001:
	ADIW R28,3
	RET
__print_G100:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0xC
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0xC
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xD
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0xF
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0xA
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0xA
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x12
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x7
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x12
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0xC
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0xA
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0xA
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x7
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0xF
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0xF
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x3
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x3
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x3
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_rx_buffer:
	.BYTE 0x64
_adc_data:
	.BYTE 0x2
_input_index_S0000002000:
	.BYTE 0x1
_PWM2_Value:
	.BYTE 0x2
_Tmp1_Value:
	.BYTE 0x1
_Tmp2_Value:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x1:
	__MULBNWRU 18,19,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	__POINTW1FN _0x0,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _enterdata
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	RJMP _enterdata

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	RCALL SUBOPT_0x3
	RJMP _Set_PWM_Value

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xC:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x3
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xF:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x3
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	RCALL SUBOPT_0xA
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	RJMP SUBOPT_0x7


	.CSEG
__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
