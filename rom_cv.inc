
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _input_index_S2=R6
	.DEF _On=R9
_11:
	.DB  0x1
	.DEF _Off=R8
	.DEF _Fan1_Status=R11
	.DEF _Fan2_Status=R10
	.DEF _Fan3_Status=R13
_12:
	.DB  0xFF,0x3
_13:
	.DB  0xFF,0x3
	.DEF _Tmp1_Value=R12
_0x46:
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
_tbl10_G2:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G2:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
_0:
	.DB  0x4E,0x4F,0x0,0x4F,0x4B,0x0,0x46,0x25
	.DB  0x64,0x25,0x64,0x0,0x50,0x25,0x64,0x25
	.DB  0x30,0x34,0x64,0x0,0x54,0x25,0x64,0x25
	.DB  0x30,0x33,0x64,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x09
	.DW  _11*2

	.DW  0x02
	.DW  _PWM1_Value
	.DW  _12*2

	.DW  0x02
	.DW  _PWM2_Value
	.DW  _13*2

	.DW  0
_0x112: