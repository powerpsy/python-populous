; IRA V2.11 (Jan  8 2025) (c)1993-1995 Tim Ruehsen
; (c)2009-2024 Frank Wille, (c)2014-2019 Nicolas Bastien

ABSEXECBASE	EQU	$4
CIAB_PRA	EQU	$BFD000
EXT_BFE0FF	EQU	$BFE0FF
CIAA_SDR	EQU	$BFEC01
JOY0DAT		EQU	$DFF00A
POTGOR		EQU	$DFF016
EXT_DFF019	EQU	$DFF019
INTREQR		EQU	$DFF01E
SERDAT		EQU	$DFF030
SERPER		EQU	$DFF032
POTGO		EQU	$DFF034
COP1LCH		EQU	$DFF080
COPJMP1		EQU	$DFF088
DMACON		EQU	$DFF096
INTENA		EQU	$DFF09A
INTREQ		EQU	$DFF09C



	BASEREG	_A4,A4


	SECTION S_0,CODE

__H0_org:
; ------------------------------------------------------------------------------
; POPULOUS 2.7 - populous.prg - Hit Squad 1993 budget release
; Lacks the binary obfuscation of the original release
; A few labels _begin _mulu _divs etc were originally .begin, .mulu etc
; but were changed to allow vasm to reassemble, which it does successfully
; 
; Populous appears to have been written in C. While Ghidra allows for C
; decompilation, Aira Force is a better tool for Amiga games
; 
; Reassemble (note: hasn't been tested):
; vasmm68k_mot -Fhunkexe -kick1hunks -databss -ldots -no-opt -wfail -o populous.prg populous_prg.asm
; ------------------------------------------------------------------------------
	JMP	_begin			;3e1e8: 4ef900050602
_main:
	LINK.W	A5,#-6			;3e1ee: 4e55fffa
	JSR	(_openlibrary,PC)	;3e1f2: 4eba0342
	CLR.L	-(A7)			;3e1f6: 42a7
	PEA	$5960.W			;3e1f8: 48785960
	JSR	(___AllocMem,A4)	;3e1fc: 4eac8200
	ADDQ.W	#8,A7			;3e200: 504f
	MOVE.L	D0,(_sprite_data,A4)	;3e202: 29409868
	CLR.L	-(A7)			;3e206: 42a7
	PEA	$2080.W			;3e208: 48782080
	JSR	(___AllocMem,A4)	;3e20c: 4eac8200
	ADDQ.W	#8,A7			;3e210: 504f
	MOVE.L	D0,(_sprite_data_32,A4)	;3e212: 2940986c
	CLR.L	-(A7)			;3e216: 42a7
	PEA	$00008340		;3e218: 487900008340
	JSR	(___AllocMem,A4)	;3e21e: 4eac8200
	ADDQ.W	#8,A7			;3e222: 504f
	MOVE.L	D0,(_blk_data,A4)	;3e224: 29409870
	PEA	2.W			;3e228: 48780002
	PEA	$7D00.W			;3e22c: 48787d00
	JSR	(___AllocMem,A4)	;3e230: 4eac8200
	ADDQ.W	#8,A7			;3e234: 504f
	MOVE.L	D0,(_back_scr,A4)	;3e236: 29409874
	PEA	$00010002		;3e23a: 487900010002
	PEA	$0000fa00		;3e240: 48790000fa00
	JSR	(___AllocMem,A4)	;3e246: 4eac8200
	ADDQ.W	#8,A7			;3e24a: 504f
	MOVE.L	D0,(_screen_pointer,A4)	;3e24c: 29409878
	PEA	$00010002		;3e250: 487900010002
	PEA	$384.W			;3e256: 48780384
	JSR	(___AllocMem,A4)	;3e25a: 4eac8200
	ADDQ.W	#8,A7			;3e25e: 504f
	MOVE.L	D0,(_copper_list,A4)	;3e260: 29409884
	PEA	$00010002		;3e264: 487900010002
	PEA	$12C.W			;3e26a: 4878012c
	JSR	(___AllocMem,A4)	;3e26e: 4eac8200
	ADDQ.W	#8,A7			;3e272: 504f
	MOVE.L	D0,(_spare_cl,A4)	;3e274: 29409890
	PEA	$00010002		;3e278: 487900010002
	PEA	$104.W			;3e27e: 48780104
	JSR	(___AllocMem,A4)	;3e282: 4eac8200
	ADDQ.W	#8,A7			;3e286: 504f
	MOVE.L	D0,(_fb,A4)		;3e288: 29409894
	CMPI.W	#$0002,(8,A5)		;3e28c: 0c6d00020008
	BNE.S	LAB_3E2A8		;3e292: 6614
	MOVEA.L	($A,A5),A0		;3e294: 206d000a
	MOVE.L	(4,A0),-(A7)		;3e298: 2f280004
	JSR	(___atoi,A4)		;3e29c: 4eac81ac
	ADDQ.W	#4,A7			;3e2a0: 584f
	MOVE.W	D0,(_start_of_game,A4)	;3e2a2: 39409898
	BRA.S	LAB_3E2BA		;3e2a6: 6012
LAB_3E2A8:
	MOVE.L	#$00000042,(-6,A5)	;3e2a8: 2b7c00000042fffa
	MOVEA.L	(-6,A5),A0		;3e2b0: 206dfffa
	MOVE.W	(2,A0),(_start_of_game,A4) ;3e2b4: 396800029898
LAB_3E2BA:
	JSR	(___open_screen,A4)	;3e2ba: 4eac80b0
	MOVE.W	(_sprites_in,A4),-(A7)	;3e2be: 3f2c989a
	JSR	(___read_sprites,A4)	;3e2c2: 4eac80b6
	ADDQ.W	#2,A7			;3e2c6: 544f
	JSR	(___sprite_to_amiga,A4)	;3e2c8: 4eac80d4
	JSR	(___start_game,A4)	;3e2cc: 4eac808c
; 1989 has two lines here: function call and move
	JSR	(_setup_serial_interrupt,PC) ;3e2d0: 4eba01a2
	MOVE.W	#$2580,(LAB_52C90,A4)	;3e2d4: 397c258098a2
	MOVE.W	#$2580,(_baud_rate,A4)	;3e2da: 397c258083b8
	JSR	(___set_serial,A4)	;3e2e0: 4eac8140
	JSR	(_animate,PC)		;3e2e4: 4eba044a
	BSR.S	_closeall		;3e2e8: 611a
	UNLK	A5			;3e2ea: 4e5d
	RTS				;3e2ec: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_rs:
	LINK.W	A5,#0			;3e2ee: 4e550000
	MOVEA.L	(_GfxBase,A4),A0	;3e2f2: 206c99a4
	MOVE.L	($26,A0),-(A7)		;3e2f6: 2f280026
	JSR	(___reset_screen,A4)	;3e2fa: 4eac8134
	ADDQ.W	#4,A7			;3e2fe: 584f
	UNLK	A5			;3e300: 4e5d
	RTS				;3e302: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_closeall:
	LINK.W	A5,#0			;3e304: 4e550000
	MOVEA.L	(_GfxBase,A4),A0	;3e308: 206c99a4
	MOVE.L	($26,A0),-(A7)		;3e30c: 2f280026
	JSR	(___reset_screen,A4)	;3e310: 4eac8134
	ADDQ.W	#4,A7			;3e314: 584f
	JSR	(_free_inter,PC)	;3e316: 4eba013c
	JSR	(___free_amiga_sprites,A4) ;3e31a: 4eac80da
	JSR	(___free_all_sounds,A4)	;3e31e: 4eac8158
	JSR	(___close_channels,A4)	;3e322: 4eac8164
	PEA	$5960.W			;3e326: 48785960
	MOVE.L	(_sprite_data,A4),-(A7)	;3e32a: 2f2c9868
	JSR	(___FreeMem,A4)		;3e32e: 4eac820c
	ADDQ.W	#8,A7			;3e332: 504f
	PEA	$2080.W			;3e334: 48782080
	MOVE.L	(_sprite_data_32,A4),-(A7) ;3e338: 2f2c986c
	JSR	(___FreeMem,A4)		;3e33c: 4eac820c
	ADDQ.W	#8,A7			;3e340: 504f
	PEA	$00008340		;3e342: 487900008340
	MOVE.L	(_blk_data,A4),-(A7)	;3e348: 2f2c9870
	JSR	(___FreeMem,A4)		;3e34c: 4eac820c
	ADDQ.W	#8,A7			;3e350: 504f
	PEA	$7D00.W			;3e352: 48787d00
	MOVE.L	(_back_scr,A4),-(A7)	;3e356: 2f2c9874
	JSR	(___FreeMem,A4)		;3e35a: 4eac820c
	ADDQ.W	#8,A7			;3e35e: 504f
	PEA	$0000fa00		;3e360: 48790000fa00
	MOVE.L	(_screen_pointer,A4),-(A7) ;3e366: 2f2c9878
	JSR	(___FreeMem,A4)		;3e36a: 4eac820c
	ADDQ.W	#8,A7			;3e36e: 504f
	PEA	$384.W			;3e370: 48780384
	MOVE.L	(_copper_list,A4),-(A7)	;3e374: 2f2c9884
	JSR	(___FreeMem,A4)		;3e378: 4eac820c
	ADDQ.W	#8,A7			;3e37c: 504f
	PEA	$12C.W			;3e37e: 4878012c
	MOVE.L	(_spare_cl,A4),-(A7)	;3e382: 2f2c9890
	JSR	(___FreeMem,A4)		;3e386: 4eac820c
	ADDQ.W	#8,A7			;3e38a: 504f
	PEA	$104.W			;3e38c: 48780104
	MOVE.L	(_fb,A4),-(A7)		;3e390: 2f2c9894
	JSR	(___FreeMem,A4)		;3e394: 4eac820c
	ADDQ.W	#8,A7			;3e398: 504f
	MOVE.W	#$0010,INTENA		;3e39a: 33fc001000dff09a
	JSR	(_free_serial_interrupt,PC) ;3e3a2: 4eba0150
	JSR	(_closelibrary,PC)	;3e3a6: 4eba015c
	UNLK	A5			;3e3aa: 4e5d
	RTS				;3e3ac: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_create_mouse:
	LINK.W	A5,#0			;3e3ae: 4e550000
; 400
	MOVE.W	#$018f,(_mouse_limit,A4) ;3e3b2: 397c018f99a8
	BSR.S	_setup_interrupt	;3e3b8: 6104
	UNLK	A5			;3e3ba: 4e5d
	RTS				;3e3bc: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_setup_interrupt:
	LINK.W	A5,#0			;3e3be: 4e550000
	MOVE.B	#$02,(LAB_52C40,A4)	;3e3c2: 197c00029852
	CLR.B	(LAB_52C41,A4)		;3e3c8: 422c9853
	LEA	(strPetersint,PC),A0	;3e3cc: 41fa0040
	MOVE.L	A0,(LAB_52C42,A4)	;3e3d0: 29489854
	LEA	(_mousex,A4),A0		;3e3d4: 41ec99aa
	MOVE.L	A0,(LAB_52C46,A4)	;3e3d8: 29489858
	LEA	(___mouse,A4),A0	;3e3dc: 41ec8128
	MOVE.L	A0,(LAB_52C4A,A4)	;3e3e0: 2948985c
	MOVEA.L	(_IntuitionBase,A4),A0	;3e3e4: 206c99ac
	MOVE.W	($46,A0),(_big_mousex,A4) ;3e3e8: 3968004699b0
	MOVEA.L	(_IntuitionBase,A4),A0	;3e3ee: 206c99ac
	MOVE.W	($44,A0),(_big_mousey,A4) ;3e3f2: 3968004499b2
	JSR	(___setup_mouse,A4)	;3e3f8: 4eac812e
	PEA	(_dint,A4)		;3e3fc: 486c984a
	PEA	5.W			;3e400: 48780005
	JSR	(___AddIntServer,A4)	;3e404: 4eac81f4
	ADDQ.W	#8,A7			;3e408: 504f
	UNLK	A5			;3e40a: 4e5d
	RTS				;3e40c: 4e75
strPetersint:
; Peter's interrupt - Peter Molyneux, no doubt
	;3e40e
	;DC.B	$70,$65,$74,$65,$72,$73,$69,$6e,$74,$00
	DC.B	"petersint",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_mouse:
	LINK.W	A5,#0			;3e418: 4e550000
	MOVEA.L	(_IntuitionBase,A4),A0	;3e41c: 206c99ac
	MOVE.W	($46,A0),D0		;3e420: 30280046
	CMP.W	(_big_mousex,A4),D0	;3e424: b06c99b0
	BNE.S	LAB_3E438		;3e428: 660e
	MOVEA.L	(_IntuitionBase,A4),A0	;3e42a: 206c99ac
	MOVE.W	($44,A0),D0		;3e42e: 30280044
	CMP.W	(_big_mousey,A4),D0	;3e432: b06c99b2
	BEQ.S	LAB_3E450		;3e436: 6718
LAB_3E438:
	MOVEA.L	(_IntuitionBase,A4),A0	;3e438: 206c99ac
	MOVE.W	($46,A0),(_big_mousex,A4) ;3e43c: 3968004699b0
	MOVEA.L	(_IntuitionBase,A4),A0	;3e442: 206c99ac
	MOVE.W	($44,A0),(_big_mousey,A4) ;3e446: 3968004499b2
	JSR	(___setup_mouse,A4)	;3e44c: 4eac812e
LAB_3E450:
	UNLK	A5			;3e450: 4e5d
	RTS				;3e452: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_free_inter:
	LINK.W	A5,#0			;3e454: 4e550000
	PEA	(_dint,A4)		;3e458: 486c984a
	PEA	5.W			;3e45c: 48780005
	JSR	(___RemIntServer,A4)	;3e460: 4eac8218
	ADDQ.W	#8,A7			;3e464: 504f
	PEA	9.W			;3e466: 48780009
	JSR	(___Delay,A4)		;3e46a: 4eac81dc
	ADDQ.W	#4,A7			;3e46e: 584f
	UNLK	A5			;3e470: 4e5d
	RTS				;3e472: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_setup_serial_interrupt:
	LINK.W	A5,#0			;3e474: 4e550000
	MOVE.B	#$02,(LAB_52DAA,A4)	;3e478: 197c000299bc
	CLR.B	(LAB_52DAB,A4)		;3e47e: 422c99bd
	LEA	(LAB_3E4DA,PC),A0	;3e482: 41fa0056
	MOVE.L	A0,(LAB_52DAC,A4)	;3e486: 294899be
	LEA	(_serial,A4),A0		;3e48a: 41ec989c
	MOVE.L	A0,(LAB_52DB0,A4)	;3e48e: 294899c2
	LEA	(___r_ser_buff,A4),A0	;3e492: 41ec8146
	MOVE.L	A0,(LAB_52DB4,A4)	;3e496: 294899c6
	PEA	(_serial_inter_1,A4)	;3e49a: 486c99b4
	PEA	$B.W			;3e49e: 4878000b
	JSR	(___SetIntVector,A4)	;3e4a2: 4eac821e
	ADDQ.W	#8,A7			;3e4a6: 504f
	MOVE.B	#$02,(LAB_52DC0,A4)	;3e4a8: 197c000299d2
	CLR.B	(LAB_52DC1,A4)		;3e4ae: 422c99d3
	LEA	(LAB_3E4E6,PC),A0	;3e4b2: 41fa0032
	MOVE.L	A0,(LAB_52DC2,A4)	;3e4b6: 294899d4
	LEA	(_serial,A4),A0		;3e4ba: 41ec989c
	MOVE.L	A0,(LAB_52DC6,A4)	;3e4be: 294899d8
	LEA	(___w_ser_buff,A4),A0	;3e4c2: 41ec814c
	MOVE.L	A0,(LAB_52DCA,A4)	;3e4c6: 294899dc
	PEA	(_serial_inter_2,A4)	;3e4ca: 486c99ca
	CLR.L	-(A7)			;3e4ce: 42a7
	JSR	(___SetIntVector,A4)	;3e4d0: 4eac821e
	ADDQ.W	#8,A7			;3e4d4: 504f
	UNLK	A5			;3e4d6: 4e5d
	RTS				;3e4d8: 4e75
LAB_3E4DA:
	;3e4da
	;DC.B	$73,$65,$72,$69,$61,$6c,$5f,$72,$65,$61,$64,$00
	DC.B	"serial_read",0
LAB_3E4E6:
	;3e4e6
	;DC.B	$73,$65,$72,$69,$61,$6c,$5f,$77,$72,$69,$74,$65,$00,$00
	DC.B	"serial_write",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_free_serial_interrupt:
	LINK.W	A5,#0			;3e4f4: 4e550000
	MOVE.W	#$0801,INTENA		;3e4f8: 33fc080100dff09a
	UNLK	A5			;3e500: 4e5d
	RTS				;3e502: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_closelibrary:
	LINK.W	A5,#0			;3e504: 4e550000
	CLR.W	-(A7)			;3e508: 4267
	BSR.S	_set_pri		;3e50a: 611a
	ADDQ.W	#2,A7			;3e50c: 544f
	MOVE.L	(_GfxBase,A4),-(A7)	;3e50e: 2f2c99a4
	JSR	(___CloseLibrary,A4)	;3e512: 4eac81fa
	ADDQ.W	#4,A7			;3e516: 584f
	MOVE.L	(_IntuitionBase,A4),-(A7) ;3e518: 2f2c99ac
	JSR	(___CloseLibrary,A4)	;3e51c: 4eac81fa
	ADDQ.W	#4,A7			;3e520: 584f
	UNLK	A5			;3e522: 4e5d
	RTS				;3e524: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_pri:
	LINK.W	A5,#0			;3e526: 4e550000
	UNLK	A5			;3e52a: 4e5d
	RTS				;3e52c: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_debug:
; this empty method is in both versions
	LINK.W	A5,#0			;3e52e: 4e550000
	UNLK	A5			;3e532: 4e5d
	RTS				;3e534: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_openlibrary:
	LINK.W	A5,#0			;3e536: 4e550000
	CLR.L	-(A7)			;3e53a: 42a7
	JSR	(___FindTask,A4)	;3e53c: 4eac8206
	ADDQ.W	#4,A7			;3e540: 584f
	MOVE.L	D0,(_my_task,A4)	;3e542: 29409860
	MOVEA.L	(_my_task,A4),A0	;3e546: 206c9860
	MOVE.L	#$ffffffff,($B8,A0)	;3e54a: 217cffffffff00b8
	MOVE.W	#$007f,-(A7)		;3e552: 3f3c007f
	BSR.S	_set_pri		;3e556: 61ce
	ADDQ.W	#2,A7			;3e558: 544f
	PEA	$1F.W			;3e55a: 4878001f
	PEA	(GraphicsLibName,PC)	;3e55e: 487a004a
	JSR	(___OpenLibrary,A4)	;3e562: 4eac8212
	ADDQ.W	#8,A7			;3e566: 504f
	MOVE.L	D0,(_GfxBase,A4)	;3e568: 294099a4
	BNE.S	LAB_3E578		;3e56c: 660a
	MOVE.W	#$0001,-(A7)		;3e56e: 3f3c0001
	JSR	(___exit,A4)		;3e572: 4eac81d0
	ADDQ.W	#2,A7			;3e576: 544f
LAB_3E578:
	PEA	$1F.W			;3e578: 4878001f
	PEA	(IntuitionLibName,PC)	;3e57c: 487a003d
	JSR	(___OpenLibrary,A4)	;3e580: 4eac8212
	ADDQ.W	#8,A7			;3e584: 504f
	MOVE.L	D0,(_IntuitionBase,A4)	;3e586: 294099ac
	BNE.S	LAB_3E596		;3e58a: 660a
	MOVE.W	#$0001,-(A7)		;3e58c: 3f3c0001
	JSR	(___exit,A4)		;3e590: 4eac81d0
	ADDQ.W	#2,A7			;3e594: 544f
LAB_3E596:
	MOVEA.L	(_GfxBase,A4),A0	;3e596: 206c99a4
	MOVE.W	($CE,A0),D0		;3e59a: 302800ce
	AND.W	#$0004,D0		;3e59e: c07c0004
	MOVE.W	D0,(_pal,A4)		;3e5a2: 394099e0
	UNLK	A5			;3e5a6: 4e5d
	RTS				;3e5a8: 4e75
GraphicsLibName:
	;3e5aa
	;DC.B	$67,$72,$61,$70,$68,$69,$63,$73,$2e,$6c,$69,$62,$72,$61,$72,$79
	;DC.B	$00
	DC.B	"graphics.library",0
IntuitionLibName:
	;3e5bb
	;DC.B	$69,$6e,$74,$75,$69,$74,$69,$6f,$6e,$2e,$6c,$69,$62,$72,$61,$72
	;DC.B	$79,$00,$00
	DC.B	"intuition.library",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_setup_display:
	LINK.W	A5,#-2			;3e5ce: 4e55fffe
	CMPI.W	#$ffff,(_in_conquest,A4) ;3e5d2: 0c6cffff84ba
	BEQ.S	LAB_3E652		;3e5d8: 6778
; Load map variables
; seed = level mod 8 + bytes8+9
; added last, suggesting the 5x expansion from 100 to 495 levels of was
; late in development
	MOVE.W	(_in_conquest,A4),D0	;3e5da: 302c84ba
	AND.W	#$0007,D0		;3e5de: c07c0007
	ADD.W	(conq_08_seed,A4),D0	;3e5e2: d06c84c4
	MOVE.W	D0,(_seed,A4)		;3e5e6: 394099e2
	MOVE.W	D0,(_start_seed,A4)	;3e5ea: 394099e4
	MOVEQ	#0,D0			;3e5ee: 7000
; Terrain type 0 - 3
	MOVE.B	(conq_05_terrain,A4),D0	;3e5f0: 102c84c1
	CMP.W	(_ground_in,A4),D0	;3e5f4: b06c99e6
	MOVEQ	#0,D0			;3e5f8: 7000
	MOVE.B	(conq_05_terrain,A4),D0	;3e5fa: 102c84c1
	MOVE.W	D0,(_ground_in,A4)	;3e5fe: 394099e6
	CLR.W	-(A7)			;3e602: 4267
	MOVE.W	(_ground_in,A4),-(A7)	;3e604: 3f2c99e6
	JSR	(___load_ground,A4)	;3e608: 4eac80bc
	ADDQ.W	#4,A7			;3e60c: 584f
	JSR	(_clear_map,PC)		;3e60e: 4eba068e
	MOVEQ	#0,D0			;3e612: 7000
; #0 and #1 can be 0 to 10
	MOVE.B	(_conquest,A4),D0	;3e614: 102c84bc
	MOVE.W	D0,(LAB_516DE,A4)	;3e618: 394082f0
	MOVEQ	#0,D0			;3e61c: 7000
	MOVE.B	(conq_01_speed,A4),D0	;3e61e: 102c84bd
	MOVE.W	D0,(LAB_516E2,A4)	;3e622: 394082f4
; 02 and #3 can be one of 25 values from 0 to 16,135
; bitfields for which powers can be used
	MOVEQ	#0,D0			;3e626: 7000
	MOVE.B	(conq_02_enemypow,A4),D0 ;3e628: 102c84be
	ASL.W	#3,D0			;3e62c: e740
	OR.W	#$0007,D0		;3e62e: 807c0007
	MOVE.W	D0,(LAB_516E0,A4)	;3e632: 394082f2
	MOVEQ	#0,D0			;3e636: 7000
	MOVE.B	(conq_03_yourpow,A4),D0	;3e638: 102c84bf
	ASL.W	#3,D0			;3e63c: e740
	OR.W	#$0007,D0		;3e63e: 807c0007
	MOVE.W	D0,(LAB_516B2,A4)	;3e642: 394082c4
; #4 game mode - build on people/towns/up only/mo build, swamps, water
	MOVEQ	#0,D0			;3e646: 7000
	MOVE.B	(conq_04_mode,A4),D0	;3e648: 102c84c0
	MOVE.W	D0,(_game_mode,A4)	;3e64c: 394084b8
	BRA.S	LAB_3E6AE		;3e650: 605c
LAB_3E652:
	MOVE.W	(_seed,A4),(_start_seed,A4) ;3e652: 396c99e299e4
	TST.W	(_seed,A4)		;3e658: 4a6c99e2
	BEQ.S	LAB_3E68C		;3e65c: 672e
	JSR	(___newrand,A4)		;3e65e: 4eac80fe
	BTST	#0,D0			;3e662: 08000000
	BEQ.S	LAB_3E68C		;3e666: 6724
	CMPI.W	#$ffff,($A,A5)		;3e668: 0c6dffff000a
	BNE.S	LAB_3E68C		;3e66e: 661c
	ADDQ.W	#1,(_ground_in,A4)	;3e670: 526c99e6
	CMPI.W	#$0003,(_ground_in,A4)	;3e674: 0c6c000399e6
	BLE.S	LAB_3E680		;3e67a: 6f04
	CLR.W	(_ground_in,A4)		;3e67c: 426c99e6
LAB_3E680:
	CLR.W	-(A7)			;3e680: 4267
	MOVE.W	(_ground_in,A4),-(A7)	;3e682: 3f2c99e6
	JSR	(___load_ground,A4)	;3e686: 4eac80bc
	ADDQ.W	#4,A7			;3e68a: 584f
LAB_3E68C:
	MOVE.W	($A,A5),D0		;3e68c: 302d000a
	CMP.W	(_ground_in,A4),D0	;3e690: b06c99e6
	BEQ.S	LAB_3E6AA		;3e694: 6714
	CMPI.W	#$ffff,($A,A5)		;3e696: 0c6dffff000a
	BEQ.S	LAB_3E6AA		;3e69c: 670c
	CLR.W	-(A7)			;3e69e: 4267
	MOVE.W	(_ground_in,A4),-(A7)	;3e6a0: 3f2c99e6
	JSR	(___load_ground,A4)	;3e6a4: 4eac80bc
	ADDQ.W	#4,A7			;3e6a8: 584f
LAB_3E6AA:
	JSR	(_clear_map,PC)		;3e6aa: 4eba05f2
LAB_3E6AE:
	TST.W	(8,A5)			;3e6ae: 4a6d0008
	BNE.S	LAB_3E6CE		;3e6b2: 661a
	JSR	(_make_alt,PC)		;3e6b4: 4eba07e0
	MOVE.W	#$003f,-(A7)		;3e6b8: 3f3c003f
	MOVE.W	#$003f,-(A7)		;3e6bc: 3f3c003f
	CLR.W	-(A7)			;3e6c0: 4267
	CLR.W	-(A7)			;3e6c2: 4267
	JSR	(_make_map,PC)		;3e6c4: 4eba09ec
	ADDQ.W	#8,A7			;3e6c8: 504f
	JSR	(_make_woods_rocks,PC)	;3e6ca: 4eba5cf8
LAB_3E6CE:
	MOVE.W	#$ffff,-(A7)		;3e6ce: 3f3cffff
	MOVE.L	(_back_scr,A4),-(A7)	;3e6d2: 2f2c9874
	MOVE.L	(_back_scr,A4),-(A7)	;3e6d6: 2f2c9874
	JSR	(___Setscreen,A4)	;3e6da: 4eac80c2
	LEA	($A,A7),A7		;3e6de: 4fef000a
	MOVE.W	#$003f,-(A7)		;3e6e2: 3f3c003f
	MOVE.W	#$003f,-(A7)		;3e6e6: 3f3c003f
	CLR.W	-(A7)			;3e6ea: 4267
	CLR.W	-(A7)			;3e6ec: 4267
	JSR	(_draw_map,PC)		;3e6ee: 4eba0af0
	ADDQ.W	#8,A7			;3e6f2: 504f
	MOVE.L	(_w_screen,A4),-(A7)	;3e6f4: 2f2c99e8
	MOVE.L	(_back_scr,A4),-(A7)	;3e6f8: 2f2c9874
	JSR	(___copy_screen,A4)	;3e6fc: 4eac80aa
	ADDQ.W	#8,A7			;3e700: 504f
	MOVE.L	(_d_screen,A4),-(A7)	;3e702: 2f2c99ec
	MOVE.L	(_back_scr,A4),-(A7)	;3e706: 2f2c9874
	JSR	(___copy_screen,A4)	;3e70a: 4eac80aa
	ADDQ.W	#8,A7			;3e70e: 504f
	MOVE.W	#$ffff,-(A7)		;3e710: 3f3cffff
	PEA	-1.W			;3e714: 4878ffff
	MOVE.L	(_w_screen,A4),-(A7)	;3e718: 2f2c99e8
	JSR	(___Setscreen,A4)	;3e71c: 4eac80c2
	LEA	($A,A7),A7		;3e720: 4fef000a
	JSR	(_place_first_people,PC) ;3e724: 4eba5294
	ADDQ.W	#1,(_seed,A4)		;3e728: 526c99e2
	UNLK	A5			;3e72c: 4e5d
	RTS				;3e72e: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_animate:
	LINK.W	A5,#-122		;3e730: 4e55ff86
	MOVEM.L	D4/A2,-(A7)		;3e734: 48e70820
	CLR.W	(-2,A5)			;3e738: 426dfffe
	CLR.W	(-14,A5)		;3e73c: 426dfff2
	CLR.W	(_xoff,A4)		;3e740: 426c99f0
	CLR.W	(_yoff,A4)		;3e744: 426c99f2
	MOVE.W	#$0001,-(A7)		;3e748: 3f3c0001
	CLR.W	-(A7)			;3e74c: 4267
	JSR	(_setup_display,PC)	;3e74e: 4ebafe7e
	ADDQ.W	#4,A7			;3e752: 584f
	MOVE.W	#$17e4,-(A7)		;3e754: 3f3c17e4
	MOVE.W	#$0003,-(A7)		;3e758: 3f3c0003
	CLR.W	-(A7)			;3e75c: 4267
	MOVE.L	(_back_scr,A4),-(A7)	;3e75e: 2f2c9874
	JSR	(___toggle_icon,A4)	;3e762: 4eac8122
	LEA	($A,A7),A7		;3e766: 4fef000a
	MOVE.W	#$17e4,-(A7)		;3e76a: 3f3c17e4
	MOVE.W	#$0004,-(A7)		;3e76e: 3f3c0004
	CLR.W	-(A7)			;3e772: 4267
	MOVE.L	(_back_scr,A4),-(A7)	;3e774: 2f2c9874
	JSR	(___toggle_icon,A4)	;3e778: 4eac8122
	LEA	($A,A7),A7		;3e77c: 4fef000a
	MOVE.W	#$12c0,-(A7)		;3e780: 3f3c12c0
	MOVE.W	#$0001,-(A7)		;3e784: 3f3c0001
	MOVE.W	#$0006,-(A7)		;3e788: 3f3c0006
	MOVE.L	(_back_scr,A4),-(A7)	;3e78c: 2f2c9874
	JSR	(___toggle_icon,A4)	;3e790: 4eac8122
	LEA	($A,A7),A7		;3e794: 4fef000a
	MOVE.W	#$12c0,-(A7)		;3e798: 3f3c12c0
	MOVE.W	#$0003,-(A7)		;3e79c: 3f3c0003
	MOVE.W	#$0004,-(A7)		;3e7a0: 3f3c0004
	MOVE.L	(_back_scr,A4),-(A7)	;3e7a4: 2f2c9874
	JSR	(___toggle_icon,A4)	;3e7a8: 4eac8122
	LEA	($A,A7),A7		;3e7ac: 4fef000a
	CMPI.W	#$0002,(_start_of_game,A4) ;3e7b0: 0c6c00029898
	BNE.S	LAB_3E7E4		;3e7b6: 662c
	CLR.W	(_start_of_game,A4)	;3e7b8: 426c9898
	JSR	(___clr_wsc,A4)		;3e7bc: 4eac80a4
	JSR	(___swap_screens,A4)	;3e7c0: 4eac80c8
LAB_3E7C4:
	JSR	(___show_world,A4)	;3e7c4: 4eac8080
	MOVE.W	D0,(_in_conquest,A4)	;3e7c8: 394084ba
	CMP.W	#$ffff,D0		;3e7cc: b07cffff
	BNE.S	LAB_3E7D4		;3e7d0: 6602
	BRA.S	LAB_3E7C4		;3e7d2: 60f0
LAB_3E7D4:
	JSR	(___return_to_game,A4)	;3e7d4: 4eac8086
	MOVE.W	#$ffff,-(A7)		;3e7d8: 3f3cffff
	CLR.W	-(A7)			;3e7dc: 4267
	JSR	(_setup_display,PC)	;3e7de: 4ebafdee
	ADDQ.W	#4,A7			;3e7e2: 584f
LAB_3E7E4:
	CLR.W	(_start_of_game,A4)	;3e7e4: 426c9898
LAB_3E7E8:
	MOVE.W	(_player,A4),D0		;3e7e8: 302c99f4
	EXT.L	D0			;3e7ec: 48c0
	ASL.L	#4,D0			;3e7ee: e980
	LEA	(good_pop,A4),A0	;3e7f0: 41ec99fe
	TST.L	(0,A0,D0.L)		;3e7f4: 4ab00800
	BEQ.S	LAB_3E852		;3e7f8: 6758
	TST.W	(_player,A4)		;3e7fa: 4a6c99f4
	BNE.S	LAB_3E804		;3e7fe: 6604
	MOVEQ	#1,D0			;3e800: 7001
	BRA.S	LAB_3E806		;3e802: 6002
LAB_3E804:
	MOVEQ	#0,D0			;3e804: 7000
LAB_3E806:
	EXT.L	D0			;3e806: 48c0
	ASL.L	#4,D0			;3e808: e980
	LEA	(good_pop,A4),A0	;3e80a: 41ec99fe
	MOVE.L	D0,D1			;3e80e: 2200
	MOVE.L	(0,A0,D1.L),D0		;3e810: 20301800
	MOVE.W	(_player,A4),D1		;3e814: 322c99f4
	EXT.L	D1			;3e818: 48c1
	ASL.L	#4,D1			;3e81a: e981
	LEA	(good_pop,A4),A0	;3e81c: 41ec99fe
	MOVE.L	D1,D2			;3e820: 2401
	MOVE.L	(0,A0,D2.L),D1		;3e822: 22302800
	JSR	(___divs,A4)		;3e826: 4eac81ca
	ASL.L	#1,D0			;3e82a: e380
	MOVEQ	#$32,D1			;3e82c: 7232
	SUB.L	D0,D1			;3e82e: 9280
	MOVE.W	D1,(_tempo,A4)		;3e830: 3941824e
	CMPI.W	#$0007,(_tempo,A4)	;3e834: 0c6c0007824e
	BGE.S	LAB_3E842		;3e83a: 6c06
	MOVE.W	#$0007,(_tempo,A4)	;3e83c: 397c0007824e
LAB_3E842:
	MOVE.W	(_tempo,A4),D0		;3e842: 302c824e
	EXT.L	D0			;3e846: 48c0
	DIVS	#$0003,D0		;3e848: 81fc0003
	MOVE.W	D0,(_beat_two,A4)	;3e84c: 39409a16
	BRA.S	LAB_3E85C		;3e850: 600a
LAB_3E852:
	CLR.W	(_tempo,A4)		;3e852: 426c824e
	MOVE.W	#$0001,(_beat_two,A4)	;3e856: 397c00019a16
LAB_3E85C:
	MOVE.W	(_tempo_now,A4),D0	;3e85c: 302c9a18
	CMP.W	(_tempo,A4),D0		;3e860: b06c824e
	BLE.S	LAB_3E86C		;3e864: 6f06
	MOVE.W	(_tempo,A4),(_tempo_now,A4) ;3e866: 396c824e9a18
LAB_3E86C:
	TST.W	(_toggle,A4)		;3e86c: 4a6c9a1a
	BNE.S	LAB_3E87A		;3e870: 6608
	MOVE.W	#$0001,(_toggle,A4)	;3e872: 397c00019a1a
	BRA.S	LAB_3E87E		;3e878: 6004
LAB_3E87A:
	CLR.W	(_toggle,A4)		;3e87a: 426c9a1a
LAB_3E87E:
	JSR	(___clr_wsc,A4)		;3e87e: 4eac80a4
	CLR.W	(_no_sprites,A4)	;3e882: 426c9a1c
	CLR.W	(_ok_to_build,A4)	;3e886: 426c9a1e
	CLR.B	(_sound_effect,A4)	;3e88a: 422c9a20
	CMPI.W	#$0002,(_mode,A4)	;3e88e: 0c6c00028256
	BNE.S	LAB_3E8A4		;3e894: 660e
	MOVE.W	(_player,A4),D0		;3e896: 302c99f4
	MULS	#$0003,D0		;3e89a: c1fc0003
	ADDQ.W	#1,D0			;3e89e: 5240
	MOVE.W	D0,(_pointer,A4)	;3e8a0: 394084b6
LAB_3E8A4:
	JSR	(_move_mana,PC)		;3e8a4: 4eba1c26
	MOVE.W	(_yoff,A4),-(A7)	;3e8a8: 3f2c99f2
	MOVE.W	(_xoff,A4),-(A7)	;3e8ac: 3f2c99f0
	JSR	(___draw_it,A4)		;3e8b0: 4eac809e
	ADDQ.W	#4,A7			;3e8b4: 584f
	MOVEQ	#0,D4			;3e8b6: 7800
	LEA	(_sprite,A4),A0		;3e8b8: 41ec9a22
	MOVEA.L	A0,A2			;3e8bc: 2448
	BRA.S	LAB_3E904		;3e8be: 6044
LAB_3E8C0:
	CMPI.W	#$00d1,(6,A2)		;3e8c0: 0c6a00d10006
	BLT.S	LAB_3E8EA		;3e8c6: 6d22
	MOVE.W	(4,A2),-(A7)		;3e8c8: 3f2a0004
	MOVE.W	(2,A2),D0		;3e8cc: 302a0002
	SUB.W	#$0010,D0		;3e8d0: 907c0010
	MOVE.W	D0,-(A7)		;3e8d4: 3f00
	MOVE.W	(A2),D0			;3e8d6: 3012
	SUBQ.W	#8,D0			;3e8d8: 5140
	MOVE.W	D0,-(A7)		;3e8da: 3f00
	MOVE.L	(_w_screen,A4),-(A7)	;3e8dc: 2f2c99e8
	JSR	(___draw_s_32,A4)	;3e8e0: 4eac811c
	LEA	($A,A7),A7		;3e8e4: 4fef000a
	BRA.S	LAB_3E900		;3e8e8: 6016
LAB_3E8EA:
	MOVE.W	(4,A2),-(A7)		;3e8ea: 3f2a0004
	MOVE.W	(2,A2),-(A7)		;3e8ee: 3f2a0002
	MOVE.W	(A2),-(A7)		;3e8f2: 3f12
	MOVE.L	(_w_screen,A4),-(A7)	;3e8f4: 2f2c99e8
	JSR	(___draw_sprite,A4)	;3e8f8: 4eac8116
	LEA	($A,A7),A7		;3e8fc: 4fef000a
LAB_3E900:
	ADDQ.W	#1,D4			;3e900: 5244
	ADDQ.L	#8,A2			;3e902: 508a
LAB_3E904:
	CMP.W	(_no_sprites,A4),D4	;3e904: b86c9a1c
	BLT.S	LAB_3E8C0		;3e908: 6db6
	MOVE.W	#$0054,-(A7)		;3e90a: 3f3c0054
	MOVE.W	(_xoff,A4),D0		;3e90e: 302c99f0
	ADD.W	(_yoff,A4),D0		;3e912: d06c99f2
	ADDQ.W	#6,D0			;3e916: 5c40
	EXT.L	D0			;3e918: 48c0
	DIVS	#$0002,D0		;3e91a: 81fc0002
	SUBQ.W	#3,D0			;3e91e: 5740
	MOVE.W	D0,-(A7)		;3e920: 3f00
	MOVE.W	(_xoff,A4),D0		;3e922: 302c99f0
	ADD.W	#$0043,D0		;3e926: d07c0043
	MOVE.W	(_yoff,A4),D1		;3e92a: 322c99f2
	ADDQ.W	#3,D1			;3e92e: 5641
	SUB.W	D1,D0			;3e930: 9041
	SUBQ.W	#3,D0			;3e932: 5740
	MOVE.W	D0,-(A7)		;3e934: 3f00
	MOVE.L	(_w_screen,A4),-(A7)	;3e936: 2f2c99e8
	JSR	(___draw_sprite,A4)	;3e93a: 4eac8116
	LEA	($A,A7),A7		;3e93e: 4fef000a
	TST.W	(_pause,A4)		;3e942: 4a6c9c22
	BNE.S	LAB_3E95A		;3e946: 6612
	TST.W	(_paint_map,A4)		;3e948: 4a6c9c24
	BNE.S	LAB_3E95A		;3e94c: 660c
	JSR	(_do_funny,PC)		;3e94e: 4eba5b9c
	JSR	(_move_peeps,PC)	;3e952: 4eba1c46
	BRA.W	LAB_3E9FA		;3e956: 600000a2
LAB_3E95A:
	MOVEQ	#0,D4			;3e95a: 7800
	LEA	(_peeps,A4),A0		;3e95c: 41ec9c26
	MOVE.L	A0,(-122,A5)		;3e960: 2b48ff86
	BRA.W	LAB_3E9F2		;3e964: 6000008c
LAB_3E968:
	MOVEA.L	(-122,A5),A0		;3e968: 206dff86
	TST.W	(4,A0)			;3e96c: 4a680004
	BEQ.S	LAB_3E9E8		;3e970: 6776
	MOVEA.L	(-122,A5),A0		;3e972: 206dff86
	MOVEQ	#0,D0			;3e976: 7000
	MOVE.B	(1,A0),D0		;3e978: 10280001
	CMP.W	(_player,A4),D0		;3e97c: b06c99f4
	BEQ.S	LAB_3E988		;3e980: 6706
	TST.W	(_serial_off,A4)	;3e982: 4a6c8254
	BEQ.S	LAB_3E9E8		;3e986: 6760
LAB_3E988:
	MOVEA.L	(-122,A5),A0		;3e988: 206dff86
	BTST	#0,(A0)			;3e98c: 08100000
	BEQ.S	LAB_3E9B8		;3e990: 6726
	MOVEA.L	(-122,A5),A0		;3e992: 206dff86
	MOVEQ	#0,D0			;3e996: 7000
	MOVE.B	(1,A0),D0		;3e998: 10280001
	MOVEQ	#$2E,D1			;3e99c: 722e
	JSR	(___mulu,A4)		;3e99e: 4eac81c4
	LEA	(LAB_516C4,A4),A0	;3e9a2: 41ec82d6
	MOVE.W	(0,A0,D0.L),-(A7)	;3e9a6: 3f300800
	MOVEA.L	(-122,A5),A0		;3e9aa: 206dff86
	MOVE.W	(8,A0),-(A7)		;3e9ae: 3f280008
	JSR	(___a_putpixel,A4)	;3e9b2: 4eac80ce
	ADDQ.W	#4,A7			;3e9b6: 584f
LAB_3E9B8:
	MOVEA.L	(-122,A5),A0		;3e9b8: 206dff86
	BTST	#1,(A0)			;3e9bc: 08100001
	BEQ.S	LAB_3E9E8		;3e9c0: 6726
	MOVEA.L	(-122,A5),A0		;3e9c2: 206dff86
	TST.B	(1,A0)			;3e9c6: 4a280001
	BNE.S	LAB_3E9D0		;3e9ca: 6604
	MOVEQ	#1,D0			;3e9cc: 7001
	BRA.S	LAB_3E9D2		;3e9ce: 6002
LAB_3E9D0:
	MOVEQ	#0,D0			;3e9d0: 7000
LAB_3E9D2:
	MULS	#$0007,D0		;3e9d2: c1fc0007
	ADDQ.W	#8,D0			;3e9d6: 5040
	MOVE.W	D0,-(A7)		;3e9d8: 3f00
	MOVEA.L	(-122,A5),A0		;3e9da: 206dff86
	MOVE.W	(8,A0),-(A7)		;3e9de: 3f280008
	JSR	(___a_putpixel,A4)	;3e9e2: 4eac80ce
	ADDQ.W	#4,A7			;3e9e6: 584f
LAB_3E9E8:
	ADDQ.W	#1,D4			;3e9e8: 5244
	ADDI.L	#$00000016,(-122,A5)	;3e9ea: 06ad00000016ff86
LAB_3E9F2:
	CMP.W	(_no_peeps,A4),D4	;3e9f2: b86cae5e
	BLT.W	LAB_3E968		;3e9f6: 6d00ff70
LAB_3E9FA:
	TST.W	(_view_timer,A4)	;3e9fa: 4a6cae60
	BEQ.S	LAB_3EA1C		;3e9fe: 671c
	SUBQ.W	#1,(_view_timer,A4)	;3ea00: 536cae60
	TST.W	(_left_button,A4)	;3ea04: 4a6cae62
	BEQ.S	LAB_3EA16		;3ea08: 670c
	TST.W	(_right_button,A4)	;3ea0a: 4a6cae64
	BEQ.S	LAB_3EA16		;3ea0e: 6706
	TST.W	(_view_timer,A4)	;3ea10: 4a6cae60
	BNE.S	LAB_3EA1C		;3ea14: 6606
LAB_3EA16:
	MOVE.W	(_old_view_who,A4),(_view_who,A4) ;3ea16: 396cae66ae68
LAB_3EA1C:
	CMPI.W	#$1000,(_game_turn,A4)	;3ea1c: 0c6c1000ae6a
	BNE.S	LAB_3EA34		;3ea22: 6610
; game turn 4096 - place funny
	MOVE.W	(_start_seed,A4),D0	;3ea24: 302c99e4
	AND.W	#$0003,D0		;3ea28: c07c0003
	MOVE.W	D0,-(A7)		;3ea2c: 3f00
	JSR	(_do_place_funny,PC)	;3ea2e: 4eba5dc2
	ADDQ.W	#2,A7			;3ea32: 544f
LAB_3EA34:
	JSR	(_show_the_shield,PC)	;3ea34: 4eba1604
	JSR	(___swap_screens,A4)	;3ea38: 4eac80c8
; Numpad inputs for scrolling the map
	JSR	(___keyboard,A4)	;3ea3c: 4eac80f2
	TST.B	(_inkey,A4)		;3ea40: 4a2cae6c
	BEQ.W	continue_3EC20		;3ea44: 670001da
	MOVEQ	#0,D0			;3ea48: 7000
	MOVE.B	(_inkey,A4),D0		;3ea4a: 102cae6c
	BRA.W	key_3EBBE		;3ea4e: 6000016e
scroll_w:
	TST.W	(_xoff,A4)		;3ea52: 4a6c99f0
	BEQ.S	LAB_3EA5C		;3ea56: 6704
	SUBQ.W	#1,(_xoff,A4)		;3ea58: 536c99f0
LAB_3EA5C:
	BRA.W	continue_3EC20		;3ea5c: 600001c2
scroll_nw:
	TST.W	(_xoff,A4)		;3ea60: 4a6c99f0
	BEQ.S	LAB_3EA6A		;3ea64: 6704
	SUBQ.W	#1,(_xoff,A4)		;3ea66: 536c99f0
LAB_3EA6A:
	TST.W	(_yoff,A4)		;3ea6a: 4a6c99f2
	BEQ.S	LAB_3EA74		;3ea6e: 6704
	SUBQ.W	#1,(_yoff,A4)		;3ea70: 536c99f2
LAB_3EA74:
	BRA.W	continue_3EC20		;3ea74: 600001aa
scroll_n:
	TST.W	(_yoff,A4)		;3ea78: 4a6c99f2
	BEQ.S	LAB_3EA82		;3ea7c: 6704
	SUBQ.W	#1,(_yoff,A4)		;3ea7e: 536c99f2
LAB_3EA82:
	BRA.W	continue_3EC20		;3ea82: 6000019c
scroll_sw:
	TST.W	(_xoff,A4)		;3ea86: 4a6c99f0
	BEQ.S	LAB_3EA90		;3ea8a: 6704
	SUBQ.W	#1,(_xoff,A4)		;3ea8c: 536c99f0
LAB_3EA90:
	CMPI.W	#$0038,(_yoff,A4)	;3ea90: 0c6c003899f2
	BGE.S	LAB_3EA9C		;3ea96: 6c04
	ADDQ.W	#1,(_yoff,A4)		;3ea98: 526c99f2
LAB_3EA9C:
	BRA.W	continue_3EC20		;3ea9c: 60000182
scroll_ne:
	CMPI.W	#$0038,(_xoff,A4)	;3eaa0: 0c6c003899f0
	BGE.S	LAB_3EAAC		;3eaa6: 6c04
	ADDQ.W	#1,(_xoff,A4)		;3eaa8: 526c99f0
LAB_3EAAC:
	TST.W	(_yoff,A4)		;3eaac: 4a6c99f2
	BEQ.S	LAB_3EAB6		;3eab0: 6704
	SUBQ.W	#1,(_yoff,A4)		;3eab2: 536c99f2
LAB_3EAB6:
	BRA.W	continue_3EC20		;3eab6: 60000168
scroll_s:
	CMPI.W	#$0038,(_yoff,A4)	;3eaba: 0c6c003899f2
	BGE.S	LAB_3EAC6		;3eac0: 6c04
	ADDQ.W	#1,(_yoff,A4)		;3eac2: 526c99f2
LAB_3EAC6:
	BRA.W	continue_3EC20		;3eac6: 60000158
scroll_se:
	CMPI.W	#$0038,(_xoff,A4)	;3eaca: 0c6c003899f0
	BGE.S	LAB_3EAD6		;3ead0: 6c04
	ADDQ.W	#1,(_xoff,A4)		;3ead2: 526c99f0
LAB_3EAD6:
	CMPI.W	#$0038,(_yoff,A4)	;3ead6: 0c6c003899f2
	BGE.S	LAB_3EAE2		;3eadc: 6c04
	ADDQ.W	#1,(_yoff,A4)		;3eade: 526c99f2
LAB_3EAE2:
	BRA.W	continue_3EC20		;3eae2: 6000013c
scroll_e:
	CMPI.W	#$0038,(_xoff,A4)	;3eae6: 0c6c003899f0
	BGE.S	LAB_3EAF2		;3eaec: 6c04
	ADDQ.W	#1,(_xoff,A4)		;3eaee: 526c99f0
LAB_3EAF2:
	BRA.W	continue_3EC20		;3eaf2: 6000012c
; ------------------------------------------------------------------------------
; Pressing A on the keyboard automatically wins the round
; ------------------------------------------------------------------------------
debug_key_win:
; New section not in 1989
	MOVEQ	#0,D4			;3eaf6: 7800
	BRA.S	LAB_3EB20		;3eaf8: 6026
LAB_3EAFA:
	MOVE.W	D4,D0			;3eafa: 3004
	MULS	#$0016,D0		;3eafc: c1fc0016
	LEA	(LAB_53015,A4),A0	;3eb00: 41ec9c27
	MOVEQ	#0,D1			;3eb04: 7200
	MOVE.B	(0,A0,D0.L),D1		;3eb06: 12300800
	CMP.W	(_not_player,A4),D1	;3eb0a: b26c825a
	BNE.S	LAB_3EB1E		;3eb0e: 660e
	MOVE.W	D4,D0			;3eb10: 3004
	MULS	#$0016,D0		;3eb12: c1fc0016
	LEA	(LAB_53018,A4),A0	;3eb16: 41ec9c2a
	CLR.W	(0,A0,D0.L)		;3eb1a: 42700800
LAB_3EB1E:
	ADDQ.W	#1,D4			;3eb1e: 5244
LAB_3EB20:
	CMP.W	(_no_peeps,A4),D4	;3eb20: b86cae5e
	BLT.S	LAB_3EAFA		;3eb24: 6dd4
	BRA.W	continue_3EC20		;3eb26: 600000f8
return_3EB2A:
	MOVEM.L	(A7)+,D4/A2		;3eb2a: 4cdf0410
	UNLK	A5			;3eb2e: 4e5d
	RTS				;3eb30: 4e75
; ------------------------------------------------------------------------------
; Pressing F9 displays debug information
; ------------------------------------------------------------------------------
debug_key_stats:
	JSR	(___display_debug,A4)	;3eb32: 4eac80e0
	BRA.W	continue_3EC20		;3eb36: 600000e8
; ------------------------------------------------------------------------------
; Pressing asterisk on the keyboard:
; not sure what it activates
; ------------------------------------------------------------------------------
debug_key_asterisk:
; new section ends
	CMPI.W	#$0136,(_mousex,A4)	;3eb3a: 0c6c013699aa
	BLE.S	LAB_3EBA4		;3eb40: 6f62
	CMPI.W	#$000a,(_mousey,A4)	;3eb42: 0c6c000aae6e
	BLT.S	LAB_3EBA4		;3eb48: 6d5a
	CMPI.W	#$0014,(_mousey,A4)	;3eb4a: 0c6c0014ae6e
	BGT.S	LAB_3EBA4		;3eb50: 6e52
	BTST	#0,(bitfield_51645,A4)	;3eb52: 082c00008257
	BEQ.S	LAB_3EBA4		;3eb58: 674a
; ------------------------------------------------------------------------------
; Here, some kind of cheat appears to be activated.
; Press keypad asterisk to activate.
; The mouse pointer must also be at x 311-320 and y 10-20
; (just below the top right of the screen)
; Some flag #0 must be set
; Unsure what it does
; ------------------------------------------------------------------------------
	PEA	(strCHEAT,PC)		;3eb5a: 487a013c
	MOVE.W	#$000a,-(A7)		;3eb5e: 3f3c000a
	CLR.W	-(A7)			;3eb62: 4267
	MOVE.L	(_w_screen,A4),-(A7)	;3eb64: 2f2c99e8
	JSR	(___text,A4)		;3eb68: 4eac813a
	LEA	($C,A7),A7		;3eb6c: 4fef000c
	MOVE.W	(_player,A4),D0		;3eb70: 302c99f4
	MULS	#$002e,D0		;3eb74: c1fc002e
	LEA	(_stats,A4),A0		;3eb78: 41ec82b6
	CLR.B	(0,A0,D0.L)		;3eb7c: 42300800
	MOVE.W	(_player,A4),D0		;3eb80: 302c99f4
	MULS	#$002e,D0		;3eb84: c1fc002e
	LEA	(LAB_516A6,A4),A0	;3eb88: 41ec82b8
	MOVE.B	#$0f,(0,A0,D0.L)	;3eb8c: 11bc000f0800
	MOVE.W	(_player,A4),D0		;3eb92: 302c99f4
	MULS	#$002e,D0		;3eb96: c1fc002e
	LEA	(LAB_516A5,A4),A0	;3eb9a: 41ec82b7
	MOVE.B	(LAB_52DE3,A4),(0,A0,D0.L) ;3eb9e: 11ac99f50800
LAB_3EBA4:
	BRA.S	continue_3EC20		;3eba4: 607a
LAB_3EBA6:
	MOVE.W	(_player,A4),D0		;3eba6: 302c99f4
	MULS	#$002e,D0		;3ebaa: c1fc002e
	LEA	(_stats,A4),A0		;3ebae: 41ec82b6
	ADD.L	A0,D0			;3ebb2: d088
	MOVE.L	D0,-(A7)		;3ebb4: 2f00
	JSR	(___paint_the_map,A4)	;3ebb6: 4eac8098
	ADDQ.W	#4,A7			;3ebba: 584f
	BRA.S	continue_3EC20		;3ebbc: 6062
; ------------------------------------------------------------------------------
; handle keyboard input
; d0 = key scancode
; Numpad asterisk: ?
; F9: Stats
; Numpad directions: Scroll map
; ------------------------------------------------------------------------------
key_3EBBE:
; new
; numpad asterisk
	SUB.L	#$00000045,D0		;3ebbe: 90bc00000045
	BEQ.W	debug_key_asterisk	;3ebc4: 6700ff74
; F9
	SUB.L	#$0000000a,D0		;3ebc8: 90bc0000000a
	BEQ.W	debug_key_stats		;3ebce: 6700ff62
; end new
	SUB.L	#$00000026,D0		;3ebd2: 90bc00000026
; esc
	BEQ.W	return_3EB2A		;3ebd8: 6700ff50
	SUB.L	#$0000000c,D0		;3ebdc: 90bc0000000c
; numpad directions
	BEQ.W	scroll_n		;3ebe2: 6700fe94
	SUBQ.L	#2,D0			;3ebe6: 5580
	BEQ.W	scroll_nw		;3ebe8: 6700fe76
	SUBQ.L	#2,D0			;3ebec: 5580
	BEQ.W	scroll_w		;3ebee: 6700fe62
	SUB.L	#$0000001c,D0		;3ebf2: 90bc0000001c
	BEQ.W	scroll_ne		;3ebf8: 6700fea6
	SUBQ.L	#4,D0			;3ebfc: 5980
	BEQ.W	scroll_sw		;3ebfe: 6700fe86
; These may be the two new lines
; A
	SUB.L	#$0000001a,D0		;3ec02: 90bc0000001a
	BEQ.W	debug_key_win		;3ec08: 6700feec
;  
	SUBQ.L	#2,D0			;3ec0c: 5580
	BEQ.W	scroll_e		;3ec0e: 6700fed6
	SUBQ.L	#2,D0			;3ec12: 5580
	BEQ.W	scroll_se		;3ec14: 6700feb4
	SUBQ.L	#2,D0			;3ec18: 5580
	BEQ.W	scroll_s		;3ec1a: 6700fe9e
	BRA.S	LAB_3EBA6		;3ec1e: 6086
continue_3EC20:
	MOVE.W	(_mode,A4),D0		;3ec20: 302c8256
	AND.W	#$000e,D0		;3ec24: c07c000e
	BEQ.S	LAB_3EC30		;3ec28: 6706
	JSR	(_sculpt,PC)		;3ec2a: 4eba48da
	BRA.S	LAB_3EC40		;3ec2e: 6010
LAB_3EC30:
	TST.W	(_left_button,A4)	;3ec30: 4a6cae62
	BEQ.S	LAB_3EC3C		;3ec34: 6706
	TST.W	(_right_button,A4)	;3ec36: 4a6cae64
	BNE.S	LAB_3EC40		;3ec3a: 6604
LAB_3EC3C:
	JSR	(_interogate,PC)	;3ec3c: 4eba1384
LAB_3EC40:
	TST.W	(_left_button,A4)	;3ec40: 4a6cae62
	BEQ.S	LAB_3EC4C		;3ec44: 6706
	TST.W	(_right_button,A4)	;3ec46: 4a6cae64
	BNE.S	LAB_3EC60		;3ec4a: 6614
LAB_3EC4C:
	TST.W	(_left_button,A4)	;3ec4c: 4a6cae62
	BNE.S	LAB_3EC56		;3ec50: 6604
	MOVEQ	#1,D0			;3ec52: 7001
	BRA.S	LAB_3EC58		;3ec54: 6002
LAB_3EC56:
	MOVEQ	#0,D0			;3ec56: 7000
LAB_3EC58:
	MOVE.W	D0,-(A7)		;3ec58: 3f00
	JSR	(_zoom_map,PC)		;3ec5a: 4eba069a
	ADDQ.W	#2,A7			;3ec5e: 544f
LAB_3EC60:
	CMPI.W	#$0002,(_left_button,A4) ;3ec60: 0c6c0002ae62
	BNE.S	LAB_3EC6C		;3ec66: 6604
	MOVEQ	#1,D0			;3ec68: 7001
	BRA.S	LAB_3EC6E		;3ec6a: 6002
LAB_3EC6C:
	MOVEQ	#0,D0			;3ec6c: 7000
LAB_3EC6E:
	ADDQ.W	#1,D0			;3ec6e: 5240
	MOVE.W	D0,(_left_button,A4)	;3ec70: 3940ae62
	CMPI.W	#$0002,(_right_button,A4) ;3ec74: 0c6c0002ae64
	BNE.S	LAB_3EC80		;3ec7a: 6604
	MOVEQ	#1,D0			;3ec7c: 7001
	BRA.S	LAB_3EC82		;3ec7e: 6002
LAB_3EC80:
	MOVEQ	#0,D0			;3ec80: 7000
LAB_3EC82:
	ADDQ.W	#1,D0			;3ec82: 5240
	MOVE.W	D0,(_right_button,A4)	;3ec84: 3940ae64
	CLR.W	-(A7)			;3ec88: 4267
	JSR	(___get_message,A4)	;3ec8a: 4eac80e6
	ADDQ.W	#2,A7			;3ec8e: 544f
	BRA.W	LAB_3E7E8		;3ec90: 6000fb56
; small optimization here
	BRA.W	return_3EB2A		;3ec94: 6000fe94
strCHEAT:
	;3ec98
	;DC.B	$43,$48,$45,$41,$54,$00
	DC.B	"CHEAT",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_clear_map:
	LINK.W	A5,#0			;3ec9e: 4e550000
	MOVEM.L	D4-D5,-(A7)		;3eca2: 48e70c00
	TST.W	(_start_of_game,A4)	;3eca6: 4a6c9898
	BNE.S	LAB_3ECC8		;3ecaa: 661c
	MOVE.W	#$0001,-(A7)		;3ecac: 3f3c0001
	MOVE.W	#$0006,-(A7)		;3ecb0: 3f3c0006
	JSR	(_set_mode_icons,PC)	;3ecb4: 4eba1128
	ADDQ.W	#4,A7			;3ecb8: 584f
	MOVE.W	#$0003,-(A7)		;3ecba: 3f3c0003
	MOVE.W	#$0004,-(A7)		;3ecbe: 3f3c0004
	JSR	(_set_tend_icons,PC)	;3ecc2: 4eba103e
	ADDQ.W	#4,A7			;3ecc6: 584f
LAB_3ECC8:
	MOVEQ	#0,D4			;3ecc8: 7800
LAB_3ECCA:
	MOVE.W	D4,D0			;3ecca: 3004
	MULS	#$0016,D0		;3eccc: c1fc0016
	LEA	(LAB_53018,A4),A0	;3ecd0: 41ec9c2a
	CLR.W	(0,A0,D0.L)		;3ecd4: 42700800
	ADDQ.W	#1,D4			;3ecd8: 5244
	CMP.W	#$00d3,D4		;3ecda: b87c00d3
	BNE.S	LAB_3ECCA		;3ecde: 66ea
	CLR.W	(_no_peeps,A4)		;3ece0: 426cae5e
	CMPI.W	#$0001,(_player,A4)	;3ece4: 0c6c000199f4
	BNE.S	LAB_3ECF0		;3ecea: 6604
	MOVEQ	#1,D0			;3ecec: 7001
	BRA.S	LAB_3ECF2		;3ecee: 6002
LAB_3ECF0:
	MOVEQ	#0,D0			;3ecf0: 7000
LAB_3ECF2:
	MULS	#$0003,D0		;3ecf2: c1fc0003
	ADDQ.W	#1,D0			;3ecf6: 5240
	MOVE.W	D0,(_pointer,A4)	;3ecf8: 394084b6
	CLR.W	(_funny_done,A4)	;3ecfc: 426cae70
	CLR.L	(_score,A4)		;3ed00: 42acae72
	MOVEQ	#0,D4			;3ed04: 7800
LAB_3ED06:
	MOVE.W	D4,D0			;3ed06: 3004
	EXT.L	D0			;3ed08: 48c0
	ASL.L	#4,D0			;3ed0a: e980
	LEA	(LAB_52DE8,A4),A0	;3ed0c: 41ec99fa
	MOVE.W	#$0001,(0,A0,D0.L)	;3ed10: 31bc00010800
	MOVE.W	D4,D0			;3ed16: 3004
	EXT.L	D0			;3ed18: 48c0
	ASL.L	#4,D0			;3ed1a: e980
	LEA	(LAB_52DF0,A4),A0	;3ed1c: 41ec9a02
	MOVE.L	#$0000018f,(0,A0,D0.L)	;3ed20: 21bc0000018f0800
	MOVE.W	D4,D0			;3ed28: 3004
	EXT.L	D0			;3ed2a: 48c0
	ASL.L	#4,D0			;3ed2c: e980
	LEA	(LAB_52DE6,A4),A0	;3ed2e: 41ec99f8
	MOVE.W	#$0820,(0,A0,D0.L)	;3ed32: 31bc08200800
	MOVE.W	#$0820,(_devil_magnet,A4) ;3ed38: 397c0820ae76
	MOVE.W	#$0820,(_god_magnet,A4)	;3ed3e: 397c0820ae78
	MOVE.W	D4,D0			;3ed44: 3004
	EXT.L	D0			;3ed46: 48c0
	ASL.L	#4,D0			;3ed48: e980
	LEA	(_magnet,A4),A0		;3ed4a: 41ec99f6
	CLR.W	(0,A0,D0.L)		;3ed4e: 42700800
	MOVE.W	D4,D0			;3ed52: 3004
	EXT.L	D0			;3ed54: 48c0
	ASL.L	#1,D0			;3ed56: e380
	LEA	(_battle_won,A4),A0	;3ed58: 41ecae7a
	CLR.W	(0,A0,D0.L)		;3ed5c: 42700800
	MOVE.W	D4,D0			;3ed60: 3004
	MULS	#$002e,D0		;3ed62: c1fc002e
	LEA	(LAB_516BE,A4),A0	;3ed66: 41ec82d0
	MOVE.L	D0,-(A7)		;3ed6a: 2f00
	MOVE.L	A0,-(A7)		;3ed6c: 2f08
	JSR	(___newrand,A4)		;3ed6e: 4eac80fe
	MOVEA.L	(A7)+,A0		;3ed72: 205f
	MOVE.L	(A7)+,D1		;3ed74: 221f
	EXT.L	D0			;3ed76: 48c0
	DIVS	#$0003,D0		;3ed78: 81fc0003
	SWAP	D0			;3ed7c: 4840
	MOVE.W	D0,(0,A0,D1.L)		;3ed7e: 31801800
	MOVE.W	D4,D0			;3ed82: 3004
	MULS	#$002e,D0		;3ed84: c1fc002e
	LEA	(LAB_516BC,A4),A0	;3ed88: 41ec82ce
	MOVE.W	D4,D1			;3ed8c: 3204
	MULS	#$002e,D1		;3ed8e: c3fc002e
	LEA	(LAB_516BE,A4),A1	;3ed92: 43ec82d0
	MOVE.L	D0,-(A7)		;3ed96: 2f00
	MOVE.L	A0,-(A7)		;3ed98: 2f08
	MOVE.L	D1,-(A7)		;3ed9a: 2f01
	MOVE.L	A1,-(A7)		;3ed9c: 2f09
	JSR	(___newrand,A4)		;3ed9e: 4eac80fe
	EXT.L	D0			;3eda2: 48c0
	DIVS	#$0005,D0		;3eda4: 81fc0005
	SWAP	D0			;3eda8: 4840
	MOVEA.L	(A7)+,A0		;3edaa: 205f
	MOVE.L	(A7)+,D1		;3edac: 221f
	MOVE.W	(0,A0,D1.L),D2		;3edae: 34301800
	ADD.W	D0,D2			;3edb2: d440
	MOVEA.L	(A7)+,A0		;3edb4: 205f
	MOVE.L	(A7)+,D0		;3edb6: 201f
	ADDQ.W	#1,D2			;3edb8: 5242
	MOVE.W	D2,(0,A0,D0.L)		;3edba: 31820800
	MOVE.W	D4,D0			;3edbe: 3004
	MULS	#$002e,D0		;3edc0: c1fc002e
	LEA	(LAB_516B6,A4),A0	;3edc4: 41ec82c8
	CLR.W	(0,A0,D0.L)		;3edc8: 42700800
	MOVE.W	D4,D0			;3edcc: 3004
	MULS	#$002e,D0		;3edce: c1fc002e
	LEA	(LAB_516C0,A4),A0	;3edd2: 41ec82d2
	CLR.W	(0,A0,D0.L)		;3edd6: 42700800
	ADDQ.W	#1,D4			;3edda: 5244
	CMP.W	#$0002,D4		;3eddc: b87c0002
	BNE.W	LAB_3ED06		;3ede0: 6600ff24
	JSR	(___clear_send,A4)	;3ede4: 4eac80ec
	CMPI.W	#$0003,(_start_of_game,A4) ;3ede8: 0c6c00039898
	BNE.S	LAB_3EDF6		;3edee: 6606
	MOVE.L	(LAB_5188C,A4),(LAB_52DF0,A4) ;3edf0: 296c849e9a02
LAB_3EDF6:
	CMPI.W	#$ffff,(_in_conquest,A4) ;3edf6: 0c6cffff84ba
	BEQ.S	LAB_3EE14		;3edfc: 6716
	CMPI.W	#$04d3,(_level_number,A4) ;3edfe: 0c6c04d3ae7e
	BLE.S	LAB_3EE14		;3ee04: 6f0e
	MOVE.L	(LAB_51880,A4),D0	;3ee06: 202c8492
	ADD.L	#$000000c8,D0		;3ee0a: d0bc000000c8
	MOVE.L	D0,(LAB_52E00,A4)	;3ee10: 29409a12
LAB_3EE14:
; init some variables
	CLR.W	(_game_turn,A4)		;3ee14: 426cae6a
	MOVE.W	#$0002,(_mode,A4)	;3ee18: 397c00028256
	MOVE.W	#$ffff,(_surender,A4)	;3ee1e: 397cffff8258
	CLR.W	(_war,A4)		;3ee24: 426cae80
	MOVE.W	#$0002,(_right_button,A4) ;3ee28: 397c0002ae64
	MOVE.W	#$0002,(_left_button,A4) ;3ee2e: 397c0002ae62
	CLR.B	(_inkey,A4)		;3ee34: 422cae6c
	MOVE.L	(___the_prot1,A4),(_the_prot3,A4) ;3ee38: 296c80f8ae82
	MOVEQ	#0,D4			;3ee3e: 7800
LAB_3EE40:
	MOVE.W	D4,D0			;3ee40: 3004
	EXT.L	D0			;3ee42: 48c0
	ASL.L	#1,D0			;3ee44: e380
	LEA	(_alt,A4),A0		;3ee46: 41ecae86
	CLR.W	(0,A0,D0.L)		;3ee4a: 42700800
	ADDQ.W	#1,D4			;3ee4e: 5244
	CMP.W	#$1081,D4		;3ee50: b87c1081
	BLT.S	LAB_3EE40		;3ee54: 6dea
	MOVEQ	#0,D4			;3ee56: 7800
LAB_3EE58:
	LEA	(_map_blk,A4),A0	;3ee58: 41eccf88
	CLR.B	(0,A0,D4.W)		;3ee5c: 42304000
	LEA	(_map_alt,A4),A0	;3ee60: 41ecdf88
	CLR.B	(0,A0,D4.W)		;3ee64: 42304000
	LEA	(_map_bk2,A4),A0	;3ee68: 41ecef88
	CLR.B	(0,A0,D4.W)		;3ee6c: 42304000
	MOVE.W	D4,D0			;3ee70: 3004
	EXT.L	D0			;3ee72: 48c0
	ASL.L	#1,D0			;3ee74: e380
	LEA	(_map_steps,A4),A0	;3ee76: 41ecff88
	CLR.W	(0,A0,D0.L)		;3ee7a: 42700800
	LEA	(_map_who,A4),A0	;3ee7e: 41ec1f88
	CLR.B	(0,A0,D4.W)		;3ee82: 42304000
	ADDQ.W	#1,D4			;3ee86: 5244
	CMP.W	#$1000,D4		;3ee88: b87c1000
	BLT.S	LAB_3EE58		;3ee8c: 6dca
	MOVEM.L	(A7)+,D4-D5		;3ee8e: 4cdf0030
	UNLK	A5			;3ee92: 4e5d
	RTS				;3ee94: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_make_alt:
	LINK.W	A5,#0			;3ee96: 4e550000
	MOVE.W	#$0004,-(A7)		;3ee9a: 3f3c0004
	MOVE.W	#$0002,-(A7)		;3ee9e: 3f3c0002
	BSR.S	_make_thing		;3eea2: 611e
	ADDQ.W	#4,A7			;3eea4: 584f
	MOVE.W	#$0002,-(A7)		;3eea6: 3f3c0002
	MOVE.W	#$0004,-(A7)		;3eeaa: 3f3c0004
	BSR.S	_make_thing		;3eeae: 6112
	ADDQ.W	#4,A7			;3eeb0: 584f
	MOVE.W	#$0003,-(A7)		;3eeb2: 3f3c0003
	MOVE.W	#$0003,-(A7)		;3eeb6: 3f3c0003
	BSR.S	_make_thing		;3eeba: 6106
	ADDQ.W	#4,A7			;3eebc: 584f
	UNLK	A5			;3eebe: 4e5d
	RTS				;3eec0: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_make_thing:
	LINK.W	A5,#0			;3eec2: 4e550000
	MOVEM.L	D4-D5,-(A7)		;3eec6: 48e70c00
	JSR	(___newrand,A4)		;3eeca: 4eac80fe
	MOVE.W	D0,D4			;3eece: 3800
	EXT.L	D4			;3eed0: 48c4
	DIVS	#$0040,D4		;3eed2: 89fc0040
	SWAP	D4			;3eed6: 4844
	JSR	(___newrand,A4)		;3eed8: 4eac80fe
	MOVE.W	D0,D5			;3eedc: 3a00
	EXT.L	D5			;3eede: 48c5
	DIVS	#$0040,D5		;3eee0: 8bfc0040
	SWAP	D5			;3eee4: 4845
LAB_3EEE6:
	MOVE.W	D5,-(A7)		;3eee6: 3f05
	MOVE.W	D4,-(A7)		;3eee8: 3f04
	BSR.S	_raise_point		;3eeea: 6166
	ADDQ.W	#4,A7			;3eeec: 584f
	CMP.W	#$0006,D0		;3eeee: b07c0006
	BEQ.S	LAB_3EF4A		;3eef2: 6756
	JSR	(___newrand,A4)		;3eef4: 4eac80fe
	MOVE.W	(8,A5),D1		;3eef8: 322d0008
	ASL.W	#1,D1			;3eefc: e341
	ADDQ.W	#1,D1			;3eefe: 5241
	EXT.L	D0			;3ef00: 48c0
	DIVS	D1,D0			;3ef02: 81c1
	SWAP	D0			;3ef04: 4840
	MOVE.W	(8,A5),D1		;3ef06: 322d0008
	NEG.W	D1			;3ef0a: 4441
	ADD.W	D1,D0			;3ef0c: d041
	ADD.W	D0,D4			;3ef0e: d840
	JSR	(___newrand,A4)		;3ef10: 4eac80fe
	MOVE.W	($A,A5),D1		;3ef14: 322d000a
	ASL.W	#1,D1			;3ef18: e341
	ADDQ.W	#1,D1			;3ef1a: 5241
	EXT.L	D0			;3ef1c: 48c0
	DIVS	D1,D0			;3ef1e: 81c1
	SWAP	D0			;3ef20: 4840
	MOVE.W	($A,A5),D1		;3ef22: 322d000a
	NEG.W	D1			;3ef26: 4441
	ADD.W	D1,D0			;3ef28: d041
	ADD.W	D0,D5			;3ef2a: da40
	TST.W	D4			;3ef2c: 4a44
	BGE.S	LAB_3EF32		;3ef2e: 6c02
	MOVEQ	#0,D4			;3ef30: 7800
LAB_3EF32:
	CMP.W	#$0040,D4		;3ef32: b87c0040
	BLE.S	LAB_3EF3A		;3ef36: 6f02
	MOVEQ	#$40,D4			;3ef38: 7840
LAB_3EF3A:
	TST.W	D5			;3ef3a: 4a45
	BGE.S	LAB_3EF40		;3ef3c: 6c02
	MOVEQ	#0,D5			;3ef3e: 7a00
LAB_3EF40:
	CMP.W	#$0040,D5		;3ef40: ba7c0040
	BLE.S	LAB_3EF48		;3ef44: 6f02
	MOVEQ	#$40,D5			;3ef46: 7a40
LAB_3EF48:
	BRA.S	LAB_3EEE6		;3ef48: 609c
LAB_3EF4A:
	MOVEM.L	(A7)+,D4-D5		;3ef4a: 4cdf0030
	UNLK	A5			;3ef4e: 4e5d
	RTS				;3ef50: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_raise_point:
	LINK.W	A5,#0			;3ef52: 4e550000
	MOVEM.L	D4-D5/A2-A3,-(A7)	;3ef56: 48e70c30
	MOVE.W	(8,A5),D4		;3ef5a: 382d0008
	MOVE.W	($A,A5),D5		;3ef5e: 3a2d000a
	CMP.W	#$0040,D4		;3ef62: b87c0040
	BGT.S	LAB_3EF76		;3ef66: 6e0e
	TST.W	D4			;3ef68: 4a44
	BLT.S	LAB_3EF76		;3ef6a: 6d0a
	CMP.W	#$0040,D5		;3ef6c: ba7c0040
	BGT.S	LAB_3EF76		;3ef70: 6e04
	TST.W	D5			;3ef72: 4a45
	BGE.S	LAB_3EF80		;3ef74: 6c0a
LAB_3EF76:
	MOVEQ	#0,D0			;3ef76: 7000
LAB_3EF78:
	MOVEM.L	(A7)+,D4-D5/A2-A3	;3ef78: 4cdf0c30
	UNLK	A5			;3ef7c: 4e5d
	RTS				;3ef7e: 4e75
LAB_3EF80:
	MOVE.W	D5,D0			;3ef80: 3005
	MULS	#$0041,D0		;3ef82: c1fc0041
	ADD.W	D4,D0			;3ef86: d044
	EXT.L	D0			;3ef88: 48c0
	ASL.L	#1,D0			;3ef8a: e380
	LEA	(_alt,A4),A0		;3ef8c: 41ecae86
	MOVEA.L	D0,A2			;3ef90: 2440
	ADDA.L	A0,A2			;3ef92: d5c8
	CMPI.W	#$0008,(A2)		;3ef94: 0c520008
	BGE.W	LAB_3F0AC		;3ef98: 6c000112
	ADDQ.W	#1,(_build_count,A4)	;3ef9c: 526c2f88
	ADDQ.W	#1,(A2)			;3efa0: 5252
	MOVEA.L	A2,A3			;3efa2: 264a
	ADDQ.L	#2,A3			;3efa4: 548b
	ADDQ.W	#1,D4			;3efa6: 5244
	MOVE.W	(A2),D0			;3efa8: 3012
	SUB.W	(A3),D0			;3efaa: 9053
	CMP.W	#$0001,D0		;3efac: b07c0001
	BLE.S	LAB_3EFBA		;3efb0: 6f08
	MOVE.W	D5,-(A7)		;3efb2: 3f05
	MOVE.W	D4,-(A7)		;3efb4: 3f04
	BSR.S	_raise_point		;3efb6: 619a
	ADDQ.W	#4,A7			;3efb8: 584f
LAB_3EFBA:
	ADDA.L	#$00000082,A3		;3efba: d7fc00000082
	ADDQ.W	#1,D5			;3efc0: 5245
	MOVE.W	(A2),D0			;3efc2: 3012
	SUB.W	(A3),D0			;3efc4: 9053
	CMP.W	#$0001,D0		;3efc6: b07c0001
	BLE.S	LAB_3EFD4		;3efca: 6f08
	MOVE.W	D5,-(A7)		;3efcc: 3f05
	MOVE.W	D4,-(A7)		;3efce: 3f04
	BSR.S	_raise_point		;3efd0: 6180
	ADDQ.W	#4,A7			;3efd2: 584f
LAB_3EFD4:
	SUBQ.L	#2,A3			;3efd4: 558b
	SUBQ.W	#1,D4			;3efd6: 5344
	MOVE.W	(A2),D0			;3efd8: 3012
	SUB.W	(A3),D0			;3efda: 9053
	CMP.W	#$0001,D0		;3efdc: b07c0001
	BLE.S	LAB_3EFEC		;3efe0: 6f0a
	MOVE.W	D5,-(A7)		;3efe2: 3f05
	MOVE.W	D4,-(A7)		;3efe4: 3f04
	JSR	(_raise_point,PC)	;3efe6: 4ebaff6a
	ADDQ.W	#4,A7			;3efea: 584f
LAB_3EFEC:
	SUBQ.L	#2,A3			;3efec: 558b
	SUBQ.W	#1,D4			;3efee: 5344
	MOVE.W	(A2),D0			;3eff0: 3012
	SUB.W	(A3),D0			;3eff2: 9053
	CMP.W	#$0001,D0		;3eff4: b07c0001
	BLE.S	LAB_3F004		;3eff8: 6f0a
	MOVE.W	D5,-(A7)		;3effa: 3f05
	MOVE.W	D4,-(A7)		;3effc: 3f04
	JSR	(_raise_point,PC)	;3effe: 4ebaff52
	ADDQ.W	#4,A7			;3f002: 584f
LAB_3F004:
	SUBA.L	#$00000082,A3		;3f004: 97fc00000082
	SUBQ.W	#1,D5			;3f00a: 5345
	MOVE.W	(A2),D0			;3f00c: 3012
	SUB.W	(A3),D0			;3f00e: 9053
	CMP.W	#$0001,D0		;3f010: b07c0001
	BLE.S	LAB_3F020		;3f014: 6f0a
	MOVE.W	D5,-(A7)		;3f016: 3f05
	MOVE.W	D4,-(A7)		;3f018: 3f04
	JSR	(_raise_point,PC)	;3f01a: 4ebaff36
	ADDQ.W	#4,A7			;3f01e: 584f
LAB_3F020:
	SUBA.L	#$00000082,A3		;3f020: 97fc00000082
	SUBQ.W	#1,D5			;3f026: 5345
	MOVE.W	(A2),D0			;3f028: 3012
	SUB.W	(A3),D0			;3f02a: 9053
	CMP.W	#$0001,D0		;3f02c: b07c0001
	BLE.S	LAB_3F03C		;3f030: 6f0a
	MOVE.W	D5,-(A7)		;3f032: 3f05
	MOVE.W	D4,-(A7)		;3f034: 3f04
	JSR	(_raise_point,PC)	;3f036: 4ebaff1a
	ADDQ.W	#4,A7			;3f03a: 584f
LAB_3F03C:
	ADDQ.L	#2,A3			;3f03c: 548b
	ADDQ.W	#1,D4			;3f03e: 5244
	MOVE.W	(A2),D0			;3f040: 3012
	SUB.W	(A3),D0			;3f042: 9053
	CMP.W	#$0001,D0		;3f044: b07c0001
	BLE.S	LAB_3F054		;3f048: 6f0a
	MOVE.W	D5,-(A7)		;3f04a: 3f05
	MOVE.W	D4,-(A7)		;3f04c: 3f04
	JSR	(_raise_point,PC)	;3f04e: 4ebaff02
	ADDQ.W	#4,A7			;3f052: 584f
LAB_3F054:
	ADDQ.L	#2,A3			;3f054: 548b
	ADDQ.W	#1,D4			;3f056: 5244
	MOVE.W	(A2),D0			;3f058: 3012
	SUB.W	(A3),D0			;3f05a: 9053
	CMP.W	#$0001,D0		;3f05c: b07c0001
	BLE.S	LAB_3F06C		;3f060: 6f0a
	MOVE.W	D5,-(A7)		;3f062: 3f05
	MOVE.W	D4,-(A7)		;3f064: 3f04
	JSR	(_raise_point,PC)	;3f066: 4ebafeea
	ADDQ.W	#4,A7			;3f06a: 584f
LAB_3F06C:
	MOVE.W	(8,A5),D0		;3f06c: 302d0008
	CMP.W	(_xmin,A4),D0		;3f070: b06c2f8a
	BGE.S	LAB_3F07C		;3f074: 6c06
	MOVE.W	(8,A5),(_xmin,A4)	;3f076: 396d00082f8a
LAB_3F07C:
	MOVE.W	(8,A5),D0		;3f07c: 302d0008
	CMP.W	(_xmax,A4),D0		;3f080: b06c2f8c
	BLE.S	LAB_3F08C		;3f084: 6f06
	MOVE.W	(8,A5),(_xmax,A4)	;3f086: 396d00082f8c
LAB_3F08C:
	MOVE.W	($A,A5),D0		;3f08c: 302d000a
	CMP.W	(_ymin,A4),D0		;3f090: b06c2f8e
	BGE.S	LAB_3F09C		;3f094: 6c06
	MOVE.W	($A,A5),(_ymin,A4)	;3f096: 396d000a2f8e
LAB_3F09C:
	MOVE.W	($A,A5),D0		;3f09c: 302d000a
	CMP.W	(_ymax,A4),D0		;3f0a0: b06c2f90
	BLE.S	LAB_3F0AC		;3f0a4: 6f06
	MOVE.W	($A,A5),(_ymax,A4)	;3f0a6: 396d000a2f90
LAB_3F0AC:
	MOVE.W	(A2),D0			;3f0ac: 3012
	BRA.W	LAB_3EF78		;3f0ae: 6000fec8
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_make_map:
	LINK.W	A5,#-4			;3f0b2: 4e55fffc
	MOVEM.L	D4-D7/A2,-(A7)		;3f0b6: 48e70f20
	MOVE.W	(8,A5),D4		;3f0ba: 382d0008
	BRA.W	LAB_3F1D0		;3f0be: 60000110
LAB_3F0C2:
	MOVE.W	($A,A5),D5		;3f0c2: 3a2d000a
	BRA.W	LAB_3F1C6		;3f0c6: 600000fe
LAB_3F0CA:
	MOVEQ	#0,D6			;3f0ca: 7c00
	MOVE.W	D5,D0			;3f0cc: 3005
	ASL.W	#6,D0			;3f0ce: ed40
	MOVEA.W	D0,A2			;3f0d0: 3440
	ADDA.W	D4,A2			;3f0d2: d4c4
	MOVE.W	D5,D0			;3f0d4: 3005
	MULS	#$0041,D0		;3f0d6: c1fc0041
	ADD.W	D4,D0			;3f0da: d044
	EXT.L	D0			;3f0dc: 48c0
	ASL.L	#1,D0			;3f0de: e380
	LEA	(_alt,A4),A0		;3f0e0: 41ecae86
	ADD.L	A0,D0			;3f0e4: d088
	MOVE.L	D0,(-4,A5)		;3f0e6: 2b40fffc
	MOVEA.L	(-4,A5),A0		;3f0ea: 206dfffc
	MOVEA.L	(-4,A5),A1		;3f0ee: 226dfffc
	MOVE.W	(2,A0),D0		;3f0f2: 30280002
	ADD.W	($82,A1),D0		;3f0f6: d0690082
	MOVEA.L	(-4,A5),A0		;3f0fa: 206dfffc
	ADD.W	($84,A0),D0		;3f0fe: d0680084
	MOVEA.L	(-4,A5),A0		;3f102: 206dfffc
	ADD.W	(A0),D0			;3f106: d050
	MOVE.W	D0,D7			;3f108: 3e00
	ASR.W	#2,D7			;3f10a: e447
	MOVEA.L	(-4,A5),A0		;3f10c: 206dfffc
	MOVE.W	(A0),D0			;3f110: 3010
	CMP.W	D7,D0			;3f112: b047
	BLE.S	LAB_3F118		;3f114: 6f02
	ADDQ.W	#1,D6			;3f116: 5246
LAB_3F118:
	MOVEA.L	(-4,A5),A0		;3f118: 206dfffc
	MOVE.W	(2,A0),D0		;3f11c: 30280002
	CMP.W	D7,D0			;3f120: b047
	BLE.S	LAB_3F126		;3f122: 6f02
	ADDQ.W	#2,D6			;3f124: 5446
LAB_3F126:
	MOVEA.L	(-4,A5),A0		;3f126: 206dfffc
	MOVE.W	($84,A0),D0		;3f12a: 30280084
	CMP.W	D7,D0			;3f12e: b047
	BLE.S	LAB_3F134		;3f130: 6f02
	ADDQ.W	#4,D6			;3f132: 5846
LAB_3F134:
	MOVEA.L	(-4,A5),A0		;3f134: 206dfffc
	MOVE.W	($82,A0),D0		;3f138: 30280082
	CMP.W	D7,D0			;3f13c: b047
	BLE.S	LAB_3F142		;3f13e: 6f02
	ADDQ.W	#8,D6			;3f140: 5046
LAB_3F142:
	LEA	(_map_blk,A4),A0	;3f142: 41eccf88
	CMPI.B	#$2f,(0,A0,A2.W)	;3f146: 0c30002fa000
	BNE.S	LAB_3F156		;3f14c: 6608
	TST.W	D6			;3f14e: 4a46
	BNE.S	LAB_3F160		;3f150: 660e
	TST.W	D7			;3f152: 4a47
	BNE.S	LAB_3F160		;3f154: 660a
LAB_3F156:
	LEA	(_map_blk,A4),A0	;3f156: 41eccf88
	MOVE.B	D6,(0,A0,A2.W)		;3f15a: 1186a000
	BRA.S	LAB_3F16C		;3f15e: 600c
LAB_3F160:
	LEA	(_map_blk,A4),A0	;3f160: 41eccf88
	MOVEQ	#0,D0			;3f164: 7000
	MOVE.B	(0,A0,A2.W),D0		;3f166: 1030a000
	MOVE.W	D0,D6			;3f16a: 3c00
LAB_3F16C:
	TST.W	D7			;3f16c: 4a47
	BEQ.S	LAB_3F178		;3f16e: 6708
	TST.W	D6			;3f170: 4a46
	BNE.S	LAB_3F178		;3f172: 6604
	SUBQ.W	#1,D7			;3f174: 5347
	MOVEQ	#$F,D6			;3f176: 7c0f
LAB_3F178:
	TST.W	D7			;3f178: 4a47
	BNE.S	LAB_3F18A		;3f17a: 660e
	CMP.W	#$000f,D6		;3f17c: bc7c000f
	BEQ.S	LAB_3F18A		;3f180: 6708
	TST.W	D6			;3f182: 4a46
	BEQ.S	LAB_3F18A		;3f184: 6704
	ADD.W	#$0010,D6		;3f186: dc7c0010
LAB_3F18A:
	LEA	(_map_alt,A4),A0	;3f18a: 41ecdf88
	MOVE.B	D7,(0,A0,A2.W)		;3f18e: 1187a000
	LEA	(_map_blk,A4),A0	;3f192: 41eccf88
	CMPI.B	#$2f,(0,A0,A2.W)	;3f196: 0c30002fa000
	BEQ.S	LAB_3F1A8		;3f19c: 670a
	LEA	(_map_blk,A4),A0	;3f19e: 41eccf88
	MOVE.B	D6,(0,A0,A2.W)		;3f1a2: 1186a000
	BRA.S	LAB_3F1AA		;3f1a6: 6002
LAB_3F1A8:
	MOVEQ	#$2F,D6			;3f1a8: 7c2f
LAB_3F1AA:
	TST.W	D6			;3f1aa: 4a46
	BNE.S	LAB_3F1B6		;3f1ac: 6608
	LEA	(_map_bk2,A4),A0	;3f1ae: 41ecef88
	CLR.B	(0,A0,A2.W)		;3f1b2: 4230a000
LAB_3F1B6:
	MOVE.W	A2,D0			;3f1b6: 300a
	EXT.L	D0			;3f1b8: 48c0
	ASL.L	#1,D0			;3f1ba: e380
	LEA	(_map_steps,A4),A0	;3f1bc: 41ecff88
	CLR.W	(0,A0,D0.L)		;3f1c0: 42700800
	ADDQ.W	#1,D5			;3f1c4: 5245
LAB_3F1C6:
	CMP.W	($E,A5),D5		;3f1c6: ba6d000e
	BLE.W	LAB_3F0CA		;3f1ca: 6f00fefe
	ADDQ.W	#1,D4			;3f1ce: 5244
LAB_3F1D0:
	CMP.W	($C,A5),D4		;3f1d0: b86d000c
	BLE.W	LAB_3F0C2		;3f1d4: 6f00feec
	MOVEM.L	(A7)+,D4-D7/A2		;3f1d8: 4cdf04f0
	UNLK	A5			;3f1dc: 4e5d
	RTS				;3f1de: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_draw_map:
	LINK.W	A5,#-2			;3f1e0: 4e55fffe
	MOVEM.L	D4-D5,-(A7)		;3f1e4: 48e70c00
	MOVE.W	(8,A5),D4		;3f1e8: 382d0008
	BRA.S	LAB_3F24E		;3f1ec: 6060
LAB_3F1EE:
	MOVE.W	($A,A5),D5		;3f1ee: 3a2d000a
	BRA.S	LAB_3F246		;3f1f2: 6052
LAB_3F1F4:
	MOVE.W	D5,D0			;3f1f4: 3005
	ASL.W	#6,D0			;3f1f6: ed40
	ADD.W	D4,D0			;3f1f8: d044
	LEA	(_map_blk,A4),A0	;3f1fa: 41eccf88
	MOVEQ	#0,D1			;3f1fe: 7200
	MOVE.B	(0,A0,D0.W),D1		;3f200: 12300000
	LEA	(_map_colour,A4),A0	;3f204: 41ec8370
	MOVEQ	#0,D0			;3f208: 7000
	MOVE.B	(0,A0,D1.L),D0		;3f20a: 10301800
	MOVE.W	D0,(-2,A5)		;3f20e: 3b40fffe
	CMP.W	#$0019,D0		;3f212: b07c0019
	BNE.S	LAB_3F222		;3f216: 660a
	MOVEQ	#0,D0			;3f218: 7000
	MOVE.B	(LAB_5177D,A4),D0	;3f21a: 102c838f
	MOVE.W	D0,(-2,A5)		;3f21e: 3b40fffe
LAB_3F222:
	MOVE.W	(-2,A5),-(A7)		;3f222: 3f2dfffe
	MOVE.W	D4,D0			;3f226: 3004
	ADD.W	D5,D0			;3f228: d045
	ASR.W	#1,D0			;3f22a: e240
	MOVE.W	D0,-(A7)		;3f22c: 3f00
	MOVE.W	D4,D0			;3f22e: 3004
	ADD.W	#$0040,D0		;3f230: d07c0040
	SUB.W	D5,D0			;3f234: 9045
	MOVE.W	D0,-(A7)		;3f236: 3f00
	MOVE.L	(_back_scr,A4),-(A7)	;3f238: 2f2c9874
	JSR	(___pixel,A4)		;3f23c: 4eac8104
	LEA	($A,A7),A7		;3f240: 4fef000a
	ADDQ.W	#1,D5			;3f244: 5245
LAB_3F246:
	CMP.W	($E,A5),D5		;3f246: ba6d000e
	BLE.S	LAB_3F1F4		;3f24a: 6fa8
	ADDQ.W	#1,D4			;3f24c: 5244
LAB_3F24E:
	CMP.W	($C,A5),D4		;3f24e: b86d000c
	BLE.S	LAB_3F1EE		;3f252: 6f9a
	MOVEM.L	(A7)+,D4-D5		;3f254: 4cdf0030
	UNLK	A5			;3f258: 4e5d
	RTS				;3f25a: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_mod_map:
	LINK.W	A5,#0			;3f25c: 4e550000
	MOVEM.L	D4-D7/A2,-(A7)		;3f260: 48e70f20
	MOVE.W	(8,A5),D4		;3f264: 382d0008
	BRA.S	LAB_3F2E6		;3f268: 607c
LAB_3F26A:
	MOVE.W	($A,A5),D5		;3f26a: 3a2d000a
	BRA.S	LAB_3F2DE		;3f26e: 606e
LAB_3F270:
	MOVE.W	D5,D0			;3f270: 3005
	ASL.W	#6,D0			;3f272: ed40
	MOVE.W	D0,D6			;3f274: 3c00
	ADD.W	D4,D6			;3f276: dc44
	LEA	(_map_alt,A4),A0	;3f278: 41ecdf88
	MOVEQ	#0,D0			;3f27c: 7000
	MOVE.B	(0,A0,D6.W),D0		;3f27e: 10306000
	MOVE.W	D0,D7			;3f282: 3e00
	LEA	(_map_blk,A4),A0	;3f284: 41eccf88
	MOVEQ	#0,D0			;3f288: 7000
	MOVE.B	(0,A0,D6.W),D0		;3f28a: 10306000
	MOVEA.W	D0,A2			;3f28e: 3440
	TST.W	D7			;3f290: 4a47
	BEQ.S	LAB_3F29E		;3f292: 670a
	MOVE.W	A2,D0			;3f294: 300a
	BNE.S	LAB_3F29E		;3f296: 6606
	SUBQ.W	#1,D7			;3f298: 5347
	MOVEA.W	#$000f,A2		;3f29a: 347c000f
LAB_3F29E:
	TST.W	D7			;3f29e: 4a47
	BNE.S	LAB_3F2B0		;3f2a0: 660e
	CMPA.W	#$000f,A2		;3f2a2: b4fc000f
	BEQ.S	LAB_3F2B0		;3f2a6: 6708
	MOVE.W	A2,D0			;3f2a8: 300a
	BEQ.S	LAB_3F2B0		;3f2aa: 6704
	ADDA.W	#$0010,A2		;3f2ac: d4fc0010
LAB_3F2B0:
	LEA	(_map_alt,A4),A0	;3f2b0: 41ecdf88
	MOVE.B	D7,(0,A0,D6.W)		;3f2b4: 11876000
	LEA	(_map_blk,A4),A0	;3f2b8: 41eccf88
	CMPI.B	#$2f,(0,A0,D6.W)	;3f2bc: 0c30002f6000
	BEQ.S	LAB_3F2CE		;3f2c2: 670a
	MOVE.W	A2,D0			;3f2c4: 300a
	LEA	(_map_blk,A4),A0	;3f2c6: 41eccf88
	MOVE.B	D0,(0,A0,D6.W)		;3f2ca: 11806000
LAB_3F2CE:
	MOVE.W	D6,D0			;3f2ce: 3006
	EXT.L	D0			;3f2d0: 48c0
	ASL.L	#1,D0			;3f2d2: e380
	LEA	(_map_steps,A4),A0	;3f2d4: 41ecff88
	CLR.W	(0,A0,D0.L)		;3f2d8: 42700800
	ADDQ.W	#1,D5			;3f2dc: 5245
LAB_3F2DE:
	CMP.W	($E,A5),D5		;3f2de: ba6d000e
	BLE.S	LAB_3F270		;3f2e2: 6f8c
	ADDQ.W	#1,D4			;3f2e4: 5244
LAB_3F2E6:
	CMP.W	($C,A5),D4		;3f2e6: b86d000c
	BLE.W	LAB_3F26A		;3f2ea: 6f00ff7e
	MOVEM.L	(A7)+,D4-D7/A2		;3f2ee: 4cdf04f0
	UNLK	A5			;3f2f2: 4e5d
	RTS				;3f2f4: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_zoom_map:
	LINK.W	A5,#-14			;3f2f6: 4e55fff2
	MOVE.W	(_mousex,A4),D0		;3f2fa: 302c99aa
	ASR.W	#1,D0			;3f2fe: e240
	ADD.W	(_mousey,A4),D0		;3f300: d06cae6e
	SUB.W	#$0020,D0		;3f304: 907c0020
	MOVE.W	D0,(-2,A5)		;3f308: 3b40fffe
	MOVE.W	(_mousex,A4),D0		;3f30c: 302c99aa
	ASR.W	#1,D0			;3f310: e240
	MOVE.W	(_mousey,A4),D1		;3f312: 322cae6e
	SUB.W	D0,D1			;3f316: 9240
	ADD.W	#$0020,D1		;3f318: d27c0020
	MOVE.W	D1,(-4,A5)		;3f31c: 3b41fffc
	TST.W	(-2,A5)			;3f320: 4a6dfffe
	BLT.S	LAB_3F384		;3f324: 6d5e
	CMPI.W	#$0040,(-2,A5)		;3f326: 0c6d0040fffe
	BGE.S	LAB_3F384		;3f32c: 6c56
	TST.W	(-4,A5)			;3f32e: 4a6dfffc
	BLT.S	LAB_3F384		;3f332: 6d50
	CMPI.W	#$0040,(-4,A5)		;3f334: 0c6d0040fffc
	BGE.S	LAB_3F384		;3f33a: 6c48
	SUBQ.W	#3,(-2,A5)		;3f33c: 576dfffe
	SUBQ.W	#3,(-4,A5)		;3f340: 576dfffc
	TST.W	(-2,A5)			;3f344: 4a6dfffe
	BGE.S	LAB_3F34E		;3f348: 6c04
	CLR.W	(-2,A5)			;3f34a: 426dfffe
LAB_3F34E:
	CMPI.W	#$0038,(-2,A5)		;3f34e: 0c6d0038fffe
	BLE.S	LAB_3F35C		;3f354: 6f06
	MOVE.W	#$0038,(-2,A5)		;3f356: 3b7c0038fffe
LAB_3F35C:
	TST.W	(-4,A5)			;3f35c: 4a6dfffc
	BGE.S	LAB_3F366		;3f360: 6c04
	CLR.W	(-4,A5)			;3f362: 426dfffc
LAB_3F366:
	CMPI.W	#$0038,(-4,A5)		;3f366: 0c6d0038fffc
	BLE.S	LAB_3F374		;3f36c: 6f06
	MOVE.W	#$0038,(-4,A5)		;3f36e: 3b7c0038fffc
LAB_3F374:
	MOVE.W	(-2,A5),(_xoff,A4)	;3f374: 396dfffe99f0
	MOVE.W	(-4,A5),(_yoff,A4)	;3f37a: 396dfffc99f2
	BRA.W	LAB_3FCB6		;3f380: 60000934
LAB_3F384:
	MOVE.W	(_player,A4),D0		;3f384: 302c99f4
	MULS	#$002e,D0		;3f388: c1fc002e
	LEA	(_stats,A4),A0		;3f38c: 41ec82b6
	ADD.L	A0,D0			;3f390: d088
	MOVE.L	D0,(-14,A5)		;3f392: 2b40fff2
	CMPI.W	#$0112,(-2,A5)		;3f396: 0c6d0112fffe
	BLE.W	LAB_3F52E		;3f39c: 6f000190
	MOVE.W	(-2,A5),D0		;3f3a0: 302dfffe
	SUB.W	#$0110,D0		;3f3a4: 907c0110
	EXT.L	D0			;3f3a8: 48c0
	DIVS	#$0010,D0		;3f3aa: 81fc0010
	MOVE.W	D0,(-2,A5)		;3f3ae: 3b40fffe
	MOVE.W	(-4,A5),D0		;3f3b2: 302dfffc
	SUB.W	#$0020,D0		;3f3b6: 907c0020
	EXT.L	D0			;3f3ba: 48c0
	DIVS	#$0010,D0		;3f3bc: 81fc0010
	MOVE.W	D0,(-4,A5)		;3f3c0: 3b40fffc
	TST.W	(-2,A5)			;3f3c4: 4a6dfffe
	BNE.W	LAB_3F498		;3f3c8: 660000ce
	TST.W	(-4,A5)			;3f3cc: 4a6dfffc
	BNE.S	LAB_3F40A		;3f3d0: 6638
	MOVE.W	#$17e4,-(A7)		;3f3d2: 3f3c17e4
	MOVE.W	(-4,A5),-(A7)		;3f3d6: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f3da: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f3de: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f3e2: 4eac8122
	LEA	($A,A7),A7		;3f3e6: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f3ea: 206dfff2
	MOVE.B	#$0e,(A0)		;3f3ee: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f3f2: 206dfff2
	MOVE.B	#$07,(2,A0)		;3f3f6: 117c00070002
	MOVEA.L	(-14,A5),A0		;3f3fc: 206dfff2
	MOVE.B	(9,A5),(1,A0)		;3f400: 116d00090001
	BRA.W	LAB_3F494		;3f406: 6000008c
LAB_3F40A:
	CMPI.W	#$0003,(-4,A5)		;3f40a: 0c6d0003fffc
	BNE.S	LAB_3F450		;3f410: 663e
	MOVE.W	#$17e4,-(A7)		;3f412: 3f3c17e4
	MOVE.W	(-4,A5),-(A7)		;3f416: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f41a: 3f2dfffe
	MOVE.L	(_back_scr,A4),-(A7)	;3f41e: 2f2c9874
	JSR	(___toggle_icon,A4)	;3f422: 4eac8122
	LEA	($A,A7),A7		;3f426: 4fef000a
	TST.W	(_music_off,A4)		;3f42a: 4a6c8250
	BNE.S	LAB_3F438		;3f42e: 6608
	MOVE.W	#$0001,(_music_off,A4)	;3f430: 397c00018250
	BRA.S	LAB_3F43C		;3f436: 6004
LAB_3F438:
	CLR.W	(_music_off,A4)		;3f438: 426c8250
LAB_3F43C:
	TST.W	(_music_off,A4)		;3f43c: 4a6c8250
	BEQ.S	LAB_3F44E		;3f440: 670c
	MOVE.W	#$0004,-(A7)		;3f442: 3f3c0004
	CLR.W	-(A7)			;3f446: 4267
	JSR	(___kill_effect,A4)	;3f448: 4eac8170
	ADDQ.W	#4,A7			;3f44c: 584f
LAB_3F44E:
	BRA.S	LAB_3F494		;3f44e: 6044
LAB_3F450:
	CMPI.W	#$0004,(-4,A5)		;3f450: 0c6d0004fffc
	BNE.S	LAB_3F494		;3f456: 663c
	MOVE.W	#$17e4,-(A7)		;3f458: 3f3c17e4
	MOVE.W	(-4,A5),-(A7)		;3f45c: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f460: 3f2dfffe
	MOVE.L	(_back_scr,A4),-(A7)	;3f464: 2f2c9874
	JSR	(___toggle_icon,A4)	;3f468: 4eac8122
	LEA	($A,A7),A7		;3f46c: 4fef000a
	TST.W	(_effect_off,A4)	;3f470: 4a6c8252
	BNE.S	LAB_3F47E		;3f474: 6608
	MOVE.W	#$0001,(_effect_off,A4)	;3f476: 397c00018252
	BRA.S	LAB_3F482		;3f47c: 6004
LAB_3F47E:
	CLR.W	(_effect_off,A4)	;3f47e: 426c8252
LAB_3F482:
	TST.W	(_effect_off,A4)	;3f482: 4a6c8252
	BEQ.S	LAB_3F494		;3f486: 670c
	MOVE.W	#$0004,-(A7)		;3f488: 3f3c0004
	CLR.W	-(A7)			;3f48c: 4267
	JSR	(___kill_effect,A4)	;3f48e: 4eac8170
	ADDQ.W	#4,A7			;3f492: 584f
LAB_3F494:
	BRA.W	LAB_3F52A		;3f494: 60000094
LAB_3F498:
	CMPI.W	#$0001,(-2,A5)		;3f498: 0c6d0001fffe
	BNE.S	LAB_3F4F0		;3f49e: 6650
	CMPI.W	#$0001,(-4,A5)		;3f4a0: 0c6d0001fffc
	BNE.S	LAB_3F4D4		;3f4a6: 662c
	MOVE.W	#$17e4,-(A7)		;3f4a8: 3f3c17e4
	MOVE.W	(-4,A5),-(A7)		;3f4ac: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f4b0: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f4b4: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f4b8: 4eac8122
	LEA	($A,A7),A7		;3f4bc: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f4c0: 206dfff2
	MOVE.B	#$08,(2,A0)		;3f4c4: 117c00080002
	MOVEA.L	(-14,A5),A0		;3f4ca: 206dfff2
	MOVE.B	#$0e,(A0)		;3f4ce: 10bc000e
	BRA.S	LAB_3F4EE		;3f4d2: 601a
LAB_3F4D4:
	CMPI.W	#$0003,(-4,A5)		;3f4d4: 0c6d0003fffc
	BNE.S	LAB_3F4EE		;3f4da: 6612
	MOVEA.L	(-14,A5),A0		;3f4dc: 206dfff2
	MOVE.B	#$0e,(A0)		;3f4e0: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f4e4: 206dfff2
	MOVE.B	#$06,(2,A0)		;3f4e8: 117c00060002
LAB_3F4EE:
	BRA.S	LAB_3F52A		;3f4ee: 603a
LAB_3F4F0:
	CMPI.W	#$0002,(-2,A5)		;3f4f0: 0c6d0002fffe
	BNE.S	LAB_3F52A		;3f4f6: 6632
	CMPI.W	#$0002,(-4,A5)		;3f4f8: 0c6d0002fffc
	BNE.S	LAB_3F52A		;3f4fe: 662a
	MOVE.W	#$17e4,-(A7)		;3f500: 3f3c17e4
	MOVE.W	(-4,A5),-(A7)		;3f504: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f508: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f50c: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f510: 4eac8122
	LEA	($A,A7),A7		;3f514: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f518: 206dfff2
	MOVE.B	#$02,(2,A0)		;3f51c: 117c00020002
	MOVEA.L	(-14,A5),A0		;3f522: 206dfff2
	MOVE.B	#$0e,(A0)		;3f526: 10bc000e
LAB_3F52A:
	BRA.W	LAB_3FCB6		;3f52a: 6000078a
LAB_3F52E:
	CMPI.W	#$0092,(-4,A5)		;3f52e: 0c6d0092fffc
	BLT.W	LAB_3FCB6		;3f534: 6d000780
	MOVE.W	(-4,A5),D0		;3f538: 302dfffc
	SUB.W	#$0090,D0		;3f53c: 907c0090
	EXT.L	D0			;3f540: 48c0
	DIVS	#$0010,D0		;3f542: 81fc0010
	MOVE.W	D0,(-4,A5)		;3f546: 3b40fffc
	MOVE.W	(-2,A5),D0		;3f54a: 302dfffe
	SUB.W	#$0060,D0		;3f54e: 907c0060
	EXT.L	D0			;3f552: 48c0
	DIVS	#$0010,D0		;3f554: 81fc0010
	MOVE.W	D0,(-2,A5)		;3f558: 3b40fffe
	CMPI.W	#$0005,(-2,A5)		;3f55c: 0c6d0005fffe
	BGT.W	LAB_3F666		;3f562: 6e000102
	CMPI.W	#$0003,(-2,A5)		;3f566: 0c6d0003fffe
	BLT.W	LAB_3F666		;3f56c: 6d0000f8
	TST.W	(-4,A5)			;3f570: 4a6dfffc
	BLT.W	LAB_3F666		;3f574: 6d0000f0
	CMPI.W	#$0002,(-4,A5)		;3f578: 0c6d0002fffc
	BGT.W	LAB_3F666		;3f57e: 6e0000e6
	MOVE.W	#$12c0,-(A7)		;3f582: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f586: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f58a: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f58e: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f592: 4eac8122
	LEA	($A,A7),A7		;3f596: 4fef000a
	CMPI.W	#$0004,(-2,A5)		;3f59a: 0c6d0004fffe
	BNE.S	LAB_3F5E8		;3f5a0: 6646
	CMPI.W	#$0001,(-4,A5)		;3f5a2: 0c6d0001fffc
	BNE.S	LAB_3F5E8		;3f5a8: 663e
	TST.W	(_view_who,A4)		;3f5aa: 4a6cae68
	BEQ.S	LAB_3F5E6		;3f5ae: 6736
	MOVE.W	(_view_who,A4),D0	;3f5b0: 302cae68
	SUBQ.W	#1,D0			;3f5b4: 5340
	MULS	#$0016,D0		;3f5b6: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3f5ba: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3f5be: 32300800
	AND.W	#$003f,D1		;3f5c2: c27c003f
	SUBQ.W	#3,D1			;3f5c6: 5741
	MOVE.W	D1,(_xoff,A4)		;3f5c8: 394199f0
	MOVE.W	(_view_who,A4),D0	;3f5cc: 302cae68
	SUBQ.W	#1,D0			;3f5d0: 5340
	MULS	#$0016,D0		;3f5d2: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3f5d6: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3f5da: 32300800
	ASR.W	#6,D1			;3f5de: ec41
	SUBQ.W	#3,D1			;3f5e0: 5741
	MOVE.W	D1,(_yoff,A4)		;3f5e2: 394199f2
LAB_3F5E6:
	BRA.S	LAB_3F662		;3f5e6: 607a
LAB_3F5E8:
	CMPI.W	#$0005,(-2,A5)		;3f5e8: 0c6d0005fffe
	BNE.S	LAB_3F5F4		;3f5ee: 6604
	MOVEQ	#1,D0			;3f5f0: 7001
	BRA.S	LAB_3F5F6		;3f5f2: 6002
LAB_3F5F4:
	MOVEQ	#0,D0			;3f5f4: 7000
LAB_3F5F6:
	ADD.W	(_xoff,A4),D0		;3f5f6: d06c99f0
	CMPI.W	#$0003,(-2,A5)		;3f5fa: 0c6d0003fffe
	BNE.S	LAB_3F606		;3f600: 6604
	MOVEQ	#1,D1			;3f602: 7201
	BRA.S	LAB_3F608		;3f604: 6002
LAB_3F606:
	MOVEQ	#0,D1			;3f606: 7200
LAB_3F608:
	SUB.W	D1,D0			;3f608: 9041
	MOVE.W	D0,(_xoff,A4)		;3f60a: 394099f0
	CMPI.W	#$0002,(-4,A5)		;3f60e: 0c6d0002fffc
	BNE.S	LAB_3F61A		;3f614: 6604
	MOVEQ	#1,D0			;3f616: 7001
	BRA.S	LAB_3F61C		;3f618: 6002
LAB_3F61A:
	MOVEQ	#0,D0			;3f61a: 7000
LAB_3F61C:
	ADD.W	(_yoff,A4),D0		;3f61c: d06c99f2
	TST.W	(-4,A5)			;3f620: 4a6dfffc
	BNE.S	LAB_3F62A		;3f624: 6604
	MOVEQ	#1,D1			;3f626: 7201
	BRA.S	LAB_3F62C		;3f628: 6002
LAB_3F62A:
	MOVEQ	#0,D1			;3f62a: 7200
LAB_3F62C:
	SUB.W	D1,D0			;3f62c: 9041
	MOVE.W	D0,(_yoff,A4)		;3f62e: 394099f2
	TST.W	(_xoff,A4)		;3f632: 4a6c99f0
	BGE.S	LAB_3F63C		;3f636: 6c04
	CLR.W	(_xoff,A4)		;3f638: 426c99f0
LAB_3F63C:
	CMPI.W	#$0038,(_xoff,A4)	;3f63c: 0c6c003899f0
	BLE.S	LAB_3F64A		;3f642: 6f06
	MOVE.W	#$0038,(_xoff,A4)	;3f644: 397c003899f0
LAB_3F64A:
	TST.W	(_yoff,A4)		;3f64a: 4a6c99f2
	BGE.S	LAB_3F654		;3f64e: 6c04
	CLR.W	(_yoff,A4)		;3f650: 426c99f2
LAB_3F654:
	CMPI.W	#$0038,(_yoff,A4)	;3f654: 0c6c003899f2
	BLE.S	LAB_3F662		;3f65a: 6f06
	MOVE.W	#$0038,(_yoff,A4)	;3f65c: 397c003899f2
LAB_3F662:
	BRA.W	LAB_3FCB6		;3f662: 60000652
LAB_3F666:
	MOVE.W	(-2,A5),D0		;3f666: 302dfffe
	EXT.L	D0			;3f66a: 48c0
	BRA.W	LAB_3FCA4		;3f66c: 60000636
LAB_3F670:
	TST.W	(-4,A5)			;3f670: 4a6dfffc
	BNE.S	LAB_3F6A0		;3f674: 662a
	MOVE.W	#$12c0,-(A7)		;3f676: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f67a: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f67e: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f682: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f686: 4eac8122
	LEA	($A,A7),A7		;3f68a: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f68e: 206dfff2
	MOVE.B	#$0e,(A0)		;3f692: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f696: 206dfff2
	MOVE.B	#$04,(2,A0)		;3f69a: 117c00040002
LAB_3F6A0:
	BRA.W	LAB_3FCB6		;3f6a0: 60000614
LAB_3F6A4:
	TST.W	(-4,A5)			;3f6a4: 4a6dfffc
	BNE.S	LAB_3F6DA		;3f6a8: 6630
	TST.W	(_paint_map,A4)		;3f6aa: 4a6c9c24
	BNE.S	LAB_3F6DA		;3f6ae: 662a
	MOVE.W	#$12c0,-(A7)		;3f6b0: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f6b4: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f6b8: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f6bc: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f6c0: 4eac8122
	LEA	($A,A7),A7		;3f6c4: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f6c8: 206dfff2
	MOVE.B	#$0e,(A0)		;3f6cc: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f6d0: 206dfff2
	MOVE.B	#$03,(2,A0)		;3f6d4: 117c00030002
LAB_3F6DA:
	CMPI.W	#$0001,(-4,A5)		;3f6da: 0c6d0001fffc
	BNE.S	LAB_3F716		;3f6e0: 6634
	MOVE.W	#$12c0,-(A7)		;3f6e2: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f6e6: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f6ea: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f6ee: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f6f2: 4eac8122
	LEA	($A,A7),A7		;3f6f6: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f6fa: 206dfff2
	MOVE.B	#$06,(A0)		;3f6fe: 10bc0006
	MOVEA.L	(-14,A5),A0		;3f702: 206dfff2
	MOVE.B	(LAB_52DDF,A4),(1,A0)	;3f706: 116c99f10001
	MOVEA.L	(-14,A5),A0		;3f70c: 206dfff2
	MOVE.B	(LAB_52DE1,A4),(2,A0)	;3f710: 116c99f30002
LAB_3F716:
	BRA.W	LAB_3FCB6		;3f716: 6000059e
LAB_3F71A:
	TST.W	(-4,A5)			;3f71a: 4a6dfffc
	BNE.S	LAB_3F758		;3f71e: 6638
	MOVE.W	#$12c0,-(A7)		;3f720: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f724: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f728: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f72c: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f730: 4eac8122
	LEA	($A,A7),A7		;3f734: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f738: 206dfff2
	MOVE.B	#$03,(A0)		;3f73c: 10bc0003
	MOVEA.L	(-14,A5),A0		;3f740: 206dfff2
	MOVE.B	(LAB_52DDF,A4),(1,A0)	;3f744: 116c99f10001
	MOVEA.L	(-14,A5),A0		;3f74a: 206dfff2
	MOVE.B	(LAB_52DE1,A4),(2,A0)	;3f74e: 116c99f30002
	BRA.W	LAB_3F800		;3f754: 600000aa
LAB_3F758:
	CMPI.W	#$0001,(-4,A5)		;3f758: 0c6d0001fffc
	BNE.S	LAB_3F78C		;3f75e: 662c
	MOVE.W	#$12c0,-(A7)		;3f760: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f764: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f768: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f76c: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f770: 4eac8122
	LEA	($A,A7),A7		;3f774: 4fef000a
	MOVEA.L	(-14,A5),A0		;3f778: 206dfff2
	MOVE.B	#$0e,(A0)		;3f77c: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f780: 206dfff2
	MOVE.B	#$05,(2,A0)		;3f784: 117c00050002
	BRA.S	LAB_3F800		;3f78a: 6074
LAB_3F78C:
	CMPI.W	#$0002,(-4,A5)		;3f78c: 0c6d0002fffc
	BNE.S	LAB_3F800		;3f792: 666c
	MOVE.W	#$12c0,-(A7)		;3f794: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f798: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f79c: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f7a0: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f7a4: 4eac8122
	LEA	($A,A7),A7		;3f7a8: 4fef000a
	MOVE.W	(_player,A4),D0		;3f7ac: 302c99f4
	EXT.L	D0			;3f7b0: 48c0
	ASL.L	#4,D0			;3f7b2: e980
	LEA	(LAB_52DF0,A4),A0	;3f7b4: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;3f7b8: 22300800
	CMP.L	(LAB_51884,A4),D1	;3f7bc: b2ac8496
	BLE.S	LAB_3F7D6		;3f7c0: 6f14
	MOVE.W	(_player,A4),D0		;3f7c2: 302c99f4
	MULS	#$002e,D0		;3f7c6: c1fc002e
	LEA	(LAB_516B2,A4),A0	;3f7ca: 41ec82c4
	BTST	#4,(1,A0,D0.L)		;3f7ce: 083000040801
	BNE.S	LAB_3F7DC		;3f7d4: 6606
LAB_3F7D6:
	TST.W	(_paint_map,A4)		;3f7d6: 4a6c9c24
	BEQ.S	LAB_3F800		;3f7da: 6724
LAB_3F7DC:
	MOVE.W	(-4,A5),-(A7)		;3f7dc: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f7e0: 3f2dfffe
	JSR	(_set_mode_icons,PC)	;3f7e4: 4eba05f8
	ADDQ.W	#4,A7			;3f7e8: 584f
	MOVE.W	(_mode,A4),D0		;3f7ea: 302c8256
	AND.W	#$0003,D0		;3f7ee: c07c0003
	BSET	#3,D0			;3f7f2: 08c00003
	MOVE.W	D0,(_mode,A4)		;3f7f6: 39408256
	MOVE.W	#$0005,(_pointer,A4)	;3f7fa: 397c000584b6
LAB_3F800:
	BRA.W	LAB_3FCB6		;3f800: 600004b4
LAB_3F804:
	CMPI.W	#$0003,(-4,A5)		;3f804: 0c6d0003fffc
	BNE.S	LAB_3F826		;3f80a: 661a
	MOVEA.L	(-14,A5),A0		;3f80c: 206dfff2
	MOVE.B	#$0e,(A0)		;3f810: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f814: 206dfff2
	MOVE.B	#$01,(2,A0)		;3f818: 117c00010002
	MOVEA.L	(-14,A5),A0		;3f81e: 206dfff2
	CLR.B	(1,A0)			;3f822: 42280001
LAB_3F826:
	BRA.W	LAB_3FCB6		;3f826: 6000048e
LAB_3F82A:
	CMPI.W	#$0003,(-4,A5)		;3f82a: 0c6d0003fffc
	BNE.S	LAB_3F850		;3f830: 661e
	MOVEA.L	(-14,A5),A0		;3f832: 206dfff2
	MOVE.B	#$0e,(A0)		;3f836: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f83a: 206dfff2
	MOVE.B	#$01,(2,A0)		;3f83e: 117c00010002
	MOVEA.L	(-14,A5),A0		;3f844: 206dfff2
	MOVE.B	#$01,(1,A0)		;3f848: 117c00010001
	BRA.S	LAB_3F874		;3f84e: 6024
LAB_3F850:
	CMPI.W	#$0004,(-4,A5)		;3f850: 0c6d0004fffc
	BNE.S	LAB_3F874		;3f856: 661c
	MOVEA.L	(-14,A5),A0		;3f858: 206dfff2
	MOVE.B	#$0e,(A0)		;3f85c: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f860: 206dfff2
	MOVE.B	#$01,(2,A0)		;3f864: 117c00010002
	MOVEA.L	(-14,A5),A0		;3f86a: 206dfff2
	MOVE.B	#$03,(1,A0)		;3f86e: 117c00030001
LAB_3F874:
	BRA.W	LAB_3FCB6		;3f874: 60000440
LAB_3F878:
	CMPI.W	#$0003,(-4,A5)		;3f878: 0c6d0003fffc
	BNE.S	LAB_3F89C		;3f87e: 661c
	MOVEA.L	(-14,A5),A0		;3f880: 206dfff2
	MOVE.B	#$0e,(A0)		;3f884: 10bc000e
	MOVEA.L	(-14,A5),A0		;3f888: 206dfff2
	MOVE.B	#$01,(2,A0)		;3f88c: 117c00010002
	MOVEA.L	(-14,A5),A0		;3f892: 206dfff2
	MOVE.B	#$02,(1,A0)		;3f896: 117c00020001
LAB_3F89C:
	BRA.W	LAB_3FCB6		;3f89c: 60000418
LAB_3F8A0:
	TST.W	(-4,A5)			;3f8a0: 4a6dfffc
	BEQ.S	LAB_3F8AE		;3f8a4: 6708
	CMPI.W	#$0001,(-4,A5)		;3f8a6: 0c6d0001fffc
	BNE.S	LAB_3F8F0		;3f8ac: 6642
LAB_3F8AE:
	MOVE.W	(-4,A5),-(A7)		;3f8ae: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f8b2: 3f2dfffe
	JSR	(_set_mode_icons,PC)	;3f8b6: 4eba0526
	ADDQ.W	#4,A7			;3f8ba: 584f
	MOVE.W	(-4,A5),D0		;3f8bc: 302dfffc
	ADDQ.W	#1,D0			;3f8c0: 5240
	MOVE.W	D0,(_mode,A4)		;3f8c2: 39408256
	CMPI.W	#$0001,(-4,A5)		;3f8c6: 0c6d0001fffc
	BNE.S	LAB_3F8E8		;3f8cc: 661a
	CMPI.W	#$0001,(_player,A4)	;3f8ce: 0c6c000199f4
	BNE.S	LAB_3F8DA		;3f8d4: 6604
	MOVEQ	#1,D0			;3f8d6: 7001
	BRA.S	LAB_3F8DC		;3f8d8: 6002
LAB_3F8DA:
	MOVEQ	#0,D0			;3f8da: 7000
LAB_3F8DC:
	MULS	#$0003,D0		;3f8dc: c1fc0003
	ADDQ.W	#1,D0			;3f8e0: 5240
	MOVE.W	D0,(_pointer,A4)	;3f8e2: 394084b6
	BRA.S	LAB_3F8EE		;3f8e6: 6006
LAB_3F8E8:
	MOVE.W	(-4,A5),(_pointer,A4)	;3f8e8: 396dfffc84b6
LAB_3F8EE:
	BRA.S	LAB_3F920		;3f8ee: 6030
LAB_3F8F0:
	CMPI.W	#$0002,(-4,A5)		;3f8f0: 0c6d0002fffc
	BNE.S	LAB_3F920		;3f8f6: 6628
	MOVE.W	(-4,A5),-(A7)		;3f8f8: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f8fc: 3f2dfffe
	JSR	(_set_mode_icons,PC)	;3f900: 4eba04dc
	ADDQ.W	#4,A7			;3f904: 584f
	MOVE.W	(_mode,A4),D0		;3f906: 302c8256
	AND.W	#$0003,D0		;3f90a: c07c0003
	BSET	#2,D0			;3f90e: 08c00002
	MOVE.W	D0,(_mode,A4)		;3f912: 39408256
	MOVE.W	(_player,A4),D0		;3f916: 302c99f4
	ADDQ.W	#2,D0			;3f91a: 5440
	MOVE.W	D0,(_pointer,A4)	;3f91c: 394084b6
LAB_3F920:
	BRA.W	LAB_3FCB6		;3f920: 60000394
LAB_3F924:
	TST.W	(-4,A5)			;3f924: 4a6dfffc
	BNE.W	LAB_3FA40		;3f928: 66000116
	MOVE.W	#$12c0,-(A7)		;3f92c: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3f930: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3f934: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3f938: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3f93c: 4eac8122
	LEA	($A,A7),A7		;3f940: 4fef000a
	TST.W	(8,A5)			;3f944: 4a6d0008
	BNE.S	LAB_3F992		;3f948: 6648
	MOVE.W	(_player,A4),D0		;3f94a: 302c99f4
	EXT.L	D0			;3f94e: 48c0
	ASL.L	#4,D0			;3f950: e980
	LEA	(LAB_52DE6,A4),A0	;3f952: 41ec99f8
	TST.W	(0,A0,D0.L)		;3f956: 4a700800
	BEQ.S	LAB_3F98E		;3f95a: 6732
	MOVE.W	(_player,A4),D0		;3f95c: 302c99f4
	EXT.L	D0			;3f960: 48c0
	ASL.L	#4,D0			;3f962: e980
	LEA	(LAB_52DE6,A4),A0	;3f964: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;3f968: 32300800
	AND.W	#$003f,D1		;3f96c: c27c003f
	SUBQ.W	#3,D1			;3f970: 5741
	MOVE.W	D1,(_xoff,A4)		;3f972: 394199f0
	MOVE.W	(_player,A4),D0		;3f976: 302c99f4
	EXT.L	D0			;3f97a: 48c0
	ASL.L	#4,D0			;3f97c: e980
	LEA	(LAB_52DE6,A4),A0	;3f97e: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;3f982: 32300800
	ASR.W	#6,D1			;3f986: ec41
	SUBQ.W	#3,D1			;3f988: 5741
	MOVE.W	D1,(_yoff,A4)		;3f98a: 394199f2
LAB_3F98E:
	BRA.W	LAB_3FA3C		;3f98e: 600000ac
LAB_3F992:
	MOVE.W	(_player,A4),D0		;3f992: 302c99f4
	EXT.L	D0			;3f996: 48c0
	ASL.L	#4,D0			;3f998: e980
	LEA	(_magnet,A4),A0		;3f99a: 41ec99f6
	TST.W	(0,A0,D0.L)		;3f99e: 4a700800
	BEQ.S	LAB_3FA0A		;3f9a2: 6766
	MOVE.W	(_player,A4),D0		;3f9a4: 302c99f4
	EXT.L	D0			;3f9a8: 48c0
	ASL.L	#4,D0			;3f9aa: e980
	LEA	(_magnet,A4),A0		;3f9ac: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;3f9b0: 32300800
	SUBQ.W	#1,D1			;3f9b4: 5341
	MULS	#$0016,D1		;3f9b6: c3fc0016
	LEA	(LAB_5301C,A4),A0	;3f9ba: 41ec9c2e
	MOVE.W	(0,A0,D1.L),D0		;3f9be: 30301800
	AND.W	#$003f,D0		;3f9c2: c07c003f
	SUBQ.W	#3,D0			;3f9c6: 5740
	MOVE.W	D0,(_xoff,A4)		;3f9c8: 394099f0
	MOVE.W	(_player,A4),D0		;3f9cc: 302c99f4
	EXT.L	D0			;3f9d0: 48c0
	ASL.L	#4,D0			;3f9d2: e980
	LEA	(_magnet,A4),A0		;3f9d4: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;3f9d8: 32300800
	SUBQ.W	#1,D1			;3f9dc: 5341
	MULS	#$0016,D1		;3f9de: c3fc0016
	LEA	(LAB_5301C,A4),A0	;3f9e2: 41ec9c2e
	MOVE.W	(0,A0,D1.L),D0		;3f9e6: 30301800
	ASR.W	#6,D0			;3f9ea: ec40
	SUBQ.W	#3,D0			;3f9ec: 5740
	MOVE.W	D0,(_yoff,A4)		;3f9ee: 394099f2
	MOVE.W	(_player,A4),D0		;3f9f2: 302c99f4
	EXT.L	D0			;3f9f6: 48c0
	ASL.L	#4,D0			;3f9f8: e980
	LEA	(_magnet,A4),A0		;3f9fa: 41ec99f6
	MOVE.W	(0,A0,D0.L),-(A7)	;3f9fe: 3f300800
	JSR	(_set_temp_view,PC)	;3fa02: 4eba0aa8
	ADDQ.W	#2,A7			;3fa06: 544f
	BRA.S	LAB_3FA3C		;3fa08: 6032
LAB_3FA0A:
	MOVE.W	(_player,A4),D0		;3fa0a: 302c99f4
	EXT.L	D0			;3fa0e: 48c0
	ASL.L	#4,D0			;3fa10: e980
	LEA	(LAB_52DE6,A4),A0	;3fa12: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;3fa16: 32300800
	AND.W	#$003f,D1		;3fa1a: c27c003f
	SUBQ.W	#3,D1			;3fa1e: 5741
	MOVE.W	D1,(_xoff,A4)		;3fa20: 394199f0
	MOVE.W	(_player,A4),D0		;3fa24: 302c99f4
	EXT.L	D0			;3fa28: 48c0
	ASL.L	#4,D0			;3fa2a: e980
	LEA	(LAB_52DE6,A4),A0	;3fa2c: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;3fa30: 32300800
	ASR.W	#6,D1			;3fa34: ec41
	SUBQ.W	#3,D1			;3fa36: 5741
	MOVE.W	D1,(_yoff,A4)		;3fa38: 394199f2
LAB_3FA3C:
	BRA.W	LAB_3FB22		;3fa3c: 600000e4
LAB_3FA40:
	CMPI.W	#$0001,(-4,A5)		;3fa40: 0c6d0001fffc
	BNE.W	LAB_3FB22		;3fa46: 660000da
	MOVE.W	#$12c0,-(A7)		;3fa4a: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3fa4e: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3fa52: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3fa56: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3fa5a: 4eac8122
	LEA	($A,A7),A7		;3fa5e: 4fef000a
	TST.W	(_no_peeps,A4)		;3fa62: 4a6cae5e
	BEQ.W	LAB_3FB22		;3fa66: 670000ba
	MOVE.W	(_view_fight,A4),D0	;3fa6a: 302c2f92
	CMP.W	(_no_peeps,A4),D0	;3fa6e: b06cae5e
	BLT.S	LAB_3FA78		;3fa72: 6d04
	CLR.W	(_view_fight,A4)	;3fa74: 426c2f92
LAB_3FA78:
	MOVE.W	(_view_fight,A4),D0	;3fa78: 302c2f92
	ADDQ.W	#1,D0			;3fa7c: 5240
	MOVE.W	D0,(-6,A5)		;3fa7e: 3b40fffa
	CLR.W	(-8,A5)			;3fa82: 426dfff8
LAB_3FA86:
	MOVE.W	(-6,A5),D0		;3fa86: 302dfffa
	CMP.W	(_no_peeps,A4),D0	;3fa8a: b06cae5e
	BLT.S	LAB_3FA94		;3fa8e: 6d04
	CLR.W	(-6,A5)			;3fa90: 426dfffa
LAB_3FA94:
	MOVE.W	(_view_fight,A4),D0	;3fa94: 302c2f92
	ADDQ.W	#1,D0			;3fa98: 5240
	CMP.W	(-6,A5),D0		;3fa9a: b06dfffa
	BNE.S	LAB_3FAA6		;3fa9e: 6606
	TST.W	(-8,A5)			;3faa0: 4a6dfff8
	BNE.S	LAB_3FB22		;3faa4: 667c
LAB_3FAA6:
	MOVE.W	#$0001,(-8,A5)		;3faa6: 3b7c0001fff8
	MOVE.W	(-6,A5),D0		;3faac: 302dfffa
	MULS	#$0016,D0		;3fab0: c1fc0016
	LEA	(_peeps,A4),A0		;3fab4: 41ec9c26
	BTST	#3,(0,A0,D0.L)		;3fab8: 083000030800
	BEQ.S	LAB_3FB1A		;3fabe: 675a
	MOVE.W	(-6,A5),D0		;3fac0: 302dfffa
	MULS	#$0016,D0		;3fac4: c1fc0016
	LEA	(LAB_53018,A4),A0	;3fac8: 41ec9c2a
	TST.W	(0,A0,D0.L)		;3facc: 4a700800
	BEQ.S	LAB_3FB1A		;3fad0: 6748
	MOVE.W	(-6,A5),D0		;3fad2: 302dfffa
	MULS	#$0016,D0		;3fad6: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3fada: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3fade: 32300800
	AND.W	#$003f,D1		;3fae2: c27c003f
	SUBQ.W	#3,D1			;3fae6: 5741
	MOVE.W	D1,(_xoff,A4)		;3fae8: 394199f0
	MOVE.W	(-6,A5),D0		;3faec: 302dfffa
	MULS	#$0016,D0		;3faf0: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3faf4: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3faf8: 32300800
	ASR.W	#6,D1			;3fafc: ec41
	SUBQ.W	#3,D1			;3fafe: 5741
	MOVE.W	D1,(_yoff,A4)		;3fb00: 394199f2
	MOVE.W	(-6,A5),(_view_fight,A4) ;3fb04: 396dfffa2f92
	MOVE.W	(-6,A5),D0		;3fb0a: 302dfffa
	ADDQ.W	#1,D0			;3fb0e: 5240
	MOVE.W	D0,-(A7)		;3fb10: 3f00
	JSR	(_set_temp_view,PC)	;3fb12: 4eba0998
	ADDQ.W	#2,A7			;3fb16: 544f
	BRA.S	LAB_3FB22		;3fb18: 6008
LAB_3FB1A:
	ADDQ.W	#1,(-6,A5)		;3fb1a: 526dfffa
	BRA.W	LAB_3FA86		;3fb1e: 6000ff66
LAB_3FB22:
	BRA.W	LAB_3FCB6		;3fb22: 60000192
LAB_3FB26:
	TST.W	(-4,A5)			;3fb26: 4a6dfffc
	BNE.W	LAB_3FC8E		;3fb2a: 66000162
	MOVE.W	#$12c0,-(A7)		;3fb2e: 3f3c12c0
	MOVE.W	(-4,A5),-(A7)		;3fb32: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;3fb36: 3f2dfffe
	MOVE.L	(_d_screen,A4),-(A7)	;3fb3a: 2f2c99ec
	JSR	(___toggle_icon,A4)	;3fb3e: 4eac8122
	LEA	($A,A7),A7		;3fb42: 4fef000a
	TST.W	(8,A5)			;3fb46: 4a6d0008
	TST.W	(_no_peeps,A4)		;3fb4a: 4a6cae5e
	BEQ.W	LAB_3FC8E		;3fb4e: 6700013e
	MOVE.W	(_view_people,A4),D0	;3fb52: 302c2f94
	CMP.W	(_no_peeps,A4),D0	;3fb56: b06cae5e
	BLT.S	LAB_3FB60		;3fb5a: 6d04
	CLR.W	(_view_people,A4)	;3fb5c: 426c2f94
LAB_3FB60:
	MOVE.W	(_view_people,A4),D0	;3fb60: 302c2f94
	ADDQ.W	#1,D0			;3fb64: 5240
	MOVE.W	D0,(-6,A5)		;3fb66: 3b40fffa
	CLR.W	(-8,A5)			;3fb6a: 426dfff8
LAB_3FB6E:
	MOVE.W	(_view_people,A4),D0	;3fb6e: 302c2f94
	ADDQ.W	#1,D0			;3fb72: 5240
	CMP.W	(-6,A5),D0		;3fb74: b06dfffa
	BNE.S	LAB_3FB82		;3fb78: 6608
	TST.W	(-8,A5)			;3fb7a: 4a6dfff8
	BNE.W	LAB_3FC8E		;3fb7e: 6600010e
LAB_3FB82:
	MOVE.W	(-6,A5),D0		;3fb82: 302dfffa
	CMP.W	(_no_peeps,A4),D0	;3fb86: b06cae5e
	BNE.S	LAB_3FB90		;3fb8a: 6604
	CLR.W	(-6,A5)			;3fb8c: 426dfffa
LAB_3FB90:
	MOVE.W	#$0001,(-8,A5)		;3fb90: 3b7c0001fff8
	MOVE.W	(-6,A5),D0		;3fb96: 302dfffa
	MULS	#$0016,D0		;3fb9a: c1fc0016
	LEA	(LAB_53015,A4),A0	;3fb9e: 41ec9c27
	MOVEQ	#0,D1			;3fba2: 7200
	MOVE.B	(0,A0,D0.L),D1		;3fba4: 12300800
	CMP.W	(_player,A4),D1		;3fba8: b26c99f4
	BNE.W	LAB_3FC86		;3fbac: 660000d8
	MOVE.W	(-6,A5),D0		;3fbb0: 302dfffa
	MULS	#$0016,D0		;3fbb4: c1fc0016
	LEA	(LAB_53018,A4),A0	;3fbb8: 41ec9c2a
	TST.W	(0,A0,D0.L)		;3fbbc: 4a700800
	BLE.W	LAB_3FC86		;3fbc0: 6f0000c4
	TST.W	(8,A5)			;3fbc4: 4a6d0008
	BNE.S	LAB_3FC26		;3fbc8: 665c
	MOVE.W	(-6,A5),D0		;3fbca: 302dfffa
	MULS	#$0016,D0		;3fbce: c1fc0016
	LEA	(_peeps,A4),A0		;3fbd2: 41ec9c26
	CMPI.B	#$01,(0,A0,D0.L)	;3fbd6: 0c3000010800
	BNE.S	LAB_3FC26		;3fbdc: 6648
	MOVE.W	(-6,A5),D0		;3fbde: 302dfffa
	MULS	#$0016,D0		;3fbe2: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3fbe6: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3fbea: 32300800
	AND.W	#$003f,D1		;3fbee: c27c003f
	SUBQ.W	#3,D1			;3fbf2: 5741
	MOVE.W	D1,(_xoff,A4)		;3fbf4: 394199f0
	MOVE.W	(-6,A5),D0		;3fbf8: 302dfffa
	MULS	#$0016,D0		;3fbfc: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3fc00: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3fc04: 32300800
	ASR.W	#6,D1			;3fc08: ec41
	SUBQ.W	#3,D1			;3fc0a: 5741
	MOVE.W	D1,(_yoff,A4)		;3fc0c: 394199f2
	MOVE.W	(-6,A5),(_view_people,A4) ;3fc10: 396dfffa2f94
	MOVE.W	(-6,A5),D0		;3fc16: 302dfffa
	ADDQ.W	#1,D0			;3fc1a: 5240
	MOVE.W	D0,-(A7)		;3fc1c: 3f00
	JSR	(_set_temp_view,PC)	;3fc1e: 4eba088c
	ADDQ.W	#2,A7			;3fc22: 544f
	BRA.S	LAB_3FC8E		;3fc24: 6068
LAB_3FC26:
	TST.W	(8,A5)			;3fc26: 4a6d0008
	BEQ.S	LAB_3FC86		;3fc2a: 675a
	MOVE.W	(-6,A5),D0		;3fc2c: 302dfffa
	MULS	#$0016,D0		;3fc30: c1fc0016
	LEA	(LAB_53022,A4),A0	;3fc34: 41ec9c34
	TST.L	(0,A0,D0.L)		;3fc38: 4ab00800
	BEQ.S	LAB_3FC86		;3fc3c: 6748
	MOVE.W	(-6,A5),D0		;3fc3e: 302dfffa
	MULS	#$0016,D0		;3fc42: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3fc46: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3fc4a: 32300800
	AND.W	#$003f,D1		;3fc4e: c27c003f
	SUBQ.W	#3,D1			;3fc52: 5741
	MOVE.W	D1,(_xoff,A4)		;3fc54: 394199f0
	MOVE.W	(-6,A5),D0		;3fc58: 302dfffa
	MULS	#$0016,D0		;3fc5c: c1fc0016
	LEA	(LAB_5301C,A4),A0	;3fc60: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;3fc64: 32300800
	ASR.W	#6,D1			;3fc68: ec41
	SUBQ.W	#3,D1			;3fc6a: 5741
	MOVE.W	D1,(_yoff,A4)		;3fc6c: 394199f2
	MOVE.W	(-6,A5),(_view_people,A4) ;3fc70: 396dfffa2f94
	MOVE.W	(-6,A5),D0		;3fc76: 302dfffa
	ADDQ.W	#1,D0			;3fc7a: 5240
	MOVE.W	D0,-(A7)		;3fc7c: 3f00
	JSR	(_set_temp_view,PC)	;3fc7e: 4eba082c
	ADDQ.W	#2,A7			;3fc82: 544f
	BRA.S	LAB_3FC8E		;3fc84: 6008
LAB_3FC86:
	ADDQ.W	#1,(-6,A5)		;3fc86: 526dfffa
	BRA.W	LAB_3FB6E		;3fc8a: 6000fee2
LAB_3FC8E:
	BRA.S	LAB_3FCB6		;3fc8e: 6026
LAB_3FC90:
	BRA.S	LAB_3FCB6		;3fc90: 6024
LAB_3FC92:
	DC.W	(LAB_3F670)-(LAB_3FCB2+2) ;3fc92: f9bc
	DC.W	(LAB_3F6A4)-(LAB_3FCB2+2) ;3fc94: f9f0
	DC.W	(LAB_3F71A)-(LAB_3FCB2+2) ;3fc96: fa66
	DC.W	(LAB_3F804)-(LAB_3FCB2+2) ;3fc98: fb50
	DC.W	(LAB_3F82A)-(LAB_3FCB2+2) ;3fc9a: fb76
	DC.W	(LAB_3F878)-(LAB_3FCB2+2) ;3fc9c: fbc4
	DC.W	(LAB_3F8A0)-(LAB_3FCB2+2) ;3fc9e: fbec
	DC.W	(LAB_3F924)-(LAB_3FCB2+2) ;3fca0: fc70
	DC.W	(LAB_3FB26)-(LAB_3FCB2+2) ;3fca2: fe72
LAB_3FCA4:
	CMP.L	#$00000009,D0		;3fca4: b0bc00000009
	BCC.S	LAB_3FC90		;3fcaa: 64e4
	ASL.L	#1,D0			;3fcac: e380
	MOVE.W	(LAB_3FC92,PC,D0.W),D0	;3fcae: 303b00e2
LAB_3FCB2:
	JMP	(LAB_3FCB2+2,PC,D0.W)	;3fcb2: 4efb0000
LAB_3FCB6:
	TST.W	(_xoff,A4)		;3fcb6: 4a6c99f0
	BGE.S	LAB_3FCC0		;3fcba: 6c04
	CLR.W	(_xoff,A4)		;3fcbc: 426c99f0
LAB_3FCC0:
	CMPI.W	#$0038,(_xoff,A4)	;3fcc0: 0c6c003899f0
	BLE.S	LAB_3FCCE		;3fcc6: 6f06
	MOVE.W	#$0038,(_xoff,A4)	;3fcc8: 397c003899f0
LAB_3FCCE:
	TST.W	(_yoff,A4)		;3fcce: 4a6c99f2
	BGE.S	LAB_3FCD8		;3fcd2: 6c04
	CLR.W	(_yoff,A4)		;3fcd4: 426c99f2
LAB_3FCD8:
	CMPI.W	#$0038,(_yoff,A4)	;3fcd8: 0c6c003899f2
	BLE.S	LAB_3FCE6		;3fcde: 6f06
	MOVE.W	#$0038,(_yoff,A4)	;3fce0: 397c003899f2
LAB_3FCE6:
	TST.W	(_left_button,A4)	;3fce6: 4a6cae62
	BNE.S	LAB_3FCF2		;3fcea: 6606
	MOVE.W	#$0002,(_left_button,A4) ;3fcec: 397c0002ae62
LAB_3FCF2:
	TST.W	(_right_button,A4)	;3fcf2: 4a6cae64
	BNE.S	LAB_3FCFE		;3fcf6: 6606
	MOVE.W	#$0002,(_right_button,A4) ;3fcf8: 397c0002ae64
LAB_3FCFE:
	UNLK	A5			;3fcfe: 4e5d
	RTS				;3fd00: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_tend_icons:
	LINK.W	A5,#0			;3fd02: 4e550000
	MOVE.W	(_player,A4),D0		;3fd06: 302c99f4
	EXT.L	D0			;3fd0a: 48c0
	ASL.L	#4,D0			;3fd0c: e980
	LEA	(LAB_52DE8,A4),A0	;3fd0e: 41ec99fa
	TST.W	(0,A0,D0.L)		;3fd12: 4a700800
	BNE.S	LAB_3FD34		;3fd16: 661c
	MOVE.W	#$12c0,-(A7)		;3fd18: 3f3c12c0
	MOVE.W	#$0003,-(A7)		;3fd1c: 3f3c0003
	MOVE.W	#$0003,-(A7)		;3fd20: 3f3c0003
	MOVE.L	(_back_scr,A4),-(A7)	;3fd24: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fd28: 4eac8122
	LEA	($A,A7),A7		;3fd2c: 4fef000a
	BRA.W	LAB_3FDBC		;3fd30: 6000008a
LAB_3FD34:
	MOVE.W	(_player,A4),D0		;3fd34: 302c99f4
	EXT.L	D0			;3fd38: 48c0
	ASL.L	#4,D0			;3fd3a: e980
	LEA	(LAB_52DE8,A4),A0	;3fd3c: 41ec99fa
	CMPI.W	#$0001,(0,A0,D0.L)	;3fd40: 0c7000010800
	BNE.S	LAB_3FD62		;3fd46: 661a
	MOVE.W	#$12c0,-(A7)		;3fd48: 3f3c12c0
	MOVE.W	#$0003,-(A7)		;3fd4c: 3f3c0003
	MOVE.W	#$0004,-(A7)		;3fd50: 3f3c0004
	MOVE.L	(_back_scr,A4),-(A7)	;3fd54: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fd58: 4eac8122
	LEA	($A,A7),A7		;3fd5c: 4fef000a
	BRA.S	LAB_3FDBC		;3fd60: 605a
LAB_3FD62:
	MOVE.W	(_player,A4),D0		;3fd62: 302c99f4
	EXT.L	D0			;3fd66: 48c0
	ASL.L	#4,D0			;3fd68: e980
	LEA	(LAB_52DE8,A4),A0	;3fd6a: 41ec99fa
	CMPI.W	#$0002,(0,A0,D0.L)	;3fd6e: 0c7000020800
	BNE.S	LAB_3FD90		;3fd74: 661a
	MOVE.W	#$12c0,-(A7)		;3fd76: 3f3c12c0
	MOVE.W	#$0003,-(A7)		;3fd7a: 3f3c0003
	MOVE.W	#$0005,-(A7)		;3fd7e: 3f3c0005
	MOVE.L	(_back_scr,A4),-(A7)	;3fd82: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fd86: 4eac8122
	LEA	($A,A7),A7		;3fd8a: 4fef000a
	BRA.S	LAB_3FDBC		;3fd8e: 602c
LAB_3FD90:
	MOVE.W	(_player,A4),D0		;3fd90: 302c99f4
	EXT.L	D0			;3fd94: 48c0
	ASL.L	#4,D0			;3fd96: e980
	LEA	(LAB_52DE8,A4),A0	;3fd98: 41ec99fa
	CMPI.W	#$0003,(0,A0,D0.L)	;3fd9c: 0c7000030800
	BNE.S	LAB_3FDBC		;3fda2: 6618
	MOVE.W	#$12c0,-(A7)		;3fda4: 3f3c12c0
	MOVE.W	#$0004,-(A7)		;3fda8: 3f3c0004
	MOVE.W	#$0004,-(A7)		;3fdac: 3f3c0004
	MOVE.L	(_back_scr,A4),-(A7)	;3fdb0: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fdb4: 4eac8122
	LEA	($A,A7),A7		;3fdb8: 4fef000a
LAB_3FDBC:
	TST.W	(8,A5)			;3fdbc: 4a6d0008
	BLT.S	LAB_3FDDA		;3fdc0: 6d18
	MOVE.W	#$12c0,-(A7)		;3fdc2: 3f3c12c0
	MOVE.W	($A,A5),-(A7)		;3fdc6: 3f2d000a
	MOVE.W	(8,A5),-(A7)		;3fdca: 3f2d0008
	MOVE.L	(_back_scr,A4),-(A7)	;3fdce: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fdd2: 4eac8122
	LEA	($A,A7),A7		;3fdd6: 4fef000a
LAB_3FDDA:
	UNLK	A5			;3fdda: 4e5d
	RTS				;3fddc: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_mode_icons:
	LINK.W	A5,#0			;3fdde: 4e550000
	BTST	#2,(bitfield_51645,A4)	;3fde2: 082c00028257
	BEQ.S	LAB_3FE04		;3fde8: 671a
	MOVE.W	#$12c0,-(A7)		;3fdea: 3f3c12c0
	MOVE.W	#$0002,-(A7)		;3fdee: 3f3c0002
	MOVE.W	#$0006,-(A7)		;3fdf2: 3f3c0006
	MOVE.L	(_back_scr,A4),-(A7)	;3fdf6: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fdfa: 4eac8122
	LEA	($A,A7),A7		;3fdfe: 4fef000a
	BRA.S	LAB_3FE42		;3fe02: 603e
LAB_3FE04:
	BTST	#3,(bitfield_51645,A4)	;3fe04: 082c00038257
	BEQ.S	LAB_3FE26		;3fe0a: 671a
	MOVE.W	#$12c0,-(A7)		;3fe0c: 3f3c12c0
	MOVE.W	#$0002,-(A7)		;3fe10: 3f3c0002
	MOVE.W	#$0002,-(A7)		;3fe14: 3f3c0002
	MOVE.L	(_back_scr,A4),-(A7)	;3fe18: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fe1c: 4eac8122
	LEA	($A,A7),A7		;3fe20: 4fef000a
	BRA.S	LAB_3FE42		;3fe24: 601c
LAB_3FE26:
	MOVE.W	#$12c0,-(A7)		;3fe26: 3f3c12c0
	MOVE.W	(_mode,A4),D0		;3fe2a: 302c8256
	SUBQ.W	#1,D0			;3fe2e: 5340
	MOVE.W	D0,-(A7)		;3fe30: 3f00
	MOVE.W	#$0006,-(A7)		;3fe32: 3f3c0006
	MOVE.L	(_back_scr,A4),-(A7)	;3fe36: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fe3a: 4eac8122
	LEA	($A,A7),A7		;3fe3e: 4fef000a
LAB_3FE42:
	TST.W	(8,A5)			;3fe42: 4a6d0008
	BLT.S	LAB_3FE60		;3fe46: 6d18
	MOVE.W	#$12c0,-(A7)		;3fe48: 3f3c12c0
	MOVE.W	($A,A5),-(A7)		;3fe4c: 3f2d000a
	MOVE.W	(8,A5),-(A7)		;3fe50: 3f2d0008
	MOVE.L	(_back_scr,A4),-(A7)	;3fe54: 2f2c9874
	JSR	(___toggle_icon,A4)	;3fe58: 4eac8122
	LEA	($A,A7),A7		;3fe5c: 4fef000a
LAB_3FE60:
	UNLK	A5			;3fe60: 4e5d
	RTS				;3fe62: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_lower_point:
	LINK.W	A5,#0			;3fe64: 4e550000
	MOVEM.L	D4-D5/A2-A3,-(A7)	;3fe68: 48e70c30
	MOVE.W	(8,A5),D4		;3fe6c: 382d0008
	MOVE.W	($A,A5),D5		;3fe70: 3a2d000a
	CMP.W	#$0040,D4		;3fe74: b87c0040
	BGT.S	LAB_3FE88		;3fe78: 6e0e
	TST.W	D4			;3fe7a: 4a44
	BLT.S	LAB_3FE88		;3fe7c: 6d0a
	CMP.W	#$0040,D5		;3fe7e: ba7c0040
	BGT.S	LAB_3FE88		;3fe82: 6e04
	TST.W	D5			;3fe84: 4a45
	BGE.S	LAB_3FE92		;3fe86: 6c0a
LAB_3FE88:
	MOVEQ	#0,D0			;3fe88: 7000
LAB_3FE8A:
	MOVEM.L	(A7)+,D4-D5/A2-A3	;3fe8a: 4cdf0c30
	UNLK	A5			;3fe8e: 4e5d
	RTS				;3fe90: 4e75
LAB_3FE92:
	MOVE.W	D5,D0			;3fe92: 3005
	MULS	#$0041,D0		;3fe94: c1fc0041
	ADD.W	D4,D0			;3fe98: d044
	EXT.L	D0			;3fe9a: 48c0
	ASL.L	#1,D0			;3fe9c: e380
	LEA	(_alt,A4),A0		;3fe9e: 41ecae86
	MOVEA.L	D0,A2			;3fea2: 2440
	ADDA.L	A0,A2			;3fea4: d5c8
	TST.W	(A2)			;3fea6: 4a52
	BEQ.W	LAB_3FFBC		;3fea8: 67000112
	ADDQ.W	#1,(_build_count,A4)	;3feac: 526c2f88
	SUBQ.W	#1,(A2)			;3feb0: 5352
	MOVEA.L	A2,A3			;3feb2: 264a
	ADDQ.L	#2,A3			;3feb4: 548b
	ADDQ.W	#1,D4			;3feb6: 5244
	MOVE.W	(A3),D0			;3feb8: 3013
	SUB.W	(A2),D0			;3feba: 9052
	CMP.W	#$0001,D0		;3febc: b07c0001
	BLE.S	LAB_3FECA		;3fec0: 6f08
	MOVE.W	D5,-(A7)		;3fec2: 3f05
	MOVE.W	D4,-(A7)		;3fec4: 3f04
	BSR.S	_lower_point		;3fec6: 619c
	ADDQ.W	#4,A7			;3fec8: 584f
LAB_3FECA:
	ADDA.L	#$00000082,A3		;3feca: d7fc00000082
	ADDQ.W	#1,D5			;3fed0: 5245
	MOVE.W	(A3),D0			;3fed2: 3013
	SUB.W	(A2),D0			;3fed4: 9052
	CMP.W	#$0001,D0		;3fed6: b07c0001
	BLE.S	LAB_3FEE4		;3feda: 6f08
	MOVE.W	D5,-(A7)		;3fedc: 3f05
	MOVE.W	D4,-(A7)		;3fede: 3f04
	BSR.S	_lower_point		;3fee0: 6182
	ADDQ.W	#4,A7			;3fee2: 584f
LAB_3FEE4:
	SUBQ.L	#2,A3			;3fee4: 558b
	SUBQ.W	#1,D4			;3fee6: 5344
	MOVE.W	(A3),D0			;3fee8: 3013
	SUB.W	(A2),D0			;3feea: 9052
	CMP.W	#$0001,D0		;3feec: b07c0001
	BLE.S	LAB_3FEFC		;3fef0: 6f0a
	MOVE.W	D5,-(A7)		;3fef2: 3f05
	MOVE.W	D4,-(A7)		;3fef4: 3f04
	JSR	(_lower_point,PC)	;3fef6: 4ebaff6c
	ADDQ.W	#4,A7			;3fefa: 584f
LAB_3FEFC:
	SUBQ.L	#2,A3			;3fefc: 558b
	SUBQ.W	#1,D4			;3fefe: 5344
	MOVE.W	(A3),D0			;3ff00: 3013
	SUB.W	(A2),D0			;3ff02: 9052
	CMP.W	#$0001,D0		;3ff04: b07c0001
	BLE.S	LAB_3FF14		;3ff08: 6f0a
	MOVE.W	D5,-(A7)		;3ff0a: 3f05
	MOVE.W	D4,-(A7)		;3ff0c: 3f04
	JSR	(_lower_point,PC)	;3ff0e: 4ebaff54
	ADDQ.W	#4,A7			;3ff12: 584f
LAB_3FF14:
	SUBA.L	#$00000082,A3		;3ff14: 97fc00000082
	SUBQ.W	#1,D5			;3ff1a: 5345
	MOVE.W	(A3),D0			;3ff1c: 3013
	SUB.W	(A2),D0			;3ff1e: 9052
	CMP.W	#$0001,D0		;3ff20: b07c0001
	BLE.S	LAB_3FF30		;3ff24: 6f0a
	MOVE.W	D5,-(A7)		;3ff26: 3f05
	MOVE.W	D4,-(A7)		;3ff28: 3f04
	JSR	(_lower_point,PC)	;3ff2a: 4ebaff38
	ADDQ.W	#4,A7			;3ff2e: 584f
LAB_3FF30:
	SUBA.L	#$00000082,A3		;3ff30: 97fc00000082
	SUBQ.W	#1,D5			;3ff36: 5345
	MOVE.W	(A3),D0			;3ff38: 3013
	SUB.W	(A2),D0			;3ff3a: 9052
	CMP.W	#$0001,D0		;3ff3c: b07c0001
	BLE.S	LAB_3FF4C		;3ff40: 6f0a
	MOVE.W	D5,-(A7)		;3ff42: 3f05
	MOVE.W	D4,-(A7)		;3ff44: 3f04
	JSR	(_lower_point,PC)	;3ff46: 4ebaff1c
	ADDQ.W	#4,A7			;3ff4a: 584f
LAB_3FF4C:
	ADDQ.L	#2,A3			;3ff4c: 548b
	ADDQ.W	#1,D4			;3ff4e: 5244
	MOVE.W	(A3),D0			;3ff50: 3013
	SUB.W	(A2),D0			;3ff52: 9052
	CMP.W	#$0001,D0		;3ff54: b07c0001
	BLE.S	LAB_3FF64		;3ff58: 6f0a
	MOVE.W	D5,-(A7)		;3ff5a: 3f05
	MOVE.W	D4,-(A7)		;3ff5c: 3f04
	JSR	(_lower_point,PC)	;3ff5e: 4ebaff04
	ADDQ.W	#4,A7			;3ff62: 584f
LAB_3FF64:
	ADDQ.L	#2,A3			;3ff64: 548b
	ADDQ.W	#1,D4			;3ff66: 5244
	MOVE.W	(A3),D0			;3ff68: 3013
	SUB.W	(A2),D0			;3ff6a: 9052
	CMP.W	#$0001,D0		;3ff6c: b07c0001
	BLE.S	LAB_3FF7C		;3ff70: 6f0a
	MOVE.W	D5,-(A7)		;3ff72: 3f05
	MOVE.W	D4,-(A7)		;3ff74: 3f04
	JSR	(_lower_point,PC)	;3ff76: 4ebafeec
	ADDQ.W	#4,A7			;3ff7a: 584f
LAB_3FF7C:
	MOVE.W	(8,A5),D0		;3ff7c: 302d0008
	CMP.W	(_xmin,A4),D0		;3ff80: b06c2f8a
	BGE.S	LAB_3FF8C		;3ff84: 6c06
	MOVE.W	(8,A5),(_xmin,A4)	;3ff86: 396d00082f8a
LAB_3FF8C:
	MOVE.W	(8,A5),D0		;3ff8c: 302d0008
	CMP.W	(_xmax,A4),D0		;3ff90: b06c2f8c
	BLE.S	LAB_3FF9C		;3ff94: 6f06
	MOVE.W	(8,A5),(_xmax,A4)	;3ff96: 396d00082f8c
LAB_3FF9C:
	MOVE.W	($A,A5),D0		;3ff9c: 302d000a
	CMP.W	(_ymin,A4),D0		;3ffa0: b06c2f8e
	BGE.S	LAB_3FFAC		;3ffa4: 6c06
	MOVE.W	($A,A5),(_ymin,A4)	;3ffa6: 396d000a2f8e
LAB_3FFAC:
	MOVE.W	($A,A5),D0		;3ffac: 302d000a
	CMP.W	(_ymax,A4),D0		;3ffb0: b06c2f90
	BLE.S	LAB_3FFBC		;3ffb4: 6f06
	MOVE.W	($A,A5),(_ymax,A4)	;3ffb6: 396d000a2f90
LAB_3FFBC:
	MOVE.W	(A2),D0			;3ffbc: 3012
	BRA.W	LAB_3FE8A		;3ffbe: 6000feca
; ------------------------------------------------------------------------------
; Function
; Probably put the shield on someone
; Right-click to put the shield temporarily
; ------------------------------------------------------------------------------
_interogate:
	LINK.W	A5,#0			;3ffc2: 4e550000
	MOVEM.L	D4/A2,-(A7)		;3ffc6: 48e70820
	MOVEQ	#0,D4			;3ffca: 7800
	LEA	(_sprite,A4),A0		;3ffcc: 41ec9a22
	MOVEA.L	A0,A2			;3ffd0: 2448
	BRA.S	LAB_4002C		;3ffd2: 6058
LAB_3FFD4:
	MOVE.W	(_mousex,A4),D0		;3ffd4: 302c99aa
	CMP.W	(A2),D0			;3ffd8: b052
	BLT.S	LAB_40028		;3ffda: 6d4c
	MOVE.W	(A2),D0			;3ffdc: 3012
	ADD.W	#$000c,D0		;3ffde: d07c000c
	MOVE.W	(_mousex,A4),D1		;3ffe2: 322c99aa
	CMP.W	D0,D1			;3ffe6: b240
	BGT.S	LAB_40028		;3ffe8: 6e3e
	MOVE.W	(_mousey,A4),D0		;3ffea: 302cae6e
	CMP.W	(2,A2),D0		;3ffee: b06a0002
	BLT.S	LAB_40028		;3fff2: 6d34
	MOVE.W	(2,A2),D0		;3fff4: 302a0002
	ADDQ.W	#8,D0			;3fff8: 5040
	MOVE.W	(_mousey,A4),D1		;3fffa: 322cae6e
	CMP.W	D0,D1			;3fffe: b240
	BGT.S	LAB_40028		;40000: 6e26
	CMPI.W	#$0001,(_mode,A4)	;40002: 0c6c00018256
	BNE.S	LAB_40026		;40008: 661c
	TST.W	(_right_button,A4)	;4000a: 4a6cae64
	BNE.S	LAB_4001C		;4000e: 660c
	MOVE.W	(6,A2),-(A7)		;40010: 3f2a0006
	JSR	(_set_temp_view,PC)	;40014: 4eba0496
	ADDQ.W	#2,A7			;40018: 544f
	BRA.S	LAB_40026		;4001a: 600a
LAB_4001C:
	CLR.W	(_view_timer,A4)	;4001c: 426cae60
	MOVE.W	(6,A2),(_view_who,A4)	;40020: 396a0006ae68
LAB_40026:
	BRA.S	LAB_40032		;40026: 600a
LAB_40028:
	ADDQ.W	#1,D4			;40028: 5244
	ADDQ.L	#8,A2			;4002a: 508a
LAB_4002C:
	CMP.W	(_no_sprites,A4),D4	;4002c: b86c9a1c
	BLT.S	LAB_3FFD4		;40030: 6da2
LAB_40032:
	MOVEM.L	(A7)+,D4/A2		;40032: 4cdf0410
	UNLK	A5			;40036: 4e5d
	RTS				;40038: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_show_the_shield:
	LINK.W	A5,#-14			;4003a: 4e55fff2
	MOVEM.L	D4/A2,-(A7)		;4003e: 48e70820
	TST.W	(_view_who,A4)		;40042: 4a6cae68
	BEQ.W	LAB_403F4		;40046: 670003ac
	MOVE.W	(_view_who,A4),D0	;4004a: 302cae68
	SUBQ.W	#1,D0			;4004e: 5340
	MULS	#$0016,D0		;40050: c1fc0016
	LEA	(_peeps,A4),A0		;40054: 41ec9c26
	MOVEA.L	D0,A2			;40058: 2440
	ADDA.L	A0,A2			;4005a: d5c8
	TST.W	(4,A2)			;4005c: 4a6a0004
	BGT.S	LAB_4006E		;40060: 6e0c
	CLR.W	(_view_who,A4)		;40062: 426cae68
LAB_40066:
	MOVEM.L	(A7)+,D4/A2		;40066: 4cdf0410
	UNLK	A5			;4006a: 4e5d
	RTS				;4006c: 4e75
LAB_4006E:
	MOVEQ	#0,D0			;4006e: 7000
	MOVE.B	(1,A2),D0		;40070: 102a0001
	MOVE.W	D0,-(A7)		;40074: 3f00
	MOVE.W	#$0004,-(A7)		;40076: 3f3c0004
	MOVE.W	#$0011,-(A7)		;4007a: 3f3c0011
	MOVE.L	(_w_screen,A4),-(A7)	;4007e: 2f2c99e8
	JSR	(___draw_icon,A4)	;40082: 4eac810a
	LEA	($A,A7),A7		;40086: 4fef000a
	MOVEQ	#1,D4			;4008a: 7801
	BRA.S	LAB_40090		;4008c: 6002
LAB_4008E:
	ADDQ.W	#1,D4			;4008e: 5244
LAB_40090:
	MOVE.W	D4,D0			;40090: 3004
	EXT.L	D0			;40092: 48c0
	ASL.L	#1,D0			;40094: e380
	LEA	(_weapons_order,A4),A0	;40096: 41ec2f96
	MOVEQ	#0,D1			;4009a: 7200
	MOVE.B	(3,A2),D1		;4009c: 122a0003
	MOVE.W	(0,A0,D0.L),D2		;400a0: 34300800
	CMP.W	D1,D2			;400a4: b441
	BEQ.S	LAB_400AE		;400a6: 6706
	CMP.W	#$000b,D4		;400a8: b87c000b
	BLT.S	LAB_4008E		;400ac: 6de0
LAB_400AE:
	CMP.W	#$000b,D4		;400ae: b87c000b
	BGE.S	LAB_400CE		;400b2: 6c1a
	MOVE.W	D4,D0			;400b4: 3004
	ADDQ.W	#1,D0			;400b6: 5240
	MOVE.W	D0,-(A7)		;400b8: 3f00
	MOVE.W	#$0004,-(A7)		;400ba: 3f3c0004
	MOVE.W	#$0012,-(A7)		;400be: 3f3c0012
	MOVE.L	(_w_screen,A4),-(A7)	;400c2: 2f2c99e8
	JSR	(___draw_icon,A4)	;400c6: 4eac810a
	LEA	($A,A7),A7		;400ca: 4fef000a
LAB_400CE:
	BTST	#3,(A2)			;400ce: 08120003
	BEQ.W	LAB_401AE		;400d2: 670000da
	MOVE.W	($C,A2),-(A7)		;400d6: 3f2a000c
	MOVE.W	#$0016,-(A7)		;400da: 3f3c0016
	MOVE.W	#$0110,-(A7)		;400de: 3f3c0110
	MOVE.L	(_w_screen,A4),-(A7)	;400e2: 2f2c99e8
	JSR	(___draw_sprite,A4)	;400e6: 4eac8116
	LEA	($A,A7),A7		;400ea: 4fef000a
	TST.B	(1,A2)			;400ee: 4a2a0001
	BNE.S	LAB_4010C		;400f2: 6618
	MOVE.L	A2,(-10,A5)		;400f4: 2b4afff6
	MOVE.W	(6,A2),D0		;400f8: 302a0006
	MULU	#$0016,D0		;400fc: c0fc0016
	LEA	(_peeps,A4),A0		;40100: 41ec9c26
	ADD.L	A0,D0			;40104: d088
	MOVE.L	D0,(-14,A5)		;40106: 2b40fff2
	BRA.S	LAB_40122		;4010a: 6016
LAB_4010C:
	MOVE.W	(6,A2),D0		;4010c: 302a0006
	MULU	#$0016,D0		;40110: c0fc0016
	LEA	(_peeps,A4),A0		;40114: 41ec9c26
	ADD.L	A0,D0			;40118: d088
	MOVE.L	D0,(-10,A5)		;4011a: 2b40fff6
	MOVE.L	A2,(-14,A5)		;4011e: 2b4afff2
LAB_40122:
	MOVEA.L	(-10,A5),A0		;40122: 206dfff6
	MOVE.W	(4,A0),D0		;40126: 30280004
	EXT.L	D0			;4012a: 48c0
	ASL.L	#4,D0			;4012c: e980
	MOVEA.L	(-10,A5),A0		;4012e: 206dfff6
	MOVE.W	(4,A0),D1		;40132: 32280004
	MOVEA.L	(-14,A5),A0		;40136: 206dfff2
	ADD.W	(4,A0),D1		;4013a: d2680004
	EXT.L	D1			;4013e: 48c1
	JSR	(___divs,A4)		;40140: 4eac81ca
	MOVE.W	D0,D4			;40144: 3800
	MOVEA.L	(-14,A5),A0		;40146: 206dfff2
	MOVE.W	(4,A0),D0		;4014a: 30280004
	EXT.L	D0			;4014e: 48c0
	ASL.L	#4,D0			;40150: e980
	MOVEA.L	(-10,A5),A0		;40152: 206dfff6
	MOVE.W	(4,A0),D1		;40156: 32280004
	MOVEA.L	(-14,A5),A0		;4015a: 206dfff2
	ADD.W	(4,A0),D1		;4015e: d2680004
	EXT.L	D1			;40162: 48c1
	JSR	(___divs,A4)		;40164: 4eac81ca
	MOVE.W	D0,(-2,A5)		;40168: 3b40fffe
	MOVE.W	#$000f,-(A7)		;4016c: 3f3c000f
	MOVE.W	D4,-(A7)		;40170: 3f04
	MOVE.W	#$0010,-(A7)		;40172: 3f3c0010
	MOVE.W	#$0025,-(A7)		;40176: 3f3c0025
	MOVE.W	#$0024,-(A7)		;4017a: 3f3c0024
	MOVE.L	(_w_screen,A4),-(A7)	;4017e: 2f2c99e8
	JSR	(___draw_bar,A4)	;40182: 4eac8110
	LEA	($E,A7),A7		;40186: 4fef000e
	MOVE.W	#$0008,-(A7)		;4018a: 3f3c0008
	MOVE.W	(-2,A5),-(A7)		;4018e: 3f2dfffe
	MOVE.W	#$0010,-(A7)		;40192: 3f3c0010
	MOVE.W	#$0025,-(A7)		;40196: 3f3c0025
	MOVE.W	#$0025,-(A7)		;4019a: 3f3c0025
	MOVE.L	(_w_screen,A4),-(A7)	;4019e: 2f2c99e8
	JSR	(___draw_bar,A4)	;401a2: 4eac8110
	LEA	($E,A7),A7		;401a6: 4fef000e
	BRA.W	LAB_403F4		;401aa: 60000248
LAB_401AE:
	CMPI.B	#$01,(A2)		;401ae: 0c120001
	BNE.W	LAB_4029E		;401b2: 660000ea
	MOVEQ	#0,D0			;401b6: 7000
	MOVE.B	(1,A2),D0		;401b8: 102a0001
	ASL.W	#1,D0			;401bc: e340
	ADD.W	(_toggle,A4),D0		;401be: d06c9a1a
	ADD.W	#$0040,D0		;401c2: d07c0040
	MOVE.W	D0,-(A7)		;401c6: 3f00
	MOVE.W	#$0016,-(A7)		;401c8: 3f3c0016
	MOVE.W	#$010c,-(A7)		;401cc: 3f3c010c
	MOVE.L	(_w_screen,A4),-(A7)	;401d0: 2f2c99e8
	JSR	(___draw_sprite,A4)	;401d4: 4eac8116
	LEA	($A,A7),A7		;401d8: 4fef000a
	MOVE.W	(8,A2),-(A7)		;401dc: 3f2a0008
	MOVEQ	#0,D0			;401e0: 7000
	MOVE.B	(1,A2),D0		;401e2: 102a0001
	MOVE.W	D0,-(A7)		;401e6: 3f00
	JSR	(___check_life,A4)	;401e8: 4eac8182
	ADDQ.W	#4,A7			;401ec: 584f
	MOVE.W	D0,(-6,A5)		;401ee: 3b40fffa
	TST.W	(-6,A5)			;401f2: 4a6dfffa
	BNE.S	LAB_401FE		;401f6: 6606
	MOVE.W	#$0001,(-6,A5)		;401f8: 3b7c0001fffa
LAB_401FE:
	CMPI.W	#$0bea,(-6,A5)		;401fe: 0c6d0beafffa
	BNE.S	LAB_40228		;40204: 6622
	MOVE.W	#$000a,-(A7)		;40206: 3f3c000a
	MOVE.W	#$0010,-(A7)		;4020a: 3f3c0010
	MOVE.W	#$0010,-(A7)		;4020e: 3f3c0010
	MOVE.W	#$0025,-(A7)		;40212: 3f3c0025
	MOVE.W	#$0024,-(A7)		;40216: 3f3c0024
	MOVE.L	(_w_screen,A4),-(A7)	;4021a: 2f2c99e8
	JSR	(___draw_bar,A4)	;4021e: 4eac8110
	LEA	($E,A7),A7		;40222: 4fef000e
	BRA.S	LAB_40256		;40226: 602e
LAB_40228:
	MOVE.W	#$000a,-(A7)		;40228: 3f3c000a
	MOVE.W	(-6,A5),D0		;4022c: 302dfffa
	ASL.W	#4,D0			;40230: e940
	SWAP	D0			;40232: 4840
	CLR.W	D0			;40234: 4240
	SWAP	D0			;40236: 4840
	DIVU	#$0131,D0		;40238: 80fc0131
	MOVE.W	D0,-(A7)		;4023c: 3f00
	MOVE.W	#$0010,-(A7)		;4023e: 3f3c0010
	MOVE.W	#$0025,-(A7)		;40242: 3f3c0025
	MOVE.W	#$0024,-(A7)		;40246: 3f3c0024
	MOVE.L	(_w_screen,A4),-(A7)	;4024a: 2f2c99e8
	JSR	(___draw_bar,A4)	;4024e: 4eac8110
	LEA	($E,A7),A7		;40252: 4fef000e
LAB_40256:
	MOVE.W	(4,A2),D0		;40256: 302a0004
	ASL.W	#4,D0			;4025a: e940
	MOVE.W	D0,(-4,A5)		;4025c: 3b40fffc
	MOVE.W	(-4,A5),D4		;40260: 382dfffc
	SWAP	D4			;40264: 4844
	CLR.W	D4			;40266: 4244
	SWAP	D4			;40268: 4844
	DIVU	(-6,A5),D4		;4026a: 88edfffa
	CMP.W	#$0010,D4		;4026e: b87c0010
	BLE.S	LAB_40276		;40272: 6f02
	MOVEQ	#$10,D4			;40274: 7810
LAB_40276:
	TST.W	D4			;40276: 4a44
	BGE.S	LAB_4027C		;40278: 6c02
	MOVEQ	#0,D4			;4027a: 7800
LAB_4027C:
	MOVE.W	#$000c,-(A7)		;4027c: 3f3c000c
	MOVE.W	D4,-(A7)		;40280: 3f04
	MOVE.W	#$0010,-(A7)		;40282: 3f3c0010
	MOVE.W	#$0025,-(A7)		;40286: 3f3c0025
	MOVE.W	#$0025,-(A7)		;4028a: 3f3c0025
	MOVE.L	(_w_screen,A4),-(A7)	;4028e: 2f2c99e8
	JSR	(___draw_bar,A4)	;40292: 4eac8110
	LEA	($E,A7),A7		;40296: 4fef000e
	BRA.W	LAB_403F4		;4029a: 60000158
LAB_4029E:
	MOVE.B	(A2),D0			;4029e: 1012
	AND.B	#$60,D0			;402a0: c03c0060
	BEQ.S	LAB_402C2		;402a4: 671c
	TST.L	($E,A2)			;402a6: 4aaa000e
	BEQ.S	LAB_402B0		;402aa: 6704
	MOVEQ	#$7D,D4			;402ac: 787d
	BRA.S	LAB_402B2		;402ae: 6002
LAB_402B0:
	MOVEQ	#$65,D4			;402b0: 7865
LAB_402B2:
	MOVEQ	#0,D0			;402b2: 7000
	MOVE.B	(1,A2),D0		;402b4: 102a0001
	ASL.W	#1,D0			;402b8: e340
	ADD.W	(_toggle,A4),D0		;402ba: d06c9a1a
	ADD.W	D0,D4			;402be: d840
	BRA.S	LAB_40330		;402c0: 606e
LAB_402C2:
	BTST	#4,(A2)			;402c2: 08120004
	BEQ.S	LAB_402EA		;402c6: 6722
	TST.L	($E,A2)			;402c8: 4aaa000e
	BEQ.S	LAB_402D2		;402cc: 6704
	MOVEQ	#$6D,D4			;402ce: 786d
	BRA.S	LAB_402D4		;402d0: 6002
LAB_402D2:
	MOVEQ	#$5D,D4			;402d2: 785d
LAB_402D4:
	MOVEQ	#0,D0			;402d4: 7000
	MOVE.B	(1,A2),D0		;402d6: 102a0001
	ASL.W	#2,D0			;402da: e540
	MOVE.W	(_game_turn,A4),D1	;402dc: 322cae6a
	AND.W	#$0003,D1		;402e0: c27c0003
	ADD.W	D1,D0			;402e4: d041
	ADD.W	D0,D4			;402e6: d840
	BRA.S	LAB_40330		;402e8: 6046
LAB_402EA:
	MOVEQ	#0,D4			;402ea: 7800
	BRA.S	LAB_402F0		;402ec: 6002
LAB_402EE:
	ADDQ.W	#1,D4			;402ee: 5244
LAB_402F0:
	CMP.W	#$0009,D4		;402f0: b87c0009
	BGE.S	LAB_4030A		;402f4: 6c14
	MOVE.W	D4,D0			;402f6: 3004
	EXT.L	D0			;402f8: 48c0
	ASL.L	#1,D0			;402fa: e380
	LEA	(_dir_sprite,A4),A0	;402fc: 41ec8462
	MOVE.W	(0,A0,D0.L),D1		;40300: 32300800
	CMP.W	($A,A2),D1		;40304: b26a000a
	BNE.S	LAB_402EE		;40308: 66e4
LAB_4030A:
	CMP.W	#$0007,D4		;4030a: b87c0007
	BLE.S	LAB_40312		;4030e: 6f02
	MOVEQ	#4,D4			;40310: 7804
LAB_40312:
	MOVE.W	D4,D0			;40312: 3004
	ASL.W	#1,D0			;40314: e340
	MOVE.W	D0,D4			;40316: 3800
	ADD.W	(_toggle,A4),D4		;40318: d86c9a1a
	TST.L	($E,A2)			;4031c: 4aaa000e
	BEQ.S	LAB_40326		;40320: 6704
	ADD.W	#$0020,D4		;40322: d87c0020
LAB_40326:
	MOVEQ	#0,D0			;40326: 7000
	MOVE.B	(1,A2),D0		;40328: 102a0001
	ASL.W	#4,D0			;4032c: e940
	ADD.W	D0,D4			;4032e: d840
LAB_40330:
	MOVE.W	D4,-(A7)		;40330: 3f04
	MOVE.W	#$0016,-(A7)		;40332: 3f3c0016
	MOVE.W	#$0110,-(A7)		;40336: 3f3c0110
	MOVE.L	(_w_screen,A4),-(A7)	;4033a: 2f2c99e8
	JSR	(___draw_sprite,A4)	;4033e: 4eac8116
	LEA	($A,A7),A7		;40342: 4fef000a
	MOVE.W	(4,A2),D4		;40346: 382a0004
	CMP.W	#$1000,D4		;4034a: b87c1000
	BLE.S	LAB_403A0		;4034e: 6f50
	MOVE.W	#$000a,-(A7)		;40350: 3f3c000a
	MOVE.W	D4,D0			;40354: 3004
	EXT.L	D0			;40356: 48c0
	DIVS	#$0400,D0		;40358: 81fc0400
	MOVE.W	D0,-(A7)		;4035c: 3f00
	MOVE.W	#$0010,-(A7)		;4035e: 3f3c0010
	MOVE.W	#$0025,-(A7)		;40362: 3f3c0025
	MOVE.W	#$0024,-(A7)		;40366: 3f3c0024
	MOVE.L	(_w_screen,A4),-(A7)	;4036a: 2f2c99e8
	JSR	(___draw_bar,A4)	;4036e: 4eac8110
	LEA	($E,A7),A7		;40372: 4fef000e
	MOVE.W	#$0009,-(A7)		;40376: 3f3c0009
	MOVE.W	D4,D0			;4037a: 3004
	EXT.L	D0			;4037c: 48c0
	DIVS	#$0400,D0		;4037e: 81fc0400
	SWAP	D0			;40382: 4840
	MOVE.W	D0,-(A7)		;40384: 3f00
	MOVE.W	#$0010,-(A7)		;40386: 3f3c0010
	MOVE.W	#$0025,-(A7)		;4038a: 3f3c0025
	MOVE.W	#$0025,-(A7)		;4038e: 3f3c0025
	MOVE.L	(_w_screen,A4),-(A7)	;40392: 2f2c99e8
	JSR	(___draw_bar,A4)	;40396: 4eac8110
	LEA	($E,A7),A7		;4039a: 4fef000e
	BRA.S	LAB_403F4		;4039e: 6054
LAB_403A0:
	MOVE.W	#$0009,-(A7)		;403a0: 3f3c0009
	MOVE.W	D4,D0			;403a4: 3004
	EXT.L	D0			;403a6: 48c0
	DIVS	#$0100,D0		;403a8: 81fc0100
	MOVE.W	D0,-(A7)		;403ac: 3f00
	MOVE.W	#$0010,-(A7)		;403ae: 3f3c0010
	MOVE.W	#$0025,-(A7)		;403b2: 3f3c0025
	MOVE.W	#$0024,-(A7)		;403b6: 3f3c0024
	MOVE.L	(_w_screen,A4),-(A7)	;403ba: 2f2c99e8
	JSR	(___draw_bar,A4)	;403be: 4eac8110
	LEA	($E,A7),A7		;403c2: 4fef000e
	MOVE.W	#$0009,-(A7)		;403c6: 3f3c0009
	MOVE.W	D4,D0			;403ca: 3004
	EXT.L	D0			;403cc: 48c0
	DIVS	#$0100,D0		;403ce: 81fc0100
	SWAP	D0			;403d2: 4840
	EXT.L	D0			;403d4: 48c0
	DIVS	#$0010,D0		;403d6: 81fc0010
	MOVE.W	D0,-(A7)		;403da: 3f00
	MOVE.W	#$0010,-(A7)		;403dc: 3f3c0010
	MOVE.W	#$0025,-(A7)		;403e0: 3f3c0025
	MOVE.W	#$0025,-(A7)		;403e4: 3f3c0025
	MOVE.L	(_w_screen,A4),-(A7)	;403e8: 2f2c99e8
	JSR	(___draw_bar,A4)	;403ec: 4eac8110
	LEA	($E,A7),A7		;403f0: 4fef000e
LAB_403F4:
	TST.L	(good_pop,A4)		;403f4: 4aac99fe
	BEQ.S	LAB_40430		;403f8: 6736
	MOVE.W	#$000f,-(A7)		;403fa: 3f3c000f
	MOVEQ	#$1F,D1			;403fe: 721f
	MOVE.L	(good_pop,A4),D0	;40400: 202c99fe
	JSR	(___mulu,A4)		;40404: 4eac81c4
	MOVE.L	#$0000c350,D1		;40408: 223c0000c350
	JSR	(___divs,A4)		;4040e: 4eac81ca
	ADDQ.L	#1,D0			;40412: 5280
	MOVE.W	D0,-(A7)		;40414: 3f00
	MOVE.W	#$0020,-(A7)		;40416: 3f3c0020
	MOVE.W	#$001f,-(A7)		;4041a: 3f3c001f
	MOVE.W	#$0020,-(A7)		;4041e: 3f3c0020
	MOVE.L	(_w_screen,A4),-(A7)	;40422: 2f2c99e8
	JSR	(___draw_bar,A4)	;40426: 4eac8110
	LEA	($E,A7),A7		;4042a: 4fef000e
	BRA.S	LAB_4044E		;4042e: 601e
LAB_40430:
	MOVE.W	#$000f,-(A7)		;40430: 3f3c000f
	CLR.W	-(A7)			;40434: 4267
	MOVE.W	#$0020,-(A7)		;40436: 3f3c0020
	MOVE.W	#$001f,-(A7)		;4043a: 3f3c001f
	MOVE.W	#$0020,-(A7)		;4043e: 3f3c0020
	MOVE.L	(_w_screen,A4),-(A7)	;40442: 2f2c99e8
	JSR	(___draw_bar,A4)	;40446: 4eac8110
	LEA	($E,A7),A7		;4044a: 4fef000e
LAB_4044E:
	TST.L	(bad_pop,A4)		;4044e: 4aac9a0e
	BEQ.S	LAB_4048A		;40452: 6736
	MOVE.W	#$0008,-(A7)		;40454: 3f3c0008
	MOVEQ	#$1F,D1			;40458: 721f
	MOVE.L	(bad_pop,A4),D0		;4045a: 202c9a0e
	JSR	(___mulu,A4)		;4045e: 4eac81c4
	MOVE.L	#$0000c350,D1		;40462: 223c0000c350
	JSR	(___divs,A4)		;40468: 4eac81ca
	ADDQ.L	#1,D0			;4046c: 5280
	MOVE.W	D0,-(A7)		;4046e: 3f00
	MOVE.W	#$0020,-(A7)		;40470: 3f3c0020
	MOVE.W	#$001f,-(A7)		;40474: 3f3c001f
	MOVE.W	#$0027,-(A7)		;40478: 3f3c0027
	MOVE.L	(_w_screen,A4),-(A7)	;4047c: 2f2c99e8
	JSR	(___draw_bar,A4)	;40480: 4eac8110
	LEA	($E,A7),A7		;40484: 4fef000e
	BRA.S	LAB_404A8		;40488: 601e
LAB_4048A:
	MOVE.W	#$0008,-(A7)		;4048a: 3f3c0008
	CLR.W	-(A7)			;4048e: 4267
	MOVE.W	#$0020,-(A7)		;40490: 3f3c0020
	MOVE.W	#$001f,-(A7)		;40494: 3f3c001f
	MOVE.W	#$0027,-(A7)		;40498: 3f3c0027
	MOVE.L	(_w_screen,A4),-(A7)	;4049c: 2f2c99e8
	JSR	(___draw_bar,A4)	;404a0: 4eac8110
	LEA	($E,A7),A7		;404a4: 4fef000e
LAB_404A8:
	BRA.W	LAB_40066		;404a8: 6000fbbc
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_temp_view:
	LINK.W	A5,#0			;404ac: 4e550000
	TST.W	(_view_timer,A4)	;404b0: 4a6cae60
	BNE.S	LAB_404BC		;404b4: 6606
	MOVE.W	(_view_who,A4),(_old_view_who,A4) ;404b6: 396cae68ae66
LAB_404BC:
	MOVE.W	#$000a,(_view_timer,A4)	;404bc: 397c000aae60
	MOVE.W	(8,A5),(_view_who,A4)	;404c2: 396d0008ae68
	UNLK	A5			;404c8: 4e5d
	RTS				;404ca: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_move_mana:
	LINK.W	A5,#0			;404cc: 4e550000
	MOVEM.L	D4-D5,-(A7)		;404d0: 48e70c00
	MOVEQ	#0,D4			;404d4: 7800
	BRA.S	LAB_404DA		;404d6: 6002
LAB_404D8:
	ADDQ.W	#1,D4			;404d8: 5244
LAB_404DA:
	MOVE.W	(_player,A4),D0		;404da: 302c99f4
	EXT.L	D0			;404de: 48c0
	ASL.L	#4,D0			;404e0: e980
	LEA	(LAB_52DF0,A4),A0	;404e2: 41ec9a02
	MOVE.W	D4,D1			;404e6: 3204
	EXT.L	D1			;404e8: 48c1
	ASL.L	#2,D1			;404ea: e581
	LEA	(_mana_values,A4),A1	;404ec: 43ec8486
	MOVE.L	(0,A0,D0.L),D2		;404f0: 24300800
	CMP.L	(0,A1,D1.L),D2		;404f4: b4b11800
	BGT.S	LAB_404D8		;404f8: 6ede
	CMP.W	#$0009,D4		;404fa: b87c0009
	BGT.S	LAB_4057A		;404fe: 6e7a
	MOVE.W	(_player,A4),D0		;40500: 302c99f4
	EXT.L	D0			;40504: 48c0
	ASL.L	#4,D0			;40506: e980
	LEA	(LAB_52DF0,A4),A0	;40508: 41ec9a02
	MOVE.L	D0,D1			;4050c: 2200
	MOVE.L	(0,A0,D1.L),D0		;4050e: 20301800
	MOVE.W	D4,D1			;40512: 3204
	SUBQ.W	#1,D1			;40514: 5341
	EXT.L	D1			;40516: 48c1
	ASL.L	#2,D1			;40518: e581
	LEA	(_mana_values,A4),A0	;4051a: 41ec8486
	SUB.L	(0,A0,D1.L),D0		;4051e: 90b01800
	ASL.L	#3,D0			;40522: e780
	MOVE.W	D4,D1			;40524: 3204
	EXT.L	D1			;40526: 48c1
	ASL.L	#2,D1			;40528: e581
	LEA	(_mana_values,A4),A0	;4052a: 41ec8486
	MOVE.L	D1,D2			;4052e: 2401
	MOVE.L	(0,A0,D2.L),D1		;40530: 22302800
	MOVE.W	D4,D2			;40534: 3404
	SUBQ.W	#1,D2			;40536: 5342
	EXT.L	D2			;40538: 48c2
	ASL.L	#2,D2			;4053a: e582
	LEA	(_mana_values,A4),A0	;4053c: 41ec8486
	SUB.L	(0,A0,D2.L),D1		;40540: 92b02800
	JSR	(___divs,A4)		;40544: 4eac81ca
	MOVE.W	D0,D5			;40548: 3a00
	MOVE.W	#$0045,-(A7)		;4054a: 3f3c0045
	MOVE.W	D4,D0			;4054e: 3004
	SUBQ.W	#1,D0			;40550: 5340
	ASL.W	#3,D0			;40552: e740
	ADD.W	D5,D0			;40554: d045
	ADDQ.W	#8,D0			;40556: 5040
	MOVE.W	D0,-(A7)		;40558: 3f00
	MOVE.W	D4,D0			;4055a: 3004
	SUBQ.W	#1,D0			;4055c: 5340
	ASL.W	#4,D0			;4055e: e940
	MOVE.W	D5,D1			;40560: 3205
	ASL.W	#1,D1			;40562: e341
	ADD.W	D1,D0			;40564: d041
	ADD.W	#$00a0,D0		;40566: d07c00a0
	MOVE.W	D0,-(A7)		;4056a: 3f00
	MOVE.L	(_w_screen,A4),-(A7)	;4056c: 2f2c99e8
	JSR	(___draw_sprite,A4)	;40570: 4eac8116
	LEA	($A,A7),A7		;40574: 4fef000a
	BRA.S	LAB_40592		;40578: 6018
LAB_4057A:
	MOVE.W	#$0045,-(A7)		;4057a: 3f3c0045
	MOVE.W	#$0057,-(A7)		;4057e: 3f3c0057
	MOVE.W	#$0137,-(A7)		;40582: 3f3c0137
	MOVE.L	(_w_screen,A4),-(A7)	;40586: 2f2c99e8
	JSR	(___draw_sprite,A4)	;4058a: 4eac8116
	LEA	($A,A7),A7		;4058e: 4fef000a
LAB_40592:
	MOVEM.L	(A7)+,D4-D5		;40592: 4cdf0030
	UNLK	A5			;40596: 4e5d
	RTS				;40598: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_move_peeps:
	LINK.W	A5,#-146		;4059a: 4e55ff6e
	CLR.W	(-42,A5)		;4059e: 426dffd6
	CLR.W	(-44,A5)		;405a2: 426dffd4
; Increment game turn
	ADDQ.W	#1,(_game_turn,A4)	;405a6: 526cae6a
	CLR.W	(-2,A5)			;405aa: 426dfffe
LAB_405AE:
	MOVE.W	(-2,A5),D0		;405ae: 302dfffe
	MULS	#$002e,D0		;405b2: c1fc002e
	LEA	(LAB_516AC,A4),A0	;405b6: 41ec82be
	TST.W	(0,A0,D0.L)		;405ba: 4a700800
	BNE.S	LAB_405CA		;405be: 660a
	MOVE.W	(-2,A5),-(A7)		;405c0: 3f2dfffe
	JSR	(_set_devil_magnet,PC)	;405c4: 4eba4b46
	ADDQ.W	#2,A7			;405c8: 544f
LAB_405CA:
	MOVE.W	(-2,A5),D0		;405ca: 302dfffe
	MULS	#$002e,D0		;405ce: c1fc002e
	LEA	(LAB_516AC,A4),A0	;405d2: 41ec82be
	TST.W	(0,A0,D0.L)		;405d6: 4a700800
	BNE.S	LAB_405E6		;405da: 660a
	MOVE.W	(-2,A5),-(A7)		;405dc: 3f2dfffe
	JSR	(_devil_effect,PC)	;405e0: 4eba4778
	ADDQ.W	#2,A7			;405e4: 544f
LAB_405E6:
	ADDQ.W	#1,(-2,A5)		;405e6: 526dfffe
	CMPI.W	#$0002,(-2,A5)		;405ea: 0c6d0002fffe
	BLT.S	LAB_405AE		;405f0: 6dbc
	CLR.W	(-2,A5)			;405f2: 426dfffe
LAB_405F6:
	MOVE.W	(-2,A5),D0		;405f6: 302dfffe
	EXT.L	D0			;405fa: 48c0
	ASL.L	#1,D0			;405fc: e380
	LEA	(-32,A5),A0		;405fe: 41edffe0
	MOVE.W	(-2,A5),D1		;40602: 322dfffe
	MULS	#$002e,D1		;40606: c3fc002e
	LEA	(good_castles,A4),A1	;4060a: 43ec82ca
	MOVE.W	(0,A1,D1.L),D2		;4060e: 34311800
	MULS	#$0003,D2		;40612: c5fc0003
	MOVE.W	(-2,A5),D1		;40616: 322dfffe
	MULS	#$002e,D1		;4061a: c3fc002e
	LEA	(good_towns,A4),A1	;4061e: 43ec82cc
	ADD.W	(0,A1,D1.L),D2		;40622: d4711800
	MOVE.W	D2,(0,A0,D0.L)		;40626: 31820800
	MOVE.W	(-2,A5),D0		;4062a: 302dfffe
	EXT.L	D0			;4062e: 48c0
	ASL.L	#4,D0			;40630: e980
	LEA	(LAB_52DEA,A4),A0	;40632: 41ec99fc
	MOVEQ	#0,D1			;40636: 7200
	MOVE.W	D1,(0,A0,D0.L)		;40638: 31810800
	EXT.L	D1			;4063c: 48c1
	MOVE.W	(-2,A5),D0		;4063e: 302dfffe
	EXT.L	D0			;40642: 48c0
	ASL.L	#4,D0			;40644: e980
	LEA	(good_pop,A4),A0	;40646: 41ec99fe
	MOVE.L	D1,(0,A0,D0.L)		;4064a: 21810800
	TST.W	(_toggle,A4)		;4064e: 4a6c9a1a
	BEQ.S	LAB_40664		;40652: 6710
	MOVE.W	(-2,A5),D0		;40654: 302dfffe
	EXT.L	D0			;40658: 48c0
	ASL.L	#4,D0			;4065a: e980
	LEA	(LAB_52DF0,A4),A0	;4065c: 41ec9a02
	ADDQ.L	#1,(0,A0,D0.L)		;40660: 52b00800
LAB_40664:
	MOVE.W	(-2,A5),D0		;40664: 302dfffe
	MULS	#$002e,D0		;40668: c1fc002e
	LEA	(LAB_516CE,A4),A0	;4066c: 41ec82e0
	CLR.L	(0,A0,D0.L)		;40670: 42b00800
	MOVE.W	(-2,A5),D0		;40674: 302dfffe
	MULS	#$002e,D0		;40678: c1fc002e
	LEA	(LAB_516CA,A4),A0	;4067c: 41ec82dc
	CLR.L	(0,A0,D0.L)		;40680: 42b00800
	MOVE.W	(-2,A5),D0		;40684: 302dfffe
	MULS	#$002e,D0		;40688: c1fc002e
	LEA	(LAB_516C6,A4),A0	;4068c: 41ec82d8
	CLR.L	(0,A0,D0.L)		;40690: 42b00800
	MOVE.W	(-2,A5),D0		;40694: 302dfffe
	EXT.L	D0			;40698: 48c0
	ASL.L	#1,D0			;4069a: e380
	LEA	(-40,A5),A0		;4069c: 41edffd8
	CLR.W	(0,A0,D0.L)		;406a0: 42700800
	MOVE.W	(-2,A5),D0		;406a4: 302dfffe
	EXT.L	D0			;406a8: 48c0
	ASL.L	#1,D0			;406aa: e380
	LEA	(-28,A5),A0		;406ac: 41edffe4
	CLR.W	(0,A0,D0.L)		;406b0: 42700800
	MOVE.W	(-2,A5),D0		;406b4: 302dfffe
	EXT.L	D0			;406b8: 48c0
	ASL.L	#1,D0			;406ba: e380
	LEA	(-24,A5),A0		;406bc: 41edffe8
	CLR.W	(0,A0,D0.L)		;406c0: 42700800
	MOVE.W	(-2,A5),D0		;406c4: 302dfffe
	EXT.L	D0			;406c8: 48c0
	ASL.L	#1,D0			;406ca: e380
	LEA	(-36,A5),A0		;406cc: 41edffdc
	MOVE.W	#$4e1f,(0,A0,D0.L)	;406d0: 31bc4e1f0800
	ADDQ.W	#1,(-2,A5)		;406d6: 526dfffe
	CMPI.W	#$0002,(-2,A5)		;406da: 0c6d0002fffe
	BLT.W	LAB_405F6		;406e0: 6d00ff14
	BRA.S	LAB_406EA		;406e4: 6004
LAB_406E6:
	SUBQ.W	#1,(_no_peeps,A4)	;406e6: 536cae5e
LAB_406EA:
	MOVE.W	(_no_peeps,A4),D0	;406ea: 302cae5e
	SUBQ.W	#1,D0			;406ee: 5340
	MULS	#$0016,D0		;406f0: c1fc0016
	LEA	(LAB_53018,A4),A0	;406f4: 41ec9c2a
	TST.W	(0,A0,D0.L)		;406f8: 4a700800
	BNE.S	LAB_40704		;406fc: 6606
	TST.W	(_no_peeps,A4)		;406fe: 4a6cae5e
	BGT.S	LAB_406E6		;40702: 6ee2
LAB_40704:
	MOVE.W	(_player,A4),D0		;40704: 302c99f4
	EXT.L	D0			;40708: 48c0
	ASL.L	#4,D0			;4070a: e980
	LEA	(_magnet,A4),A0		;4070c: 41ec99f6
	TST.W	(0,A0,D0.L)		;40710: 4a700800
	BEQ.S	LAB_4076E		;40714: 6758
	MOVE.W	(_player,A4),D0		;40716: 302c99f4
	EXT.L	D0			;4071a: 48c0
	ASL.L	#4,D0			;4071c: e980
	LEA	(_magnet,A4),A0		;4071e: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;40722: 32300800
	SUBQ.W	#1,D1			;40726: 5341
	MULS	#$0016,D1		;40728: c3fc0016
	LEA	(LAB_53022,A4),A0	;4072c: 41ec9c34
	TST.L	(0,A0,D1.L)		;40730: 4ab01800
	BEQ.S	LAB_4076E		;40734: 6738
	MOVE.W	(_player,A4),D0		;40736: 302c99f4
	EXT.L	D0			;4073a: 48c0
	ASL.L	#4,D0			;4073c: e980
	LEA	(_magnet,A4),A0		;4073e: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;40742: 32300800
	SUBQ.W	#1,D1			;40746: 5341
	MULS	#$0016,D1		;40748: c3fc0016
	LEA	(LAB_5301C,A4),A0	;4074c: 41ec9c2e
	MOVE.W	(0,A0,D1.L),-(A7)	;40750: 3f301800
	MOVE.W	(_player,A4),-(A7)	;40754: 3f2c99f4
	JSR	(_set_magnet_to,PC)	;40758: 4eba3972
	ADDQ.W	#4,A7			;4075c: 584f
	MOVE.W	(_player,A4),D0		;4075e: 302c99f4
	EXT.L	D0			;40762: 48c0
	ASL.L	#4,D0			;40764: e980
	LEA	(_magnet,A4),A0		;40766: 41ec99f6
	CLR.W	(0,A0,D0.L)		;4076a: 42700800
LAB_4076E:
	MOVE.W	(_not_player,A4),D0	;4076e: 302c825a
	EXT.L	D0			;40772: 48c0
	ASL.L	#4,D0			;40774: e980
	LEA	(_magnet,A4),A0		;40776: 41ec99f6
	TST.W	(0,A0,D0.L)		;4077a: 4a700800
	BEQ.S	LAB_407D8		;4077e: 6758
	MOVE.W	(_not_player,A4),D0	;40780: 302c825a
	EXT.L	D0			;40784: 48c0
	ASL.L	#4,D0			;40786: e980
	LEA	(_magnet,A4),A0		;40788: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;4078c: 32300800
	SUBQ.W	#1,D1			;40790: 5341
	MULS	#$0016,D1		;40792: c3fc0016
	LEA	(LAB_53022,A4),A0	;40796: 41ec9c34
	TST.L	(0,A0,D1.L)		;4079a: 4ab01800
	BEQ.S	LAB_407D8		;4079e: 6738
	MOVE.W	(_not_player,A4),D0	;407a0: 302c825a
	EXT.L	D0			;407a4: 48c0
	ASL.L	#4,D0			;407a6: e980
	LEA	(_magnet,A4),A0		;407a8: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;407ac: 32300800
	SUBQ.W	#1,D1			;407b0: 5341
	MULS	#$0016,D1		;407b2: c3fc0016
	LEA	(LAB_5301C,A4),A0	;407b6: 41ec9c2e
	MOVE.W	(0,A0,D1.L),-(A7)	;407ba: 3f301800
	MOVE.W	(_not_player,A4),-(A7)	;407be: 3f2c825a
	JSR	(_set_magnet_to,PC)	;407c2: 4eba3908
	ADDQ.W	#4,A7			;407c6: 584f
	MOVE.W	(_not_player,A4),D0	;407c8: 302c825a
	EXT.L	D0			;407cc: 48c0
	ASL.L	#4,D0			;407ce: e980
	LEA	(_magnet,A4),A0		;407d0: 41ec99f6
	CLR.W	(0,A0,D0.L)		;407d4: 42700800
LAB_407D8:
	TST.W	(_war,A4)		;407d8: 4a6cae80
	BEQ.S	LAB_407FC		;407dc: 671e
	MOVE.W	#$0820,(-2,A5)		;407de: 3b7c0820fffe
	MOVE.W	(-2,A5),(LAB_52DF6,A4)	;407e4: 396dfffe9a08
	MOVE.W	(-2,A5),(LAB_52DE6,A4)	;407ea: 396dfffe99f8
	MOVE.W	(-2,A5),(_god_magnet,A4) ;407f0: 396dfffeae78
	MOVE.W	(-2,A5),(_devil_magnet,A4) ;407f6: 396dfffeae76
LAB_407FC:
	BTST	#3,(_sound_effect,A4)	;407fc: 082c00039a20
	BEQ.S	LAB_40810		;40802: 670c
	MOVE.W	(_toggle,A4),D0		;40804: 302c9a1a
	ADD.W	#$0043,D0		;40808: d07c0043
	MOVE.W	D0,(_effect,A4)		;4080c: 39402fac
LAB_40810:
	MOVEQ	#0,D0			;40810: 7000
	MOVE.B	(_sound_effect,A4),D0	;40812: 102c9a20
	BTST	#7,D0			;40816: 08000007
	BEQ.S	LAB_40830		;4081a: 6714
	TST.W	(_last_fire,A4)		;4081c: 4a6c2fae
	BNE.S	LAB_40828		;40820: 6606
	MOVE.W	#$0046,(_effect,A4)	;40822: 397c00462fac
LAB_40828:
	MOVE.W	#$0003,(_last_fire,A4)	;40828: 397c00032fae
	BRA.S	LAB_4083A		;4082e: 600a
LAB_40830:
	TST.W	(_last_fire,A4)		;40830: 4a6c2fae
	BEQ.S	LAB_4083A		;40834: 6704
	SUBQ.W	#1,(_last_fire,A4)	;40836: 536c2fae
LAB_4083A:
	CLR.W	(-2,A5)			;4083a: 426dfffe
	LEA	(_peeps,A4),A0		;4083e: 41ec9c26
	MOVE.L	A0,(-16,A5)		;40842: 2b48fff0
LAB_40846:
	MOVE.W	(-2,A5),D0		;40846: 302dfffe
	CMP.W	(_no_peeps,A4),D0	;4084a: b06cae5e
	BGE.W	LAB_41300		;4084e: 6c000ab0
	MOVEA.L	(-16,A5),A0		;40852: 206dfff0
	TST.W	(4,A0)			;40856: 4a680004
	BLE.W	LAB_412F0		;4085a: 6f000a94
	MOVEA.L	(-16,A5),A0		;4085e: 206dfff0
	MOVEQ	#0,D0			;40862: 7000
	MOVE.B	(1,A0),D0		;40864: 10280001
	ASL.L	#4,D0			;40868: e980
	LEA	(good_pop,A4),A0	;4086a: 41ec99fe
	ADDA.L	D0,A0			;4086e: d1c0
	MOVEA.L	(-16,A5),A1		;40870: 226dfff0
	MOVE.W	(4,A1),D0		;40874: 30290004
	EXT.L	D0			;40878: 48c0
	ADD.L	D0,(A0)			;4087a: d190
	MOVEA.L	(-16,A5),A0		;4087c: 206dfff0
	MOVE.W	(8,A0),D0		;40880: 30280008
	EXT.L	D0			;40884: 48c0
	LEA	(_map_blk,A4),A0	;40886: 41eccf88
	ADD.L	A0,D0			;4088a: d088
	MOVE.L	D0,(-8,A5)		;4088c: 2b40fff8
	MOVEA.L	(-16,A5),A0		;40890: 206dfff0
	BTST	#4,(A0)			;40894: 08100004
	BEQ.W	LAB_40994		;40898: 670000fa
	BTST	#0,(LAB_518A7,A4)	;4089c: 082c000084b9
	BEQ.S	LAB_408B6		;408a2: 6712
	MOVE.W	(-2,A5),-(A7)		;408a4: 3f2dfffe
	MOVE.L	(-16,A5),-(A7)		;408a8: 2f2dfff0
	JSR	(_zero_population,PC)	;408ac: 4eba1946
	ADDQ.W	#6,A7			;408b0: 5c4f
	BRA.W	LAB_412F0		;408b2: 60000a3c
LAB_408B6:
	MOVEA.L	(-16,A5),A0		;408b6: 206dfff0
	MOVEQ	#0,D0			;408ba: 7000
	MOVE.B	(1,A0),D0		;408bc: 10280001
	MOVEQ	#$2E,D1			;408c0: 722e
	JSR	(___mulu,A4)		;408c2: 4eac81c4
	LEA	(LAB_516AA,A4),A0	;408c6: 41ec82bc
	CMPI.W	#$0001,(0,A0,D0.L)	;408ca: 0c7000010800
	BNE.S	LAB_408DA		;408d0: 6608
	BTST	#2,(LAB_518A7,A4)	;408d2: 082c000284b9
	BEQ.S	LAB_408E2		;408d8: 6708
LAB_408DA:
	TST.W	(_war,A4)		;408da: 4a6cae80
	BEQ.W	LAB_40964		;408de: 67000084
LAB_408E2:
	MOVEA.L	(-16,A5),A0		;408e2: 206dfff0
	MOVEQ	#0,D0			;408e6: 7000
	MOVE.B	(1,A0),D0		;408e8: 10280001
	MOVEQ	#$2E,D1			;408ec: 722e
	JSR	(___mulu,A4)		;408ee: 4eac81c4
	LEA	(_stats,A4),A0		;408f2: 41ec82b6
	MOVE.B	#$01,(0,A0,D0.L)	;408f6: 11bc00010800
	MOVEA.L	(-16,A5),A0		;408fc: 206dfff0
	MOVE.W	(8,A0),D0		;40900: 30280008
	AND.W	#$003f,D0		;40904: c07c003f
	MOVEA.L	(-16,A5),A0		;40908: 206dfff0
	MOVE.B	D0,-(A7)		;4090c: 1f00
	MOVEQ	#0,D0			;4090e: 7000
	MOVE.B	(1,A0),D0		;40910: 10280001
	MOVEQ	#$2E,D1			;40914: 722e
	JSR	(___mulu,A4)		;40916: 4eac81c4
	LEA	(LAB_516A5,A4),A0	;4091a: 41ec82b7
	MOVE.B	(A7)+,D1		;4091e: 121f
	MOVE.B	D1,(0,A0,D0.L)		;40920: 11810800
	MOVEA.L	(-16,A5),A0		;40924: 206dfff0
	MOVE.W	(8,A0),D0		;40928: 30280008
	ASR.W	#6,D0			;4092c: ec40
	MOVEA.L	(-16,A5),A0		;4092e: 206dfff0
	MOVE.B	D0,-(A7)		;40932: 1f00
	MOVEQ	#0,D0			;40934: 7000
	MOVE.B	(1,A0),D0		;40936: 10280001
	MOVEQ	#$2E,D1			;4093a: 722e
	JSR	(___mulu,A4)		;4093c: 4eac81c4
	LEA	(LAB_516A6,A4),A0	;40940: 41ec82b8
	MOVE.B	(A7)+,D1		;40944: 121f
	MOVE.B	D1,(0,A0,D0.L)		;40946: 11810800
	MOVEA.L	(-16,A5),A0		;4094a: 206dfff0
	MOVEQ	#0,D0			;4094e: 7000
	MOVE.B	(1,A0),D0		;40950: 10280001
	MOVEQ	#$2E,D1			;40954: 722e
	JSR	(___mulu,A4)		;40956: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;4095a: 41ec82be
	MOVE.W	#$0001,(0,A0,D0.L)	;4095e: 31bc00010800
LAB_40964:
	MOVEA.L	(-16,A5),A0		;40964: 206dfff0
	MOVE.W	(_walk_death,A4),D0	;40968: 302c2fb0
	ASL.W	#1,D0			;4096c: e340
	SUB.W	D0,(4,A0)		;4096e: 91680004
	MOVEA.L	(-8,A5),A0		;40972: 206dfff8
	TST.B	(A0)			;40976: 4a10
	BEQ.S	LAB_4098E		;40978: 6714
	MOVEA.L	(-16,A5),A0		;4097a: 206dfff0
	ANDI.B	#$ef,(A0)		;4097e: 021000ef
	MOVE.L	(-16,A5),-(A7)		;40982: 2f2dfff0
	JSR	(_set_frame,PC)		;40986: 4eba194a
	ADDQ.W	#4,A7			;4098a: 584f
	BRA.S	LAB_40992		;4098c: 6004
LAB_4098E:
	BRA.W	LAB_412D8		;4098e: 60000948
LAB_40992:
	BRA.S	LAB_409D0		;40992: 603c
LAB_40994:
	MOVEA.L	(-8,A5),A0		;40994: 206dfff8
	TST.B	(A0)			;40998: 4a10
	BNE.S	LAB_409D0		;4099a: 6634
	MOVEA.L	(-16,A5),A0		;4099c: 206dfff0
	BTST	#0,(A0)			;409a0: 08100000
	BEQ.S	LAB_409B4		;409a4: 670e
	MOVE.W	#$0001,-(A7)		;409a6: 3f3c0001
	MOVE.L	(-16,A5),-(A7)		;409aa: 2f2dfff0
	JSR	(_set_town,PC)		;409ae: 4eba1a8c
	ADDQ.W	#6,A7			;409b2: 5c4f
LAB_409B4:
	MOVEA.L	(-16,A5),A0		;409b4: 206dfff0
	MOVE.B	#$12,(A0)		;409b8: 10bc0012
	MOVEA.L	(-16,A5),A0		;409bc: 206dfff0
	CMPI.W	#$0008,($C,A0)		;409c0: 0c680008000c
	BLT.S	LAB_409D0		;409c6: 6d08
	MOVEA.L	(-16,A5),A0		;409c8: 206dfff0
	CLR.W	($C,A0)			;409cc: 4268000c
; ------------------------------------------------------------------------------
; large number of lines cut
; ------------------------------------------------------------------------------
LAB_409D0:
	MOVEA.L	(-16,A5),A0		;409d0: 206dfff0
	BTST	#2,(A0)			;409d4: 08100002
	BEQ.S	LAB_409FE		;409d8: 6724
	MOVE.L	(-16,A5),-(A7)		;409da: 2f2dfff0
	JSR	(_set_frame,PC)		;409de: 4eba18f2
	ADDQ.W	#4,A7			;409e2: 584f
	TST.W	D0			;409e4: 4a40
	BEQ.S	LAB_409FA		;409e6: 6712
	MOVEA.L	(-16,A5),A0		;409e8: 206dfff0
	ANDI.B	#$fb,(A0)		;409ec: 021000fb
	MOVE.L	(-16,A5),-(A7)		;409f0: 2f2dfff0
	JSR	(_set_frame,PC)		;409f4: 4eba18dc
	ADDQ.W	#4,A7			;409f8: 584f
LAB_409FA:
	BRA.W	LAB_412D8		;409fa: 600008dc
LAB_409FE:
	MOVEA.L	(-16,A5),A0		;409fe: 206dfff0
	CMPI.B	#$01,(A0)		;40a02: 0c100001
	BNE.W	LAB_40FD2		;40a06: 660005ca
	MOVEA.L	(-16,A5),A0		;40a0a: 206dfff0
	MOVE.W	(8,A0),-(A7)		;40a0e: 3f280008
	MOVEA.L	(-16,A5),A0		;40a12: 206dfff0
	MOVEQ	#0,D0			;40a16: 7000
	MOVE.B	(1,A0),D0		;40a18: 10280001
	MOVE.W	D0,-(A7)		;40a1c: 3f00
	JSR	(___check_life,A4)	;40a1e: 4eac8182
	ADDQ.W	#4,A7			;40a22: 584f
	MOVE.W	D0,(-12,A5)		;40a24: 3b40fff4
	TST.W	D0			;40a28: 4a40
	BLE.S	LAB_40A3C		;40a2a: 6f10
	MOVEA.L	(-16,A5),A0		;40a2c: 206dfff0
	TST.L	($E,A0)			;40a30: 4aa8000e
	BNE.S	LAB_40A3C		;40a34: 6606
	TST.W	(_war,A4)		;40a36: 4a6cae80
	BEQ.S	LAB_40A6E		;40a3a: 6732
LAB_40A3C:
	MOVEA.L	(-16,A5),A0		;40a3c: 206dfff0
	ANDI.B	#$fe,(A0)		;40a40: 021000fe
	MOVEA.L	(-16,A5),A0		;40a44: 206dfff0
	BSET	#1,(A0)			;40a48: 08d00001
	MOVEA.L	(-16,A5),A0		;40a4c: 206dfff0
	CLR.W	($C,A0)			;40a50: 4268000c
	MOVEA.L	(-16,A5),A0		;40a54: 206dfff0
	CLR.W	($A,A0)			;40a58: 4268000a
	MOVE.W	#$0001,-(A7)		;40a5c: 3f3c0001
	MOVE.L	(-16,A5),-(A7)		;40a60: 2f2dfff0
	JSR	(_set_town,PC)		;40a64: 4eba19d6
	ADDQ.W	#6,A7			;40a68: 5c4f
	BRA.W	LAB_412F0		;40a6a: 60000884
LAB_40A6E:
	MOVEA.L	(-16,A5),A0		;40a6e: 206dfff0
	MOVE.W	($C,A0),(-46,A5)	;40a72: 3b68000cffd2
	CMPI.W	#$0bea,(-12,A5)		;40a78: 0c6d0beafff4
	BLT.S	LAB_40AA0		;40a7e: 6d20
	MOVEA.L	(-16,A5),A0		;40a80: 206dfff0
	MOVEQ	#0,D0			;40a84: 7000
	MOVE.B	(1,A0),D0		;40a86: 10280001
	ASL.L	#1,D0			;40a8a: e380
	LEA	(-40,A5),A0		;40a8c: 41edffd8
	ADDQ.W	#1,(0,A0,D0.L)		;40a90: 52700800
	MOVEA.L	(-16,A5),A0		;40a94: 206dfff0
	MOVE.W	#$002a,($C,A0)		;40a98: 317c002a000c
	BRA.S	LAB_40ACE		;40a9e: 602e
LAB_40AA0:
	MOVEA.L	(-16,A5),A0		;40aa0: 206dfff0
	MOVE.W	(-12,A5),D0		;40aa4: 302dfff4
	MULS	#$000a,D0		;40aa8: c1fc000a
	EXT.L	D0			;40aac: 48c0
	DIVS	#$0131,D0		;40aae: 81fc0131
	ADD.W	#$0020,D0		;40ab2: d07c0020
	MOVE.W	D0,($C,A0)		;40ab6: 3140000c
	MOVEA.L	(-16,A5),A0		;40aba: 206dfff0
	MOVEQ	#0,D0			;40abe: 7000
	MOVE.B	(1,A0),D0		;40ac0: 10280001
	ASL.L	#4,D0			;40ac4: e980
	LEA	(LAB_52DEA,A4),A0	;40ac6: 41ec99fc
	ADDQ.W	#1,(0,A0,D0.L)		;40aca: 52700800
LAB_40ACE:
	MOVEA.L	(-16,A5),A0		;40ace: 206dfff0
	MOVE.W	($C,A0),D0		;40ad2: 3028000c
	SUB.W	#$0020,D0		;40ad6: 907c0020
	MOVE.W	D0,(-10,A5)		;40ada: 3b40fff6
	MOVEA.L	(-16,A5),A0		;40ade: 206dfff0
	MOVE.W	(8,A0),D0		;40ae2: 30280008
	LEA	(_map_who,A4),A0	;40ae6: 41ec1f88
	TST.B	(0,A0,D0.W)		;40aea: 4a300000
	BNE.S	LAB_40B06		;40aee: 6616
	MOVE.W	(-2,A5),D0		;40af0: 302dfffe
	ADDQ.W	#1,D0			;40af4: 5240
	MOVEA.L	(-16,A5),A0		;40af6: 206dfff0
	MOVE.W	(8,A0),D1		;40afa: 32280008
	LEA	(_map_who,A4),A0	;40afe: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;40b02: 11801000
LAB_40B06:
	MOVEA.L	(-16,A5),A0		;40b06: 206dfff0
	MOVEQ	#0,D0			;40b0a: 7000
	MOVE.B	(1,A0),D0		;40b0c: 10280001
	ASL.L	#1,D0			;40b10: e380
	LEA	(-24,A5),A0		;40b12: 41edffe8
	MOVE.W	(0,A0,D0.L),D1		;40b16: 32300800
	CMP.W	(-12,A5),D1		;40b1a: b26dfff4
	BGE.S	LAB_40B54		;40b1e: 6c34
	MOVEA.L	(-16,A5),A0		;40b20: 206dfff0
	MOVEQ	#0,D0			;40b24: 7000
	MOVE.B	(1,A0),D0		;40b26: 10280001
	ASL.L	#1,D0			;40b2a: e380
	LEA	(-24,A5),A0		;40b2c: 41edffe8
	MOVE.W	(-12,A5),(0,A0,D0.L)	;40b30: 31adfff40800
	MOVEA.L	(-16,A5),A0		;40b36: 206dfff0
	TST.B	(1,A0)			;40b3a: 4a280001
	BNE.S	LAB_40B44		;40b3e: 6604
	MOVEQ	#1,D0			;40b40: 7001
	BRA.S	LAB_40B46		;40b42: 6002
LAB_40B44:
	MOVEQ	#0,D0			;40b44: 7000
LAB_40B46:
	MULS	#$002e,D0		;40b46: c1fc002e
	LEA	(LAB_516C6,A4),A0	;40b4a: 41ec82d8
	MOVE.L	(-16,A5),(0,A0,D0.L)	;40b4e: 21adfff00800
LAB_40B54:
	MOVEA.L	(-16,A5),A0		;40b54: 206dfff0
	MOVEQ	#0,D0			;40b58: 7000
	MOVE.B	(1,A0),D0		;40b5a: 10280001
	ASL.L	#1,D0			;40b5e: e380
	LEA	(-28,A5),A0		;40b60: 41edffe4
	MOVEA.L	(-16,A5),A1		;40b64: 226dfff0
	MOVE.W	(_game_turn,A4),D1	;40b68: 322cae6a
	SUB.W	(6,A1),D1		;40b6c: 92690006
	MOVE.W	(0,A0,D0.L),D2		;40b70: 34300800
	CMP.W	D1,D2			;40b74: b441
	BHI.S	LAB_40BB6		;40b76: 623e
	MOVEA.L	(-16,A5),A0		;40b78: 206dfff0
	MOVEQ	#0,D0			;40b7c: 7000
	MOVE.B	(1,A0),D0		;40b7e: 10280001
	ASL.L	#1,D0			;40b82: e380
	LEA	(-28,A5),A0		;40b84: 41edffe4
	MOVEA.L	(-16,A5),A1		;40b88: 226dfff0
	MOVE.W	(_game_turn,A4),D1	;40b8c: 322cae6a
	SUB.W	(6,A1),D1		;40b90: 92690006
	MOVE.W	D1,(0,A0,D0.L)		;40b94: 31810800
	MOVEA.L	(-16,A5),A0		;40b98: 206dfff0
	TST.B	(1,A0)			;40b9c: 4a280001
	BNE.S	LAB_40BA6		;40ba0: 6604
	MOVEQ	#1,D0			;40ba2: 7001
	BRA.S	LAB_40BA8		;40ba4: 6002
LAB_40BA6:
	MOVEQ	#0,D0			;40ba6: 7000
LAB_40BA8:
	MULS	#$002e,D0		;40ba8: c1fc002e
	LEA	(LAB_516CA,A4),A0	;40bac: 41ec82dc
	MOVE.L	(-16,A5),(0,A0,D0.L)	;40bb0: 21adfff00800
LAB_40BB6:
	MOVEA.L	(-16,A5),A0		;40bb6: 206dfff0
	MOVEQ	#0,D0			;40bba: 7000
	MOVE.B	(1,A0),D0		;40bbc: 10280001
	ASL.L	#1,D0			;40bc0: e380
	LEA	(-36,A5),A0		;40bc2: 41edffdc
	MOVEA.L	(-16,A5),A1		;40bc6: 226dfff0
	MOVE.W	(_game_turn,A4),D1	;40bca: 322cae6a
	SUB.W	(6,A1),D1		;40bce: 92690006
	MOVE.W	(0,A0,D0.L),D2		;40bd2: 34300800
	CMP.W	D1,D2			;40bd6: b441
	BLS.S	LAB_40C14		;40bd8: 633a
	MOVEA.L	(-16,A5),A0		;40bda: 206dfff0
	MOVEQ	#0,D0			;40bde: 7000
	MOVE.B	(1,A0),D0		;40be0: 10280001
	ASL.L	#1,D0			;40be4: e380
	LEA	(-36,A5),A0		;40be6: 41edffdc
	MOVEA.L	(-16,A5),A1		;40bea: 226dfff0
	MOVE.W	(_game_turn,A4),D1	;40bee: 322cae6a
	SUB.W	(6,A1),D1		;40bf2: 92690006
	MOVE.W	D1,(0,A0,D0.L)		;40bf6: 31810800
	MOVEA.L	(-16,A5),A0		;40bfa: 206dfff0
	MOVEQ	#0,D0			;40bfe: 7000
	MOVE.B	(1,A0),D0		;40c00: 10280001
	MOVEQ	#$2E,D1			;40c04: 722e
	JSR	(___mulu,A4)		;40c06: 4eac81c4
	LEA	(LAB_516CE,A4),A0	;40c0a: 41ec82e0
	MOVE.L	(-16,A5),(0,A0,D0.L)	;40c0e: 21adfff00800
LAB_40C14:
	MOVEA.L	(-16,A5),A0		;40c14: 206dfff0
	MOVEQ	#0,D0			;40c18: 7000
	MOVE.B	(1,A0),D0		;40c1a: 10280001
	MOVEQ	#$2E,D1			;40c1e: 722e
	JSR	(___mulu,A4)		;40c20: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;40c24: 41ec82be
	TST.W	(0,A0,D0.L)		;40c28: 4a700800
	BNE.W	LAB_40CBE		;40c2c: 66000090
	MOVEA.L	(-16,A5),A0		;40c30: 206dfff0
	MOVE.W	(8,A0),D0		;40c34: 30280008
	LEA	(_map_alt,A4),A0	;40c38: 41ecdf88
	TST.B	(0,A0,D0.W)		;40c3c: 4a300000
	BNE.S	LAB_40C84		;40c40: 6642
	MOVEA.L	(-16,A5),A0		;40c42: 206dfff0
	TST.B	($14,A0)		;40c46: 4a280014
	BEQ.S	LAB_40C60		;40c4a: 6714
	MOVEA.L	(-16,A5),A0		;40c4c: 206dfff0
	MOVE.W	($C,A0),D0		;40c50: 3028000c
	CMP.W	(-46,A5),D0		;40c54: b06dffd2
	BNE.S	LAB_40C60		;40c58: 6606
	TST.W	(_a_flat_block,A4)	;40c5a: 4a6c2fb2
	BEQ.S	LAB_40C82		;40c5e: 6722
LAB_40C60:
	MOVEA.L	(-16,A5),A0		;40c60: 206dfff0
	MOVEQ	#0,D0			;40c64: 7000
	MOVE.B	(1,A0),D0		;40c66: 10280001
	MOVE.W	D0,-(A7)		;40c6a: 3f00
	MOVEA.L	(-16,A5),A0		;40c6c: 206dfff0
	MOVE.W	(8,A0),-(A7)		;40c70: 3f280008
	JSR	(_make_level,PC)	;40c74: 4eba3d54
	ADDQ.W	#4,A7			;40c78: 584f
	MOVEA.L	(-16,A5),A0		;40c7a: 206dfff0
	MOVE.B	D0,($14,A0)		;40c7e: 11400014
LAB_40C82:
	BRA.S	LAB_40CBE		;40c82: 603a
LAB_40C84:
	MOVEA.L	(-16,A5),A0		;40c84: 206dfff0
	MOVEQ	#0,D0			;40c88: 7000
	MOVE.B	(1,A0),D0		;40c8a: 10280001
	ASL.L	#1,D0			;40c8e: e380
	LEA	(-32,A5),A0		;40c90: 41edffe0
	CMPI.W	#$0003,(0,A0,D0.L)	;40c94: 0c7000030800
	BGE.S	LAB_40CBE		;40c9a: 6c22
	CMPI.W	#$00fa,(_game_turn,A4)	;40c9c: 0c6c00faae6a
	BLS.S	LAB_40CBE		;40ca2: 631a
	MOVEA.L	(-16,A5),A0		;40ca4: 206dfff0
	MOVEQ	#0,D0			;40ca8: 7000
	MOVE.B	(1,A0),D0		;40caa: 10280001
	MOVE.W	D0,-(A7)		;40cae: 3f00
	MOVEA.L	(-16,A5),A0		;40cb0: 206dfff0
	MOVE.W	(8,A0),-(A7)		;40cb4: 3f280008
	JSR	(_make_level,PC)	;40cb8: 4eba3d10
	ADDQ.W	#4,A7			;40cbc: 584f
LAB_40CBE:
	MOVE.W	(_game_turn,A4),D0	;40cbe: 302cae6a
	AND.W	#$0007,D0		;40cc2: c07c0007
	BNE.W	LAB_40F58		;40cc6: 66000290
	MOVEA.L	(-16,A5),A0		;40cca: 206dfff0
	CMPI.W	#$002a,($C,A0)		;40cce: 0c68002a000c
	BNE.S	LAB_40D38		;40cd4: 6662
	MOVEA.L	(-16,A5),A0		;40cd6: 206dfff0
	MOVEQ	#0,D0			;40cda: 7000
	MOVE.B	(1,A0),D0		;40cdc: 10280001
	MOVEQ	#$2E,D1			;40ce0: 722e
	JSR	(___mulu,A4)		;40ce2: 4eac81c4
	LEA	(LAB_516AA,A4),A0	;40ce6: 41ec82bc
	CMPI.W	#$0001,(0,A0,D0.L)	;40cea: 0c7000010800
	BNE.S	LAB_40D38		;40cf0: 6646
	MOVEA.L	(-16,A5),A0		;40cf2: 206dfff0
	CMPI.W	#$0131,(4,A0)		;40cf6: 0c6801310004
	BLE.S	LAB_40D38		;40cfc: 6f3a
	MOVEA.L	(-16,A5),A0		;40cfe: 206dfff0
	MOVEQ	#0,D0			;40d02: 7000
	MOVE.B	(1,A0),D0		;40d04: 10280001
	MOVEQ	#$2E,D1			;40d08: 722e
	JSR	(___mulu,A4)		;40d0a: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;40d0e: 41ec82be
	TST.W	(0,A0,D0.L)		;40d12: 4a700800
	BNE.S	LAB_40D38		;40d16: 6620
	MOVE.W	#$0131,(-12,A5)		;40d18: 3b7c0131fff4
	MOVEA.L	(-16,A5),A0		;40d1e: 206dfff0
	MOVEQ	#0,D0			;40d22: 7000
	MOVE.B	(1,A0),D0		;40d24: 10280001
	MOVEQ	#$2E,D1			;40d28: 722e
	JSR	(___mulu,A4)		;40d2a: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;40d2e: 41ec82be
	MOVE.W	#$0001,(0,A0,D0.L)	;40d32: 31bc00010800
LAB_40D38:
	TST.W	(_cheat,A4)		;40d38: 4a6c2fb4
	BEQ.S	LAB_40D58		;40d3c: 671a
	MOVEA.L	(-16,A5),A0		;40d3e: 206dfff0
	MOVEQ	#0,D0			;40d42: 7000
	MOVE.B	(1,A0),D0		;40d44: 10280001
	MOVE.W	(_cheat,A4),D1		;40d48: 322c2fb4
	SUBQ.W	#1,D1			;40d4c: 5341
	CMP.W	D1,D0			;40d4e: b041
	BNE.S	LAB_40D58		;40d50: 6606
	MOVE.W	#$0032,(-12,A5)		;40d52: 3b7c0032fff4
LAB_40D58:
	MOVEA.L	(-16,A5),A0		;40d58: 206dfff0
	MOVEQ	#0,D0			;40d5c: 7000
	MOVE.B	(1,A0),D0		;40d5e: 10280001
	ASL.L	#4,D0			;40d62: e980
	LEA	(LAB_52DF0,A4),A0	;40d64: 41ec9a02
	ADDA.L	D0,A0			;40d68: d1c0
	MOVE.W	(-10,A5),D0		;40d6a: 302dfff6
	EXT.L	D0			;40d6e: 48c0
	ASL.L	#1,D0			;40d70: e380
	LEA	(_mana_add,A4),A1	;40d72: 43ec2fb6
	MOVE.W	(0,A1,D0.L),D1		;40d76: 32310800
	EXT.L	D1			;40d7a: 48c1
	ADD.L	D1,(A0)			;40d7c: d390
	MOVE.W	(-10,A5),D0		;40d7e: 302dfff6
	EXT.L	D0			;40d82: 48c0
	ASL.L	#1,D0			;40d84: e380
	LEA	(_weapons_add,A4),A0	;40d86: 41ec2fcc
	MOVEA.L	(-16,A5),A1		;40d8a: 226dfff0
	MOVE.B	(1,A0,D0.L),(3,A1)	;40d8e: 137008010003
	MOVEA.L	(-16,A5),A0		;40d94: 206dfff0
	MOVE.W	(4,A0),D0		;40d98: 30280004
	CMP.W	(-12,A5),D0		;40d9c: b06dfff4
	BLE.W	LAB_40F22		;40da0: 6f000180
	CLR.W	(-4,A5)			;40da4: 426dfffc
	LEA	(_peeps,A4),A0		;40da8: 41ec9c26
	MOVE.L	A0,(-20,A5)		;40dac: 2b48ffec
	BRA.W	LAB_40F18		;40db0: 60000166
LAB_40DB4:
	MOVEA.L	(-20,A5),A0		;40db4: 206dffec
	TST.W	(4,A0)			;40db8: 4a680004
	BGT.W	LAB_40F0C		;40dbc: 6e00014e
	MOVE.W	(-4,A5),D0		;40dc0: 302dfffc
	CMP.W	(_no_peeps,A4),D0	;40dc4: b06cae5e
	BLT.S	LAB_40DD4		;40dc8: 6d0a
	MOVE.W	(-4,A5),D0		;40dca: 302dfffc
	ADDQ.W	#1,D0			;40dce: 5240
	MOVE.W	D0,(_no_peeps,A4)	;40dd0: 3940ae5e
LAB_40DD4:
	MOVEA.L	(-20,A5),A0		;40dd4: 206dffec
	MOVEA.L	(-16,A5),A1		;40dd8: 226dfff0
	MOVE.W	(-12,A5),D0		;40ddc: 302dfff4
	ASR.W	#1,D0			;40de0: e240
	MOVE.W	(4,A1),D1		;40de2: 32290004
	SUB.W	D0,D1			;40de6: 9240
	MOVE.W	D1,(4,A0)		;40de8: 31410004
	MOVEA.L	(-16,A5),A0		;40dec: 206dfff0
	MOVE.W	(-12,A5),D0		;40df0: 302dfff4
	ASR.W	#1,D0			;40df4: e240
	MOVE.W	D0,(4,A0)		;40df6: 31400004
	MOVEA.L	(-16,A5),A0		;40dfa: 206dfff0
	MOVEQ	#0,D0			;40dfe: 7000
	MOVE.B	(1,A0),D0		;40e00: 10280001
	ASL.L	#4,D0			;40e04: e980
	LEA	(_magnet,A4),A0		;40e06: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;40e0a: 32300800
	SUBQ.W	#1,D1			;40e0e: 5341
	CMP.W	(-2,A5),D1		;40e10: b26dfffe
	BNE.S	LAB_40E30		;40e14: 661a
	MOVEA.L	(-16,A5),A0		;40e16: 206dfff0
	MOVEQ	#0,D0			;40e1a: 7000
	MOVE.B	(1,A0),D0		;40e1c: 10280001
	ASL.L	#4,D0			;40e20: e980
	LEA	(_magnet,A4),A0		;40e22: 41ec99f6
	MOVE.W	(-4,A5),D1		;40e26: 322dfffc
	ADDQ.W	#1,D1			;40e2a: 5241
	MOVE.W	D1,(0,A0,D0.L)		;40e2c: 31810800
LAB_40E30:
	MOVE.W	(_view_who,A4),D0	;40e30: 302cae68
	SUBQ.W	#1,D0			;40e34: 5340
	CMP.W	(-2,A5),D0		;40e36: b06dfffe
	BNE.S	LAB_40E46		;40e3a: 660a
	MOVE.W	(-4,A5),D0		;40e3c: 302dfffc
	ADDQ.W	#1,D0			;40e40: 5240
	MOVE.W	D0,(_view_who,A4)	;40e42: 3940ae68
LAB_40E46:
	MOVEA.L	(-16,A5),A0		;40e46: 206dfff0
	MOVEA.L	(-20,A5),A1		;40e4a: 226dffec
	MOVE.B	(2,A0),(2,A1)		;40e4e: 136800020002
	MOVEA.L	(-16,A5),A0		;40e54: 206dfff0
	MOVEA.L	(-20,A5),A1		;40e58: 226dffec
	MOVE.W	(8,A0),(8,A1)		;40e5c: 336800080008
	MOVEA.L	(-20,A5),A0		;40e62: 206dffec
	MOVE.B	#$02,(A0)		;40e66: 10bc0002
	MOVEA.L	(-16,A5),A0		;40e6a: 206dfff0
	MOVEA.L	(-20,A5),A1		;40e6e: 226dffec
	MOVE.B	(1,A0),(1,A1)		;40e72: 136800010001
	MOVEA.L	(-20,A5),A0		;40e78: 206dffec
	CLR.W	($A,A0)			;40e7c: 4268000a
	MOVEA.L	(-20,A5),A0		;40e80: 206dffec
	CLR.W	($C,A0)			;40e84: 4268000c
	MOVEA.L	(-16,A5),A0		;40e88: 206dfff0
	MOVEA.L	(-20,A5),A1		;40e8c: 226dffec
	MOVE.B	(3,A0),(3,A1)		;40e90: 136800030003
	MOVEA.L	(-20,A5),A0		;40e96: 206dffec
	CLR.L	($E,A0)			;40e9a: 42a8000e
	MOVEA.L	(-16,A5),A0		;40e9e: 206dfff0
	MOVEA.L	(-20,A5),A1		;40ea2: 226dffec
	MOVE.W	(8,A0),($12,A1)		;40ea6: 336800080012
	MOVEA.L	(-20,A5),A0		;40eac: 206dffec
	CLR.B	($14,A0)		;40eb0: 42280014
	MOVEA.L	(-20,A5),A0		;40eb4: 206dffec
	MOVE.W	(8,A0),D0		;40eb8: 30280008
	LEA	(_map_who,A4),A0	;40ebc: 41ec1f88
	MOVEQ	#0,D1			;40ec0: 7200
	MOVE.B	(0,A0,D0.W),D1		;40ec2: 12300000
	SUBQ.W	#1,D1			;40ec6: 5341
	CMP.W	(-2,A5),D1		;40ec8: b26dfffe
	BEQ.S	LAB_40EE0		;40ecc: 6712
	MOVEA.L	(-20,A5),A0		;40ece: 206dffec
	MOVE.W	(8,A0),D0		;40ed2: 30280008
	LEA	(_map_who,A4),A0	;40ed6: 41ec1f88
	TST.B	(0,A0,D0.W)		;40eda: 4a300000
	BNE.S	LAB_40EF6		;40ede: 6616
LAB_40EE0:
	MOVE.W	(-4,A5),D0		;40ee0: 302dfffc
	ADDQ.W	#1,D0			;40ee4: 5240
	MOVEA.L	(-20,A5),A0		;40ee6: 206dffec
	MOVE.W	(8,A0),D1		;40eea: 32280008
	LEA	(_map_who,A4),A0	;40eee: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;40ef2: 11801000
LAB_40EF6:
	MOVEA.L	(-16,A5),A0		;40ef6: 206dfff0
	CMPI.B	#$04,(2,A0)		;40efa: 0c2800040002
	BCC.S	LAB_40F0A		;40f00: 6408
	MOVEA.L	(-16,A5),A0		;40f02: 206dfff0
	ADDQ.B	#1,(2,A0)		;40f06: 52280002
LAB_40F0A:
	BRA.S	LAB_40F22		;40f0a: 6016
LAB_40F0C:
	ADDQ.W	#1,(-4,A5)		;40f0c: 526dfffc
	ADDI.L	#$00000016,(-20,A5)	;40f10: 06ad00000016ffec
LAB_40F18:
	CMPI.W	#$00d0,(-4,A5)		;40f18: 0c6d00d0fffc
	BLT.W	LAB_40DB4		;40f1e: 6d00fe94
LAB_40F22:
	CMPI.W	#$00d0,(-4,A5)		;40f22: 0c6d00d0fffc
	BNE.S	LAB_40F40		;40f28: 6616
	TST.W	(_funny_done,A4)	;40f2a: 4a6cae70
	BNE.S	LAB_40F40		;40f2e: 6610
	MOVE.W	#$0001,-(A7)		;40f30: 3f3c0001
	JSR	(_do_place_funny,PC)	;40f34: 4eba38bc
	ADDQ.W	#2,A7			;40f38: 544f
	MOVE.W	#$0001,(_funny_done,A4)	;40f3a: 397c0001ae70
LAB_40F40:
	MOVEA.L	(-16,A5),A0		;40f40: 206dfff0
	MOVE.W	(-10,A5),D0		;40f44: 302dfff6
	EXT.L	D0			;40f48: 48c0
	ASL.L	#1,D0			;40f4a: e380
	LEA	(_population_add,A4),A1	;40f4c: 43ec2fe2
	MOVE.W	(0,A1,D0.L),D1		;40f50: 32310800
	ADD.W	D1,(4,A0)		;40f54: d3680004
LAB_40F58:
	TST.W	(_toggle,A4)		;40f58: 4a6c9a1a
	BNE.S	LAB_40F9A		;40f5c: 663c
	MOVEA.L	(-16,A5),A0		;40f5e: 206dfff0
	MOVEQ	#0,D0			;40f62: 7000
	MOVE.B	(1,A0),D0		;40f64: 10280001
	CMP.W	(_player,A4),D0		;40f68: b06c99f4
	BEQ.S	LAB_40F74		;40f6c: 6706
	TST.W	(_serial_off,A4)	;40f6e: 4a6c8254
	BEQ.S	LAB_40F9A		;40f72: 6726
LAB_40F74:
	MOVEA.L	(-16,A5),A0		;40f74: 206dfff0
	MOVEQ	#0,D0			;40f78: 7000
	MOVE.B	(1,A0),D0		;40f7a: 10280001
	MOVEQ	#$2E,D1			;40f7e: 722e
	JSR	(___mulu,A4)		;40f80: 4eac81c4
	LEA	(LAB_516C4,A4),A0	;40f84: 41ec82d6
	MOVE.W	(0,A0,D0.L),-(A7)	;40f88: 3f300800
	MOVEA.L	(-16,A5),A0		;40f8c: 206dfff0
	MOVE.W	(8,A0),-(A7)		;40f90: 3f280008
	JSR	(___a_putpixel,A4)	;40f94: 4eac80ce
	ADDQ.W	#4,A7			;40f98: 584f
LAB_40F9A:
	MOVEA.L	(-16,A5),A0		;40f9a: 206dfff0
	MOVE.W	($C,A0),D0		;40f9e: 3028000c
	CMP.W	(-46,A5),D0		;40fa2: b06dffd2
	BNE.S	LAB_40FC2		;40fa6: 661a
	TST.W	(_a_flat_block,A4)	;40fa8: 4a6c2fb2
	BNE.S	LAB_40FC2		;40fac: 6614
	MOVEA.L	(-16,A5),A0		;40fae: 206dfff0
	CMPI.W	#$002a,($C,A0)		;40fb2: 0c68002a000c
	BNE.S	LAB_40FCE		;40fb8: 6614
	CMPI.W	#$0009,(_all_of_city,A4) ;40fba: 0c6c00092ff8
	BGE.S	LAB_40FCE		;40fc0: 6c0c
LAB_40FC2:
	CLR.W	-(A7)			;40fc2: 4267
	MOVE.L	(-16,A5),-(A7)		;40fc4: 2f2dfff0
	JSR	(_set_town,PC)		;40fc8: 4eba1472
	ADDQ.W	#6,A7			;40fcc: 5c4f
LAB_40FCE:
	BRA.W	LAB_412D8		;40fce: 60000308
LAB_40FD2:
	MOVEA.L	(-16,A5),A0		;40fd2: 206dfff0
	CMPI.B	#$02,(A0)		;40fd6: 0c100002
	BNE.W	LAB_411C0		;40fda: 660001e4
	MOVEA.L	(-16,A5),A0		;40fde: 206dfff0
	TST.W	(4,A0)			;40fe2: 4a680004
	BLE.W	LAB_411BC		;40fe6: 6f0001d4
	MOVE.L	(-16,A5),-(A7)		;40fea: 2f2dfff0
	JSR	(_set_frame,PC)		;40fee: 4eba12e2
	ADDQ.W	#4,A7			;40ff2: 584f
	TST.W	D0			;40ff4: 4a40
	BEQ.W	LAB_410E2		;40ff6: 670000ea
	MOVEA.L	(-8,A5),A0		;40ffa: 206dfff8
	CMPI.B	#$35,(A0)		;40ffe: 0c100035
	BNE.S	LAB_4102C		;41002: 6628
	MOVE.W	(-2,A5),-(A7)		;41004: 3f2dfffe
	MOVE.L	(-16,A5),-(A7)		;41008: 2f2dfff0
	JSR	(_zero_population,PC)	;4100c: 4eba11e6
	ADDQ.W	#6,A7			;41010: 5c4f
	MOVE.W	#$0042,(_effect,A4)	;41012: 397c00422fac
	BTST	#1,(LAB_518A7,A4)	;41018: 082c000184b9
	BNE.S	LAB_41028		;4101e: 6608
	MOVEA.L	(-8,A5),A0		;41020: 206dfff8
	MOVE.B	#$0f,(A0)		;41024: 10bc000f
LAB_41028:
	BRA.W	LAB_412F0		;41028: 600002c6
LAB_4102C:
	MOVEA.L	(-16,A5),A0		;4102c: 206dfff0
	TST.B	(1,A0)			;41030: 4a280001
	BNE.S	LAB_4103A		;41034: 6604
	MOVEQ	#1,D0			;41036: 7001
	BRA.S	LAB_4103C		;41038: 6002
LAB_4103A:
	MOVEQ	#0,D0			;4103a: 7000
LAB_4103C:
	MULS	#$002e,D0		;4103c: c1fc002e
	LEA	(LAB_516CA,A4),A0	;41040: 41ec82dc
	TST.L	(0,A0,D0.L)		;41044: 4ab00800
	BNE.S	LAB_41068		;41048: 661e
	MOVEA.L	(-16,A5),A0		;4104a: 206dfff0
	TST.B	(1,A0)			;4104e: 4a280001
	BNE.S	LAB_41058		;41052: 6604
	MOVEQ	#1,D0			;41054: 7001
	BRA.S	LAB_4105A		;41056: 6002
LAB_41058:
	MOVEQ	#0,D0			;41058: 7000
LAB_4105A:
	MULS	#$002e,D0		;4105a: c1fc002e
	LEA	(LAB_516CA,A4),A0	;4105e: 41ec82dc
	MOVE.L	(-16,A5),(0,A0,D0.L)	;41062: 21adfff00800
LAB_41068:
	MOVEA.L	(-16,A5),A0		;41068: 206dfff0
	MOVEQ	#0,D0			;4106c: 7000
	MOVE.B	(1,A0),D0		;4106e: 10280001
	MOVEQ	#$2E,D1			;41072: 722e
	JSR	(___mulu,A4)		;41074: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;41078: 41ec82be
	TST.W	(0,A0,D0.L)		;4107c: 4a700800
	BNE.S	LAB_4109C		;41080: 661a
	MOVEA.L	(-16,A5),A0		;41082: 206dfff0
	MOVEQ	#0,D0			;41086: 7000
	MOVE.B	(1,A0),D0		;41088: 10280001
	MOVE.W	D0,-(A7)		;4108c: 3f00
	MOVEA.L	(-16,A5),A0		;4108e: 206dfff0
	MOVE.W	(8,A0),-(A7)		;41092: 3f280008
	JSR	(_one_block_flat,PC)	;41096: 4eba3ae0
	ADDQ.W	#4,A7			;4109a: 584f
LAB_4109C:
	MOVE.W	(-2,A5),-(A7)		;4109c: 3f2dfffe
	MOVE.L	(-16,A5),-(A7)		;410a0: 2f2dfff0
	JSR	(_move_explorer,PC)	;410a4: 4eba0324
	ADDQ.W	#6,A7			;410a8: 5c4f
	MOVEA.L	(-16,A5),A0		;410aa: 206dfff0
	TST.W	($12,A0)		;410ae: 4a680012
	BEQ.S	LAB_410D6		;410b2: 6722
	MOVEA.L	(-16,A5),A0		;410b4: 206dfff0
	MOVEA.L	(-16,A5),A1		;410b8: 226dfff0
	MOVE.W	(8,A0),D0		;410bc: 30280008
	SUB.W	($A,A1),D0		;410c0: 9069000a
	MOVEA.L	(-16,A5),A0		;410c4: 206dfff0
	CMP.W	($12,A0),D0		;410c8: b0680012
	BEQ.S	LAB_410D6		;410cc: 6708
	MOVEA.L	(-16,A5),A0		;410ce: 206dfff0
	CLR.W	($12,A0)		;410d2: 42680012
LAB_410D6:
	MOVEA.L	(-16,A5),A0		;410d6: 206dfff0
	MOVE.W	(_walk_death,A4),D0	;410da: 302c2fb0
	SUB.W	D0,(4,A0)		;410de: 91680004
LAB_410E2:
	MOVEA.L	(-16,A5),A0		;410e2: 206dfff0
	TST.W	(4,A0)			;410e6: 4a680004
	BLE.W	LAB_411BC		;410ea: 6f0000d0
	MOVEA.L	(-16,A5),A0		;410ee: 206dfff0
	MOVE.W	(8,A0),D0		;410f2: 30280008
	LEA	(_map_who,A4),A0	;410f6: 41ec1f88
	MOVEQ	#0,D1			;410fa: 7200
	MOVE.B	(0,A0,D0.W),D1		;410fc: 12300000
	SUBQ.W	#1,D1			;41100: 5341
	MOVE.W	D1,(-4,A5)		;41102: 3b41fffc
	MOVE.W	(-4,A5),D0		;41106: 302dfffc
	CMP.W	(-2,A5),D0		;4110a: b06dfffe
	BEQ.S	LAB_4117A		;4110e: 676a
	CMPI.W	#$ffff,(-4,A5)		;41110: 0c6dfffffffc
	BEQ.S	LAB_4117A		;41116: 6762
	MOVE.W	(-4,A5),D0		;41118: 302dfffc
	MULS	#$0016,D0		;4111c: c1fc0016
	LEA	(LAB_53020,A4),A0	;41120: 41ec9c32
	TST.W	(0,A0,D0.L)		;41124: 4a700800
	BNE.S	LAB_4117A		;41128: 6650
	CMPI.W	#$00d0,(-4,A5)		;4112a: 0c6d00d0fffc
	BGE.S	LAB_4117A		;41130: 6c48
	MOVE.W	(-4,A5),D0		;41132: 302dfffc
	MULS	#$0016,D0		;41136: c1fc0016
	LEA	(_peeps,A4),A0		;4113a: 41ec9c26
	BTST	#4,(0,A0,D0.L)		;4113e: 083000040800
	BNE.S	LAB_4117A		;41144: 6634
	MOVE.W	(-4,A5),D0		;41146: 302dfffc
	MULS	#$0016,D0		;4114a: c1fc0016
	LEA	(_peeps,A4),A0		;4114e: 41ec9c26
	ADDA.L	D0,A0			;41152: d1c0
	BSET	#5,(A0)			;41154: 08d00005
	MOVE.W	(-4,A5),D0		;41158: 302dfffc
	MULS	#$0016,D0		;4115c: c1fc0016
	LEA	(LAB_53020,A4),A0	;41160: 41ec9c32
	MOVE.W	#$0065,(0,A0,D0.L)	;41164: 31bc00650800
	MOVE.W	(-4,A5),D0		;4116a: 302dfffc
	MULS	#$0016,D0		;4116e: c1fc0016
	LEA	(LAB_5301A,A4),A0	;41172: 41ec9c2c
	CLR.W	(0,A0,D0.L)		;41176: 42700800
LAB_4117A:
	TST.W	(_toggle,A4)		;4117a: 4a6c9a1a
	BEQ.S	LAB_411BC		;4117e: 673c
	MOVEA.L	(-16,A5),A0		;41180: 206dfff0
	MOVEQ	#0,D0			;41184: 7000
	MOVE.B	(1,A0),D0		;41186: 10280001
	CMP.W	(_player,A4),D0		;4118a: b06c99f4
	BEQ.S	LAB_41196		;4118e: 6706
	TST.W	(_serial_off,A4)	;41190: 4a6c8254
	BEQ.S	LAB_411BC		;41194: 6726
LAB_41196:
	MOVEA.L	(-16,A5),A0		;41196: 206dfff0
	TST.B	(1,A0)			;4119a: 4a280001
	BNE.S	LAB_411A4		;4119e: 6604
	MOVEQ	#1,D0			;411a0: 7001
	BRA.S	LAB_411A6		;411a2: 6002
LAB_411A4:
	MOVEQ	#0,D0			;411a4: 7000
LAB_411A6:
	MULS	#$0007,D0		;411a6: c1fc0007
	ADDQ.W	#8,D0			;411aa: 5040
	MOVE.W	D0,-(A7)		;411ac: 3f00
	MOVEA.L	(-16,A5),A0		;411ae: 206dfff0
	MOVE.W	(8,A0),-(A7)		;411b2: 3f280008
	JSR	(___a_putpixel,A4)	;411b6: 4eac80ce
	ADDQ.W	#4,A7			;411ba: 584f
LAB_411BC:
	BRA.W	LAB_412D8		;411bc: 6000011a
LAB_411C0:
	MOVEA.L	(-16,A5),A0		;411c0: 206dfff0
	MOVE.B	(A0),D0			;411c4: 1010
	AND.B	#$60,D0			;411c6: c03c0060
	BEQ.W	LAB_41264		;411ca: 67000098
	MOVE.L	(-16,A5),-(A7)		;411ce: 2f2dfff0
	JSR	(_set_frame,PC)		;411d2: 4eba10fe
	ADDQ.W	#4,A7			;411d6: 584f
	TST.W	(_toggle,A4)		;411d8: 4a6c9a1a
	BEQ.S	LAB_4121A		;411dc: 673c
	MOVEA.L	(-16,A5),A0		;411de: 206dfff0
	MOVEQ	#0,D0			;411e2: 7000
	MOVE.B	(1,A0),D0		;411e4: 10280001
	CMP.W	(_player,A4),D0		;411e8: b06c99f4
	BEQ.S	LAB_411F4		;411ec: 6706
	TST.W	(_serial_off,A4)	;411ee: 4a6c8254
	BEQ.S	LAB_4121A		;411f2: 6726
LAB_411F4:
	MOVEA.L	(-16,A5),A0		;411f4: 206dfff0
	TST.B	(1,A0)			;411f8: 4a280001
	BNE.S	LAB_41202		;411fc: 6604
	MOVEQ	#1,D0			;411fe: 7001
	BRA.S	LAB_41204		;41200: 6002
LAB_41202:
	MOVEQ	#0,D0			;41202: 7000
LAB_41204:
	MULS	#$0007,D0		;41204: c1fc0007
	ADDQ.W	#8,D0			;41208: 5040
	MOVE.W	D0,-(A7)		;4120a: 3f00
	MOVEA.L	(-16,A5),A0		;4120c: 206dfff0
	MOVE.W	(8,A0),-(A7)		;41210: 3f280008
	JSR	(___a_putpixel,A4)	;41214: 4eac80ce
	ADDQ.W	#4,A7			;41218: 584f
LAB_4121A:
	MOVEA.L	(-16,A5),A0		;4121a: 206dfff0
	MOVE.W	(_walk_death,A4),D0	;4121e: 302c2fb0
	SUB.W	D0,(4,A0)		;41222: 91680004
	MOVEA.L	(-16,A5),A0		;41226: 206dfff0
	MOVE.W	(6,A0),D0		;4122a: 30280006
	ADDQ.W	#1,(6,A0)		;4122e: 52680006
	CMP.W	#$000e,D0		;41232: b07c000e
	BLS.S	LAB_41262		;41236: 632a
	MOVEA.L	(-16,A5),A0		;41238: 206dfff0
	ANDI.B	#$9f,(A0)		;4123c: 0210009f
	MOVE.L	(-16,A5),-(A7)		;41240: 2f2dfff0
	JSR	(_set_frame,PC)		;41244: 4eba108c
	ADDQ.W	#4,A7			;41248: 584f
	MOVEA.L	(-16,A5),A0		;4124a: 206dfff0
	CMPI.B	#$02,(A0)		;4124e: 0c100002
	BNE.S	LAB_41262		;41252: 660e
	MOVE.W	(-2,A5),-(A7)		;41254: 3f2dfffe
	MOVE.L	(-16,A5),-(A7)		;41258: 2f2dfff0
	JSR	(_move_explorer,PC)	;4125c: 4eba016c
	ADDQ.W	#6,A7			;41260: 5c4f
LAB_41262:
	BRA.S	LAB_412D8		;41262: 6074
LAB_41264:
	MOVEA.L	(-16,A5),A0		;41264: 206dfff0
	BTST	#3,(A0)			;41268: 08100003
	BEQ.S	LAB_4128A		;4126c: 671c
	MOVEA.L	(-16,A5),A0		;4126e: 206dfff0
	CMPI.B	#$08,(A0)		;41272: 0c100008
	BNE.S	LAB_41288		;41276: 6610
	MOVE.W	(-2,A5),-(A7)		;41278: 3f2dfffe
	MOVE.L	(-16,A5),-(A7)		;4127c: 2f2dfff0
	JSR	(_do_battle,PC)		;41280: 4eba1408
	ADDQ.W	#6,A7			;41284: 5c4f
	BRA.S	LAB_412F0		;41286: 6068
LAB_41288:
	BRA.S	LAB_412D8		;41288: 604e
LAB_4128A:
	MOVEA.L	(-16,A5),A0		;4128a: 206dfff0
	MOVEQ	#0,D0			;4128e: 7000
	MOVE.B	(A0),D0			;41290: 1010
	BTST	#7,D0			;41292: 08000007
	BEQ.S	LAB_412D8		;41296: 6740
	MOVEA.L	(-16,A5),A0		;41298: 206dfff0
	MOVE.W	(8,A0),D0		;4129c: 30280008
	LEA	(_map_who,A4),A0	;412a0: 41ec1f88
	TST.B	(0,A0,D0.W)		;412a4: 4a300000
	BNE.S	LAB_412C0		;412a8: 6616
	MOVE.W	(-2,A5),D0		;412aa: 302dfffe
	ADDQ.W	#1,D0			;412ae: 5240
	MOVEA.L	(-16,A5),A0		;412b0: 206dfff0
	MOVE.W	(8,A0),D1		;412b4: 32280008
	LEA	(_map_who,A4),A0	;412b8: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;412bc: 11801000
LAB_412C0:
	MOVEA.L	(-16,A5),A0		;412c0: 206dfff0
	MOVE.W	(6,A0),D0		;412c4: 30280006
	SUBQ.W	#1,(6,A0)		;412c8: 53680006
	TST.W	D0			;412cc: 4a40
	BHI.S	LAB_412D8		;412ce: 6208
	MOVEA.L	(-16,A5),A0		;412d0: 206dfff0
	CLR.W	(4,A0)			;412d4: 42680004
LAB_412D8:
	MOVEA.L	(-16,A5),A0		;412d8: 206dfff0
	TST.W	(4,A0)			;412dc: 4a680004
	BGT.S	LAB_412F0		;412e0: 6e0e
	MOVE.W	(-2,A5),-(A7)		;412e2: 3f2dfffe
	MOVE.L	(-16,A5),-(A7)		;412e6: 2f2dfff0
	JSR	(_zero_population,PC)	;412ea: 4eba0f08
	ADDQ.W	#6,A7			;412ee: 5c4f
; ------------------------------------------------------------------------------
; lines cut
; ------------------------------------------------------------------------------
LAB_412F0:
	ADDI.L	#$00000016,(-16,A5)	;412f0: 06ad00000016fff0
	ADDQ.W	#1,(-2,A5)		;412f8: 526dfffe
	BRA.W	LAB_40846		;412fc: 6000f548
LAB_41300:
	MOVE.W	(_player,A4),D0		;41300: 302c99f4
	EXT.L	D0			;41304: 48c0
	ASL.L	#4,D0			;41306: e980
	LEA	(good_pop,A4),A0	;41308: 41ec99fe
	TST.L	(0,A0,D0.L)		;4130c: 4ab00800
	BEQ.S	LAB_4131C		;41310: 670a
	MOVE.W	(_player,A4),D0		;41312: 302c99f4
	CMP.W	(_surender,A4),D0	;41316: b06c8258
	BNE.S	LAB_41328		;4131a: 660c
LAB_4131C:
	MOVE.W	#$0001,-(A7)		;4131c: 3f3c0001
	JSR	(___end_game,A4)	;41320: 4eac8092
	ADDQ.W	#2,A7			;41324: 544f
	BRA.S	LAB_4134C		;41326: 6024
LAB_41328:
	MOVE.W	(_not_player,A4),D0	;41328: 302c825a
	EXT.L	D0			;4132c: 48c0
	ASL.L	#4,D0			;4132e: e980
	LEA	(good_pop,A4),A0	;41330: 41ec99fe
	TST.L	(0,A0,D0.L)		;41334: 4ab00800
	BEQ.S	LAB_41344		;41338: 670a
	MOVE.W	(_not_player,A4),D0	;4133a: 302c825a
	CMP.W	(_surender,A4),D0	;4133e: b06c8258
	BNE.S	LAB_4134C		;41342: 6608
LAB_41344:
	CLR.W	-(A7)			;41344: 4267
	JSR	(___end_game,A4)	;41346: 4eac8092
	ADDQ.W	#2,A7			;4134a: 544f
LAB_4134C:
	CLR.W	(-2,A5)			;4134c: 426dfffe
LAB_41350:
	MOVE.W	(-2,A5),D0		;41350: 302dfffe
	EXT.L	D0			;41354: 48c0
	ASL.L	#4,D0			;41356: e980
	LEA	(LAB_52DEA,A4),A0	;41358: 41ec99fc
	MOVE.W	(-2,A5),D1		;4135c: 322dfffe
	MULS	#$002e,D1		;41360: c3fc002e
	LEA	(good_towns,A4),A1	;41364: 43ec82cc
	MOVE.W	(0,A0,D0.L),(0,A1,D1.L)	;41368: 33b008001800
	MOVE.W	(-2,A5),D0		;4136e: 302dfffe
	EXT.L	D0			;41372: 48c0
	ASL.L	#1,D0			;41374: e380
	LEA	(-40,A5),A0		;41376: 41edffd8
	MOVE.W	(-2,A5),D1		;4137a: 322dfffe
	MULS	#$002e,D1		;4137e: c3fc002e
	LEA	(good_castles,A4),A1	;41382: 43ec82ca
	MOVE.W	(0,A0,D0.L),(0,A1,D1.L)	;41386: 33b008001800
	ADDQ.W	#1,(-2,A5)		;4138c: 526dfffe
	CMPI.W	#$0002,(-2,A5)		;41390: 0c6d0002fffe
	BLT.S	LAB_41350		;41396: 6db8
	MOVE.W	(_game_turn,A4),D0	;41398: 302cae6a
	AND.W	#$0007,D0		;4139c: c07c0007
	BNE.S	LAB_413C0		;413a0: 661e
; cheat notification every 8 days
	TST.W	(_cheat,A4)		;413a2: 4a6c2fb4
	BEQ.S	LAB_413BC		;413a6: 6714
	PEA	(strCHEAT2,PC)		;413a8: 487a001a
	CLR.W	-(A7)			;413ac: 4267
	CLR.W	-(A7)			;413ae: 4267
	MOVE.L	(_w_screen,A4),-(A7)	;413b0: 2f2c99e8
	JSR	(___text,A4)		;413b4: 4eac813a
	LEA	($C,A7),A7		;413b8: 4fef000c
LAB_413BC:
	CLR.W	(_cheat,A4)		;413bc: 426c2fb4
LAB_413C0:
	UNLK	A5			;413c0: 4e5d
	RTS				;413c2: 4e75
strCHEAT2:
	;413c4
	;DC.B	$43,$48,$45,$41,$54,$00
	DC.B	"CHEAT",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_move_explorer:
	LINK.W	A5,#-8			;413ca: 4e55fff8
	MOVEA.L	(8,A5),A0		;413ce: 206d0008
	MOVEQ	#0,D0			;413d2: 7000
	MOVE.B	(1,A0),D0		;413d4: 10280001
	ASL.L	#4,D0			;413d8: e980
	LEA	(LAB_52DE8,A4),A0	;413da: 41ec99fa
	TST.W	(0,A0,D0.L)		;413de: 4a700800
	BEQ.S	LAB_413F4		;413e2: 6710
	MOVEA.L	(8,A5),A0		;413e4: 206d0008
	TST.L	($E,A0)			;413e8: 4aa8000e
	BNE.S	LAB_413F4		;413ec: 6606
	TST.W	(_war,A4)		;413ee: 4a6cae80
	BEQ.S	LAB_41408		;413f2: 6714
LAB_413F4:
	MOVE.W	($C,A5),-(A7)		;413f4: 3f2d000c
	MOVE.L	(8,A5),-(A7)		;413f8: 2f2d0008
	JSR	(_move_magnet_peeps,PC)	;413fc: 4eba05d6
	ADDQ.W	#6,A7			;41400: 5c4f
	MOVE.W	D0,(-8,A5)		;41402: 3b40fff8
	BRA.S	LAB_4141A		;41406: 6012
LAB_41408:
	MOVE.W	($C,A5),-(A7)		;41408: 3f2d000c
	MOVE.L	(8,A5),-(A7)		;4140c: 2f2d0008
	JSR	(_where_do_i_go,PC)	;41410: 4eba028e
	ADDQ.W	#6,A7			;41414: 5c4f
	MOVE.W	D0,(-8,A5)		;41416: 3b40fff8
LAB_4141A:
	CMPI.W	#$03e7,(-8,A5)		;4141a: 0c6d03e7fff8
	BNE.S	LAB_41438		;41420: 6616
	MOVEA.L	(8,A5),A0		;41422: 206d0008
	BSET	#6,(A0)			;41426: 08d00006
	MOVEA.L	(8,A5),A0		;4142a: 206d0008
	MOVE.W	#$0007,(6,A0)		;4142e: 317c00070006
LAB_41434:
	UNLK	A5			;41434: 4e5d
	RTS				;41436: 4e75
LAB_41438:
	MOVEA.L	(8,A5),A0		;41438: 206d0008
	ANDI.B	#$bf,(A0)		;4143c: 021000bf
	MOVEA.L	(8,A5),A0		;41440: 206d0008
	MOVE.W	(8,A0),D0		;41444: 30280008
	MOVEA.L	(8,A5),A0		;41448: 206d0008
	SUB.W	($A,A0),D0		;4144c: 9068000a
	LEA	(_map_who,A4),A0	;41450: 41ec1f88
	MOVEQ	#0,D1			;41454: 7200
	MOVE.B	(0,A0,D0.W),D1		;41456: 12300000
	SUBQ.W	#1,D1			;4145a: 5341
	CMP.W	($C,A5),D1		;4145c: b26d000c
	BNE.S	LAB_4147A		;41460: 6618
	MOVEA.L	(8,A5),A0		;41462: 206d0008
	MOVE.W	(8,A0),D0		;41466: 30280008
	MOVEA.L	(8,A5),A0		;4146a: 206d0008
	SUB.W	($A,A0),D0		;4146e: 9068000a
	LEA	(_map_who,A4),A0	;41472: 41ec1f88
	CLR.B	(0,A0,D0.W)		;41476: 42300000
LAB_4147A:
	MOVEA.L	(8,A5),A0		;4147a: 206d0008
	MOVEQ	#0,D0			;4147e: 7000
	MOVE.B	(1,A0),D0		;41480: 10280001
	MOVEQ	#$2E,D1			;41484: 722e
	JSR	(___mulu,A4)		;41486: 4eac81c4
	LEA	(LAB_516AA,A4),A0	;4148a: 41ec82bc
	CMPI.W	#$0001,(0,A0,D0.L)	;4148e: 0c7000010800
	BNE.W	LAB_4153A		;41494: 660000a4
	MOVEA.L	(8,A5),A0		;41498: 206d0008
	MOVE.W	(8,A0),D0		;4149c: 30280008
	LEA	(_map_blk,A4),A0	;414a0: 41eccf88
	CMPI.B	#$42,(0,A0,D0.W)	;414a4: 0c3000420000
	BNE.W	LAB_4153A		;414aa: 6600008e
	MOVEA.L	(8,A5),A0		;414ae: 206d0008
	MOVEQ	#0,D0			;414b2: 7000
	MOVE.B	(1,A0),D0		;414b4: 10280001
	MOVEQ	#$2E,D1			;414b8: 722e
	JSR	(___mulu,A4)		;414ba: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;414be: 41ec82be
	TST.W	(0,A0,D0.L)		;414c2: 4a700800
	BNE.S	LAB_4153A		;414c6: 6672
	MOVE.W	(_game_mode,A4),D0	;414c8: 302c84b8
	AND.W	#$000c,D0		;414cc: c07c000c
	BNE.S	LAB_4153A		;414d0: 6668
	MOVEA.L	(8,A5),A0		;414d2: 206d0008
	MOVEQ	#0,D0			;414d6: 7000
	MOVE.B	(1,A0),D0		;414d8: 10280001
	MOVEQ	#$2E,D1			;414dc: 722e
	JSR	(___mulu,A4)		;414de: 4eac81c4
	LEA	(_stats,A4),A0		;414e2: 41ec82b6
	MOVE.B	#$02,(0,A0,D0.L)	;414e6: 11bc00020800
	MOVEA.L	(8,A5),A0		;414ec: 206d0008
	MOVE.W	(8,A0),D0		;414f0: 30280008
	AND.W	#$003f,D0		;414f4: c07c003f
	MOVEA.L	(8,A5),A0		;414f8: 206d0008
	MOVE.B	D0,-(A7)		;414fc: 1f00
	MOVEQ	#0,D0			;414fe: 7000
	MOVE.B	(1,A0),D0		;41500: 10280001
	MOVEQ	#$2E,D1			;41504: 722e
	JSR	(___mulu,A4)		;41506: 4eac81c4
	LEA	(LAB_516A5,A4),A0	;4150a: 41ec82b7
	MOVE.B	(A7)+,D1		;4150e: 121f
	MOVE.B	D1,(0,A0,D0.L)		;41510: 11810800
	MOVEA.L	(8,A5),A0		;41514: 206d0008
	MOVE.W	(8,A0),D0		;41518: 30280008
	ASR.W	#6,D0			;4151c: ec40
	MOVEA.L	(8,A5),A0		;4151e: 206d0008
	MOVE.B	D0,-(A7)		;41522: 1f00
	MOVEQ	#0,D0			;41524: 7000
	MOVE.B	(1,A0),D0		;41526: 10280001
	MOVEQ	#$2E,D1			;4152a: 722e
	JSR	(___mulu,A4)		;4152c: 4eac81c4
	LEA	(LAB_516A6,A4),A0	;41530: 41ec82b8
	MOVE.B	(A7)+,D1		;41534: 121f
	MOVE.B	D1,(0,A0,D0.L)		;41536: 11810800
LAB_4153A:
	MOVEA.L	(8,A5),A0		;4153a: 206d0008
	MOVE.W	(8,A0),D0		;4153e: 30280008
	LEA	(_map_who,A4),A0	;41542: 41ec1f88
	MOVEQ	#0,D1			;41546: 7200
	MOVE.B	(0,A0,D0.W),D1		;41548: 12300000
	SUBQ.W	#1,D1			;4154c: 5341
	MOVE.W	D1,(-6,A5)		;4154e: 3b41fffa
	CMPI.W	#$ffff,(-6,A5)		;41552: 0c6dfffffffa
	BEQ.W	LAB_415DC		;41558: 67000082
	MOVE.W	(-6,A5),D0		;4155c: 302dfffa
	CMP.W	($C,A5),D0		;41560: b06d000c
	BEQ.S	LAB_415DC		;41564: 6776
	CMPI.W	#$00d0,(-6,A5)		;41566: 0c6d00d0fffa
	BGE.S	LAB_415DC		;4156c: 6c6e
	MOVE.W	(-6,A5),D0		;4156e: 302dfffa
	MULS	#$0016,D0		;41572: c1fc0016
	LEA	(_peeps,A4),A0		;41576: 41ec9c26
	ADD.L	A0,D0			;4157a: d088
	MOVE.L	D0,(-4,A5)		;4157c: 2b40fffc
	MOVEA.L	(-4,A5),A0		;41580: 206dfffc
	MOVEQ	#0,D0			;41584: 7000
	MOVE.B	(A0),D0			;41586: 1010
	BTST	#7,D0			;41588: 08000007
	BNE.S	LAB_415DC		;4158c: 664e
	MOVEA.L	(-4,A5),A0		;4158e: 206dfffc
	BTST	#3,(A0)			;41592: 08100003
	BEQ.S	LAB_415A8		;41596: 6710
	MOVE.W	(-6,A5),-(A7)		;41598: 3f2dfffa
	MOVE.W	($C,A5),-(A7)		;4159c: 3f2d000c
	JSR	(_join_battle,PC)	;415a0: 4eba184a
	ADDQ.W	#4,A7			;415a4: 584f
	BRA.S	LAB_415DC		;415a6: 6034
LAB_415A8:
	MOVEA.L	(-4,A5),A0		;415a8: 206dfffc
	MOVEA.L	(8,A5),A1		;415ac: 226d0008
	MOVE.B	(1,A0),D0		;415b0: 10280001
	CMP.B	(1,A1),D0		;415b4: b0290001
	BNE.S	LAB_415CA		;415b8: 6610
	MOVE.W	(-6,A5),-(A7)		;415ba: 3f2dfffa
	MOVE.W	($C,A5),-(A7)		;415be: 3f2d000c
	JSR	(_join_forces,PC)	;415c2: 4eba0af0
	ADDQ.W	#4,A7			;415c6: 584f
	BRA.S	LAB_415DC		;415c8: 6012
LAB_415CA:
	MOVE.W	(-6,A5),-(A7)		;415ca: 3f2dfffa
	MOVE.W	($C,A5),-(A7)		;415ce: 3f2d000c
	JSR	(_set_battle,PC)	;415d2: 4eba16e6
	ADDQ.W	#4,A7			;415d6: 584f
	BRA.W	LAB_41434		;415d8: 6000fe5a
LAB_415DC:
	MOVEA.L	(8,A5),A0		;415dc: 206d0008
	TST.W	(4,A0)			;415e0: 4a680004
	BLE.W	LAB_4169C		;415e4: 6f0000b6
	TST.W	(-8,A5)			;415e8: 4a6dfff8
	BNE.S	LAB_4164A		;415ec: 665c
	MOVEA.L	(8,A5),A0		;415ee: 206d0008
	TST.L	($E,A0)			;415f2: 4aa8000e
	BNE.S	LAB_4164A		;415f6: 6652
	MOVEA.L	(8,A5),A0		;415f8: 206d0008
	MOVE.W	(8,A0),D0		;415fc: 30280008
	LEA	(_map_who,A4),A0	;41600: 41ec1f88
	TST.B	(0,A0,D0.W)		;41604: 4a300000
	BNE.S	LAB_41620		;41608: 6616
	MOVE.W	($C,A5),D0		;4160a: 302d000c
	ADDQ.W	#1,D0			;4160e: 5240
	MOVEA.L	(8,A5),A0		;41610: 206d0008
	MOVE.W	(8,A0),D1		;41614: 32280008
	LEA	(_map_who,A4),A0	;41618: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;4161c: 11801000
LAB_41620:
	MOVEA.L	(8,A5),A0		;41620: 206d0008
	MOVE.B	#$01,(A0)		;41624: 10bc0001
	MOVEA.L	(8,A5),A0		;41628: 206d0008
	MOVE.W	(_game_turn,A4),(6,A0)	;4162c: 316cae6a0006
	MOVE.L	(8,A5),-(A7)		;41632: 2f2d0008
	JSR	(_set_frame,PC)		;41636: 4eba0c9a
	ADDQ.W	#4,A7			;4163a: 584f
	CLR.W	-(A7)			;4163c: 4267
	MOVE.L	(8,A5),-(A7)		;4163e: 2f2d0008
	JSR	(_set_town,PC)		;41642: 4eba0df8
	ADDQ.W	#6,A7			;41646: 5c4f
	BRA.S	LAB_4169C		;41648: 6052
LAB_4164A:
	MOVEA.L	(8,A5),A0		;4164a: 206d0008
	MOVE.W	(8,A0),D0		;4164e: 30280008
	EXT.L	D0			;41652: 48c0
	ASL.L	#1,D0			;41654: e380
	LEA	(_map_steps,A4),A0	;41656: 41ecff88
	ADDQ.W	#1,(0,A0,D0.L)		;4165a: 52700800
	MOVEA.L	(8,A5),A0		;4165e: 206d0008
	MOVE.W	(8,A0),D0		;41662: 30280008
	LEA	(_map_who,A4),A0	;41666: 41ec1f88
	TST.B	(0,A0,D0.W)		;4166a: 4a300000
	BNE.S	LAB_41686		;4166e: 6616
	MOVE.W	($C,A5),D0		;41670: 302d000c
	ADDQ.W	#1,D0			;41674: 5240
	MOVEA.L	(8,A5),A0		;41676: 206d0008
	MOVE.W	(8,A0),D1		;4167a: 32280008
	LEA	(_map_who,A4),A0	;4167e: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;41682: 11801000
LAB_41686:
	MOVEA.L	(8,A5),A0		;41686: 206d0008
	MOVE.W	(-8,A5),D0		;4168a: 302dfff8
	ADD.W	D0,(8,A0)		;4168e: d1680008
	MOVEA.L	(8,A5),A0		;41692: 206d0008
	MOVE.W	(-8,A5),($A,A0)		;41696: 316dfff8000a
LAB_4169C:
	BRA.W	LAB_41434		;4169c: 6000fd96
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_where_do_i_go:
	LINK.W	A5,#-32			;416a0: 4e55ffe0
	MOVEM.L	D4-D6,-(A7)		;416a4: 48e70e00
	MOVE.W	#$270f,(-12,A5)		;416a8: 3b7c270ffff4
	MOVEQ	#0,D5			;416ae: 7a00
LAB_416B0:
	MOVE.W	D5,D0			;416b0: 3005
	EXT.L	D0			;416b2: 48c0
	ASL.L	#1,D0			;416b4: e380
	LEA	(-22,A5),A0		;416b6: 41edffea
	MOVE.W	#$0005,(0,A0,D0.L)	;416ba: 31bc00050800
	ADDQ.W	#1,D5			;416c0: 5245
	CMP.W	#$0005,D5		;416c2: ba7c0005
	BNE.S	LAB_416B0		;416c6: 66e8
	MOVEQ	#-1,D5			;416c8: 7aff
	CLR.W	(-2,A5)			;416ca: 426dfffe
	BRA.W	LAB_41944		;416ce: 60000274
LAB_416D2:
	TST.W	D5			;416d2: 4a45
	BNE.S	LAB_416EC		;416d4: 6616
	CMPI.W	#$0001,(-2,A5)		;416d6: 0c6d0001fffe
	BNE.S	LAB_416EC		;416dc: 660e
	JSR	(___newrand,A4)		;416de: 4eac80fe
	AND.W	#$0007,D0		;416e2: c07c0007
	MOVE.W	D0,D5			;416e6: 3a00
	ADDQ.W	#1,D5			;416e8: 5245
	BRA.S	LAB_416EE		;416ea: 6002
LAB_416EC:
	ADDQ.W	#1,D5			;416ec: 5245
LAB_416EE:
	CMP.W	#$0009,D5		;416ee: ba7c0009
	BNE.S	LAB_416F6		;416f2: 6602
	MOVEQ	#0,D5			;416f4: 7a00
LAB_416F6:
	MOVEA.L	(8,A5),A0		;416f6: 206d0008
	MOVE.W	(8,A0),(-10,A5)		;416fa: 3b680008fff6
	MOVEQ	#0,D4			;41700: 7800
	BRA.W	LAB_41930		;41702: 6000022c
LAB_41706:
	MOVE.W	D5,D0			;41706: 3005
	EXT.L	D0			;41708: 48c0
	ASL.L	#1,D0			;4170a: e380
	LEA	(_offset_vector,A4),A0	;4170c: 41ec842c
	MOVE.W	(0,A0,D0.L),-(A7)	;41710: 3f300800
	MOVE.W	(-10,A5),-(A7)		;41714: 3f2dfff6
	JSR	(___valid_move,A4)	;41718: 4eac817c
	ADDQ.W	#4,A7			;4171c: 584f
	MOVE.W	D0,D6			;4171e: 3c00
	TST.W	D6			;41720: 4a46
	BNE.W	LAB_41940		;41722: 6600021c
	MOVE.W	D5,D0			;41726: 3005
	EXT.L	D0			;41728: 48c0
	ASL.L	#1,D0			;4172a: e380
	LEA	(_offset_vector,A4),A0	;4172c: 41ec842c
	MOVE.W	(0,A0,D0.L),D1		;41730: 32300800
	ADD.W	D1,(-10,A5)		;41734: d36dfff6
	MOVE.W	(-10,A5),D0		;41738: 302dfff6
	LEA	(_map_blk,A4),A0	;4173c: 41eccf88
	CMPI.B	#$0f,(0,A0,D0.W)	;41740: 0c30000f0000
	BNE.W	LAB_417F4		;41746: 660000ac
	CMP.W	(-22,A5),D4		;4174a: b86dffea
	BGE.W	LAB_417F4		;4174e: 6c0000a4
	TST.W	D5			;41752: 4a45
	BNE.S	LAB_41780		;41754: 662a
	MOVE.W	(-10,A5),-(A7)		;41756: 3f2dfff6
	MOVEA.L	(8,A5),A0		;4175a: 206d0008
	MOVEQ	#0,D0			;4175e: 7000
	MOVE.B	(1,A0),D0		;41760: 10280001
	MOVE.W	D0,-(A7)		;41764: 3f00
	JSR	(___check_life,A4)	;41766: 4eac8182
	ADDQ.W	#4,A7			;4176a: 584f
	MOVE.W	D0,(-8,A5)		;4176c: 3b40fff8
	BEQ.S	LAB_4177E		;41770: 670c
	MOVE.W	D4,(-22,A5)		;41772: 3b44ffea
	CLR.W	(-32,A5)		;41776: 426dffe0
	BRA.W	LAB_4192E		;4177a: 600001b2
LAB_4177E:
	BRA.S	LAB_417F4		;4177e: 6074
LAB_41780:
	MOVEQ	#9,D6			;41780: 7c09
LAB_41782:
	MOVE.W	D6,D0			;41782: 3006
	EXT.L	D0			;41784: 48c0
	ASL.L	#1,D0			;41786: e380
	LEA	(_offset_vector,A4),A0	;41788: 41ec842c
	MOVE.W	(0,A0,D0.L),-(A7)	;4178c: 3f300800
	MOVE.W	(-10,A5),-(A7)		;41790: 3f2dfff6
	JSR	(___valid_move,A4)	;41794: 4eac817c
	ADDQ.W	#4,A7			;41798: 584f
	TST.W	D0			;4179a: 4a40
	BNE.S	LAB_417CE		;4179c: 6630
	MOVE.W	D6,D0			;4179e: 3006
	EXT.L	D0			;417a0: 48c0
	ASL.L	#1,D0			;417a2: e380
	LEA	(_offset_vector,A4),A0	;417a4: 41ec842c
	MOVE.W	(0,A0,D0.L),D1		;417a8: 32300800
	ADD.W	(-10,A5),D1		;417ac: d26dfff6
	LEA	(_map_bk2,A4),A0	;417b0: 41ecef88
	MOVEQ	#0,D0			;417b4: 7000
	MOVE.B	(0,A0,D1.W),D0		;417b6: 10301000
	MOVE.W	D0,(-8,A5)		;417ba: 3b40fff8
	CMPI.W	#$0020,(-8,A5)		;417be: 0c6d0020fff8
	BLE.S	LAB_417CE		;417c4: 6f08
	CMPI.W	#$002c,(-8,A5)		;417c6: 0c6d002cfff8
	BLE.S	LAB_417D6		;417cc: 6f08
LAB_417CE:
	ADDQ.W	#1,D6			;417ce: 5246
	CMP.W	#$0011,D6		;417d0: bc7c0011
	BLT.S	LAB_41782		;417d4: 6dac
LAB_417D6:
	CMP.W	#$0011,D6		;417d6: bc7c0011
	BNE.S	LAB_417F4		;417da: 6618
	MOVE.W	D4,(-22,A5)		;417dc: 3b44ffea
	MOVE.W	D5,D0			;417e0: 3005
	EXT.L	D0			;417e2: 48c0
	ASL.L	#1,D0			;417e4: e380
	LEA	(_offset_vector,A4),A0	;417e6: 41ec842c
	MOVE.W	(0,A0,D0.L),(-32,A5)	;417ea: 3b700800ffe0
	BRA.W	LAB_4192E		;417f0: 6000013c
LAB_417F4:
	TST.W	D5			;417f4: 4a45
	BEQ.W	LAB_4192E		;417f6: 67000136
	MOVE.W	(-10,A5),D0		;417fa: 302dfff6
	LEA	(_map_who,A4),A0	;417fe: 41ec1f88
	TST.B	(0,A0,D0.W)		;41802: 4a300000
	BEQ.W	LAB_418BE		;41806: 670000b6
	MOVE.W	(-10,A5),D0		;4180a: 302dfff6
	LEA	(_map_who,A4),A0	;4180e: 41ec1f88
	MOVEQ	#0,D1			;41812: 7200
	MOVE.B	(0,A0,D0.W),D1		;41814: 12300000
	SUBQ.W	#1,D1			;41818: 5341
	CMP.W	($C,A5),D1		;4181a: b26d000c
	BEQ.W	LAB_418BE		;4181e: 6700009e
	MOVE.W	(-10,A5),D0		;41822: 302dfff6
	LEA	(_map_who,A4),A0	;41826: 41ec1f88
	MOVEQ	#0,D1			;4182a: 7200
	MOVE.B	(0,A0,D0.W),D1		;4182c: 12300000
	SUBQ.W	#1,D1			;41830: 5341
	MULU	#$0016,D1		;41832: c2fc0016
	LEA	(_peeps,A4),A0		;41836: 41ec9c26
	ADD.L	A0,D1			;4183a: d288
	MOVE.L	D1,(-6,A5)		;4183c: 2b41fffa
	MOVEA.L	(-6,A5),A0		;41840: 206dfffa
	BTST	#3,(A0)			;41844: 08100003
	BEQ.S	LAB_41868		;41848: 671e
	CMP.W	(-20,A5),D4		;4184a: b86dffec
	BGE.S	LAB_41868		;4184e: 6c18
	MOVE.W	D4,(-20,A5)		;41850: 3b44ffec
	MOVE.W	D5,D0			;41854: 3005
	EXT.L	D0			;41856: 48c0
	ASL.L	#1,D0			;41858: e380
	LEA	(_offset_vector,A4),A0	;4185a: 41ec842c
	MOVE.W	(0,A0,D0.L),(-30,A5)	;4185e: 3b700800ffe2
	BRA.W	LAB_4192E		;41864: 600000c8
LAB_41868:
	MOVEA.L	(-6,A5),A0		;41868: 206dfffa
	MOVEA.L	(8,A5),A1		;4186c: 226d0008
	MOVE.B	(1,A0),D0		;41870: 10280001
	CMP.B	(1,A1),D0		;41874: b0290001
	BEQ.S	LAB_41898		;41878: 671e
	CMP.W	(-18,A5),D4		;4187a: b86dffee
	BGE.S	LAB_41898		;4187e: 6c18
	MOVE.W	D4,(-18,A5)		;41880: 3b44ffee
	MOVE.W	D5,D0			;41884: 3005
	EXT.L	D0			;41886: 48c0
	ASL.L	#1,D0			;41888: e380
	LEA	(_offset_vector,A4),A0	;4188a: 41ec842c
	MOVE.W	(0,A0,D0.L),(-28,A5)	;4188e: 3b700800ffe4
	BRA.W	LAB_4192E		;41894: 60000098
LAB_41898:
	MOVEA.L	(-6,A5),A0		;41898: 206dfffa
	BTST	#1,(A0)			;4189c: 08100001
	BEQ.S	LAB_418BE		;418a0: 671c
	CMP.W	(-16,A5),D4		;418a2: b86dfff0
	BGE.S	LAB_418BE		;418a6: 6c16
	MOVE.W	D4,(-16,A5)		;418a8: 3b44fff0
	MOVE.W	D5,D0			;418ac: 3005
	EXT.L	D0			;418ae: 48c0
	ASL.L	#1,D0			;418b0: e380
	LEA	(_offset_vector,A4),A0	;418b2: 41ec842c
	MOVE.W	(0,A0,D0.L),(-26,A5)	;418b6: 3b700800ffe6
	BRA.S	LAB_4192E		;418bc: 6070
LAB_418BE:
	MOVE.W	D5,D0			;418be: 3005
	EXT.L	D0			;418c0: 48c0
	ASL.L	#1,D0			;418c2: e380
	LEA	(_offset_vector,A4),A0	;418c4: 41ec842c
	MOVEA.L	(8,A5),A1		;418c8: 226d0008
	MOVE.W	(0,A0,D0.L),D1		;418cc: 32300800
	CMP.W	($A,A1),D1		;418d0: b269000a
	BEQ.S	LAB_4192E		;418d4: 6758
	MOVE.W	(-10,A5),D0		;418d6: 302dfff6
	EXT.L	D0			;418da: 48c0
	ASL.L	#1,D0			;418dc: e380
	LEA	(_map_steps,A4),A0	;418de: 41ecff88
	MOVE.W	(0,A0,D0.L),D1		;418e2: 32300800
	CMP.W	(-12,A5),D1		;418e6: b26dfff4
	BCS.S	LAB_41908		;418ea: 651c
	MOVE.W	(-10,A5),D0		;418ec: 302dfff6
	EXT.L	D0			;418f0: 48c0
	ASL.L	#1,D0			;418f2: e380
	LEA	(_map_steps,A4),A0	;418f4: 41ecff88
	MOVE.W	(0,A0,D0.L),D1		;418f8: 32300800
	CMP.W	(-12,A5),D1		;418fc: b26dfff4
	BNE.S	LAB_4192E		;41900: 662c
	CMP.W	(-14,A5),D4		;41902: b86dfff2
	BGE.S	LAB_4192E		;41906: 6c26
LAB_41908:
	MOVE.W	(-10,A5),D0		;41908: 302dfff6
	EXT.L	D0			;4190c: 48c0
	ASL.L	#1,D0			;4190e: e380
	LEA	(_map_steps,A4),A0	;41910: 41ecff88
	MOVE.W	(0,A0,D0.L),(-12,A5)	;41914: 3b700800fff4
	MOVE.W	D4,(-14,A5)		;4191a: 3b44fff2
	MOVE.W	D5,D0			;4191e: 3005
	EXT.L	D0			;41920: 48c0
	ASL.L	#1,D0			;41922: e380
	LEA	(_offset_vector,A4),A0	;41924: 41ec842c
	MOVE.W	(0,A0,D0.L),(-24,A5)	;41928: 3b700800ffe8
LAB_4192E:
	ADDQ.W	#1,D4			;4192e: 5244
LAB_41930:
	MOVEA.L	(8,A5),A0		;41930: 206d0008
	MOVEQ	#0,D0			;41934: 7000
	MOVE.B	(2,A0),D0		;41936: 10280002
	CMP.W	D4,D0			;4193a: b044
	BNE.W	LAB_41706		;4193c: 6600fdc8
LAB_41940:
	ADDQ.W	#1,(-2,A5)		;41940: 526dfffe
LAB_41944:
	CMPI.W	#$0009,(-2,A5)		;41944: 0c6d0009fffe
	BNE.W	LAB_416D2		;4194a: 6600fd86
	MOVEA.L	(8,A5),A0		;4194e: 206d0008
	MOVEQ	#0,D0			;41952: 7000
	MOVE.B	(1,A0),D0		;41954: 10280001
	ASL.L	#4,D0			;41958: e980
	LEA	(LAB_52DE8,A4),A0	;4195a: 41ec99fa
	CMPI.W	#$0003,(0,A0,D0.L)	;4195e: 0c7000030800
	BNE.S	LAB_4197A		;41964: 6614
	CMPI.W	#$0005,(-18,A5)		;41966: 0c6d0005ffee
	BEQ.S	LAB_4197A		;4196c: 670c
	MOVE.W	(-28,A5),D0		;4196e: 302dffe4
LAB_41972:
	MOVEM.L	(A7)+,D4-D6		;41972: 4cdf0070
	UNLK	A5			;41976: 4e5d
	RTS				;41978: 4e75
LAB_4197A:
	MOVEA.L	(8,A5),A0		;4197a: 206d0008
	MOVEQ	#0,D0			;4197e: 7000
	MOVE.B	(1,A0),D0		;41980: 10280001
	ASL.L	#4,D0			;41984: e980
	LEA	(LAB_52DE8,A4),A0	;41986: 41ec99fa
	CMPI.W	#$0002,(0,A0,D0.L)	;4198a: 0c7000020800
	BNE.S	LAB_419A0		;41990: 660e
	CMPI.W	#$0005,(-16,A5)		;41992: 0c6d0005fff0
	BEQ.S	LAB_419A0		;41998: 6706
	MOVE.W	(-26,A5),D0		;4199a: 302dffe6
	BRA.S	LAB_41972		;4199e: 60d2
LAB_419A0:
	MOVEQ	#0,D5			;419a0: 7a00
LAB_419A2:
	MOVE.W	D5,D0			;419a2: 3005
	EXT.L	D0			;419a4: 48c0
	ASL.L	#1,D0			;419a6: e380
	LEA	(-22,A5),A0		;419a8: 41edffea
	CMPI.W	#$0005,(0,A0,D0.L)	;419ac: 0c7000050800
	BEQ.S	LAB_419C6		;419b2: 6712
	MOVE.W	D5,D0			;419b4: 3005
	EXT.L	D0			;419b6: 48c0
	ASL.L	#1,D0			;419b8: e380
	LEA	(-32,A5),A0		;419ba: 41edffe0
	MOVE.L	D0,D1			;419be: 2200
	MOVE.W	(0,A0,D1.L),D0		;419c0: 30301800
	BRA.S	LAB_41972		;419c4: 60ac
LAB_419C6:
	ADDQ.W	#1,D5			;419c6: 5245
	CMP.W	#$0005,D5		;419c8: ba7c0005
	BNE.S	LAB_419A2		;419cc: 66d4
	MOVE.W	#$03e7,D0		;419ce: 303c03e7
	BRA.S	LAB_41972		;419d2: 609e
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_move_magnet_peeps:
	LINK.W	A5,#-14			;419d4: 4e55fff2
	MOVEM.L	D4/A2,-(A7)		;419d8: 48e70820
	MOVEA.L	(8,A5),A2		;419dc: 246d0008
	MOVEQ	#0,D0			;419e0: 7000
	MOVE.B	(1,A2),D0		;419e2: 102a0001
	MOVE.W	D0,(-14,A5)		;419e6: 3b40fff2
	TST.L	($E,A2)			;419ea: 4aaa000e
	BEQ.W	LAB_41A9E		;419ee: 670000ae
	MOVEA.L	($E,A2),A0		;419f2: 206a000e
	MOVE.W	(8,A0),D0		;419f6: 30280008
	CMP.W	(8,A2),D0		;419fa: b06a0008
	BEQ.S	LAB_41A26		;419fe: 6726
	MOVEA.L	($E,A2),A0		;41a00: 206a000e
	TST.W	(4,A0)			;41a04: 4a680004
	BLE.S	LAB_41A26		;41a08: 6f1c
	MOVEA.L	($E,A2),A0		;41a0a: 206a000e
	MOVE.B	(1,A0),D0		;41a0e: 10280001
	CMP.B	(1,A2),D0		;41a12: b02a0001
	BEQ.S	LAB_41A26		;41a16: 670e
	MOVEA.L	($E,A2),A0		;41a18: 206a000e
	MOVEQ	#0,D0			;41a1c: 7000
	MOVE.B	(A0),D0			;41a1e: 1010
	BTST	#7,D0			;41a20: 08000007
	BEQ.S	LAB_41A2E		;41a24: 6708
LAB_41A26:
	MOVE.L	A2,-(A7)		;41a26: 2f0a
	JSR	(_get_heading,PC)	;41a28: 4eba05c0
	ADDQ.W	#4,A7			;41a2c: 584f
LAB_41A2E:
	MOVEA.L	($E,A2),A0		;41a2e: 206a000e
	MOVE.W	(8,A0),D0		;41a32: 30280008
	AND.W	#$003f,D0		;41a36: c07c003f
	MOVE.W	(8,A2),D1		;41a3a: 322a0008
	AND.W	#$003f,D1		;41a3e: c27c003f
	SUB.W	D1,D0			;41a42: 9041
	MOVE.W	D0,(-10,A5)		;41a44: 3b40fff6
	MOVEA.L	($E,A2),A0		;41a48: 206a000e
	MOVE.W	(8,A0),D0		;41a4c: 30280008
	ASR.W	#6,D0			;41a50: ec40
	MOVE.W	(8,A2),D1		;41a52: 322a0008
	ASR.W	#6,D1			;41a56: ec41
	SUB.W	D1,D0			;41a58: 9041
	MOVE.W	D0,(-12,A5)		;41a5a: 3b40fff4
	TST.W	(-10,A5)		;41a5e: 4a6dfff6
	BLE.S	LAB_41A68		;41a62: 6f04
	MOVEQ	#1,D0			;41a64: 7001
	BRA.S	LAB_41A6A		;41a66: 6002
LAB_41A68:
	MOVEQ	#0,D0			;41a68: 7000
LAB_41A6A:
	TST.W	(-10,A5)		;41a6a: 4a6dfff6
	BGE.S	LAB_41A74		;41a6e: 6c04
	MOVEQ	#1,D1			;41a70: 7201
	BRA.S	LAB_41A76		;41a72: 6002
LAB_41A74:
	MOVEQ	#0,D1			;41a74: 7200
LAB_41A76:
	SUB.W	D1,D0			;41a76: 9041
	MOVE.W	D0,(-6,A5)		;41a78: 3b40fffa
	TST.W	(-12,A5)		;41a7c: 4a6dfff4
	BLE.S	LAB_41A86		;41a80: 6f04
	MOVEQ	#1,D0			;41a82: 7001
	BRA.S	LAB_41A88		;41a84: 6002
LAB_41A86:
	MOVEQ	#0,D0			;41a86: 7000
LAB_41A88:
	TST.W	(-12,A5)		;41a88: 4a6dfff4
	BGE.S	LAB_41A92		;41a8c: 6c04
	MOVEQ	#1,D1			;41a8e: 7201
	BRA.S	LAB_41A94		;41a90: 6002
LAB_41A92:
	MOVEQ	#0,D1			;41a92: 7200
LAB_41A94:
	SUB.W	D1,D0			;41a94: 9041
	MOVE.W	D0,(-8,A5)		;41a96: 3b40fff8
	BRA.W	LAB_41CF6		;41a9a: 6000025a
LAB_41A9E:
	MOVE.W	(-14,A5),D0		;41a9e: 302dfff2
	EXT.L	D0			;41aa2: 48c0
	ASL.L	#4,D0			;41aa4: e980
	LEA	(_magnet,A4),A0		;41aa6: 41ec99f6
	TST.W	(0,A0,D0.L)		;41aaa: 4a700800
	BNE.W	LAB_41B9C		;41aae: 660000ec
	MOVE.W	(-14,A5),D0		;41ab2: 302dfff2
	EXT.L	D0			;41ab6: 48c0
	ASL.L	#4,D0			;41ab8: e980
	LEA	(LAB_52DE6,A4),A0	;41aba: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;41abe: 32300800
	CMP.W	(8,A2),D1		;41ac2: b26a0008
	BNE.S	LAB_41AF4		;41ac6: 662c
	MOVE.W	(-14,A5),D0		;41ac8: 302dfff2
	EXT.L	D0			;41acc: 48c0
	ASL.L	#4,D0			;41ace: e980
	LEA	(_magnet,A4),A0		;41ad0: 41ec99f6
	MOVE.W	($C,A5),D1		;41ad4: 322d000c
	ADDQ.W	#1,D1			;41ad8: 5241
	MOVE.W	D1,(0,A0,D0.L)		;41ada: 31810800
	TST.W	(_view_who,A4)		;41ade: 4a6cae68
	BNE.S	LAB_41AEE		;41ae2: 660a
	MOVE.W	($C,A5),D0		;41ae4: 302d000c
	ADDQ.W	#1,D0			;41ae8: 5240
	MOVE.W	D0,(_view_who,A4)	;41aea: 3940ae68
LAB_41AEE:
	MOVE.B	(-13,A5),(1,A2)		;41aee: 156dfff30001
LAB_41AF4:
	MOVE.W	(-14,A5),D0		;41af4: 302dfff2
	EXT.L	D0			;41af8: 48c0
	ASL.L	#4,D0			;41afa: e980
	LEA	(LAB_52DE6,A4),A0	;41afc: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;41b00: 32300800
	AND.W	#$003f,D1		;41b04: c27c003f
	MOVE.W	(8,A2),D0		;41b08: 302a0008
	AND.W	#$003f,D0		;41b0c: c07c003f
	SUB.W	D0,D1			;41b10: 9240
	TST.W	D1			;41b12: 4a41
	BLE.S	LAB_41B1A		;41b14: 6f04
	MOVEQ	#1,D0			;41b16: 7001
	BRA.S	LAB_41B1C		;41b18: 6002
LAB_41B1A:
	MOVEQ	#0,D0			;41b1a: 7000
LAB_41B1C:
	MOVE.W	(-14,A5),D1		;41b1c: 322dfff2
	EXT.L	D1			;41b20: 48c1
	ASL.L	#4,D1			;41b22: e981
	LEA	(LAB_52DE6,A4),A0	;41b24: 41ec99f8
	MOVE.W	(0,A0,D1.L),D2		;41b28: 34301800
	AND.W	#$003f,D2		;41b2c: c47c003f
	MOVE.W	(8,A2),D1		;41b30: 322a0008
	AND.W	#$003f,D1		;41b34: c27c003f
	SUB.W	D1,D2			;41b38: 9441
	TST.W	D2			;41b3a: 4a42
	BGE.S	LAB_41B42		;41b3c: 6c04
	MOVEQ	#1,D1			;41b3e: 7201
	BRA.S	LAB_41B44		;41b40: 6002
LAB_41B42:
	MOVEQ	#0,D1			;41b42: 7200
LAB_41B44:
	SUB.W	D1,D0			;41b44: 9041
	MOVE.W	D0,(-6,A5)		;41b46: 3b40fffa
	MOVE.W	(-14,A5),D0		;41b4a: 302dfff2
	EXT.L	D0			;41b4e: 48c0
	ASL.L	#4,D0			;41b50: e980
	LEA	(LAB_52DE6,A4),A0	;41b52: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;41b56: 32300800
	ASR.W	#6,D1			;41b5a: ec41
	MOVE.W	(8,A2),D0		;41b5c: 302a0008
	ASR.W	#6,D0			;41b60: ec40
	SUB.W	D0,D1			;41b62: 9240
	TST.W	D1			;41b64: 4a41
	BLE.S	LAB_41B6C		;41b66: 6f04
	MOVEQ	#1,D0			;41b68: 7001
	BRA.S	LAB_41B6E		;41b6a: 6002
LAB_41B6C:
	MOVEQ	#0,D0			;41b6c: 7000
LAB_41B6E:
	MOVE.W	(-14,A5),D1		;41b6e: 322dfff2
	EXT.L	D1			;41b72: 48c1
	ASL.L	#4,D1			;41b74: e981
	LEA	(LAB_52DE6,A4),A0	;41b76: 41ec99f8
	MOVE.W	(0,A0,D1.L),D2		;41b7a: 34301800
	ASR.W	#6,D2			;41b7e: ec42
	MOVE.W	(8,A2),D1		;41b80: 322a0008
	ASR.W	#6,D1			;41b84: ec41
	SUB.W	D1,D2			;41b86: 9441
	TST.W	D2			;41b88: 4a42
	BGE.S	LAB_41B90		;41b8a: 6c04
	MOVEQ	#1,D1			;41b8c: 7201
	BRA.S	LAB_41B92		;41b8e: 6002
LAB_41B90:
	MOVEQ	#0,D1			;41b90: 7200
LAB_41B92:
	SUB.W	D1,D0			;41b92: 9041
	MOVE.W	D0,(-8,A5)		;41b94: 3b40fff8
	BRA.W	LAB_41CF6		;41b98: 6000015c
LAB_41B9C:
	MOVE.W	(-14,A5),D0		;41b9c: 302dfff2
	EXT.L	D0			;41ba0: 48c0
	ASL.L	#4,D0			;41ba2: e980
	LEA	(_magnet,A4),A0		;41ba4: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;41ba8: 32300800
	SUBQ.W	#1,D1			;41bac: 5341
	CMP.W	($C,A5),D1		;41bae: b26d000c
	BNE.W	LAB_41C5E		;41bb2: 660000aa
	MOVE.W	(-14,A5),D0		;41bb6: 302dfff2
	EXT.L	D0			;41bba: 48c0
	ASL.L	#4,D0			;41bbc: e980
	LEA	(LAB_52DE6,A4),A0	;41bbe: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;41bc2: 32300800
	AND.W	#$003f,D1		;41bc6: c27c003f
	MOVE.W	(8,A2),D0		;41bca: 302a0008
	AND.W	#$003f,D0		;41bce: c07c003f
	SUB.W	D0,D1			;41bd2: 9240
	TST.W	D1			;41bd4: 4a41
	BLE.S	LAB_41BDC		;41bd6: 6f04
	MOVEQ	#1,D0			;41bd8: 7001
	BRA.S	LAB_41BDE		;41bda: 6002
LAB_41BDC:
	MOVEQ	#0,D0			;41bdc: 7000
LAB_41BDE:
	MOVE.W	(-14,A5),D1		;41bde: 322dfff2
	EXT.L	D1			;41be2: 48c1
	ASL.L	#4,D1			;41be4: e981
	LEA	(LAB_52DE6,A4),A0	;41be6: 41ec99f8
	MOVE.W	(0,A0,D1.L),D2		;41bea: 34301800
	AND.W	#$003f,D2		;41bee: c47c003f
	MOVE.W	(8,A2),D1		;41bf2: 322a0008
	AND.W	#$003f,D1		;41bf6: c27c003f
	SUB.W	D1,D2			;41bfa: 9441
	TST.W	D2			;41bfc: 4a42
	BGE.S	LAB_41C04		;41bfe: 6c04
	MOVEQ	#1,D1			;41c00: 7201
	BRA.S	LAB_41C06		;41c02: 6002
LAB_41C04:
	MOVEQ	#0,D1			;41c04: 7200
LAB_41C06:
	SUB.W	D1,D0			;41c06: 9041
	MOVE.W	D0,(-6,A5)		;41c08: 3b40fffa
	MOVE.W	(-14,A5),D0		;41c0c: 302dfff2
	EXT.L	D0			;41c10: 48c0
	ASL.L	#4,D0			;41c12: e980
	LEA	(LAB_52DE6,A4),A0	;41c14: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;41c18: 32300800
	ASR.W	#6,D1			;41c1c: ec41
	MOVE.W	(8,A2),D0		;41c1e: 302a0008
	ASR.W	#6,D0			;41c22: ec40
	SUB.W	D0,D1			;41c24: 9240
	TST.W	D1			;41c26: 4a41
	BLE.S	LAB_41C2E		;41c28: 6f04
	MOVEQ	#1,D0			;41c2a: 7001
	BRA.S	LAB_41C30		;41c2c: 6002
LAB_41C2E:
	MOVEQ	#0,D0			;41c2e: 7000
LAB_41C30:
	MOVE.W	(-14,A5),D1		;41c30: 322dfff2
	EXT.L	D1			;41c34: 48c1
	ASL.L	#4,D1			;41c36: e981
	LEA	(LAB_52DE6,A4),A0	;41c38: 41ec99f8
	MOVE.W	(0,A0,D1.L),D2		;41c3c: 34301800
	ASR.W	#6,D2			;41c40: ec42
	MOVE.W	(8,A2),D1		;41c42: 322a0008
	ASR.W	#6,D1			;41c46: ec41
	SUB.W	D1,D2			;41c48: 9441
	TST.W	D2			;41c4a: 4a42
	BGE.S	LAB_41C52		;41c4c: 6c04
	MOVEQ	#1,D1			;41c4e: 7201
	BRA.S	LAB_41C54		;41c50: 6002
LAB_41C52:
	MOVEQ	#0,D1			;41c52: 7200
LAB_41C54:
	SUB.W	D1,D0			;41c54: 9041
	MOVE.W	D0,(-8,A5)		;41c56: 3b40fff8
	BRA.W	LAB_41CF6		;41c5a: 6000009a
LAB_41C5E:
	MOVE.W	(-14,A5),D0		;41c5e: 302dfff2
	EXT.L	D0			;41c62: 48c0
	ASL.L	#4,D0			;41c64: e980
	LEA	(_magnet,A4),A0		;41c66: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;41c6a: 32300800
	SUBQ.W	#1,D1			;41c6e: 5341
	MULS	#$0016,D1		;41c70: c3fc0016
	LEA	(LAB_5301C,A4),A0	;41c74: 41ec9c2e
	MOVE.W	(0,A0,D1.L),D0		;41c78: 30301800
	AND.W	#$003f,D0		;41c7c: c07c003f
	MOVE.W	(8,A2),D1		;41c80: 322a0008
	AND.W	#$003f,D1		;41c84: c27c003f
	SUB.W	D1,D0			;41c88: 9041
	MOVE.W	D0,(-10,A5)		;41c8a: 3b40fff6
	MOVE.W	(-14,A5),D0		;41c8e: 302dfff2
	EXT.L	D0			;41c92: 48c0
	ASL.L	#4,D0			;41c94: e980
	LEA	(_magnet,A4),A0		;41c96: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;41c9a: 32300800
	SUBQ.W	#1,D1			;41c9e: 5341
	MULS	#$0016,D1		;41ca0: c3fc0016
	LEA	(LAB_5301C,A4),A0	;41ca4: 41ec9c2e
	MOVE.W	(0,A0,D1.L),D0		;41ca8: 30301800
	ASR.W	#6,D0			;41cac: ec40
	MOVE.W	(8,A2),D1		;41cae: 322a0008
	ASR.W	#6,D1			;41cb2: ec41
	SUB.W	D1,D0			;41cb4: 9041
	MOVE.W	D0,(-12,A5)		;41cb6: 3b40fff4
	TST.W	(-10,A5)		;41cba: 4a6dfff6
	BLE.S	LAB_41CC4		;41cbe: 6f04
	MOVEQ	#1,D0			;41cc0: 7001
	BRA.S	LAB_41CC6		;41cc2: 6002
LAB_41CC4:
	MOVEQ	#0,D0			;41cc4: 7000
LAB_41CC6:
	TST.W	(-10,A5)		;41cc6: 4a6dfff6
	BGE.S	LAB_41CD0		;41cca: 6c04
	MOVEQ	#1,D1			;41ccc: 7201
	BRA.S	LAB_41CD2		;41cce: 6002
LAB_41CD0:
	MOVEQ	#0,D1			;41cd0: 7200
LAB_41CD2:
	SUB.W	D1,D0			;41cd2: 9041
	MOVE.W	D0,(-6,A5)		;41cd4: 3b40fffa
	TST.W	(-12,A5)		;41cd8: 4a6dfff4
	BLE.S	LAB_41CE2		;41cdc: 6f04
	MOVEQ	#1,D0			;41cde: 7001
	BRA.S	LAB_41CE4		;41ce0: 6002
LAB_41CE2:
	MOVEQ	#0,D0			;41ce2: 7000
LAB_41CE4:
	TST.W	(-12,A5)		;41ce4: 4a6dfff4
	BGE.S	LAB_41CEE		;41ce8: 6c04
	MOVEQ	#1,D1			;41cea: 7201
	BRA.S	LAB_41CF0		;41cec: 6002
LAB_41CEE:
	MOVEQ	#0,D1			;41cee: 7200
LAB_41CF0:
	SUB.W	D1,D0			;41cf0: 9041
	MOVE.W	D0,(-8,A5)		;41cf2: 3b40fff8
LAB_41CF6:
	MOVE.W	(-6,A5),D0		;41cf6: 302dfffa
	ADDQ.W	#1,D0			;41cfa: 5240
	MULS	#$0003,D0		;41cfc: c1fc0003
	ADD.W	(-8,A5),D0		;41d00: d06dfff8
	ADDQ.W	#1,D0			;41d04: 5240
	EXT.L	D0			;41d06: 48c0
	ASL.L	#1,D0			;41d08: e380
	LEA	(_to_delta,A4),A0	;41d0a: 41ec840a
	MOVE.W	(0,A0,D0.L),(-2,A5)	;41d0e: 3b700800fffe
	MOVE.W	(-2,A5),D0		;41d14: 302dfffe
	EXT.L	D0			;41d18: 48c0
	ASL.L	#1,D0			;41d1a: e380
	LEA	(_to_offset,A4),A0	;41d1c: 41ec841c
	MOVE.W	(0,A0,D0.L),-(A7)	;41d20: 3f300800
	MOVE.W	(8,A2),-(A7)		;41d24: 3f2a0008
	JSR	(___valid_move,A4)	;41d28: 4eac817c
	ADDQ.W	#4,A7			;41d2c: 584f
	MOVE.W	D0,(-4,A5)		;41d2e: 3b40fffc
	BNE.S	LAB_41D7A		;41d32: 6646
	TST.L	($E,A2)			;41d34: 4aaa000e
	BEQ.S	LAB_41D5A		;41d38: 6720
	MOVE.W	(-2,A5),D0		;41d3a: 302dfffe
	EXT.L	D0			;41d3e: 48c0
	ASL.L	#1,D0			;41d40: e380
	LEA	(_to_offset,A4),A0	;41d42: 41ec841c
	MOVE.W	(0,A0,D0.L),D1		;41d46: 32300800
	ADD.W	(8,A2),D1		;41d4a: d26a0008
	LEA	(_map_blk,A4),A0	;41d4e: 41eccf88
	CMPI.B	#$35,(0,A0,D1.W)	;41d52: 0c3000351000
	BEQ.S	LAB_41D7A		;41d58: 6720
LAB_41D5A:
	MOVE.W	(-2,A5),D0		;41d5a: 302dfffe
	EXT.L	D0			;41d5e: 48c0
	ASL.L	#1,D0			;41d60: e380
	LEA	(_to_offset,A4),A0	;41d62: 41ec841c
	MOVE.L	D0,D1			;41d66: 2200
	MOVE.B	(1,A0,D1.L),D0		;41d68: 10301801
	MOVE.B	D0,($15,A2)		;41d6c: 15400015
	EXT.W	D0			;41d70: 4880
LAB_41D72:
	MOVEM.L	(A7)+,D4/A2		;41d72: 4cdf0410
	UNLK	A5			;41d76: 4e5d
	RTS				;41d78: 4e75
LAB_41D7A:
	CMPI.W	#$0002,(-4,A5)		;41d7a: 0c6d0002fffc
	BNE.S	LAB_41DA2		;41d80: 6620
	TST.W	(_war,A4)		;41d82: 4a6cae80
	BEQ.S	LAB_41DA2		;41d86: 671a
	MOVE.W	(-2,A5),D0		;41d88: 302dfffe
	EXT.L	D0			;41d8c: 48c0
	ASL.L	#1,D0			;41d8e: e380
	LEA	(_to_offset,A4),A0	;41d90: 41ec841c
	MOVE.L	D0,D1			;41d94: 2200
	MOVE.B	(1,A0,D1.L),D0		;41d96: 10301801
	MOVE.B	D0,($15,A2)		;41d9a: 15400015
	EXT.W	D0			;41d9e: 4880
	BRA.S	LAB_41D72		;41da0: 60d0
LAB_41DA2:
	MOVEQ	#0,D0			;41da2: 7000
	MOVE.B	(1,A2),D0		;41da4: 102a0001
	MOVEQ	#$2E,D1			;41da8: 722e
	JSR	(___mulu,A4)		;41daa: 4eac81c4
	LEA	(LAB_516AA,A4),A0	;41dae: 41ec82bc
	CMPI.W	#$0001,(0,A0,D0.L)	;41db2: 0c7000010800
	BEQ.S	LAB_41DC2		;41db8: 6708
	TST.W	(_war,A4)		;41dba: 4a6cae80
	BEQ.W	LAB_41F06		;41dbe: 67000146
LAB_41DC2:
	BTST	#2,(LAB_518A7,A4)	;41dc2: 082c000284b9
	BEQ.S	LAB_41DD2		;41dc8: 6708
	TST.W	(_war,A4)		;41dca: 4a6cae80
	BEQ.W	LAB_41F06		;41dce: 67000136
LAB_41DD2:
	CMPI.W	#$0003,(-4,A5)		;41dd2: 0c6d0003fffc
	BNE.S	LAB_41E48		;41dd8: 666e
	MOVEQ	#0,D0			;41dda: 7000
	MOVE.B	(1,A2),D0		;41ddc: 102a0001
	MOVEQ	#$2E,D1			;41de0: 722e
	JSR	(___mulu,A4)		;41de2: 4eac81c4
	LEA	(_stats,A4),A0		;41de6: 41ec82b6
	MOVE.B	#$01,(0,A0,D0.L)	;41dea: 11bc00010800
	MOVE.W	(8,A2),D0		;41df0: 302a0008
	AND.W	#$003f,D0		;41df4: c07c003f
	MOVE.B	D0,-(A7)		;41df8: 1f00
	MOVEQ	#0,D0			;41dfa: 7000
	MOVE.B	(1,A2),D0		;41dfc: 102a0001
	MOVEQ	#$2E,D1			;41e00: 722e
	JSR	(___mulu,A4)		;41e02: 4eac81c4
	LEA	(LAB_516A5,A4),A0	;41e06: 41ec82b7
	MOVE.B	(A7)+,D1		;41e0a: 121f
	MOVE.B	D1,(0,A0,D0.L)		;41e0c: 11810800
	MOVE.W	(8,A2),D0		;41e10: 302a0008
	ASR.W	#6,D0			;41e14: ec40
	MOVE.B	D0,-(A7)		;41e16: 1f00
	MOVEQ	#0,D0			;41e18: 7000
	MOVE.B	(1,A2),D0		;41e1a: 102a0001
	MOVEQ	#$2E,D1			;41e1e: 722e
	JSR	(___mulu,A4)		;41e20: 4eac81c4
	LEA	(LAB_516A6,A4),A0	;41e24: 41ec82b8
	MOVE.B	(A7)+,D1		;41e28: 121f
	MOVE.B	D1,(0,A0,D0.L)		;41e2a: 11810800
	MOVEQ	#0,D0			;41e2e: 7000
	MOVE.B	(1,A2),D0		;41e30: 102a0001
	MOVEQ	#$2E,D1			;41e34: 722e
	JSR	(___mulu,A4)		;41e36: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;41e3a: 41ec82be
	MOVE.W	#$0001,(0,A0,D0.L)	;41e3e: 31bc00010800
	BRA.W	LAB_41F06		;41e44: 600000c0
LAB_41E48:
	MOVE.W	(-2,A5),D0		;41e48: 302dfffe
	EXT.L	D0			;41e4c: 48c0
	ASL.L	#1,D0			;41e4e: e380
	LEA	(_to_offset,A4),A0	;41e50: 41ec841c
	MOVE.W	(0,A0,D0.L),D1		;41e54: 32300800
	ADD.W	(8,A2),D1		;41e58: d26a0008
	LEA	(_map_blk,A4),A0	;41e5c: 41eccf88
	CMPI.B	#$35,(0,A0,D1.W)	;41e60: 0c3000351000
	BNE.W	LAB_41F06		;41e66: 6600009e
	BTST	#3,(LAB_518A7,A4)	;41e6a: 082c000384b9
	BNE.W	LAB_41F06		;41e70: 66000094
	TST.W	(_war,A4)		;41e74: 4a6cae80
	BNE.W	LAB_41F06		;41e78: 6600008c
	MOVEQ	#0,D0			;41e7c: 7000
	MOVE.B	(1,A2),D0		;41e7e: 102a0001
	MOVEQ	#$2E,D1			;41e82: 722e
	JSR	(___mulu,A4)		;41e84: 4eac81c4
	LEA	(_stats,A4),A0		;41e88: 41ec82b6
	MOVE.B	#$01,(0,A0,D0.L)	;41e8c: 11bc00010800
	MOVE.W	(-2,A5),D0		;41e92: 302dfffe
	EXT.L	D0			;41e96: 48c0
	ASL.L	#1,D0			;41e98: e380
	LEA	(_to_offset,A4),A0	;41e9a: 41ec841c
	MOVE.W	(0,A0,D0.L),D1		;41e9e: 32300800
	ADD.W	(8,A2),D1		;41ea2: d26a0008
	AND.W	#$003f,D1		;41ea6: c27c003f
	MOVEQ	#0,D0			;41eaa: 7000
	MOVE.B	(1,A2),D0		;41eac: 102a0001
	MOVE.B	D1,-(A7)		;41eb0: 1f01
	MOVEQ	#$2E,D1			;41eb2: 722e
	JSR	(___mulu,A4)		;41eb4: 4eac81c4
	LEA	(LAB_516A5,A4),A0	;41eb8: 41ec82b7
	MOVE.B	(A7)+,D1		;41ebc: 121f
	MOVE.B	D1,(0,A0,D0.L)		;41ebe: 11810800
	MOVE.W	(-2,A5),D0		;41ec2: 302dfffe
	EXT.L	D0			;41ec6: 48c0
	ASL.L	#1,D0			;41ec8: e380
	LEA	(_to_offset,A4),A0	;41eca: 41ec841c
	MOVE.W	(0,A0,D0.L),D1		;41ece: 32300800
	ADD.W	(8,A2),D1		;41ed2: d26a0008
	ASR.W	#6,D1			;41ed6: ec41
	MOVEQ	#0,D0			;41ed8: 7000
	MOVE.B	(1,A2),D0		;41eda: 102a0001
	MOVE.B	D1,-(A7)		;41ede: 1f01
	MOVEQ	#$2E,D1			;41ee0: 722e
	JSR	(___mulu,A4)		;41ee2: 4eac81c4
	LEA	(LAB_516A6,A4),A0	;41ee6: 41ec82b8
	MOVE.B	(A7)+,D1		;41eea: 121f
	MOVE.B	D1,(0,A0,D0.L)		;41eec: 11810800
	MOVEQ	#0,D0			;41ef0: 7000
	MOVE.B	(1,A2),D0		;41ef2: 102a0001
	MOVEQ	#$2E,D1			;41ef6: 722e
	JSR	(___mulu,A4)		;41ef8: 4eac81c4
	LEA	(LAB_516AC,A4),A0	;41efc: 41ec82be
	MOVE.W	#$0001,(0,A0,D0.L)	;41f00: 31bc00010800
LAB_41F06:
	MOVE.W	(-2,A5),D4		;41f06: 382dfffe
	SUBQ.W	#1,D4			;41f0a: 5344
	CLR.W	(-4,A5)			;41f0c: 426dfffc
	BRA.W	LAB_41FB0		;41f10: 6000009e
LAB_41F14:
	TST.W	D4			;41f14: 4a44
	BGE.S	LAB_41F1A		;41f16: 6c02
	MOVEQ	#7,D4			;41f18: 7807
LAB_41F1A:
	CMP.W	#$0007,D4		;41f1a: b87c0007
	BLE.S	LAB_41F22		;41f1e: 6f02
	MOVEQ	#0,D4			;41f20: 7800
LAB_41F22:
	MOVE.W	D4,D0			;41f22: 3004
	EXT.L	D0			;41f24: 48c0
	ASL.L	#1,D0			;41f26: e380
	LEA	(_to_offset,A4),A0	;41f28: 41ec841c
	MOVE.W	(0,A0,D0.L),-(A7)	;41f2c: 3f300800
	MOVE.W	(8,A2),-(A7)		;41f30: 3f2a0008
	JSR	(___valid_move,A4)	;41f34: 4eac817c
	ADDQ.W	#4,A7			;41f38: 584f
	TST.W	D0			;41f3a: 4a40
	BNE.S	LAB_41FAA		;41f3c: 666c
	MOVE.W	D4,D0			;41f3e: 3004
	EXT.L	D0			;41f40: 48c0
	ASL.L	#1,D0			;41f42: e380
	LEA	(_to_offset,A4),A0	;41f44: 41ec841c
	MOVE.B	($15,A2),D1		;41f48: 122a0015
	EXT.W	D1			;41f4c: 4881
	MOVE.W	(0,A0,D0.L),D2		;41f4e: 34300800
	CMP.W	D1,D2			;41f52: b441
	BEQ.S	LAB_41FAA		;41f54: 6754
	TST.L	($E,A2)			;41f56: 4aaa000e
	BEQ.S	LAB_41F7A		;41f5a: 671e
	MOVE.W	D4,D0			;41f5c: 3004
	EXT.L	D0			;41f5e: 48c0
	ASL.L	#1,D0			;41f60: e380
	LEA	(_to_offset,A4),A0	;41f62: 41ec841c
	MOVE.W	(0,A0,D0.L),D1		;41f66: 32300800
	ADD.W	(8,A2),D1		;41f6a: d26a0008
	LEA	(_map_blk,A4),A0	;41f6e: 41eccf88
	CMPI.B	#$35,(0,A0,D1.W)	;41f72: 0c3000351000
	BEQ.S	LAB_41FAA		;41f78: 6730
LAB_41F7A:
	MOVE.W	D4,D0			;41f7a: 3004
	EXT.L	D0			;41f7c: 48c0
	ASL.L	#1,D0			;41f7e: e380
	LEA	(_opposite,A4),A0	;41f80: 41ec83ba
	MOVE.W	(0,A0,D0.L),D1		;41f84: 32300800
	EXT.L	D1			;41f88: 48c1
	ASL.L	#1,D1			;41f8a: e381
	LEA	(_to_offset,A4),A0	;41f8c: 41ec841c
	MOVE.B	(1,A0,D1.L),($15,A2)	;41f90: 157018010015
	MOVE.W	D4,D0			;41f96: 3004
	EXT.L	D0			;41f98: 48c0
	ASL.L	#1,D0			;41f9a: e380
	LEA	(_to_offset,A4),A0	;41f9c: 41ec841c
	MOVE.L	D0,D1			;41fa0: 2200
	MOVE.W	(0,A0,D1.L),D0		;41fa2: 30301800
	BRA.W	LAB_41D72		;41fa6: 6000fdca
LAB_41FAA:
	ADDQ.W	#1,D4			;41faa: 5244
	ADDQ.W	#1,(-4,A5)		;41fac: 526dfffc
LAB_41FB0:
	CMPI.W	#$0008,(-4,A5)		;41fb0: 0c6d0008fffc
	BLT.W	LAB_41F14		;41fb6: 6d00ff5c
	CMPI.W	#$0008,(-4,A5)		;41fba: 0c6d0008fffc
	BNE.S	LAB_41FE6		;41fc0: 6624
	MOVE.W	D4,D0			;41fc2: 3004
	EXT.L	D0			;41fc4: 48c0
	ASL.L	#1,D0			;41fc6: e380
	LEA	(_opposite,A4),A0	;41fc8: 41ec83ba
	MOVE.W	(0,A0,D0.L),D1		;41fcc: 32300800
	EXT.L	D1			;41fd0: 48c1
	ASL.L	#1,D1			;41fd2: e381
	LEA	(_to_offset,A4),A0	;41fd4: 41ec841c
	MOVE.B	(1,A0,D1.L),($15,A2)	;41fd8: 157018010015
	MOVE.W	#$03e7,D0		;41fde: 303c03e7
	BRA.W	LAB_41D72		;41fe2: 6000fd8e
LAB_41FE6:
	BRA.W	LAB_41D72		;41fe6: 6000fd8a
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_get_heading:
	LINK.W	A5,#-12			;41fea: 4e55fff4
	MOVEM.L	D4/A2-A3,-(A7)		;41fee: 48e70830
	MOVEA.L	(8,A5),A2		;41ff2: 246d0008
	MOVE.W	#$270f,(-8,A5)		;41ff6: 3b7c270ffff8
	MOVE.W	(8,A2),D0		;41ffc: 302a0008
	AND.W	#$003f,D0		;42000: c07c003f
	MOVE.W	D0,(-2,A5)		;42004: 3b40fffe
	MOVE.W	(8,A2),D0		;42008: 302a0008
	ASR.W	#6,D0			;4200c: ec40
	MOVE.W	D0,(-4,A5)		;4200e: 3b40fffc
	MOVE.L	A2,($E,A2)		;42012: 254a000e
	MOVEQ	#0,D4			;42016: 7800
	LEA	(_peeps,A4),A0		;42018: 41ec9c26
	MOVEA.L	A0,A3			;4201c: 2648
	BRA.W	LAB_420A4		;4201e: 60000084
LAB_42022:
	MOVE.B	(1,A2),D0		;42022: 102a0001
	CMP.B	(1,A3),D0		;42026: b02b0001
	BEQ.S	LAB_4209C		;4202a: 6770
	TST.W	(4,A3)			;4202c: 4a6b0004
	BLE.S	LAB_4209C		;42030: 6f6a
	MOVEQ	#0,D0			;42032: 7000
	MOVE.B	(A3),D0			;42034: 1013
	BTST	#7,D0			;42036: 08000007
	BNE.S	LAB_4209C		;4203a: 6660
	MOVE.W	(8,A3),D0		;4203c: 302b0008
	AND.W	#$003f,D0		;42040: c07c003f
	SUB.W	(-2,A5),D0		;42044: 906dfffe
	MOVE.W	D0,(-10,A5)		;42048: 3b40fff6
	MOVE.W	(8,A3),D0		;4204c: 302b0008
	ASR.W	#6,D0			;42050: ec40
	SUB.W	(-4,A5),D0		;42052: 906dfffc
	MOVE.W	D0,(-12,A5)		;42056: 3b40fff4
	TST.W	(-10,A5)		;4205a: 4a6dfff6
	BGE.S	LAB_42068		;4205e: 6c08
	MOVE.W	(-10,A5),D0		;42060: 302dfff6
	NEG.W	D0			;42064: 4440
	BRA.S	LAB_4206C		;42066: 6004
LAB_42068:
	MOVE.W	(-10,A5),D0		;42068: 302dfff6
LAB_4206C:
	MOVE.W	D0,-(A7)		;4206c: 3f00
	TST.W	(-12,A5)		;4206e: 4a6dfff4
	BGE.S	LAB_4207C		;42072: 6c08
	MOVE.W	(-12,A5),D0		;42074: 302dfff4
	NEG.W	D0			;42078: 4440
	BRA.S	LAB_42080		;4207a: 6004
LAB_4207C:
	MOVE.W	(-12,A5),D0		;4207c: 302dfff4
LAB_42080:
	MOVE.W	(A7)+,D1		;42080: 321f
	ADD.W	D0,D1			;42082: d240
	MOVE.W	D1,(-6,A5)		;42084: 3b41fffa
	MOVE.W	(-6,A5),D0		;42088: 302dfffa
	CMP.W	(-8,A5),D0		;4208c: b06dfff8
	BGE.S	LAB_4209C		;42090: 6c0a
	MOVE.W	(-6,A5),(-8,A5)		;42092: 3b6dfffafff8
	MOVE.L	A3,($E,A2)		;42098: 254b000e
LAB_4209C:
	ADDA.L	#$00000016,A3		;4209c: d7fc00000016
	ADDQ.W	#1,D4			;420a2: 5244
LAB_420A4:
	CMP.W	(_no_peeps,A4),D4	;420a4: b86cae5e
	BLT.W	LAB_42022		;420a8: 6d00ff78
	MOVEM.L	(A7)+,D4/A2-A3		;420ac: 4cdf0c10
	UNLK	A5			;420b0: 4e5d
	RTS				;420b2: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_join_forces:
	LINK.W	A5,#-10			;420b4: 4e55fff6
	MOVE.W	(8,A5),D0		;420b8: 302d0008
	MULS	#$0016,D0		;420bc: c1fc0016
	LEA	(_peeps,A4),A0		;420c0: 41ec9c26
	ADD.L	A0,D0			;420c4: d088
	MOVE.L	D0,(-4,A5)		;420c6: 2b40fffc
	MOVE.W	($A,A5),D0		;420ca: 302d000a
	MULS	#$0016,D0		;420ce: c1fc0016
	LEA	(_peeps,A4),A0		;420d2: 41ec9c26
	ADD.L	A0,D0			;420d6: d088
	MOVE.L	D0,(-8,A5)		;420d8: 2b40fff8
	MOVEA.L	(-4,A5),A0		;420dc: 206dfffc
	MOVEQ	#0,D0			;420e0: 7000
	MOVE.B	(1,A0),D0		;420e2: 10280001
	ASL.L	#4,D0			;420e6: e980
	LEA	(_magnet,A4),A0		;420e8: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;420ec: 32300800
	SUBQ.W	#1,D1			;420f0: 5341
	MOVE.W	D1,(-10,A5)		;420f2: 3b41fff6
	MOVEA.L	(-4,A5),A0		;420f6: 206dfffc
	TST.L	($E,A0)			;420fa: 4aa8000e
	BEQ.S	LAB_4211C		;420fe: 671c
	MOVEA.L	(-8,A5),A0		;42100: 206dfff8
	CMPI.B	#$01,(A0)		;42104: 0c100001
	BNE.S	LAB_4210E		;42108: 6604
LAB_4210A:
	UNLK	A5			;4210a: 4e5d
	RTS				;4210c: 4e75
LAB_4210E:
	MOVEA.L	(-4,A5),A0		;4210e: 206dfffc
	MOVEA.L	(-8,A5),A1		;42112: 226dfff8
	MOVE.L	($E,A0),($E,A1)		;42116: 2368000e000e
LAB_4211C:
	MOVEA.L	(-4,A5),A0		;4211c: 206dfffc
	MOVE.W	(4,A0),D0		;42120: 30280004
	EXT.L	D0			;42124: 48c0
	MOVEA.L	(-8,A5),A0		;42126: 206dfff8
	MOVE.W	(4,A0),D1		;4212a: 32280004
	EXT.L	D1			;4212e: 48c1
	ADD.L	D1,D0			;42130: d081
	CMP.L	#$00007d00,D0		;42132: b0bc00007d00
	BLE.S	LAB_42146		;42138: 6f0c
	MOVEA.L	(-8,A5),A0		;4213a: 206dfff8
	MOVE.W	#$7d00,(4,A0)		;4213e: 317c7d000004
	BRA.S	LAB_42156		;42144: 6010
LAB_42146:
	MOVEA.L	(-8,A5),A0		;42146: 206dfff8
	MOVEA.L	(-4,A5),A1		;4214a: 226dfffc
	MOVE.W	(4,A1),D0		;4214e: 30290004
	ADD.W	D0,(4,A0)		;42152: d1680004
LAB_42156:
	MOVE.W	(8,A5),D0		;42156: 302d0008
	CMP.W	(-10,A5),D0		;4215a: b06dfff6
	BNE.S	LAB_4217A		;4215e: 661a
	MOVEA.L	(-4,A5),A0		;42160: 206dfffc
	MOVEQ	#0,D0			;42164: 7000
	MOVE.B	(1,A0),D0		;42166: 10280001
	ASL.L	#4,D0			;4216a: e980
	LEA	(_magnet,A4),A0		;4216c: 41ec99f6
	MOVE.W	($A,A5),D1		;42170: 322d000a
	ADDQ.W	#1,D1			;42174: 5241
	MOVE.W	D1,(0,A0,D0.L)		;42176: 31810800
LAB_4217A:
	MOVE.W	(_view_who,A4),D0	;4217a: 302cae68
	SUBQ.W	#1,D0			;4217e: 5340
	CMP.W	(8,A5),D0		;42180: b06d0008
	BNE.S	LAB_42190		;42184: 660a
	MOVE.W	($A,A5),D0		;42186: 302d000a
	ADDQ.W	#1,D0			;4218a: 5240
	MOVE.W	D0,(_view_who,A4)	;4218c: 3940ae68
LAB_42190:
	MOVE.W	($A,A5),D0		;42190: 302d000a
	CMP.W	(8,A5),D0		;42194: b06d0008
	BLE.S	LAB_421B8		;42198: 6f1e
	MOVEA.L	(-4,A5),A0		;4219a: 206dfffc
	MOVEQ	#0,D0			;4219e: 7000
	MOVE.B	(1,A0),D0		;421a0: 10280001
	ASL.L	#4,D0			;421a4: e980
	LEA	(good_pop,A4),A0	;421a6: 41ec99fe
	ADDA.L	D0,A0			;421aa: d1c0
	MOVEA.L	(-4,A5),A1		;421ac: 226dfffc
	MOVE.W	(4,A1),D0		;421b0: 30290004
	EXT.L	D0			;421b4: 48c0
	SUB.L	D0,(A0)			;421b6: 9190
LAB_421B8:
	MOVEA.L	(-4,A5),A0		;421b8: 206dfffc
	MOVEA.L	(-8,A5),A1		;421bc: 226dfff8
	MOVE.B	(3,A0),D0		;421c0: 10280003
	CMP.B	(3,A1),D0		;421c4: b0290003
	BLS.S	LAB_421D8		;421c8: 630e
	MOVEA.L	(-4,A5),A0		;421ca: 206dfffc
	MOVEA.L	(-8,A5),A1		;421ce: 226dfff8
	MOVE.B	(3,A0),(3,A1)		;421d2: 136800030003
LAB_421D8:
	MOVEA.L	(-4,A5),A0		;421d8: 206dfffc
	CLR.W	(4,A0)			;421dc: 42680004
	MOVEA.L	(-8,A5),A0		;421e0: 206dfff8
	ANDI.B	#$9f,(A0)		;421e4: 0210009f
	MOVEA.L	(-8,A5),A0		;421e8: 206dfff8
	CLR.W	($C,A0)			;421ec: 4268000c
	BRA.W	LAB_4210A		;421f0: 6000ff18
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_zero_population:
	LINK.W	A5,#-2			;421f4: 4e55fffe
	MOVE.L	A2,-(A7)		;421f8: 2f0a
	MOVEA.L	(8,A5),A2		;421fa: 246d0008
	MOVEQ	#0,D0			;421fe: 7000
	MOVE.B	(1,A2),D0		;42200: 102a0001
	MOVE.W	D0,(-2,A5)		;42204: 3b40fffe
	CLR.W	(4,A2)			;42208: 426a0004
	CMPI.B	#$08,(A2)		;4220c: 0c120008
	BNE.S	LAB_42224		;42210: 6612
	MOVE.W	(6,A2),D0		;42212: 302a0006
	MULU	#$0016,D0		;42216: c0fc0016
	LEA	(_peeps,A4),A0		;4221a: 41ec9c26
	ADDA.L	D0,A0			;4221e: d1c0
	ANDI.B	#$f7,(A0)		;42220: 021000f7
LAB_42224:
	BTST	#0,(A2)			;42224: 08120000
	BEQ.S	LAB_42236		;42228: 670c
	MOVE.W	#$0001,-(A7)		;4222a: 3f3c0001
	MOVE.L	A2,-(A7)		;4222e: 2f0a
	JSR	(_set_town,PC)		;42230: 4eba020a
	ADDQ.W	#6,A7			;42234: 5c4f
LAB_42236:
	MOVE.W	(8,A2),D0		;42236: 302a0008
	LEA	(_map_who,A4),A0	;4223a: 41ec1f88
	MOVEQ	#0,D1			;4223e: 7200
	MOVE.B	(0,A0,D0.W),D1		;42240: 12300000
	SUBQ.W	#1,D1			;42244: 5341
	CMP.W	($C,A5),D1		;42246: b26d000c
	BNE.S	LAB_42258		;4224a: 660c
	MOVE.W	(8,A2),D0		;4224c: 302a0008
	LEA	(_map_who,A4),A0	;42250: 41ec1f88
	CLR.B	(0,A0,D0.W)		;42254: 42300000
LAB_42258:
	MOVE.W	(8,A2),D0		;42258: 302a0008
	SUB.W	($A,A2),D0		;4225c: 906a000a
	LEA	(_map_who,A4),A0	;42260: 41ec1f88
	MOVEQ	#0,D1			;42264: 7200
	MOVE.B	(0,A0,D0.W),D1		;42266: 12300000
	SUBQ.W	#1,D1			;4226a: 5341
	CMP.W	($C,A5),D1		;4226c: b26d000c
	BNE.S	LAB_42282		;42270: 6610
	MOVE.W	(8,A2),D0		;42272: 302a0008
	SUB.W	($A,A2),D0		;42276: 906a000a
	LEA	(_map_who,A4),A0	;4227a: 41ec1f88
	CLR.B	(0,A0,D0.W)		;4227e: 42300000
LAB_42282:
	MOVEQ	#0,D0			;42282: 7000
	MOVE.B	(1,A2),D0		;42284: 102a0001
	ASL.L	#4,D0			;42288: e980
	LEA	(_magnet,A4),A0		;4228a: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;4228e: 32300800
	SUBQ.W	#1,D1			;42292: 5341
	CMP.W	($C,A5),D1		;42294: b26d000c
	BNE.S	LAB_422BC		;42298: 6622
	MOVEQ	#0,D0			;4229a: 7000
	MOVE.B	(1,A2),D0		;4229c: 102a0001
	ASL.L	#4,D0			;422a0: e980
	LEA	(_magnet,A4),A0		;422a2: 41ec99f6
	CLR.W	(0,A0,D0.L)		;422a6: 42700800
	MOVE.W	(8,A2),-(A7)		;422aa: 3f2a0008
	MOVEQ	#0,D0			;422ae: 7000
	MOVE.B	(1,A2),D0		;422b0: 102a0001
	MOVE.W	D0,-(A7)		;422b4: 3f00
	JSR	(_set_magnet_to,PC)	;422b6: 4eba1e14
	ADDQ.W	#4,A7			;422ba: 584f
LAB_422BC:
	MOVE.W	(_view_who,A4),D0	;422bc: 302cae68
	SUBQ.W	#1,D0			;422c0: 5340
	CMP.W	($C,A5),D0		;422c2: b06d000c
	BNE.S	LAB_422CC		;422c6: 6604
	CLR.W	(_view_who,A4)		;422c8: 426cae68
LAB_422CC:
	MOVEA.L	(A7)+,A2		;422cc: 245f
	UNLK	A5			;422ce: 4e5d
	RTS				;422d0: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_frame:
	LINK.W	A5,#0			;422d2: 4e550000
	MOVEM.L	D4/A2-A3,-(A7)		;422d6: 48e70830
	MOVEA.L	(8,A5),A2		;422da: 246d0008
	TST.W	(4,A2)			;422de: 4a6a0004
	BEQ.W	LAB_42436		;422e2: 67000152
	CMPI.B	#$02,(A2)		;422e6: 0c120002
	BNE.S	LAB_4230C		;422ea: 6620
	MOVE.W	($C,A2),D0		;422ec: 302a000c
	ADDQ.W	#1,($C,A2)		;422f0: 526a000c
	CMP.W	#$0007,D0		;422f4: b07c0007
	BLT.S	LAB_42308		;422f8: 6d0e
	CLR.W	($C,A2)			;422fa: 426a000c
	MOVEQ	#1,D0			;422fe: 7001
LAB_42300:
	MOVEM.L	(A7)+,D4/A2-A3		;42300: 4cdf0c10
	UNLK	A5			;42304: 4e5d
	RTS				;42306: 4e75
LAB_42308:
	BRA.W	LAB_42436		;42308: 6000012c
LAB_4230C:
	BTST	#4,(A2)			;4230c: 08120004
	BEQ.S	LAB_42334		;42310: 6722
	ADDQ.W	#1,($C,A2)		;42312: 526a000c
	CMPI.W	#$0060,($C,A2)		;42316: 0c6a0060000c
	BGT.S	LAB_42326		;4231c: 6e08
	CMPI.W	#$005d,($C,A2)		;4231e: 0c6a005d000c
	BGE.S	LAB_42330		;42324: 6c0a
LAB_42326:
	MOVE.W	#$005d,($C,A2)		;42326: 357c005d000c
	MOVEQ	#1,D0			;4232c: 7001
	BRA.S	LAB_42300		;4232e: 60d0
LAB_42330:
	BRA.W	LAB_42436		;42330: 60000104
LAB_42334:
	BTST	#3,(A2)			;42334: 08120003
	BEQ.S	LAB_423AE		;42338: 6774
	MOVE.W	(6,A2),D0		;4233a: 302a0006
	MULU	#$0016,D0		;4233e: c0fc0016
	LEA	(_peeps,A4),A0		;42342: 41ec9c26
	MOVEA.L	D0,A3			;42346: 2640
	ADDA.L	A0,A3			;42348: d7c8
	TST.L	($E,A2)			;4234a: 4aaa000e
	BEQ.S	LAB_4236E		;4234e: 671e
	TST.L	($E,A3)			;42350: 4aab000e
	BEQ.S	LAB_4235C		;42354: 6706
	MOVE.W	#$008a,D4		;42356: 383c008a
	BRA.S	LAB_4236C		;4235a: 6010
LAB_4235C:
	TST.B	(1,A2)			;4235c: 4a2a0001
	BNE.S	LAB_42368		;42360: 6606
	MOVE.W	#$0082,D4		;42362: 383c0082
	BRA.S	LAB_4236C		;42366: 6004
LAB_42368:
	MOVE.W	#$0086,D4		;42368: 383c0086
LAB_4236C:
	BRA.S	LAB_42388		;4236c: 601a
LAB_4236E:
	TST.L	($E,A3)			;4236e: 4aab000e
	BEQ.S	LAB_42386		;42372: 6712
	TST.B	(1,A3)			;42374: 4a2b0001
	BNE.S	LAB_42380		;42378: 6606
	MOVE.W	#$0082,D4		;4237a: 383c0082
	BRA.S	LAB_42384		;4237e: 6004
LAB_42380:
	MOVE.W	#$0086,D4		;42380: 383c0086
LAB_42384:
	BRA.S	LAB_42388		;42384: 6002
LAB_42386:
	MOVEQ	#$46,D4			;42386: 7846
LAB_42388:
	ADDQ.W	#1,($C,A2)		;42388: 526a000c
	MOVE.W	D4,D0			;4238c: 3004
	ADDQ.W	#3,D0			;4238e: 5640
	MOVE.W	($C,A2),D1		;42390: 322a000c
	CMP.W	D0,D1			;42394: b240
	BGE.S	LAB_423A0		;42396: 6c08
	MOVE.W	($C,A2),D0		;42398: 302a000c
	CMP.W	D4,D0			;4239c: b044
	BGE.S	LAB_423AA		;4239e: 6c0a
LAB_423A0:
	MOVE.W	D4,($C,A2)		;423a0: 3544000c
	MOVEQ	#1,D0			;423a4: 7001
	BRA.W	LAB_42300		;423a6: 6000ff58
LAB_423AA:
	BRA.W	LAB_42436		;423aa: 6000008a
LAB_423AE:
	CMPI.B	#$01,(A2)		;423ae: 0c120001
	BNE.S	LAB_423EC		;423b2: 6638
	MOVE.W	(8,A2),-(A7)		;423b4: 3f2a0008
	MOVEQ	#0,D0			;423b8: 7000
	MOVE.B	(1,A2),D0		;423ba: 102a0001
	MOVE.W	D0,-(A7)		;423be: 3f00
	JSR	(___check_life,A4)	;423c0: 4eac8182
	ADDQ.W	#4,A7			;423c4: 584f
	MOVE.W	D0,D4			;423c6: 3800
	CMP.W	#$0bea,D4		;423c8: b87c0bea
	BLT.S	LAB_423D6		;423cc: 6d08
	MOVE.W	#$002a,($C,A2)		;423ce: 357c002a000c
	BRA.S	LAB_423EA		;423d4: 6014
LAB_423D6:
	MOVE.W	D4,D0			;423d6: 3004
	MULS	#$000a,D0		;423d8: c1fc000a
	EXT.L	D0			;423dc: 48c0
	DIVS	#$0131,D0		;423de: 81fc0131
	ADD.W	#$0020,D0		;423e2: d07c0020
	MOVE.W	D0,($C,A2)		;423e6: 3540000c
LAB_423EA:
	BRA.S	LAB_42436		;423ea: 604a
LAB_423EC:
	BTST	#2,(A2)			;423ec: 08120002
	BEQ.S	LAB_4240E		;423f0: 671c
	ADDQ.W	#1,($C,A2)		;423f2: 526a000c
	CMPI.W	#$0058,($C,A2)		;423f6: 0c6a0058000c
	BGE.S	LAB_42406		;423fc: 6c08
	CMPI.W	#$0055,($C,A2)		;423fe: 0c6a0055000c
	BGE.S	LAB_4240C		;42404: 6c06
LAB_42406:
	MOVEQ	#1,D0			;42406: 7001
	BRA.W	LAB_42300		;42408: 6000fef6
LAB_4240C:
	BRA.S	LAB_42436		;4240c: 6028
LAB_4240E:
	MOVE.B	(A2),D0			;4240e: 1012
	AND.B	#$60,D0			;42410: c03c0060
	BEQ.S	LAB_42436		;42414: 6720
	ADDQ.W	#1,($C,A2)		;42416: 526a000c
	CMPI.W	#$0066,($C,A2)		;4241a: 0c6a0066000c
	BGT.S	LAB_4242A		;42420: 6e08
	CMPI.W	#$0065,($C,A2)		;42422: 0c6a0065000c
	BGE.S	LAB_42436		;42428: 6c0c
LAB_4242A:
	MOVE.W	#$0065,($C,A2)		;4242a: 357c0065000c
	MOVEQ	#1,D0			;42430: 7001
	BRA.W	LAB_42300		;42432: 6000fecc
LAB_42436:
	MOVEQ	#0,D0			;42436: 7000
	BRA.W	LAB_42300		;42438: 6000fec6
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_town:
	LINK.W	A5,#-2			;4243c: 4e55fffe
	MOVEM.L	D4-D5/A2,-(A7)		;42440: 48e70c20
	MOVEA.L	(8,A5),A0		;42444: 206d0008
	MOVE.W	(8,A0),(-2,A5)		;42448: 3b680008fffe
	LEA	(_offset_vector,A4),A0	;4244e: 41ec842c
	MOVEA.L	A0,A2			;42452: 2448
	TST.W	($C,A5)			;42454: 4a6d000c
	BEQ.W	LAB_42528		;42458: 670000ce
	MOVE.W	(-2,A5),D0		;4245c: 302dfffe
	LEA	(_map_bk2,A4),A0	;42460: 41ecef88
	CMPI.B	#$2a,(0,A0,D0.W)	;42464: 0c30002a0000
	BNE.S	LAB_424C0		;4246a: 6654
	MOVEQ	#0,D4			;4246c: 7800
LAB_4246E:
	MOVE.W	(A2),-(A7)		;4246e: 3f12
	MOVE.W	(-2,A5),-(A7)		;42470: 3f2dfffe
	JSR	(___valid_move,A4)	;42474: 4eac817c
	ADDQ.W	#4,A7			;42478: 584f
	CMP.W	#$0001,D0		;4247a: b07c0001
	BEQ.S	LAB_424B4		;4247e: 6734
	MOVE.W	(A2),D5			;42480: 3a12
	ADD.W	(-2,A5),D5		;42482: da6dfffe
	LEA	(_map_bk2,A4),A0	;42486: 41ecef88
	CLR.B	(0,A0,D5.W)		;4248a: 42305000
	MOVEA.L	(8,A5),A0		;4248e: 206d0008
	MOVEQ	#0,D0			;42492: 7000
	MOVE.B	(1,A0),D0		;42494: 10280001
	ADD.W	#$001f,D0		;42498: d07c001f
	LEA	(_map_blk,A4),A0	;4249c: 41eccf88
	MOVEQ	#0,D1			;424a0: 7200
	MOVE.B	(0,A0,D5.W),D1		;424a2: 12305000
	CMP.W	D1,D0			;424a6: b041
	BNE.S	LAB_424B4		;424a8: 660a
	LEA	(_map_blk,A4),A0	;424aa: 41eccf88
	MOVE.B	#$0f,(0,A0,D5.W)	;424ae: 11bc000f5000
LAB_424B4:
	ADDQ.W	#1,D4			;424b4: 5244
	ADDQ.L	#2,A2			;424b6: 548a
	CMP.W	#$0019,D4		;424b8: b87c0019
	BLT.S	LAB_4246E		;424bc: 6db0
	BRA.S	LAB_42524		;424be: 6064
LAB_424C0:
	MOVEQ	#0,D4			;424c0: 7800
LAB_424C2:
	MOVE.W	(A2),-(A7)		;424c2: 3f12
	MOVE.W	(-2,A5),-(A7)		;424c4: 3f2dfffe
	JSR	(___valid_move,A4)	;424c8: 4eac817c
	ADDQ.W	#4,A7			;424cc: 584f
	CMP.W	#$0001,D0		;424ce: b07c0001
	BEQ.S	LAB_4250E		;424d2: 673a
	MOVE.W	(A2),D5			;424d4: 3a12
	ADD.W	(-2,A5),D5		;424d6: da6dfffe
	CMP.W	#$0009,D4		;424da: b87c0009
	BGE.S	LAB_424E8		;424de: 6c08
	LEA	(_map_bk2,A4),A0	;424e0: 41ecef88
	CLR.B	(0,A0,D5.W)		;424e4: 42305000
LAB_424E8:
	MOVEA.L	(8,A5),A0		;424e8: 206d0008
	MOVEQ	#0,D0			;424ec: 7000
	MOVE.B	(1,A0),D0		;424ee: 10280001
	ADD.W	#$001f,D0		;424f2: d07c001f
	LEA	(_map_blk,A4),A0	;424f6: 41eccf88
	MOVEQ	#0,D1			;424fa: 7200
	MOVE.B	(0,A0,D5.W),D1		;424fc: 12305000
	CMP.W	D1,D0			;42500: b041
	BNE.S	LAB_4250E		;42502: 660a
	LEA	(_map_blk,A4),A0	;42504: 41eccf88
	MOVE.B	#$0f,(0,A0,D5.W)	;42508: 11bc000f5000
LAB_4250E:
	ADDQ.W	#1,D4			;4250e: 5244
	ADDQ.L	#2,A2			;42510: 548a
	CMP.W	#$0011,D4		;42512: b87c0011
	BLT.S	LAB_424C2		;42516: 6daa
	MOVE.W	(-2,A5),D0		;42518: 302dfffe
	LEA	(_map_bk2,A4),A0	;4251c: 41ecef88
	CLR.B	(0,A0,D0.W)		;42520: 42300000
LAB_42524:
	BRA.W	LAB_42682		;42524: 6000015c
LAB_42528:
	MOVEA.L	(8,A5),A0		;42528: 206d0008
	CMPI.W	#$002a,($C,A0)		;4252c: 0c68002a000c
	BNE.S	LAB_42596		;42532: 6662
	MOVEQ	#0,D4			;42534: 7800
LAB_42536:
	MOVE.W	(A2),-(A7)		;42536: 3f12
	MOVE.W	(-2,A5),-(A7)		;42538: 3f2dfffe
	JSR	(___valid_move,A4)	;4253c: 4eac817c
	ADDQ.W	#4,A7			;42540: 584f
	CMP.W	#$0001,D0		;42542: b07c0001
	BEQ.S	LAB_42588		;42546: 6740
	MOVE.W	(A2),D5			;42548: 3a12
	ADD.W	(-2,A5),D5		;4254a: da6dfffe
	CMP.W	#$0009,D4		;4254e: b87c0009
	BGE.S	LAB_42568		;42552: 6c14
	MOVE.W	D4,D0			;42554: 3004
	EXT.L	D0			;42556: 48c0
	ASL.L	#1,D0			;42558: e380
	LEA	(_big_city,A4),A0	;4255a: 41ec8474
	LEA	(_map_bk2,A4),A1	;4255e: 43ecef88
	MOVE.B	(1,A0,D0.L),(0,A1,D5.W)	;42562: 13b008015000
LAB_42568:
	LEA	(_map_blk,A4),A0	;42568: 41eccf88
	CMPI.B	#$0f,(0,A0,D5.W)	;4256c: 0c30000f5000
	BNE.S	LAB_42588		;42572: 6614
	LEA	(_map_blk,A4),A0	;42574: 41eccf88
	MOVEA.L	(8,A5),A1		;42578: 226d0008
	MOVE.B	(1,A1),D0		;4257c: 10290001
	ADD.B	#$1f,D0			;42580: d03c001f
	MOVE.B	D0,(0,A0,D5.W)		;42584: 11805000
LAB_42588:
	ADDQ.W	#1,D4			;42588: 5244
	ADDQ.L	#2,A2			;4258a: 548a
	CMP.W	#$0019,D4		;4258c: b87c0019
	BLT.S	LAB_42536		;42590: 6da4
	BRA.W	LAB_42682		;42592: 600000ee
LAB_42596:
	MOVE.W	(-2,A5),D0		;42596: 302dfffe
	LEA	(_map_bk2,A4),A0	;4259a: 41ecef88
	CMPI.B	#$2a,(0,A0,D0.W)	;4259e: 0c30002a0000
	BNE.S	LAB_425FE		;425a4: 6658
	MOVEQ	#0,D4			;425a6: 7800
LAB_425A8:
	MOVE.W	(A2),-(A7)		;425a8: 3f12
	MOVE.W	(-2,A5),-(A7)		;425aa: 3f2dfffe
	JSR	(___valid_move,A4)	;425ae: 4eac817c
	ADDQ.W	#4,A7			;425b2: 584f
	CMP.W	#$0001,D0		;425b4: b07c0001
	BEQ.S	LAB_425EE		;425b8: 6734
	MOVE.W	(A2),D5			;425ba: 3a12
	ADD.W	(-2,A5),D5		;425bc: da6dfffe
	LEA	(_map_bk2,A4),A0	;425c0: 41ecef88
	CLR.B	(0,A0,D5.W)		;425c4: 42305000
	MOVEA.L	(8,A5),A0		;425c8: 206d0008
	MOVEQ	#0,D0			;425cc: 7000
	MOVE.B	(1,A0),D0		;425ce: 10280001
	ADD.W	#$001f,D0		;425d2: d07c001f
	LEA	(_map_blk,A4),A0	;425d6: 41eccf88
	MOVEQ	#0,D1			;425da: 7200
	MOVE.B	(0,A0,D5.W),D1		;425dc: 12305000
	CMP.W	D1,D0			;425e0: b041
	BNE.S	LAB_425EE		;425e2: 660a
	LEA	(_map_blk,A4),A0	;425e4: 41eccf88
	MOVE.B	#$0f,(0,A0,D5.W)	;425e8: 11bc000f5000
LAB_425EE:
	ADDQ.W	#1,D4			;425ee: 5244
	ADDQ.L	#2,A2			;425f0: 548a
	CMP.W	#$0019,D4		;425f2: b87c0019
	BLT.S	LAB_425A8		;425f6: 6db0
	LEA	(_offset_vector,A4),A0	;425f8: 41ec842c
	MOVEA.L	A0,A2			;425fc: 2448
LAB_425FE:
	MOVEQ	#0,D4			;425fe: 7800
LAB_42600:
	MOVE.W	(A2),-(A7)		;42600: 3f12
	MOVE.W	(-2,A5),-(A7)		;42602: 3f2dfffe
	JSR	(___valid_move,A4)	;42606: 4eac817c
	ADDQ.W	#4,A7			;4260a: 584f
	CMP.W	#$0001,D0		;4260c: b07c0001
	BEQ.S	LAB_42646		;42610: 6734
	MOVE.W	(A2),D5			;42612: 3a12
	ADD.W	(-2,A5),D5		;42614: da6dfffe
	CMP.W	#$0009,D4		;42618: b87c0009
	BGE.S	LAB_42626		;4261c: 6c08
	LEA	(_map_bk2,A4),A0	;4261e: 41ecef88
	CLR.B	(0,A0,D5.W)		;42622: 42305000
LAB_42626:
	LEA	(_map_blk,A4),A0	;42626: 41eccf88
	CMPI.B	#$0f,(0,A0,D5.W)	;4262a: 0c30000f5000
	BNE.S	LAB_42646		;42630: 6614
	LEA	(_map_blk,A4),A0	;42632: 41eccf88
	MOVEA.L	(8,A5),A1		;42636: 226d0008
	MOVE.B	(1,A1),D0		;4263a: 10290001
	ADD.B	#$1f,D0			;4263e: d03c001f
	MOVE.B	D0,(0,A0,D5.W)		;42642: 11805000
LAB_42646:
	ADDQ.W	#1,D4			;42646: 5244
	ADDQ.L	#2,A2			;42648: 548a
	CMP.W	#$0011,D4		;4264a: b87c0011
	BLT.S	LAB_42600		;4264e: 6db0
	MOVEA.L	(8,A5),A0		;42650: 206d0008
	MOVEQ	#0,D0			;42654: 7000
	MOVE.B	(1,A0),D0		;42656: 10280001
	ADD.W	#$001f,D0		;4265a: d07c001f
	MOVE.W	(-2,A5),D1		;4265e: 322dfffe
	LEA	(_map_blk,A4),A0	;42662: 41eccf88
	MOVEQ	#0,D2			;42666: 7400
	MOVE.B	(0,A0,D1.W),D2		;42668: 14301000
	CMP.W	D2,D0			;4266c: b042
	BNE.S	LAB_42682		;4266e: 6612
	MOVEA.L	(8,A5),A0		;42670: 206d0008
	MOVE.W	(-2,A5),D0		;42674: 302dfffe
	LEA	(_map_bk2,A4),A1	;42678: 43ecef88
	MOVE.B	($D,A0),(0,A1,D0.W)	;4267c: 13a8000d0000
LAB_42682:
	MOVEM.L	(A7)+,D4-D5/A2		;42682: 4cdf0430
	UNLK	A5			;42686: 4e5d
	RTS				;42688: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_battle:
	LINK.W	A5,#-16			;4268a: 4e55fff0
	MOVEA.L	(8,A5),A0		;4268e: 206d0008
	MOVE.W	(6,A0),D0		;42692: 30280006
	MULU	#$0016,D0		;42696: c0fc0016
	LEA	(_peeps,A4),A0		;4269a: 41ec9c26
	ADD.L	A0,D0			;4269e: d088
	MOVE.L	D0,(-16,A5)		;426a0: 2b40fff0
	MOVE.W	(_toggle,A4),D0		;426a4: 302c9a1a
	MULS	#$0007,D0		;426a8: c1fc0007
	ADDQ.W	#8,D0			;426ac: 5040
	MOVE.W	D0,-(A7)		;426ae: 3f00
	MOVEA.L	(8,A5),A0		;426b0: 206d0008
	MOVE.W	(8,A0),-(A7)		;426b4: 3f280008
	JSR	(___a_putpixel,A4)	;426b8: 4eac80ce
	ADDQ.W	#4,A7			;426bc: 584f
	MOVEA.L	(-16,A5),A0		;426be: 206dfff0
	MOVE.L	A0,-(A7)		;426c2: 2f08
	JSR	(___newrand,A4)		;426c4: 4eac80fe
	EXT.L	D0			;426c8: 48c0
	DIVS	#$0003,D0		;426ca: 81fc0003
	SWAP	D0			;426ce: 4840
	ADDQ.W	#1,D0			;426d0: 5240
	MOVEA.L	(A7)+,A0		;426d2: 205f
	MULS	(4,A0),D0		;426d4: c1e80004
	MOVE.L	D0,(-6,A5)		;426d8: 2b40fffa
	MOVEA.L	(8,A5),A0		;426dc: 206d0008
	MOVE.L	A0,-(A7)		;426e0: 2f08
	JSR	(___newrand,A4)		;426e2: 4eac80fe
	EXT.L	D0			;426e6: 48c0
	DIVS	#$0003,D0		;426e8: 81fc0003
	SWAP	D0			;426ec: 4840
	ADDQ.W	#1,D0			;426ee: 5240
	MOVEA.L	(A7)+,A0		;426f0: 205f
	MULS	(4,A0),D0		;426f2: c1e80004
	MOVE.L	D0,(-10,A5)		;426f6: 2b40fff6
	MOVE.L	(-6,A5),D0		;426fa: 202dfffa
	CMP.L	(-10,A5),D0		;426fe: b0adfff6
	BLE.S	LAB_4275E		;42702: 6f5a
	MOVEA.L	(-16,A5),A0		;42704: 206dfff0
	MOVEA.L	(8,A5),A1		;42708: 226d0008
	MOVEQ	#0,D0			;4270c: 7000
	MOVE.B	(3,A1),D0		;4270e: 10290003
	MOVEQ	#$64,D1			;42712: 7264
	MOVE.L	D0,-(A7)		;42714: 2f00
	MOVE.L	(-10,A5),D0		;42716: 202dfff6
	JSR	(___divs,A4)		;4271a: 4eac81ca
	MOVE.L	D0,D1			;4271e: 2200
	MOVE.L	(A7)+,D0		;42720: 201f
	JSR	(___mulu,A4)		;42722: 4eac81c4
	ADD.L	#$0000000a,D0		;42726: d0bc0000000a
	SUB.W	D0,(4,A0)		;4272c: 91680004
	MOVEA.L	(8,A5),A0		;42730: 206d0008
	MOVEA.L	(-16,A5),A1		;42734: 226dfff0
	MOVEQ	#0,D0			;42738: 7000
	MOVE.B	(3,A1),D0		;4273a: 10290003
	MOVEQ	#$64,D1			;4273e: 7264
	MOVE.L	D0,-(A7)		;42740: 2f00
	MOVE.L	(-10,A5),D0		;42742: 202dfff6
	JSR	(___divs,A4)		;42746: 4eac81ca
	MOVE.L	D0,D1			;4274a: 2200
	MOVE.L	(A7)+,D0		;4274c: 201f
	JSR	(___mulu,A4)		;4274e: 4eac81c4
	ADD.L	#$0000000a,D0		;42752: d0bc0000000a
	SUB.W	D0,(4,A0)		;42758: 91680004
	BRA.S	LAB_427B6		;4275c: 6058
LAB_4275E:
	MOVEA.L	(8,A5),A0		;4275e: 206d0008
	MOVEA.L	(-16,A5),A1		;42762: 226dfff0
	MOVEQ	#0,D0			;42766: 7000
	MOVE.B	(3,A1),D0		;42768: 10290003
	MOVEQ	#$64,D1			;4276c: 7264
	MOVE.L	D0,-(A7)		;4276e: 2f00
	MOVE.L	(-6,A5),D0		;42770: 202dfffa
	JSR	(___divs,A4)		;42774: 4eac81ca
	MOVE.L	D0,D1			;42778: 2200
	MOVE.L	(A7)+,D0		;4277a: 201f
	JSR	(___mulu,A4)		;4277c: 4eac81c4
	ADD.L	#$0000000a,D0		;42780: d0bc0000000a
	SUB.W	D0,(4,A0)		;42786: 91680004
	MOVEA.L	(-16,A5),A0		;4278a: 206dfff0
	MOVEA.L	(8,A5),A1		;4278e: 226d0008
	MOVEQ	#0,D0			;42792: 7000
	MOVE.B	(3,A1),D0		;42794: 10290003
	MOVEQ	#$64,D1			;42798: 7264
	MOVE.L	D0,-(A7)		;4279a: 2f00
	MOVE.L	(-6,A5),D0		;4279c: 202dfffa
	JSR	(___divs,A4)		;427a0: 4eac81ca
	MOVE.L	D0,D1			;427a4: 2200
	MOVE.L	(A7)+,D0		;427a6: 201f
	JSR	(___mulu,A4)		;427a8: 4eac81c4
	ADD.L	#$0000000a,D0		;427ac: d0bc0000000a
	SUB.W	D0,(4,A0)		;427b2: 91680004
LAB_427B6:
	MOVE.L	(8,A5),-(A7)		;427b6: 2f2d0008
	JSR	(_set_frame,PC)		;427ba: 4ebafb16
	ADDQ.W	#4,A7			;427be: 584f
	MOVE.L	(-16,A5),-(A7)		;427c0: 2f2dfff0
	JSR	(_set_frame,PC)		;427c4: 4ebafb0c
	ADDQ.W	#4,A7			;427c8: 584f
	MOVEA.L	(8,A5),A0		;427ca: 206d0008
	TST.W	(4,A0)			;427ce: 4a680004
	BGT.S	LAB_42800		;427d2: 6e2c
	MOVEA.L	(-16,A5),A0		;427d4: 206dfff0
	TST.W	(4,A0)			;427d8: 4a680004
	BGT.S	LAB_42800		;427dc: 6e22
	MOVEA.L	(8,A5),A0		;427de: 206d0008
	MOVE.W	(6,A0),-(A7)		;427e2: 3f280006
	MOVE.L	(-16,A5),-(A7)		;427e6: 2f2dfff0
	JSR	(___zero_population,A4)	;427ea: 4eac803e
	ADDQ.W	#6,A7			;427ee: 5c4f
	MOVE.W	($C,A5),-(A7)		;427f0: 3f2d000c
	MOVE.L	(8,A5),-(A7)		;427f4: 2f2d0008
	JSR	(___zero_population,A4)	;427f8: 4eac803e
	ADDQ.W	#6,A7			;427fc: 5c4f
	BRA.S	LAB_42836		;427fe: 6036
LAB_42800:
	MOVEA.L	(8,A5),A0		;42800: 206d0008
	TST.W	(4,A0)			;42804: 4a680004
	BGT.S	LAB_4281C		;42808: 6e12
	MOVE.W	($C,A5),-(A7)		;4280a: 3f2d000c
	MOVEA.L	(8,A5),A0		;4280e: 206d0008
	MOVE.W	(6,A0),-(A7)		;42812: 3f280006
	BSR.S	_battle_over		;42816: 6122
	ADDQ.W	#4,A7			;42818: 584f
	BRA.S	LAB_42836		;4281a: 601a
LAB_4281C:
	MOVEA.L	(-16,A5),A0		;4281c: 206dfff0
	TST.W	(4,A0)			;42820: 4a680004
	BGT.S	LAB_42836		;42824: 6e10
	MOVEA.L	(8,A5),A0		;42826: 206d0008
	MOVE.W	(6,A0),-(A7)		;4282a: 3f280006
	MOVE.W	($C,A5),-(A7)		;4282e: 3f2d000c
	BSR.S	_battle_over		;42832: 6106
	ADDQ.W	#4,A7			;42834: 584f
LAB_42836:
	UNLK	A5			;42836: 4e5d
	RTS				;42838: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_battle_over:
	LINK.W	A5,#-14			;4283a: 4e55fff2
	CLR.W	(-10,A5)		;4283e: 426dfff6
	MOVE.W	(8,A5),D0		;42842: 302d0008
	MULS	#$0016,D0		;42846: c1fc0016
	LEA	(_peeps,A4),A0		;4284a: 41ec9c26
	ADD.L	A0,D0			;4284e: d088
	MOVE.L	D0,(-4,A5)		;42850: 2b40fffc
	MOVE.W	($A,A5),D0		;42854: 302d000a
	MULS	#$0016,D0		;42858: c1fc0016
	LEA	(_peeps,A4),A0		;4285c: 41ec9c26
	ADD.L	A0,D0			;42860: d088
	MOVE.L	D0,(-8,A5)		;42862: 2b40fff8
	MOVEA.L	(-4,A5),A0		;42866: 206dfffc
	MOVEQ	#0,D0			;4286a: 7000
	MOVE.B	(1,A0),D0		;4286c: 10280001
	ASL.L	#1,D0			;42870: e380
	LEA	(_battle_won,A4),A0	;42872: 41ecae7a
	ADDQ.W	#1,(0,A0,D0.L)		;42876: 52700800
	MOVEA.L	(-8,A5),A0		;4287a: 206dfff8
	BTST	#0,(A0)			;4287e: 08100000
	BEQ.W	LAB_42B0A		;42882: 67000286
	MOVEA.L	(-8,A5),A0		;42886: 206dfff8
	MOVE.B	#$01,(A0)		;4288a: 10bc0001
	MOVE.L	(-8,A5),-(A7)		;4288e: 2f2dfff8
	JSR	(_set_frame,PC)		;42892: 4ebafa3e
	ADDQ.W	#4,A7			;42896: 584f
	MOVEA.L	(-8,A5),A0		;42898: 206dfff8
	MOVE.W	($C,A0),D0		;4289c: 3028000c
	SUB.W	#$0020,D0		;428a0: 907c0020
	MOVE.W	D0,(-10,A5)		;428a4: 3b40fff6
	TST.W	(-10,A5)		;428a8: 4a6dfff6
	BLT.S	LAB_428CA		;428ac: 6d1c
	CMPI.W	#$000a,(-10,A5)		;428ae: 0c6d000afff6
	BGT.S	LAB_428CA		;428b4: 6e14
	MOVE.W	(-10,A5),D0		;428b6: 302dfff6
	EXT.L	D0			;428ba: 48c0
	ASL.L	#1,D0			;428bc: e380
	LEA	(_battle_add1,A4),A0	;428be: 41ec2ffa
	MOVE.W	(0,A0,D0.L),(-10,A5)	;428c2: 3b700800fff6
	BRA.S	LAB_428D0		;428c8: 6006
LAB_428CA:
	MOVE.W	#$0064,(-10,A5)		;428ca: 3b7c0064fff6
LAB_428D0:
	MOVEA.L	(-4,A5),A0		;428d0: 206dfffc
	TST.L	($E,A0)			;428d4: 4aa8000e
	BEQ.W	LAB_42A94		;428d8: 670001ba
	MOVEA.L	(-4,A5),A0		;428dc: 206dfffc
	TST.W	(4,A0)			;428e0: 4a680004
	BEQ.W	LAB_42A94		;428e4: 670001ae
	MOVEA.L	(-8,A5),A0		;428e8: 206dfff8
	MOVE.B	#$80,(A0)		;428ec: 10bc0080
	MOVEA.L	(-8,A5),A0		;428f0: 206dfff8
	MOVE.W	#$0001,(4,A0)		;428f4: 317c00010004
	MOVEA.L	(-8,A5),A0		;428fa: 206dfff8
	MOVE.W	#$0028,(6,A0)		;428fe: 317c00280006
	MOVEA.L	(-4,A5),A0		;42904: 206dfffc
	MOVE.B	#$02,(A0)		;42908: 10bc0002
	MOVEA.L	(-8,A5),A0		;4290c: 206dfff8
	MOVE.W	(8,A0),D0		;42910: 30280008
	LEA	(_map_bk2,A4),A0	;42914: 41ecef88
	CMPI.B	#$2a,(0,A0,D0.W)	;42918: 0c30002a0000
	BNE.W	LAB_429BC		;4291e: 6600009c
	CLR.W	(-12,A5)		;42922: 426dfff4
LAB_42926:
	MOVE.W	(-12,A5),D0		;42926: 302dfff4
	EXT.L	D0			;4292a: 48c0
	ASL.L	#1,D0			;4292c: e380
	LEA	(_offset_vector,A4),A0	;4292e: 41ec842c
	MOVEA.L	(-8,A5),A1		;42932: 226dfff8
	MOVE.W	(0,A0,D0.L),D1		;42936: 32300800
	ADD.W	(8,A1),D1		;4293a: d2690008
	MOVE.W	D1,(-14,A5)		;4293e: 3b41fff2
	CMPI.W	#$0009,(-12,A5)		;42942: 0c6d0009fff4
	BGE.S	LAB_4297E		;42948: 6c34
	TST.W	(-12,A5)		;4294a: 4a6dfff4
	BEQ.S	LAB_4297E		;4294e: 672e
	MOVE.W	(-14,A5),D0		;42950: 302dfff2
	LEA	(_map_bk2,A4),A0	;42954: 41ecef88
	CMPI.B	#$29,(0,A0,D0.W)	;42958: 0c3000290000
	BCS.S	LAB_4297E		;4295e: 651e
	MOVE.W	(-14,A5),D0		;42960: 302dfff2
	LEA	(_map_bk2,A4),A0	;42964: 41ecef88
	CMPI.B	#$2c,(0,A0,D0.W)	;42968: 0c30002c0000
	BHI.S	LAB_4297E		;4296e: 620e
	MOVE.W	(-14,A5),D0		;42970: 302dfff2
	LEA	(_map_bk2,A4),A0	;42974: 41ecef88
	ADDA.W	D0,A0			;42978: d0c0
	ADDI.B	#$15,(A0)		;4297a: 06100015
LAB_4297E:
	MOVEA.L	(-8,A5),A0		;4297e: 206dfff8
	MOVEQ	#0,D0			;42982: 7000
	MOVE.B	(1,A0),D0		;42984: 10280001
	ADD.W	#$001f,D0		;42988: d07c001f
	MOVE.W	(-14,A5),D1		;4298c: 322dfff2
	LEA	(_map_blk,A4),A0	;42990: 41eccf88
	MOVEQ	#0,D2			;42994: 7400
	MOVE.B	(0,A0,D1.W),D2		;42996: 14301000
	CMP.W	D2,D0			;4299a: b042
	BNE.S	LAB_429AC		;4299c: 660e
	MOVE.W	(-14,A5),D0		;4299e: 302dfff2
	LEA	(_map_blk,A4),A0	;429a2: 41eccf88
	MOVE.B	#$42,(0,A0,D0.W)	;429a6: 11bc00420000
LAB_429AC:
	ADDQ.W	#1,(-12,A5)		;429ac: 526dfff4
	CMPI.W	#$0019,(-12,A5)		;429b0: 0c6d0019fff4
	BLT.W	LAB_42926		;429b6: 6d00ff6e
	BRA.S	LAB_42A38		;429ba: 607c
LAB_429BC:
	CLR.W	(-12,A5)		;429bc: 426dfff4
LAB_429C0:
	MOVE.W	(-12,A5),D0		;429c0: 302dfff4
	EXT.L	D0			;429c4: 48c0
	ASL.L	#1,D0			;429c6: e380
	LEA	(_offset_vector,A4),A0	;429c8: 41ec842c
	MOVE.W	(0,A0,D0.L),-(A7)	;429cc: 3f300800
	MOVEA.L	(-8,A5),A0		;429d0: 206dfff8
	MOVE.W	(8,A0),-(A7)		;429d4: 3f280008
	JSR	(___valid_move,A4)	;429d8: 4eac817c
	ADDQ.W	#4,A7			;429dc: 584f
	TST.W	D0			;429de: 4a40
	BNE.S	LAB_42A2C		;429e0: 664a
	MOVE.W	(-12,A5),D0		;429e2: 302dfff4
	EXT.L	D0			;429e6: 48c0
	ASL.L	#1,D0			;429e8: e380
	LEA	(_offset_vector,A4),A0	;429ea: 41ec842c
	MOVEA.L	(-8,A5),A1		;429ee: 226dfff8
	MOVE.W	(0,A0,D0.L),D1		;429f2: 32300800
	ADD.W	(8,A1),D1		;429f6: d2690008
	MOVE.W	D1,(-14,A5)		;429fa: 3b41fff2
	MOVEA.L	(-8,A5),A0		;429fe: 206dfff8
	MOVEQ	#0,D0			;42a02: 7000
	MOVE.B	(1,A0),D0		;42a04: 10280001
	ADD.W	#$001f,D0		;42a08: d07c001f
	MOVE.W	(-14,A5),D1		;42a0c: 322dfff2
	LEA	(_map_blk,A4),A0	;42a10: 41eccf88
	MOVEQ	#0,D2			;42a14: 7400
	MOVE.B	(0,A0,D1.W),D2		;42a16: 14301000
	CMP.W	D2,D0			;42a1a: b042
	BNE.S	LAB_42A2C		;42a1c: 660e
	MOVE.W	(-14,A5),D0		;42a1e: 302dfff2
	LEA	(_map_blk,A4),A0	;42a22: 41eccf88
	MOVE.B	#$42,(0,A0,D0.W)	;42a26: 11bc00420000
LAB_42A2C:
	ADDQ.W	#1,(-12,A5)		;42a2c: 526dfff4
	CMPI.W	#$0011,(-12,A5)		;42a30: 0c6d0011fff4
	BLT.S	LAB_429C0		;42a36: 6d88
LAB_42A38:
	MOVEA.L	(-8,A5),A0		;42a38: 206dfff8
	MOVE.W	(8,A0),(-14,A5)		;42a3c: 3b680008fff2
	MOVE.W	(-14,A5),D0		;42a42: 302dfff2
	LEA	(_map_bk2,A4),A0	;42a46: 41ecef88
	CMPI.B	#$20,(0,A0,D0.W)	;42a4a: 0c3000200000
	BCS.S	LAB_42A70		;42a50: 651e
	MOVE.W	(-14,A5),D0		;42a52: 302dfff2
	LEA	(_map_bk2,A4),A0	;42a56: 41ecef88
	CMPI.B	#$2a,(0,A0,D0.W)	;42a5a: 0c30002a0000
	BHI.S	LAB_42A70		;42a60: 620e
	MOVE.W	(-14,A5),D0		;42a62: 302dfff2
	LEA	(_map_bk2,A4),A0	;42a66: 41ecef88
	ADDA.W	D0,A0			;42a6a: d0c0
	ADDI.B	#$15,(A0)		;42a6c: 06100015
LAB_42A70:
	MOVE.W	(-14,A5),D0		;42a70: 302dfff2
	LEA	(_map_who,A4),A0	;42a74: 41ec1f88
	MOVEQ	#0,D1			;42a78: 7200
	MOVE.B	(0,A0,D0.W),D1		;42a7a: 12300000
	SUBQ.W	#1,D1			;42a7e: 5341
	CMP.W	($A,A5),D1		;42a80: b26d000a
	BNE.S	LAB_42A92		;42a84: 660c
	MOVE.W	(-14,A5),D0		;42a86: 302dfff2
	LEA	(_map_who,A4),A0	;42a8a: 41ec1f88
	CLR.B	(0,A0,D0.W)		;42a8e: 42300000
LAB_42A92:
	BRA.S	LAB_42B08		;42a92: 6074
LAB_42A94:
	MOVE.W	#$0001,-(A7)		;42a94: 3f3c0001
	MOVE.L	(-8,A5),-(A7)		;42a98: 2f2dfff8
	JSR	(_set_town,PC)		;42a9c: 4ebaf99e
	ADDQ.W	#6,A7			;42aa0: 5c4f
	MOVEA.L	(-4,A5),A0		;42aa2: 206dfffc
	MOVE.W	(8,A0),-(A7)		;42aa6: 3f280008
	MOVEA.L	(-4,A5),A0		;42aaa: 206dfffc
	MOVEQ	#0,D0			;42aae: 7000
	MOVE.B	(1,A0),D0		;42ab0: 10280001
	MOVE.W	D0,-(A7)		;42ab4: 3f00
	JSR	(___check_life,A4)	;42ab6: 4eac8182
	ADDQ.W	#4,A7			;42aba: 584f
	TST.W	D0			;42abc: 4a40
	BLE.S	LAB_42AF2		;42abe: 6f32
	MOVEA.L	(-8,A5),A0		;42ac0: 206dfff8
	MOVE.B	#$08,(A0)		;42ac4: 10bc0008
	MOVEA.L	(-4,A5),A0		;42ac8: 206dfffc
	MOVE.B	#$01,(A0)		;42acc: 10bc0001
	MOVEA.L	(-4,A5),A0		;42ad0: 206dfffc
	MOVE.W	(_game_turn,A4),(6,A0)	;42ad4: 316cae6a0006
	MOVE.L	(-4,A5),-(A7)		;42ada: 2f2dfffc
	JSR	(_set_frame,PC)		;42ade: 4ebaf7f2
	ADDQ.W	#4,A7			;42ae2: 584f
	CLR.W	-(A7)			;42ae4: 4267
	MOVE.L	(-4,A5),-(A7)		;42ae6: 2f2dfffc
	JSR	(_set_town,PC)		;42aea: 4ebaf950
	ADDQ.W	#6,A7			;42aee: 5c4f
	BRA.S	LAB_42B08		;42af0: 6016
LAB_42AF2:
	MOVEA.L	(-4,A5),A0		;42af2: 206dfffc
	BTST	#0,(A0)			;42af6: 08100000
	BEQ.S	LAB_42B00		;42afa: 6704
	MOVEQ	#1,D0			;42afc: 7001
	BRA.S	LAB_42B02		;42afe: 6002
LAB_42B00:
	MOVEQ	#2,D0			;42b00: 7002
LAB_42B02:
	MOVEA.L	(-4,A5),A0		;42b02: 206dfffc
	MOVE.B	D0,(A0)			;42b06: 1080
LAB_42B08:
	BRA.S	LAB_42B5C		;42b08: 6052
LAB_42B0A:
	MOVEA.L	(-4,A5),A0		;42b0a: 206dfffc
	BTST	#0,(A0)			;42b0e: 08100000
	BEQ.S	LAB_42B18		;42b12: 6704
	MOVEQ	#1,D0			;42b14: 7001
	BRA.S	LAB_42B1A		;42b16: 6002
LAB_42B18:
	MOVEQ	#2,D0			;42b18: 7002
LAB_42B1A:
	MOVEA.L	(-4,A5),A0		;42b1a: 206dfffc
	MOVE.B	D0,(A0)			;42b1e: 1080
	MOVEA.L	(-8,A5),A0		;42b20: 206dfff8
	TST.L	($E,A0)			;42b24: 4aa8000e
	BEQ.S	LAB_42B32		;42b28: 6708
	MOVE.W	(LAB_5C400,A4),(-10,A5)	;42b2a: 3b6c3012fff6
	BRA.S	LAB_42B5C		;42b30: 602a
LAB_42B32:
	MOVEA.L	(-8,A5),A0		;42b32: 206dfff8
	MOVEQ	#0,D0			;42b36: 7000
	MOVE.B	(1,A0),D0		;42b38: 10280001
	ASL.L	#4,D0			;42b3c: e980
	LEA	(_magnet,A4),A0		;42b3e: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;42b42: 32300800
	SUBQ.W	#1,D1			;42b46: 5341
	CMP.W	($A,A5),D1		;42b48: b26d000a
	BNE.S	LAB_42B56		;42b4c: 6608
	MOVE.W	(LAB_5C402,A4),(-10,A5)	;42b4e: 3b6c3014fff6
	BRA.S	LAB_42B5C		;42b54: 6006
LAB_42B56:
	MOVE.W	(_battle_add2,A4),(-10,A5) ;42b56: 3b6c3010fff6
LAB_42B5C:
	MOVEA.L	(-4,A5),A0		;42b5c: 206dfffc
	MOVE.W	(8,A0),D0		;42b60: 30280008
	LEA	(_map_who,A4),A0	;42b64: 41ec1f88
	MOVEQ	#0,D1			;42b68: 7200
	MOVE.B	(0,A0,D0.W),D1		;42b6a: 12300000
	SUBQ.W	#1,D1			;42b6e: 5341
	CMP.W	($A,A5),D1		;42b70: b26d000a
	BEQ.S	LAB_42B88		;42b74: 6712
	MOVEA.L	(-4,A5),A0		;42b76: 206dfffc
	MOVE.W	(8,A0),D0		;42b7a: 30280008
	LEA	(_map_who,A4),A0	;42b7e: 41ec1f88
	TST.B	(0,A0,D0.W)		;42b82: 4a300000
	BNE.S	LAB_42B9E		;42b86: 6616
LAB_42B88:
	MOVE.W	(8,A5),D0		;42b88: 302d0008
	ADDQ.W	#1,D0			;42b8c: 5240
	MOVEA.L	(-4,A5),A0		;42b8e: 206dfffc
	MOVE.W	(8,A0),D1		;42b92: 32280008
	LEA	(_map_who,A4),A0	;42b96: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;42b9a: 11801000
LAB_42B9E:
	MOVEA.L	(-4,A5),A0		;42b9e: 206dfffc
	TST.B	($14,A0)		;42ba2: 4a280014
	BEQ.S	LAB_42BE8		;42ba6: 6740
	MOVEA.L	(-4,A5),A0		;42ba8: 206dfffc
	MOVEA.L	(-4,A5),A1		;42bac: 226dfffc
	MOVEQ	#0,D0			;42bb0: 7000
	MOVE.B	(1,A1),D0		;42bb2: 10290001
	MOVEQ	#$2E,D1			;42bb6: 722e
	JSR	(___mulu,A4)		;42bb8: 4eac81c4
	LEA	(LAB_516C2,A4),A1	;42bbc: 43ec82d4
	MOVE.W	(8,A0),(0,A1,D0.L)	;42bc0: 33a800080800
	MOVEA.L	(-4,A5),A0		;42bc6: 206dfffc
	MOVEQ	#0,D0			;42bca: 7000
	MOVE.B	(1,A0),D0		;42bcc: 10280001
	MOVEQ	#$2E,D1			;42bd0: 722e
	JSR	(___mulu,A4)		;42bd2: 4eac81c4
	LEA	(LAB_516C0,A4),A0	;42bd6: 41ec82d2
	MOVE.W	#$0002,(0,A0,D0.L)	;42bda: 31bc00020800
	MOVEA.L	(-4,A5),A0		;42be0: 206dfffc
	SUBQ.B	#1,($14,A0)		;42be4: 53280014
LAB_42BE8:
	MOVEA.L	(-8,A5),A0		;42be8: 206dfff8
	TST.B	($14,A0)		;42bec: 4a280014
	BEQ.S	LAB_42C0A		;42bf0: 6718
	MOVEA.L	(-8,A5),A0		;42bf2: 206dfff8
	MOVEQ	#0,D0			;42bf6: 7000
	MOVE.B	(1,A0),D0		;42bf8: 10280001
	MOVEQ	#$2E,D1			;42bfc: 722e
	JSR	(___mulu,A4)		;42bfe: 4eac81c4
	LEA	(LAB_516C0,A4),A0	;42c02: 41ec82d2
	CLR.W	(0,A0,D0.L)		;42c06: 42700800
LAB_42C0A:
	MOVEA.L	(-4,A5),A0		;42c0a: 206dfffc
	CLR.W	($A,A0)			;42c0e: 4268000a
	MOVEA.L	(-4,A5),A0		;42c12: 206dfffc
	BSET	#2,(A0)			;42c16: 08d00002
	MOVEA.L	(-4,A5),A0		;42c1a: 206dfffc
	MOVE.W	#$0055,($C,A0)		;42c1e: 317c0055000c
	MOVEA.L	(-4,A5),A0		;42c24: 206dfffc
	MOVEQ	#0,D0			;42c28: 7000
	MOVE.B	(1,A0),D0		;42c2a: 10280001
	ASL.L	#4,D0			;42c2e: e980
	LEA	(LAB_52DF0,A4),A0	;42c30: 41ec9a02
	ADDA.L	D0,A0			;42c34: d1c0
	MOVE.W	(-10,A5),D0		;42c36: 302dfff6
	EXT.L	D0			;42c3a: 48c0
	ADD.L	D0,(A0)			;42c3c: d190
	MOVEA.L	(-8,A5),A0		;42c3e: 206dfff8
	MOVEQ	#0,D0			;42c42: 7000
	MOVE.B	(1,A0),D0		;42c44: 10280001
	ASL.L	#4,D0			;42c48: e980
	LEA	(LAB_52DF0,A4),A0	;42c4a: 41ec9a02
	ADDA.L	D0,A0			;42c4e: d1c0
	MOVE.W	(-10,A5),D0		;42c50: 302dfff6
	EXT.L	D0			;42c54: 48c0
	SUB.L	D0,(A0)			;42c56: 9190
	MOVEA.L	(-8,A5),A0		;42c58: 206dfff8
	MOVEQ	#0,D0			;42c5c: 7000
	MOVE.B	(1,A0),D0		;42c5e: 10280001
	ASL.L	#4,D0			;42c62: e980
	LEA	(LAB_52DF0,A4),A0	;42c64: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;42c68: 22300800
	CMP.L	(_mana_values,A4),D1	;42c6c: b2ac8486
	BGE.S	LAB_42C88		;42c70: 6c16
	MOVEA.L	(-8,A5),A0		;42c72: 206dfff8
	MOVEQ	#0,D0			;42c76: 7000
	MOVE.B	(1,A0),D0		;42c78: 10280001
	ASL.L	#4,D0			;42c7c: e980
	LEA	(LAB_52DF0,A4),A0	;42c7e: 41ec9a02
	MOVE.L	(_mana_values,A4),(0,A0,D0.L) ;42c82: 21ac84860800
LAB_42C88:
	MOVE.W	(_view_who,A4),D0	;42c88: 302cae68
	SUBQ.W	#1,D0			;42c8c: 5340
	CMP.W	($A,A5),D0		;42c8e: b06d000a
	BNE.S	LAB_42C9E		;42c92: 660a
	MOVE.W	(8,A5),D0		;42c94: 302d0008
	ADDQ.W	#1,D0			;42c98: 5240
	MOVE.W	D0,(_view_who,A4)	;42c9a: 3940ae68
LAB_42C9E:
	MOVEA.L	(-8,A5),A0		;42c9e: 206dfff8
	TST.W	(4,A0)			;42ca2: 4a680004
	BGT.S	LAB_42CB6		;42ca6: 6e0e
	MOVE.W	($A,A5),-(A7)		;42ca8: 3f2d000a
	MOVE.L	(-8,A5),-(A7)		;42cac: 2f2dfff8
	JSR	(___zero_population,A4)	;42cb0: 4eac803e
	ADDQ.W	#6,A7			;42cb4: 5c4f
LAB_42CB6:
	UNLK	A5			;42cb6: 4e5d
	RTS				;42cb8: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_battle:
	LINK.W	A5,#-8			;42cba: 4e55fff8
	MOVE.W	(8,A5),D0		;42cbe: 302d0008
	MULS	#$0016,D0		;42cc2: c1fc0016
	LEA	(_peeps,A4),A0		;42cc6: 41ec9c26
	ADD.L	A0,D0			;42cca: d088
	MOVE.L	D0,(-4,A5)		;42ccc: 2b40fffc
	MOVE.W	($A,A5),D0		;42cd0: 302d000a
	MULS	#$0016,D0		;42cd4: c1fc0016
	LEA	(_peeps,A4),A0		;42cd8: 41ec9c26
	ADD.L	A0,D0			;42cdc: d088
	MOVE.L	D0,(-8,A5)		;42cde: 2b40fff8
	MOVEA.L	(-4,A5),A0		;42ce2: 206dfffc
	MOVE.B	#$08,(A0)		;42ce6: 10bc0008
	MOVEA.L	(-8,A5),A0		;42cea: 206dfff8
	MOVEQ	#0,D0			;42cee: 7000
	MOVE.B	(A0),D0			;42cf0: 1010
	AND.W	#$0007,D0		;42cf2: c07c0007
	BSET	#3,D0			;42cf6: 08c00003
	MOVEA.L	(-8,A5),A0		;42cfa: 206dfff8
	MOVE.B	D0,(A0)			;42cfe: 1080
	MOVEA.L	(-4,A5),A0		;42d00: 206dfffc
	MOVE.W	($A,A5),(6,A0)		;42d04: 316d000a0006
	MOVEA.L	(-8,A5),A0		;42d0a: 206dfff8
	MOVE.W	(8,A5),(6,A0)		;42d0e: 316d00080006
	MOVE.L	(-4,A5),-(A7)		;42d14: 2f2dfffc
	JSR	(_set_frame,PC)		;42d18: 4ebaf5b8
	ADDQ.W	#4,A7			;42d1c: 584f
	MOVE.L	(-8,A5),-(A7)		;42d1e: 2f2dfff8
	JSR	(_set_frame,PC)		;42d22: 4ebaf5ae
	ADDQ.W	#4,A7			;42d26: 584f
	MOVE.W	(_view_who,A4),D0	;42d28: 302cae68
	SUBQ.W	#1,D0			;42d2c: 5340
	CMP.W	($A,A5),D0		;42d2e: b06d000a
	BNE.S	LAB_42D3E		;42d32: 660a
	MOVE.W	($A,A5),D0		;42d34: 302d000a
	ADDQ.W	#1,D0			;42d38: 5240
	MOVE.W	D0,(_view_who,A4)	;42d3a: 3940ae68
LAB_42D3E:
	MOVEA.L	(-8,A5),A0		;42d3e: 206dfff8
	MOVE.W	(8,A0),D0		;42d42: 30280008
	MOVEA.L	(-8,A5),A0		;42d46: 206dfff8
	SUB.W	($A,A0),D0		;42d4a: 9068000a
	LEA	(_map_who,A4),A0	;42d4e: 41ec1f88
	MOVEQ	#0,D1			;42d52: 7200
	MOVE.B	(0,A0,D0.W),D1		;42d54: 12300000
	SUBQ.W	#1,D1			;42d58: 5341
	CMP.W	($A,A5),D1		;42d5a: b26d000a
	BNE.S	LAB_42D78		;42d5e: 6618
	MOVEA.L	(-8,A5),A0		;42d60: 206dfff8
	MOVE.W	(8,A0),D0		;42d64: 30280008
	MOVEA.L	(-8,A5),A0		;42d68: 206dfff8
	SUB.W	($A,A0),D0		;42d6c: 9068000a
	LEA	(_map_who,A4),A0	;42d70: 41ec1f88
	CLR.B	(0,A0,D0.W)		;42d74: 42300000
LAB_42D78:
	MOVEA.L	(-8,A5),A0		;42d78: 206dfff8
	MOVE.W	(8,A0),D0		;42d7c: 30280008
	LEA	(_map_who,A4),A0	;42d80: 41ec1f88
	MOVEQ	#0,D1			;42d84: 7200
	MOVE.B	(0,A0,D0.W),D1		;42d86: 12300000
	SUBQ.W	#1,D1			;42d8a: 5341
	CMP.W	($A,A5),D1		;42d8c: b26d000a
	BNE.S	LAB_42DA2		;42d90: 6610
	MOVEA.L	(-8,A5),A0		;42d92: 206dfff8
	MOVE.W	(8,A0),D0		;42d96: 30280008
	LEA	(_map_who,A4),A0	;42d9a: 41ec1f88
	CLR.B	(0,A0,D0.W)		;42d9e: 42300000
LAB_42DA2:
	MOVEA.L	(-8,A5),A0		;42da2: 206dfff8
	BTST	#0,(A0)			;42da6: 08100000
	BEQ.S	LAB_42DC4		;42daa: 6718
	MOVE.W	(8,A5),D0		;42dac: 302d0008
	ADDQ.W	#1,D0			;42db0: 5240
	MOVEA.L	(-8,A5),A0		;42db2: 206dfff8
	MOVE.W	(8,A0),D1		;42db6: 32280008
	LEA	(_map_who,A4),A0	;42dba: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;42dbe: 11801000
	BRA.S	LAB_42DE8		;42dc2: 6024
LAB_42DC4:
	MOVEA.L	(-4,A5),A0		;42dc4: 206dfffc
	MOVEA.L	(-8,A5),A1		;42dc8: 226dfff8
	MOVE.W	(8,A0),(8,A1)		;42dcc: 336800080008
	MOVE.W	(8,A5),D0		;42dd2: 302d0008
	ADDQ.W	#1,D0			;42dd6: 5240
	MOVEA.L	(-4,A5),A0		;42dd8: 206dfffc
	MOVE.W	(8,A0),D1		;42ddc: 32280008
	LEA	(_map_who,A4),A0	;42de0: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;42de4: 11801000
LAB_42DE8:
	UNLK	A5			;42de8: 4e5d
	RTS				;42dea: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_join_battle:
	LINK.W	A5,#-8			;42dec: 4e55fff8
	MOVE.W	(8,A5),D0		;42df0: 302d0008
	MULS	#$0016,D0		;42df4: c1fc0016
	LEA	(_peeps,A4),A0		;42df8: 41ec9c26
	ADD.L	A0,D0			;42dfc: d088
	MOVE.L	D0,(-4,A5)		;42dfe: 2b40fffc
	MOVE.W	($A,A5),D0		;42e02: 302d000a
	MULS	#$0016,D0		;42e06: c1fc0016
	LEA	(_peeps,A4),A0		;42e0a: 41ec9c26
	ADD.L	A0,D0			;42e0e: d088
	MOVE.L	D0,(-8,A5)		;42e10: 2b40fff8
	MOVEA.L	(-4,A5),A0		;42e14: 206dfffc
	MOVEA.L	(-8,A5),A1		;42e18: 226dfff8
	MOVE.B	(1,A0),D0		;42e1c: 10280001
	CMP.B	(1,A1),D0		;42e20: b0290001
	BEQ.S	LAB_42E42		;42e24: 671c
	MOVEA.L	(-8,A5),A0		;42e26: 206dfff8
	MOVE.W	(6,A0),($A,A5)		;42e2a: 3b680006000a
	MOVE.W	($A,A5),D0		;42e30: 302d000a
	MULS	#$0016,D0		;42e34: c1fc0016
	LEA	(_peeps,A4),A0		;42e38: 41ec9c26
	ADD.L	A0,D0			;42e3c: d088
	MOVE.L	D0,(-8,A5)		;42e3e: 2b40fff8
LAB_42E42:
	MOVEA.L	(-4,A5),A0		;42e42: 206dfffc
	MOVE.W	(4,A0),D0		;42e46: 30280004
	EXT.L	D0			;42e4a: 48c0
	MOVEA.L	(-8,A5),A0		;42e4c: 206dfff8
	MOVE.W	(4,A0),D1		;42e50: 32280004
	EXT.L	D1			;42e54: 48c1
	ADD.L	D1,D0			;42e56: d081
	CMP.L	#$00007d00,D0		;42e58: b0bc00007d00
	BLE.S	LAB_42E6C		;42e5e: 6f0c
	MOVEA.L	(-8,A5),A0		;42e60: 206dfff8
	MOVE.W	#$7d00,(4,A0)		;42e64: 317c7d000004
	BRA.S	LAB_42E7C		;42e6a: 6010
LAB_42E6C:
	MOVEA.L	(-8,A5),A0		;42e6c: 206dfff8
	MOVEA.L	(-4,A5),A1		;42e70: 226dfffc
	MOVE.W	(4,A1),D0		;42e74: 30290004
	ADD.W	D0,(4,A0)		;42e78: d1680004
LAB_42E7C:
	MOVEA.L	(-4,A5),A0		;42e7c: 206dfffc
	MOVEQ	#0,D0			;42e80: 7000
	MOVE.B	(1,A0),D0		;42e82: 10280001
	ASL.L	#4,D0			;42e86: e980
	LEA	(_magnet,A4),A0		;42e88: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;42e8c: 32300800
	SUBQ.W	#1,D1			;42e90: 5341
	CMP.W	(8,A5),D1		;42e92: b26d0008
	BNE.S	LAB_42EB2		;42e96: 661a
	MOVEA.L	(-4,A5),A0		;42e98: 206dfffc
	MOVEQ	#0,D0			;42e9c: 7000
	MOVE.B	(1,A0),D0		;42e9e: 10280001
	ASL.L	#4,D0			;42ea2: e980
	LEA	(_magnet,A4),A0		;42ea4: 41ec99f6
	MOVE.W	($A,A5),D1		;42ea8: 322d000a
	ADDQ.W	#1,D1			;42eac: 5241
	MOVE.W	D1,(0,A0,D0.L)		;42eae: 31810800
LAB_42EB2:
	MOVE.W	(_view_who,A4),D0	;42eb2: 302cae68
	SUBQ.W	#1,D0			;42eb6: 5340
	CMP.W	(8,A5),D0		;42eb8: b06d0008
	BNE.S	LAB_42EC8		;42ebc: 660a
	MOVE.W	($A,A5),D0		;42ebe: 302d000a
	ADDQ.W	#1,D0			;42ec2: 5240
	MOVE.W	D0,(_view_who,A4)	;42ec4: 3940ae68
LAB_42EC8:
	MOVE.W	($A,A5),D0		;42ec8: 302d000a
	CMP.W	(8,A5),D0		;42ecc: b06d0008
	BLE.S	LAB_42EF0		;42ed0: 6f1e
	MOVEA.L	(-4,A5),A0		;42ed2: 206dfffc
	MOVEQ	#0,D0			;42ed6: 7000
	MOVE.B	(1,A0),D0		;42ed8: 10280001
	ASL.L	#4,D0			;42edc: e980
	LEA	(good_pop,A4),A0	;42ede: 41ec99fe
	ADDA.L	D0,A0			;42ee2: d1c0
	MOVEA.L	(-4,A5),A1		;42ee4: 226dfffc
	MOVE.W	(4,A1),D0		;42ee8: 30290004
	EXT.L	D0			;42eec: 48c0
	SUB.L	D0,(A0)			;42eee: 9190
LAB_42EF0:
	MOVEA.L	(-4,A5),A0		;42ef0: 206dfffc
	TST.L	($E,A0)			;42ef4: 4aa8000e
	BEQ.S	LAB_42F08		;42ef8: 670e
	MOVEA.L	(-4,A5),A0		;42efa: 206dfffc
	MOVEA.L	(-8,A5),A1		;42efe: 226dfff8
	MOVE.L	($E,A0),($E,A1)		;42f02: 2368000e000e
LAB_42F08:
	MOVEA.L	(-4,A5),A0		;42f08: 206dfffc
	MOVEA.L	(-8,A5),A1		;42f0c: 226dfff8
	MOVE.B	(3,A0),D0		;42f10: 10280003
	CMP.B	(3,A1),D0		;42f14: b0290003
	BLS.S	LAB_42F28		;42f18: 630e
	MOVEA.L	(-4,A5),A0		;42f1a: 206dfffc
	MOVEA.L	(-8,A5),A1		;42f1e: 226dfff8
	MOVE.B	(3,A0),(3,A1)		;42f22: 136800030003
LAB_42F28:
	MOVEA.L	(-4,A5),A0		;42f28: 206dfffc
	CLR.W	(4,A0)			;42f2c: 42680004
	UNLK	A5			;42f30: 4e5d
	RTS				;42f32: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_magnet:
	LINK.W	A5,#0			;42f34: 4e550000
	MOVE.W	(8,A5),D0		;42f38: 302d0008
	EXT.L	D0			;42f3c: 48c0
	ASL.L	#4,D0			;42f3e: e980
	LEA	(LAB_52DF0,A4),A0	;42f40: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;42f44: 22300800
	CMP.L	(LAB_5187C,A4),D1	;42f48: b2ac848e
	BLT.S	LAB_42FC6		;42f4c: 6d78
	MOVE.W	(8,A5),D0		;42f4e: 302d0008
	EXT.L	D0			;42f52: 48c0
	ASL.L	#4,D0			;42f54: e980
	LEA	(_magnet,A4),A0		;42f56: 41ec99f6
	TST.W	(0,A0,D0.L)		;42f5a: 4a700800
	BEQ.S	LAB_42FC6		;42f5e: 6766
	TST.W	(_war,A4)		;42f60: 4a6cae80
	BNE.S	LAB_42FC6		;42f64: 6660
	MOVE.W	#$004d,(_effect,A4)	;42f66: 397c004d2fac
	MOVE.W	(8,A5),D0		;42f6c: 302d0008
	EXT.L	D0			;42f70: 48c0
	ASL.L	#4,D0			;42f72: e980
	LEA	(LAB_52DF0,A4),A0	;42f74: 41ec9a02
	ADDA.L	D0,A0			;42f78: d1c0
	MOVE.L	(LAB_5187C,A4),D0	;42f7a: 202c848e
	SUB.L	D0,(A0)			;42f7e: 9190
	CMPI.W	#$0040,($A,A5)		;42f80: 0c6d0040000a
	BLT.S	LAB_42F8E		;42f86: 6d06
	MOVE.W	#$003f,($A,A5)		;42f88: 3b7c003f000a
LAB_42F8E:
	TST.W	($A,A5)			;42f8e: 4a6d000a
	BGE.S	LAB_42F98		;42f92: 6c04
	CLR.W	($A,A5)			;42f94: 426d000a
LAB_42F98:
	CMPI.W	#$0040,($C,A5)		;42f98: 0c6d0040000c
	BLT.S	LAB_42FA6		;42f9e: 6d06
	MOVE.W	#$003f,($C,A5)		;42fa0: 3b7c003f000c
LAB_42FA6:
	TST.W	($C,A5)			;42fa6: 4a6d000c
	BGE.S	LAB_42FB0		;42faa: 6c04
	CLR.W	($C,A5)			;42fac: 426d000c
LAB_42FB0:
	MOVE.W	($C,A5),D0		;42fb0: 302d000c
	ASL.W	#6,D0			;42fb4: ed40
	ADD.W	($A,A5),D0		;42fb6: d06d000a
	MOVE.W	D0,-(A7)		;42fba: 3f00
	MOVE.W	(8,A5),-(A7)		;42fbc: 3f2d0008
	JSR	(_set_magnet_to,PC)	;42fc0: 4eba110a
	ADDQ.W	#4,A7			;42fc4: 584f
LAB_42FC6:
	UNLK	A5			;42fc6: 4e5d
	RTS				;42fc8: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_rotate_all_map:
	LINK.W	A5,#-2			;42fca: 4e55fffe
	MOVEM.L	D4-D5,-(A7)		;42fce: 48e70c00
	MOVE.W	#$1080,D5		;42fd2: 3a3c1080
	MOVEQ	#0,D4			;42fd6: 7800
	BRA.S	LAB_43034		;42fd8: 605a
LAB_42FDA:
	MOVE.W	D4,D0			;42fda: 3004
	EXT.L	D0			;42fdc: 48c0
	ASL.L	#1,D0			;42fde: e380
	LEA	(_alt,A4),A0		;42fe0: 41ecae86
	MOVE.W	D5,D1			;42fe4: 3205
	SUB.W	D4,D1			;42fe6: 9244
	EXT.L	D1			;42fe8: 48c1
	ASL.L	#1,D1			;42fea: e381
	LEA	(_alt,A4),A1		;42fec: 43ecae86
	MOVE.W	(0,A0,D0.L),D2		;42ff0: 34300800
	CMP.W	(0,A1,D1.L),D2		;42ff4: b4711800
	BGE.S	LAB_43016		;42ff8: 6c1c
	MOVE.W	D5,D0			;42ffa: 3005
	SUB.W	D4,D0			;42ffc: 9044
	EXT.L	D0			;42ffe: 48c0
	ASL.L	#1,D0			;43000: e380
	LEA	(_alt,A4),A0		;43002: 41ecae86
	MOVE.W	D4,D1			;43006: 3204
	EXT.L	D1			;43008: 48c1
	ASL.L	#1,D1			;4300a: e381
	LEA	(_alt,A4),A1		;4300c: 43ecae86
	MOVE.W	(0,A0,D0.L),(0,A1,D1.L)	;43010: 33b008001800
LAB_43016:
	MOVE.W	D4,D0			;43016: 3004
	EXT.L	D0			;43018: 48c0
	ASL.L	#1,D0			;4301a: e380
	LEA	(_alt,A4),A0		;4301c: 41ecae86
	MOVE.W	D5,D1			;43020: 3205
	SUB.W	D4,D1			;43022: 9244
	EXT.L	D1			;43024: 48c1
	ASL.L	#1,D1			;43026: e381
	LEA	(_alt,A4),A1		;43028: 43ecae86
	MOVE.W	(0,A0,D0.L),(0,A1,D1.L)	;4302c: 33b008001800
	ADDQ.W	#1,D4			;43032: 5244
LAB_43034:
	MOVE.W	D5,D0			;43034: 3005
	ASR.W	#1,D0			;43036: e240
	CMP.W	D0,D4			;43038: b840
	BLT.S	LAB_42FDA		;4303a: 6d9e
	MOVE.W	#$0fff,D5		;4303c: 3a3c0fff
	MOVEQ	#0,D4			;43040: 7800
	BRA.S	LAB_430A4		;43042: 6060
LAB_43044:
	LEA	(_map_bk2,A4),A0	;43044: 41ecef88
	CMPI.B	#$32,(0,A0,D4.W)	;43048: 0c3000324000
	BCS.S	LAB_43070		;4304e: 6520
	LEA	(_map_bk2,A4),A0	;43050: 41ecef88
	CMPI.B	#$37,(0,A0,D4.W)	;43054: 0c3000374000
	BHI.S	LAB_43070		;4305a: 6214
	LEA	(_map_bk2,A4),A0	;4305c: 41ecef88
	MOVE.W	D5,D0			;43060: 3005
	SUB.W	D4,D0			;43062: 9044
	LEA	(_map_bk2,A4),A1	;43064: 43ecef88
	MOVE.B	(0,A0,D4.W),(0,A1,D0.W)	;43068: 13b040000000
	BRA.S	LAB_430A2		;4306e: 6032
LAB_43070:
	MOVE.W	D5,D0			;43070: 3005
	SUB.W	D4,D0			;43072: 9044
	LEA	(_map_bk2,A4),A0	;43074: 41ecef88
	CMPI.B	#$32,(0,A0,D0.W)	;43078: 0c3000320000
	BCS.S	LAB_430A2		;4307e: 6522
	MOVE.W	D5,D0			;43080: 3005
	SUB.W	D4,D0			;43082: 9044
	LEA	(_map_bk2,A4),A0	;43084: 41ecef88
	CMPI.B	#$37,(0,A0,D0.W)	;43088: 0c3000370000
	BHI.S	LAB_430A2		;4308e: 6212
	MOVE.W	D5,D0			;43090: 3005
	SUB.W	D4,D0			;43092: 9044
	LEA	(_map_bk2,A4),A0	;43094: 41ecef88
	LEA	(_map_bk2,A4),A1	;43098: 43ecef88
	MOVE.B	(0,A0,D0.W),(0,A1,D4.W)	;4309c: 13b000004000
LAB_430A2:
	ADDQ.W	#1,D4			;430a2: 5244
LAB_430A4:
	MOVE.W	D5,D0			;430a4: 3005
	ASR.W	#1,D0			;430a6: e240
	CMP.W	D0,D4			;430a8: b840
	BLT.S	LAB_43044		;430aa: 6d98
	MOVE.W	#$003f,-(A7)		;430ac: 3f3c003f
	MOVE.W	#$003f,-(A7)		;430b0: 3f3c003f
	CLR.W	-(A7)			;430b4: 4267
	CLR.W	-(A7)			;430b6: 4267
	JSR	(___make_map,A4)	;430b8: 4eac8020
	ADDQ.W	#8,A7			;430bc: 504f
	MOVE.W	#$003f,-(A7)		;430be: 3f3c003f
	MOVE.W	#$003f,-(A7)		;430c2: 3f3c003f
	CLR.W	-(A7)			;430c6: 4267
	CLR.W	-(A7)			;430c8: 4267
	JSR	(___draw_map,A4)	;430ca: 4eac8026
	ADDQ.W	#8,A7			;430ce: 504f
	MOVEM.L	(A7)+,D4-D5		;430d0: 4cdf0030
	UNLK	A5			;430d4: 4e5d
	RTS				;430d6: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_clear_all_map:
	LINK.W	A5,#0			;430d8: 4e550000
	MOVE.L	D4,-(A7)		;430dc: 2f04
	MOVEQ	#0,D4			;430de: 7800
LAB_430E0:
	MOVE.W	D4,D0			;430e0: 3004
	EXT.L	D0			;430e2: 48c0
	ASL.L	#1,D0			;430e4: e380
	LEA	(_alt,A4),A0		;430e6: 41ecae86
	CLR.W	(0,A0,D0.L)		;430ea: 42700800
	CMP.W	#$1000,D4		;430ee: b87c1000
	BGE.S	LAB_4310C		;430f2: 6c18
	LEA	(_map_who,A4),A0	;430f4: 41ec1f88
	CLR.B	(0,A0,D4.W)		;430f8: 42304000
	LEA	(_map_bk2,A4),A0	;430fc: 41ecef88
	CLR.B	(0,A0,D4.W)		;43100: 42304000
	LEA	(_map_blk,A4),A0	;43104: 41eccf88
	CLR.B	(0,A0,D4.W)		;43108: 42304000
LAB_4310C:
	ADDQ.W	#1,D4			;4310c: 5244
	CMP.W	#$1081,D4		;4310e: b87c1081
	BLT.S	LAB_430E0		;43112: 6dcc
	MOVEQ	#0,D4			;43114: 7800
	BRA.S	LAB_43130		;43116: 6018
LAB_43118:
	MOVE.W	D4,-(A7)		;43118: 3f04
	MOVE.W	D4,D0			;4311a: 3004
	MULS	#$0016,D0		;4311c: c1fc0016
	LEA	(_peeps,A4),A0		;43120: 41ec9c26
	ADD.L	A0,D0			;43124: d088
	MOVE.L	D0,-(A7)		;43126: 2f00
	JSR	(___zero_population,A4)	;43128: 4eac803e
	ADDQ.W	#6,A7			;4312c: 5c4f
	ADDQ.W	#1,D4			;4312e: 5244
LAB_43130:
	CMP.W	(_no_peeps,A4),D4	;43130: b86cae5e
	BLT.S	LAB_43118		;43134: 6de2
	CLR.W	(_no_peeps,A4)		;43136: 426cae5e
	MOVE.W	#$003f,-(A7)		;4313a: 3f3c003f
	MOVE.W	#$003f,-(A7)		;4313e: 3f3c003f
	CLR.W	-(A7)			;43142: 4267
	CLR.W	-(A7)			;43144: 4267
	JSR	(___make_map,A4)	;43146: 4eac8020
	ADDQ.W	#8,A7			;4314a: 504f
	MOVE.W	#$003f,-(A7)		;4314c: 3f3c003f
	MOVE.W	#$003f,-(A7)		;43150: 3f3c003f
	CLR.W	-(A7)			;43154: 4267
	CLR.W	-(A7)			;43156: 4267
	JSR	(___draw_map,A4)	;43158: 4eac8026
	ADDQ.W	#8,A7			;4315c: 504f
	MOVE.L	(A7)+,D4		;4315e: 281f
	UNLK	A5			;43160: 4e5d
	RTS				;43162: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_place_people:
	LINK.W	A5,#-2			;43164: 4e55fffe
	CMPI.W	#$00d0,(_no_peeps,A4)	;43168: 0c6c00d0ae5e
	BLT.S	LAB_43174		;4316e: 6d04
LAB_43170:
	UNLK	A5			;43170: 4e5d
	RTS				;43172: 4e75
LAB_43174:
	TST.W	($E,A5)			;43174: 4a6d000e
	BEQ.S	LAB_431BE		;43178: 6744
	MOVE.W	(8,A5),D0		;4317a: 302d0008
	EXT.L	D0			;4317e: 48c0
	ASL.L	#4,D0			;43180: e980
	LEA	(_magnet,A4),A0		;43182: 41ec99f6
	TST.W	(0,A0,D0.L)		;43186: 4a700800
	BEQ.S	LAB_431BE		;4318a: 6732
	MOVE.W	(8,A5),D0		;4318c: 302d0008
	EXT.L	D0			;43190: 48c0
	ASL.L	#4,D0			;43192: e980
	LEA	(_magnet,A4),A0		;43194: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;43198: 32300800
	SUBQ.W	#1,D1			;4319c: 5341
	MOVE.W	D1,(-2,A5)		;4319e: 3b41fffe
	MOVE.W	(-2,A5),-(A7)		;431a2: 3f2dfffe
	MOVE.W	(-2,A5),D0		;431a6: 302dfffe
	MULS	#$0016,D0		;431aa: c1fc0016
	LEA	(_peeps,A4),A0		;431ae: 41ec9c26
	ADD.L	A0,D0			;431b2: d088
	MOVE.L	D0,-(A7)		;431b4: 2f00
	JSR	(___zero_population,A4)	;431b6: 4eac803e
	ADDQ.W	#6,A7			;431ba: 5c4f
	BRA.S	LAB_431CA		;431bc: 600c
LAB_431BE:
	MOVE.W	(_no_peeps,A4),D0	;431be: 302cae5e
	ADDQ.W	#1,(_no_peeps,A4)	;431c2: 526cae5e
	MOVE.W	D0,(-2,A5)		;431c6: 3b40fffe
LAB_431CA:
	MOVE.W	(-2,A5),D0		;431ca: 302dfffe
	MULS	#$0016,D0		;431ce: c1fc0016
	LEA	(LAB_5301A,A4),A0	;431d2: 41ec9c2c
	CLR.W	(0,A0,D0.L)		;431d6: 42700800
	MOVE.W	(-2,A5),D0		;431da: 302dfffe
	MULS	#$0016,D0		;431de: c1fc0016
	LEA	(LAB_53018,A4),A0	;431e2: 41ec9c2a
	MOVE.W	#$002d,(0,A0,D0.L)	;431e6: 31bc002d0800
	MOVE.W	(-2,A5),D0		;431ec: 302dfffe
	MULS	#$0016,D0		;431f0: c1fc0016
	LEA	(LAB_5301C,A4),A0	;431f4: 41ec9c2e
	MOVE.W	($C,A5),D1		;431f8: 322d000c
	ASL.W	#6,D1			;431fc: ed41
	ADD.W	($A,A5),D1		;431fe: d26d000a
	MOVE.W	D1,(0,A0,D0.L)		;43202: 31810800
	MOVE.W	(-2,A5),D0		;43206: 302dfffe
	ADDQ.W	#1,D0			;4320a: 5240
	MOVE.W	(-2,A5),D1		;4320c: 322dfffe
	MULS	#$0016,D1		;43210: c3fc0016
	LEA	(LAB_5301C,A4),A0	;43214: 41ec9c2e
	MOVE.W	(0,A0,D1.L),D2		;43218: 34301800
	LEA	(_map_who,A4),A0	;4321c: 41ec1f88
	MOVE.B	D0,(0,A0,D2.W)		;43220: 11802000
	MOVE.W	(-2,A5),D0		;43224: 302dfffe
	MULS	#$0016,D0		;43228: c1fc0016
	LEA	(LAB_53015,A4),A0	;4322c: 41ec9c27
	MOVE.B	(9,A5),(0,A0,D0.L)	;43230: 11ad00090800
	MOVE.W	(-2,A5),D0		;43236: 302dfffe
	MULS	#$0016,D0		;4323a: c1fc0016
	LEA	(_peeps,A4),A0		;4323e: 41ec9c26
	MOVE.B	#$02,(0,A0,D0.L)	;43242: 11bc00020800
	MOVE.W	(-2,A5),D0		;43248: 302dfffe
	MULS	#$0016,D0		;4324c: c1fc0016
	LEA	(LAB_53020,A4),A0	;43250: 41ec9c32
	MOVE.W	#$00ff,(0,A0,D0.L)	;43254: 31bc00ff0800
	MOVE.W	(-2,A5),D0		;4325a: 302dfffe
	MULS	#$0016,D0		;4325e: c1fc0016
	LEA	(LAB_53016,A4),A0	;43262: 41ec9c28
	MOVE.B	#$01,(0,A0,D0.L)	;43266: 11bc00010800
	MOVE.W	(-2,A5),D0		;4326c: 302dfffe
	MULS	#$0016,D0		;43270: c1fc0016
	LEA	(LAB_5301E,A4),A0	;43274: 41ec9c30
	CLR.W	(0,A0,D0.L)		;43278: 42700800
	MOVE.W	(-2,A5),D0		;4327c: 302dfffe
	MULS	#$0016,D0		;43280: c1fc0016
	LEA	(LAB_53017,A4),A0	;43284: 41ec9c29
	MOVE.B	#$01,(0,A0,D0.L)	;43288: 11bc00010800
	MOVE.W	(-2,A5),D0		;4328e: 302dfffe
	MULS	#$0016,D0		;43292: c1fc0016
	LEA	(LAB_53022,A4),A0	;43296: 41ec9c34
	CLR.L	(0,A0,D0.L)		;4329a: 42b00800
	TST.W	($E,A5)			;4329e: 4a6d000e
	BEQ.S	LAB_432BA		;432a2: 6716
	MOVE.W	(8,A5),D0		;432a4: 302d0008
	EXT.L	D0			;432a8: 48c0
	ASL.L	#4,D0			;432aa: e980
	LEA	(_magnet,A4),A0		;432ac: 41ec99f6
	MOVE.W	(-2,A5),D1		;432b0: 322dfffe
	ADDQ.W	#1,D1			;432b4: 5241
	MOVE.W	D1,(0,A0,D0.L)		;432b6: 31810800
LAB_432BA:
	MOVE.W	(-2,A5),D0		;432ba: 302dfffe
	MULS	#$0016,D0		;432be: c1fc0016
	LEA	(_peeps,A4),A0		;432c2: 41ec9c26
	ADD.L	A0,D0			;432c6: d088
	MOVE.L	D0,-(A7)		;432c8: 2f00
	JSR	(_set_frame,PC)		;432ca: 4ebaf006
	ADDQ.W	#4,A7			;432ce: 584f
	BRA.W	LAB_43170		;432d0: 6000fe9e
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_lower_point:
	LINK.W	A5,#0			;432d4: 4e550000
	MOVE.W	($A,A5),(_xmin,A4)	;432d8: 396d000a2f8a
	MOVE.W	($A,A5),(_xmax,A4)	;432de: 396d000a2f8c
	MOVE.W	($C,A5),(_ymin,A4)	;432e4: 396d000c2f8e
	MOVE.W	($C,A5),(_ymax,A4)	;432ea: 396d000c2f90
	MOVE.W	(8,A5),D0		;432f0: 302d0008
	EXT.L	D0			;432f4: 48c0
	ASL.L	#4,D0			;432f6: e980
	LEA	(LAB_52DF0,A4),A0	;432f8: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;432fc: 22300800
	CMP.L	(LAB_51878,A4),D1	;43300: b2ac848a
	BGE.S	LAB_43310		;43304: 6c0a
	TST.W	(_paint_map,A4)		;43306: 4a6c9c24
	BNE.S	LAB_43310		;4330a: 6604
LAB_4330C:
	UNLK	A5			;4330c: 4e5d
	RTS				;4330e: 4e75
LAB_43310:
	CLR.W	(_build_count,A4)	;43310: 426c2f88
	MOVE.W	($C,A5),-(A7)		;43314: 3f2d000c
	MOVE.W	($A,A5),-(A7)		;43318: 3f2d000a
	JSR	(_lower_point,PC)	;4331c: 4ebacb46
	ADDQ.W	#4,A7			;43320: 584f
	TST.W	(_paint_map,A4)		;43322: 4a6c9c24
	BNE.S	LAB_4334A		;43326: 6622
	TST.W	(_war,A4)		;43328: 4a6cae80
	BNE.S	LAB_4334A		;4332c: 661c
	MOVE.W	(8,A5),D0		;4332e: 302d0008
	EXT.L	D0			;43332: 48c0
	ASL.L	#4,D0			;43334: e980
	LEA	(LAB_52DF0,A4),A0	;43336: 41ec9a02
	ADDA.L	D0,A0			;4333a: d1c0
	MOVE.W	(_build_count,A4),D0	;4333c: 302c2f88
	ASL.W	#2,D0			;43340: e540
	ADD.W	#$000a,D0		;43342: d07c000a
	EXT.L	D0			;43346: 48c0
	SUB.L	D0,(A0)			;43348: 9190
LAB_4334A:
	CMPI.W	#$0001,(_xmin,A4)	;4334a: 0c6c00012f8a
	BGE.S	LAB_43358		;43350: 6c06
	MOVE.W	#$0001,(_xmin,A4)	;43352: 397c00012f8a
LAB_43358:
	CMPI.W	#$003f,(_xmax,A4)	;43358: 0c6c003f2f8c
	BLE.S	LAB_43366		;4335e: 6f06
	MOVE.W	#$003f,(_xmax,A4)	;43360: 397c003f2f8c
LAB_43366:
	CMPI.W	#$0001,(_ymin,A4)	;43366: 0c6c00012f8e
	BGE.S	LAB_43374		;4336c: 6c06
	MOVE.W	#$0001,(_ymin,A4)	;4336e: 397c00012f8e
LAB_43374:
	CMPI.W	#$003f,(_ymax,A4)	;43374: 0c6c003f2f90
	BLE.S	LAB_43382		;4337a: 6f06
	MOVE.W	#$003f,(_ymax,A4)	;4337c: 397c003f2f90
LAB_43382:
	MOVE.W	(_ymax,A4),-(A7)	;43382: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;43386: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;4338a: 302c2f8e
	SUBQ.W	#1,D0			;4338e: 5340
	MOVE.W	D0,-(A7)		;43390: 3f00
	MOVE.W	(_xmin,A4),D0		;43392: 302c2f8a
	SUBQ.W	#1,D0			;43396: 5340
	MOVE.W	D0,-(A7)		;43398: 3f00
	JSR	(___make_map,A4)	;4339a: 4eac8020
	ADDQ.W	#8,A7			;4339e: 504f
	MOVE.W	#$ffff,-(A7)		;433a0: 3f3cffff
	PEA	-1.W			;433a4: 4878ffff
	MOVE.L	(_back_scr,A4),-(A7)	;433a8: 2f2c9874
	JSR	(___Setscreen,A4)	;433ac: 4eac80c2
	LEA	($A,A7),A7		;433b0: 4fef000a
	MOVE.W	(_ymax,A4),-(A7)	;433b4: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;433b8: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;433bc: 302c2f8e
	SUBQ.W	#1,D0			;433c0: 5340
	MOVE.W	D0,-(A7)		;433c2: 3f00
	MOVE.W	(_xmin,A4),D0		;433c4: 302c2f8a
	SUBQ.W	#1,D0			;433c8: 5340
	MOVE.W	D0,-(A7)		;433ca: 3f00
	JSR	(___draw_map,A4)	;433cc: 4eac8026
	ADDQ.W	#8,A7			;433d0: 504f
	MOVE.W	#$ffff,-(A7)		;433d2: 3f3cffff
	PEA	-1.W			;433d6: 4878ffff
	MOVE.L	(_w_screen,A4),-(A7)	;433da: 2f2c99e8
	JSR	(___Setscreen,A4)	;433de: 4eac80c2
	LEA	($A,A7),A7		;433e2: 4fef000a
	BRA.W	LAB_4330C		;433e6: 6000ff24
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_raise_point:
	LINK.W	A5,#0			;433ea: 4e550000
	MOVE.W	(8,A5),D0		;433ee: 302d0008
	EXT.L	D0			;433f2: 48c0
	ASL.L	#4,D0			;433f4: e980
	LEA	(LAB_52DF0,A4),A0	;433f6: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;433fa: 22300800
	CMP.L	(LAB_51878,A4),D1	;433fe: b2ac848a
	BGE.S	LAB_43414		;43402: 6c10
	TST.W	(_paint_map,A4)		;43404: 4a6c9c24
	BNE.S	LAB_43414		;43408: 660a
	TST.W	(_war,A4)		;4340a: 4a6cae80
	BNE.S	LAB_43414		;4340e: 6604
LAB_43410:
	UNLK	A5			;43410: 4e5d
	RTS				;43412: 4e75
LAB_43414:
	MOVE.W	($A,A5),(_xmin,A4)	;43414: 396d000a2f8a
	MOVE.W	($A,A5),(_xmax,A4)	;4341a: 396d000a2f8c
	MOVE.W	($C,A5),(_ymin,A4)	;43420: 396d000c2f8e
	MOVE.W	($C,A5),(_ymax,A4)	;43426: 396d000c2f90
	CLR.W	(_build_count,A4)	;4342c: 426c2f88
	MOVE.W	($C,A5),-(A7)		;43430: 3f2d000c
	MOVE.W	($A,A5),-(A7)		;43434: 3f2d000a
	JSR	(_raise_point,PC)	;43438: 4ebabb18
	ADDQ.W	#4,A7			;4343c: 584f
	TST.W	(_paint_map,A4)		;4343e: 4a6c9c24
	BNE.S	LAB_43466		;43442: 6622
	TST.W	(_war,A4)		;43444: 4a6cae80
	BNE.S	LAB_43466		;43448: 661c
	MOVE.W	(8,A5),D0		;4344a: 302d0008
	EXT.L	D0			;4344e: 48c0
	ASL.L	#4,D0			;43450: e980
	LEA	(LAB_52DF0,A4),A0	;43452: 41ec9a02
	ADDA.L	D0,A0			;43456: d1c0
	MOVE.W	(_build_count,A4),D0	;43458: 302c2f88
	ASL.W	#2,D0			;4345c: e540
	ADD.W	#$000a,D0		;4345e: d07c000a
	EXT.L	D0			;43462: 48c0
	SUB.L	D0,(A0)			;43464: 9190
LAB_43466:
	CMPI.W	#$0001,(_xmin,A4)	;43466: 0c6c00012f8a
	BGE.S	LAB_43474		;4346c: 6c06
	MOVE.W	#$0001,(_xmin,A4)	;4346e: 397c00012f8a
LAB_43474:
	CMPI.W	#$003f,(_xmax,A4)	;43474: 0c6c003f2f8c
	BLE.S	LAB_43482		;4347a: 6f06
	MOVE.W	#$003f,(_xmax,A4)	;4347c: 397c003f2f8c
LAB_43482:
	CMPI.W	#$0001,(_ymin,A4)	;43482: 0c6c00012f8e
	BGE.S	LAB_43490		;43488: 6c06
	MOVE.W	#$0001,(_ymin,A4)	;4348a: 397c00012f8e
LAB_43490:
	CMPI.W	#$003f,(_ymax,A4)	;43490: 0c6c003f2f90
	BLE.S	LAB_4349E		;43496: 6f06
	MOVE.W	#$003f,(_ymax,A4)	;43498: 397c003f2f90
LAB_4349E:
	MOVE.W	(_ymax,A4),-(A7)	;4349e: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;434a2: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;434a6: 302c2f8e
	SUBQ.W	#1,D0			;434aa: 5340
	MOVE.W	D0,-(A7)		;434ac: 3f00
	MOVE.W	(_xmin,A4),D0		;434ae: 302c2f8a
	SUBQ.W	#1,D0			;434b2: 5340
	MOVE.W	D0,-(A7)		;434b4: 3f00
	JSR	(___make_map,A4)	;434b6: 4eac8020
	ADDQ.W	#8,A7			;434ba: 504f
	MOVE.W	#$ffff,-(A7)		;434bc: 3f3cffff
	PEA	-1.W			;434c0: 4878ffff
	MOVE.L	(_back_scr,A4),-(A7)	;434c4: 2f2c9874
	JSR	(___Setscreen,A4)	;434c8: 4eac80c2
	LEA	($A,A7),A7		;434cc: 4fef000a
	MOVE.W	(_ymax,A4),-(A7)	;434d0: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;434d4: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;434d8: 302c2f8e
	SUBQ.W	#1,D0			;434dc: 5340
	MOVE.W	D0,-(A7)		;434de: 3f00
	MOVE.W	(_xmin,A4),D0		;434e0: 302c2f8a
	SUBQ.W	#1,D0			;434e4: 5340
	MOVE.W	D0,-(A7)		;434e6: 3f00
	JSR	(___draw_map,A4)	;434e8: 4eac8026
	ADDQ.W	#8,A7			;434ec: 504f
	MOVE.W	#$ffff,-(A7)		;434ee: 3f3cffff
	PEA	-1.W			;434f2: 4878ffff
	MOVE.L	(_w_screen,A4),-(A7)	;434f6: 2f2c99e8
	JSR	(___Setscreen,A4)	;434fa: 4eac80c2
	LEA	($A,A7),A7		;434fe: 4fef000a
	BRA.W	LAB_43410		;43502: 6000ff0c
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_sculpt:
	LINK.W	A5,#-38			;43506: 4e55ffda
	MOVEM.L	D4-D6,-(A7)		;4350a: 48e70e00
	MOVE.W	#$ffff,(-36,A5)		;4350e: 3b7cffffffdc
	TST.W	(_pause,A4)		;43514: 4a6c9c22
	BEQ.S	LAB_43522		;43518: 6708
LAB_4351A:
	MOVEM.L	(A7)+,D4-D6		;4351a: 4cdf0070
	UNLK	A5			;4351e: 4e5d
	RTS				;43520: 4e75
LAB_43522:
	MOVE.W	(_mousex,A4),D4		;43522: 382c99aa
	MOVE.W	(_mousey,A4),D5		;43526: 3a2cae6e
	MOVE.W	D4,D0			;4352a: 3004
	ASR.W	#1,D0			;4352c: e240
	ADD.W	D5,D0			;4352e: d045
	SUB.W	#$0020,D0		;43530: 907c0020
	MOVE.W	D0,(-2,A5)		;43534: 3b40fffe
	MOVE.W	D4,D0			;43538: 3004
	ASR.W	#1,D0			;4353a: e240
	MOVE.W	D5,D1			;4353c: 3205
	SUB.W	D0,D1			;4353e: 9240
	ADD.W	#$0020,D1		;43540: d27c0020
	MOVE.W	D1,(-4,A5)		;43544: 3b41fffc
	TST.W	(_war,A4)		;43548: 4a6cae80
	BNE.S	LAB_43588		;4354c: 663a
	CMPI.W	#$003e,(-2,A5)		;4354e: 0c6d003efffe
	BLT.S	LAB_43588		;43554: 6d32
	CMPI.W	#$010a,(-2,A5)		;43556: 0c6d010afffe
	BGT.S	LAB_43588		;4355c: 6e2a
	CMPI.W	#$ffc0,(-4,A5)		;4355e: 0c6dffc0fffc
	BLT.S	LAB_43588		;43564: 6d22
	CMPI.W	#$0088,(-4,A5)		;43566: 0c6d0088fffc
	BGT.S	LAB_43588		;4356c: 6e1a
	CMP.W	#$0040,D4		;4356e: b87c0040
	BLT.S	LAB_43588		;43572: 6d14
	TST.W	(_ok_to_build,A4)	;43574: 4a6c9a1e
	BNE.S	LAB_4358C		;43578: 6612
	CMPI.W	#$0002,(_mode,A4)	;4357a: 0c6c00028256
	BNE.S	LAB_4358C		;43580: 660a
	TST.W	(_paint_map,A4)		;43582: 4a6c9c24
	BNE.S	LAB_4358C		;43586: 6604
LAB_43588:
	MOVEQ	#0,D0			;43588: 7000
	BRA.S	LAB_4351A		;4358a: 608e
LAB_4358C:
	SUB.W	#$0038,D4		;4358c: 987c0038
	ASR.W	#4,D4			;43590: e844
	MOVE.W	(_xoff,A4),(-26,A5)	;43592: 3b6c99f0ffe6
	MOVE.W	(_yoff,A4),(-28,A5)	;43598: 3b6c99f2ffe4
	MOVE.W	(-28,A5),D0		;4359e: 302dffe4
	MULS	#$0041,D0		;435a2: c1fc0041
	ADD.W	(-26,A5),D0		;435a6: d06dffe6
	MOVE.W	D0,(-30,A5)		;435aa: 3b40ffe2
	MOVE.W	#$0009,(-6,A5)		;435ae: 3b7c0009fffa
	MOVE.W	#$0048,(-32,A5)		;435b4: 3b7c0048ffe0
	CMP.W	#$0008,D4		;435ba: b87c0008
	BLE.S	LAB_435DA		;435be: 6f1a
	MOVEQ	#$11,D0			;435c0: 7011
	SUB.W	D4,D0			;435c2: 9044
	MOVE.W	D0,(-6,A5)		;435c4: 3b40fffa
	MOVE.W	D4,D0			;435c8: 3004
	SUBQ.W	#8,D0			;435ca: 5140
	ADD.W	D0,(-30,A5)		;435cc: d16dffe2
	MOVE.W	D4,D0			;435d0: 3004
	SUBQ.W	#8,D0			;435d2: 5140
	ASL.W	#3,D0			;435d4: e740
	ADD.W	D0,(-32,A5)		;435d6: d16dffe0
LAB_435DA:
	CMP.W	#$0008,D4		;435da: b87c0008
	BGE.S	LAB_435FE		;435de: 6c1e
	MOVE.W	D4,D0			;435e0: 3004
	ADDQ.W	#1,D0			;435e2: 5240
	MOVE.W	D0,(-6,A5)		;435e4: 3b40fffa
	MOVEQ	#8,D0			;435e8: 7008
	SUB.W	D4,D0			;435ea: 9044
	MULS	#$0041,D0		;435ec: c1fc0041
	ADD.W	D0,(-30,A5)		;435f0: d16dffe2
	MOVEQ	#8,D0			;435f4: 7008
	SUB.W	D4,D0			;435f6: 9044
	ASL.W	#3,D0			;435f8: e740
	ADD.W	D0,(-32,A5)		;435fa: d16dffe0
; ------------------------------------------------------------------------------
; lines cut
; ------------------------------------------------------------------------------
LAB_435FE:
	MOVEQ	#0,D6			;435fe: 7c00
	BRA.S	LAB_43664		;43600: 6062
LAB_43602:
	MOVE.W	D6,D0			;43602: 3006
	EXT.L	D0			;43604: 48c0
	ASL.L	#1,D0			;43606: e380
	LEA	(-24,A5),A0		;43608: 41edffe8
	MOVE.W	D6,D1			;4360c: 3206
	MULS	#$0042,D1		;4360e: c3fc0042
	ADD.W	(-30,A5),D1		;43612: d26dffe2
	EXT.L	D1			;43616: 48c1
	ASL.L	#1,D1			;43618: e381
	LEA	(_alt,A4),A1		;4361a: 43ecae86
	MOVE.W	(0,A1,D1.L),D2		;4361e: 34311800
	ASL.W	#3,D2			;43622: e742
	MOVE.W	(-32,A5),D1		;43624: 322dffe0
	SUB.W	D2,D1			;43628: 9242
	MOVE.W	D1,(0,A0,D0.L)		;4362a: 31810800
	ADDI.W	#$0010,(-32,A5)		;4362e: 066d0010ffe0
	MOVE.W	D6,D0			;43634: 3006
	EXT.L	D0			;43636: 48c0
	ASL.L	#1,D0			;43638: e380
	LEA	(-24,A5),A0		;4363a: 41edffe8
	MOVE.W	D5,D1			;4363e: 3205
	ADDQ.W	#4,D1			;43640: 5841
	MOVE.W	(0,A0,D0.L),D2		;43642: 34300800
	CMP.W	D1,D2			;43646: b441
	BGT.S	LAB_43662		;43648: 6e18
	MOVE.W	D6,(-36,A5)		;4364a: 3b46ffdc
	MOVE.W	D6,D0			;4364e: 3006
	EXT.L	D0			;43650: 48c0
	ASL.L	#1,D0			;43652: e380
	LEA	(-24,A5),A0		;43654: 41edffe8
	MOVE.W	(0,A0,D0.L),D1		;43658: 32300800
	SUBQ.W	#3,D1			;4365c: 5741
	MOVE.W	D1,(-34,A5)		;4365e: 3b41ffde
LAB_43662:
	ADDQ.W	#1,D6			;43662: 5246
LAB_43664:
	CMP.W	(-6,A5),D6		;43664: bc6dfffa
	BLT.S	LAB_43602		;43668: 6d98
	TST.W	(-36,A5)		;4366a: 4a6dffdc
	BGE.S	LAB_43676		;4366e: 6c06
	MOVEQ	#0,D0			;43670: 7000
	BRA.W	LAB_4351A		;43672: 6000fea6
LAB_43676:
	MOVE.W	(-36,A5),D0		;43676: 302dffdc
	MULS	#$0042,D0		;4367a: c1fc0042
	ADD.W	D0,(-30,A5)		;4367e: d16dffe2
	MOVE.W	(-30,A5),D0		;43682: 302dffe2
	EXT.L	D0			;43686: 48c0
	DIVS	#$0041,D0		;43688: 81fc0041
	MOVE.W	D0,(-4,A5)		;4368c: 3b40fffc
	MOVE.W	D0,(_cur_y,A4)		;43690: 39403026
	MOVE.W	(-4,A5),D0		;43694: 302dfffc
	MULS	#$0041,D0		;43698: c1fc0041
	MOVE.W	(-30,A5),D1		;4369c: 322dffe2
	SUB.W	D0,D1			;436a0: 9240
	MOVE.W	D1,(-2,A5)		;436a2: 3b41fffe
	MOVE.W	D1,(_cur_x,A4)		;436a6: 39413028
	TST.W	(_paint_map,A4)		;436aa: 4a6c9c24
	BNE.S	LAB_436F0		;436ae: 6640
	MOVE.W	(_mode,A4),D0		;436b0: 302c8256
	AND.W	#$000c,D0		;436b4: c07c000c
	BNE.S	LAB_436F0		;436b8: 6636
	BTST	#2,(LAB_518A7,A4)	;436ba: 082c000284b9
	BEQ.S	LAB_436C8		;436c0: 6706
	MOVEQ	#0,D0			;436c2: 7000
	BRA.W	LAB_4351A		;436c4: 6000fe54
LAB_436C8:
	MOVE.W	(-30,A5),D0		;436c8: 302dffe2
	EXT.L	D0			;436cc: 48c0
	ASL.L	#1,D0			;436ce: e380
	LEA	(_alt,A4),A0		;436d0: 41ecae86
	TST.W	(0,A0,D0.L)		;436d4: 4a700800
	BLE.S	LAB_436F0		;436d8: 6f16
	BTST	#4,(LAB_518A7,A4)	;436da: 082c000484b9
	BEQ.S	LAB_436F0		;436e0: 670e
	BTST	#0,(LAB_52E0D,A4)	;436e2: 082c00009a1f
	BNE.S	LAB_436F0		;436e8: 6606
	MOVEQ	#0,D0			;436ea: 7000
	BRA.W	LAB_4351A		;436ec: 6000fe2c
LAB_436F0:
	CMPI.W	#$00c0,(-34,A5)		;436f0: 0c6d00c0ffde
	BGE.S	LAB_43716		;436f6: 6c1e
	MOVE.W	#$0054,-(A7)		;436f8: 3f3c0054
	MOVE.W	(-34,A5),-(A7)		;436fc: 3f2dffde
	MOVE.W	D4,D0			;43700: 3004
	ASL.W	#4,D0			;43702: e940
	ADD.W	#$003d,D0		;43704: d07c003d
	MOVE.W	D0,-(A7)		;43708: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;4370a: 2f2c99ec
	JSR	(___draw_sprite,A4)	;4370e: 4eac8116
	LEA	($A,A7),A7		;43712: 4fef000a
LAB_43716:
	TST.W	(_left_button,A4)	;43716: 4a6cae62
	BNE.W	LAB_43860		;4371a: 66000144
	BTST	#3,(bitfield_51645,A4)	;4371e: 082c00038257
	BEQ.S	LAB_437A4		;43724: 677e
	MOVE.W	(_mode,A4),D0		;43726: 302c8256
	AND.W	#$0003,D0		;4372a: c07c0003
	SUBQ.W	#1,D0			;4372e: 5340
	MOVE.W	D0,-(A7)		;43730: 3f00
	MOVE.W	#$0006,-(A7)		;43732: 3f3c0006
	JSR	(___set_mode_icons,A4)	;43736: 4eac8032
	ADDQ.W	#4,A7			;4373a: 584f
	MOVE.W	(_player,A4),D0		;4373c: 302c99f4
	MULS	#$002e,D0		;43740: c1fc002e
	LEA	(_stats,A4),A0		;43744: 41ec82b6
	MOVE.B	#$04,(0,A0,D0.L)	;43748: 11bc00040800
	MOVE.W	(-2,A5),D0		;4374e: 302dfffe
	SUBQ.W	#1,D0			;43752: 5340
	MOVE.W	(_player,A4),D1		;43754: 322c99f4
	MULS	#$002e,D1		;43758: c3fc002e
	LEA	(LAB_516A5,A4),A0	;4375c: 41ec82b7
	MOVE.B	D0,(0,A0,D1.L)		;43760: 11801800
	MOVE.W	(-4,A5),D0		;43764: 302dfffc
	SUBQ.W	#1,D0			;43768: 5340
	MOVE.W	(_player,A4),D1		;4376a: 322c99f4
	MULS	#$002e,D1		;4376e: c3fc002e
	LEA	(LAB_516A6,A4),A0	;43772: 41ec82b8
	MOVE.B	D0,(0,A0,D1.L)		;43776: 11801800
	BCLR	#3,(bitfield_51645,A4)	;4377a: 08ac00038257
	MOVE.W	(_mode,A4),D0		;43780: 302c8256
	SUBQ.W	#1,D0			;43784: 5340
	MOVE.W	D0,(_pointer,A4)	;43786: 394084b6
	CMPI.W	#$0001,(_pointer,A4)	;4378a: 0c6c000184b6
	BNE.S	LAB_437A0		;43790: 660e
	CMPI.W	#$0001,(_player,A4)	;43792: 0c6c000199f4
	BNE.S	LAB_437A0		;43798: 6606
	MOVE.W	#$0004,(_pointer,A4)	;4379a: 397c000484b6
LAB_437A0:
	BRA.W	LAB_4385E		;437a0: 600000bc
LAB_437A4:
	BTST	#2,(bitfield_51645,A4)	;437a4: 082c00028257
	BEQ.S	LAB_43828		;437aa: 677c
	MOVE.W	(_mode,A4),D0		;437ac: 302c8256
	AND.W	#$0003,D0		;437b0: c07c0003
	SUBQ.W	#1,D0			;437b4: 5340
	MOVE.W	D0,-(A7)		;437b6: 3f00
	MOVE.W	#$0006,-(A7)		;437b8: 3f3c0006
	JSR	(___set_mode_icons,A4)	;437bc: 4eac8032
	ADDQ.W	#4,A7			;437c0: 584f
	MOVE.W	(_player,A4),D0		;437c2: 302c99f4
	MULS	#$002e,D0		;437c6: c1fc002e
	LEA	(_stats,A4),A0		;437ca: 41ec82b6
	MOVE.B	#$05,(0,A0,D0.L)	;437ce: 11bc00050800
	MOVE.W	(-2,A5),D0		;437d4: 302dfffe
	SUBQ.W	#1,D0			;437d8: 5340
	MOVE.W	(_player,A4),D1		;437da: 322c99f4
	MULS	#$002e,D1		;437de: c3fc002e
	LEA	(LAB_516A5,A4),A0	;437e2: 41ec82b7
	MOVE.B	D0,(0,A0,D1.L)		;437e6: 11801800
	MOVE.W	(-4,A5),D0		;437ea: 302dfffc
	SUBQ.W	#1,D0			;437ee: 5340
	MOVE.W	(_player,A4),D1		;437f0: 322c99f4
	MULS	#$002e,D1		;437f4: c3fc002e
	LEA	(LAB_516A6,A4),A0	;437f8: 41ec82b8
	MOVE.B	D0,(0,A0,D1.L)		;437fc: 11801800
	BCLR	#2,(bitfield_51645,A4)	;43800: 08ac00028257
	MOVE.W	(_mode,A4),D0		;43806: 302c8256
	SUBQ.W	#1,D0			;4380a: 5340
	MOVE.W	D0,(_pointer,A4)	;4380c: 394084b6
	CMPI.W	#$0001,(_pointer,A4)	;43810: 0c6c000184b6
	BNE.S	LAB_43826		;43816: 660e
	CMPI.W	#$0001,(_player,A4)	;43818: 0c6c000199f4
	BNE.S	LAB_43826		;4381e: 6606
	MOVE.W	#$0004,(_pointer,A4)	;43820: 397c000484b6
LAB_43826:
	BRA.S	LAB_4385E		;43826: 6036
LAB_43828:
	MOVE.W	(_player,A4),D0		;43828: 302c99f4
	MULS	#$002e,D0		;4382c: c1fc002e
	LEA	(_stats,A4),A0		;43830: 41ec82b6
	MOVE.B	#$01,(0,A0,D0.L)	;43834: 11bc00010800
	MOVE.W	(_player,A4),D0		;4383a: 302c99f4
	MULS	#$002e,D0		;4383e: c1fc002e
	LEA	(LAB_516A5,A4),A0	;43842: 41ec82b7
	MOVE.B	(-1,A5),(0,A0,D0.L)	;43846: 11adffff0800
	MOVE.W	(_player,A4),D0		;4384c: 302c99f4
	MULS	#$002e,D0		;43850: c1fc002e
	LEA	(LAB_516A6,A4),A0	;43854: 41ec82b8
	MOVE.B	(-3,A5),(0,A0,D0.L)	;43858: 11adfffd0800
LAB_4385E:
	BRA.S	LAB_438B2		;4385e: 6052
LAB_43860:
	TST.W	(_right_button,A4)	;43860: 4a6cae64
	BNE.S	LAB_438B2		;43864: 664c
	CMPI.W	#$0002,(_mode,A4)	;43866: 0c6c00028256
	BNE.S	LAB_438B2		;4386c: 6644
	BTST	#3,(LAB_518A7,A4)	;4386e: 082c000384b9
	BNE.S	LAB_438B2		;43874: 663c
	MOVE.W	#$0002,(_right_button,A4) ;43876: 397c0002ae64
	MOVE.W	(_player,A4),D0		;4387c: 302c99f4
	MULS	#$002e,D0		;43880: c1fc002e
	LEA	(_stats,A4),A0		;43884: 41ec82b6
	MOVE.B	#$02,(0,A0,D0.L)	;43888: 11bc00020800
	MOVE.W	(_player,A4),D0		;4388e: 302c99f4
	MULS	#$002e,D0		;43892: c1fc002e
	LEA	(LAB_516A5,A4),A0	;43896: 41ec82b7
	MOVE.B	(-1,A5),(0,A0,D0.L)	;4389a: 11adffff0800
	MOVE.W	(_player,A4),D0		;438a0: 302c99f4
	MULS	#$002e,D0		;438a4: c1fc002e
	LEA	(LAB_516A6,A4),A0	;438a8: 41ec82b8
	MOVE.B	(-3,A5),(0,A0,D0.L)	;438ac: 11adfffd0800
LAB_438B2:
	BRA.W	LAB_4351A		;438b2: 6000fc66
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_flood:
	LINK.W	A5,#-2			;438b6: 4e55fffe
	TST.W	(_paint_map,A4)		;438ba: 4a6c9c24
	BNE.S	LAB_4390E		;438be: 664e
	MOVE.W	(8,A5),D0		;438c0: 302d0008
	EXT.L	D0			;438c4: 48c0
	ASL.L	#4,D0			;438c6: e980
	LEA	(LAB_52DF0,A4),A0	;438c8: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;438cc: 22300800
	CMP.L	(LAB_51890,A4),D1	;438d0: b2ac84a2
	BLT.S	LAB_438F6		;438d4: 6d20
	TST.W	(_war,A4)		;438d6: 4a6cae80
	BNE.S	LAB_438F6		;438da: 661a
	TST.W	(_pause,A4)		;438dc: 4a6c9c22
	BNE.S	LAB_438F6		;438e0: 6614
	MOVE.W	(8,A5),D0		;438e2: 302d0008
	MULS	#$002e,D0		;438e6: c1fc002e
	LEA	(LAB_516B2,A4),A0	;438ea: 41ec82c4
	BTST	#7,(1,A0,D0.L)		;438ee: 083000070801
	BNE.S	LAB_438FA		;438f4: 6604
LAB_438F6:
	UNLK	A5			;438f6: 4e5d
	RTS				;438f8: 4e75
LAB_438FA:
	MOVE.W	(8,A5),D0		;438fa: 302d0008
	EXT.L	D0			;438fe: 48c0
	ASL.L	#4,D0			;43900: e980
	LEA	(LAB_52DF0,A4),A0	;43902: 41ec9a02
	ADDA.L	D0,A0			;43906: d1c0
	MOVE.L	(LAB_51890,A4),D0	;43908: 202c84a2
	SUB.L	D0,(A0)			;4390c: 9190
LAB_4390E:
	MOVE.W	(8,A5),D0		;4390e: 302d0008
	CMP.W	(_player,A4),D0		;43912: b06c99f4
	BNE.S	LAB_43920		;43916: 6608
; +250 points
	ADDI.L	#$000000fa,(_score,A4)	;43918: 06ac000000faae72
LAB_43920:
	MOVE.W	#$004a,(_effect,A4)	;43920: 397c004a2fac
	CLR.W	(-2,A5)			;43926: 426dfffe
LAB_4392A:
	MOVE.W	(-2,A5),D0		;4392a: 302dfffe
	EXT.L	D0			;4392e: 48c0
	ASL.L	#1,D0			;43930: e380
	LEA	(_alt,A4),A0		;43932: 41ecae86
	TST.W	(0,A0,D0.L)		;43936: 4a700800
	BLE.S	LAB_4394C		;4393a: 6f10
	MOVE.W	(-2,A5),D0		;4393c: 302dfffe
	EXT.L	D0			;43940: 48c0
	ASL.L	#1,D0			;43942: e380
	LEA	(_alt,A4),A0		;43944: 41ecae86
	SUBQ.W	#1,(0,A0,D0.L)		;43948: 53700800
LAB_4394C:
	ADDQ.W	#1,(-2,A5)		;4394c: 526dfffe
	CMPI.W	#$1081,(-2,A5)		;43950: 0c6d1081fffe
	BLT.S	LAB_4392A		;43956: 6dd2
	MOVE.W	#$003f,-(A7)		;43958: 3f3c003f
	MOVE.W	#$003f,-(A7)		;4395c: 3f3c003f
	CLR.W	-(A7)			;43960: 4267
	CLR.W	-(A7)			;43962: 4267
	JSR	(___make_map,A4)	;43964: 4eac8020
	ADDQ.W	#8,A7			;43968: 504f
	MOVE.W	#$004a,(_effect,A4)	;4396a: 397c004a2fac
	MOVE.W	#$004a,(_effect,A4)	;43970: 397c004a2fac
	MOVE.W	#$ffff,-(A7)		;43976: 3f3cffff
	PEA	-1.W			;4397a: 4878ffff
	MOVE.L	(_back_scr,A4),-(A7)	;4397e: 2f2c9874
	JSR	(___Setscreen,A4)	;43982: 4eac80c2
	LEA	($A,A7),A7		;43986: 4fef000a
	MOVE.W	#$003f,-(A7)		;4398a: 3f3c003f
	MOVE.W	#$003f,-(A7)		;4398e: 3f3c003f
	CLR.W	-(A7)			;43992: 4267
	CLR.W	-(A7)			;43994: 4267
	JSR	(___draw_map,A4)	;43996: 4eac8026
	ADDQ.W	#8,A7			;4399a: 504f
	MOVE.W	#$ffff,-(A7)		;4399c: 3f3cffff
	PEA	-1.W			;439a0: 4878ffff
	MOVE.L	(_w_screen,A4),-(A7)	;439a4: 2f2c99e8
	JSR	(___Setscreen,A4)	;439a8: 4eac80c2
	LEA	($A,A7),A7		;439ac: 4fef000a
	MOVE.W	#$004a,(_effect,A4)	;439b0: 397c004a2fac
	BRA.W	LAB_438F6		;439b6: 6000ff3e
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_place_first_people:
	LINK.W	A5,#-4			;439ba: 4e55fffc
	CMPI.W	#$ffff,(_in_conquest,A4) ;439be: 0c6cffff84ba
	BNE.S	LAB_439CE		;439c4: 6608
	CMPI.W	#$0003,(_start_of_game,A4) ;439c6: 0c6c00039898
	BNE.S	LAB_439DA		;439cc: 660c
LAB_439CE:
	MOVEQ	#0,D0			;439ce: 7000
	MOVE.B	(conq_06_yourpop,A4),D0	;439d0: 102c84c2
	MOVE.W	D0,(-4,A5)		;439d4: 3b40fffc
	BRA.S	LAB_439FE		;439d8: 6024
LAB_439DA:
	TST.W	(_serial_off,A4)	;439da: 4a6c8254
	BNE.S	LAB_439E8		;439de: 6608
	MOVE.W	#$0001,(-4,A5)		;439e0: 3b7c0001fffc
	BRA.S	LAB_439FE		;439e6: 6016
LAB_439E8:
	CMPI.W	#$0004,(LAB_516B0,A4)	;439e8: 0c6c000482c2
	BLE.S	LAB_439F4		;439ee: 6f04
	MOVEQ	#1,D0			;439f0: 7001
	BRA.S	LAB_439F6		;439f2: 6002
LAB_439F4:
	MOVEQ	#0,D0			;439f4: 7000
LAB_439F6:
	ASL.W	#1,D0			;439f6: e340
	ADDQ.W	#1,D0			;439f8: 5240
	MOVE.W	D0,(-4,A5)		;439fa: 3b40fffc
LAB_439FE:
	TST.W	(_player,A4)		;439fe: 4a6c99f4
	BNE.S	LAB_43A12		;43a02: 660e
	MOVE.W	(-4,A5),D0		;43a04: 302dfffc
; +10 points per
	MULS	#$000a,D0		;43a08: c1fc000a
	EXT.L	D0			;43a0c: 48c0
	ADD.L	D0,(_score,A4)		;43a0e: d1acae72
LAB_43A12:
	MOVE.W	#$0080,(-2,A5)		;43a12: 3b7c0080fffe
LAB_43A18:
	MOVE.W	(-2,A5),D0		;43a18: 302dfffe
	LEA	(_map_blk,A4),A0	;43a1c: 41eccf88
	CMPI.B	#$0f,(0,A0,D0.W)	;43a20: 0c30000f0000
	BNE.S	LAB_43A5A		;43a26: 6632
	SUBQ.W	#1,(-4,A5)		;43a28: 536dfffc
	TST.W	(-4,A5)			;43a2c: 4a6dfffc
	BGT.S	LAB_43A36		;43a30: 6e04
	MOVEQ	#1,D0			;43a32: 7001
	BRA.S	LAB_43A38		;43a34: 6002
LAB_43A36:
	MOVEQ	#0,D0			;43a36: 7000
LAB_43A38:
	MOVE.W	D0,-(A7)		;43a38: 3f00
	MOVE.W	(-2,A5),D0		;43a3a: 302dfffe
	ASR.W	#6,D0			;43a3e: ec40
	MOVE.W	D0,-(A7)		;43a40: 3f00
	MOVE.W	(-2,A5),D0		;43a42: 302dfffe
	AND.W	#$003f,D0		;43a46: c07c003f
	MOVE.W	D0,-(A7)		;43a4a: 3f00
	CLR.W	-(A7)			;43a4c: 4267
	JSR	(_place_people,PC)	;43a4e: 4ebaf714
	ADDQ.W	#8,A7			;43a52: 504f
	TST.W	(-4,A5)			;43a54: 4a6dfffc
	BEQ.S	LAB_43A66		;43a58: 670c
LAB_43A5A:
	ADDQ.W	#1,(-2,A5)		;43a5a: 526dfffe
	CMPI.W	#$1000,(-2,A5)		;43a5e: 0c6d1000fffe
	BLT.S	LAB_43A18		;43a64: 6db2
LAB_43A66:
	TST.W	(-4,A5)			;43a66: 4a6dfffc
	BEQ.S	LAB_43ACA		;43a6a: 675e
	CLR.W	(-2,A5)			;43a6c: 426dfffe
LAB_43A70:
	MOVE.W	(-2,A5),D0		;43a70: 302dfffe
	LEA	(_map_blk,A4),A0	;43a74: 41eccf88
	TST.B	(0,A0,D0.W)		;43a78: 4a300000
	BEQ.S	LAB_43ABE		;43a7c: 6740
	MOVE.W	(-2,A5),D0		;43a7e: 302dfffe
	LEA	(_map_who,A4),A0	;43a82: 41ec1f88
	TST.B	(0,A0,D0.W)		;43a86: 4a300000
	BNE.S	LAB_43ABE		;43a8a: 6632
	SUBQ.W	#1,(-4,A5)		;43a8c: 536dfffc
	TST.W	(-4,A5)			;43a90: 4a6dfffc
	BGT.S	LAB_43A9A		;43a94: 6e04
	MOVEQ	#1,D0			;43a96: 7001
	BRA.S	LAB_43A9C		;43a98: 6002
LAB_43A9A:
	MOVEQ	#0,D0			;43a9a: 7000
LAB_43A9C:
	MOVE.W	D0,-(A7)		;43a9c: 3f00
	MOVE.W	(-2,A5),D0		;43a9e: 302dfffe
	ASR.W	#6,D0			;43aa2: ec40
	MOVE.W	D0,-(A7)		;43aa4: 3f00
	MOVE.W	(-2,A5),D0		;43aa6: 302dfffe
	AND.W	#$003f,D0		;43aaa: c07c003f
	MOVE.W	D0,-(A7)		;43aae: 3f00
	CLR.W	-(A7)			;43ab0: 4267
	JSR	(_place_people,PC)	;43ab2: 4ebaf6b0
	ADDQ.W	#8,A7			;43ab6: 504f
	TST.W	(-4,A5)			;43ab8: 4a6dfffc
	BEQ.S	LAB_43ACA		;43abc: 670c
LAB_43ABE:
	ADDQ.W	#1,(-2,A5)		;43abe: 526dfffe
	CMPI.W	#$1000,(-2,A5)		;43ac2: 0c6d1000fffe
	BLT.S	LAB_43A70		;43ac8: 6da6
LAB_43ACA:
	CMPI.W	#$ffff,(_in_conquest,A4) ;43aca: 0c6cffff84ba
	BNE.S	LAB_43ADA		;43ad0: 6608
	CMPI.W	#$0003,(_start_of_game,A4) ;43ad2: 0c6c00039898
	BNE.S	LAB_43AE6		;43ad8: 660c
LAB_43ADA:
	MOVEQ	#0,D0			;43ada: 7000
	MOVE.B	(conq_07_enemypop,A4),D0 ;43adc: 102c84c3
	MOVE.W	D0,(-4,A5)		;43ae0: 3b40fffc
	BRA.S	LAB_43B0A		;43ae4: 6024
LAB_43AE6:
	TST.W	(_serial_off,A4)	;43ae6: 4a6c8254
	BNE.S	LAB_43AF4		;43aea: 6608
	MOVE.W	#$0001,(-4,A5)		;43aec: 3b7c0001fffc
	BRA.S	LAB_43B0A		;43af2: 6016
LAB_43AF4:
	CMPI.W	#$0004,(LAB_516DE,A4)	;43af4: 0c6c000482f0
	BLE.S	LAB_43B00		;43afa: 6f04
	MOVEQ	#1,D0			;43afc: 7001
	BRA.S	LAB_43B02		;43afe: 6002
LAB_43B00:
	MOVEQ	#0,D0			;43b00: 7000
LAB_43B02:
	ASL.W	#1,D0			;43b02: e340
	ADDQ.W	#1,D0			;43b04: 5240
	MOVE.W	D0,(-4,A5)		;43b06: 3b40fffc
LAB_43B0A:
	CMPI.W	#$0001,(_player,A4)	;43b0a: 0c6c000199f4
	BNE.S	LAB_43B20		;43b10: 660e
	MOVE.W	(-4,A5),D0		;43b12: 302dfffc
; +10 points per
	MULS	#$000a,D0		;43b16: c1fc000a
	EXT.L	D0			;43b1a: 48c0
	ADD.L	D0,(_score,A4)		;43b1c: d1acae72
LAB_43B20:
	MOVE.W	#$0f80,(-2,A5)		;43b20: 3b7c0f80fffe
LAB_43B26:
	MOVE.W	(-2,A5),D0		;43b26: 302dfffe
	LEA	(_map_blk,A4),A0	;43b2a: 41eccf88
	CMPI.B	#$0f,(0,A0,D0.W)	;43b2e: 0c30000f0000
	BNE.S	LAB_43B6A		;43b34: 6634
	SUBQ.W	#1,(-4,A5)		;43b36: 536dfffc
	TST.W	(-4,A5)			;43b3a: 4a6dfffc
	BGT.S	LAB_43B44		;43b3e: 6e04
	MOVEQ	#1,D0			;43b40: 7001
	BRA.S	LAB_43B46		;43b42: 6002
LAB_43B44:
	MOVEQ	#0,D0			;43b44: 7000
LAB_43B46:
	MOVE.W	D0,-(A7)		;43b46: 3f00
	MOVE.W	(-2,A5),D0		;43b48: 302dfffe
	ASR.W	#6,D0			;43b4c: ec40
	MOVE.W	D0,-(A7)		;43b4e: 3f00
	MOVE.W	(-2,A5),D0		;43b50: 302dfffe
	AND.W	#$003f,D0		;43b54: c07c003f
	MOVE.W	D0,-(A7)		;43b58: 3f00
	MOVE.W	#$0001,-(A7)		;43b5a: 3f3c0001
	JSR	(_place_people,PC)	;43b5e: 4ebaf604
	ADDQ.W	#8,A7			;43b62: 504f
	TST.W	(-4,A5)			;43b64: 4a6dfffc
	BEQ.S	LAB_43B76		;43b68: 670c
LAB_43B6A:
	SUBQ.W	#1,(-2,A5)		;43b6a: 536dfffe
	CMPI.W	#$0080,(-2,A5)		;43b6e: 0c6d0080fffe
	BGE.S	LAB_43B26		;43b74: 6cb0
LAB_43B76:
	TST.W	(-4,A5)			;43b76: 4a6dfffc
	BEQ.S	LAB_43BDC		;43b7a: 6760
	MOVE.W	#$1000,(-2,A5)		;43b7c: 3b7c1000fffe
LAB_43B82:
	MOVE.W	(-2,A5),D0		;43b82: 302dfffe
	LEA	(_map_blk,A4),A0	;43b86: 41eccf88
	TST.B	(0,A0,D0.W)		;43b8a: 4a300000
	BEQ.S	LAB_43BD2		;43b8e: 6742
	MOVE.W	(-2,A5),D0		;43b90: 302dfffe
	LEA	(_map_who,A4),A0	;43b94: 41ec1f88
	TST.B	(0,A0,D0.W)		;43b98: 4a300000
	BNE.S	LAB_43BD2		;43b9c: 6634
	TST.W	(-4,A5)			;43b9e: 4a6dfffc
	BGT.S	LAB_43BA8		;43ba2: 6e04
	MOVEQ	#1,D0			;43ba4: 7001
	BRA.S	LAB_43BAA		;43ba6: 6002
LAB_43BA8:
	MOVEQ	#0,D0			;43ba8: 7000
LAB_43BAA:
	MOVE.W	D0,-(A7)		;43baa: 3f00
	MOVE.W	(-2,A5),D0		;43bac: 302dfffe
	ASR.W	#6,D0			;43bb0: ec40
	MOVE.W	D0,-(A7)		;43bb2: 3f00
	MOVE.W	(-2,A5),D0		;43bb4: 302dfffe
	AND.W	#$003f,D0		;43bb8: c07c003f
	MOVE.W	D0,-(A7)		;43bbc: 3f00
	MOVE.W	#$0001,-(A7)		;43bbe: 3f3c0001
	JSR	(_place_people,PC)	;43bc2: 4ebaf5a0
	ADDQ.W	#8,A7			;43bc6: 504f
	SUBQ.W	#1,(-4,A5)		;43bc8: 536dfffc
	TST.W	(-4,A5)			;43bcc: 4a6dfffc
	BEQ.S	LAB_43BDC		;43bd0: 670a
LAB_43BD2:
	SUBQ.W	#1,(-2,A5)		;43bd2: 536dfffe
	TST.W	(-2,A5)			;43bd6: 4a6dfffe
	BNE.S	LAB_43B82		;43bda: 66a6
LAB_43BDC:
	UNLK	A5			;43bdc: 4e5d
	RTS				;43bde: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_quake:
	LINK.W	A5,#-8			;43be0: 4e55fff8
	TST.W	(_paint_map,A4)		;43be4: 4a6c9c24
	BNE.S	LAB_43C38		;43be8: 664e
	MOVE.W	(8,A5),D0		;43bea: 302d0008
	EXT.L	D0			;43bee: 48c0
	ASL.L	#4,D0			;43bf0: e980
	LEA	(LAB_52DF0,A4),A0	;43bf2: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;43bf6: 22300800
	CMP.L	(LAB_51880,A4),D1	;43bfa: b2ac8492
	BLT.S	LAB_43C20		;43bfe: 6d20
	TST.W	(_war,A4)		;43c00: 4a6cae80
	BNE.S	LAB_43C20		;43c04: 661a
	TST.W	(_pause,A4)		;43c06: 4a6c9c22
	BNE.S	LAB_43C20		;43c0a: 6614
	MOVE.W	(8,A5),D0		;43c0c: 302d0008
	MULS	#$002e,D0		;43c10: c1fc002e
	LEA	(LAB_516B2,A4),A0	;43c14: 41ec82c4
	BTST	#3,(1,A0,D0.L)		;43c18: 083000030801
	BNE.S	LAB_43C24		;43c1e: 6604
LAB_43C20:
	UNLK	A5			;43c20: 4e5d
	RTS				;43c22: 4e75
LAB_43C24:
	MOVE.W	(8,A5),D0		;43c24: 302d0008
	EXT.L	D0			;43c28: 48c0
	ASL.L	#4,D0			;43c2a: e980
	LEA	(LAB_52DF0,A4),A0	;43c2c: 41ec9a02
	ADDA.L	D0,A0			;43c30: d1c0
	MOVE.L	(LAB_51880,A4),D0	;43c32: 202c8492
	SUB.L	D0,(A0)			;43c36: 9190
LAB_43C38:
	MOVE.W	($A,A5),(_xmin,A4)	;43c38: 396d000a2f8a
	MOVE.W	($A,A5),(_xmax,A4)	;43c3e: 396d000a2f8c
	MOVE.W	($C,A5),(_ymin,A4)	;43c44: 396d000c2f8e
	MOVE.W	($C,A5),(_ymax,A4)	;43c4a: 396d000c2f90
	SUBI.L	#$00000028,(_screen_origin,A4) ;43c50: 04ac000000288242
	MOVE.W	#$004c,(_effect,A4)	;43c58: 397c004c2fac
	MOVE.W	(8,A5),D0		;43c5e: 302d0008
	CMP.W	(_player,A4),D0		;43c62: b06c99f4
	BNE.S	LAB_43C70		;43c66: 6608
; +25 points for earthquake
	ADDI.L	#$00000019,(_score,A4)	;43c68: 06ac00000019ae72
LAB_43C70:
	CLR.W	(-6,A5)			;43c70: 426dfffa
LAB_43C74:
	BTST	#0,(-5,A5)		;43c74: 082d0000fffb
	BEQ.S	LAB_43C86		;43c7a: 670a
	ADDI.L	#$00000078,(_screen_origin,A4) ;43c7c: 06ac000000788242
	BRA.S	LAB_43C8E		;43c84: 6008
LAB_43C86:
	SUBI.L	#$00000078,(_screen_origin,A4) ;43c86: 04ac000000788242
LAB_43C8E:
	MOVE.W	(_yoff,A4),-(A7)	;43c8e: 3f2c99f2
	MOVE.W	(_xoff,A4),-(A7)	;43c92: 3f2c99f0
	JSR	(___draw_it,A4)		;43c96: 4eac809e
	ADDQ.W	#4,A7			;43c9a: 584f
	JSR	(___swap_screens,A4)	;43c9c: 4eac80c8
	ADDQ.W	#1,(-6,A5)		;43ca0: 526dfffa
	CMPI.W	#$0014,(-6,A5)		;43ca4: 0c6d0014fffa
	BNE.S	LAB_43C74		;43caa: 66c8
	ADDI.L	#$00000028,(_screen_origin,A4) ;43cac: 06ac000000288242
	CLR.W	(-6,A5)			;43cb4: 426dfffa
LAB_43CB8:
	MOVE.W	($A,A5),(-2,A5)		;43cb8: 3b6d000afffe
	BRA.W	LAB_43D4A		;43cbe: 6000008a
LAB_43CC2:
	MOVE.W	($C,A5),(-4,A5)		;43cc2: 3b6d000cfffc
	BRA.S	LAB_43D36		;43cc8: 606c
LAB_43CCA:
	MOVE.W	(-4,A5),D0		;43cca: 302dfffc
	MULS	#$0041,D0		;43cce: c1fc0041
	ADD.W	(-2,A5),D0		;43cd2: d06dfffe
	EXT.L	D0			;43cd6: 48c0
	ASL.L	#1,D0			;43cd8: e380
	LEA	(_alt,A4),A0		;43cda: 41ecae86
	TST.W	(0,A0,D0.L)		;43cde: 4a700800
	BEQ.S	LAB_43D32		;43ce2: 674e
	JSR	(___newrand,A4)		;43ce4: 4eac80fe
	EXT.L	D0			;43ce8: 48c0
	DIVS	#$0005,D0		;43cea: 81fc0005
	SWAP	D0			;43cee: 4840
	EXT.L	D0			;43cf0: 48c0
	BRA.S	LAB_43D20		;43cf2: 602c
LAB_43CF4:
	MOVE.W	(-4,A5),-(A7)		;43cf4: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;43cf8: 3f2dfffe
	JSR	(_raise_point,PC)	;43cfc: 4ebab254
	ADDQ.W	#4,A7			;43d00: 584f
	BRA.S	LAB_43D32		;43d02: 602e
LAB_43D04:
	MOVE.W	(-4,A5),-(A7)		;43d04: 3f2dfffc
	MOVE.W	(-2,A5),-(A7)		;43d08: 3f2dfffe
	JSR	(_lower_point,PC)	;43d0c: 4ebac156
	ADDQ.W	#4,A7			;43d10: 584f
	BRA.S	LAB_43D32		;43d12: 601e
LAB_43D14:
	BRA.S	LAB_43D32		;43d14: 601c
LAB_43D16:
	DC.W	(LAB_43D14)-(LAB_43D2E+2) ;43d16: ffe4
	DC.W	(LAB_43CF4)-(LAB_43D2E+2) ;43d18: ffc4
	DC.W	(LAB_43D04)-(LAB_43D2E+2) ;43d1a: ffd4
	DC.W	(LAB_43D04)-(LAB_43D2E+2) ;43d1c: ffd4
	DC.W	(LAB_43D04)-(LAB_43D2E+2) ;43d1e: ffd4
LAB_43D20:
	CMP.L	#$00000005,D0		;43d20: b0bc00000005
	BCC.S	LAB_43D14		;43d26: 64ec
	ASL.L	#1,D0			;43d28: e380
	MOVE.W	(LAB_43D16,PC,D0.W),D0	;43d2a: 303b00ea
LAB_43D2E:
	JMP	(LAB_43D2E+2,PC,D0.W)	;43d2e: 4efb0000
LAB_43D32:
	ADDQ.W	#1,(-4,A5)		;43d32: 526dfffc
LAB_43D36:
	MOVE.W	($C,A5),D0		;43d36: 302d000c
	ADD.W	#$0009,D0		;43d3a: d07c0009
	MOVE.W	(-4,A5),D1		;43d3e: 322dfffc
	CMP.W	D0,D1			;43d42: b240
	BLT.S	LAB_43CCA		;43d44: 6d84
	ADDQ.W	#1,(-2,A5)		;43d46: 526dfffe
LAB_43D4A:
	MOVE.W	($A,A5),D0		;43d4a: 302d000a
	ADD.W	#$0009,D0		;43d4e: d07c0009
	MOVE.W	(-2,A5),D1		;43d52: 322dfffe
	CMP.W	D0,D1			;43d56: b240
	BLT.W	LAB_43CC2		;43d58: 6d00ff68
	ADDQ.W	#1,(-6,A5)		;43d5c: 526dfffa
	CMPI.W	#$0002,(-6,A5)		;43d60: 0c6d0002fffa
	BNE.W	LAB_43CB8		;43d66: 6600ff50
	CMPI.W	#$0001,(_xmin,A4)	;43d6a: 0c6c00012f8a
	BGE.S	LAB_43D78		;43d70: 6c06
	MOVE.W	#$0001,(_xmin,A4)	;43d72: 397c00012f8a
LAB_43D78:
	CMPI.W	#$003f,(_xmax,A4)	;43d78: 0c6c003f2f8c
	BLE.S	LAB_43D86		;43d7e: 6f06
	MOVE.W	#$003f,(_xmax,A4)	;43d80: 397c003f2f8c
LAB_43D86:
	CMPI.W	#$0001,(_ymin,A4)	;43d86: 0c6c00012f8e
	BGE.S	LAB_43D94		;43d8c: 6c06
	MOVE.W	#$0001,(_ymin,A4)	;43d8e: 397c00012f8e
LAB_43D94:
	CMPI.W	#$003f,(_ymax,A4)	;43d94: 0c6c003f2f90
	BLE.S	LAB_43DA2		;43d9a: 6f06
	MOVE.W	#$003f,(_ymax,A4)	;43d9c: 397c003f2f90
LAB_43DA2:
	MOVE.W	(_ymax,A4),-(A7)	;43da2: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;43da6: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;43daa: 302c2f8e
	SUBQ.W	#1,D0			;43dae: 5340
	MOVE.W	D0,-(A7)		;43db0: 3f00
	MOVE.W	(_xmin,A4),D0		;43db2: 302c2f8a
	SUBQ.W	#1,D0			;43db6: 5340
	MOVE.W	D0,-(A7)		;43db8: 3f00
	JSR	(___make_map,A4)	;43dba: 4eac8020
	ADDQ.W	#8,A7			;43dbe: 504f
	MOVE.W	#$ffff,-(A7)		;43dc0: 3f3cffff
	PEA	-1.W			;43dc4: 4878ffff
	MOVE.L	(_back_scr,A4),-(A7)	;43dc8: 2f2c9874
	JSR	(___Setscreen,A4)	;43dcc: 4eac80c2
	LEA	($A,A7),A7		;43dd0: 4fef000a
	MOVE.W	(_ymax,A4),-(A7)	;43dd4: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;43dd8: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;43ddc: 302c2f8e
	SUBQ.W	#1,D0			;43de0: 5340
	MOVE.W	D0,-(A7)		;43de2: 3f00
	MOVE.W	(_xmin,A4),D0		;43de4: 302c2f8a
	SUBQ.W	#1,D0			;43de8: 5340
	MOVE.W	D0,-(A7)		;43dea: 3f00
	JSR	(___draw_map,A4)	;43dec: 4eac8026
	ADDQ.W	#8,A7			;43df0: 504f
	MOVE.W	#$ffff,-(A7)		;43df2: 3f3cffff
	PEA	-1.W			;43df6: 4878ffff
	MOVE.L	(_w_screen,A4),-(A7)	;43dfa: 2f2c99e8
	JSR	(___Setscreen,A4)	;43dfe: 4eac80c2
	LEA	($A,A7),A7		;43e02: 4fef000a
	MOVE.W	#$0004,-(A7)		;43e06: 3f3c0004
	MOVE.W	#$0002,-(A7)		;43e0a: 3f3c0002
	JSR	(___kill_effect,A4)	;43e0e: 4eac8170
	ADDQ.W	#4,A7			;43e12: 584f
	BRA.W	LAB_43C20		;43e14: 6000fe0a
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_volcano:
	LINK.W	A5,#-14			;43e18: 4e55fff2
	TST.W	(_paint_map,A4)		;43e1c: 4a6c9c24
	BNE.S	LAB_43E70		;43e20: 664e
	MOVE.W	(8,A5),D0		;43e22: 302d0008
	EXT.L	D0			;43e26: 48c0
	ASL.L	#4,D0			;43e28: e980
	LEA	(LAB_52DF0,A4),A0	;43e2a: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;43e2e: 22300800
	CMP.L	(LAB_5188C,A4),D1	;43e32: b2ac849e
	BLT.S	LAB_43E58		;43e36: 6d20
	TST.W	(_war,A4)		;43e38: 4a6cae80
	BNE.S	LAB_43E58		;43e3c: 661a
	TST.W	(_pause,A4)		;43e3e: 4a6c9c22
	BNE.S	LAB_43E58		;43e42: 6614
	MOVE.W	(8,A5),D0		;43e44: 302d0008
	MULS	#$002e,D0		;43e48: c1fc002e
	LEA	(LAB_516B2,A4),A0	;43e4c: 41ec82c4
	BTST	#6,(1,A0,D0.L)		;43e50: 083000060801
	BNE.S	LAB_43E5C		;43e56: 6604
LAB_43E58:
	UNLK	A5			;43e58: 4e5d
	RTS				;43e5a: 4e75
LAB_43E5C:
	MOVE.W	(8,A5),D0		;43e5c: 302d0008
	EXT.L	D0			;43e60: 48c0
	ASL.L	#4,D0			;43e62: e980
	LEA	(LAB_52DF0,A4),A0	;43e64: 41ec9a02
	ADDA.L	D0,A0			;43e68: d1c0
	MOVE.L	(LAB_5188C,A4),D0	;43e6a: 202c849e
	SUB.L	D0,(A0)			;43e6e: 9190
LAB_43E70:
	MOVE.W	(8,A5),D0		;43e70: 302d0008
	CMP.W	(_player,A4),D0		;43e74: b06c99f4
	BNE.S	LAB_43E82		;43e78: 6608
; +100 points per volcano
	ADDI.L	#$00000064,(_score,A4)	;43e7a: 06ac00000064ae72
LAB_43E82:
	MOVE.W	($A,A5),(_xmin,A4)	;43e82: 396d000a2f8a
	MOVE.W	($A,A5),(_xmax,A4)	;43e88: 396d000a2f8c
	MOVE.W	($C,A5),(_ymin,A4)	;43e8e: 396d000c2f8e
	MOVE.W	($C,A5),(_ymax,A4)	;43e94: 396d000c2f90
	MOVE.W	#$004b,(_effect,A4)	;43e9a: 397c004b2fac
	CLR.W	(-6,A5)			;43ea0: 426dfffa
LAB_43EA4:
	MOVE.W	(-6,A5),(-2,A5)		;43ea4: 3b6dfffafffe
	BRA.S	LAB_43F06		;43eaa: 605a
LAB_43EAC:
	MOVE.W	(-6,A5),(-4,A5)		;43eac: 3b6dfffafffc
	BRA.S	LAB_43EF4		;43eb2: 6040
LAB_43EB4:
	JSR	(___newrand,A4)		;43eb4: 4eac80fe
	EXT.L	D0			;43eb8: 48c0
	DIVS	#$0005,D0		;43eba: 81fc0005
	SWAP	D0			;43ebe: 4840
	EXT.L	D0			;43ec0: 48c0
	BRA.S	LAB_43EE2		;43ec2: 601e
LAB_43EC4:
	MOVE.W	(-4,A5),D0		;43ec4: 302dfffc
	ADD.W	($C,A5),D0		;43ec8: d06d000c
	MOVE.W	D0,-(A7)		;43ecc: 3f00
	MOVE.W	(-2,A5),D0		;43ece: 302dfffe
	ADD.W	($A,A5),D0		;43ed2: d06d000a
	MOVE.W	D0,-(A7)		;43ed6: 3f00
	JSR	(_raise_point,PC)	;43ed8: 4ebab078
	ADDQ.W	#4,A7			;43edc: 584f
	BRA.S	LAB_43EF0		;43ede: 6010
LAB_43EE0:
	BRA.S	LAB_43EF0		;43ee0: 600e
LAB_43EE2:
	SUBQ.L	#1,D0			;43ee2: 5380
	BEQ.S	LAB_43EC4		;43ee4: 67de
	SUBQ.L	#1,D0			;43ee6: 5380
	BEQ.S	LAB_43EC4		;43ee8: 67da
	SUBQ.L	#2,D0			;43eea: 5580
	BEQ.S	LAB_43EC4		;43eec: 67d6
	BRA.S	LAB_43EE0		;43eee: 60f0
LAB_43EF0:
	ADDQ.W	#1,(-4,A5)		;43ef0: 526dfffc
LAB_43EF4:
	MOVEQ	#9,D0			;43ef4: 7009
	SUB.W	(-6,A5),D0		;43ef6: 906dfffa
	MOVE.W	(-4,A5),D1		;43efa: 322dfffc
	CMP.W	D0,D1			;43efe: b240
	BLT.S	LAB_43EB4		;43f00: 6db2
	ADDQ.W	#1,(-2,A5)		;43f02: 526dfffe
LAB_43F06:
	MOVEQ	#9,D0			;43f06: 7009
	SUB.W	(-6,A5),D0		;43f08: 906dfffa
	MOVE.W	(-2,A5),D1		;43f0c: 322dfffe
	CMP.W	D0,D1			;43f10: b240
	BLT.S	LAB_43EAC		;43f12: 6d98
	ADDQ.W	#1,(-6,A5)		;43f14: 526dfffa
	CMPI.W	#$0004,(-6,A5)		;43f18: 0c6d0004fffa
	BLE.S	LAB_43EA4		;43f1e: 6f84
	MOVE.W	(_magnet,A4),(-12,A5)	;43f20: 3b6c99f6fff4
	TST.W	(-12,A5)		;43f26: 4a6dfff4
	BEQ.S	LAB_43F40		;43f2a: 6714
	MOVE.W	(-12,A5),D0		;43f2c: 302dfff4
	SUBQ.W	#1,D0			;43f30: 5340
	MULS	#$0016,D0		;43f32: c1fc0016
	LEA	(LAB_5301C,A4),A0	;43f36: 41ec9c2e
	MOVE.W	(0,A0,D0.L),(-12,A5)	;43f3a: 3b700800fff4
LAB_43F40:
	MOVE.W	(_magnet,A4),(-14,A5)	;43f40: 3b6c99f6fff2
	TST.W	(-14,A5)		;43f46: 4a6dfff2
	BEQ.S	LAB_43F60		;43f4a: 6714
	MOVE.W	(-14,A5),D0		;43f4c: 302dfff2
	SUBQ.W	#1,D0			;43f50: 5340
	MULS	#$0016,D0		;43f52: c1fc0016
	LEA	(LAB_5301C,A4),A0	;43f56: 41ec9c2e
	MOVE.W	(0,A0,D0.L),(-14,A5)	;43f5a: 3b700800fff2
LAB_43F60:
	MOVE.W	($A,A5),(-2,A5)		;43f60: 3b6d000afffe
	BRA.W	LAB_44016		;43f66: 600000ae
LAB_43F6A:
	MOVE.W	($C,A5),(-4,A5)		;43f6a: 3b6d000cfffc
	BRA.W	LAB_44002		;43f70: 60000090
LAB_43F74:
	TST.W	(-2,A5)			;43f74: 4a6dfffe
	BLT.W	LAB_43FFE		;43f78: 6d000084
	CMPI.W	#$0040,(-2,A5)		;43f7c: 0c6d0040fffe
	BGE.S	LAB_43FFE		;43f82: 6c7a
	TST.W	(-4,A5)			;43f84: 4a6dfffc
	BLT.S	LAB_43FFE		;43f88: 6d74
	CMPI.W	#$0040,(-4,A5)		;43f8a: 0c6d0040fffc
	BGE.S	LAB_43FFE		;43f90: 6c6c
	MOVE.W	(-4,A5),D0		;43f92: 302dfffc
	ASL.W	#6,D0			;43f96: ed40
	ADD.W	(-2,A5),D0		;43f98: d06dfffe
	MOVE.W	D0,(-10,A5)		;43f9c: 3b40fff6
	JSR	(___newrand,A4)		;43fa0: 4eac80fe
	EXT.L	D0			;43fa4: 48c0
	DIVS	#$0005,D0		;43fa6: 81fc0005
	SWAP	D0			;43faa: 4840
	TST.W	D0			;43fac: 4a40
	BNE.S	LAB_43FFE		;43fae: 664e
	MOVE.W	(-12,A5),D0		;43fb0: 302dfff4
	CMP.W	(-10,A5),D0		;43fb4: b06dfff6
	BEQ.S	LAB_43FFE		;43fb8: 6744
	MOVE.W	(-10,A5),D0		;43fba: 302dfff6
	CMP.W	(-14,A5),D0		;43fbe: b06dfff2
	BEQ.S	LAB_43FFE		;43fc2: 673a
	MOVE.W	(-10,A5),D0		;43fc4: 302dfff6
	CMP.W	(LAB_52DE6,A4),D0	;43fc8: b06c99f8
	BEQ.S	LAB_43FFE		;43fcc: 6730
	MOVE.W	(-10,A5),D0		;43fce: 302dfff6
	CMP.W	(LAB_52DF6,A4),D0	;43fd2: b06c9a08
	BEQ.S	LAB_43FFE		;43fd6: 6726
	MOVE.W	(-4,A5),D0		;43fd8: 302dfffc
	ASL.W	#6,D0			;43fdc: ed40
	ADD.W	(-2,A5),D0		;43fde: d06dfffe
	LEA	(_map_blk,A4),A0	;43fe2: 41eccf88
	MOVE.B	#$2f,(0,A0,D0.W)	;43fe6: 11bc002f0000
	MOVE.W	(-4,A5),D0		;43fec: 302dfffc
	ASL.W	#6,D0			;43ff0: ed40
	ADD.W	(-2,A5),D0		;43ff2: d06dfffe
	LEA	(_map_bk2,A4),A0	;43ff6: 41ecef88
	CLR.B	(0,A0,D0.W)		;43ffa: 42300000
LAB_43FFE:
	ADDQ.W	#1,(-4,A5)		;43ffe: 526dfffc
LAB_44002:
	MOVE.W	($C,A5),D0		;44002: 302d000c
	ADDQ.W	#8,D0			;44006: 5040
	MOVE.W	(-4,A5),D1		;44008: 322dfffc
	CMP.W	D0,D1			;4400c: b240
	BLT.W	LAB_43F74		;4400e: 6d00ff64
	ADDQ.W	#1,(-2,A5)		;44012: 526dfffe
LAB_44016:
	MOVE.W	($A,A5),D0		;44016: 302d000a
	ADDQ.W	#8,D0			;4401a: 5040
	MOVE.W	(-2,A5),D1		;4401c: 322dfffe
	CMP.W	D0,D1			;44020: b240
	BLT.W	LAB_43F6A		;44022: 6d00ff46
	CMPI.W	#$0001,(_xmin,A4)	;44026: 0c6c00012f8a
	BGE.S	LAB_44034		;4402c: 6c06
	MOVE.W	#$0001,(_xmin,A4)	;4402e: 397c00012f8a
LAB_44034:
	CMPI.W	#$003f,(_xmax,A4)	;44034: 0c6c003f2f8c
	BLE.S	LAB_44042		;4403a: 6f06
	MOVE.W	#$003f,(_xmax,A4)	;4403c: 397c003f2f8c
LAB_44042:
	CMPI.W	#$0001,(_ymin,A4)	;44042: 0c6c00012f8e
	BGE.S	LAB_44050		;44048: 6c06
	MOVE.W	#$0001,(_ymin,A4)	;4404a: 397c00012f8e
LAB_44050:
	CMPI.W	#$003f,(_ymax,A4)	;44050: 0c6c003f2f90
	BLE.S	LAB_4405E		;44056: 6f06
	MOVE.W	#$003f,(_ymax,A4)	;44058: 397c003f2f90
LAB_4405E:
	MOVE.W	(_ymax,A4),-(A7)	;4405e: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;44062: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;44066: 302c2f8e
	SUBQ.W	#1,D0			;4406a: 5340
	MOVE.W	D0,-(A7)		;4406c: 3f00
	MOVE.W	(_xmin,A4),D0		;4406e: 302c2f8a
	SUBQ.W	#1,D0			;44072: 5340
	MOVE.W	D0,-(A7)		;44074: 3f00
	JSR	(___make_map,A4)	;44076: 4eac8020
	ADDQ.W	#8,A7			;4407a: 504f
	MOVE.W	#$ffff,-(A7)		;4407c: 3f3cffff
	PEA	-1.W			;44080: 4878ffff
	MOVE.L	(_back_scr,A4),-(A7)	;44084: 2f2c9874
	JSR	(___Setscreen,A4)	;44088: 4eac80c2
	LEA	($A,A7),A7		;4408c: 4fef000a
	MOVE.W	(_ymax,A4),-(A7)	;44090: 3f2c2f90
	MOVE.W	(_xmax,A4),-(A7)	;44094: 3f2c2f8c
	MOVE.W	(_ymin,A4),D0		;44098: 302c2f8e
	SUBQ.W	#1,D0			;4409c: 5340
	MOVE.W	D0,-(A7)		;4409e: 3f00
	MOVE.W	(_xmin,A4),D0		;440a0: 302c2f8a
	SUBQ.W	#1,D0			;440a4: 5340
	MOVE.W	D0,-(A7)		;440a6: 3f00
	JSR	(___draw_map,A4)	;440a8: 4eac8026
	ADDQ.W	#8,A7			;440ac: 504f
	MOVE.W	#$ffff,-(A7)		;440ae: 3f3cffff
	PEA	-1.W			;440b2: 4878ffff
	MOVE.L	(_w_screen,A4),-(A7)	;440b6: 2f2c99e8
	JSR	(___Setscreen,A4)	;440ba: 4eac80c2
	LEA	($A,A7),A7		;440be: 4fef000a
	MOVE.W	#$004b,(_effect,A4)	;440c2: 397c004b2fac
	BRA.W	LAB_43E58		;440c8: 6000fd8e
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_magnet_to:
	LINK.W	A5,#0			;440cc: 4e550000
	TST.W	(_pause,A4)		;440d0: 4a6c9c22
	BEQ.S	LAB_440DA		;440d4: 6704
LAB_440D6:
	UNLK	A5			;440d6: 4e5d
	RTS				;440d8: 4e75
LAB_440DA:
	MOVE.W	(8,A5),D0		;440da: 302d0008
	EXT.L	D0			;440de: 48c0
	ASL.L	#4,D0			;440e0: e980
	LEA	(LAB_52DE6,A4),A0	;440e2: 41ec99f8
	MOVE.W	($A,A5),(0,A0,D0.L)	;440e6: 31ad000a0800
	TST.W	(8,A5)			;440ec: 4a6d0008
	BNE.S	LAB_440FA		;440f0: 6608
	MOVE.W	($A,A5),(_god_magnet,A4) ;440f2: 396d000aae78
	BRA.S	LAB_44100		;440f8: 6006
LAB_440FA:
	MOVE.W	($A,A5),(_devil_magnet,A4) ;440fa: 396d000aae76
LAB_44100:
	BRA.S	LAB_440D6		;44100: 60d4
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_swamp:
	LINK.W	A5,#-8			;44102: 4e55fff8
	TST.W	(_paint_map,A4)		;44106: 4a6c9c24
	BNE.S	LAB_4415A		;4410a: 664e
	MOVE.W	(8,A5),D0		;4410c: 302d0008
	EXT.L	D0			;44110: 48c0
	ASL.L	#4,D0			;44112: e980
	LEA	(LAB_52DF0,A4),A0	;44114: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;44118: 22300800
	CMP.L	(LAB_51884,A4),D1	;4411c: b2ac8496
	BLT.S	LAB_44142		;44120: 6d20
	TST.W	(_war,A4)		;44122: 4a6cae80
	BNE.S	LAB_44142		;44126: 661a
	TST.W	(_pause,A4)		;44128: 4a6c9c22
	BNE.S	LAB_44142		;4412c: 6614
	MOVE.W	(8,A5),D0		;4412e: 302d0008
	MULS	#$002e,D0		;44132: c1fc002e
	LEA	(LAB_516B2,A4),A0	;44136: 41ec82c4
	BTST	#4,(1,A0,D0.L)		;4413a: 083000040801
	BNE.S	LAB_44146		;44140: 6604
LAB_44142:
	UNLK	A5			;44142: 4e5d
	RTS				;44144: 4e75
LAB_44146:
	MOVE.W	(8,A5),D0		;44146: 302d0008
	EXT.L	D0			;4414a: 48c0
	ASL.L	#4,D0			;4414c: e980
	LEA	(LAB_52DF0,A4),A0	;4414e: 41ec9a02
	ADDA.L	D0,A0			;44152: d1c0
	MOVE.L	(LAB_51884,A4),D0	;44154: 202c8496
	SUB.L	D0,(A0)			;44158: 9190
LAB_4415A:
	MOVE.W	(8,A5),D0		;4415a: 302d0008
	CMP.W	(_player,A4),D0		;4415e: b06c99f4
	BNE.S	LAB_4416C		;44162: 6608
; +50 points per swamp
	ADDI.L	#$00000032,(_score,A4)	;44164: 06ac00000032ae72
LAB_4416C:
	CLR.W	(-6,A5)			;4416c: 426dfffa
LAB_44170:
	JSR	(___newrand,A4)		;44170: 4eac80fe
	EXT.L	D0			;44174: 48c0
	DIVS	#$0007,D0		;44176: 81fc0007
	SWAP	D0			;4417a: 4840
	ADD.W	($A,A5),D0		;4417c: d06d000a
	SUBQ.W	#3,D0			;44180: 5740
	MOVE.W	D0,(-2,A5)		;44182: 3b40fffe
	JSR	(___newrand,A4)		;44186: 4eac80fe
	EXT.L	D0			;4418a: 48c0
	DIVS	#$0007,D0		;4418c: 81fc0007
	SWAP	D0			;44190: 4840
	ADD.W	($C,A5),D0		;44192: d06d000c
	SUBQ.W	#3,D0			;44196: 5740
	MOVE.W	D0,(-4,A5)		;44198: 3b40fffc
	MOVE.W	(-4,A5),D0		;4419c: 302dfffc
	ASL.W	#6,D0			;441a0: ed40
	ADD.W	(-2,A5),D0		;441a2: d06dfffe
	LEA	(_map_blk,A4),A0	;441a6: 41eccf88
	MOVEQ	#0,D1			;441aa: 7200
	MOVE.B	(0,A0,D0.W),D1		;441ac: 12300000
	MOVE.W	D1,(-8,A5)		;441b0: 3b41fff8
	TST.W	(-2,A5)			;441b4: 4a6dfffe
	BLT.S	LAB_44218		;441b8: 6d5e
	CMPI.W	#$0040,(-2,A5)		;441ba: 0c6d0040fffe
	BGE.S	LAB_44218		;441c0: 6c56
	TST.W	(-4,A5)			;441c2: 4a6dfffc
	BLT.S	LAB_44218		;441c6: 6d50
	CMPI.W	#$0040,(-4,A5)		;441c8: 0c6d0040fffc
	BGE.S	LAB_44218		;441ce: 6c48
	CMPI.W	#$000f,(-8,A5)		;441d0: 0c6d000ffff8
	BEQ.S	LAB_441F0		;441d6: 6718
	CMPI.W	#$001f,(-8,A5)		;441d8: 0c6d001ffff8
	BEQ.S	LAB_441F0		;441de: 6710
	CMPI.W	#$0020,(-8,A5)		;441e0: 0c6d0020fff8
	BEQ.S	LAB_441F0		;441e6: 6708
	CMPI.W	#$0042,(-8,A5)		;441e8: 0c6d0042fff8
	BNE.S	LAB_44218		;441ee: 6628
LAB_441F0:
	MOVE.W	(-4,A5),D0		;441f0: 302dfffc
	ASL.W	#6,D0			;441f4: ed40
	ADD.W	(-2,A5),D0		;441f6: d06dfffe
	LEA	(_map_who,A4),A0	;441fa: 41ec1f88
	TST.B	(0,A0,D0.W)		;441fe: 4a300000
	BNE.S	LAB_44218		;44202: 6614
	MOVE.W	(-4,A5),D0		;44204: 302dfffc
	ASL.W	#6,D0			;44208: ed40
	ADD.W	(-2,A5),D0		;4420a: d06dfffe
	LEA	(_map_blk,A4),A0	;4420e: 41eccf88
	MOVE.B	#$35,(0,A0,D0.W)	;44212: 11bc00350000
LAB_44218:
	ADDQ.W	#1,(-6,A5)		;44218: 526dfffa
	CMPI.W	#$001e,(-6,A5)		;4421c: 0c6d001efffa
	BNE.W	LAB_44170		;44222: 6600ff4c
	BRA.W	LAB_44142		;44226: 6000ff1a
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_knight:
	LINK.W	A5,#0			;4422a: 4e550000
	MOVE.W	(8,A5),D0		;4422e: 302d0008
	EXT.L	D0			;44232: 48c0
	ASL.L	#4,D0			;44234: e980
	LEA	(_magnet,A4),A0		;44236: 41ec99f6
	TST.W	(0,A0,D0.L)		;4423a: 4a700800
	BNE.S	LAB_44244		;4423e: 6604
return_44240:
	UNLK	A5			;44240: 4e5d
	RTS				;44242: 4e75
LAB_44244:
	TST.W	(_paint_map,A4)		;44244: 4a6c9c24
	BNE.S	LAB_44296		;44248: 664c
	MOVE.W	(8,A5),D0		;4424a: 302d0008
	EXT.L	D0			;4424e: 48c0
	ASL.L	#4,D0			;44250: e980
	LEA	(LAB_52DF0,A4),A0	;44252: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;44256: 22300800
	CMP.L	(LAB_51888,A4),D1	;4425a: b2ac849a
	BLT.S	return_44280		;4425e: 6d20
	TST.W	(_war,A4)		;44260: 4a6cae80
	BNE.S	return_44280		;44264: 661a
	TST.W	(_pause,A4)		;44266: 4a6c9c22
	BNE.S	return_44280		;4426a: 6614
	MOVE.W	(8,A5),D0		;4426c: 302d0008
	MULS	#$002e,D0		;44270: c1fc002e
	LEA	(LAB_516B2,A4),A0	;44274: 41ec82c4
	BTST	#5,(1,A0,D0.L)		;44278: 083000050801
	BNE.S	LAB_44282		;4427e: 6602
return_44280:
	BRA.S	return_44240		;44280: 60be
LAB_44282:
	MOVE.W	(8,A5),D0		;44282: 302d0008
	EXT.L	D0			;44286: 48c0
	ASL.L	#4,D0			;44288: e980
	LEA	(LAB_52DF0,A4),A0	;4428a: 41ec9a02
	ADDA.L	D0,A0			;4428e: d1c0
	MOVE.L	(LAB_51888,A4),D0	;44290: 202c849a
	SUB.L	D0,(A0)			;44294: 9190
LAB_44296:
	MOVE.W	(8,A5),D0		;44296: 302d0008
	CMP.W	(_player,A4),D0		;4429a: b06c99f4
	BNE.S	LAB_442A8		;4429e: 6608
; +150 points for knight
	ADDI.L	#$00000096,(_score,A4)	;442a0: 06ac00000096ae72
LAB_442A8:
	MOVE.W	(8,A5),D0		;442a8: 302d0008
	EXT.L	D0			;442ac: 48c0
	ASL.L	#4,D0			;442ae: e980
	LEA	(_magnet,A4),A0		;442b0: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;442b4: 32300800
	SUBQ.W	#1,D1			;442b8: 5341
	MULS	#$0016,D1		;442ba: c3fc0016
	LEA	(LAB_53028,A4),A0	;442be: 41ec9c3a
	MOVE.B	#$01,(0,A0,D1.L)	;442c2: 11bc00011800
	MOVE.W	(8,A5),D0		;442c8: 302d0008
	EXT.L	D0			;442cc: 48c0
	ASL.L	#4,D0			;442ce: e980
	LEA	(_magnet,A4),A0		;442d0: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;442d4: 32300800
	SUBQ.W	#1,D1			;442d8: 5341
	MULS	#$0016,D1		;442da: c3fc0016
	LEA	(_peeps,A4),A0		;442de: 41ec9c26
	ADD.L	A0,D1			;442e2: d288
	MOVE.L	D1,-(A7)		;442e4: 2f01
	JSR	(___get_heading,A4)	;442e6: 4eac8038
	ADDQ.W	#4,A7			;442ea: 584f
	MOVE.W	(8,A5),D0		;442ec: 302d0008
	EXT.L	D0			;442f0: 48c0
	ASL.L	#4,D0			;442f2: e980
	LEA	(_magnet,A4),A0		;442f4: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;442f8: 32300800
	SUBQ.W	#1,D1			;442fc: 5341
	MULS	#$0016,D1		;442fe: c3fc0016
	LEA	(LAB_5301C,A4),A0	;44302: 41ec9c2e
	MOVE.W	(0,A0,D1.L),-(A7)	;44306: 3f301800
	MOVE.W	(8,A5),-(A7)		;4430a: 3f2d0008
	JSR	(_set_magnet_to,PC)	;4430e: 4ebafdbc
	ADDQ.W	#4,A7			;44312: 584f
	MOVE.W	(8,A5),D0		;44314: 302d0008
	EXT.L	D0			;44318: 48c0
	ASL.L	#4,D0			;4431a: e980
	LEA	(_magnet,A4),A0		;4431c: 41ec99f6
	CLR.W	(0,A0,D0.L)		;44320: 42700800
	MOVE.W	#$0045,(_effect,A4)	;44324: 397c00452fac
	BRA.W	return_44240		;4432a: 6000ff14
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_war:
	LINK.W	A5,#-2			;4432e: 4e55fffe
	TST.W	(_paint_map,A4)		;44332: 4a6c9c24
	BNE.S	LAB_44392		;44336: 665a
	MOVE.W	(8,A5),D0		;44338: 302d0008
	EXT.L	D0			;4433c: 48c0
	ASL.L	#4,D0			;4433e: e980
	LEA	(LAB_52DF0,A4),A0	;44340: 41ec9a02
	MOVE.L	(0,A0,D0.L),D1		;44344: 22300800
	CMP.L	(LAB_51894,A4),D1	;44348: b2ac84a6
	BLT.S	LAB_44368		;4434c: 6d1a
	TST.W	(_pause,A4)		;4434e: 4a6c9c22
	BNE.S	LAB_44368		;44352: 6614
	MOVE.W	(8,A5),D0		;44354: 302d0008
	MULS	#$002e,D0		;44358: c1fc002e
	LEA	(LAB_516B2,A4),A0	;4435c: 41ec82c4
	BTST	#0,(0,A0,D0.L)		;44360: 083000000800
	BNE.S	LAB_4436C		;44366: 6604
LAB_44368:
	UNLK	A5			;44368: 4e5d
	RTS				;4436a: 4e75
LAB_4436C:
	MOVE.W	(8,A5),D0		;4436c: 302d0008
	EXT.L	D0			;44370: 48c0
	ASL.L	#4,D0			;44372: e980
	LEA	(LAB_52DF0,A4),A0	;44374: 41ec9a02
	ADDA.L	D0,A0			;44378: d1c0
	MOVE.L	(LAB_51894,A4),D0	;4437a: 202c84a6
	SUB.L	D0,(A0)			;4437e: 9190
	MOVE.W	(8,A5),D0		;44380: 302d0008
	CMP.W	(_player,A4),D0		;44384: b06c99f4
	BNE.S	LAB_44392		;44388: 6608
; +5000 points for armageddon
	ADDI.L	#$00001388,(_score,A4)	;4438a: 06ac00001388ae72
LAB_44392:
	CLR.W	(-2,A5)			;44392: 426dfffe
	BRA.S	LAB_443AC		;44396: 6014
LAB_44398:
	MOVE.W	(-2,A5),D0		;44398: 302dfffe
	MULS	#$0016,D0		;4439c: c1fc0016
	LEA	(LAB_53022,A4),A0	;443a0: 41ec9c34
	CLR.L	(0,A0,D0.L)		;443a4: 42b00800
	ADDQ.W	#1,(-2,A5)		;443a8: 526dfffe
LAB_443AC:
	MOVE.W	(-2,A5),D0		;443ac: 302dfffe
	CMP.W	(_no_peeps,A4),D0	;443b0: b06cae5e
	BLT.S	LAB_44398		;443b4: 6de2
	MOVE.W	#$0049,(_effect,A4)	;443b6: 397c00492fac
	MOVE.W	#$0001,(_war,A4)	;443bc: 397c0001ae80
	BRA.S	LAB_44368		;443c2: 60a4
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_make_woods_rocks:
	LINK.W	A5,#-14			;443c4: 4e55fff2
	CLR.W	(-10,A5)		;443c8: 426dfff6
LAB_443CC:
	CMPI.W	#$0007,(-10,A5)		;443cc: 0c6d0007fff6
	BGE.S	LAB_443D8		;443d2: 6c04
	MOVEQ	#1,D0			;443d4: 7001
	BRA.S	LAB_443DA		;443d6: 6002
LAB_443D8:
	MOVEQ	#0,D0			;443d8: 7000
LAB_443DA:
	MULS	#$0003,D0		;443da: c1fc0003
	MOVEQ	#$32,D1			;443de: 7232
	SUB.W	D0,D1			;443e0: 9240
	MOVE.W	D1,(-14,A5)		;443e2: 3b41fff2
	JSR	(___newrand,A4)		;443e6: 4eac80fe
	EXT.L	D0			;443ea: 48c0
	DIVS	#$003b,D0		;443ec: 81fc003b
	SWAP	D0			;443f0: 4840
	MOVE.W	D0,(-6,A5)		;443f2: 3b40fffa
	JSR	(___newrand,A4)		;443f6: 4eac80fe
	EXT.L	D0			;443fa: 48c0
	DIVS	#$003b,D0		;443fc: 81fc003b
	SWAP	D0			;44400: 4840
	MOVE.W	D0,(-8,A5)		;44402: 3b40fff8
	CLR.W	(-12,A5)		;44406: 426dfff4
LAB_4440A:
	JSR	(___newrand,A4)		;4440a: 4eac80fe
	EXT.L	D0			;4440e: 48c0
	DIVS	#$0009,D0		;44410: 81fc0009
	SWAP	D0			;44414: 4840
	ADD.W	(-6,A5),D0		;44416: d06dfffa
	MOVE.W	D0,(-2,A5)		;4441a: 3b40fffe
	JSR	(___newrand,A4)		;4441e: 4eac80fe
	EXT.L	D0			;44422: 48c0
	DIVS	#$0009,D0		;44424: 81fc0009
	SWAP	D0			;44428: 4840
	ADD.W	(-8,A5),D0		;4442a: d06dfff8
	MOVE.W	D0,(-4,A5)		;4442e: 3b40fffc
	TST.W	(-2,A5)			;44432: 4a6dfffe
	BLT.W	LAB_444CC		;44436: 6d000094
	CMPI.W	#$0040,(-2,A5)		;4443a: 0c6d0040fffe
	BGE.W	LAB_444CC		;44440: 6c00008a
	TST.W	(-4,A5)			;44444: 4a6dfffc
	BLT.W	LAB_444CC		;44448: 6d000082
	CMPI.W	#$0040,(-4,A5)		;4444c: 0c6d0040fffc
	BGE.S	LAB_444CC		;44452: 6c78
	MOVE.W	(-4,A5),D0		;44454: 302dfffc
	ASL.W	#6,D0			;44458: ed40
	ADD.W	(-2,A5),D0		;4445a: d06dfffe
	LEA	(_map_blk,A4),A0	;4445e: 41eccf88
	TST.B	(0,A0,D0.W)		;44462: 4a300000
	BEQ.S	LAB_444CC		;44466: 6764
	MOVE.W	(-4,A5),D0		;44468: 302dfffc
	ASL.W	#6,D0			;4446c: ed40
	ADD.W	(-2,A5),D0		;4446e: d06dfffe
	LEA	(_map_blk,A4),A0	;44472: 41eccf88
	CMPI.B	#$2f,(0,A0,D0.W)	;44476: 0c30002f0000
	BEQ.S	LAB_444CC		;4447c: 674e
	CMPI.W	#$002f,(-14,A5)		;4447e: 0c6d002ffff2
	BNE.S	LAB_444AA		;44484: 6624
	JSR	(___newrand,A4)		;44486: 4eac80fe
	EXT.L	D0			;4448a: 48c0
	DIVS	#$0003,D0		;4448c: 81fc0003
	SWAP	D0			;44490: 4840
	ADD.W	(-14,A5),D0		;44492: d06dfff2
	MOVE.W	(-4,A5),D1		;44496: 322dfffc
	ASL.W	#6,D1			;4449a: ed41
	ADD.W	(-2,A5),D1		;4449c: d26dfffe
	LEA	(_map_blk,A4),A0	;444a0: 41eccf88
	MOVE.B	D0,(0,A0,D1.W)		;444a4: 11801000
	BRA.S	LAB_444CC		;444a8: 6022
LAB_444AA:
	JSR	(___newrand,A4)		;444aa: 4eac80fe
	EXT.L	D0			;444ae: 48c0
	DIVS	#$0003,D0		;444b0: 81fc0003
	SWAP	D0			;444b4: 4840
	ADD.W	(-14,A5),D0		;444b6: d06dfff2
	MOVE.W	(-4,A5),D1		;444ba: 322dfffc
	ASL.W	#6,D1			;444be: ed41
	ADD.W	(-2,A5),D1		;444c0: d26dfffe
	LEA	(_map_bk2,A4),A0	;444c4: 41ecef88
	MOVE.B	D0,(0,A0,D1.W)		;444c8: 11801000
LAB_444CC:
	ADDQ.W	#1,(-12,A5)		;444cc: 526dfff4
	CMPI.W	#$001e,(-12,A5)		;444d0: 0c6d001efff4
	BNE.W	LAB_4440A		;444d6: 6600ff32
	ADDQ.W	#1,(-10,A5)		;444da: 526dfff6
	CMPI.W	#$0016,(-10,A5)		;444de: 0c6d0016fff6
	BNE.W	LAB_443CC		;444e4: 6600fee6
	UNLK	A5			;444e8: 4e5d
	RTS				;444ea: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_funny:
	LINK.W	A5,#-12			;444ec: 4e55fff4
	LEA	(LAB_5420A,A4),A0	;444f0: 41ecae1c
	MOVE.L	A0,(-4,A5)		;444f4: 2b48fffc
	MOVE.W	#$00d1,(-6,A5)		;444f8: 3b7c00d1fffa
LAB_444FE:
	MOVEA.L	(-4,A5),A0		;444fe: 206dfffc
	TST.W	(4,A0)			;44502: 4a680004
	BEQ.W	LAB_447D8		;44506: 670002d0
	MOVEA.L	(-4,A5),A0		;4450a: 206dfffc
	ADDQ.W	#1,($C,A0)		;4450e: 5268000c
	MOVEA.L	(-4,A5),A0		;44512: 206dfffc
	MOVE.B	($15,A0),D0		;44516: 10280015
	EXT.W	D0			;4451a: 4880
	MOVE.W	D0,(-8,A5)		;4451c: 3b40fff8
	MOVEA.L	(-4,A5),A0		;44520: 206dfffc
	MOVE.W	(-8,A5),D0		;44524: 302dfff8
	ADD.W	D0,(6,A0)		;44528: d1680006
	MOVEA.L	(-4,A5),A0		;4452c: 206dfffc
	MOVEA.L	(-4,A5),A1		;44530: 226dfffc
	MOVEQ	#0,D0			;44534: 7000
	MOVE.B	(2,A1),D0		;44536: 10290002
	MOVE.W	(6,A0),D1		;4453a: 32280006
	CMP.W	D0,D1			;4453e: b240
	BCC.S	LAB_44558		;44540: 6416
	MOVEA.L	(-4,A5),A0		;44542: 206dfffc
	MOVEA.L	(-4,A5),A1		;44546: 226dfffc
	MOVEQ	#0,D0			;4454a: 7000
	MOVE.B	(3,A1),D0		;4454c: 10290003
	MOVE.W	(6,A0),D1		;44550: 32280006
	CMP.W	D0,D1			;44554: b240
	BHI.S	LAB_44566		;44556: 620e
LAB_44558:
	NEG.W	(-8,A5)			;44558: 446dfff8
	MOVEA.L	(-4,A5),A0		;4455c: 206dfffc
	MOVE.B	(-7,A5),($15,A0)	;44560: 116dfff90015
LAB_44566:
	MOVEA.L	(-4,A5),A0		;44566: 206dfffc
	CMPI.W	#$0007,($C,A0)		;4456a: 0c680007000c
	BLE.W	LAB_447D8		;44570: 6f000266
	MOVEA.L	(-4,A5),A0		;44574: 206dfffc
	CLR.W	($C,A0)			;44578: 4268000c
	MOVEA.L	(-4,A5),A0		;4457c: 206dfffc
	MOVE.W	(8,A0),D0		;44580: 30280008
	LEA	(_map_who,A4),A0	;44584: 41ec1f88
	MOVEQ	#0,D1			;44588: 7200
	MOVE.B	(0,A0,D0.W),D1		;4458a: 12300000
	SUBQ.W	#1,D1			;4458e: 5341
	CMP.W	(-6,A5),D1		;44590: b26dfffa
	BNE.S	LAB_445A6		;44594: 6610
	MOVEA.L	(-4,A5),A0		;44596: 206dfffc
	MOVE.W	(8,A0),D0		;4459a: 30280008
	LEA	(_map_who,A4),A0	;4459e: 41ec1f88
	CLR.B	(0,A0,D0.W)		;445a2: 42300000
LAB_445A6:
	MOVEA.L	(-4,A5),A0		;445a6: 206dfffc
	TST.W	($A,A0)			;445aa: 4a68000a
	BNE.S	LAB_445D0		;445ae: 6620
	MOVEA.L	(-4,A5),A0		;445b0: 206dfffc
	MOVE.B	($14,A0),D0		;445b4: 10280014
	EXT.W	D0			;445b8: 4880
	EXT.L	D0			;445ba: 48c0
	MOVEQ	#$C,D1			;445bc: 720c
	JSR	(___mulu,A4)		;445be: 4eac81c4
	LEA	(_funny,A4),A0		;445c2: 41ec8292
	MOVEA.L	(-4,A5),A1		;445c6: 226dfffc
	MOVE.W	(0,A0,D0.L),($A,A1)	;445ca: 33700800000a
LAB_445D0:
	MOVEA.L	(-4,A5),A0		;445d0: 206dfffc
	MOVE.W	($A,A0),-(A7)		;445d4: 3f28000a
	MOVEA.L	(-4,A5),A0		;445d8: 206dfffc
	MOVE.W	(8,A0),-(A7)		;445dc: 3f280008
	JSR	(___valid_move,A4)	;445e0: 4eac817c
	ADDQ.W	#4,A7			;445e4: 584f
	MOVE.W	D0,(-8,A5)		;445e6: 3b40fff8
	CMPI.W	#$0001,(-8,A5)		;445ea: 0c6d0001fff8
	BNE.S	LAB_445FE		;445f0: 660c
	MOVEA.L	(-4,A5),A0		;445f2: 206dfffc
	CLR.W	(4,A0)			;445f6: 42680004
	BRA.W	LAB_447D8		;445fa: 600001dc
LAB_445FE:
	MOVEA.L	(-4,A5),A0		;445fe: 206dfffc
	MOVEA.L	(-4,A5),A1		;44602: 226dfffc
	MOVE.W	($A,A1),D0		;44606: 3029000a
	ADD.W	D0,(8,A0)		;4460a: d1680008
	CLR.W	(-8,A5)			;4460e: 426dfff8
LAB_44612:
	MOVEA.L	(-4,A5),A0		;44612: 206dfffc
	MOVE.B	($14,A0),D0		;44616: 10280014
	EXT.W	D0			;4461a: 4880
	EXT.L	D0			;4461c: 48c0
	MOVEQ	#$C,D1			;4461e: 720c
	JSR	(___mulu,A4)		;44620: 4eac81c4
	MOVE.W	(-8,A5),D1		;44624: 322dfff8
	EXT.L	D1			;44628: 48c1
	ASL.L	#1,D1			;4462a: e381
	ADD.L	D1,D0			;4462c: d081
	LEA	(LAB_51686,A4),A0	;4462e: 41ec8298
	MOVE.W	(0,A0,D0.L),-(A7)	;44632: 3f300800
	MOVEA.L	(-4,A5),A0		;44636: 206dfffc
	MOVE.W	(8,A0),-(A7)		;4463a: 3f280008
	JSR	(___valid_move,A4)	;4463e: 4eac817c
	ADDQ.W	#4,A7			;44642: 584f
	MOVE.W	D0,(-12,A5)		;44644: 3b40fff4
	CMP.W	#$0001,D0		;44648: b07c0001
	BEQ.W	LAB_447B4		;4464c: 67000166
	MOVEA.L	(-4,A5),A0		;44650: 206dfffc
	MOVE.B	($14,A0),D0		;44654: 10280014
	EXT.W	D0			;44658: 4880
	EXT.L	D0			;4465a: 48c0
	MOVEQ	#$C,D1			;4465c: 720c
	JSR	(___mulu,A4)		;4465e: 4eac81c4
	MOVE.W	(-8,A5),D1		;44662: 322dfff8
	EXT.L	D1			;44666: 48c1
	ASL.L	#1,D1			;44668: e381
	ADD.L	D1,D0			;4466a: d081
	LEA	(LAB_51686,A4),A0	;4466c: 41ec8298
	MOVEA.L	(-4,A5),A1		;44670: 226dfffc
	MOVE.W	(0,A0,D0.L),D1		;44674: 32300800
	ADD.W	(8,A1),D1		;44678: d2690008
	MOVE.W	D1,(-10,A5)		;4467c: 3b41fff6
	MOVEA.L	(-4,A5),A0		;44680: 206dfffc
	TST.B	($14,A0)		;44684: 4a280014
	BNE.S	LAB_446C0		;44688: 6636
	MOVE.W	(-10,A5),D0		;4468a: 302dfff6
	LEA	(_map_blk,A4),A0	;4468e: 41eccf88
	TST.B	(0,A0,D0.W)		;44692: 4a300000
	BEQ.S	LAB_446BC		;44696: 6724
	MOVE.W	(-10,A5),D0		;44698: 302dfff6
	LEA	(_map_blk,A4),A0	;4469c: 41eccf88
	CMPI.B	#$10,(0,A0,D0.W)	;446a0: 0c3000100000
	BEQ.S	LAB_446BC		;446a6: 6714
	MOVE.W	(-8,A5),D0		;446a8: 302dfff8
	ADD.W	#$0032,D0		;446ac: d07c0032
	MOVE.W	(-10,A5),D1		;446b0: 322dfff6
	LEA	(_map_bk2,A4),A0	;446b4: 41ecef88
	MOVE.B	D0,(0,A0,D1.W)		;446b8: 11801000
LAB_446BC:
	BRA.W	LAB_44772		;446bc: 600000b4
LAB_446C0:
	MOVEA.L	(-4,A5),A0		;446c0: 206dfffc
	CMPI.B	#$01,($14,A0)		;446c4: 0c2800010014
	BNE.S	LAB_4471C		;446ca: 6650
	MOVE.W	(-10,A5),D0		;446cc: 302dfff6
	LEA	(_map_blk,A4),A0	;446d0: 41eccf88
	CMPI.B	#$0f,(0,A0,D0.W)	;446d4: 0c30000f0000
	BEQ.S	LAB_4470C		;446da: 6730
	MOVE.W	(-10,A5),D0		;446dc: 302dfff6
	LEA	(_map_blk,A4),A0	;446e0: 41eccf88
	CMPI.B	#$1f,(0,A0,D0.W)	;446e4: 0c30001f0000
	BEQ.S	LAB_4470C		;446ea: 6720
	MOVE.W	(-10,A5),D0		;446ec: 302dfff6
	LEA	(_map_blk,A4),A0	;446f0: 41eccf88
	CMPI.B	#$20,(0,A0,D0.W)	;446f4: 0c3000200000
	BEQ.S	LAB_4470C		;446fa: 6710
	MOVE.W	(-10,A5),D0		;446fc: 302dfff6
	LEA	(_map_blk,A4),A0	;44700: 41eccf88
	CMPI.B	#$42,(0,A0,D0.W)	;44704: 0c3000420000
	BNE.S	LAB_4471A		;4470a: 660e
LAB_4470C:
	MOVE.W	(-10,A5),D0		;4470c: 302dfff6
	LEA	(_map_blk,A4),A0	;44710: 41eccf88
	MOVE.B	#$35,(0,A0,D0.W)	;44714: 11bc00350000
LAB_4471A:
	BRA.S	LAB_44772		;4471a: 6056
LAB_4471C:
	MOVE.W	(-10,A5),D0		;4471c: 302dfff6
	LEA	(_map_blk,A4),A0	;44720: 41eccf88
	TST.B	(0,A0,D0.W)		;44724: 4a300000
	BEQ.S	LAB_44772		;44728: 6748
	MOVE.W	(-10,A5),D0		;4472a: 302dfff6
	LEA	(_map_blk,A4),A0	;4472e: 41eccf88
	CMPI.B	#$10,(0,A0,D0.W)	;44732: 0c3000100000
	BEQ.S	LAB_44772		;44738: 6738
	MOVE.W	(-8,A5),D0		;4473a: 302dfff8
	ADD.W	#$002f,D0		;4473e: d07c002f
	MOVE.W	(-10,A5),D1		;44742: 322dfff6
	LEA	(_map_blk,A4),A0	;44746: 41eccf88
	MOVE.B	D0,(0,A0,D1.W)		;4474a: 11801000
	MOVE.W	(-10,A5),D0		;4474e: 302dfff6
	LEA	(_map_blk,A4),A0	;44752: 41eccf88
	MOVEQ	#0,D1			;44756: 7200
	MOVE.B	(0,A0,D0.W),D1		;44758: 12300000
	LEA	(_map_colour,A4),A0	;4475c: 41ec8370
	MOVEQ	#0,D0			;44760: 7000
	MOVE.B	(0,A0,D1.L),D0		;44762: 10301800
	MOVE.W	D0,-(A7)		;44766: 3f00
	MOVE.W	(-10,A5),-(A7)		;44768: 3f2dfff6
	JSR	(___a_putpixel,A4)	;4476c: 4eac80ce
	ADDQ.W	#4,A7			;44770: 584f
LAB_44772:
	MOVE.W	(-10,A5),D0		;44772: 302dfff6
	LEA	(_map_who,A4),A0	;44776: 41ec1f88
	TST.B	(0,A0,D0.W)		;4477a: 4a300000
	BEQ.S	LAB_447B4		;4477e: 6734
	MOVE.W	(-10,A5),D0		;44780: 302dfff6
	LEA	(_map_who,A4),A0	;44784: 41ec1f88
	MOVEQ	#0,D1			;44788: 7200
	MOVE.B	(0,A0,D0.W),D1		;4478a: 12300000
	SUBQ.W	#1,D1			;4478e: 5341
	MOVE.W	D1,-(A7)		;44790: 3f01
	MOVE.W	(-10,A5),D0		;44792: 302dfff6
	LEA	(_map_who,A4),A0	;44796: 41ec1f88
	MOVEQ	#0,D1			;4479a: 7200
	MOVE.B	(0,A0,D0.W),D1		;4479c: 12300000
	SUBQ.W	#1,D1			;447a0: 5341
	MULU	#$0016,D1		;447a2: c2fc0016
	LEA	(_peeps,A4),A0		;447a6: 41ec9c26
	ADD.L	A0,D1			;447aa: d288
	MOVE.L	D1,-(A7)		;447ac: 2f01
	JSR	(___zero_population,A4)	;447ae: 4eac803e
	ADDQ.W	#6,A7			;447b2: 5c4f
LAB_447B4:
	ADDQ.W	#1,(-8,A5)		;447b4: 526dfff8
	CMPI.W	#$0003,(-8,A5)		;447b8: 0c6d0003fff8
	BLT.W	LAB_44612		;447be: 6d00fe52
	MOVE.W	(-6,A5),D0		;447c2: 302dfffa
	ADDQ.W	#1,D0			;447c6: 5240
	MOVEA.L	(-4,A5),A0		;447c8: 206dfffc
	MOVE.W	(8,A0),D1		;447cc: 32280008
	LEA	(_map_who,A4),A0	;447d0: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;447d4: 11801000
LAB_447D8:
	ADDQ.W	#1,(-6,A5)		;447d8: 526dfffa
	ADDI.L	#$00000016,(-4,A5)	;447dc: 06ad00000016fffc
	CMPI.W	#$00d3,(-6,A5)		;447e4: 0c6d00d3fffa
	BLT.W	LAB_444FE		;447ea: 6d00fd12
	UNLK	A5			;447ee: 4e5d
	RTS				;447f0: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_place_funny:
	LINK.W	A5,#-18			;447f2: 4e55ffee
	CMPI.W	#$0002,(8,A5)		;447f6: 0c6d00020008
	BLE.S	LAB_44802		;447fc: 6f04
LAB_447FE:
	UNLK	A5			;447fe: 4e5d
	RTS				;44800: 4e75
LAB_44802:
	MOVE.W	(_player,A4),D0		;44802: 302c99f4
	MULS	#$002e,D0		;44806: c1fc002e
	LEA	(LAB_516AA,A4),A0	;4480a: 41ec82bc
	ADD.L	A0,D0			;4480e: d088
	MOVE.L	D0,(-6,A5)		;44810: 2b40fffa
	TST.W	(_player,A4)		;44814: 4a6c99f4
	BNE.S	LAB_4481E		;44818: 6604
	MOVEQ	#1,D0			;4481a: 7001
	BRA.S	LAB_44820		;4481c: 6002
LAB_4481E:
	MOVEQ	#0,D0			;4481e: 7000
LAB_44820:
	MULS	#$002e,D0		;44820: c1fc002e
	LEA	(LAB_516AA,A4),A0	;44824: 41ec82bc
	ADD.L	A0,D0			;44828: d088
	MOVE.L	D0,(-10,A5)		;4482a: 2b40fff6
	MOVE.W	#$00d1,(-2,A5)		;4482e: 3b7c00d1fffe
	MOVE.W	(-2,A5),D0		;44834: 302dfffe
	MULS	#$0016,D0		;44838: c1fc0016
	LEA	(_peeps,A4),A0		;4483c: 41ec9c26
	ADD.L	A0,D0			;44840: d088
	MOVE.L	D0,(-18,A5)		;44842: 2b40ffee
	BRA.W	LAB_449BC		;44846: 60000174
LAB_4484A:
	MOVEA.L	(-18,A5),A0		;4484a: 206dffee
	TST.W	(4,A0)			;4484e: 4a680004
	BNE.W	LAB_449B0		;44852: 6600015c
	MOVEA.L	(-18,A5),A0		;44856: 206dffee
	MOVE.W	#$0001,(4,A0)		;4485a: 317c00010004
	MOVEA.L	(-18,A5),A0		;44860: 206dffee
	MOVE.B	#$02,(A0)		;44864: 10bc0002
	TST.W	($A,A5)			;44868: 4a6d000a
	BNE.S	LAB_44890		;4486c: 6622
	MOVEA.L	(-18,A5),A0		;4486e: 206dffee
	MOVE.L	A0,-(A7)		;44872: 2f08
	JSR	(___newrand,A4)		;44874: 4eac80fe
	EXT.L	D0			;44878: 48c0
	DIVS	#$007d,D0		;4487a: 81fc007d
	SWAP	D0			;4487e: 4840
	ASR.W	#1,D0			;44880: e240
	MOVEA.L	(A7)+,A0		;44882: 205f
	ADD.W	#$0fc0,D0		;44884: d07c0fc0
	MOVE.W	D0,(8,A0)		;44888: 31400008
	BRA.W	LAB_44930		;4488c: 600000a2
LAB_44890:
	CMPI.W	#$0001,($A,A5)		;44890: 0c6d0001000a
	BNE.S	LAB_448EA		;44896: 6652
	JSR	(___newrand,A4)		;44898: 4eac80fe
	BTST	#0,D0			;4489c: 08000000
	BEQ.S	LAB_448C6		;448a0: 6724
	MOVEA.L	(-18,A5),A0		;448a2: 206dffee
	MOVE.L	A0,-(A7)		;448a6: 2f08
	JSR	(___newrand,A4)		;448a8: 4eac80fe
	EXT.L	D0			;448ac: 48c0
	DIVS	#$002b,D0		;448ae: 81fc002b
	SWAP	D0			;448b2: 4840
	ADD.W	#$0014,D0		;448b4: d07c0014
	ASL.W	#6,D0			;448b8: ed40
	MOVEA.L	(A7)+,A0		;448ba: 205f
	ADD.W	#$003f,D0		;448bc: d07c003f
	MOVE.W	D0,(8,A0)		;448c0: 31400008
	BRA.S	LAB_448E8		;448c4: 6022
LAB_448C6:
	MOVEA.L	(-18,A5),A0		;448c6: 206dffee
	MOVE.L	A0,-(A7)		;448ca: 2f08
	JSR	(___newrand,A4)		;448cc: 4eac80fe
	EXT.L	D0			;448d0: 48c0
	DIVS	#$002b,D0		;448d2: 81fc002b
	SWAP	D0			;448d6: 4840
	ADD.W	#$0014,D0		;448d8: d07c0014
	ASL.W	#6,D0			;448dc: ed40
	MOVEA.L	(A7)+,A0		;448de: 205f
	ADD.W	#$0fc0,D0		;448e0: d07c0fc0
	MOVE.W	D0,(8,A0)		;448e4: 31400008
LAB_448E8:
	BRA.S	LAB_44930		;448e8: 6046
LAB_448EA:
	CMPI.W	#$0002,($A,A5)		;448ea: 0c6d0002000a
	BNE.S	LAB_44930		;448f0: 663e
	JSR	(___newrand,A4)		;448f2: 4eac80fe
	BTST	#0,D0			;448f6: 08000000
	BEQ.S	LAB_44918		;448fa: 671c
	MOVEA.L	(-18,A5),A0		;448fc: 206dffee
	MOVE.L	A0,-(A7)		;44900: 2f08
	JSR	(___newrand,A4)		;44902: 4eac80fe
	EXT.L	D0			;44906: 48c0
	DIVS	#$002b,D0		;44908: 81fc002b
	SWAP	D0			;4490c: 4840
	MOVEA.L	(A7)+,A0		;4490e: 205f
	ASL.W	#6,D0			;44910: ed40
	MOVE.W	D0,(8,A0)		;44912: 31400008
	BRA.S	LAB_44930		;44916: 6018
LAB_44918:
	MOVEA.L	(-18,A5),A0		;44918: 206dffee
	MOVE.L	A0,-(A7)		;4491c: 2f08
	JSR	(___newrand,A4)		;4491e: 4eac80fe
	MOVEA.L	(A7)+,A0		;44922: 205f
	EXT.L	D0			;44924: 48c0
	DIVS	#$002b,D0		;44926: 81fc002b
	SWAP	D0			;4492a: 4840
	MOVE.W	D0,(8,A0)		;4492c: 31400008
LAB_44930:
	MOVE.W	(-2,A5),D0		;44930: 302dfffe
	ADDQ.W	#1,D0			;44934: 5240
	MOVEA.L	(-18,A5),A0		;44936: 206dffee
	MOVE.W	(8,A0),D1		;4493a: 32280008
	LEA	(_map_who,A4),A0	;4493e: 41ec1f88
	MOVE.B	D0,(0,A0,D1.W)		;44942: 11801000
	MOVE.W	(8,A5),D0		;44946: 302d0008
	MULS	#$000c,D0		;4494a: c1fc000c
	LEA	(_funny,A4),A0		;4494e: 41ec8292
	MOVEA.L	(-18,A5),A1		;44952: 226dffee
	MOVE.W	(0,A0,D0.L),($A,A1)	;44956: 33700800000a
	MOVE.W	(8,A5),D0		;4495c: 302d0008
	MULS	#$000c,D0		;44960: c1fc000c
	LEA	(LAB_51684,A4),A0	;44964: 41ec8296
	MOVEA.L	(-18,A5),A1		;44968: 226dffee
	MOVE.B	(1,A0,D0.L),(2,A1)	;4496c: 137008010002
	MOVE.W	(8,A5),D0		;44972: 302d0008
	MULS	#$000c,D0		;44976: c1fc000c
	LEA	(LAB_51682,A4),A0	;4497a: 41ec8294
	MOVEA.L	(-18,A5),A1		;4497e: 226dffee
	MOVE.B	(1,A0,D0.L),(3,A1)	;44982: 137008010003
	MOVEA.L	(-18,A5),A0		;44988: 206dffee
	MOVE.B	#$01,($15,A0)		;4498c: 117c00010015
	MOVEA.L	(-18,A5),A0		;44992: 206dffee
	MOVEQ	#0,D0			;44996: 7000
	MOVE.B	(3,A0),D0		;44998: 10280003
	MOVEA.L	(-18,A5),A0		;4499c: 206dffee
	MOVE.W	D0,(6,A0)		;449a0: 31400006
	MOVEA.L	(-18,A5),A0		;449a4: 206dffee
	MOVE.B	(9,A5),($14,A0)		;449a8: 116d00090014
	BRA.S	LAB_449C6		;449ae: 6016
; ------------------------------------------------------------------------------
; lines cut
; ------------------------------------------------------------------------------
LAB_449B0:
	ADDQ.W	#1,(-2,A5)		;449b0: 526dfffe
	ADDI.L	#$00000016,(-18,A5)	;449b4: 06ad00000016ffee
LAB_449BC:
	CMPI.W	#$00d3,(-2,A5)		;449bc: 0c6d00d3fffe
	BLT.W	LAB_4484A		;449c2: 6d00fe86
LAB_449C6:
	BRA.W	LAB_447FE		;449c6: 6000fe36
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_make_level:
	LINK.W	A5,#-14			;449ca: 4e55fff2
	MOVEM.L	D4-D6,-(A7)		;449ce: 48e70e00
	MOVE.W	($A,A5),D0		;449d2: 302d000a
	MULS	#$002e,D0		;449d6: c1fc002e
	LEA	(_stats,A4),A0		;449da: 41ec82b6
	ADD.L	A0,D0			;449de: d088
	MOVE.L	D0,(-14,A5)		;449e0: 2b40fff2
	MOVEA.L	(-14,A5),A0		;449e4: 206dfff2
	BTST	#0,($F,A0)		;449e8: 08280000000f
	BEQ.S	LAB_449F8		;449ee: 6708
	BTST	#2,(LAB_518A7,A4)	;449f0: 082c000284b9
	BEQ.S	LAB_44A00		;449f6: 6708
LAB_449F8:
	MOVEM.L	(A7)+,D4-D6		;449f8: 4cdf0070
	UNLK	A5			;449fc: 4e5d
	RTS				;449fe: 4e75
LAB_44A00:
	MOVE.W	(8,A5),D0		;44a00: 302d0008
	AND.W	#$003f,D0		;44a04: c07c003f
	MOVE.W	D0,(-2,A5)		;44a08: 3b40fffe
	MOVE.W	(8,A5),D0		;44a0c: 302d0008
	ASR.W	#6,D0			;44a10: ec40
	MOVE.W	D0,(-4,A5)		;44a12: 3b40fffc
	MOVE.W	(-4,A5),D0		;44a16: 302dfffc
	MULS	#$0041,D0		;44a1a: c1fc0041
	ADD.W	(-2,A5),D0		;44a1e: d06dfffe
	EXT.L	D0			;44a22: 48c0
	ASL.L	#1,D0			;44a24: e380
	LEA	(_alt,A4),A0		;44a26: 41ecae86
	MOVE.W	(0,A0,D0.L),(-10,A5)	;44a2a: 3b700800fff6
	MOVEQ	#0,D6			;44a30: 7c00
LAB_44A32:
	LEA	(_a_flat,A4),A0		;44a32: 41ec9704
	MOVE.B	(0,A0,D6.W),D0		;44a36: 10306000
	EXT.W	D0			;44a3a: 4880
	MOVE.W	D0,D4			;44a3c: 3800
	ADD.W	(-2,A5),D4		;44a3e: d86dfffe
	MOVE.W	D6,D0			;44a42: 3006
	ADDQ.W	#1,D0			;44a44: 5240
	LEA	(_a_flat,A4),A0		;44a46: 41ec9704
	MOVE.B	(0,A0,D0.W),D1		;44a4a: 12300000
	EXT.W	D1			;44a4e: 4881
	MOVE.W	D1,D5			;44a50: 3a01
	ADD.W	(-4,A5),D5		;44a52: da6dfffc
	TST.W	D4			;44a56: 4a44
	BLT.W	LAB_44B68		;44a58: 6d00010e
	CMP.W	#$0040,D4		;44a5c: b87c0040
	BGT.W	LAB_44B68		;44a60: 6e000106
	TST.W	D5			;44a64: 4a45
	BLT.W	LAB_44B68		;44a66: 6d000100
	CMP.W	#$0040,D5		;44a6a: ba7c0040
	BGT.W	LAB_44B68		;44a6e: 6e0000f8
	MOVE.W	D5,D0			;44a72: 3005
	ASL.W	#6,D0			;44a74: ed40
	ADD.W	D4,D0			;44a76: d044
	MOVE.W	D0,(-8,A5)		;44a78: 3b40fff8
	MOVE.W	(-8,A5),D0		;44a7c: 302dfff8
	LEA	(_map_blk,A4),A0	;44a80: 41eccf88
	CMPI.B	#$2f,(0,A0,D0.W)	;44a84: 0c30002f0000
	BNE.S	LAB_44AC8		;44a8a: 663c
	BTST	#3,(LAB_518A7,A4)	;44a8c: 082c000384b9
	BNE.S	LAB_44AC8		;44a92: 6634
	MOVE.W	(-8,A5),D0		;44a94: 302dfff8
	LEA	(_map_blk,A4),A0	;44a98: 41eccf88
	ADDQ.B	#1,(0,A0,D0.W)		;44a9c: 52300000
	MOVEA.L	(-14,A5),A0		;44aa0: 206dfff2
	MOVE.B	#$02,(A0)		;44aa4: 10bc0002
	MOVEA.L	(-14,A5),A0		;44aa8: 206dfff2
	MOVE.B	D4,(1,A0)		;44aac: 11440001
	MOVEA.L	(-14,A5),A0		;44ab0: 206dfff2
	MOVE.B	D5,(2,A0)		;44ab4: 11450002
	MOVEA.L	(-14,A5),A0		;44ab8: 206dfff2
	MOVE.W	#$0001,(8,A0)		;44abc: 317c00010008
	MOVEQ	#0,D0			;44ac2: 7000
	BRA.W	LAB_449F8		;44ac4: 6000ff32
LAB_44AC8:
	MOVE.W	D5,D0			;44ac8: 3005
	MULS	#$0041,D0		;44aca: c1fc0041
	ADD.W	D4,D0			;44ace: d044
	EXT.L	D0			;44ad0: 48c0
	ASL.L	#1,D0			;44ad2: e380
	LEA	(_alt,A4),A0		;44ad4: 41ecae86
	MOVE.W	(-10,A5),D1		;44ad8: 322dfff6
	SUB.W	(0,A0,D0.L),D1		;44adc: 92700800
	MOVE.W	D1,(-6,A5)		;44ae0: 3b41fffa
	TST.W	(-6,A5)			;44ae4: 4a6dfffa
	BLE.S	LAB_44B12		;44ae8: 6f28
	MOVEA.L	(-14,A5),A0		;44aea: 206dfff2
	MOVE.B	#$01,(A0)		;44aee: 10bc0001
	MOVEA.L	(-14,A5),A0		;44af2: 206dfff2
	MOVE.B	D4,(1,A0)		;44af6: 11440001
	MOVEA.L	(-14,A5),A0		;44afa: 206dfff2
	MOVE.B	D5,(2,A0)		;44afe: 11450002
	MOVEA.L	(-14,A5),A0		;44b02: 206dfff2
	MOVE.W	#$0001,(8,A0)		;44b06: 317c00010008
	MOVEQ	#0,D0			;44b0c: 7000
	BRA.W	LAB_449F8		;44b0e: 6000fee8
LAB_44B12:
	TST.W	(-6,A5)			;44b12: 4a6dfffa
	BLT.S	LAB_44B38		;44b16: 6d20
	MOVE.W	(-8,A5),D0		;44b18: 302dfff8
	LEA	(_map_blk,A4),A0	;44b1c: 41eccf88
	CMPI.B	#$42,(0,A0,D0.W)	;44b20: 0c3000420000
	BEQ.S	LAB_44B38		;44b26: 6710
	MOVE.W	(-8,A5),D0		;44b28: 302dfff8
	LEA	(_map_blk,A4),A0	;44b2c: 41eccf88
	CMPI.B	#$35,(0,A0,D0.W)	;44b30: 0c3000350000
	BNE.S	LAB_44B68		;44b36: 6630
LAB_44B38:
	BTST	#3,(LAB_518A7,A4)	;44b38: 082c000384b9
	BNE.S	LAB_44B68		;44b3e: 6628
	MOVEA.L	(-14,A5),A0		;44b40: 206dfff2
	MOVE.B	#$02,(A0)		;44b44: 10bc0002
	MOVEA.L	(-14,A5),A0		;44b48: 206dfff2
	MOVE.B	D4,(1,A0)		;44b4c: 11440001
	MOVEA.L	(-14,A5),A0		;44b50: 206dfff2
	MOVE.B	D5,(2,A0)		;44b54: 11450002
	MOVEA.L	(-14,A5),A0		;44b58: 206dfff2
	MOVE.W	#$0001,(8,A0)		;44b5c: 317c00010008
	MOVEQ	#0,D0			;44b62: 7000
	BRA.W	LAB_449F8		;44b64: 6000fe92
LAB_44B68:
	ADDQ.W	#2,D6			;44b68: 5446
	CMP.W	#$00a2,D6		;44b6a: bc7c00a2
	BLT.W	LAB_44A32		;44b6e: 6d00fec2
	MOVEQ	#1,D0			;44b72: 7001
	BRA.W	LAB_449F8		;44b74: 6000fe82
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_one_block_flat:
	LINK.W	A5,#-12			;44b78: 4e55fff4
	MOVEM.L	D4-D5,-(A7)		;44b7c: 48e70c00
	MOVE.W	($A,A5),D0		;44b80: 302d000a
	MULS	#$002e,D0		;44b84: c1fc002e
	LEA	(_stats,A4),A0		;44b88: 41ec82b6
	ADD.L	A0,D0			;44b8c: d088
	MOVE.L	D0,(-12,A5)		;44b8e: 2b40fff4
	MOVEA.L	(-12,A5),A0		;44b92: 206dfff4
	TST.W	(8,A0)			;44b96: 4a680008
	BNE.S	LAB_44BDA		;44b9a: 663e
	MOVE.W	($A,A5),D0		;44b9c: 302d000a
	EXT.L	D0			;44ba0: 48c0
	ASL.L	#4,D0			;44ba2: e980
	LEA	(LAB_52DF0,A4),A0	;44ba4: 41ec9a02
	CMPI.L	#$00000014,(0,A0,D0.L)	;44ba8: 0cb0000000140800
	BLT.S	LAB_44BDA		;44bb0: 6d28
	MOVE.W	($A,A5),D0		;44bb2: 302d000a
	EXT.L	D0			;44bb6: 48c0
	ASL.L	#4,D0			;44bb8: e980
	LEA	(LAB_52DEA,A4),A0	;44bba: 41ec99fc
	CMPI.W	#$0032,(0,A0,D0.L)	;44bbe: 0c7000320800
	BGT.S	LAB_44BDA		;44bc4: 6e14
	MOVEA.L	(-12,A5),A0		;44bc6: 206dfff4
	BTST	#0,($F,A0)		;44bca: 08280000000f
	BEQ.S	LAB_44BDA		;44bd0: 6708
	BTST	#2,(LAB_518A7,A4)	;44bd2: 082c000284b9
	BEQ.S	LAB_44BE2		;44bd8: 6708
LAB_44BDA:
	MOVEM.L	(A7)+,D4-D5		;44bda: 4cdf0030
	UNLK	A5			;44bde: 4e5d
	RTS				;44be0: 4e75
LAB_44BE2:
	MOVE.W	(8,A5),D0		;44be2: 302d0008
	AND.W	#$003f,D0		;44be6: c07c003f
	MOVE.W	D0,(-2,A5)		;44bea: 3b40fffe
	MOVE.W	(8,A5),D0		;44bee: 302d0008
	ASR.W	#6,D0			;44bf2: ec40
	MOVE.W	D0,(-4,A5)		;44bf4: 3b40fffc
	MOVE.W	(-4,A5),D0		;44bf8: 302dfffc
	MULS	#$0041,D0		;44bfc: c1fc0041
	ADD.W	(-2,A5),D0		;44c00: d06dfffe
	EXT.L	D0			;44c04: 48c0
	ASL.L	#1,D0			;44c06: e380
	LEA	(_alt,A4),A0		;44c08: 41ecae86
	MOVE.W	(-4,A5),D1		;44c0c: 322dfffc
	MULS	#$0041,D1		;44c10: c3fc0041
	ADD.W	(-2,A5),D1		;44c14: d26dfffe
	ADDQ.W	#1,D1			;44c18: 5241
	EXT.L	D1			;44c1a: 48c1
	ASL.L	#1,D1			;44c1c: e381
	LEA	(_alt,A4),A1		;44c1e: 43ecae86
	MOVE.W	(0,A0,D0.L),D2		;44c22: 34300800
	ADD.W	(0,A1,D1.L),D2		;44c26: d4711800
	MOVE.W	(-4,A5),D0		;44c2a: 302dfffc
	MULS	#$0041,D0		;44c2e: c1fc0041
	ADD.W	(-2,A5),D0		;44c32: d06dfffe
	ADD.W	#$0042,D0		;44c36: d07c0042
	EXT.L	D0			;44c3a: 48c0
	ASL.L	#1,D0			;44c3c: e380
	LEA	(_alt,A4),A0		;44c3e: 41ecae86
	ADD.W	(0,A0,D0.L),D2		;44c42: d4700800
	MOVE.W	(-4,A5),D0		;44c46: 302dfffc
	MULS	#$0041,D0		;44c4a: c1fc0041
	ADD.W	(-2,A5),D0		;44c4e: d06dfffe
	ADD.W	#$0041,D0		;44c52: d07c0041
	EXT.L	D0			;44c56: 48c0
	ASL.L	#1,D0			;44c58: e380
	LEA	(_alt,A4),A0		;44c5a: 41ecae86
	ADD.W	(0,A0,D0.L),D2		;44c5e: d4700800
	MOVE.W	D2,(-8,A5)		;44c62: 3b42fff8
	CMPI.W	#$0001,(-8,A5)		;44c66: 0c6d0001fff8
	BNE.S	LAB_44C72		;44c6c: 6604
	BRA.W	LAB_44BDA		;44c6e: 6000ff6a
LAB_44C72:
	MOVE.W	(-8,A5),D0		;44c72: 302dfff8
	EXT.L	D0			;44c76: 48c0
	DIVS	#$0004,D0		;44c78: 81fc0004
	SWAP	D0			;44c7c: 4840
	MOVE.W	D0,(-6,A5)		;44c7e: 3b40fffa
	MOVE.W	(-8,A5),D0		;44c82: 302dfff8
	EXT.L	D0			;44c86: 48c0
	DIVS	#$0004,D0		;44c88: 81fc0004
	MOVE.W	D0,(-8,A5)		;44c8c: 3b40fff8
	MOVE.W	(-2,A5),D4		;44c90: 382dfffe
	BRA.W	LAB_44D4A		;44c94: 600000b4
LAB_44C98:
	MOVE.W	(-4,A5),D5		;44c98: 3a2dfffc
	BRA.W	LAB_44D3C		;44c9c: 6000009e
LAB_44CA0:
	CMPI.W	#$0003,(-6,A5)		;44ca0: 0c6d0003fffa
	BNE.S	LAB_44CEA		;44ca6: 6642
	MOVE.W	D5,D0			;44ca8: 3005
	MULS	#$0041,D0		;44caa: c1fc0041
	ADD.W	D4,D0			;44cae: d044
	EXT.L	D0			;44cb0: 48c0
	ASL.L	#1,D0			;44cb2: e380
	LEA	(_alt,A4),A0		;44cb4: 41ecae86
	MOVE.W	(0,A0,D0.L),D1		;44cb8: 32300800
	CMP.W	(-8,A5),D1		;44cbc: b26dfff8
	BNE.S	LAB_44CE8		;44cc0: 6626
	MOVEA.L	(-12,A5),A0		;44cc2: 206dfff4
	MOVE.B	#$01,(A0)		;44cc6: 10bc0001
	MOVEA.L	(-12,A5),A0		;44cca: 206dfff4
	MOVE.B	D4,(1,A0)		;44cce: 11440001
	MOVEA.L	(-12,A5),A0		;44cd2: 206dfff4
	MOVE.B	D5,(2,A0)		;44cd6: 11450002
	MOVEA.L	(-12,A5),A0		;44cda: 206dfff4
	MOVE.W	#$0001,(8,A0)		;44cde: 317c00010008
	BRA.W	LAB_44BDA		;44ce4: 6000fef4
LAB_44CE8:
	BRA.S	LAB_44D3A		;44ce8: 6050
LAB_44CEA:
	CMPI.W	#$0001,(-6,A5)		;44cea: 0c6d0001fffa
	BNE.S	LAB_44D3A		;44cf0: 6648
	MOVE.W	D5,D0			;44cf2: 3005
	MULS	#$0041,D0		;44cf4: c1fc0041
	ADD.W	D4,D0			;44cf8: d044
	EXT.L	D0			;44cfa: 48c0
	ASL.L	#1,D0			;44cfc: e380
	LEA	(_alt,A4),A0		;44cfe: 41ecae86
	MOVE.W	(0,A0,D0.L),D1		;44d02: 32300800
	CMP.W	(-8,A5),D1		;44d06: b26dfff8
	BLE.S	LAB_44D3A		;44d0a: 6f2e
	BTST	#3,(LAB_518A7,A4)	;44d0c: 082c000384b9
	BNE.S	LAB_44D3A		;44d12: 6626
	MOVEA.L	(-12,A5),A0		;44d14: 206dfff4
	MOVE.B	#$02,(A0)		;44d18: 10bc0002
	MOVEA.L	(-12,A5),A0		;44d1c: 206dfff4
	MOVE.B	D4,(1,A0)		;44d20: 11440001
	MOVEA.L	(-12,A5),A0		;44d24: 206dfff4
	MOVE.B	D5,(2,A0)		;44d28: 11450002
	MOVEA.L	(-12,A5),A0		;44d2c: 206dfff4
	MOVE.W	#$0001,(8,A0)		;44d30: 317c00010008
	BRA.W	LAB_44BDA		;44d36: 6000fea2
LAB_44D3A:
	ADDQ.W	#1,D5			;44d3a: 5245
LAB_44D3C:
	MOVE.W	(-4,A5),D0		;44d3c: 302dfffc
	ADDQ.W	#1,D0			;44d40: 5240
	CMP.W	D0,D5			;44d42: ba40
	BLE.W	LAB_44CA0		;44d44: 6f00ff5a
	ADDQ.W	#1,D4			;44d48: 5244
LAB_44D4A:
	MOVE.W	(-2,A5),D0		;44d4a: 302dfffe
	ADDQ.W	#1,D0			;44d4e: 5240
	CMP.W	D0,D4			;44d50: b840
	BLE.W	LAB_44C98		;44d52: 6f00ff44
	BRA.W	LAB_44BDA		;44d56: 6000fe82
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_devil_effect:
	LINK.W	A5,#-6			;44d5a: 4e55fffa
	MOVE.L	A2,-(A7)		;44d5e: 2f0a
	MOVE.W	(8,A5),D0		;44d60: 302d0008
	MULS	#$002e,D0		;44d64: c1fc002e
	LEA	(_stats,A4),A0		;44d68: 41ec82b6
	MOVEA.L	D0,A2			;44d6c: 2440
	ADDA.L	A0,A2			;44d6e: d5c8
	TST.W	(8,A2)			;44d70: 4a6a0008
	BEQ.S	LAB_44D7C		;44d74: 6706
LAB_44D76:
	MOVEA.L	(A7)+,A2		;44d76: 245f
	UNLK	A5			;44d78: 4e5d
	RTS				;44d7a: 4e75
LAB_44D7C:
	MOVE.W	($E,A2),(-6,A5)		;44d7c: 3b6a000efffa
	BTST	#0,(-6,A5)		;44d82: 082d0000fffa
	BEQ.S	LAB_44DE4		;44d88: 675a
	MOVE.W	(8,A5),D0		;44d8a: 302d0008
	EXT.L	D0			;44d8e: 48c0
	ASL.L	#4,D0			;44d90: e980
	LEA	(LAB_52DF0,A4),A0	;44d92: 41ec9a02
	MOVE.L	(LAB_51894,A4),D1	;44d96: 222c84a6
	ADD.L	#$000003e7,D1		;44d9a: d2bc000003e7
	MOVE.L	(0,A0,D0.L),D2		;44da0: 24300800
	CMP.L	D1,D2			;44da4: b481
	BLE.S	LAB_44DE4		;44da6: 6f3c
	MOVE.W	(8,A5),D0		;44da8: 302d0008
	EXT.L	D0			;44dac: 48c0
	ASL.L	#4,D0			;44dae: e980
	LEA	(good_pop,A4),A0	;44db0: 41ec99fe
	TST.W	(8,A5)			;44db4: 4a6d0008
	BNE.S	LAB_44DBE		;44db8: 6604
	MOVEQ	#1,D1			;44dba: 7201
	BRA.S	LAB_44DC0		;44dbc: 6002
LAB_44DBE:
	MOVEQ	#0,D1			;44dbe: 7200
LAB_44DC0:
	EXT.L	D1			;44dc0: 48c1
	ASL.L	#4,D1			;44dc2: e981
	LEA	(good_pop,A4),A1	;44dc4: 43ec99fe
	MOVE.L	(0,A0,D0.L),D2		;44dc8: 24300800
	CMP.L	(0,A1,D1.L),D2		;44dcc: b4b11800
	BLE.S	LAB_44DE4		;44dd0: 6f12
	MOVE.B	#$0e,(A2)		;44dd2: 14bc000e
	MOVE.B	#$03,(2,A2)		;44dd6: 157c00030002
	MOVE.W	#$0001,(8,A2)		;44ddc: 357c00010008
	BRA.S	LAB_44D76		;44de2: 6092
LAB_44DE4:
	BTST	#7,(-5,A5)		;44de4: 082d0007fffb
	BEQ.S	LAB_44E1E		;44dea: 6732
	MOVE.W	(8,A5),D0		;44dec: 302d0008
	EXT.L	D0			;44df0: 48c0
	ASL.L	#4,D0			;44df2: e980
	LEA	(LAB_52DF0,A4),A0	;44df4: 41ec9a02
	MOVE.L	(LAB_51890,A4),D1	;44df8: 222c84a2
	ADD.L	#$000007cf,D1		;44dfc: d2bc000007cf
	MOVE.L	(0,A0,D0.L),D2		;44e02: 24300800
	CMP.L	D1,D2			;44e06: b481
	BLE.S	LAB_44E1E		;44e08: 6f14
	MOVE.B	#$0e,(A2)		;44e0a: 14bc000e
	MOVE.B	#$04,(2,A2)		;44e0e: 157c00040002
	MOVE.W	#$0001,(8,A2)		;44e14: 357c00010008
	BRA.W	LAB_44D76		;44e1a: 6000ff5a
LAB_44E1E:
	BTST	#5,(-5,A5)		;44e1e: 082d0005fffb
	BEQ.S	LAB_44E8C		;44e24: 6766
	MOVE.W	(8,A5),D0		;44e26: 302d0008
	EXT.L	D0			;44e2a: 48c0
	ASL.L	#4,D0			;44e2c: e980
	LEA	(_magnet,A4),A0		;44e2e: 41ec99f6
	TST.W	(0,A0,D0.L)		;44e32: 4a700800
	BEQ.S	LAB_44E8C		;44e36: 6754
	MOVE.W	(8,A5),D0		;44e38: 302d0008
	EXT.L	D0			;44e3c: 48c0
	ASL.L	#4,D0			;44e3e: e980
	LEA	(_magnet,A4),A0		;44e40: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;44e44: 32300800
	SUBQ.W	#1,D1			;44e48: 5341
	MULS	#$0016,D1		;44e4a: c3fc0016
	LEA	(LAB_53018,A4),A0	;44e4e: 41ec9c2a
	CMPI.W	#$0bb8,(0,A0,D1.L)	;44e52: 0c700bb81800
	BLE.S	LAB_44E8C		;44e58: 6f32
	MOVE.W	(8,A5),D0		;44e5a: 302d0008
	EXT.L	D0			;44e5e: 48c0
	ASL.L	#4,D0			;44e60: e980
	LEA	(LAB_52DF0,A4),A0	;44e62: 41ec9a02
	MOVE.L	(LAB_51888,A4),D1	;44e66: 222c849a
	ADD.L	#$000001f4,D1		;44e6a: d2bc000001f4
	MOVE.L	(0,A0,D0.L),D2		;44e70: 24300800
	CMP.L	D1,D2			;44e74: b481
	BLE.S	LAB_44E88		;44e76: 6f10
	MOVE.B	#$0e,(A2)		;44e78: 14bc000e
	MOVE.B	#$05,(2,A2)		;44e7c: 157c00050002
	MOVE.W	#$0001,(8,A2)		;44e82: 357c00010008
LAB_44E88:
	BRA.W	LAB_44D76		;44e88: 6000feec
LAB_44E8C:
	TST.L	($26,A2)		;44e8c: 4aaa0026
	BEQ.W	LAB_45026		;44e90: 67000194
	MOVE.W	(8,A5),D0		;44e94: 302d0008
	EXT.L	D0			;44e98: 48c0
	ASL.L	#4,D0			;44e9a: e980
	LEA	(LAB_52DF0,A4),A0	;44e9c: 41ec9a02
	MOVE.L	(LAB_5188C,A4),D1	;44ea0: 222c849e
	ADD.L	#$000001f4,D1		;44ea4: d2bc000001f4
	MOVE.L	(0,A0,D0.L),D2		;44eaa: 24300800
	CMP.L	D1,D2			;44eae: b481
	BLE.S	LAB_44ED8		;44eb0: 6f26
	BTST	#6,(-5,A5)		;44eb2: 082d0006fffb
	BEQ.S	LAB_44ED8		;44eb8: 671e
	MOVE.B	#$06,(A2)		;44eba: 14bc0006
	MOVE.L	A2,-(A7)		;44ebe: 2f0a
	MOVE.W	(8,A5),-(A7)		;44ec0: 3f2d0008
	JSR	(_do_computer_effect,PC) ;44ec4: 4eba0164
	ADDQ.W	#6,A7			;44ec8: 5c4f
	MOVE.W	#$0001,(8,A2)		;44eca: 357c00010008
	CLR.W	($12,A2)		;44ed0: 426a0012
	BRA.W	LAB_44D76		;44ed4: 6000fea0
LAB_44ED8:
	MOVE.W	(8,A5),D0		;44ed8: 302d0008
	EXT.L	D0			;44edc: 48c0
	ASL.L	#4,D0			;44ede: e980
	LEA	(LAB_52DF0,A4),A0	;44ee0: 41ec9a02
	MOVE.L	(LAB_51884,A4),D1	;44ee4: 222c8496
	ADD.L	#$000001f4,D1		;44ee8: d2bc000001f4
	MOVE.L	(0,A0,D0.L),D2		;44eee: 24300800
	CMP.L	D1,D2			;44ef2: b481
	BLE.W	LAB_44FCA		;44ef4: 6f0000d4
	BTST	#4,(-5,A5)		;44ef8: 082d0004fffb
	BEQ.W	LAB_44FCA		;44efe: 670000ca
	MOVE.W	($12,A2),D0		;44f02: 302a0012
	CMP.W	($1A,A2),D0		;44f06: b06a001a
	BGE.S	LAB_44F16		;44f0a: 6c0a
	BTST	#3,(-5,A5)		;44f0c: 082d0003fffb
	BNE.W	LAB_44FCA		;44f12: 660000b6
LAB_44F16:
	MOVE.W	($12,A2),D0		;44f16: 302a0012
	CMP.W	($18,A2),D0		;44f1a: b06a0018
	BLE.S	LAB_44F2A		;44f1e: 6f0a
	BTST	#6,(-5,A5)		;44f20: 082d0006fffb
	BNE.W	LAB_44FCA		;44f26: 660000a2
LAB_44F2A:
	TST.W	(8,A5)			;44f2a: 4a6d0008
	BNE.S	LAB_44F34		;44f2e: 6604
	MOVEQ	#1,D0			;44f30: 7001
	BRA.S	LAB_44F36		;44f32: 6002
LAB_44F34:
	MOVEQ	#0,D0			;44f34: 7000
LAB_44F36:
	EXT.L	D0			;44f36: 48c0
	ASL.L	#4,D0			;44f38: e980
	LEA	(_magnet,A4),A0		;44f3a: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;44f3e: 32300800
	SUBQ.W	#1,D1			;44f42: 5341
	MOVE.W	D1,(-2,A5)		;44f44: 3b41fffe
	MOVE.W	(8,A5),D0		;44f48: 302d0008
	EXT.L	D0			;44f4c: 48c0
	ASL.L	#4,D0			;44f4e: e980
	LEA	(_magnet,A4),A0		;44f50: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;44f54: 32300800
	SUBQ.W	#1,D1			;44f58: 5341
	MOVE.W	D1,(-4,A5)		;44f5a: 3b41fffc
	CMPI.W	#$ffff,(-2,A5)		;44f5e: 0c6dfffffffe
	BEQ.S	LAB_44FCA		;44f64: 6764
	CMPI.W	#$ffff,(-4,A5)		;44f66: 0c6dfffffffc
	BEQ.S	LAB_44F90		;44f6c: 6722
	MOVE.W	(-2,A5),D0		;44f6e: 302dfffe
	MULS	#$0016,D0		;44f72: c1fc0016
	LEA	(LAB_53018,A4),A0	;44f76: 41ec9c2a
	MOVE.W	(-4,A5),D1		;44f7a: 322dfffc
	MULS	#$0016,D1		;44f7e: c3fc0016
	LEA	(LAB_53018,A4),A1	;44f82: 43ec9c2a
	MOVE.W	(0,A0,D0.L),D2		;44f86: 34300800
	CMP.W	(0,A1,D1.L),D2		;44f8a: b4711800
	BLE.S	LAB_44FCA		;44f8e: 6f3a
LAB_44F90:
	ADDQ.W	#1,($12,A2)		;44f90: 526a0012
	MOVE.B	#$04,(A2)		;44f94: 14bc0004
	MOVE.W	(-2,A5),D0		;44f98: 302dfffe
	MULS	#$0016,D0		;44f9c: c1fc0016
	LEA	(LAB_5301C,A4),A0	;44fa0: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;44fa4: 32300800
	AND.W	#$003f,D1		;44fa8: c27c003f
	MOVE.B	D1,(1,A2)		;44fac: 15410001
	MOVE.W	(-2,A5),D0		;44fb0: 302dfffe
	MULS	#$0016,D0		;44fb4: c1fc0016
	LEA	(LAB_5301C,A4),A0	;44fb8: 41ec9c2e
	MOVE.W	(0,A0,D0.L),D1		;44fbc: 32300800
	ASR.W	#6,D1			;44fc0: ec41
	MOVE.B	D1,(2,A2)		;44fc2: 15410002
	BRA.W	LAB_44D76		;44fc6: 6000fdae
LAB_44FCA:
	MOVE.W	(8,A5),D0		;44fca: 302d0008
	EXT.L	D0			;44fce: 48c0
	ASL.L	#4,D0			;44fd0: e980
	LEA	(LAB_52DF0,A4),A0	;44fd2: 41ec9a02
	MOVE.L	(LAB_51880,A4),D1	;44fd6: 222c8492
	ADD.L	#$000001f4,D1		;44fda: d2bc000001f4
	MOVE.L	(0,A0,D0.L),D2		;44fe0: 24300800
	CMP.L	D1,D2			;44fe4: b481
	BLE.S	LAB_45026		;44fe6: 6f3e
	MOVEA.L	($26,A2),A0		;44fe8: 206a0026
	CMPI.B	#$01,(A0)		;44fec: 0c100001
	BNE.S	LAB_45026		;44ff0: 6634
	BTST	#3,(-5,A5)		;44ff2: 082d0003fffb
	BEQ.S	LAB_45026		;44ff8: 672c
	MOVE.W	($12,A2),D0		;44ffa: 302a0012
	CMP.W	($1A,A2),D0		;44ffe: b06a001a
	BLT.S	LAB_4500E		;45002: 6d0a
	MOVE.W	(-6,A5),D0		;45004: 302dfffa
	AND.W	#$0050,D0		;45008: c07c0050
	BNE.S	LAB_45026		;4500c: 6618
LAB_4500E:
	MOVE.B	#$03,(A2)		;4500e: 14bc0003
	MOVE.L	A2,-(A7)		;45012: 2f0a
	MOVE.W	(8,A5),-(A7)		;45014: 3f2d0008
	BSR.S	_do_computer_effect	;45018: 6110
	ADDQ.W	#6,A7			;4501a: 5c4f
	MOVE.W	#$0001,(8,A2)		;4501c: 357c00010008
	ADDQ.W	#1,($12,A2)		;45022: 526a0012
LAB_45026:
	BRA.W	LAB_44D76		;45026: 6000fd4e
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_computer_effect:
	LINK.W	A5,#-4			;4502a: 4e55fffc
	MOVE.W	(8,A5),D0		;4502e: 302d0008
	EXT.L	D0			;45032: 48c0
	ASL.L	#4,D0			;45034: e980
	LEA	(_magnet,A4),A0		;45036: 41ec99f6
	TST.W	(0,A0,D0.L)		;4503a: 4a700800
	BNE.S	LAB_450B8		;4503e: 6678
	MOVE.W	(8,A5),D0		;45040: 302d0008
	EXT.L	D0			;45044: 48c0
	ASL.L	#4,D0			;45046: e980
	LEA	(LAB_52DE6,A4),A0	;45048: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;4504c: 32300800
	LEA	(_map_who,A4),A0	;45050: 41ec1f88
	MOVEQ	#0,D0			;45054: 7000
	MOVE.B	(0,A0,D1.W),D0		;45056: 10301000
	MOVE.W	D0,(-2,A5)		;4505a: 3b40fffe
	TST.W	(-2,A5)			;4505e: 4a6dfffe
	BEQ.S	LAB_450B8		;45062: 6754
	MOVE.W	(-2,A5),D0		;45064: 302dfffe
	SUBQ.W	#1,D0			;45068: 5340
	MULS	#$0016,D0		;4506a: c1fc0016
	LEA	(LAB_53015,A4),A0	;4506e: 41ec9c27
	MOVEQ	#0,D1			;45072: 7200
	MOVE.B	(0,A0,D0.L),D1		;45074: 12300800
	CMP.W	(8,A5),D1		;45078: b26d0008
	BEQ.S	LAB_450B8		;4507c: 673a
	MOVE.W	(8,A5),D0		;4507e: 302d0008
	EXT.L	D0			;45082: 48c0
	ASL.L	#4,D0			;45084: e980
	LEA	(LAB_52DE6,A4),A0	;45086: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;4508a: 32300800
	AND.W	#$003f,D1		;4508e: c27c003f
	MOVEA.L	($A,A5),A0		;45092: 206d000a
	MOVE.B	D1,(1,A0)		;45096: 11410001
	MOVE.W	(8,A5),D0		;4509a: 302d0008
	EXT.L	D0			;4509e: 48c0
	ASL.L	#4,D0			;450a0: e980
	LEA	(LAB_52DE6,A4),A0	;450a2: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;450a6: 32300800
	ASR.W	#6,D1			;450aa: ec41
	MOVEA.L	($A,A5),A0		;450ac: 206d000a
	MOVE.B	D1,(2,A0)		;450b0: 11410002
LAB_450B4:
	UNLK	A5			;450b4: 4e5d
	RTS				;450b6: 4e75
LAB_450B8:
	MOVEA.L	($A,A5),A0		;450b8: 206d000a
	MOVEA.L	($26,A0),A1		;450bc: 22680026
	MOVE.W	(8,A1),D0		;450c0: 30290008
	AND.W	#$003f,D0		;450c4: c07c003f
	SUBQ.W	#3,D0			;450c8: 5740
	MOVE.W	D0,(-2,A5)		;450ca: 3b40fffe
	MOVEA.L	($A,A5),A0		;450ce: 206d000a
	MOVEA.L	($26,A0),A1		;450d2: 22680026
	MOVE.W	(8,A1),D0		;450d6: 30290008
	ASR.W	#6,D0			;450da: ec40
	SUBQ.W	#3,D0			;450dc: 5740
	MOVE.W	D0,(-4,A5)		;450de: 3b40fffc
	TST.W	(-2,A5)			;450e2: 4a6dfffe
	BGE.S	LAB_450EC		;450e6: 6c04
	CLR.W	(-2,A5)			;450e8: 426dfffe
LAB_450EC:
	TST.W	(-4,A5)			;450ec: 4a6dfffc
	BGE.S	LAB_450F6		;450f0: 6c04
	CLR.W	(-4,A5)			;450f2: 426dfffc
LAB_450F6:
	MOVEA.L	($A,A5),A0		;450f6: 206d000a
	MOVE.B	(-1,A5),(1,A0)		;450fa: 116dffff0001
	MOVEA.L	($A,A5),A0		;45100: 206d000a
	MOVE.B	(-3,A5),(2,A0)		;45104: 116dfffd0002
	BRA.S	LAB_450B4		;4510a: 60a8
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_devil_magnet:
	LINK.W	A5,#0			;4510c: 4e550000
	MOVEM.L	D4/A2-A3,-(A7)		;45110: 48e70830
	SUBA.L	A3,A3			;45114: 97cb
	MOVEQ	#0,D4			;45116: 7800
	MOVE.W	(8,A5),D0		;45118: 302d0008
	MULS	#$002e,D0		;4511c: c1fc002e
	LEA	(_stats,A4),A0		;45120: 41ec82b6
	MOVEA.L	D0,A2			;45124: 2440
	ADDA.L	A0,A2			;45126: d5c8
	MOVE.W	($16,A2),D0		;45128: 302a0016
	ADD.W	($14,A2),D0		;4512c: d06a0014
	MOVE.W	($C,A2),D1		;45130: 322a000c
	ASL.W	#1,D1			;45134: e341
	ADD.W	#$000f,D1		;45136: d27c000f
	CMP.W	D1,D0			;4513a: b041
	BLT.S	LAB_4515A		;4513c: 6d1c
	MOVE.W	(_game_turn,A4),D0	;4513e: 302cae6a
	SWAP	D0			;45142: 4840
	CLR.W	D0			;45144: 4240
	SWAP	D0			;45146: 4840
	DIVU	#$005a,D0		;45148: 80fc005a
	SWAP	D0			;4514c: 4840
	MOVE.W	($C,A2),D1		;4514e: 322a000c
	ADD.W	#$000a,D1		;45152: d27c000a
	CMP.W	D1,D0			;45156: b041
	BCC.S	LAB_45196		;45158: 643c
LAB_4515A:
	MOVE.W	(8,A5),D0		;4515a: 302d0008
	EXT.L	D0			;4515e: 48c0
	ASL.L	#4,D0			;45160: e980
	LEA	(LAB_52DE8,A4),A0	;45162: 41ec99fa
	TST.W	(0,A0,D0.L)		;45166: 4a700800
	BNE.S	LAB_4518E		;4516a: 6622
	MOVE.B	#$0e,(A2)		;4516c: 14bc000e
	MOVE.B	#$01,(2,A2)		;45170: 157c00010002
	JSR	(___newrand,A4)		;45176: 4eac80fe
	EXT.L	D0			;4517a: 48c0
	DIVS	#$0003,D0		;4517c: 81fc0003
	SWAP	D0			;45180: 4840
	ADDQ.W	#1,D0			;45182: 5240
	MOVE.B	D0,(1,A2)		;45184: 15400001
	MOVE.W	#$0001,(8,A2)		;45188: 357c00010008
LAB_4518E:
	MOVEM.L	(A7)+,D4/A2-A3		;4518e: 4cdf0c10
	UNLK	A5			;45192: 4e5d
	RTS				;45194: 4e75
LAB_45196:
	TST.W	(8,A5)			;45196: 4a6d0008
	BNE.S	LAB_451A0		;4519a: 6604
	MOVEQ	#1,D0			;4519c: 7001
	BRA.S	LAB_451A2		;4519e: 6002
LAB_451A0:
	MOVEQ	#0,D0			;451a0: 7000
LAB_451A2:
	EXT.L	D0			;451a2: 48c0
	ASL.L	#4,D0			;451a4: e980
	LEA	(_magnet,A4),A0		;451a6: 41ec99f6
	TST.W	(0,A0,D0.L)		;451aa: 4a700800
	BEQ.S	LAB_451D6		;451ae: 6726
	TST.W	(8,A5)			;451b0: 4a6d0008
	BNE.S	LAB_451BA		;451b4: 6604
	MOVEQ	#1,D0			;451b6: 7001
	BRA.S	LAB_451BC		;451b8: 6002
LAB_451BA:
	MOVEQ	#0,D0			;451ba: 7000
LAB_451BC:
	EXT.L	D0			;451bc: 48c0
	ASL.L	#4,D0			;451be: e980
	LEA	(_magnet,A4),A0		;451c0: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;451c4: 32300800
	SUBQ.W	#1,D1			;451c8: 5341
	MULS	#$0016,D1		;451ca: c3fc0016
	LEA	(_peeps,A4),A0		;451ce: 41ec9c26
	MOVE.L	D1,D4			;451d2: 2801
	ADD.L	A0,D4			;451d4: d888
LAB_451D6:
	MOVE.W	(8,A5),D0		;451d6: 302d0008
	EXT.L	D0			;451da: 48c0
	ASL.L	#4,D0			;451dc: e980
	LEA	(_magnet,A4),A0		;451de: 41ec99f6
	TST.W	(0,A0,D0.L)		;451e2: 4a700800
	BEQ.S	LAB_45206		;451e6: 671e
	MOVE.W	(8,A5),D0		;451e8: 302d0008
	EXT.L	D0			;451ec: 48c0
	ASL.L	#4,D0			;451ee: e980
	LEA	(_magnet,A4),A0		;451f0: 41ec99f6
	MOVE.W	(0,A0,D0.L),D1		;451f4: 32300800
	SUBQ.W	#1,D1			;451f8: 5341
	MULS	#$0016,D1		;451fa: c3fc0016
	LEA	(_peeps,A4),A0		;451fe: 41ec9c26
	MOVEA.L	D1,A3			;45202: 2641
	ADDA.L	A0,A3			;45204: d7c8
LAB_45206:
	MOVE.L	A3,D0			;45206: 200b
	BNE.S	LAB_45238		;45208: 662e
	MOVE.W	(8,A5),D0		;4520a: 302d0008
	EXT.L	D0			;4520e: 48c0
	ASL.L	#4,D0			;45210: e980
	LEA	(LAB_52DE8,A4),A0	;45212: 41ec99fa
	TST.W	(0,A0,D0.L)		;45216: 4a700800
	BEQ.S	LAB_45234		;4521a: 6718
	MOVE.B	#$0e,(A2)		;4521c: 14bc000e
	MOVE.B	#$01,(2,A2)		;45220: 157c00010002
	CLR.B	(1,A2)			;45226: 422a0001
	MOVE.W	#$0001,(8,A2)		;4522a: 357c00010008
	CLR.W	($1C,A2)		;45230: 426a001c
LAB_45234:
	BRA.W	LAB_4518E		;45234: 6000ff58
LAB_45238:
	MOVE.W	(8,A3),D0		;45238: 302b0008
	CMP.W	($1E,A2),D0		;4523c: b06a001e
	BNE.S	LAB_4524C		;45240: 660a
	TST.W	($1C,A2)		;45242: 4a6a001c
	BEQ.S	LAB_4524C		;45246: 6704
	SUBQ.W	#1,($1C,A2)		;45248: 536a001c
LAB_4524C:
	CMPI.W	#$1770,(4,A3)		;4524c: 0c6b17700004
	BGE.W	LAB_45318		;45252: 6c0000c4
	TST.W	($1C,A2)		;45256: 4a6a001c
	BEQ.S	LAB_45298		;4525a: 673c
	MOVE.W	(8,A5),D0		;4525c: 302d0008
	EXT.L	D0			;45260: 48c0
	ASL.L	#4,D0			;45262: e980
	LEA	(LAB_52DE6,A4),A0	;45264: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;45268: 32300800
	CMP.W	($1E,A2),D1		;4526c: b26a001e
	BEQ.S	LAB_45296		;45270: 6724
	MOVE.B	#$05,(A2)		;45272: 14bc0005
	MOVE.W	($1E,A2),D0		;45276: 302a001e
	AND.W	#$003f,D0		;4527a: c07c003f
	MOVE.B	D0,(1,A2)		;4527e: 15400001
	MOVE.W	($1E,A2),D0		;45282: 302a001e
	ASR.W	#6,D0			;45286: ec40
	MOVE.B	D0,(2,A2)		;45288: 15400002
	MOVE.W	#$0001,(8,A2)		;4528c: 357c00010008
	BRA.W	LAB_4518E		;45292: 6000fefa
LAB_45296:
	BRA.S	LAB_452EE		;45296: 6056
LAB_45298:
	MOVE.W	(8,A5),D0		;45298: 302d0008
	EXT.L	D0			;4529c: 48c0
	ASL.L	#4,D0			;4529e: e980
	LEA	(LAB_52DE6,A4),A0	;452a0: 41ec99f8
	MOVEA.L	($2A,A2),A1		;452a4: 226a002a
	MOVE.W	(0,A0,D0.L),D1		;452a8: 32300800
	CMP.W	(8,A1),D1		;452ac: b2690008
	BEQ.S	LAB_452EE		;452b0: 673c
	MOVE.B	#$05,(A2)		;452b2: 14bc0005
	MOVEA.L	($2A,A2),A0		;452b6: 206a002a
	MOVE.W	(8,A0),D0		;452ba: 30280008
	AND.W	#$003f,D0		;452be: c07c003f
	MOVE.B	D0,(1,A2)		;452c2: 15400001
	MOVEA.L	($2A,A2),A0		;452c6: 206a002a
	MOVE.W	(8,A0),D0		;452ca: 30280008
	ASR.W	#6,D0			;452ce: ec40
	MOVE.B	D0,(2,A2)		;452d0: 15400002
	MOVEA.L	($2A,A2),A0		;452d4: 206a002a
	MOVE.W	(8,A0),($1E,A2)		;452d8: 35680008001e
	MOVE.W	#$0002,($1C,A2)		;452de: 357c0002001c
	MOVE.W	#$0001,(8,A2)		;452e4: 357c00010008
	BRA.W	LAB_4518E		;452ea: 6000fea2
LAB_452EE:
	MOVE.W	(8,A5),D0		;452ee: 302d0008
	EXT.L	D0			;452f2: 48c0
	ASL.L	#4,D0			;452f4: e980
	LEA	(LAB_52DE8,A4),A0	;452f6: 41ec99fa
	TST.W	(0,A0,D0.L)		;452fa: 4a700800
	BEQ.S	LAB_45314		;452fe: 6714
	MOVE.B	#$0e,(A2)		;45300: 14bc000e
	MOVE.B	#$01,(2,A2)		;45304: 157c00010002
	CLR.B	(1,A2)			;4530a: 422a0001
	MOVE.W	#$0001,(8,A2)		;4530e: 357c00010008
LAB_45314:
	BRA.W	LAB_4518E		;45314: 6000fe78
LAB_45318:
	TST.L	D4			;45318: 4a84
	BEQ.W	LAB_453F6		;4531a: 670000da
	MOVEA.L	D4,A0			;4531e: 2044
	MOVE.W	(4,A0),D0		;45320: 30280004
	ADD.W	#$01f4,D0		;45324: d07c01f4
	MOVE.W	(4,A3),D1		;45328: 322b0004
	CMP.W	D0,D1			;4532c: b240
	BLE.W	LAB_453F6		;4532e: 6f0000c6
	TST.W	(8,A5)			;45332: 4a6d0008
	BNE.S	LAB_4533C		;45336: 6604
	MOVEQ	#1,D0			;45338: 7001
	BRA.S	LAB_4533E		;4533a: 6002
LAB_4533C:
	MOVEQ	#0,D0			;4533c: 7000
LAB_4533E:
	EXT.L	D0			;4533e: 48c0
	ASL.L	#4,D0			;45340: e980
	LEA	(LAB_52DE8,A4),A0	;45342: 41ec99fa
	TST.W	(0,A0,D0.L)		;45346: 4a700800
	BNE.W	LAB_453F6		;4534a: 660000aa
	BTST	#2,($F,A2)		;4534e: 082a0002000f
	BEQ.W	LAB_453F2		;45354: 6700009c
	MOVE.W	(8,A5),D0		;45358: 302d0008
	EXT.L	D0			;4535c: 48c0
	ASL.L	#4,D0			;4535e: e980
	LEA	(LAB_52DE8,A4),A0	;45360: 41ec99fa
	TST.W	(0,A0,D0.L)		;45364: 4a700800
	BEQ.S	LAB_45380		;45368: 6716
	MOVE.B	#$0e,(A2)		;4536a: 14bc000e
	MOVE.B	#$01,(2,A2)		;4536e: 157c00010002
	CLR.B	(1,A2)			;45374: 422a0001
	MOVE.W	#$0001,(8,A2)		;45378: 357c00010008
	BRA.S	LAB_453F2		;4537e: 6072
LAB_45380:
	MOVE.W	(8,A5),D0		;45380: 302d0008
	EXT.L	D0			;45384: 48c0
	ASL.L	#4,D0			;45386: e980
	LEA	(LAB_52DE6,A4),A0	;45388: 41ec99f8
	TST.W	(8,A5)			;4538c: 4a6d0008
	BNE.S	LAB_45396		;45390: 6604
	MOVEQ	#1,D1			;45392: 7201
	BRA.S	LAB_45398		;45394: 6002
LAB_45396:
	MOVEQ	#0,D1			;45396: 7200
LAB_45398:
	EXT.L	D1			;45398: 48c1
	ASL.L	#4,D1			;4539a: e981
	LEA	(LAB_52DE6,A4),A1	;4539c: 43ec99f8
	MOVE.W	(0,A0,D0.L),D2		;453a0: 34300800
	CMP.W	(0,A1,D1.L),D2		;453a4: b4711800
	BEQ.S	LAB_453F2		;453a8: 6748
	MOVE.B	#$05,(A2)		;453aa: 14bc0005
	TST.W	(8,A5)			;453ae: 4a6d0008
	BNE.S	LAB_453B8		;453b2: 6604
	MOVEQ	#1,D0			;453b4: 7001
	BRA.S	LAB_453BA		;453b6: 6002
LAB_453B8:
	MOVEQ	#0,D0			;453b8: 7000
LAB_453BA:
	EXT.L	D0			;453ba: 48c0
	ASL.L	#4,D0			;453bc: e980
	LEA	(LAB_52DE6,A4),A0	;453be: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;453c2: 32300800
	AND.W	#$003f,D1		;453c6: c27c003f
	MOVE.B	D1,(1,A2)		;453ca: 15410001
	TST.W	(8,A5)			;453ce: 4a6d0008
	BNE.S	LAB_453D8		;453d2: 6604
	MOVEQ	#1,D0			;453d4: 7001
	BRA.S	LAB_453DA		;453d6: 6002
LAB_453D8:
	MOVEQ	#0,D0			;453d8: 7000
LAB_453DA:
	EXT.L	D0			;453da: 48c0
	ASL.L	#4,D0			;453dc: e980
	LEA	(LAB_52DE6,A4),A0	;453de: 41ec99f8
	MOVE.W	(0,A0,D0.L),D1		;453e2: 32300800
	ASR.W	#6,D1			;453e6: ec41
	MOVE.B	D1,(2,A2)		;453e8: 15410002
	MOVE.W	#$0001,(8,A2)		;453ec: 357c00010008
LAB_453F2:
	BRA.W	LAB_4518E		;453f2: 6000fd9a
LAB_453F6:
	BTST	#1,($F,A2)		;453f6: 082a0001000f
	BEQ.W	LAB_45480		;453fc: 67000082
	MOVE.W	(8,A5),D0		;45400: 302d0008
	EXT.L	D0			;45404: 48c0
	ASL.L	#4,D0			;45406: e980
	LEA	(LAB_52DE6,A4),A0	;45408: 41ec99f8
	MOVEA.L	($22,A2),A1		;4540c: 226a0022
	MOVE.W	(0,A0,D0.L),D1		;45410: 32300800
	CMP.W	(8,A1),D1		;45414: b2690008
	BEQ.S	LAB_4545A		;45418: 6740
	TST.W	($1C,A2)		;4541a: 4a6a001c
	BNE.S	LAB_4545A		;4541e: 663a
	MOVE.B	#$05,(A2)		;45420: 14bc0005
	MOVEA.L	($22,A2),A0		;45424: 206a0022
	MOVE.W	(8,A0),D0		;45428: 30280008
	AND.W	#$003f,D0		;4542c: c07c003f
	MOVE.B	D0,(1,A2)		;45430: 15400001
	MOVEA.L	($22,A2),A0		;45434: 206a0022
	MOVE.W	(8,A0),D0		;45438: 30280008
	ASR.W	#6,D0			;4543c: ec40
	MOVE.B	D0,(2,A2)		;4543e: 15400002
	MOVEA.L	($22,A2),A0		;45442: 206a0022
	MOVE.W	(8,A0),($1E,A2)		;45446: 35680008001e
	MOVE.W	#$0002,($1C,A2)		;4544c: 357c0002001c
	MOVE.W	#$0001,(8,A2)		;45452: 357c00010008
	BRA.S	LAB_45480		;45458: 6026
LAB_4545A:
	MOVE.W	(8,A5),D0		;4545a: 302d0008
	EXT.L	D0			;4545e: 48c0
	ASL.L	#4,D0			;45460: e980
	LEA	(LAB_52DE8,A4),A0	;45462: 41ec99fa
	TST.W	(0,A0,D0.L)		;45466: 4a700800
	BEQ.S	LAB_45480		;4546a: 6714
	MOVE.B	#$0e,(A2)		;4546c: 14bc000e
	MOVE.B	#$01,(2,A2)		;45470: 157c00010002
	CLR.B	(1,A2)			;45476: 422a0001
	MOVE.W	#$0001,(8,A2)		;4547a: 357c00010008
LAB_45480:
	BRA.W	LAB_4518E		;45480: 6000fd0c
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_requester:
	LINK.W	A5,#-6			;45484: 4e55fffa
	MOVEM.L	D4-D7,-(A7)		;45488: 48e70f00
	MOVE.W	($C,A5),D4		;4548c: 382d000c
	MOVE.W	($E,A5),D5		;45490: 3a2d000e
	CLR.W	(_tempo,A4)		;45494: 426c824e
	ASR.W	#4,D4			;45498: e844
	MOVE.W	($10,A5),D0		;4549a: 302d0010
	ASR.W	#4,D0			;4549e: e840
	MOVE.W	D0,($10,A5)		;454a0: 3b400010
	MOVEA.L	($14,A5),A0		;454a4: 206d0014
	ADDQ.L	#6,A0			;454a8: 5c88
	MOVE.L	A0,-(A7)		;454aa: 2f08
	JSR	(___strlen,A4)		;454ac: 4eac81a6
	ADDQ.W	#4,A7			;454b0: 584f
	ASR.W	#1,D0			;454b2: e240
	MOVE.W	D0,(-6,A5)		;454b4: 3b40fffa
	MOVE.W	#$000c,-(A7)		;454b8: 3f3c000c
	MOVE.W	D5,-(A7)		;454bc: 3f05
	MOVE.W	D4,-(A7)		;454be: 3f04
	MOVE.L	(8,A5),-(A7)		;454c0: 2f2d0008
	JSR	(___draw_icon,A4)	;454c4: 4eac810a
	LEA	($A,A7),A7		;454c8: 4fef000a
	MOVEQ	#1,D6			;454cc: 7c01
	BRA.S	LAB_454EA		;454ce: 601a
LAB_454D0:
	MOVE.W	#$000d,-(A7)		;454d0: 3f3c000d
	MOVE.W	D5,-(A7)		;454d4: 3f05
	MOVE.W	D4,D0			;454d6: 3004
	ADD.W	D6,D0			;454d8: d046
	MOVE.W	D0,-(A7)		;454da: 3f00
	MOVE.L	(8,A5),-(A7)		;454dc: 2f2d0008
	JSR	(___draw_icon,A4)	;454e0: 4eac810a
	LEA	($A,A7),A7		;454e4: 4fef000a
	ADDQ.W	#1,D6			;454e8: 5246
LAB_454EA:
	MOVE.W	($10,A5),D0		;454ea: 302d0010
	SUBQ.W	#1,D0			;454ee: 5340
	CMP.W	D0,D6			;454f0: bc40
	BLT.S	LAB_454D0		;454f2: 6ddc
	MOVE.W	#$000e,-(A7)		;454f4: 3f3c000e
	MOVE.W	D5,-(A7)		;454f8: 3f05
	MOVE.W	D4,D0			;454fa: 3004
	ADD.W	D6,D0			;454fc: d046
	MOVE.W	D0,-(A7)		;454fe: 3f00
	MOVE.L	(8,A5),-(A7)		;45500: 2f2d0008
	JSR	(___draw_icon,A4)	;45504: 4eac810a
	LEA	($A,A7),A7		;45508: 4fef000a
	MOVE.W	D5,D6			;4550c: 3c05
	ADD.W	#$0010,D6		;4550e: dc7c0010
	BRA.S	LAB_4556C		;45512: 6058
LAB_45514:
	MOVE.W	#$0012,-(A7)		;45514: 3f3c0012
	MOVE.W	D6,-(A7)		;45518: 3f06
	MOVE.W	D4,-(A7)		;4551a: 3f04
	MOVE.L	(8,A5),-(A7)		;4551c: 2f2d0008
	JSR	(___draw_icon,A4)	;45520: 4eac810a
	LEA	($A,A7),A7		;45524: 4fef000a
	MOVEQ	#1,D7			;45528: 7e01
	BRA.S	LAB_45546		;4552a: 601a
LAB_4552C:
	MOVE.W	#$0014,-(A7)		;4552c: 3f3c0014
	MOVE.W	D6,-(A7)		;45530: 3f06
	MOVE.W	D4,D0			;45532: 3004
	ADD.W	D7,D0			;45534: d047
	MOVE.W	D0,-(A7)		;45536: 3f00
	MOVE.L	(8,A5),-(A7)		;45538: 2f2d0008
	JSR	(___draw_icon,A4)	;4553c: 4eac810a
	LEA	($A,A7),A7		;45540: 4fef000a
	ADDQ.W	#1,D7			;45544: 5247
LAB_45546:
	MOVE.W	($10,A5),D0		;45546: 302d0010
	SUBQ.W	#1,D0			;4554a: 5340
	CMP.W	D0,D7			;4554c: be40
	BLT.S	LAB_4552C		;4554e: 6ddc
	MOVE.W	#$0013,-(A7)		;45550: 3f3c0013
	MOVE.W	D6,-(A7)		;45554: 3f06
	MOVE.W	D4,D0			;45556: 3004
	ADD.W	D7,D0			;45558: d047
	MOVE.W	D0,-(A7)		;4555a: 3f00
	MOVE.L	(8,A5),-(A7)		;4555c: 2f2d0008
	JSR	(___draw_icon,A4)	;45560: 4eac810a
	LEA	($A,A7),A7		;45564: 4fef000a
	ADD.W	#$0010,D6		;45568: dc7c0010
LAB_4556C:
	MOVE.W	D5,D0			;4556c: 3005
	ADD.W	($12,A5),D0		;4556e: d06d0012
	SUB.W	#$0010,D0		;45572: 907c0010
	CMP.W	D0,D6			;45576: bc40
	BLT.S	LAB_45514		;45578: 6d9a
	MOVE.W	#$000f,-(A7)		;4557a: 3f3c000f
	MOVE.W	D6,-(A7)		;4557e: 3f06
	MOVE.W	D4,-(A7)		;45580: 3f04
	MOVE.L	(8,A5),-(A7)		;45582: 2f2d0008
	JSR	(___draw_icon,A4)	;45586: 4eac810a
	LEA	($A,A7),A7		;4558a: 4fef000a
	MOVEQ	#1,D7			;4558e: 7e01
	MOVEA.L	($14,A5),A0		;45590: 206d0014
	MOVE.W	D6,(2,A0)		;45594: 31460002
	TST.L	($18,A5)		;45598: 4aad0018
	BEQ.W	LAB_45744		;4559c: 670001a6
	MOVEA.L	($14,A5),A0		;455a0: 206d0014
	MOVE.W	D4,D0			;455a4: 3004
	ADD.W	D7,D0			;455a6: d047
	ASL.W	#4,D0			;455a8: e940
	MOVE.W	D0,(A0)			;455aa: 3080
	MOVEA.L	($14,A5),A0		;455ac: 206d0014
	MOVEA.L	($18,A5),A1		;455b0: 226d0018
	MOVE.W	(2,A0),(2,A1)		;455b4: 336800020002
	MOVE.W	#$0015,-(A7)		;455ba: 3f3c0015
	MOVE.W	D6,-(A7)		;455be: 3f06
	MOVE.W	D7,D0			;455c0: 3007
	ADDQ.W	#1,D7			;455c2: 5247
	ADD.W	D4,D0			;455c4: d044
	MOVE.W	D0,-(A7)		;455c6: 3f00
	MOVE.L	(8,A5),-(A7)		;455c8: 2f2d0008
	JSR	(___draw_icon,A4)	;455cc: 4eac810a
	LEA	($A,A7),A7		;455d0: 4fef000a
	CLR.W	(-4,A5)			;455d4: 426dfffc
	BRA.S	LAB_455F8		;455d8: 601e
LAB_455DA:
	MOVE.W	#$0016,-(A7)		;455da: 3f3c0016
	MOVE.W	D6,-(A7)		;455de: 3f06
	MOVE.W	D4,D0			;455e0: 3004
	ADD.W	D7,D0			;455e2: d047
	MOVE.W	D0,-(A7)		;455e4: 3f00
	MOVE.L	(8,A5),-(A7)		;455e6: 2f2d0008
	JSR	(___draw_icon,A4)	;455ea: 4eac810a
	LEA	($A,A7),A7		;455ee: 4fef000a
	ADDQ.W	#1,(-4,A5)		;455f2: 526dfffc
	ADDQ.W	#1,D7			;455f6: 5247
LAB_455F8:
	MOVE.W	(-4,A5),D0		;455f8: 302dfffc
	CMP.W	(-6,A5),D0		;455fc: b06dfffa
	BLT.S	LAB_455DA		;45600: 6dd8
	MOVE.W	#$0017,-(A7)		;45602: 3f3c0017
	MOVE.W	D6,-(A7)		;45606: 3f06
	MOVE.W	D7,D0			;45608: 3007
	ADDQ.W	#1,D7			;4560a: 5247
	ADD.W	D4,D0			;4560c: d044
	MOVE.W	D0,-(A7)		;4560e: 3f00
	MOVE.L	(8,A5),-(A7)		;45610: 2f2d0008
	JSR	(___draw_icon,A4)	;45614: 4eac810a
	LEA	($A,A7),A7		;45618: 4fef000a
	MOVEA.L	($14,A5),A0		;4561c: 206d0014
	ADDQ.L	#6,A0			;45620: 5c88
	MOVE.L	A0,-(A7)		;45622: 2f08
	MOVE.W	D6,D0			;45624: 3006
	ADDQ.W	#3,D0			;45626: 5640
	MOVE.W	D0,-(A7)		;45628: 3f00
	MOVEA.L	($14,A5),A0		;4562a: 206d0014
	MOVE.W	(A0),D0			;4562e: 3010
	ADD.W	#$0010,D0		;45630: d07c0010
	MOVE.W	D0,-(A7)		;45634: 3f00
	MOVE.L	(8,A5),-(A7)		;45636: 2f2d0008
	JSR	(___text,A4)		;4563a: 4eac813a
	LEA	($C,A7),A7		;4563e: 4fef000c
	BRA.S	LAB_4565E		;45642: 601a
LAB_45644:
	MOVE.W	#$0010,-(A7)		;45644: 3f3c0010
	MOVE.W	D6,-(A7)		;45648: 3f06
	MOVE.W	D4,D0			;4564a: 3004
	ADD.W	D7,D0			;4564c: d047
	MOVE.W	D0,-(A7)		;4564e: 3f00
	MOVE.L	(8,A5),-(A7)		;45650: 2f2d0008
	JSR	(___draw_icon,A4)	;45654: 4eac810a
	LEA	($A,A7),A7		;45658: 4fef000a
	ADDQ.W	#1,D7			;4565c: 5247
LAB_4565E:
	MOVEA.L	($18,A5),A0		;4565e: 206d0018
	ADDQ.L	#6,A0			;45662: 5c88
	MOVE.L	A0,-(A7)		;45664: 2f08
	JSR	(___strlen,A4)		;45666: 4eac81a6
	ADDQ.W	#4,A7			;4566a: 584f
	ASR.W	#1,D0			;4566c: e240
	MOVE.W	($10,A5),D1		;4566e: 322d0010
	SUB.W	D0,D1			;45672: 9240
	SUBQ.W	#3,D1			;45674: 5741
	CMP.W	D1,D7			;45676: be41
	BLT.S	LAB_45644		;45678: 6dca
	MOVEA.L	($18,A5),A0		;4567a: 206d0018
	MOVE.W	D4,D0			;4567e: 3004
	ADD.W	D7,D0			;45680: d047
	ASL.W	#4,D0			;45682: e940
	MOVE.W	D0,(A0)			;45684: 3080
	MOVE.W	#$0015,-(A7)		;45686: 3f3c0015
	MOVE.W	D6,-(A7)		;4568a: 3f06
	MOVE.W	D7,D0			;4568c: 3007
	ADDQ.W	#1,D7			;4568e: 5247
	ADD.W	D4,D0			;45690: d044
	MOVE.W	D0,-(A7)		;45692: 3f00
	MOVE.L	(8,A5),-(A7)		;45694: 2f2d0008
	JSR	(___draw_icon,A4)	;45698: 4eac810a
	LEA	($A,A7),A7		;4569c: 4fef000a
	CLR.W	(-4,A5)			;456a0: 426dfffc
	BRA.S	LAB_456C4		;456a4: 601e
LAB_456A6:
	MOVE.W	#$0016,-(A7)		;456a6: 3f3c0016
	MOVE.W	D6,-(A7)		;456aa: 3f06
	MOVE.W	D4,D0			;456ac: 3004
	ADD.W	D7,D0			;456ae: d047
	MOVE.W	D0,-(A7)		;456b0: 3f00
	MOVE.L	(8,A5),-(A7)		;456b2: 2f2d0008
	JSR	(___draw_icon,A4)	;456b6: 4eac810a
	LEA	($A,A7),A7		;456ba: 4fef000a
	ADDQ.W	#1,(-4,A5)		;456be: 526dfffc
	ADDQ.W	#1,D7			;456c2: 5247
LAB_456C4:
	MOVEA.L	($18,A5),A0		;456c4: 206d0018
	ADDQ.L	#6,A0			;456c8: 5c88
	MOVE.L	A0,-(A7)		;456ca: 2f08
	JSR	(___strlen,A4)		;456cc: 4eac81a6
	ADDQ.W	#4,A7			;456d0: 584f
	ASR.W	#1,D0			;456d2: e240
	MOVE.W	(-4,A5),D1		;456d4: 322dfffc
	CMP.W	D0,D1			;456d8: b240
	BLT.S	LAB_456A6		;456da: 6dca
	MOVE.W	#$0017,-(A7)		;456dc: 3f3c0017
	MOVE.W	D6,-(A7)		;456e0: 3f06
	MOVE.W	D7,D0			;456e2: 3007
	ADDQ.W	#1,D7			;456e4: 5247
	ADD.W	D4,D0			;456e6: d044
	MOVE.W	D0,-(A7)		;456e8: 3f00
	MOVE.L	(8,A5),-(A7)		;456ea: 2f2d0008
	JSR	(___draw_icon,A4)	;456ee: 4eac810a
	LEA	($A,A7),A7		;456f2: 4fef000a
	MOVEA.L	($18,A5),A0		;456f6: 206d0018
	MOVE.L	A0,-(A7)		;456fa: 2f08
	MOVEA.L	($18,A5),A0		;456fc: 206d0018
	ADDQ.L	#6,A0			;45700: 5c88
	MOVE.L	A0,-(A7)		;45702: 2f08
	JSR	(___strlen,A4)		;45704: 4eac81a6
	ADDQ.W	#4,A7			;45708: 584f
	ADDQ.W	#4,D0			;4570a: 5840
	ASL.W	#3,D0			;4570c: e740
	MOVEA.L	(A7)+,A0		;4570e: 205f
	MOVEA.L	($18,A5),A1		;45710: 226d0018
	ADD.W	(A1),D0			;45714: d051
	MOVE.W	D0,(4,A0)		;45716: 31400004
	MOVEA.L	($18,A5),A0		;4571a: 206d0018
	ADDQ.L	#6,A0			;4571e: 5c88
	MOVE.L	A0,-(A7)		;45720: 2f08
	MOVE.W	D6,D0			;45722: 3006
	ADDQ.W	#3,D0			;45724: 5640
	MOVE.W	D0,-(A7)		;45726: 3f00
	MOVEA.L	($18,A5),A0		;45728: 206d0018
	MOVE.W	(A0),D0			;4572c: 3010
	ADD.W	#$0010,D0		;4572e: d07c0010
	MOVE.W	D0,-(A7)		;45732: 3f00
	MOVE.L	(8,A5),-(A7)		;45734: 2f2d0008
	JSR	(___text,A4)		;45738: 4eac813a
	LEA	($C,A7),A7		;4573c: 4fef000c
	BRA.W	LAB_4580E		;45740: 600000cc
LAB_45744:
	MOVEQ	#1,D7			;45744: 7e01
	BRA.S	LAB_45762		;45746: 601a
LAB_45748:
	MOVE.W	#$0010,-(A7)		;45748: 3f3c0010
	MOVE.W	D6,-(A7)		;4574c: 3f06
	MOVE.W	D4,D0			;4574e: 3004
	ADD.W	D7,D0			;45750: d047
	MOVE.W	D0,-(A7)		;45752: 3f00
	MOVE.L	(8,A5),-(A7)		;45754: 2f2d0008
	JSR	(___draw_icon,A4)	;45758: 4eac810a
	LEA	($A,A7),A7		;4575c: 4fef000a
	ADDQ.W	#1,D7			;45760: 5247
LAB_45762:
	MOVE.W	($10,A5),D0		;45762: 302d0010
	ASR.W	#1,D0			;45766: e240
	MOVE.W	(-6,A5),D1		;45768: 322dfffa
	ASR.W	#1,D1			;4576c: e241
	SUB.W	D1,D0			;4576e: 9041
	SUBQ.W	#1,D0			;45770: 5340
	CMP.W	D0,D7			;45772: be40
	BLT.S	LAB_45748		;45774: 6dd2
	MOVEA.L	($14,A5),A0		;45776: 206d0014
	MOVE.W	D4,D0			;4577a: 3004
	ADD.W	D7,D0			;4577c: d047
	ASL.W	#4,D0			;4577e: e940
	MOVE.W	D0,(A0)			;45780: 3080
	MOVE.W	#$0015,-(A7)		;45782: 3f3c0015
	MOVE.W	D6,-(A7)		;45786: 3f06
	MOVE.W	D7,D0			;45788: 3007
	ADDQ.W	#1,D7			;4578a: 5247
	ADD.W	D4,D0			;4578c: d044
	MOVE.W	D0,-(A7)		;4578e: 3f00
	MOVE.L	(8,A5),-(A7)		;45790: 2f2d0008
	JSR	(___draw_icon,A4)	;45794: 4eac810a
	LEA	($A,A7),A7		;45798: 4fef000a
	MOVE.W	D7,(-2,A5)		;4579c: 3b47fffe
	CLR.W	(-4,A5)			;457a0: 426dfffc
	BRA.S	LAB_457C4		;457a4: 601e
LAB_457A6:
	MOVE.W	#$0016,-(A7)		;457a6: 3f3c0016
	MOVE.W	D6,-(A7)		;457aa: 3f06
	MOVE.W	D4,D0			;457ac: 3004
	ADD.W	D7,D0			;457ae: d047
	MOVE.W	D0,-(A7)		;457b0: 3f00
	MOVE.L	(8,A5),-(A7)		;457b2: 2f2d0008
	JSR	(___draw_icon,A4)	;457b6: 4eac810a
	LEA	($A,A7),A7		;457ba: 4fef000a
	ADDQ.W	#1,(-4,A5)		;457be: 526dfffc
	ADDQ.W	#1,D7			;457c2: 5247
LAB_457C4:
	MOVE.W	(-4,A5),D0		;457c4: 302dfffc
	CMP.W	(-6,A5),D0		;457c8: b06dfffa
	BLT.S	LAB_457A6		;457cc: 6dd8
	MOVE.W	#$0017,-(A7)		;457ce: 3f3c0017
	MOVE.W	D6,-(A7)		;457d2: 3f06
	MOVE.W	D7,D0			;457d4: 3007
	ADDQ.W	#1,D7			;457d6: 5247
	ADD.W	D4,D0			;457d8: d044
	MOVE.W	D0,-(A7)		;457da: 3f00
	MOVE.L	(8,A5),-(A7)		;457dc: 2f2d0008
	JSR	(___draw_icon,A4)	;457e0: 4eac810a
	LEA	($A,A7),A7		;457e4: 4fef000a
	BRA.S	LAB_45804		;457e8: 601a
LAB_457EA:
	MOVE.W	#$0010,-(A7)		;457ea: 3f3c0010
	MOVE.W	D6,-(A7)		;457ee: 3f06
	MOVE.W	D4,D0			;457f0: 3004
	ADD.W	D7,D0			;457f2: d047
	MOVE.W	D0,-(A7)		;457f4: 3f00
	MOVE.L	(8,A5),-(A7)		;457f6: 2f2d0008
	JSR	(___draw_icon,A4)	;457fa: 4eac810a
	LEA	($A,A7),A7		;457fe: 4fef000a
	ADDQ.W	#1,D7			;45802: 5247
LAB_45804:
	MOVE.W	($10,A5),D0		;45804: 302d0010
	SUBQ.W	#1,D0			;45808: 5340
	CMP.W	D0,D7			;4580a: be40
	BLT.S	LAB_457EA		;4580c: 6ddc
LAB_4580E:
	MOVEA.L	($14,A5),A0		;4580e: 206d0014
	MOVE.L	A0,-(A7)		;45812: 2f08
	MOVEA.L	($14,A5),A0		;45814: 206d0014
	ADDQ.L	#6,A0			;45818: 5c88
	MOVE.L	A0,-(A7)		;4581a: 2f08
	JSR	(___strlen,A4)		;4581c: 4eac81a6
	ADDQ.W	#4,A7			;45820: 584f
	ADDQ.W	#4,D0			;45822: 5840
	ASL.W	#3,D0			;45824: e740
	MOVEA.L	(A7)+,A0		;45826: 205f
	MOVEA.L	($14,A5),A1		;45828: 226d0014
	ADD.W	(A1),D0			;4582c: d051
	MOVE.W	D0,(4,A0)		;4582e: 31400004
	MOVE.W	#$0011,-(A7)		;45832: 3f3c0011
	MOVE.W	D6,-(A7)		;45836: 3f06
	MOVE.W	D4,D0			;45838: 3004
	ADD.W	D7,D0			;4583a: d047
	MOVE.W	D0,-(A7)		;4583c: 3f00
	MOVE.L	(8,A5),-(A7)		;4583e: 2f2d0008
	JSR	(___draw_icon,A4)	;45842: 4eac810a
	LEA	($A,A7),A7		;45846: 4fef000a
	MOVEA.L	($14,A5),A0		;4584a: 206d0014
	ADDQ.L	#6,A0			;4584e: 5c88
	MOVE.L	A0,-(A7)		;45850: 2f08
	MOVE.W	D6,D0			;45852: 3006
	ADDQ.W	#3,D0			;45854: 5640
	MOVE.W	D0,-(A7)		;45856: 3f00
	MOVEA.L	($14,A5),A0		;45858: 206d0014
	MOVE.W	(A0),D0			;4585c: 3010
	ADD.W	#$0010,D0		;4585e: d07c0010
	MOVE.W	D0,-(A7)		;45862: 3f00
	MOVE.L	(8,A5),-(A7)		;45864: 2f2d0008
	JSR	(___text,A4)		;45868: 4eac813a
	LEA	($C,A7),A7		;4586c: 4fef000c
	MOVEM.L	(A7)+,D4-D7		;45870: 4cdf00f0
	UNLK	A5			;45874: 4e5d
	RTS				;45876: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_toggle_button:
	LINK.W	A5,#0			;45878: 4e550000
	MOVEA.L	($C,A5),A0		;4587c: 206d000c
	MOVEQ	#0,D0			;45880: 7000
	MOVE.B	(6,A0),D0		;45882: 10280006
	CMP.W	#$0080,D0		;45886: b07c0080
	BNE.S	LAB_45892		;4588a: 6606
	MOVE.W	#$0081,D0		;4588c: 303c0081
	BRA.S	LAB_45896		;45890: 6004
LAB_45892:
	MOVE.W	#$0080,D0		;45892: 303c0080
LAB_45896:
	MOVEA.L	($C,A5),A0		;45896: 206d000c
	MOVE.B	D0,(6,A0)		;4589a: 11400006
	MOVEA.L	($C,A5),A0		;4589e: 206d000c
	ADDQ.L	#6,A0			;458a2: 5c88
	MOVE.L	A0,-(A7)		;458a4: 2f08
	MOVEA.L	($C,A5),A0		;458a6: 206d000c
	MOVE.W	(2,A0),D0		;458aa: 30280002
	ADD.W	($A,A5),D0		;458ae: d06d000a
	MOVE.W	D0,-(A7)		;458b2: 3f00
	MOVEA.L	($C,A5),A0		;458b4: 206d000c
	MOVE.W	(A0),D0			;458b8: 3010
	ADD.W	(8,A5),D0		;458ba: d06d0008
	MOVE.W	D0,-(A7)		;458be: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;458c0: 2f2c99ec
	JSR	(___text,A4)		;458c4: 4eac813a
	LEA	($C,A7),A7		;458c8: 4fef000c
	UNLK	A5			;458cc: 4e5d
	RTS				;458ce: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_get_name:
	LINK.W	A5,#-46			;458d0: 4e55ffd2
	MOVE.L	($C,A5),-(A7)		;458d4: 2f2d000c
	JSR	(___strlen,A4)		;458d8: 4eac81a6
	ADDQ.W	#4,A7			;458dc: 584f
	MOVE.W	D0,(-46,A5)		;458de: 3b40ffd2
	CLR.W	(-44,A5)		;458e2: 426dffd4
	CLR.W	(-42,A5)		;458e6: 426dffd6
	BRA.S	LAB_45936		;458ea: 604a
LAB_458EC:
	MOVE.W	(-42,A5),D0		;458ec: 302dffd6
	MOVEA.L	($C,A5),A0		;458f0: 206d000c
	TST.B	(0,A0,D0.W)		;458f4: 4a300000
	BNE.S	LAB_45900		;458f8: 6606
	MOVE.W	#$0001,(-44,A5)		;458fa: 3b7c0001ffd4
LAB_45900:
	MOVE.W	(-42,A5),D0		;45900: 302dffd6
	MOVEA.L	($C,A5),A0		;45904: 206d000c
	CMPI.B	#$20,(0,A0,D0.W)	;45908: 0c3000200000
	BLS.S	LAB_45916		;4590e: 6306
	TST.W	(-44,A5)		;45910: 4a6dffd4
	BEQ.S	LAB_45924		;45914: 670e
LAB_45916:
	MOVE.W	(-42,A5),D0		;45916: 302dffd6
	MOVEA.L	($C,A5),A0		;4591a: 206d000c
	MOVE.B	#$82,(0,A0,D0.W)	;4591e: 11bc00820000
LAB_45924:
	MOVE.W	(-42,A5),D0		;45924: 302dffd6
	LEA	(-40,A5),A0		;45928: 41edffd8
	MOVE.B	#$82,(0,A0,D0.W)	;4592c: 11bc00820000
	ADDQ.W	#1,(-42,A5)		;45932: 526dffd6
LAB_45936:
	MOVE.W	(-42,A5),D0		;45936: 302dffd6
	CMP.W	($14,A5),D0		;4593a: b06d0014
	BNE.S	LAB_458EC		;4593e: 66ac
	MOVE.W	(-42,A5),D0		;45940: 302dffd6
	MOVEA.L	($C,A5),A0		;45944: 206d000c
	CLR.B	(0,A0,D0.W)		;45948: 42300000
	MOVE.W	(-42,A5),D0		;4594c: 302dffd6
	LEA	(-40,A5),A0		;45950: 41edffd8
	CLR.B	(0,A0,D0.W)		;45954: 42300000
	MOVE.W	#$0002,(_left_button,A4) ;45958: 397c0002ae62
	PEA	(-40,A5)		;4595e: 486dffd8
	MOVE.W	($12,A5),-(A7)		;45962: 3f2d0012
	MOVE.W	($10,A5),-(A7)		;45966: 3f2d0010
	MOVE.L	(8,A5),-(A7)		;4596a: 2f2d0008
	JSR	(___text,A4)		;4596e: 4eac813a
	LEA	($C,A7),A7		;45972: 4fef000c
	CLR.W	(-44,A5)		;45976: 426dffd4
LAB_4597A:
	MOVE.W	(-44,A5),D0		;4597a: 302dffd4
	ADDQ.W	#1,(-44,A5)		;4597e: 526dffd4
	MOVE.W	($14,A5),D1		;45982: 322d0014
	ADD.W	#$0014,D1		;45986: d27c0014
	EXT.L	D0			;4598a: 48c0
	DIVS	D1,D0			;4598c: 81c1
	SWAP	D0			;4598e: 4840
	TST.W	D0			;45990: 4a40
	BNE.S	LAB_459BE		;45992: 662a
	MOVE.W	(-46,A5),D0		;45994: 302dffd2
	MOVEA.L	($C,A5),A0		;45998: 206d000c
	MOVEQ	#0,D1			;4599c: 7200
	MOVE.B	(0,A0,D0.W),D1		;4599e: 12300000
	CMP.W	#$0082,D1		;459a2: b27c0082
	BNE.S	LAB_459AC		;459a6: 6604
	MOVEQ	#1,D0			;459a8: 7001
	BRA.S	LAB_459AE		;459aa: 6002
LAB_459AC:
	MOVEQ	#0,D0			;459ac: 7000
LAB_459AE:
	ADD.W	#$0082,D0		;459ae: d07c0082
	MOVE.W	(-46,A5),D1		;459b2: 322dffd2
	MOVEA.L	($C,A5),A0		;459b6: 206d000c
	MOVE.B	D0,(0,A0,D1.W)		;459ba: 11801000
LAB_459BE:
	MOVE.L	($C,A5),-(A7)		;459be: 2f2d000c
	MOVE.W	($12,A5),-(A7)		;459c2: 3f2d0012
	MOVE.W	($10,A5),-(A7)		;459c6: 3f2d0010
	MOVE.L	(8,A5),-(A7)		;459ca: 2f2d0008
	JSR	(___text,A4)		;459ce: 4eac813a
	LEA	($C,A7),A7		;459d2: 4fef000c
	JSR	(___keyboard,A4)	;459d6: 4eac80f2
	TST.W	D0			;459da: 4a40
	BEQ.W	LAB_45A82		;459dc: 670000a4
; text entry
	CMPI.B	#$20,(_asckey,A4)	;459e0: 0c2c0020302a
	BCS.S	LAB_45A4E		;459e6: 6566
	CMPI.B	#$7a,(_asckey,A4)	;459e8: 0c2c007a302a
	BHI.S	LAB_45A4E		;459ee: 625e
	MOVE.W	($14,A5),D0		;459f0: 302d0014
	SUBQ.W	#1,D0			;459f4: 5340
	MOVE.W	(-46,A5),D1		;459f6: 322dffd2
	CMP.W	D0,D1			;459fa: b240
	BGE.S	LAB_45A4E		;459fc: 6c50
	MOVE.W	(-46,A5),D0		;459fe: 302dffd2
	MOVEA.L	($C,A5),A0		;45a02: 206d000c
	MOVE.B	#$82,(0,A0,D0.W)	;45a06: 11bc00820000
	MOVE.L	($C,A5),-(A7)		;45a0c: 2f2d000c
	MOVE.W	($12,A5),-(A7)		;45a10: 3f2d0012
	MOVE.W	($10,A5),-(A7)		;45a14: 3f2d0010
	MOVE.L	(8,A5),-(A7)		;45a18: 2f2d0008
	JSR	(___text,A4)		;45a1c: 4eac813a
	LEA	($C,A7),A7		;45a20: 4fef000c
	CMPI.B	#$61,(_asckey,A4)	;45a24: 0c2c0061302a
	BCS.S	LAB_45A3A		;45a2a: 650e
	CMPI.B	#$7a,(_asckey,A4)	;45a2c: 0c2c007a302a
	BHI.S	LAB_45A3A		;45a32: 6206
	SUBI.B	#$20,(_asckey,A4)	;45a34: 042c0020302a
LAB_45A3A:
	MOVE.W	(-46,A5),D0		;45a3a: 302dffd2
	ADDQ.W	#1,(-46,A5)		;45a3e: 526dffd2
	MOVEA.L	($C,A5),A0		;45a42: 206d000c
	MOVE.B	(_asckey,A4),(0,A0,D0.W) ;45a46: 11ac302a0000
	BRA.S	LAB_45A82		;45a4c: 6034
LAB_45A4E:
	CMPI.B	#$08,(_asckey,A4)	;45a4e: 0c2c0008302a
	BEQ.S	LAB_45A5E		;45a54: 6708
	CMPI.B	#$7f,(_asckey,A4)	;45a56: 0c2c007f302a
	BNE.S	LAB_45A78		;45a5c: 661a
LAB_45A5E:
	TST.W	(-46,A5)		;45a5e: 4a6dffd2
	BEQ.S	LAB_45A78		;45a62: 6714
	MOVE.W	(-46,A5),D0		;45a64: 302dffd2
	SUBQ.W	#1,(-46,A5)		;45a68: 536dffd2
	MOVEA.L	($C,A5),A0		;45a6c: 206d000c
	MOVE.B	#$82,(0,A0,D0.W)	;45a70: 11bc00820000
	BRA.S	LAB_45A82		;45a76: 600a
LAB_45A78:
	CMPI.B	#$0d,(_asckey,A4)	;45a78: 0c2c000d302a
	BNE.S	LAB_45A82		;45a7e: 6602
	BRA.S	LAB_45ABA		;45a80: 6038
LAB_45A82:
	MOVE.L	($1A,A5),-(A7)		;45a82: 2f2d001a
	MOVE.L	($16,A5),-(A7)		;45a86: 2f2d0016
	JSR	(_check_cancel,PC)	;45a8a: 4eba14c4
	ADDQ.W	#8,A7			;45a8e: 504f
	MOVE.W	D0,(-42,A5)		;45a90: 3b40ffd6
	BEQ.S	LAB_45AAA		;45a94: 6714
	CMPI.W	#$0002,(-42,A5)		;45a96: 0c6d0002ffd6
	BNE.S	LAB_45AA8		;45a9c: 660a
	MOVEA.L	($C,A5),A0		;45a9e: 206d000c
	CLR.B	(A0)			;45aa2: 4210
LAB_45AA4:
	UNLK	A5			;45aa4: 4e5d
	RTS				;45aa6: 4e75
LAB_45AA8:
	BRA.S	LAB_45ABA		;45aa8: 6010
LAB_45AAA:
	TST.W	(_left_button,A4)	;45aaa: 4a6cae62
	BNE.S	LAB_45AB6		;45aae: 6606
	MOVE.W	#$0002,(_left_button,A4) ;45ab0: 397c0002ae62
LAB_45AB6:
	BRA.W	LAB_4597A		;45ab6: 6000fec2
LAB_45ABA:
	MOVE.W	(-46,A5),D0		;45aba: 302dffd2
	MOVEA.L	($C,A5),A0		;45abe: 206d000c
	MOVE.B	#$82,(0,A0,D0.W)	;45ac2: 11bc00820000
	MOVE.L	($C,A5),-(A7)		;45ac8: 2f2d000c
	MOVE.W	($12,A5),-(A7)		;45acc: 3f2d0012
	MOVE.W	($10,A5),-(A7)		;45ad0: 3f2d0010
	MOVE.L	(8,A5),-(A7)		;45ad4: 2f2d0008
	JSR	(___text,A4)		;45ad8: 4eac813a
	LEA	($C,A7),A7		;45adc: 4fef000c
	MOVE.W	($14,A5),D0		;45ae0: 302d0014
	SUBQ.W	#1,D0			;45ae4: 5340
	MOVE.W	D0,(-42,A5)		;45ae6: 3b40ffd6
	BRA.S	LAB_45AFC		;45aea: 6010
LAB_45AEC:
	MOVE.W	(-42,A5),D0		;45aec: 302dffd6
	MOVEA.L	($C,A5),A0		;45af0: 206d000c
	CLR.B	(0,A0,D0.W)		;45af4: 42300000
	SUBQ.W	#1,(-42,A5)		;45af8: 536dffd6
LAB_45AFC:
	MOVE.W	(-42,A5),D0		;45afc: 302dffd6
	MOVEA.L	($C,A5),A0		;45b00: 206d000c
	MOVEQ	#0,D1			;45b04: 7200
	MOVE.B	(0,A0,D0.W),D1		;45b06: 12300000
	CMP.W	#$0080,D1		;45b0a: b27c0080
	BLS.S	LAB_45B16		;45b0e: 6306
	TST.W	(-42,A5)		;45b10: 4a6dffd6
	BGE.S	LAB_45AEC		;45b14: 6cd6
LAB_45B16:
	BRA.S	LAB_45AA4		;45b16: 608c
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_save_load:
	LINK.W	A5,#-148		;45b18: 4e55ff6c
	MOVE.L	(_w_screen,A4),(-84,A5)	;45b1c: 2b6c99e8ffac
	MOVE.W	#$000f,(-144,A5)	;45b22: 3b7c000fff70
	CLR.W	-(A7)			;45b28: 4267
	JSR	(___set_pri,A4)		;45b2a: 4eac8014
	ADDQ.W	#2,A7			;45b2e: 544f
	TST.W	(8,A5)			;45b30: 4a6d0008
	BEQ.S	LAB_45B54		;45b34: 671e
	PEA	(LAB_46174,PC)		;45b36: 487a063c
	PEA	(-124,A5)		;45b3a: 486dff84
	JSR	(___strcpy,A4)		;45b3e: 4eac81a0
	ADDQ.W	#8,A7			;45b42: 504f
	PEA	(LAB_46179,PC)		;45b44: 487a0633
	PEA	(-10,A5)		;45b48: 486dfff6
	JSR	(___strcpy,A4)		;45b4c: 4eac81a0
	ADDQ.W	#8,A7			;45b50: 504f
	BRA.S	LAB_45B70		;45b52: 601c
LAB_45B54:
	PEA	(LAB_46183,PC)		;45b54: 487a062d
	PEA	(-124,A5)		;45b58: 486dff84
	JSR	(___strcpy,A4)		;45b5c: 4eac81a0
	ADDQ.W	#8,A7			;45b60: 504f
	PEA	(LAB_46188,PC)		;45b62: 487a0624
	PEA	(-10,A5)		;45b66: 486dfff6
	JSR	(___strcpy,A4)		;45b6a: 4eac81a0
	ADDQ.W	#8,A7			;45b6e: 504f
LAB_45B70:
	PEA	(_end_cancel,A4)	;45b70: 486c84f4
	PEA	(-130,A5)		;45b74: 486dff7e
	MOVE.W	#$00b0,-(A7)		;45b78: 3f3c00b0
	MOVE.W	#$00b0,-(A7)		;45b7c: 3f3c00b0
	MOVE.W	#$0010,-(A7)		;45b80: 3f3c0010
	MOVE.W	#$0048,-(A7)		;45b84: 3f3c0048
	MOVE.L	(_d_screen,A4),-(A7)	;45b88: 2f2c99ec
	JSR	(_requester,PC)		;45b8c: 4ebaf8f6
	LEA	($14,A7),A7		;45b90: 4fef0014
	PEA	(-10,A5)		;45b94: 486dfff6
	MOVE.W	#$0018,-(A7)		;45b98: 3f3c0018
	MOVE.W	#$0058,-(A7)		;45b9c: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45ba0: 2f2c99ec
	JSR	(___text,A4)		;45ba4: 4eac813a
	LEA	($C,A7),A7		;45ba8: 4fef000c
	PEA	(LAB_46192,PC)		;45bac: 487a05e4
	MOVE.W	#$0022,-(A7)		;45bb0: 3f3c0022
	MOVE.W	#$00d8,-(A7)		;45bb4: 3f3c00d8
	MOVE.L	(_d_screen,A4),-(A7)	;45bb8: 2f2c99ec
	JSR	(___text,A4)		;45bbc: 4eac813a
	LEA	($C,A7),A7		;45bc0: 4fef000c
	PEA	(LAB_46194,PC)		;45bc4: 487a05ce
	MOVE.W	#$007a,-(A7)		;45bc8: 3f3c007a
	MOVE.W	#$00d8,-(A7)		;45bcc: 3f3c00d8
	MOVE.L	(_d_screen,A4),-(A7)	;45bd0: 2f2c99ec
	JSR	(___text,A4)		;45bd4: 4eac813a
	LEA	($C,A7),A7		;45bd8: 4fef000c
	PEA	(LAB_46196,PC)		;45bdc: 487a05b8
	MOVE.W	#$0084,-(A7)		;45be0: 3f3c0084
	MOVE.W	#$0058,-(A7)		;45be4: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45be8: 2f2c99ec
	JSR	(___text,A4)		;45bec: 4eac813a
	LEA	($C,A7),A7		;45bf0: 4fef000c
	PEA	(LAB_461A0,PC)		;45bf4: 487a05aa
	MOVE.W	#$0097,-(A7)		;45bf8: 3f3c0097
	MOVE.W	#$0058,-(A7)		;45bfc: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45c00: 2f2c99ec
	JSR	(___text,A4)		;45c04: 4eac813a
	LEA	($C,A7),A7		;45c08: 4fef000c
	PEA	(LAB_525C8,A4)		;45c0c: 486c91da
	MOVE.W	#$008d,-(A7)		;45c10: 3f3c008d
	MOVE.W	#$0058,-(A7)		;45c14: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45c18: 2f2c99ec
	JSR	(___text,A4)		;45c1c: 4eac813a
	LEA	($C,A7),A7		;45c20: 4fef000c
	PEA	(LAB_525C8,A4)		;45c24: 486c91da
	MOVE.W	#$00a0,-(A7)		;45c28: 3f3c00a0
	MOVE.W	#$0058,-(A7)		;45c2c: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45c30: 2f2c99ec
	JSR	(___text,A4)		;45c34: 4eac813a
	LEA	($C,A7),A7		;45c38: 4fef000c
LAB_45C3C:
	BTST	#0,(-143,A5)		;45c3c: 082d0000ff71
	BEQ.S	LAB_45C9A		;45c42: 6756
	CLR.W	(-136,A5)		;45c44: 426dff78
LAB_45C48:
	PEA	(LAB_525C8,A4)		;45c48: 486c91da
	MOVE.W	(-136,A5),D0		;45c4c: 302dff78
	ASL.W	#3,D0			;45c50: e740
	ADD.W	#$0022,D0		;45c52: d07c0022
	MOVE.W	D0,-(A7)		;45c56: 3f00
	MOVE.W	#$0058,-(A7)		;45c58: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45c5c: 2f2c99ec
	JSR	(___text,A4)		;45c60: 4eac813a
	LEA	($C,A7),A7		;45c64: 4fef000c
	ADDQ.W	#1,(-136,A5)		;45c68: 526dff78
	CMPI.W	#$000c,(-136,A5)	;45c6c: 0c6d000cff78
	BLT.S	LAB_45C48		;45c72: 6dd4
	MOVE.L	(-84,A5),-(A7)		;45c74: 2f2dffac
	PEA	(_drawer,A4)		;45c78: 486c302c
	JSR	(_get_a_dir,PC)		;45c7c: 4eba4a2c
	ADDQ.W	#8,A7			;45c80: 504f
	MOVE.W	D0,(-132,A5)		;45c82: 3b40ff7c
	BEQ.S	LAB_45C96		;45c86: 670e
	MOVE.L	(-84,A5),-(A7)		;45c88: 2f2dffac
	MOVE.W	(-132,A5),-(A7)		;45c8c: 3f2dff7c
	JSR	(_sort,PC)		;45c90: 4eba053c
	ADDQ.W	#6,A7			;45c94: 5c4f
LAB_45C96:
	CLR.W	(-134,A5)		;45c96: 426dff7a
LAB_45C9A:
	BTST	#1,(-143,A5)		;45c9a: 082d0001ff71
	BEQ.W	LAB_45D8C		;45ca0: 670000ea
	CLR.W	(-136,A5)		;45ca4: 426dff78
LAB_45CA8:
	PEA	(LAB_525C8,A4)		;45ca8: 486c91da
	MOVE.W	(-136,A5),D0		;45cac: 302dff78
	ASL.W	#3,D0			;45cb0: e740
	ADD.W	#$0022,D0		;45cb2: d07c0022
	MOVE.W	D0,-(A7)		;45cb6: 3f00
	MOVE.W	#$0058,-(A7)		;45cb8: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45cbc: 2f2c99ec
	JSR	(___text,A4)		;45cc0: 4eac813a
	LEA	($C,A7),A7		;45cc4: 4fef000c
	ADDQ.W	#1,(-136,A5)		;45cc8: 526dff78
	CMPI.W	#$000c,(-136,A5)	;45ccc: 0c6d000cff78
	BLT.S	LAB_45CA8		;45cd2: 6dd4
	CLR.W	(-136,A5)		;45cd4: 426dff78
	MOVE.W	(-134,A5),(-138,A5)	;45cd8: 3b6dff7aff76
	BRA.W	LAB_45D82		;45cde: 600000a2
LAB_45CE2:
	MOVE.W	(-138,A5),D0		;45ce2: 302dff76
	CMP.W	(-132,A5),D0		;45ce6: b06dff7c
	BGE.S	LAB_45D02		;45cea: 6c16
	MOVE.W	(-138,A5),D0		;45cec: 302dff76
	ASL.W	#5,D0			;45cf0: eb40
	EXT.L	D0			;45cf2: 48c0
	ADD.L	(-84,A5),D0		;45cf4: d0adffac
	MOVE.L	D0,-(A7)		;45cf8: 2f00
	JSR	(___strlen,A4)		;45cfa: 4eac81a6
	ADDQ.W	#4,A7			;45cfe: 584f
	BRA.S	LAB_45D04		;45d00: 6002
LAB_45D02:
	MOVEQ	#0,D0			;45d02: 7000
LAB_45D04:
	MOVE.W	D0,(-142,A5)		;45d04: 3b40ff72
	CLR.W	(-140,A5)		;45d08: 426dff74
LAB_45D0C:
	MOVE.W	(-140,A5),D0		;45d0c: 302dff74
	CMP.W	(-142,A5),D0		;45d10: b06dff72
	BGE.S	LAB_45D34		;45d14: 6c1e
	MOVE.W	(-138,A5),D0		;45d16: 302dff76
	ASL.W	#5,D0			;45d1a: eb40
	ADD.W	(-140,A5),D0		;45d1c: d06dff74
	MOVEA.L	(-84,A5),A0		;45d20: 206dffac
	MOVE.W	(-140,A5),D1		;45d24: 322dff74
	LEA	(-80,A5),A1		;45d28: 43edffb0
	MOVE.B	(0,A0,D0.W),(0,A1,D1.W)	;45d2c: 13b000001000
	BRA.S	LAB_45D42		;45d32: 600e
LAB_45D34:
	MOVE.W	(-140,A5),D0		;45d34: 302dff74
	LEA	(-80,A5),A0		;45d38: 41edffb0
	MOVE.B	#$82,(0,A0,D0.W)	;45d3c: 11bc00820000
LAB_45D42:
	ADDQ.W	#1,(-140,A5)		;45d42: 526dff74
	CMPI.W	#$0010,(-140,A5)	;45d46: 0c6d0010ff74
	BLT.S	LAB_45D0C		;45d4c: 6dbe
	MOVE.W	(-140,A5),D0		;45d4e: 302dff74
	LEA	(-80,A5),A0		;45d52: 41edffb0
	CLR.B	(0,A0,D0.W)		;45d56: 42300000
	PEA	(-80,A5)		;45d5a: 486dffb0
	MOVE.W	(-136,A5),D0		;45d5e: 302dff78
	ASL.W	#3,D0			;45d62: e740
	ADD.W	#$0022,D0		;45d64: d07c0022
	MOVE.W	D0,-(A7)		;45d68: 3f00
	MOVE.W	#$0058,-(A7)		;45d6a: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45d6e: 2f2c99ec
	JSR	(___text,A4)		;45d72: 4eac813a
	LEA	($C,A7),A7		;45d76: 4fef000c
	ADDQ.W	#1,(-136,A5)		;45d7a: 526dff78
	ADDQ.W	#1,(-138,A5)		;45d7e: 526dff76
LAB_45D82:
	CMPI.W	#$000c,(-136,A5)	;45d82: 0c6d000cff78
	BLT.W	LAB_45CE2		;45d88: 6d00ff58
LAB_45D8C:
	BTST	#2,(-143,A5)		;45d8c: 082d0002ff71
	BEQ.S	LAB_45E06		;45d92: 6772
	PEA	(_drawer,A4)		;45d94: 486c302c
	JSR	(___strlen,A4)		;45d98: 4eac81a6
	ADDQ.W	#4,A7			;45d9c: 584f
	MOVE.W	D0,(-142,A5)		;45d9e: 3b40ff72
	CLR.W	(-140,A5)		;45da2: 426dff74
LAB_45DA6:
	MOVE.W	(-140,A5),D0		;45da6: 302dff74
	CMP.W	(-142,A5),D0		;45daa: b06dff72
	BGE.S	LAB_45DC8		;45dae: 6c18
	MOVE.W	(-140,A5),D0		;45db0: 302dff74
	LEA	(_drawer,A4),A0		;45db4: 41ec302c
	MOVE.W	(-140,A5),D1		;45db8: 322dff74
	LEA	(-80,A5),A1		;45dbc: 43edffb0
	MOVE.B	(0,A0,D0.W),(0,A1,D1.W)	;45dc0: 13b000001000
	BRA.S	LAB_45DD6		;45dc6: 600e
LAB_45DC8:
	MOVE.W	(-140,A5),D0		;45dc8: 302dff74
	LEA	(-80,A5),A0		;45dcc: 41edffb0
	MOVE.B	#$82,(0,A0,D0.W)	;45dd0: 11bc00820000
LAB_45DD6:
	ADDQ.W	#1,(-140,A5)		;45dd6: 526dff74
	CMPI.W	#$0010,(-140,A5)	;45dda: 0c6d0010ff74
	BLT.S	LAB_45DA6		;45de0: 6dc4
	MOVE.W	(-140,A5),D0		;45de2: 302dff74
	LEA	(-80,A5),A0		;45de6: 41edffb0
	CLR.B	(0,A0,D0.W)		;45dea: 42300000
	PEA	(-80,A5)		;45dee: 486dffb0
	MOVE.W	#$008d,-(A7)		;45df2: 3f3c008d
	MOVE.W	#$0058,-(A7)		;45df6: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45dfa: 2f2c99ec
	JSR	(___text,A4)		;45dfe: 4eac813a
	LEA	($C,A7),A7		;45e02: 4fef000c
LAB_45E06:
	BTST	#3,(-143,A5)		;45e06: 082d0003ff71
	BEQ.W	LAB_45E9A		;45e0c: 6700008c
	PEA	(_filename,A4)		;45e10: 486c3040
	JSR	(___strlen,A4)		;45e14: 4eac81a6
	ADDQ.W	#4,A7			;45e18: 584f
	MOVE.W	D0,(-142,A5)		;45e1a: 3b40ff72
	CLR.W	(-140,A5)		;45e1e: 426dff74
LAB_45E22:
	MOVE.W	(-140,A5),D0		;45e22: 302dff74
	CMP.W	(-142,A5),D0		;45e26: b06dff72
	BGE.S	LAB_45E44		;45e2a: 6c18
	MOVE.W	(-140,A5),D0		;45e2c: 302dff74
	LEA	(_filename,A4),A0	;45e30: 41ec3040
	MOVE.W	(-140,A5),D1		;45e34: 322dff74
	LEA	(-80,A5),A1		;45e38: 43edffb0
	MOVE.B	(0,A0,D0.W),(0,A1,D1.W)	;45e3c: 13b000001000
	BRA.S	LAB_45E52		;45e42: 600e
LAB_45E44:
	MOVE.W	(-140,A5),D0		;45e44: 302dff74
	LEA	(-80,A5),A0		;45e48: 41edffb0
	MOVE.B	#$82,(0,A0,D0.W)	;45e4c: 11bc00820000
LAB_45E52:
	ADDQ.W	#1,(-140,A5)		;45e52: 526dff74
	CMPI.W	#$0010,(-140,A5)	;45e56: 0c6d0010ff74
	BLT.S	LAB_45E22		;45e5c: 6dc4
	MOVE.W	(-140,A5),D0		;45e5e: 302dff74
	LEA	(-80,A5),A0		;45e62: 41edffb0
	CLR.B	(0,A0,D0.W)		;45e66: 42300000
	PEA	(LAB_525C8,A4)		;45e6a: 486c91da
	MOVE.W	#$00a0,-(A7)		;45e6e: 3f3c00a0
	MOVE.W	#$0058,-(A7)		;45e72: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45e76: 2f2c99ec
	JSR	(___text,A4)		;45e7a: 4eac813a
	LEA	($C,A7),A7		;45e7e: 4fef000c
	PEA	(-80,A5)		;45e82: 486dffb0
	MOVE.W	#$00a0,-(A7)		;45e86: 3f3c00a0
	MOVE.W	#$0058,-(A7)		;45e8a: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;45e8e: 2f2c99ec
	JSR	(___text,A4)		;45e92: 4eac813a
	LEA	($C,A7),A7		;45e96: 4fef000c
LAB_45E9A:
	CLR.W	(-144,A5)		;45e9a: 426dff70
	MOVE.W	#$0002,(_left_button,A4) ;45e9e: 397c0002ae62
LAB_45EA4:
	TST.W	(_left_button,A4)	;45ea4: 4a6cae62
	BEQ.S	LAB_45EAC		;45ea8: 6702
	BRA.S	LAB_45EA4		;45eaa: 60f8
LAB_45EAC:
	CMPI.W	#$0058,(_mousex,A4)	;45eac: 0c6c005899aa
	BLT.W	LAB_45F7E		;45eb2: 6d0000ca
	CMPI.W	#$00d8,(_mousex,A4)	;45eb6: 0c6c00d899aa
	BGT.W	LAB_45F7E		;45ebc: 6e0000c0
	CMPI.W	#$0022,(_mousey,A4)	;45ec0: 0c6c0022ae6e
	BLT.S	LAB_45F0C		;45ec6: 6d44
	CMPI.W	#$0082,(_mousey,A4)	;45ec8: 0c6c0082ae6e
	BGT.S	LAB_45F0C		;45ece: 6e3c
	MOVE.W	(_mousey,A4),D0		;45ed0: 302cae6e
	SUB.W	#$0022,D0		;45ed4: 907c0022
	ASR.W	#3,D0			;45ed8: e640
	ADD.W	(-134,A5),D0		;45eda: d06dff7a
	MOVE.W	D0,(-136,A5)		;45ede: 3b40ff78
	MOVE.W	(-136,A5),D0		;45ee2: 302dff78
	CMP.W	(-132,A5),D0		;45ee6: b06dff7c
	BGE.S	LAB_45F0A		;45eea: 6c1e
	MOVE.W	(-136,A5),D0		;45eec: 302dff78
	ASL.W	#5,D0			;45ef0: eb40
	EXT.L	D0			;45ef2: 48c0
	ADD.L	(-84,A5),D0		;45ef4: d0adffac
	MOVE.L	D0,-(A7)		;45ef8: 2f00
	PEA	(_filename,A4)		;45efa: 486c3040
	JSR	(___strcpy,A4)		;45efe: 4eac81a0
	ADDQ.W	#8,A7			;45f02: 504f
	MOVE.W	#$0008,(-144,A5)	;45f04: 3b7c0008ff70
LAB_45F0A:
	BRA.S	LAB_45F7C		;45f0a: 6070
LAB_45F0C:
	CMPI.W	#$008d,(_mousey,A4)	;45f0c: 0c6c008dae6e
	BLT.S	LAB_45F48		;45f12: 6d34
	CMPI.W	#$0095,(_mousey,A4)	;45f14: 0c6c0095ae6e
	BGT.S	LAB_45F48		;45f1a: 6e2c
	PEA	(_end_cancel,A4)	;45f1c: 486c84f4
	PEA	(-130,A5)		;45f20: 486dff7e
	MOVE.W	#$0010,-(A7)		;45f24: 3f3c0010
	MOVE.W	#$008d,-(A7)		;45f28: 3f3c008d
	MOVE.W	#$0058,-(A7)		;45f2c: 3f3c0058
	PEA	(_drawer,A4)		;45f30: 486c302c
	MOVE.L	(_d_screen,A4),-(A7)	;45f34: 2f2c99ec
	JSR	(_get_name,PC)		;45f38: 4ebaf996
	LEA	($16,A7),A7		;45f3c: 4fef0016
	MOVE.W	#$0003,(-144,A5)	;45f40: 3b7c0003ff70
	BRA.S	LAB_45F7C		;45f46: 6034
LAB_45F48:
	CMPI.W	#$00a0,(_mousey,A4)	;45f48: 0c6c00a0ae6e
	BLT.S	LAB_45F7C		;45f4e: 6d2c
	CMPI.W	#$00a8,(_mousey,A4)	;45f50: 0c6c00a8ae6e
	BGT.S	LAB_45F7C		;45f56: 6e24
	PEA	(_end_cancel,A4)	;45f58: 486c84f4
	PEA	(-130,A5)		;45f5c: 486dff7e
	MOVE.W	#$0010,-(A7)		;45f60: 3f3c0010
	MOVE.W	#$00a0,-(A7)		;45f64: 3f3c00a0
	MOVE.W	#$0058,-(A7)		;45f68: 3f3c0058
	PEA	(_filename,A4)		;45f6c: 486c3040
	MOVE.L	(_d_screen,A4),-(A7)	;45f70: 2f2c99ec
	JSR	(_get_name,PC)		;45f74: 4ebaf95a
	LEA	($16,A7),A7		;45f78: 4fef0016
LAB_45F7C:
	BRA.S	LAB_45FD6		;45f7c: 6058
LAB_45F7E:
	CMPI.W	#$00d8,(_mousex,A4)	;45f7e: 0c6c00d899aa
	BLT.S	LAB_45FD6		;45f84: 6d50
	CMPI.W	#$00e0,(_mousex,A4)	;45f86: 0c6c00e099aa
	BGT.S	LAB_45FD6		;45f8c: 6e48
	CMPI.W	#$0022,(_mousey,A4)	;45f8e: 0c6c0022ae6e
	BLT.S	LAB_45FB0		;45f94: 6d1a
	CMPI.W	#$002a,(_mousey,A4)	;45f96: 0c6c002aae6e
	BGT.S	LAB_45FB0		;45f9c: 6e12
	TST.W	(-134,A5)		;45f9e: 4a6dff7a
	BEQ.S	LAB_45FB0		;45fa2: 670c
	SUBQ.W	#1,(-134,A5)		;45fa4: 536dff7a
	MOVE.W	#$0002,(-144,A5)	;45fa8: 3b7c0002ff70
	BRA.S	LAB_45FD6		;45fae: 6026
LAB_45FB0:
	CMPI.W	#$007a,(_mousey,A4)	;45fb0: 0c6c007aae6e
	BLT.S	LAB_45FD6		;45fb6: 6d1e
	CMPI.W	#$0082,(_mousey,A4)	;45fb8: 0c6c0082ae6e
	BGT.S	LAB_45FD6		;45fbe: 6e16
	MOVE.W	(-134,A5),D0		;45fc0: 302dff7a
	ADDQ.W	#5,D0			;45fc4: 5a40
	CMP.W	(-132,A5),D0		;45fc6: b06dff7c
	BGE.S	LAB_45FD6		;45fca: 6c0a
	ADDQ.W	#1,(-134,A5)		;45fcc: 526dff7a
	MOVE.W	#$0002,(-144,A5)	;45fd0: 3b7c0002ff70
LAB_45FD6:
	PEA	(_end_cancel,A4)	;45fd6: 486c84f4
	PEA	(-130,A5)		;45fda: 486dff7e
	JSR	(_check_cancel,PC)	;45fde: 4eba0f70
	ADDQ.W	#8,A7			;45fe2: 504f
	MOVE.W	D0,(-136,A5)		;45fe4: 3b40ff78
	BEQ.W	LAB_4616E		;45fe8: 67000184
	MOVE.W	#$0002,(_left_button,A4) ;45fec: 397c0002ae62
	CMPI.W	#$0001,(-136,A5)	;45ff2: 0c6d0001ff78
	BNE.W	LAB_46160		;45ff8: 66000166
	TST.B	(_filename,A4)		;45ffc: 4a2c3040
	BEQ.W	LAB_46160		;46000: 6700015e
	PEA	(_drawer,A4)		;46004: 486c302c
	PEA	(-80,A5)		;46008: 486dffb0
	JSR	(___strcpy,A4)		;4600c: 4eac81a0
	ADDQ.W	#8,A7			;46010: 504f
	PEA	(-80,A5)		;46012: 486dffb0
	JSR	(___strlen,A4)		;46016: 4eac81a6
	ADDQ.W	#4,A7			;4601a: 584f
	SUBQ.W	#1,D0			;4601c: 5340
	MOVE.W	D0,(-138,A5)		;4601e: 3b40ff76
	TST.W	(-138,A5)		;46022: 4a6dff76
	BLE.S	LAB_4606A		;46026: 6f42
	MOVE.W	(-138,A5),D0		;46028: 302dff76
	LEA	(-80,A5),A0		;4602c: 41edffb0
	CMPI.B	#$3a,(0,A0,D0.W)	;46030: 0c30003a0000
	BEQ.S	LAB_4605A		;46036: 6722
	MOVE.W	(-138,A5),D0		;46038: 302dff76
	LEA	(-80,A5),A0		;4603c: 41edffb0
	CMPI.B	#$2f,(0,A0,D0.W)	;46040: 0c30002f0000
	BEQ.S	LAB_4605A		;46046: 6712
	ADDQ.W	#1,(-138,A5)		;46048: 526dff76
	MOVE.W	(-138,A5),D0		;4604c: 302dff76
	LEA	(-80,A5),A0		;46050: 41edffb0
	MOVE.B	#$2f,(0,A0,D0.W)	;46054: 11bc002f0000
LAB_4605A:
	ADDQ.W	#1,(-138,A5)		;4605a: 526dff76
	MOVE.W	(-138,A5),D0		;4605e: 302dff76
	LEA	(-80,A5),A0		;46062: 41edffb0
	CLR.B	(0,A0,D0.W)		;46066: 42300000
LAB_4606A:
	PEA	(_filename,A4)		;4606a: 486c3040
	PEA	(-80,A5)		;4606e: 486dffb0
	JSR	(___strcat,A4)		;46072: 4eac81be
	ADDQ.W	#8,A7			;46076: 504f
	TST.W	(8,A5)			;46078: 4a6d0008
	BEQ.W	LAB_46146		;4607c: 670000c8
	PEA	(-80,A5)		;46080: 486dffb0
	JSR	(_save_game,PC)		;46084: 4eba49e0
	ADDQ.W	#4,A7			;46088: 584f
	TST.W	D0			;4608a: 4a40
	BEQ.S	LAB_4610A		;4608c: 677c
	PEA	(LAB_525B3,A4)		;4608e: 486c91c5
	MOVE.W	#$0097,-(A7)		;46092: 3f3c0097
	MOVE.W	#$0058,-(A7)		;46096: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;4609a: 2f2c99ec
	JSR	(___text,A4)		;4609e: 4eac813a
	LEA	($C,A7),A7		;460a2: 4fef000c
	PEA	(LAB_461AA,PC)		;460a6: 487a0102
	MOVE.W	#$0097,-(A7)		;460aa: 3f3c0097
	MOVE.W	#$0058,-(A7)		;460ae: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;460b2: 2f2c99ec
	JSR	(___text,A4)		;460b6: 4eac813a
	LEA	($C,A7),A7		;460ba: 4fef000c
	MOVE.W	#$0002,(_left_button,A4) ;460be: 397c0002ae62
	MOVE.W	#$0002,(_right_button,A4) ;460c4: 397c0002ae64
LAB_460CA:
	TST.W	(_left_button,A4)	;460ca: 4a6cae62
	BEQ.S	LAB_460D8		;460ce: 6708
	TST.W	(_right_button,A4)	;460d0: 4a6cae64
	BEQ.S	LAB_460D8		;460d4: 6702
	BRA.S	LAB_460CA		;460d6: 60f2
LAB_460D8:
	PEA	(LAB_525B3,A4)		;460d8: 486c91c5
	MOVE.W	#$0097,-(A7)		;460dc: 3f3c0097
	MOVE.W	#$0058,-(A7)		;460e0: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;460e4: 2f2c99ec
	JSR	(___text,A4)		;460e8: 4eac813a
	LEA	($C,A7),A7		;460ec: 4fef000c
	PEA	(LAB_461BA,PC)		;460f0: 487a00c8
	MOVE.W	#$0097,-(A7)		;460f4: 3f3c0097
	MOVE.W	#$0058,-(A7)		;460f8: 3f3c0058
	MOVE.L	(_d_screen,A4),-(A7)	;460fc: 2f2c99ec
	JSR	(___text,A4)		;46100: 4eac813a
	LEA	($C,A7),A7		;46104: 4fef000c
	BRA.S	LAB_4616E		;46108: 6064
LAB_4610A:
	MOVE.W	#$0001,(_saved,A4)	;4610a: 397c00013054
LAB_46110:
	PEA	$3ED.W			;46110: 487803ed
	PEA	(str_leveldat,PC)	;46114: 487a00ae
	JSR	(___Open,A4)		;46118: 4eac81e2
	ADDQ.W	#8,A7			;4611c: 504f
	MOVE.L	D0,(-148,A5)		;4611e: 2b40ff6c
	TST.L	D0			;46122: 4a80
	BLE.S	LAB_46132		;46124: 6f0c
	MOVE.L	(-148,A5),-(A7)		;46126: 2f2dff6c
	JSR	(___Close,A4)		;4612a: 4eac81d6
	ADDQ.W	#4,A7			;4612e: 584f
	BRA.S	LAB_4613E		;46130: 600c
LAB_46132:
	CLR.W	-(A7)			;46132: 4267
	MOVE.L	(LAB_51BD8,A4),-(A7)	;46134: 2f2c87ea
	JSR	(_do_message,PC)	;46138: 4eba0158
	ADDQ.W	#6,A7			;4613c: 5c4f
LAB_4613E:
	TST.L	(-148,A5)		;4613e: 4aadff6c
	BLE.S	LAB_46110		;46142: 6fcc
	BRA.S	LAB_46150		;46144: 600a
LAB_46146:
	PEA	(-80,A5)		;46146: 486dffb0
	JSR	(_load_game,PC)		;4614a: 4eba4d0c
	ADDQ.W	#4,A7			;4614e: 584f
LAB_46150:
	MOVE.W	#$007f,-(A7)		;46150: 3f3c007f
	JSR	(___set_pri,A4)		;46154: 4eac8014
	ADDQ.W	#2,A7			;46158: 544f
	MOVEQ	#1,D0			;4615a: 7001
LAB_4615C:
	UNLK	A5			;4615c: 4e5d
	RTS				;4615e: 4e75
LAB_46160:
	MOVE.W	#$007f,-(A7)		;46160: 3f3c007f
	JSR	(___set_pri,A4)		;46164: 4eac8014
	ADDQ.W	#2,A7			;46168: 544f
	MOVEQ	#0,D0			;4616a: 7000
	BRA.S	LAB_4615C		;4616c: 60ee
LAB_4616E:
	BRA.W	LAB_45C3C		;4616e: 6000facc
	BRA.S	LAB_4615C		;46172: 60e8
LAB_46174:
	;46174
	;DC.B	$53,$41,$56,$45,$00
	DC.B	"SAVE",0
LAB_46179:
	;46179
	;DC.B	$53,$41,$56,$45,$20,$47,$41,$4d,$45,$00
	DC.B	"SAVE GAME",0
LAB_46183:
	;46183
	;DC.B	$4c,$4f,$41,$44,$00
	DC.B	"LOAD",0
LAB_46188:
	;46188
	;DC.B	$4c,$4f,$41,$44,$20,$47,$41,$4d,$45,$00
	DC.B	"LOAD GAME",0
LAB_46192:
	DC.W	$8800			;46192
LAB_46194:
	DC.W	$8900			;46194
LAB_46196:
	;46196
	;DC.B	$44,$49,$52,$45,$43,$54,$4f,$52,$59,$00
	DC.B	"DIRECTORY",0
LAB_461A0:
	;461a0
	;DC.B	$46,$49,$4c,$45,$20,$4e,$41,$4d,$45,$00
	DC.B	"FILE NAME",0
LAB_461AA:
	;461aa
	;DC.B	$45,$52,$52,$4f,$52,$20,$49,$4e,$20,$53,$41,$56,$49,$4e,$47,$00
	DC.B	"ERROR IN SAVING",0
LAB_461BA:
	;461ba
	;DC.B	$46,$49,$4c,$45,$20,$4e,$41,$4d,$45,$00
	DC.B	"FILE NAME",0
str_leveldat:
	;461c4
	;DC.B	$6c,$65,$76,$65,$6c,$2e,$64,$61,$74,$00
	DC.B	"level.dat",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_sort:
	LINK.W	A5,#-42			;461ce: 4e55ffd6
	MOVEM.L	D4-D7,-(A7)		;461d2: 48e70f00
	MOVE.W	(8,A5),(-2,A5)		;461d6: 3b6d0008fffe
LAB_461DC:
	ASR	(-2,A5)			;461dc: e0edfffe
	BEQ.W	LAB_4628A		;461e0: 670000a8
	MOVE.W	(8,A5),D7		;461e4: 3e2d0008
	SUB.W	(-2,A5),D7		;461e8: 9e6dfffe
	MOVEQ	#1,D6			;461ec: 7c01
LAB_461EE:
	MOVE.W	D6,D5			;461ee: 3a06
LAB_461F0:
	MOVE.W	D5,D4			;461f0: 3805
	ADD.W	(-2,A5),D4		;461f2: d86dfffe
	MOVE.W	D4,D0			;461f6: 3004
	SUBQ.W	#1,D0			;461f8: 5340
	ASL.W	#5,D0			;461fa: eb40
	EXT.L	D0			;461fc: 48c0
	ADD.L	($A,A5),D0		;461fe: d0ad000a
	MOVE.L	D0,-(A7)		;46202: 2f00
	MOVE.W	D5,D0			;46204: 3005
	SUBQ.W	#1,D0			;46206: 5340
	ASL.W	#5,D0			;46208: eb40
	EXT.L	D0			;4620a: 48c0
	ADD.L	($A,A5),D0		;4620c: d0ad000a
	MOVE.L	D0,-(A7)		;46210: 2f00
	JSR	(___strcmp,A4)		;46212: 4eac81b2
	ADDQ.W	#8,A7			;46216: 504f
	TST.W	D0			;46218: 4a40
	BLE.S	LAB_46274		;4621a: 6f58
	MOVE.W	D5,D0			;4621c: 3005
	SUBQ.W	#1,D0			;4621e: 5340
	ASL.W	#5,D0			;46220: eb40
	EXT.L	D0			;46222: 48c0
	ADD.L	($A,A5),D0		;46224: d0ad000a
	MOVE.L	D0,-(A7)		;46228: 2f00
	PEA	(-42,A5)		;4622a: 486dffd6
	JSR	(___strcpy,A4)		;4622e: 4eac81a0
	ADDQ.W	#8,A7			;46232: 504f
	MOVE.W	D4,D0			;46234: 3004
	SUBQ.W	#1,D0			;46236: 5340
	ASL.W	#5,D0			;46238: eb40
	EXT.L	D0			;4623a: 48c0
	ADD.L	($A,A5),D0		;4623c: d0ad000a
	MOVE.L	D0,-(A7)		;46240: 2f00
	MOVE.W	D5,D0			;46242: 3005
	SUBQ.W	#1,D0			;46244: 5340
	ASL.W	#5,D0			;46246: eb40
	EXT.L	D0			;46248: 48c0
	ADD.L	($A,A5),D0		;4624a: d0ad000a
	MOVE.L	D0,-(A7)		;4624e: 2f00
	JSR	(___strcpy,A4)		;46250: 4eac81a0
	ADDQ.W	#8,A7			;46254: 504f
	PEA	(-42,A5)		;46256: 486dffd6
	MOVE.W	D4,D0			;4625a: 3004
	SUBQ.W	#1,D0			;4625c: 5340
	ASL.W	#5,D0			;4625e: eb40
	EXT.L	D0			;46260: 48c0
	ADD.L	($A,A5),D0		;46262: d0ad000a
	MOVE.L	D0,-(A7)		;46266: 2f00
	JSR	(___strcpy,A4)		;46268: 4eac81a0
	ADDQ.W	#8,A7			;4626c: 504f
	SUB.W	(-2,A5),D5		;4626e: 9a6dfffe
	BRA.S	LAB_46276		;46272: 6002
LAB_46274:
	BRA.S	LAB_4627E		;46274: 6008
LAB_46276:
	CMP.W	#$0001,D5		;46276: ba7c0001
	BGE.W	LAB_461F0		;4627a: 6c00ff74
LAB_4627E:
	ADDQ.W	#1,D6			;4627e: 5246
	CMP.W	D7,D6			;46280: bc47
	BLE.W	LAB_461EE		;46282: 6f00ff6a
	BRA.W	LAB_461DC		;46286: 6000ff54
LAB_4628A:
	MOVEM.L	(A7)+,D4-D7		;4628a: 4cdf00f0
	UNLK	A5			;4628e: 4e5d
	RTS				;46290: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_message:
	LINK.W	A5,#-6			;46292: 4e55fffa
	TST.W	($C,A5)			;46296: 4a6d000c
	BEQ.S	LAB_462A6		;4629a: 670a
	LEA	(_end_cancel,A4),A0	;4629c: 41ec84f4
	MOVE.L	A0,(-4,A5)		;462a0: 2b48fffc
	BRA.S	LAB_462AA		;462a4: 6004
LAB_462A6:
	CLR.L	(-4,A5)			;462a6: 42adfffc
LAB_462AA:
	MOVE.L	(-4,A5),-(A7)		;462aa: 2f2dfffc
	PEA	(_end_ok,A4)		;462ae: 486c84c6
	MOVE.W	#$0030,-(A7)		;462b2: 3f3c0030
	MOVE.W	#$0100,-(A7)		;462b6: 3f3c0100
	MOVE.W	#$003c,-(A7)		;462ba: 3f3c003c
	MOVE.W	#$0028,-(A7)		;462be: 3f3c0028
	MOVE.L	(_d_screen,A4),-(A7)	;462c2: 2f2c99ec
	JSR	(_requester,PC)		;462c6: 4ebaf1bc
	LEA	($14,A7),A7		;462ca: 4fef0014
	MOVE.L	(8,A5),-(A7)		;462ce: 2f2d0008
	MOVE.W	#$0048,-(A7)		;462d2: 3f3c0048
	MOVE.W	#$0038,-(A7)		;462d6: 3f3c0038
	MOVE.L	(_d_screen,A4),-(A7)	;462da: 2f2c99ec
	JSR	(___text,A4)		;462de: 4eac813a
	LEA	($C,A7),A7		;462e2: 4fef000c
LAB_462E6:
	MOVE.W	#$0002,(_left_button,A4) ;462e6: 397c0002ae62
LAB_462EC:
	TST.W	(_left_button,A4)	;462ec: 4a6cae62
	BEQ.S	LAB_462F4		;462f0: 6702
	BRA.S	LAB_462EC		;462f2: 60f8
LAB_462F4:
	MOVE.L	(-4,A5),-(A7)		;462f4: 2f2dfffc
	PEA	(_end_ok,A4)		;462f8: 486c84c6
	JSR	(_check_cancel,PC)	;462fc: 4eba0c52
	ADDQ.W	#8,A7			;46300: 504f
	MOVE.W	D0,(-6,A5)		;46302: 3b40fffa
	BEQ.S	LAB_462E6		;46306: 67de
	MOVE.W	#$0002,(_left_button,A4) ;46308: 397c0002ae62
	MOVE.W	(-6,A5),D0		;4630e: 302dfffa
	UNLK	A5			;46312: 4e5d
	RTS				;46314: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_get_a_message:
	LINK.W	A5,#0			;46316: 4e550000
	PEA	(_end_cancel,A4)	;4631a: 486c84f4
	PEA	(_end_ok,A4)		;4631e: 486c84c6
	MOVE.W	#$0050,-(A7)		;46322: 3f3c0050
	MOVE.W	#$0100,-(A7)		;46326: 3f3c0100
	MOVE.W	#$003c,-(A7)		;4632a: 3f3c003c
	MOVE.W	#$0028,-(A7)		;4632e: 3f3c0028
	MOVE.L	(_d_screen,A4),-(A7)	;46332: 2f2c99ec
	JSR	(_requester,PC)		;46336: 4ebaf14c
	LEA	($14,A7),A7		;4633a: 4fef0014
	MOVE.L	(_g_text,A4),-(A7)	;4633e: 2f2c87aa
	MOVE.W	#$004c,-(A7)		;46342: 3f3c004c
	MOVE.L	(_g_text,A4),-(A7)	;46346: 2f2c87aa
	JSR	(___strlen,A4)		;4634a: 4eac81a6
	ADDQ.W	#4,A7			;4634e: 584f
	ASL.W	#3,D0			;46350: e740
	EXT.L	D0			;46352: 48c0
	DIVS	#$0002,D0		;46354: 81fc0002
	MOVE.W	#$00a8,D1		;46358: 323c00a8
	SUB.W	D0,D1			;4635c: 9240
	MOVE.W	D1,-(A7)		;4635e: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;46360: 2f2c99ec
	JSR	(___text,A4)		;46364: 4eac813a
	LEA	($C,A7),A7		;46368: 4fef000c
	MOVEA.L	(8,A5),A0		;4636c: 206d0008
	CLR.B	(A0)			;46370: 4210
	PEA	(_end_cancel,A4)	;46372: 486c84f4
	PEA	(_end_ok,A4)		;46376: 486c84c6
	MOVE.W	#$001c,-(A7)		;4637a: 3f3c001c
	MOVE.W	#$0064,-(A7)		;4637e: 3f3c0064
	MOVE.W	#$0030,-(A7)		;46382: 3f3c0030
	MOVE.L	(8,A5),-(A7)		;46386: 2f2d0008
	MOVE.L	(_d_screen,A4),-(A7)	;4638a: 2f2c99ec
	JSR	(_get_name,PC)		;4638e: 4ebaf540
	LEA	($16,A7),A7		;46392: 4fef0016
	MOVE.W	#$0002,(_left_button,A4) ;46396: 397c0002ae62
	UNLK	A5			;4639c: 4e5d
	RTS				;4639e: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_serial_message:
	LINK.W	A5,#-4			;463a0: 4e55fffc
	CLR.L	-(A7)			;463a4: 42a7
	PEA	(_end_ok,A4)		;463a6: 486c84c6
	MOVE.W	#$0050,-(A7)		;463aa: 3f3c0050
	MOVE.W	#$0100,-(A7)		;463ae: 3f3c0100
	MOVE.W	#$003c,-(A7)		;463b2: 3f3c003c
	MOVE.W	#$0028,-(A7)		;463b6: 3f3c0028
	MOVE.L	(_d_screen,A4),-(A7)	;463ba: 2f2c99ec
	JSR	(_requester,PC)		;463be: 4ebaf0c4
	LEA	($14,A7),A7		;463c2: 4fef0014
	MOVE.L	(8,A5),-(A7)		;463c6: 2f2d0008
	MOVE.W	#$004c,-(A7)		;463ca: 3f3c004c
	MOVE.W	#$0038,-(A7)		;463ce: 3f3c0038
	MOVE.L	(_d_screen,A4),-(A7)	;463d2: 2f2c99ec
	JSR	(___text,A4)		;463d6: 4eac813a
	LEA	($C,A7),A7		;463da: 4fef000c
	MOVE.L	(LAB_51BA4,A4),-(A7)	;463de: 2f2c87b6
	MOVE.W	#$0056,-(A7)		;463e2: 3f3c0056
	MOVE.W	#$0038,-(A7)		;463e6: 3f3c0038
	MOVE.L	(_d_screen,A4),-(A7)	;463ea: 2f2c99ec
	JSR	(___text,A4)		;463ee: 4eac813a
	LEA	($C,A7),A7		;463f2: 4fef000c
	TST.W	(_quick_io,A4)		;463f6: 4a6c3056
	BEQ.S	LAB_46432		;463fa: 6736
	MOVE.B	#$0f,(_message,A4)	;463fc: 197c000f3058
	PEA	(_message,A4)		;46402: 486c3058
	JSR	(___compress,A4)	;46406: 4eac8194
	ADDQ.W	#4,A7			;4640a: 584f
	MOVE.W	D0,(-2,A5)		;4640c: 3b40fffe
	CLR.W	(-4,A5)			;46410: 426dfffc
LAB_46414:
	CLR.L	-(A7)			;46414: 42a7
	MOVE.W	#$0005,-(A7)		;46416: 3f3c0005
	PEA	(-2,A5)			;4641a: 486dfffe
	JSR	(_write_serial,PC)	;4641e: 4eba6bb2
	LEA	($A,A7),A7		;46422: 4fef000a
	ADDQ.W	#1,(-4,A5)		;46426: 526dfffc
	CMPI.W	#$000a,(-4,A5)		;4642a: 0c6d000afffc
	BLT.S	LAB_46414		;46430: 6de2
LAB_46432:
	MOVE.W	#$0002,(_left_button,A4) ;46432: 397c0002ae62
LAB_46438:
	TST.W	(_left_button,A4)	;46438: 4a6cae62
	BEQ.S	LAB_46440		;4643c: 6702
	BRA.S	LAB_46438		;4643e: 60f8
LAB_46440:
	CLR.L	-(A7)			;46440: 42a7
	PEA	(_end_ok,A4)		;46442: 486c84c6
	JSR	(_check_cancel,PC)	;46446: 4eba0b08
	ADDQ.W	#8,A7			;4644a: 504f
	TST.W	D0			;4644c: 4a40
	BEQ.S	LAB_46432		;4644e: 67e2
	JSR	(_clear_serial,PC)	;46450: 4eba6a5a
	MOVE.W	#$0002,(_left_button,A4) ;46454: 397c0002ae62
	MOVE.W	#$0001,(_serial_off,A4)	;4645a: 397c00018254
	TST.W	(_pause,A4)		;46460: 4a6c9c22
	BNE.S	LAB_4646E		;46464: 6608
	MOVE.W	#$0001,(_pause,A4)	;46466: 397c00019c22
	BRA.S	LAB_46472		;4646c: 6004
LAB_4646E:
	CLR.W	(_pause,A4)		;4646e: 426c9c22
LAB_46472:
	CLR.W	(_toggle,A4)		;46472: 426c9a1a
	MOVE.W	#$17e4,-(A7)		;46476: 3f3c17e4
	MOVE.W	#$0003,-(A7)		;4647a: 3f3c0003
	MOVE.W	#$0001,-(A7)		;4647e: 3f3c0001
	MOVE.L	(_back_scr,A4),-(A7)	;46482: 2f2c9874
	JSR	(___toggle_icon,A4)	;46486: 4eac8122
	LEA	($A,A7),A7		;4648a: 4fef000a
	JSR	(___clear_send,A4)	;4648e: 4eac80ec
	MOVE.W	(_not_player,A4),D0	;46492: 302c825a
	MULS	#$002e,D0		;46496: c1fc002e
	LEA	(LAB_516AA,A4),A0	;4649a: 41ec82bc
	MOVE.W	#$0001,(0,A0,D0.L)	;4649e: 31bc00010800
	UNLK	A5			;464a4: 4e5d
	RTS				;464a6: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_two_players:
	LINK.W	A5,#-94			;464a8: 4e55ffa2
	MOVE.W	#$03e7,(-40,A5)		;464ac: 3b7c03e7ffd8
	MOVE.W	#$0001,(-44,A5)		;464b2: 3b7c0001ffd4
	TST.W	(_bring_up_two,A4)	;464b8: 4a6c3080
	BEQ.S	LAB_464DA		;464bc: 671c
	PEA	(LAB_46C80,PC)		;464be: 487a07c0
	PEA	(-88,A5)		;464c2: 486dffa8
	JSR	(___strcpy,A4)		;464c6: 4eac81a0
	ADDQ.W	#8,A7			;464ca: 504f
	LEA	(-94,A5),A0		;464cc: 41edffa2
	MOVE.L	A0,(-48,A5)		;464d0: 2b48ffd0
	JSR	(_clear_serial,PC)	;464d4: 4eba69d6
	BRA.S	LAB_464E2		;464d8: 6008
LAB_464DA:
	LEA	(_end_cancel,A4),A0	;464da: 41ec84f4
	MOVE.L	A0,(-48,A5)		;464de: 2b48ffd0
LAB_464E2:
	MOVE.W	(_player,A4),(-42,A5)	;464e2: 3b6c99f4ffd6
LAB_464E8:
	TST.W	(-40,A5)		;464e8: 4a6dffd8
	BEQ.W	LAB_46774		;464ec: 67000286
	CLR.L	-(A7)			;464f0: 42a7
	MOVE.L	(-48,A5),-(A7)		;464f2: 2f2dffd0
	MOVE.W	#$0080,-(A7)		;464f6: 3f3c0080
	MOVE.W	#$0100,-(A7)		;464fa: 3f3c0100
	MOVE.W	#$002e,-(A7)		;464fe: 3f3c002e
	MOVE.W	#$0020,-(A7)		;46502: 3f3c0020
	MOVE.L	(_d_screen,A4),-(A7)	;46506: 2f2c99ec
	JSR	(_requester,PC)		;4650a: 4ebaef78
	LEA	($14,A7),A7		;4650e: 4fef0014
	CMPI.W	#$0002,(-40,A5)		;46512: 0c6d0002ffd8
	BNE.S	LAB_46572		;46518: 6658
	MOVE.W	(-42,A5),D0		;4651a: 302dffd6
	ADD.W	#$000c,D0		;4651e: d07c000c
	MULS	#$002e,D0		;46522: c1fc002e
	LEA	(LAB_525E0,A4),A0	;46526: 41ec91f2
	ADD.L	A0,D0			;4652a: d088
	MOVE.L	D0,-(A7)		;4652c: 2f00
	MOVE.W	(-42,A5),D0		;4652e: 302dffd6
	ADD.W	#$000c,D0		;46532: d07c000c
	MULS	#$002e,D0		;46536: c1fc002e
	LEA	(LAB_525DC,A4),A0	;4653a: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;4653e: 32300800
	ADD.W	#$002e,D1		;46542: d27c002e
	MOVE.W	D1,-(A7)		;46546: 3f01
	MOVE.W	(-42,A5),D0		;46548: 302dffd6
	ADD.W	#$000c,D0		;4654c: d07c000c
	MULS	#$002e,D0		;46550: c1fc002e
	LEA	(_serial_text,A4),A0	;46554: 41ec91ec
	MOVE.W	(0,A0,D0.L),D1		;46558: 32300800
	ADD.W	#$0020,D1		;4655c: d27c0020
	MOVE.W	D1,-(A7)		;46560: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;46562: 2f2c99ec
	JSR	(___text,A4)		;46566: 4eac813a
	LEA	($C,A7),A7		;4656a: 4fef000c
	BRA.W	LAB_466B4		;4656e: 60000144
LAB_46572:
	CMPI.W	#$0003,(-40,A5)		;46572: 0c6d0003ffd8
	BNE.S	LAB_465D2		;46578: 6658
	MOVE.W	(-44,A5),D0		;4657a: 302dffd4
	ADD.W	#$000e,D0		;4657e: d07c000e
	MULS	#$002e,D0		;46582: c1fc002e
	LEA	(LAB_525E0,A4),A0	;46586: 41ec91f2
	ADD.L	A0,D0			;4658a: d088
	MOVE.L	D0,-(A7)		;4658c: 2f00
	MOVE.W	(-44,A5),D0		;4658e: 302dffd4
	ADD.W	#$000e,D0		;46592: d07c000e
	MULS	#$002e,D0		;46596: c1fc002e
	LEA	(LAB_525DC,A4),A0	;4659a: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;4659e: 32300800
	ADD.W	#$002e,D1		;465a2: d27c002e
	MOVE.W	D1,-(A7)		;465a6: 3f01
	MOVE.W	(-44,A5),D0		;465a8: 302dffd4
	ADD.W	#$000e,D0		;465ac: d07c000e
	MULS	#$002e,D0		;465b0: c1fc002e
	LEA	(_serial_text,A4),A0	;465b4: 41ec91ec
	MOVE.W	(0,A0,D0.L),D1		;465b8: 32300800
	ADD.W	#$0020,D1		;465bc: d27c0020
	MOVE.W	D1,-(A7)		;465c0: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;465c2: 2f2c99ec
	JSR	(___text,A4)		;465c6: 4eac813a
	LEA	($C,A7),A7		;465ca: 4fef000c
	BRA.W	LAB_466B4		;465ce: 600000e4
LAB_465D2:
	CMPI.W	#$0004,(-40,A5)		;465d2: 0c6d0004ffd8
	BNE.S	LAB_46602		;465d8: 6628
	PEA	(LAB_528C0,A4)		;465da: 486c94d2
	MOVE.W	(LAB_528BC,A4),D0	;465de: 302c94ce
	ADD.W	#$002e,D0		;465e2: d07c002e
	MOVE.W	D0,-(A7)		;465e6: 3f00
	MOVE.W	(LAB_528BA,A4),D0	;465e8: 302c94cc
	ADD.W	#$0020,D0		;465ec: d07c0020
	MOVE.W	D0,-(A7)		;465f0: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;465f2: 2f2c99ec
	JSR	(___text,A4)		;465f6: 4eac813a
	LEA	($C,A7),A7		;465fa: 4fef000c
	BRA.W	LAB_466B4		;465fe: 600000b4
LAB_46602:
	CMPI.W	#$0005,(-40,A5)		;46602: 0c6d0005ffd8
	BNE.S	LAB_46660		;46608: 6656
	MOVE.W	(_quick_io,A4),D0	;4660a: 302c3056
	ADD.W	#$0011,D0		;4660e: d07c0011
	MULS	#$002e,D0		;46612: c1fc002e
	LEA	(LAB_525E0,A4),A0	;46616: 41ec91f2
	ADD.L	A0,D0			;4661a: d088
	MOVE.L	D0,-(A7)		;4661c: 2f00
	MOVE.W	(_quick_io,A4),D0	;4661e: 302c3056
	ADD.W	#$0011,D0		;46622: d07c0011
	MULS	#$002e,D0		;46626: c1fc002e
	LEA	(LAB_525DC,A4),A0	;4662a: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;4662e: 32300800
	ADD.W	#$002e,D1		;46632: d27c002e
	MOVE.W	D1,-(A7)		;46636: 3f01
	MOVE.W	(_quick_io,A4),D0	;46638: 302c3056
	ADD.W	#$0011,D0		;4663c: d07c0011
	MULS	#$002e,D0		;46640: c1fc002e
	LEA	(_serial_text,A4),A0	;46644: 41ec91ec
	MOVE.W	(0,A0,D0.L),D1		;46648: 32300800
	ADD.W	#$0020,D1		;4664c: d27c0020
	MOVE.W	D1,-(A7)		;46650: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;46652: 2f2c99ec
	JSR	(___text,A4)		;46656: 4eac813a
	LEA	($C,A7),A7		;4665a: 4fef000c
	BRA.S	LAB_466B4		;4665e: 6054
LAB_46660:
	CMPI.W	#$0006,(-40,A5)		;46660: 0c6d0006ffd8
	BNE.S	LAB_466B4		;46666: 664c
	PEA	(LAB_5294A,A4)		;46668: 486c955c
	MOVE.W	(LAB_52946,A4),D0	;4666c: 302c9558
	ADD.W	#$002e,D0		;46670: d07c002e
	MOVE.W	D0,-(A7)		;46674: 3f00
	MOVE.W	(LAB_52944,A4),D0	;46676: 302c9556
	ADD.W	#$0020,D0		;4667a: d07c0020
	MOVE.W	D0,-(A7)		;4667e: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;46680: 2f2c99ec
	JSR	(___text,A4)		;46684: 4eac813a
	LEA	($C,A7),A7		;46688: 4fef000c
	MOVE.W	#$0001,(-44,A5)		;4668c: 3b7c0001ffd4
	MOVE.W	(_land_checksum,A4),-(A7) ;46692: 3f2c3082
	PEA	(-37,A5)		;46696: 486dffdb
	JSR	(___word_asc,A4)	;4669a: 4eac818e
	ADDQ.W	#6,A7			;4669e: 5c4f
	PEA	(-37,A5)		;466a0: 486dffdb
	CLR.W	-(A7)			;466a4: 4267
	CLR.W	-(A7)			;466a6: 4267
	MOVE.L	(_d_screen,A4),-(A7)	;466a8: 2f2c99ec
	JSR	(___text,A4)		;466ac: 4eac813a
	LEA	($C,A7),A7		;466b0: 4fef000c
LAB_466B4:
	MOVE.W	(LAB_52608,A4),D0	;466b4: 302c921a
	ADD.W	#$0078,D0		;466b8: d07c0078
	MOVE.W	D0,(-4,A5)		;466bc: 3b40fffc
	MOVE.W	(_baud_rate,A4),-(A7)	;466c0: 3f2c83b8
	PEA	(-37,A5)		;466c4: 486dffdb
	JSR	(___word_asc,A4)	;466c8: 4eac818e
	ADDQ.W	#6,A7			;466cc: 5c4f
	TST.W	(_use_modem,A4)		;466ce: 4a6c3084
	BEQ.S	LAB_46724		;466d2: 6750
	PEA	(_blank_box,A4)		;466d4: 486c91d7
	JSR	(___strlen,A4)		;466d8: 4eac81a6
	ADDQ.W	#4,A7			;466dc: 584f
	SUB.W	#$0011,D0		;466de: 907c0011
	EXT.L	D0			;466e2: 48c0
	LEA	(_blank_box,A4),A0	;466e4: 41ec91d7
	ADD.L	A0,D0			;466e8: d088
	MOVE.L	D0,-(A7)		;466ea: 2f00
	MOVE.W	(LAB_5260A,A4),D0	;466ec: 302c921c
	ADD.W	#$002e,D0		;466f0: d07c002e
	MOVE.W	D0,-(A7)		;466f4: 3f00
	MOVE.W	(-4,A5),-(A7)		;466f6: 3f2dfffc
	MOVE.L	(_d_screen,A4),-(A7)	;466fa: 2f2c99ec
	JSR	(___text,A4)		;466fe: 4eac813a
	LEA	($C,A7),A7		;46702: 4fef000c
	PEA	(_login,A4)		;46706: 486c3086
	MOVE.W	(LAB_5260A,A4),D0	;4670a: 302c921c
	ADD.W	#$002e,D0		;4670e: d07c002e
	MOVE.W	D0,-(A7)		;46712: 3f00
	MOVE.W	(-4,A5),-(A7)		;46714: 3f2dfffc
	MOVE.L	(_d_screen,A4),-(A7)	;46718: 2f2c99ec
	JSR	(___text,A4)		;4671c: 4eac813a
	LEA	($C,A7),A7		;46720: 4fef000c
LAB_46724:
	PEA	(_blank_box,A4)		;46724: 486c91d7
	JSR	(___strlen,A4)		;46728: 4eac81a6
	ADDQ.W	#4,A7			;4672c: 584f
	SUBQ.W	#6,D0			;4672e: 5d40
	EXT.L	D0			;46730: 48c0
	LEA	(_blank_box,A4),A0	;46732: 41ec91d7
	ADD.L	A0,D0			;46736: d088
	MOVE.L	D0,-(A7)		;46738: 2f00
	MOVE.W	(LAB_52638,A4),D0	;4673a: 302c924a
	ADD.W	#$002e,D0		;4673e: d07c002e
	MOVE.W	D0,-(A7)		;46742: 3f00
	MOVE.W	(-4,A5),-(A7)		;46744: 3f2dfffc
	MOVE.L	(_d_screen,A4),-(A7)	;46748: 2f2c99ec
	JSR	(___text,A4)		;4674c: 4eac813a
	LEA	($C,A7),A7		;46750: 4fef000c
	PEA	(-37,A5)		;46754: 486dffdb
	MOVE.W	(LAB_52638,A4),D0	;46758: 302c924a
	ADD.W	#$002e,D0		;4675c: d07c002e
	MOVE.W	D0,-(A7)		;46760: 3f00
	MOVE.W	(-4,A5),-(A7)		;46762: 3f2dfffc
	MOVE.L	(_d_screen,A4),-(A7)	;46766: 2f2c99ec
	JSR	(___text,A4)		;4676a: 4eac813a
	LEA	($C,A7),A7		;4676e: 4fef000c
	BRA.S	LAB_46798		;46772: 6024
LAB_46774:
	PEA	(_blank,A4)		;46774: 486c91ba
	MOVE.W	(LAB_528BC,A4),D0	;46778: 302c94ce
	ADD.W	#$002e,D0		;4677c: d07c002e
	MOVE.W	D0,-(A7)		;46780: 3f00
	MOVE.W	(LAB_528BA,A4),D0	;46782: 302c94cc
	ADD.W	#$0020,D0		;46786: d07c0020
	MOVE.W	D0,-(A7)		;4678a: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;4678c: 2f2c99ec
	JSR	(___text,A4)		;46790: 4eac813a
	LEA	($C,A7),A7		;46794: 4fef000c
LAB_46798:
	CLR.W	(-2,A5)			;46798: 426dfffe
LAB_4679C:
	TST.W	(_use_modem,A4)		;4679c: 4a6c3084
	BNE.S	LAB_467B6		;467a0: 6614
	CMPI.W	#$0001,(-2,A5)		;467a2: 0c6d0001fffe
	BEQ.W	LAB_46874		;467a8: 670000ca
	CMPI.W	#$0004,(-2,A5)		;467ac: 0c6d0004fffe
	BEQ.W	LAB_46874		;467b2: 670000c0
LAB_467B6:
	CMPI.W	#$0003,(-2,A5)		;467b6: 0c6d0003fffe
	BNE.S	LAB_467D0		;467bc: 6612
	MOVE.W	(_use_modem,A4),D0	;467be: 302c3084
	MULU	#$0005,D0		;467c2: c0fc0005
	ADD.W	(-2,A5),D0		;467c6: d06dfffe
	MOVE.W	D0,(-4,A5)		;467ca: 3b40fffc
	BRA.S	LAB_4682C		;467ce: 605c
LAB_467D0:
	CMPI.W	#$0004,(-2,A5)		;467d0: 0c6d0004fffe
	BNE.S	LAB_467EA		;467d6: 6612
	MOVE.W	(_quick_io,A4),D0	;467d8: 302c3056
	MULS	#$0005,D0		;467dc: c1fc0005
	ADD.W	(-2,A5),D0		;467e0: d06dfffe
	MOVE.W	D0,(-4,A5)		;467e4: 3b40fffc
	BRA.S	LAB_4682C		;467e8: 6042
LAB_467EA:
	CMPI.W	#$0005,(-2,A5)		;467ea: 0c6d0005fffe
	BNE.S	LAB_46804		;467f0: 6612
	MOVE.W	(-42,A5),D0		;467f2: 302dffd6
	MULS	#$0005,D0		;467f6: c1fc0005
	ADD.W	(-2,A5),D0		;467fa: d06dfffe
	MOVE.W	D0,(-4,A5)		;467fe: 3b40fffc
	BRA.S	LAB_4682C		;46802: 6028
LAB_46804:
	CMPI.W	#$0006,(-2,A5)		;46804: 0c6d0006fffe
	BNE.S	LAB_46826		;4680a: 661a
	TST.W	(-44,A5)		;4680c: 4a6dffd4
	BNE.S	LAB_46816		;46810: 6604
	MOVEQ	#1,D0			;46812: 7001
	BRA.S	LAB_46818		;46814: 6002
LAB_46816:
	MOVEQ	#0,D0			;46816: 7000
LAB_46818:
	MULS	#$0005,D0		;46818: c1fc0005
	ADD.W	(-2,A5),D0		;4681c: d06dfffe
	MOVE.W	D0,(-4,A5)		;46820: 3b40fffc
	BRA.S	LAB_4682C		;46824: 6006
LAB_46826:
	MOVE.W	(-2,A5),(-4,A5)		;46826: 3b6dfffefffc
LAB_4682C:
	MOVE.W	(-4,A5),D0		;4682c: 302dfffc
	MULS	#$002e,D0		;46830: c1fc002e
	LEA	(LAB_525E0,A4),A0	;46834: 41ec91f2
	ADD.L	A0,D0			;46838: d088
	MOVE.L	D0,-(A7)		;4683a: 2f00
	MOVE.W	(-4,A5),D0		;4683c: 302dfffc
	MULS	#$002e,D0		;46840: c1fc002e
	LEA	(LAB_525DC,A4),A0	;46844: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;46848: 32300800
	ADD.W	#$002e,D1		;4684c: d27c002e
	MOVE.W	D1,-(A7)		;46850: 3f01
	MOVE.W	(-4,A5),D0		;46852: 302dfffc
	MULS	#$002e,D0		;46856: c1fc002e
	LEA	(_serial_text,A4),A0	;4685a: 41ec91ec
	MOVE.W	(0,A0,D0.L),D1		;4685e: 32300800
	ADD.W	#$0020,D1		;46862: d27c0020
	MOVE.W	D1,-(A7)		;46866: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;46868: 2f2c99ec
	JSR	(___text,A4)		;4686c: 4eac813a
	LEA	($C,A7),A7		;46870: 4fef000c
LAB_46874:
	ADDQ.W	#1,(-2,A5)		;46874: 526dfffe
	CMPI.W	#$0008,(-2,A5)		;46878: 0c6d0008fffe
	BLT.W	LAB_4679C		;4687e: 6d00ff1c
	CLR.W	(-40,A5)		;46882: 426dffd8
	MOVE.W	#$0002,(_left_button,A4) ;46886: 397c0002ae62
LAB_4688C:
	TST.W	(_left_button,A4)	;4688c: 4a6cae62
	BEQ.S	LAB_46894		;46890: 6702
	BRA.S	LAB_4688C		;46892: 60f8
LAB_46894:
	MOVE.W	#$0001,(-2,A5)		;46894: 3b7c0001fffe
LAB_4689A:
	MOVE.W	(-2,A5),D0		;4689a: 302dfffe
	MULS	#$002e,D0		;4689e: c1fc002e
	LEA	(_serial_text,A4),A0	;468a2: 41ec91ec
	MOVE.W	(0,A0,D0.L),D1		;468a6: 32300800
	ADD.W	#$0020,D1		;468aa: d27c0020
	MOVE.W	(_mousex,A4),D0		;468ae: 302c99aa
	CMP.W	D1,D0			;468b2: b041
	BLT.S	LAB_4691A		;468b4: 6d64
	MOVE.W	(-2,A5),D0		;468b6: 302dfffe
	MULS	#$002e,D0		;468ba: c1fc002e
	LEA	(_serial_text,A4),A0	;468be: 41ec91ec
	MOVE.W	(-2,A5),D1		;468c2: 322dfffe
	MULS	#$002e,D1		;468c6: c3fc002e
	LEA	(LAB_525DE,A4),A1	;468ca: 43ec91f0
	MOVE.W	(0,A0,D0.L),D2		;468ce: 34300800
	ADD.W	(0,A1,D1.L),D2		;468d2: d4711800
	ADD.W	#$0020,D2		;468d6: d47c0020
	MOVE.W	(_mousex,A4),D0		;468da: 302c99aa
	CMP.W	D2,D0			;468de: b042
	BGT.S	LAB_4691A		;468e0: 6e38
	MOVE.W	(-2,A5),D0		;468e2: 302dfffe
	MULS	#$002e,D0		;468e6: c1fc002e
	LEA	(LAB_525DC,A4),A0	;468ea: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;468ee: 32300800
	ADD.W	#$002e,D1		;468f2: d27c002e
	MOVE.W	(_mousey,A4),D0		;468f6: 302cae6e
	CMP.W	D1,D0			;468fa: b041
	BLT.S	LAB_4691A		;468fc: 6d1c
	MOVE.W	(-2,A5),D0		;468fe: 302dfffe
	MULS	#$002e,D0		;46902: c1fc002e
	LEA	(LAB_525DC,A4),A0	;46906: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;4690a: 32300800
	ADD.W	#$0036,D1		;4690e: d27c0036
	MOVE.W	(_mousey,A4),D0		;46912: 302cae6e
	CMP.W	D1,D0			;46916: b041
	BLE.S	LAB_46928		;46918: 6f0e
LAB_4691A:
	ADDQ.W	#1,(-2,A5)		;4691a: 526dfffe
	CMPI.W	#$0008,(-2,A5)		;4691e: 0c6d0008fffe
	BLT.W	LAB_4689A		;46924: 6d00ff74
LAB_46928:
	MOVE.W	(LAB_52608,A4),D0	;46928: 302c921a
	ADD.W	#$0078,D0		;4692c: d07c0078
	MOVE.W	D0,(-4,A5)		;46930: 3b40fffc
	MOVE.W	(-2,A5),D0		;46934: 302dfffe
	EXT.L	D0			;46938: 48c0
	BRA.W	LAB_46BF4		;4693a: 600002b8
LAB_4693E:
	TST.W	(_use_modem,A4)		;4693e: 4a6c3084
	BEQ.W	LAB_469D8		;46942: 67000094
	CLR.L	-(A7)			;46946: 42a7
	MOVE.L	(-48,A5),-(A7)		;46948: 2f2dffd0
	MOVE.W	#$0011,-(A7)		;4694c: 3f3c0011
	MOVE.W	(-2,A5),D0		;46950: 302dfffe
	MULS	#$002e,D0		;46954: c1fc002e
	LEA	(LAB_525DC,A4),A0	;46958: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;4695c: 32300800
	ADD.W	#$002e,D1		;46960: d27c002e
	MOVE.W	D1,-(A7)		;46964: 3f01
	MOVE.W	(-4,A5),-(A7)		;46966: 3f2dfffc
	PEA	(_login,A4)		;4696a: 486c3086
	MOVE.L	(_d_screen,A4),-(A7)	;4696e: 2f2c99ec
	JSR	(_get_name,PC)		;46972: 4ebaef5c
	LEA	($16,A7),A7		;46976: 4fef0016
	TST.B	(_login,A4)		;4697a: 4a2c3086
	BEQ.S	LAB_469D8		;4697e: 6758
	CLR.W	(-4,A5)			;46980: 426dfffc
	BRA.S	LAB_469AE		;46984: 6028
LAB_46986:
	JSR	(_waittof,PC)		;46986: 4eba621a
	CLR.L	-(A7)			;4698a: 42a7
	MOVE.W	#$0001,-(A7)		;4698c: 3f3c0001
	MOVE.W	(-4,A5),D0		;46990: 302dfffc
	EXT.L	D0			;46994: 48c0
	LEA	(_login,A4),A0		;46996: 41ec3086
	ADD.L	A0,D0			;4699a: d088
	MOVE.L	D0,-(A7)		;4699c: 2f00
	JSR	(_write_serial,PC)	;4699e: 4eba6632
	LEA	($A,A7),A7		;469a2: 4fef000a
	JSR	(_waittof,PC)		;469a6: 4eba61fa
	ADDQ.W	#1,(-4,A5)		;469aa: 526dfffc
LAB_469AE:
	MOVE.W	(-4,A5),D0		;469ae: 302dfffc
	LEA	(_login,A4),A0		;469b2: 41ec3086
	TST.B	(0,A0,D0.W)		;469b6: 4a300000
	BNE.S	LAB_46986		;469ba: 66ca
	MOVE.W	#$004b,-(A7)		;469bc: 3f3c004b
	JSR	(_waitfor,PC)		;469c0: 4eba2a28
	ADDQ.W	#2,A7			;469c4: 544f
	CLR.L	-(A7)			;469c6: 42a7
	MOVE.W	#$0001,-(A7)		;469c8: 3f3c0001
	PEA	(LAB_46C89,PC)		;469cc: 487a02bb
	JSR	(_write_serial,PC)	;469d0: 4eba6600
	LEA	($A,A7),A7		;469d4: 4fef000a
LAB_469D8:
	BRA.W	LAB_46C06		;469d8: 6000022c
LAB_469DC:
	CLR.L	-(A7)			;469dc: 42a7
	MOVE.L	(-48,A5),-(A7)		;469de: 2f2dffd0
	MOVE.W	#$0006,-(A7)		;469e2: 3f3c0006
	MOVE.W	(-2,A5),D0		;469e6: 302dfffe
	MULS	#$002e,D0		;469ea: c1fc002e
	LEA	(LAB_525DC,A4),A0	;469ee: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;469f2: 32300800
	ADD.W	#$002e,D1		;469f6: d27c002e
	MOVE.W	D1,-(A7)		;469fa: 3f01
	MOVE.W	(-4,A5),-(A7)		;469fc: 3f2dfffc
	PEA	(-37,A5)		;46a00: 486dffdb
	MOVE.L	(_d_screen,A4),-(A7)	;46a04: 2f2c99ec
	JSR	(_get_name,PC)		;46a08: 4ebaeec6
	LEA	($16,A7),A7		;46a0c: 4fef0016
	TST.B	(-37,A5)		;46a10: 4a2dffdb
	BEQ.S	LAB_46A62		;46a14: 674c
	PEA	(-37,A5)		;46a16: 486dffdb
	JSR	(___atoi,A4)		;46a1a: 4eac81ac
	ADDQ.W	#4,A7			;46a1e: 584f
	MOVE.W	D0,(_baud_rate,A4)	;46a20: 394083b8
	CLR.W	(-4,A5)			;46a24: 426dfffc
	BRA.S	LAB_46A2E		;46a28: 6004
LAB_46A2A:
	ADDQ.W	#1,(-4,A5)		;46a2a: 526dfffc
LAB_46A2E:
	CMPI.W	#$0010,(-4,A5)		;46a2e: 0c6d0010fffc
	BGE.S	LAB_46A4C		;46a34: 6c16
	MOVE.W	(-4,A5),D0		;46a36: 302dfffc
	EXT.L	D0			;46a3a: 48c0
	ASL.L	#1,D0			;46a3c: e380
	LEA	(_b_rates,A4),A0	;46a3e: 41ec8260
	MOVE.W	(_baud_rate,A4),D1	;46a42: 322c83b8
	CMP.W	(0,A0,D0.L),D1		;46a46: b2700800
	BLT.S	LAB_46A2A		;46a4a: 6dde
LAB_46A4C:
	MOVE.W	(-4,A5),D0		;46a4c: 302dfffc
	EXT.L	D0			;46a50: 48c0
	ASL.L	#1,D0			;46a52: e380
	LEA	(_b_rates,A4),A0	;46a54: 41ec8260
	MOVE.W	(0,A0,D0.L),(_baud_rate,A4) ;46a58: 3970080083b8
	JSR	(_set_baud_rate,PC)	;46a5e: 4eba3d90
LAB_46A62:
	BRA.W	LAB_46C06		;46a62: 600001a2
LAB_46A66:
	TST.W	(_use_modem,A4)		;46a66: 4a6c3084
	BNE.S	LAB_46A74		;46a6a: 6608
	MOVE.W	#$0001,(_use_modem,A4)	;46a6c: 397c00013084
	BRA.S	LAB_46A78		;46a72: 6004
LAB_46A74:
	CLR.W	(_use_modem,A4)		;46a74: 426c3084
LAB_46A78:
	MOVE.W	#$0001,(-40,A5)		;46a78: 3b7c0001ffd8
	BRA.W	LAB_46C06		;46a7e: 60000186
LAB_46A82:
	TST.W	(_use_modem,A4)		;46a82: 4a6c3084
	BEQ.S	LAB_46A9A		;46a86: 6712
	TST.W	(_quick_io,A4)		;46a88: 4a6c3056
	BNE.S	LAB_46A96		;46a8c: 6608
	MOVE.W	#$0001,(_quick_io,A4)	;46a8e: 397c00013056
	BRA.S	LAB_46A9A		;46a94: 6004
LAB_46A96:
	CLR.W	(_quick_io,A4)		;46a96: 426c3056
LAB_46A9A:
	BRA.W	LAB_46C06		;46a9a: 6000016a
LAB_46A9E:
	TST.W	(-42,A5)		;46a9e: 4a6dffd6
	BNE.S	LAB_46AAC		;46aa2: 6608
	MOVE.W	#$0001,(-42,A5)		;46aa4: 3b7c0001ffd6
	BRA.S	LAB_46AB0		;46aaa: 6004
LAB_46AAC:
	CLR.W	(-42,A5)		;46aac: 426dffd6
LAB_46AB0:
	BRA.W	LAB_46C06		;46ab0: 60000154
LAB_46AB4:
	TST.W	(-44,A5)		;46ab4: 4a6dffd4
	BEQ.S	LAB_46AF8		;46ab8: 673e
	CLR.W	-(A7)			;46aba: 4267
	JSR	(_save_load,PC)		;46abc: 4ebaf05a
	ADDQ.W	#2,A7			;46ac0: 544f
	TST.W	D0			;46ac2: 4a40
	BEQ.S	LAB_46AF0		;46ac4: 672a
	MOVE.W	(_player,A4),(-4,A5)	;46ac6: 3b6c99f4fffc
	MOVE.W	(-42,A5),(_player,A4)	;46acc: 396dffd699f4
	CLR.W	(-44,A5)		;46ad2: 426dffd4
	MOVE.W	#$ffff,-(A7)		;46ad6: 3f3cffff
	MOVE.L	(_d_screen,A4),-(A7)	;46ada: 2f2c99ec
	MOVE.L	(_w_screen,A4),-(A7)	;46ade: 2f2c99e8
	JSR	(___Setscreen,A4)	;46ae2: 4eac80c2
	LEA	($A,A7),A7		;46ae6: 4fef000a
	MOVE.W	(-4,A5),(_player,A4)	;46aea: 396dfffc99f4
LAB_46AF0:
	MOVE.W	#$0001,(-40,A5)		;46af0: 3b7c0001ffd8
	BRA.S	LAB_46AFE		;46af6: 6006
LAB_46AF8:
	MOVE.W	#$0001,(-44,A5)		;46af8: 3b7c0001ffd4
LAB_46AFE:
	BRA.W	LAB_46C06		;46afe: 60000106
LAB_46B02:
	MOVE.W	(-44,A5),-(A7)		;46b02: 3f2dffd4
	MOVE.W	(-42,A5),-(A7)		;46b06: 3f2dffd6
	JSR	(_try_serial,PC)	;46b0a: 4eba0180
	ADDQ.W	#4,A7			;46b0e: 584f
	MOVE.W	D0,(-40,A5)		;46b10: 3b40ffd8
	CMP.W	#$0001,D0		;46b14: b07c0001
	BNE.W	LAB_46BE0		;46b18: 660000c6
	TST.W	(-44,A5)		;46b1c: 4a6dffd4
	BNE.S	LAB_46B3E		;46b20: 661c
	MOVE.W	#$ffff,-(A7)		;46b22: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;46b26: 3f3cffff
	JSR	(___set_tend_icons,A4)	;46b2a: 4eac802c
	ADDQ.W	#4,A7			;46b2e: 584f
	MOVE.W	#$ffff,-(A7)		;46b30: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;46b34: 3f3cffff
	JSR	(___set_mode_icons,A4)	;46b38: 4eac8032
	ADDQ.W	#4,A7			;46b3c: 584f
LAB_46B3E:
	MOVE.W	(-42,A5),(_player,A4)	;46b3e: 396dffd699f4
	TST.W	(_player,A4)		;46b44: 4a6c99f4
	BNE.S	LAB_46B52		;46b48: 6608
	MOVE.W	#$0001,(_not_player,A4)	;46b4a: 397c0001825a
	BRA.S	LAB_46B56		;46b50: 6004
LAB_46B52:
	CLR.W	(_not_player,A4)	;46b52: 426c825a
LAB_46B56:
	TST.W	(8,A5)			;46b56: 4a6d0008
	BEQ.S	LAB_46B62		;46b5a: 6706
	TST.W	(-44,A5)		;46b5c: 4a6dffd4
	BEQ.S	LAB_46B6C		;46b60: 670a
LAB_46B62:
	MOVE.W	(_start_seed,A4),(_seed,A4) ;46b62: 396c99e499e2
	CLR.W	(_game_turn,A4)		;46b68: 426cae6a
LAB_46B6C:
	CLR.W	(_serial_off,A4)	;46b6c: 426c8254
	TST.W	(_pause,A4)		;46b70: 4a6c9c22
	BEQ.S	LAB_46B8E		;46b74: 6718
	MOVE.W	#$17e4,-(A7)		;46b76: 3f3c17e4
	MOVE.W	#$0003,-(A7)		;46b7a: 3f3c0003
	MOVE.W	#$0001,-(A7)		;46b7e: 3f3c0001
	MOVE.L	(_back_scr,A4),-(A7)	;46b82: 2f2c9874
	JSR	(___toggle_icon,A4)	;46b86: 4eac8122
	LEA	($A,A7),A7		;46b8a: 4fef000a
LAB_46B8E:
	CLR.W	(_pause,A4)		;46b8e: 426c9c22
	CLR.W	(_toggle,A4)		;46b92: 426c9a1a
	CLR.W	(LAB_516D8,A4)		;46b96: 426c82ea
	CLR.W	(LAB_516AA,A4)		;46b9a: 426c82bc
	TST.W	(-44,A5)		;46b9e: 4a6dffd4
	BEQ.S	LAB_46BB8		;46ba2: 6714
	TST.W	(8,A5)			;46ba4: 4a6d0008
	BNE.S	LAB_46BB8		;46ba8: 660e
	MOVE.W	#$fffe,-(A7)		;46baa: 3f3cfffe
	CLR.W	-(A7)			;46bae: 4267
	JSR	(___setup_display,A4)	;46bb0: 4eac801a
	ADDQ.W	#4,A7			;46bb4: 584f
	BRA.S	LAB_46BDA		;46bb6: 6022
LAB_46BB8:
	TST.W	(-44,A5)		;46bb8: 4a6dffd4
	BNE.S	LAB_46BDA		;46bbc: 661c
	MOVE.W	#$ffff,-(A7)		;46bbe: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;46bc2: 3f3cffff
	JSR	(___set_tend_icons,A4)	;46bc6: 4eac802c
	ADDQ.W	#4,A7			;46bca: 584f
	MOVE.W	#$ffff,-(A7)		;46bcc: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;46bd0: 3f3cffff
	JSR	(___set_mode_icons,A4)	;46bd4: 4eac8032
	ADDQ.W	#4,A7			;46bd8: 584f
LAB_46BDA:
	MOVEQ	#1,D0			;46bda: 7001
LAB_46BDC:
	UNLK	A5			;46bdc: 4e5d
	RTS				;46bde: 4e75
LAB_46BE0:
	BRA.S	LAB_46C06		;46be0: 6024
LAB_46BE2:
	BRA.S	LAB_46C06		;46be2: 6022
LAB_46BE4:
	DC.W	(LAB_46BE2)-(LAB_46C02+2) ;46be4: ffde
	DC.W	(LAB_4693E)-(LAB_46C02+2) ;46be6: fd3a
	DC.W	(LAB_469DC)-(LAB_46C02+2) ;46be8: fdd8
	DC.W	(LAB_46A66)-(LAB_46C02+2) ;46bea: fe62
	DC.W	(LAB_46A82)-(LAB_46C02+2) ;46bec: fe7e
	DC.W	(LAB_46A9E)-(LAB_46C02+2) ;46bee: fe9a
	DC.W	(LAB_46AB4)-(LAB_46C02+2) ;46bf0: feb0
	DC.W	(LAB_46B02)-(LAB_46C02+2) ;46bf2: fefe
LAB_46BF4:
	CMP.L	#$00000008,D0		;46bf4: b0bc00000008
	BCC.S	LAB_46BE2		;46bfa: 64e6
	ASL.L	#1,D0			;46bfc: e380
	MOVE.W	(LAB_46BE4,PC,D0.W),D0	;46bfe: 303b00e4
LAB_46C02:
	JMP	(LAB_46C02+2,PC,D0.W)	;46c02: 4efb0000
LAB_46C06:
	CMPI.W	#$0003,(-2,A5)		;46c06: 0c6d0003fffe
	BLT.S	LAB_46C52		;46c0c: 6d44
	CMPI.W	#$0006,(-2,A5)		;46c0e: 0c6d0006fffe
	BGT.S	LAB_46C52		;46c14: 6e3c
	PEA	(_blank,A4)		;46c16: 486c91ba
	MOVE.W	(-2,A5),D0		;46c1a: 302dfffe
	MULS	#$002e,D0		;46c1e: c1fc002e
	LEA	(LAB_525DC,A4),A0	;46c22: 41ec91ee
	MOVE.W	(0,A0,D0.L),D1		;46c26: 32300800
	ADD.W	#$002e,D1		;46c2a: d27c002e
	MOVE.W	D1,-(A7)		;46c2e: 3f01
	MOVE.W	(-2,A5),D0		;46c30: 302dfffe
	MULS	#$002e,D0		;46c34: c1fc002e
	LEA	(_serial_text,A4),A0	;46c38: 41ec91ec
	MOVE.W	(0,A0,D0.L),D1		;46c3c: 32300800
	ADD.W	#$0020,D1		;46c40: d27c0020
	MOVE.W	D1,-(A7)		;46c44: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;46c46: 2f2c99ec
	JSR	(___text,A4)		;46c4a: 4eac813a
	LEA	($C,A7),A7		;46c4e: 4fef000c
LAB_46C52:
	CLR.L	-(A7)			;46c52: 42a7
	MOVE.L	(-48,A5),-(A7)		;46c54: 2f2dffd0
	JSR	(_check_cancel,PC)	;46c58: 4eba02f6
	ADDQ.W	#8,A7			;46c5c: 504f
	MOVE.W	D0,(-2,A5)		;46c5e: 3b40fffe
	BEQ.S	LAB_46C76		;46c62: 6712
	CMPI.W	#$0001,(-2,A5)		;46c64: 0c6d0001fffe
	BNE.S	LAB_46C74		;46c6a: 6608
	TST.W	(8,A5)			;46c6c: 4a6d0008
	BNE.W	LAB_46B02		;46c70: 6600fe90
LAB_46C74:
	BRA.S	LAB_46C7A		;46c74: 6004
LAB_46C76:
	BRA.W	LAB_464E8		;46c76: 6000f870
LAB_46C7A:
	MOVEQ	#0,D0			;46c7a: 7000
	BRA.W	LAB_46BDC		;46c7c: 6000ff5e
LAB_46C80:
	;46c80
	;DC.B	$43,$4f,$4e,$54,$49,$4e,$55,$45,$00
	DC.B	"CONTINUE",0
LAB_46C89:
	DC.B	$0d			;46c89
	DS.W	1			;46c8a
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_try_serial:
	LINK.W	A5,#-78			;46c8c: 4e55ffb2
	MOVE.W	#$0001,(-76,A5)		;46c90: 3b7c0001ffb4
	MOVE.W	(8,A5),(-30,A5)		;46c96: 3b6d0008ffe2
	MOVE.W	(_start_seed,A4),(-28,A5) ;46c9c: 3b6c99e4ffe4
	MOVE.W	(_game_mode,A4),(-26,A5) ;46ca2: 3b6c84b8ffe6
	MOVE.W	(8,A5),D0		;46ca8: 302d0008
	MULS	#$002e,D0		;46cac: c1fc002e
	LEA	(LAB_516B0,A4),A0	;46cb0: 41ec82c2
	MOVE.W	(0,A0,D0.L),(-24,A5)	;46cb4: 3b700800ffe8
	MOVE.W	(8,A5),D0		;46cba: 302d0008
	MULS	#$002e,D0		;46cbe: c1fc002e
	LEA	(LAB_516B2,A4),A0	;46cc2: 41ec82c4
	MOVE.W	(0,A0,D0.L),(-22,A5)	;46cc6: 3b700800ffea
	MOVE.W	(8,A5),D0		;46ccc: 302d0008
	MULS	#$002e,D0		;46cd0: c1fc002e
	LEA	(LAB_516B4,A4),A0	;46cd4: 41ec82c6
	MOVE.W	(0,A0,D0.L),(-20,A5)	;46cd8: 3b700800ffec
	MOVE.W	($A,A5),(-18,A5)	;46cde: 3b6d000affee
	MOVE.W	(_ground_in,A4),(-16,A5) ;46ce4: 3b6c99e6fff0
	MOVE.W	(_paint_map,A4),(-14,A5) ;46cea: 3b6c9c24fff2
	MOVE.W	(_quick_io,A4),(-12,A5)	;46cf0: 3b6c3056fff4
	MOVE.W	(_land_checksum,A4),(-10,A5) ;46cf6: 3b6c3082fff6
	CLR.L	-(A7)			;46cfc: 42a7
	PEA	(_end_cancel,A4)	;46cfe: 486c84f4
	MOVE.W	#$0040,-(A7)		;46d02: 3f3c0040
	MOVE.W	#$00e4,-(A7)		;46d06: 3f3c00e4
	MOVE.W	#$0046,-(A7)		;46d0a: 3f3c0046
	MOVE.W	#$0030,-(A7)		;46d0e: 3f3c0030
	MOVE.L	(_d_screen,A4),-(A7)	;46d12: 2f2c99ec
	JSR	(_requester,PC)		;46d16: 4ebae76c
	LEA	($14,A7),A7		;46d1a: 4fef0014
	PEA	(LAB_46F30,PC)		;46d1e: 487a0210
	MOVE.W	#$0058,-(A7)		;46d22: 3f3c0058
	MOVE.W	#$0040,-(A7)		;46d26: 3f3c0040
	MOVE.L	(_d_screen,A4),-(A7)	;46d2a: 2f2c99ec
	JSR	(___text,A4)		;46d2e: 4eac813a
	LEA	($C,A7),A7		;46d32: 4fef000c
	MOVE.W	#$0002,(_left_button,A4) ;46d36: 397c0002ae62
LAB_46D3C:
	MOVE.W	(-76,A5),D0		;46d3c: 302dffb4
	ADDQ.W	#1,(-76,A5)		;46d40: 526dffb4
	MOVE.W	D0,-(A7)		;46d44: 3f00
	PEA	(-72,A5)		;46d46: 486dffb8
	JSR	(___word_asc,A4)	;46d4a: 4eac818e
	ADDQ.W	#6,A7			;46d4e: 5c4f
	CMPI.W	#$7530,(-76,A5)		;46d50: 0c6d7530ffb4
	BLS.S	LAB_46D5E		;46d56: 6306
	MOVE.W	#$0001,(-76,A5)		;46d58: 3b7c0001ffb4
LAB_46D5E:
	PEA	(_blank,A4)		;46d5e: 486c91ba
	JSR	(___strlen,A4)		;46d62: 4eac81a6
	ADDQ.W	#4,A7			;46d66: 584f
	SUB.W	#$000c,D0		;46d68: 907c000c
	EXT.L	D0			;46d6c: 48c0
	LEA	(_blank,A4),A0		;46d6e: 41ec91ba
	ADD.L	A0,D0			;46d72: d088
	MOVE.L	D0,-(A7)		;46d74: 2f00
	MOVE.W	#$0058,-(A7)		;46d76: 3f3c0058
	MOVE.W	#$0098,-(A7)		;46d7a: 3f3c0098
	MOVE.L	(_d_screen,A4),-(A7)	;46d7e: 2f2c99ec
	JSR	(___text,A4)		;46d82: 4eac813a
	LEA	($C,A7),A7		;46d86: 4fef000c
	PEA	(-72,A5)		;46d8a: 486dffb8
	MOVE.W	#$0058,-(A7)		;46d8e: 3f3c0058
	MOVE.W	#$0098,-(A7)		;46d92: 3f3c0098
	MOVE.L	(_d_screen,A4),-(A7)	;46d96: 2f2c99ec
	JSR	(___text,A4)		;46d9a: 4eac813a
	LEA	($C,A7),A7		;46d9e: 4fef000c
	PEA	(_end_cancel,A4)	;46da2: 486c84f4
	MOVE.W	#$0001,-(A7)		;46da6: 3f3c0001
	PEA	(LAB_46F3C,PC)		;46daa: 487a0190
	JSR	(_write_serial,PC)	;46dae: 4eba6222
	LEA	($A,A7),A7		;46db2: 4fef000a
	TST.W	D0			;46db6: 4a40
	BNE.W	LAB_46F20		;46db8: 66000166
	MOVE.W	#$0001,-(A7)		;46dbc: 3f3c0001
	JSR	(_check_serial,PC)	;46dc0: 4eba3a72
	ADDQ.W	#2,A7			;46dc4: 544f
	TST.W	D0			;46dc6: 4a40
	BEQ.S	LAB_46E32		;46dc8: 6768
	PEA	(_end_cancel,A4)	;46dca: 486c84f4
	MOVE.W	#$0001,-(A7)		;46dce: 3f3c0001
	PEA	(-73,A5)		;46dd2: 486dffb7
	JSR	(_read_serial,PC)	;46dd6: 4eba6138
	LEA	($A,A7),A7		;46dda: 4fef000a
	TST.W	D0			;46dde: 4a40
	BNE.W	LAB_46F20		;46de0: 6600013e
	CMPI.B	#$72,(-73,A5)		;46de4: 0c2d0072ffb7
	BNE.S	LAB_46E2A		;46dea: 663e
	PEA	(_end_cancel,A4)	;46dec: 486c84f4
	MOVE.W	#$0001,-(A7)		;46df0: 3f3c0001
	PEA	(LAB_46F3E,PC)		;46df4: 487a0148
	JSR	(_write_serial,PC)	;46df8: 4eba61d8
	LEA	($A,A7),A7		;46dfc: 4fef000a
	TST.W	D0			;46e00: 4a40
	BNE.W	LAB_46F20		;46e02: 6600011c
LAB_46E06:
	PEA	(_end_cancel,A4)	;46e06: 486c84f4
	MOVE.W	#$0001,-(A7)		;46e0a: 3f3c0001
	PEA	(-73,A5)		;46e0e: 486dffb7
	JSR	(_read_serial,PC)	;46e12: 4eba60fc
	LEA	($A,A7),A7		;46e16: 4fef000a
	TST.W	D0			;46e1a: 4a40
	BNE.W	LAB_46F20		;46e1c: 66000102
	CMPI.B	#$7a,(-73,A5)		;46e20: 0c2d007affb7
	BNE.S	LAB_46E06		;46e26: 66de
	BRA.S	LAB_46E36		;46e28: 600c
LAB_46E2A:
	CMPI.B	#$7a,(-73,A5)		;46e2a: 0c2d007affb7
	BEQ.S	LAB_46E36		;46e30: 6704
LAB_46E32:
	BRA.W	LAB_46D3C		;46e32: 6000ff08
LAB_46E36:
	PEA	(_end_cancel,A4)	;46e36: 486c84f4
	MOVE.W	#$0016,-(A7)		;46e3a: 3f3c0016
	PEA	(-30,A5)		;46e3e: 486dffe2
	JSR	(_write_serial,PC)	;46e42: 4eba618e
	LEA	($A,A7),A7		;46e46: 4fef000a
	TST.W	D0			;46e4a: 4a40
	BNE.W	LAB_46F20		;46e4c: 660000d2
	PEA	(_end_cancel,A4)	;46e50: 486c84f4
	MOVE.W	#$0016,-(A7)		;46e54: 3f3c0016
	PEA	(-60,A5)		;46e58: 486dffc4
	JSR	(_read_serial,PC)	;46e5c: 4eba60b2
	LEA	($A,A7),A7		;46e60: 4fef000a
	TST.W	D0			;46e64: 4a40
	BNE.W	LAB_46F20		;46e66: 660000b8
	JSR	(_clear_serial,PC)	;46e6a: 4eba6040
	PEA	(LAB_46F40,PC)		;46e6e: 487a00d0
	MOVE.W	#$0060,-(A7)		;46e72: 3f3c0060
	MOVE.W	#$0040,-(A7)		;46e76: 3f3c0040
	MOVE.L	(_d_screen,A4),-(A7)	;46e7a: 2f2c99ec
	JSR	(___text,A4)		;46e7e: 4eac813a
	LEA	($C,A7),A7		;46e82: 4fef000c
	MOVE.W	(-60,A5),D0		;46e86: 302dffc4
	CMP.W	(-30,A5),D0		;46e8a: b06dffe2
	BNE.S	LAB_46E96		;46e8e: 6606
	MOVEQ	#2,D0			;46e90: 7002
LAB_46E92:
	UNLK	A5			;46e92: 4e5d
	RTS				;46e94: 4e75
LAB_46E96:
	MOVE.W	(-48,A5),D0		;46e96: 302dffd0
	CMP.W	(-18,A5),D0		;46e9a: b06dffee
	BEQ.S	LAB_46EA4		;46e9e: 6704
	MOVEQ	#3,D0			;46ea0: 7003
	BRA.S	LAB_46E92		;46ea2: 60ee
LAB_46EA4:
	MOVE.W	(-42,A5),D0		;46ea4: 302dffd6
	CMP.W	(-12,A5),D0		;46ea8: b06dfff4
	BEQ.S	LAB_46EB2		;46eac: 6704
	MOVEQ	#5,D0			;46eae: 7005
	BRA.S	LAB_46E92		;46eb0: 60e0
LAB_46EB2:
	MOVE.W	(-40,A5),D0		;46eb2: 302dffd8
	CMP.W	(-10,A5),D0		;46eb6: b06dfff6
	BEQ.S	LAB_46EC6		;46eba: 670a
	TST.W	($A,A5)			;46ebc: 4a6d000a
	BNE.S	LAB_46EC6		;46ec0: 6604
	MOVEQ	#6,D0			;46ec2: 7006
	BRA.S	LAB_46E92		;46ec4: 60cc
LAB_46EC6:
	CMPI.W	#$0001,(-60,A5)		;46ec6: 0c6d0001ffc4
	BNE.S	LAB_46F02		;46ecc: 6634
	MOVE.W	(-58,A5),(_start_seed,A4) ;46ece: 396dffc699e4
	MOVE.W	(-56,A5),(_game_mode,A4) ;46ed4: 396dffc884b8
	MOVE.W	(-54,A5),(LAB_516DE,A4)	;46eda: 396dffca82f0
	MOVE.W	(-52,A5),(LAB_516E0,A4)	;46ee0: 396dffcc82f2
	MOVE.W	(-50,A5),(LAB_516E2,A4)	;46ee6: 396dffce82f4
	MOVE.W	(-46,A5),(_ground_in,A4) ;46eec: 396dffd299e6
	MOVE.W	(-44,A5),(_paint_map,A4) ;46ef2: 396dffd49c24
	MOVE.W	(-42,A5),(_quick_io,A4)	;46ef8: 396dffd63056
	MOVEQ	#1,D0			;46efe: 7001
	BRA.S	LAB_46E92		;46f00: 6090
LAB_46F02:
	TST.W	(-60,A5)		;46f02: 4a6dffc4
	BNE.S	LAB_46F20		;46f06: 6618
	MOVE.W	(-54,A5),(LAB_516B0,A4)	;46f08: 396dffca82c2
	MOVE.W	(-52,A5),(LAB_516B2,A4)	;46f0e: 396dffcc82c4
	MOVE.W	(-50,A5),(LAB_516B4,A4)	;46f14: 396dffce82c6
	MOVEQ	#1,D0			;46f1a: 7001
	BRA.W	LAB_46E92		;46f1c: 6000ff74
LAB_46F20:
	JSR	(_clear_serial,PC)	;46f20: 4eba5f8a
	MOVE.W	#$0002,(_left_button,A4) ;46f24: 397c0002ae62
	MOVEQ	#$63,D0			;46f2a: 7063
	BRA.W	LAB_46E92		;46f2c: 6000ff64
LAB_46F30:
	;46f30
	;DC.B	$54,$52,$59,$20,$4e,$55,$4d,$42,$45,$52,$20,$00
	DC.B	"TRY NUMBER ",0
LAB_46F3C:
	DC.W	$7200			;46f3c
LAB_46F3E:
	DC.W	$7a00			;46f3e
LAB_46F40:
	;46f40
	;DC.B	$43,$4f,$4e,$4e,$45,$43,$54,$49,$4f,$4e,$20,$4d,$41,$44,$45,$00
	DC.B	"CONNECTION MADE",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_check_cancel:
	LINK.W	A5,#0			;46f50: 4e550000
	TST.W	(_left_button,A4)	;46f54: 4a6cae62
	BNE.W	LAB_46FEA		;46f58: 66000090
	TST.L	(8,A5)			;46f5c: 4aad0008
	BEQ.S	LAB_46FA4		;46f60: 6742
	MOVEA.L	(8,A5),A0		;46f62: 206d0008
	MOVE.W	(_mousex,A4),D0		;46f66: 302c99aa
	CMP.W	(A0),D0			;46f6a: b050
	BLT.S	LAB_46FA4		;46f6c: 6d36
	MOVEA.L	(8,A5),A0		;46f6e: 206d0008
	MOVE.W	(_mousex,A4),D0		;46f72: 302c99aa
	CMP.W	(4,A0),D0		;46f76: b0680004
	BGT.S	LAB_46FA4		;46f7a: 6e28
	MOVEA.L	(8,A5),A0		;46f7c: 206d0008
	MOVE.W	(_mousey,A4),D0		;46f80: 302cae6e
	CMP.W	(2,A0),D0		;46f84: b0680002
	BLT.S	LAB_46FA4		;46f88: 6d1a
	MOVEA.L	(8,A5),A0		;46f8a: 206d0008
	MOVE.W	(2,A0),D0		;46f8e: 30280002
	ADD.W	#$0010,D0		;46f92: d07c0010
	MOVE.W	(_mousey,A4),D1		;46f96: 322cae6e
	CMP.W	D0,D1			;46f9a: b240
	BGT.S	LAB_46FA4		;46f9c: 6e06
	MOVEQ	#1,D0			;46f9e: 7001
LAB_46FA0:
	UNLK	A5			;46fa0: 4e5d
	RTS				;46fa2: 4e75
LAB_46FA4:
	TST.L	($C,A5)			;46fa4: 4aad000c
	BEQ.S	LAB_46FEA		;46fa8: 6740
	MOVEA.L	($C,A5),A0		;46faa: 206d000c
	MOVE.W	(_mousex,A4),D0		;46fae: 302c99aa
	CMP.W	(A0),D0			;46fb2: b050
	BLT.S	LAB_46FEA		;46fb4: 6d34
	MOVEA.L	($C,A5),A0		;46fb6: 206d000c
	MOVE.W	(_mousex,A4),D0		;46fba: 302c99aa
	CMP.W	(4,A0),D0		;46fbe: b0680004
	BGT.S	LAB_46FEA		;46fc2: 6e26
	MOVEA.L	($C,A5),A0		;46fc4: 206d000c
	MOVE.W	(_mousey,A4),D0		;46fc8: 302cae6e
	CMP.W	(2,A0),D0		;46fcc: b0680002
	BLT.S	LAB_46FEA		;46fd0: 6d18
	MOVEA.L	($C,A5),A0		;46fd2: 206d000c
	MOVE.W	(2,A0),D0		;46fd6: 30280002
	ADD.W	#$0010,D0		;46fda: d07c0010
	MOVE.W	(_mousey,A4),D1		;46fde: 322cae6e
	CMP.W	D0,D1			;46fe2: b240
	BGT.S	LAB_46FEA		;46fe4: 6e04
	MOVEQ	#2,D0			;46fe6: 7002
	BRA.S	LAB_46FA0		;46fe8: 60b6
LAB_46FEA:
	MOVEQ	#0,D0			;46fea: 7000
	BRA.S	LAB_46FA0		;46fec: 60b2
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_put_in_string:
	LINK.W	A5,#0			;46fee: 4e550000
LAB_46FF2:
	TST.W	($10,A5)		;46ff2: 4a6d0010
	BEQ.S	LAB_47006		;46ff6: 670e
	MOVEA.L	(8,A5),A0		;46ff8: 206d0008
	ADDQ.L	#1,(8,A5)		;46ffc: 52ad0008
	SUBQ.W	#1,($10,A5)		;47000: 536d0010
	BRA.S	LAB_46FF2		;47004: 60ec
LAB_47006:
	MOVEA.L	($C,A5),A0		;47006: 206d000c
	TST.B	(A0)			;4700a: 4a10
	BEQ.S	LAB_47022		;4700c: 6714
	MOVEA.L	($C,A5),A0		;4700e: 206d000c
	ADDQ.L	#1,($C,A5)		;47012: 52ad000c
	MOVEA.L	(8,A5),A1		;47016: 226d0008
	ADDQ.L	#1,(8,A5)		;4701a: 52ad0008
	MOVE.B	(A0),(A1)		;4701e: 1290
	BRA.S	LAB_47006		;47020: 60e4
LAB_47022:
	MOVEA.L	(8,A5),A0		;47022: 206d0008
	CLR.B	(A0)			;47026: 4210
	UNLK	A5			;47028: 4e5d
	RTS				;4702a: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_show_world:
	LINK.W	A5,#-118		;4702c: 4e55ff8a
	CLR.W	(-22,A5)		;47030: 426dffea
	PEA	(strStartGame,PC)	;47034: 487a06b0
	PEA	(-66,A5)		;47038: 486dffbe
	JSR	(___strcpy,A4)		;4703c: 4eac81a0
	ADDQ.W	#8,A7			;47040: 504f
	PEA	(strNewGame,PC)		;47042: 487a06ad
	PEA	(-112,A5)		;47046: 486dff90
	JSR	(___strcpy,A4)		;4704a: 4eac81a0
	ADDQ.W	#8,A7			;4704e: 504f
	TST.B	(_message,A4)		;47050: 4a2c3058
	BNE.S	LAB_47064		;47054: 660e
	PEA	(strGENESIS1,PC)	;47056: 487a06a2
	PEA	(_message,A4)		;4705a: 486c3058
	JSR	(___strcpy,A4)		;4705e: 4eac81a0
	ADDQ.W	#8,A7			;47062: 504f
LAB_47064:
	PEA	(-118,A5)		;47064: 486dff8a
	PEA	(-72,A5)		;47068: 486dffb8
	MOVE.W	#$00a0,-(A7)		;4706c: 3f3c00a0
	MOVE.W	#$0120,-(A7)		;47070: 3f3c0120
	MOVE.W	#$0018,-(A7)		;47074: 3f3c0018
	MOVE.W	#$0010,-(A7)		;47078: 3f3c0010
	MOVE.L	(_d_screen,A4),-(A7)	;4707c: 2f2c99ec
	JSR	(_requester,PC)		;47080: 4ebae402
	LEA	($14,A7),A7		;47084: 4fef0014
	PEA	(strWorldToConquer,A4)	;47088: 486c8b02
	MOVE.W	(LAB_51EEC,A4),D0	;4708c: 302c8afe
	ADD.W	#$0018,D0		;47090: d07c0018
	MOVE.W	D0,-(A7)		;47094: 3f00
	MOVE.W	(_c_text,A4),D0		;47096: 302c8afc
	ADD.W	#$0010,D0		;4709a: d07c0010
	MOVE.W	D0,-(A7)		;4709e: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;470a0: 2f2c99ec
	JSR	(___text,A4)		;470a4: 4eac813a
	LEA	($C,A7),A7		;470a8: 4fef000c
LAB_470AC:
	PEA	(LAB_525C8,A4)		;470ac: 486c91da
	MOVE.W	#$002c,-(A7)		;470b0: 3f3c002c
	MOVE.W	#$0020,-(A7)		;470b4: 3f3c0020
	MOVE.L	(_d_screen,A4),-(A7)	;470b8: 2f2c99ec
	JSR	(___text,A4)		;470bc: 4eac813a
	LEA	($C,A7),A7		;470c0: 4fef000c
	PEA	(_message,A4)		;470c4: 486c3058
	MOVE.W	#$002c,-(A7)		;470c8: 3f3c002c
	MOVE.W	#$0020,-(A7)		;470cc: 3f3c0020
	MOVE.L	(_d_screen,A4),-(A7)	;470d0: 2f2c99ec
	JSR	(___text,A4)		;470d4: 4eac813a
	LEA	($C,A7),A7		;470d8: 4fef000c
	TST.W	(-22,A5)		;470dc: 4a6dffea
	BEQ.S	LAB_4712A		;470e0: 6748
	PEA	(-118,A5)		;470e2: 486dff8a
	PEA	(-72,A5)		;470e6: 486dffb8
	MOVE.W	#$0010,-(A7)		;470ea: 3f3c0010
	MOVE.W	#$002c,-(A7)		;470ee: 3f3c002c
	MOVE.W	#$0020,-(A7)		;470f2: 3f3c0020
	PEA	(_message,A4)		;470f6: 486c3058
	MOVE.L	(_d_screen,A4),-(A7)	;470fa: 2f2c99ec
	JSR	(_get_name,PC)		;470fe: 4ebae7d0
	LEA	($16,A7),A7		;47102: 4fef0016
	PEA	(_blank,A4)		;47106: 486c91ba
	MOVE.W	(text_y,A4),D0		;4710a: 302c8b2c
	ADD.W	#$0018,D0		;4710e: d07c0018
	MOVE.W	D0,-(A7)		;47112: 3f00
	MOVE.W	(text_x,A4),D0		;47114: 302c8b2a
	ADD.W	#$0010,D0		;47118: d07c0010
	MOVE.W	D0,-(A7)		;4711c: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;4711e: 2f2c99ec
	JSR	(___text,A4)		;47122: 4eac813a
	LEA	($C,A7),A7		;47126: 4fef000c
LAB_4712A:
	PEA	(_message,A4)		;4712a: 486c3058
	JSR	(___atoi,A4)		;4712e: 4eac81ac
	ADDQ.W	#4,A7			;47132: 584f
	TST.W	D0			;47134: 4a40
	BEQ.S	LAB_47154		;47136: 671c
	PEA	(_message,A4)		;47138: 486c3058
	JSR	(___atoi,A4)		;4713c: 4eac81ac
	ADDQ.W	#4,A7			;47140: 584f
	MOVE.W	D0,(_start_seed,A4)	;47142: 394099e4
	MOVE.W	D0,(_seed,A4)		;47146: 394099e2
	CLR.B	(_message,A4)		;4714a: 422c3058
	MOVEQ	#-1,D0			;4714e: 70ff
return_47150:
	UNLK	A5			;47150: 4e5d
	RTS				;47152: 4e75
LAB_47154:
	TST.B	(_message,A4)		;47154: 4a2c3058
	BEQ.S	LAB_471AA		;47158: 6750
; special case for code = GENESIS
	PEA	(strGENESIS2,PC)	;4715a: 487a05a6
	PEA	(_message,A4)		;4715e: 486c3058
	JSR	(___strcmp,A4)		;47162: 4eac81b2
	ADDQ.W	#8,A7			;47166: 504f
	TST.W	D0			;47168: 4a40
	BNE.S	LAB_47172		;4716a: 6606
; battle number 0
	CLR.W	(-18,A5)		;4716c: 426dffee
	BRA.S	LAB_47180		;47170: 600e
LAB_47172:
	PEA	(_message,A4)		;47172: 486c3058
	JSR	(_decode,PC)		;47176: 4eba1f5c
	ADDQ.W	#4,A7			;4717a: 584f
; battle number x 5
	MOVE.W	D0,(-18,A5)		;4717c: 3b40ffee
LAB_47180:
	TST.W	(-18,A5)		;47180: 4a6dffee
	BGE.S	LAB_471AA		;47184: 6c24
; No such world
	PEA	(strNoSuchWorld,PC)	;47186: 487a0582
	MOVE.W	(text_y,A4),D0		;4718a: 302c8b2c
	ADD.W	#$0018,D0		;4718e: d07c0018
	MOVE.W	D0,-(A7)		;47192: 3f00
	MOVE.W	(text_x,A4),D0		;47194: 302c8b2a
	ADD.W	#$0010,D0		;47198: d07c0010
	MOVE.W	D0,-(A7)		;4719c: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;4719e: 2f2c99ec
	JSR	(___text,A4)		;471a2: 4eac813a
	LEA	($C,A7),A7		;471a6: 4fef000c
LAB_471AA:
	TST.W	(-18,A5)		;471aa: 4a6dffee
	BLT.W	LAB_470AC		;471ae: 6d00fefc
; valid
	MOVE.W	#$0001,(-22,A5)		;471b2: 3b7c0001ffea
	MOVE.W	(-18,A5),D0		;471b8: 302dffee
	EXT.L	D0			;471bc: 48c0
; / 25 (level number / 5)
	DIVS	#$0019,D0		;471be: 81fc0019
	MOVE.W	D0,(-20,A5)		;471c2: 3b40ffec
; ------------------------------------------------------------------------------
; Load level data
; level.dat is a 990 byte file containing 99 10-byte entries
; The game has 99 * 5 = 495 levels
; Valid numbers for each column:
; 0 01 02 03 04 05 06 07 08 09 0a
; 1 01 02 03 04 05 06 07 08 09 0a
; 2 00 01 02 03 04 05 06 07 08 0a 0b 0c 0d 0f 10 12 14 20 22 24 34 38 3a 3e 3f
; 3 00 01 02 04 08 09 0b 0f 12 19 1b 1e 1f 20 22 24 29 2d 2e 2f 30 31 32 33 34
;   35 36 37 38 39 3a 3b 3c 3d 3e 3f
; 4 00 01 03 04 08 0a 10 11 12
; 5 00 01 02 03
; 6 01 02 03 04 05 06 07 0a 0c 14 1e
; 7 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 14 1e
; 8 0019 001e 002d 003c 004b 005a 0069 0082 0091 00a0 00af 00cd 00dc 00eb 00fa
;   0118 0127 0136 0154 0163 0172 0181 0190 019f 01ae 01bd 01cc 01ea 01f9 0208
;   0217 0226 0235 0244 0253 0260 0262 0271 0280 028f 029e 02ad 02bc 02cb 02da
;   03e8 03f7 0401 0406 040b 041a 0429 043d 0442 0451 0a5f 0bb8 0d5f 0db6 118f
;   5fd6 6302 6f97 75bd 7cdf 7e8e
; ------------------------------------------------------------------------------
	PEA	$3ED.W			;471c6: 487803ed
	PEA	(str_level_dat,PC)	;471ca: 487a054c
	JSR	(___Open,A4)		;471ce: 4eac81e2
	ADDQ.W	#8,A7			;471d2: 504f
	MOVE.L	D0,(-26,A5)		;471d4: 2b40ffe6
	TST.L	D0			;471d8: 4a80
	BLE.S	diskerr_47222		;471da: 6f46
	PEA	-1.W			;471dc: 4878ffff
	MOVE.W	(-20,A5),D0		;471e0: 302dffec
	MULU	#$000a,D0		;471e4: c0fc000a
	MOVEQ	#0,D1			;471e8: 7200
	MOVE.W	D0,D1			;471ea: 3200
	MOVE.L	D1,-(A7)		;471ec: 2f01
	MOVE.L	(-26,A5),-(A7)		;471ee: 2f2dffe6
	JSR	(___Seek,A4)		;471f2: 4eac81ee
	LEA	($C,A7),A7		;471f6: 4fef000c
	CMP.L	#$ffffffff,D0		;471fa: b0bcffffffff
	BEQ.S	LAB_47216		;47200: 6714
	PEA	$A.W			;47202: 4878000a
; 10 bytes read to this buffer _conquest
	PEA	(_conquest,A4)		;47206: 486c84bc
	MOVE.L	(-26,A5),-(A7)		;4720a: 2f2dffe6
	JSR	(___Read,A4)		;4720e: 4eac81e8
	LEA	($C,A7),A7		;47212: 4fef000c
LAB_47216:
	MOVE.L	(-26,A5),-(A7)		;47216: 2f2dffe6
	JSR	(___Close,A4)		;4721a: 4eac81d6
	ADDQ.W	#4,A7			;4721e: 584f
	BRA.S	LAB_47236		;47220: 6014
diskerr_47222:
	CLR.W	(-22,A5)		;47222: 426dffea
	CLR.W	-(A7)			;47226: 4267
; insert disk
	MOVE.L	(LAB_51BD8,A4),-(A7)	;47228: 2f2c87ea
	JSR	(_do_message,PC)	;4722c: 4ebaf064
	ADDQ.W	#6,A7			;47230: 5c4f
	BRA.W	LAB_47064		;47232: 6000fe30
LAB_47236:
	MOVE.W	#$0002,(_left_button,A4) ;47236: 397c0002ae62
	MOVE.W	#$0001,(-20,A5)		;4723c: 3b7c0001ffec
LAB_47242:
; loop 1 to 16
	MOVE.W	(-20,A5),D0		;47242: 302dffec
	EXT.L	D0			;47246: 48c0
	BRA.W	LAB_4760C		;47248: 600003c2
; ------------------------------------------------------------------------------
; #1
; ------------------------------------------------------------------------------
line_1:
	MOVE.W	(-18,A5),D0		;4724c: 302dffee
	EXT.L	D0			;47250: 48c0
	DIVS	#$0005,D0		;47252: 81fc0005
	MOVE.W	D0,-(A7)		;47256: 3f00
	PEA	(-10,A5)		;47258: 486dfff6
	JSR	(___word_asc,A4)	;4725c: 4eac818e
	ADDQ.W	#6,A7			;47260: 5c4f
	MOVE.W	(-20,A5),D0		;47262: 302dffec
	MULS	#$002e,D0		;47266: c1fc002e
	LEA	(LAB_51EEE,A4),A0	;4726a: 41ec8b00
	MOVE.W	(0,A0,D0.L),-(A7)	;4726e: 3f300800
	PEA	(-10,A5)		;47272: 486dfff6
	MOVE.W	(-20,A5),D0		;47276: 302dffec
	MULS	#$002e,D0		;4727a: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;4727e: 41ec8b02
	ADD.L	A0,D0			;47282: d088
	MOVE.L	D0,-(A7)		;47284: 2f00
	JSR	(_put_in_string,PC)	;47286: 4ebafd66
	LEA	($A,A7),A7		;4728a: 4fef000a
	BRA.W	LAB_47620		;4728e: 60000390
; ------------------------------------------------------------------------------
; #2
; ------------------------------------------------------------------------------
line_2:
	MOVE.W	(-20,A5),D0		;47292: 302dffec
	MULS	#$002e,D0		;47296: c1fc002e
	LEA	(LAB_51EEE,A4),A0	;4729a: 41ec8b00
	MOVE.W	(0,A0,D0.L),-(A7)	;4729e: 3f300800
	MOVEQ	#0,D0			;472a2: 7000
	MOVE.B	(conq_05_terrain,A4),D0	;472a4: 102c84c1
	ASL.L	#2,D0			;472a8: e580
	LEA	(_con_text,A4),A0	;472aa: 41ec8dae
	MOVE.L	(0,A0,D0.L),-(A7)	;472ae: 2f300800
	MOVE.W	(-20,A5),D0		;472b2: 302dffec
	MULS	#$002e,D0		;472b6: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;472ba: 41ec8b02
	ADD.L	A0,D0			;472be: d088
	MOVE.L	D0,-(A7)		;472c0: 2f00
	JSR	(_put_in_string,PC)	;472c2: 4ebafd2a
	LEA	($A,A7),A7		;472c6: 4fef000a
	BRA.W	LAB_47620		;472ca: 60000354
; ------------------------------------------------------------------------------
; #3
; ------------------------------------------------------------------------------
line_3:
	MOVE.W	(-20,A5),D0		;472ce: 302dffec
	MULS	#$002e,D0		;472d2: c1fc002e
	LEA	(LAB_51EEE,A4),A0	;472d6: 41ec8b00
	MOVE.W	(0,A0,D0.L),-(A7)	;472da: 3f300800
	MOVEQ	#0,D0			;472de: 7000
	MOVE.B	(conq_01_speed,A4),D0	;472e0: 102c84bd
	MOVEQ	#$A,D1			;472e4: 720a
	SUB.W	D0,D1			;472e6: 9240
	LSR.W	#1,D1			;472e8: e249
	ADDQ.W	#4,D1			;472ea: 5841
	MOVEQ	#0,D0			;472ec: 7000
	MOVE.W	D1,D0			;472ee: 3001
	ASL.L	#2,D0			;472f0: e580
	LEA	(_con_text,A4),A0	;472f2: 41ec8dae
	MOVE.L	(0,A0,D0.L),-(A7)	;472f6: 2f300800
	MOVE.W	(-20,A5),D0		;472fa: 302dffec
	MULS	#$002e,D0		;472fe: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;47302: 41ec8b02
	ADD.L	A0,D0			;47306: d088
	MOVE.L	D0,-(A7)		;47308: 2f00
	JSR	(_put_in_string,PC)	;4730a: 4ebafce2
	LEA	($A,A7),A7		;4730e: 4fef000a
	BRA.W	LAB_47620		;47312: 6000030c
; ------------------------------------------------------------------------------
; #4
; ------------------------------------------------------------------------------
line_4:
	MOVE.W	(-20,A5),D0		;47316: 302dffec
	MULS	#$002e,D0		;4731a: c1fc002e
	LEA	(LAB_51EEE,A4),A0	;4731e: 41ec8b00
	MOVE.W	(0,A0,D0.L),-(A7)	;47322: 3f300800
	MOVEQ	#0,D0			;47326: 7000
	MOVE.B	(_conquest,A4),D0	;47328: 102c84bc
	MOVEQ	#$A,D1			;4732c: 720a
	SUB.W	D0,D1			;4732e: 9240
	LSR.W	#1,D1			;47330: e249
	ADD.W	#$0009,D1		;47332: d27c0009
	MOVEQ	#0,D0			;47336: 7000
	MOVE.W	D1,D0			;47338: 3001
	ASL.L	#2,D0			;4733a: e580
	LEA	(_con_text,A4),A0	;4733c: 41ec8dae
	MOVE.L	(0,A0,D0.L),-(A7)	;47340: 2f300800
	MOVE.W	(-20,A5),D0		;47344: 302dffec
	MULS	#$002e,D0		;47348: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;4734c: 41ec8b02
	ADD.L	A0,D0			;47350: d088
	MOVE.L	D0,-(A7)		;47352: 2f00
	JSR	(_put_in_string,PC)	;47354: 4ebafc98
	LEA	($A,A7),A7		;47358: 4fef000a
	BRA.W	LAB_47620		;4735c: 600002c2
; ------------------------------------------------------------------------------
; #5
; ------------------------------------------------------------------------------
line_5:
	BTST	#2,(conq_04_mode,A4)	;47360: 082c000284c0
	BEQ.S	LAB_47370		;47366: 6708
	MOVE.L	(LAB_521D4,A4),(-14,A5)	;47368: 2b6c8de6fff2
	BRA.S	LAB_47396		;4736e: 6026
LAB_47370:
	BTST	#4,(conq_04_mode,A4)	;47370: 082c000484c0
	BEQ.S	LAB_47380		;47376: 6708
	MOVE.L	(LAB_521D8,A4),(-14,A5)	;47378: 2b6c8deafff2
	BRA.S	LAB_47396		;4737e: 6016
LAB_47380:
	BTST	#3,(conq_04_mode,A4)	;47380: 082c000384c0
	BEQ.S	LAB_47390		;47386: 6708
	MOVE.L	(LAB_521DC,A4),(-14,A5)	;47388: 2b6c8deefff2
	BRA.S	LAB_47396		;4738e: 6006
LAB_47390:
	MOVE.L	(LAB_521E0,A4),(-14,A5)	;47390: 2b6c8df2fff2
LAB_47396:
	MOVE.W	(-20,A5),D0		;47396: 302dffec
	MULS	#$002e,D0		;4739a: c1fc002e
	LEA	(LAB_51EEE,A4),A0	;4739e: 41ec8b00
	MOVE.W	(0,A0,D0.L),-(A7)	;473a2: 3f300800
	MOVE.L	(-14,A5),-(A7)		;473a6: 2f2dfff2
	MOVE.W	(-20,A5),D0		;473aa: 302dffec
	MULS	#$002e,D0		;473ae: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;473b2: 41ec8b02
	ADD.L	A0,D0			;473b6: d088
	MOVE.L	D0,-(A7)		;473b8: 2f00
	JSR	(_put_in_string,PC)	;473ba: 4ebafc32
	LEA	($A,A7),A7		;473be: 4fef000a
	BRA.W	LAB_47620		;473c2: 6000025c
; ------------------------------------------------------------------------------
; #6
; ------------------------------------------------------------------------------
line_6:
	BTST	#1,(conq_04_mode,A4)	;473c6: 082c000184c0
	BEQ.S	LAB_473D6		;473cc: 6708
	MOVE.L	(LAB_521E8,A4),(-14,A5)	;473ce: 2b6c8dfafff2
	BRA.S	LAB_473DC		;473d4: 6006
LAB_473D6:
	MOVE.L	(LAB_521E4,A4),(-14,A5)	;473d6: 2b6c8df6fff2
LAB_473DC:
	MOVE.W	(-20,A5),D0		;473dc: 302dffec
	MULS	#$002e,D0		;473e0: c1fc002e
	LEA	(LAB_51EEE,A4),A0	;473e4: 41ec8b00
	MOVE.W	(0,A0,D0.L),-(A7)	;473e8: 3f300800
	MOVE.L	(-14,A5),-(A7)		;473ec: 2f2dfff2
	MOVE.W	(-20,A5),D0		;473f0: 302dffec
	MULS	#$002e,D0		;473f4: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;473f8: 41ec8b02
	ADD.L	A0,D0			;473fc: d088
	MOVE.L	D0,-(A7)		;473fe: 2f00
	JSR	(_put_in_string,PC)	;47400: 4ebafbec
	LEA	($A,A7),A7		;47404: 4fef000a
	BRA.W	LAB_47620		;47408: 60000216
; ------------------------------------------------------------------------------
; #7
; ------------------------------------------------------------------------------
line_7:
	BTST	#0,(conq_04_mode,A4)	;4740c: 082c000084c0
	BEQ.S	LAB_4741C		;47412: 6708
	MOVE.L	(LAB_521F0,A4),(-14,A5)	;47414: 2b6c8e02fff2
	BRA.S	LAB_47422		;4741a: 6006
LAB_4741C:
	MOVE.L	(LAB_521EC,A4),(-14,A5)	;4741c: 2b6c8dfefff2
LAB_47422:
	MOVE.W	(-20,A5),D0		;47422: 302dffec
	MULS	#$002e,D0		;47426: c1fc002e
	LEA	(LAB_51EEE,A4),A0	;4742a: 41ec8b00
	MOVE.W	(0,A0,D0.L),-(A7)	;4742e: 3f300800
	MOVE.L	(-14,A5),-(A7)		;47432: 2f2dfff2
	MOVE.W	(-20,A5),D0		;47436: 302dffec
	MULS	#$002e,D0		;4743a: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;4743e: 41ec8b02
	ADD.L	A0,D0			;47442: d088
	MOVE.L	D0,-(A7)		;47444: 2f00
	JSR	(_put_in_string,PC)	;47446: 4ebafba6
	LEA	($A,A7),A7		;4744a: 4fef000a
	BRA.W	LAB_47620		;4744e: 600001d0
; ------------------------------------------------------------------------------
; #8
; ------------------------------------------------------------------------------
line_8:
	BRA.W	LAB_47620		;47452: 600001cc
; ------------------------------------------------------------------------------
; #9
; ------------------------------------------------------------------------------
line_9:
	MOVEQ	#0,D0			;47456: 7000
	MOVE.B	(conq_06_yourpop,A4),D0	;47458: 102c84c2
	MOVE.W	D0,-(A7)		;4745c: 3f00
	PEA	(-10,A5)		;4745e: 486dfff6
	JSR	(___word_asc,A4)	;47462: 4eac818e
	ADDQ.W	#6,A7			;47466: 5c4f
	PEA	(-10,A5)		;47468: 486dfff6
	MOVE.W	(-20,A5),D0		;4746c: 302dffec
	MULS	#$002e,D0		;47470: c1fc002e
	LEA	(LAB_51EEC,A4),A0	;47474: 41ec8afe
	MOVE.W	(0,A0,D0.L),D1		;47478: 32300800
	ADD.W	#$0018,D1		;4747c: d27c0018
	MOVE.W	D1,-(A7)		;47480: 3f01
	MOVE.W	(-20,A5),D0		;47482: 302dffec
	MULS	#$002e,D0		;47486: c1fc002e
	LEA	(_c_text,A4),A0		;4748a: 41ec8afc
	MOVE.W	(-20,A5),D1		;4748e: 322dffec
	MULS	#$002e,D1		;47492: c3fc002e
	LEA	(LAB_51EEE,A4),A1	;47496: 43ec8b00
	MOVE.W	(0,A0,D0.L),D2		;4749a: 34300800
	ADD.W	(0,A1,D1.L),D2		;4749e: d4711800
	ADD.W	#$0010,D2		;474a2: d47c0010
	MOVE.W	D2,-(A7)		;474a6: 3f02
	MOVE.L	(_d_screen,A4),-(A7)	;474a8: 2f2c99ec
	JSR	(___text,A4)		;474ac: 4eac813a
	LEA	($C,A7),A7		;474b0: 4fef000c
	MOVEQ	#0,D0			;474b4: 7000
	MOVE.B	(conq_07_enemypop,A4),D0 ;474b6: 102c84c3
	MOVE.W	D0,-(A7)		;474ba: 3f00
	PEA	(-10,A5)		;474bc: 486dfff6
	JSR	(___word_asc,A4)	;474c0: 4eac818e
	ADDQ.W	#6,A7			;474c4: 5c4f
	PEA	(-10,A5)		;474c6: 486dfff6
	MOVE.W	(-20,A5),D0		;474ca: 302dffec
	MULS	#$002e,D0		;474ce: c1fc002e
	LEA	(LAB_51EEC,A4),A0	;474d2: 41ec8afe
	MOVE.W	(0,A0,D0.L),D1		;474d6: 32300800
	ADD.W	#$0018,D1		;474da: d27c0018
	MOVE.W	D1,-(A7)		;474de: 3f01
	MOVE.W	(-20,A5),D0		;474e0: 302dffec
	MULS	#$002e,D0		;474e4: c1fc002e
	LEA	(_c_text,A4),A0		;474e8: 41ec8afc
	MOVE.W	(-20,A5),D1		;474ec: 322dffec
	MULS	#$002e,D1		;474f0: c3fc002e
	LEA	(LAB_51EEE,A4),A1	;474f4: 43ec8b00
	MOVE.W	(0,A0,D0.L),D2		;474f8: 34300800
	ADD.W	(0,A1,D1.L),D2		;474fc: d4711800
	ADD.W	#$0048,D2		;47500: d47c0048
	MOVE.W	D2,-(A7)		;47504: 3f02
	MOVE.L	(_d_screen,A4),-(A7)	;47506: 2f2c99ec
	JSR	(___text,A4)		;4750a: 4eac813a
	LEA	($C,A7),A7		;4750e: 4fef000c
	BRA.W	LAB_47620		;47512: 6000010c
; ------------------------------------------------------------------------------
; #0
; ------------------------------------------------------------------------------
line_0:
	MOVEQ	#0,D0			;47516: 7000
	MOVE.B	(conq_03_yourpow,A4),D0	;47518: 102c84bf
	MOVE.W	(-20,A5),D1		;4751c: 322dffec
	SUB.W	#$000a,D1		;47520: 927c000a
	MOVEQ	#1,D2			;47524: 7401
	ASL.W	D1,D2			;47526: e362
	AND.W	D2,D0			;47528: c042
	BEQ.S	LAB_47534		;4752a: 6708
	MOVE.L	(LAB_521F4,A4),(-14,A5)	;4752c: 2b6c8e06fff2
	BRA.S	LAB_4753A		;47532: 6006
LAB_47534:
	MOVE.L	(LAB_521F8,A4),(-14,A5)	;47534: 2b6c8e0afff2
LAB_4753A:
	MOVE.L	(-14,A5),-(A7)		;4753a: 2f2dfff2
	MOVE.W	(-20,A5),D0		;4753e: 302dffec
	MULS	#$002e,D0		;47542: c1fc002e
	LEA	(LAB_51EEC,A4),A0	;47546: 41ec8afe
	MOVE.W	(0,A0,D0.L),D1		;4754a: 32300800
	ADD.W	#$0018,D1		;4754e: d27c0018
	MOVE.W	D1,-(A7)		;47552: 3f01
	MOVE.W	(-20,A5),D0		;47554: 302dffec
	MULS	#$002e,D0		;47558: c1fc002e
	LEA	(_c_text,A4),A0		;4755c: 41ec8afc
	MOVE.W	(-20,A5),D1		;47560: 322dffec
	MULS	#$002e,D1		;47564: c3fc002e
	LEA	(LAB_51EEE,A4),A1	;47568: 43ec8b00
	MOVE.W	(0,A0,D0.L),D2		;4756c: 34300800
	ADD.W	(0,A1,D1.L),D2		;47570: d4711800
	ADD.W	#$0010,D2		;47574: d47c0010
	MOVE.W	D2,-(A7)		;47578: 3f02
	MOVE.L	(_d_screen,A4),-(A7)	;4757a: 2f2c99ec
	JSR	(___text,A4)		;4757e: 4eac813a
	LEA	($C,A7),A7		;47582: 4fef000c
	MOVEQ	#0,D0			;47586: 7000
	MOVE.B	(conq_02_enemypow,A4),D0 ;47588: 102c84be
	MOVE.W	(-20,A5),D1		;4758c: 322dffec
	SUB.W	#$000a,D1		;47590: 927c000a
	MOVEQ	#1,D2			;47594: 7401
	ASL.W	D1,D2			;47596: e362
	AND.W	D2,D0			;47598: c042
	BEQ.S	LAB_475A4		;4759a: 6708
	MOVE.L	(LAB_521F4,A4),(-14,A5)	;4759c: 2b6c8e06fff2
	BRA.S	LAB_475AA		;475a2: 6006
LAB_475A4:
	MOVE.L	(LAB_521F8,A4),(-14,A5)	;475a4: 2b6c8e0afff2
LAB_475AA:
	MOVE.L	(-14,A5),-(A7)		;475aa: 2f2dfff2
	MOVE.W	(-20,A5),D0		;475ae: 302dffec
	MULS	#$002e,D0		;475b2: c1fc002e
	LEA	(LAB_51EEC,A4),A0	;475b6: 41ec8afe
	MOVE.W	(0,A0,D0.L),D1		;475ba: 32300800
	ADD.W	#$0018,D1		;475be: d27c0018
	MOVE.W	D1,-(A7)		;475c2: 3f01
	MOVE.W	(-20,A5),D0		;475c4: 302dffec
	MULS	#$002e,D0		;475c8: c1fc002e
	LEA	(_c_text,A4),A0		;475cc: 41ec8afc
	MOVE.W	(-20,A5),D1		;475d0: 322dffec
	MULS	#$002e,D1		;475d4: c3fc002e
	LEA	(LAB_51EEE,A4),A1	;475d8: 43ec8b00
	MOVE.W	(0,A0,D0.L),D2		;475dc: 34300800
	ADD.W	(0,A1,D1.L),D2		;475e0: d4711800
	ADD.W	#$0048,D2		;475e4: d47c0048
	MOVE.W	D2,-(A7)		;475e8: 3f02
	MOVE.L	(_d_screen,A4),-(A7)	;475ea: 2f2c99ec
	JSR	(___text,A4)		;475ee: 4eac813a
	LEA	($C,A7),A7		;475f2: 4fef000c
	BRA.S	LAB_47620		;475f6: 6028
LAB_475F8:
	DC.W	(line_0)-(LAB_4761C+2)	;475f8: fef8
	DC.W	(line_1)-(LAB_4761C+2)	;475fa: fc2e
	DC.W	(line_2)-(LAB_4761C+2)	;475fc: fc74
	DC.W	(line_3)-(LAB_4761C+2)	;475fe: fcb0
	DC.W	(line_4)-(LAB_4761C+2)	;47600: fcf8
	DC.W	(line_5)-(LAB_4761C+2)	;47602: fd42
	DC.W	(line_6)-(LAB_4761C+2)	;47604: fda8
	DC.W	(line_7)-(LAB_4761C+2)	;47606: fdee
	DC.W	(line_8)-(LAB_4761C+2)	;47608: fe34
	DC.W	(line_9)-(LAB_4761C+2)	;4760a: fe38
LAB_4760C:
; level 10+ = 0
; conquest new game screen data fields
	CMP.L	#$0000000a,D0		;4760c: b0bc0000000a
	BCC.W	line_0			;47612: 6400ff02
	ASL.L	#1,D0			;47616: e380
	MOVE.W	(LAB_475F8,PC,D0.W),D0	;47618: 303b00de
LAB_4761C:
; jump table
	JMP	(LAB_4761C+2,PC,D0.W)	;4761c: 4efb0000
LAB_47620:
	MOVE.W	(-20,A5),D0		;47620: 302dffec
	MULS	#$002e,D0		;47624: c1fc002e
	LEA	(strWorldToConquer,A4),A0 ;47628: 41ec8b02
	ADD.L	A0,D0			;4762c: d088
	MOVE.L	D0,-(A7)		;4762e: 2f00
	MOVE.W	(-20,A5),D0		;47630: 302dffec
	MULS	#$002e,D0		;47634: c1fc002e
	LEA	(LAB_51EEC,A4),A0	;47638: 41ec8afe
	MOVE.W	(0,A0,D0.L),D1		;4763c: 32300800
	ADD.W	#$0018,D1		;47640: d27c0018
	MOVE.W	D1,-(A7)		;47644: 3f01
	MOVE.W	(-20,A5),D0		;47646: 302dffec
	MULS	#$002e,D0		;4764a: c1fc002e
	LEA	(_c_text,A4),A0		;4764e: 41ec8afc
	MOVE.W	(0,A0,D0.L),D1		;47652: 32300800
	ADD.W	#$0010,D1		;47656: d27c0010
	MOVE.W	D1,-(A7)		;4765a: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;4765c: 2f2c99ec
	JSR	(___text,A4)		;47660: 4eac813a
	LEA	($C,A7),A7		;47664: 4fef000c
	ADDQ.W	#1,(-20,A5)		;47668: 526dffec
	CMPI.W	#$000f,(-20,A5)		;4766c: 0c6d000fffec
	BLT.W	LAB_47242		;47672: 6d00fbce
LAB_47676:
	TST.W	(_left_button,A4)	;47676: 4a6cae62
	BEQ.S	LAB_4767E		;4767a: 6702
	BRA.S	LAB_47676		;4767c: 60f8
LAB_4767E:
	PEA	(-118,A5)		;4767e: 486dff8a
	PEA	(-72,A5)		;47682: 486dffb8
	JSR	(_check_cancel,PC)	;47686: 4ebaf8c8
	ADDQ.W	#8,A7			;4768a: 504f
	MOVE.W	D0,(-20,A5)		;4768c: 3b40ffec
	BEQ.S	LAB_476A2		;47690: 6710
	CMPI.W	#$0002,(-20,A5)		;47692: 0c6d0002ffec
	BNE.S	LAB_476A2		;47698: 6608
	CLR.B	(_message,A4)		;4769a: 422c3058
	BRA.W	LAB_47064		;4769e: 6000f9c4
LAB_476A2:
	CMPI.W	#$0001,(-20,A5)		;476a2: 0c6d0001ffec
	BNE.W	LAB_47236		;476a8: 6600fb8c
	CLR.W	(_player,A4)		;476ac: 426c99f4
	MOVE.W	#$0001,(_not_player,A4)	;476b0: 397c0001825a
	MOVE.W	#$0001,(LAB_516D8,A4)	;476b6: 397c000182ea
	CLR.W	(LAB_516AA,A4)		;476bc: 426c82bc
	MOVE.W	#$0001,(LAB_516AC,A4)	;476c0: 397c000182be
	CLR.W	(LAB_516DA,A4)		;476c6: 426c82ec
	MOVE.W	#$0001,(_serial_off,A4)	;476ca: 397c00018254
	CLR.W	(_paint_map,A4)		;476d0: 426c9c24
	CLR.W	(_war,A4)		;476d4: 426cae80
	MOVE.W	(-18,A5),(_level_number,A4) ;476d8: 396dffeeae7e
	MOVE.W	(-18,A5),D0		;476de: 302dffee
	BRA.W	return_47150		;476e2: 6000fa6c
strStartGame:
	;476e6
	;DC.B	$53,$54,$41,$52,$54,$20,$47,$41,$4d,$45,$00
	DC.B	"START GAME",0
strNewGame:
	;476f1
	;DC.B	$4e,$45,$57,$20,$47,$41,$4d,$45,$00
	DC.B	"NEW GAME",0
strGENESIS1:
	;476fa
	;DC.B	$47,$45,$4e,$45,$53,$49,$53,$00
	DC.B	"GENESIS",0
strGENESIS2:
	;47702
	;DC.B	$47,$45,$4e,$45,$53,$49,$53,$00
	DC.B	"GENESIS",0
strNoSuchWorld:
	;4770a
	;DC.B	$4e,$4f,$20,$53,$55,$43,$48,$20,$57,$4f,$52,$4c,$44,$00
	DC.B	"NO SUCH WORLD",0
str_level_dat:
	;47718
	;DC.B	$6c,$65,$76,$65,$6c,$2e,$64,$61,$74,$00
	DC.B	"level.dat",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_game_options:
	LINK.W	A5,#-16			;47722: 4e55fff0
	MOVE.W	#$0001,(-4,A5)		;47726: 3b7c0001fffc
	MOVE.W	(_serial_off,A4),(-6,A5) ;4772c: 3b6c8254fffa
	MOVE.W	(_paint_map,A4),(-8,A5)	;47732: 3b6c9c24fff8
	MOVE.W	(_player,A4),(-10,A5)	;47738: 3b6c99f4fff6
	MOVE.W	(_player,A4),D0		;4773e: 302c99f4
	MULS	#$002e,D0		;47742: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47746: 41ec82bc
	MOVE.W	(0,A0,D0.L),(-12,A5)	;4774a: 3b700800fff4
	MOVE.W	(_in_conquest,A4),(-14,A5) ;47750: 3b6c84bafff2
	CLR.W	(_bring_up_two,A4)	;47756: 426c3080
	MOVE.W	(_serial_off,A4),D0	;4775a: 302c8254
	ADD.W	#$0080,D0		;4775e: d07c0080
	MOVE.B	D0,(strOnePlayer,A4)	;47762: 19408822
	TST.W	(_serial_off,A4)	;47766: 4a6c8254
	BNE.S	LAB_47770		;4776a: 6604
	MOVEQ	#1,D0			;4776c: 7001
	BRA.S	LAB_47772		;4776e: 6002
LAB_47770:
	MOVEQ	#0,D0			;47770: 7000
LAB_47772:
	ADD.W	#$0080,D0		;47772: d07c0080
	MOVE.B	D0,(strTwoplayers,A4)	;47776: 19408850
	TST.W	(_paint_map,A4)		;4777a: 4a6c9c24
	BNE.S	LAB_47784		;4777e: 6604
	MOVEQ	#1,D0			;47780: 7001
	BRA.S	LAB_47786		;47782: 6002
LAB_47784:
	MOVEQ	#0,D0			;47784: 7000
LAB_47786:
	ADD.W	#$0080,D0		;47786: d07c0080
	MOVE.B	D0,(strPlayGame,A4)	;4778a: 1940887e
	MOVE.W	(_paint_map,A4),D0	;4778e: 302c9c24
	ADD.W	#$0080,D0		;47792: d07c0080
	MOVE.B	D0,(strPaintMap,A4)	;47796: 194088ac
	TST.W	(_player,A4)		;4779a: 4a6c99f4
	BNE.S	LAB_477A4		;4779e: 6604
	MOVEQ	#1,D0			;477a0: 7001
	BRA.S	LAB_477A6		;477a2: 6002
LAB_477A4:
	MOVEQ	#0,D0			;477a4: 7000
LAB_477A6:
	ADD.W	#$0080,D0		;477a6: d07c0080
	MOVE.B	D0,(strGood,A4)		;477aa: 194088da
	MOVE.W	(_player,A4),D0		;477ae: 302c99f4
	ADD.W	#$0080,D0		;477b2: d07c0080
	MOVE.B	D0,(strEvil,A4)		;477b6: 19408908
	MOVE.W	(_player,A4),D0		;477ba: 302c99f4
	MULS	#$002e,D0		;477be: c1fc002e
	LEA	(LAB_516AA,A4),A0	;477c2: 41ec82bc
	TST.W	(0,A0,D0.L)		;477c6: 4a700800
	BNE.S	LAB_477D0		;477ca: 6604
	MOVEQ	#1,D0			;477cc: 7001
	BRA.S	LAB_477D2		;477ce: 6002
LAB_477D0:
	MOVEQ	#0,D0			;477d0: 7000
LAB_477D2:
	ADD.W	#$0080,D0		;477d2: d07c0080
	MOVE.B	D0,(strHumanVsAmiga,A4)	;477d6: 19408936
	MOVE.W	(_player,A4),D0		;477da: 302c99f4
	MULS	#$002e,D0		;477de: c1fc002e
	LEA	(LAB_516AA,A4),A0	;477e2: 41ec82bc
	MOVE.W	(0,A0,D0.L),D1		;477e6: 32300800
	ADD.W	#$0080,D1		;477ea: d27c0080
	MOVE.B	D1,(strAmigaVsAmiga,A4)	;477ee: 19418964
	CMPI.W	#$ffff,(_in_conquest,A4) ;477f2: 0c6cffff84ba
	BEQ.S	LAB_477FE		;477f8: 6704
	MOVEQ	#1,D0			;477fa: 7001
	BRA.S	LAB_47800		;477fc: 6002
LAB_477FE:
	MOVEQ	#0,D0			;477fe: 7000
LAB_47800:
	ADD.W	#$0080,D0		;47800: d07c0080
	MOVE.B	D0,(strConquest2,A4)	;47804: 19408992
	CMPI.W	#$ffff,(_in_conquest,A4) ;47808: 0c6cffff84ba
	BNE.S	LAB_47814		;4780e: 6604
	MOVEQ	#1,D0			;47810: 7001
	BRA.S	LAB_47816		;47812: 6002
LAB_47814:
	MOVEQ	#0,D0			;47814: 7000
LAB_47816:
	ADD.W	#$0080,D0		;47816: d07c0080
	MOVE.B	D0,(strCustomGame,A4)	;4781a: 194089c0
	CLR.W	(_saved,A4)		;4781e: 426c3054
LAB_47822:
	TST.W	(-4,A5)			;47822: 4a6dfffc
	BEQ.S	LAB_47850		;47826: 6728
	PEA	(_end_cancel,A4)	;47828: 486c84f4
	PEA	(_end_ok,A4)		;4782c: 486c84c6
	MOVE.W	#$00b0,-(A7)		;47830: 3f3c00b0
	MOVE.W	#$0120,-(A7)		;47834: 3f3c0120
	MOVE.W	#$0010,-(A7)		;47838: 3f3c0010
	MOVE.W	#$0010,-(A7)		;4783c: 3f3c0010
	MOVE.L	(_d_screen,A4),-(A7)	;47840: 2f2c99ec
	JSR	(_requester,PC)		;47844: 4ebadc3e
	LEA	($14,A7),A7		;47848: 4fef0014
	CLR.W	(-4,A5)			;4784c: 426dfffc
LAB_47850:
	CLR.W	(-2,A5)			;47850: 426dfffe
LAB_47854:
	MOVE.W	(-2,A5),D0		;47854: 302dfffe
	MULS	#$002e,D0		;47858: c1fc002e
	LEA	(strGameSetup,A4),A0	;4785c: 41ec87f4
	ADD.L	A0,D0			;47860: d088
	MOVE.L	D0,-(A7)		;47862: 2f00
	MOVE.W	(-2,A5),D0		;47864: 302dfffe
	MULS	#$002e,D0		;47868: c1fc002e
	LEA	(LAB_51BDE,A4),A0	;4786c: 41ec87f0
	MOVE.W	(0,A0,D0.L),D1		;47870: 32300800
	ADD.W	#$0010,D1		;47874: d27c0010
	MOVE.W	D1,-(A7)		;47878: 3f01
	MOVE.W	(-2,A5),D0		;4787a: 302dfffe
	MULS	#$002e,D0		;4787e: c1fc002e
	LEA	(_game_text,A4),A0	;47882: 41ec87ee
	MOVE.W	(0,A0,D0.L),D1		;47886: 32300800
	ADD.W	#$0010,D1		;4788a: d27c0010
	MOVE.W	D1,-(A7)		;4788e: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;47890: 2f2c99ec
	JSR	(___text,A4)		;47894: 4eac813a
	LEA	($C,A7),A7		;47898: 4fef000c
	ADDQ.W	#1,(-2,A5)		;4789c: 526dfffe
	CMPI.W	#$0011,(-2,A5)		;478a0: 0c6d0011fffe
	BLT.S	LAB_47854		;478a6: 6dac
	MOVE.W	#$0002,(_left_button,A4) ;478a8: 397c0002ae62
LAB_478AE:
	TST.W	(_left_button,A4)	;478ae: 4a6cae62
	BEQ.S	LAB_478B6		;478b2: 6702
	BRA.S	LAB_478AE		;478b4: 60f8
LAB_478B6:
	CLR.W	(-2,A5)			;478b6: 426dfffe
LAB_478BA:
	MOVE.W	(-2,A5),D0		;478ba: 302dfffe
	MULS	#$002e,D0		;478be: c1fc002e
	LEA	(_game_text,A4),A0	;478c2: 41ec87ee
	MOVE.W	(0,A0,D0.L),D1		;478c6: 32300800
	ADD.W	#$0010,D1		;478ca: d27c0010
	MOVE.W	(_mousex,A4),D0		;478ce: 302c99aa
	CMP.W	D1,D0			;478d2: b041
	BLT.S	LAB_4793A		;478d4: 6d64
	MOVE.W	(-2,A5),D0		;478d6: 302dfffe
	MULS	#$002e,D0		;478da: c1fc002e
	LEA	(_game_text,A4),A0	;478de: 41ec87ee
	MOVE.W	(-2,A5),D1		;478e2: 322dfffe
	MULS	#$002e,D1		;478e6: c3fc002e
	LEA	(LAB_51BE0,A4),A1	;478ea: 43ec87f2
	MOVE.W	(0,A0,D0.L),D2		;478ee: 34300800
	ADD.W	(0,A1,D1.L),D2		;478f2: d4711800
	ADD.W	#$0010,D2		;478f6: d47c0010
	MOVE.W	(_mousex,A4),D0		;478fa: 302c99aa
	CMP.W	D2,D0			;478fe: b042
	BGT.S	LAB_4793A		;47900: 6e38
	MOVE.W	(-2,A5),D0		;47902: 302dfffe
	MULS	#$002e,D0		;47906: c1fc002e
	LEA	(LAB_51BDE,A4),A0	;4790a: 41ec87f0
	MOVE.W	(0,A0,D0.L),D1		;4790e: 32300800
	ADD.W	#$0010,D1		;47912: d27c0010
	MOVE.W	(_mousey,A4),D0		;47916: 302cae6e
	CMP.W	D1,D0			;4791a: b041
	BLT.S	LAB_4793A		;4791c: 6d1c
	MOVE.W	(-2,A5),D0		;4791e: 302dfffe
	MULS	#$002e,D0		;47922: c1fc002e
	LEA	(LAB_51BDE,A4),A0	;47926: 41ec87f0
	MOVE.W	(0,A0,D0.L),D1		;4792a: 32300800
	ADD.W	#$0018,D1		;4792e: d27c0018
	MOVE.W	(_mousey,A4),D0		;47932: 302cae6e
	CMP.W	D1,D0			;47936: b041
	BLE.S	LAB_47948		;47938: 6f0e
LAB_4793A:
	ADDQ.W	#1,(-2,A5)		;4793a: 526dfffe
	CMPI.W	#$0011,(-2,A5)		;4793e: 0c6d0011fffe
	BLT.W	LAB_478BA		;47944: 6d00ff74
LAB_47948:
	CMPI.W	#$0009,(-2,A5)		;47948: 0c6d0009fffe
	BGE.S	LAB_4795E		;4794e: 6c0e
	CMPI.W	#$ffff,(_in_conquest,A4) ;47950: 0c6cffff84ba
	BEQ.S	LAB_4795E		;47956: 6706
	MOVE.W	#$0013,(-2,A5)		;47958: 3b7c0013fffe
LAB_4795E:
	MOVE.W	(-2,A5),D0		;4795e: 302dfffe
	EXT.L	D0			;47962: 48c0
	BRA.W	LAB_47DB8		;47964: 60000452
LAB_47968:
	MOVE.W	(-2,A5),D0		;47968: 302dfffe
	MULS	#$002e,D0		;4796c: c1fc002e
	LEA	(strGameSetup,A4),A0	;47970: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47974: 11bc00810800
	MOVE.W	(-2,A5),D0		;4797a: 302dfffe
	ADDQ.W	#1,D0			;4797e: 5240
	MULS	#$002e,D0		;47980: c1fc002e
	LEA	(strGameSetup,A4),A0	;47984: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47988: 11bc00800800
	TST.W	(_serial_off,A4)	;4798e: 4a6c8254
	BNE.S	LAB_479C8		;47992: 6634
	MOVE.W	(_player,A4),D0		;47994: 302c99f4
	MULS	#$002e,D0		;47998: c1fc002e
	LEA	(LAB_516AA,A4),A0	;4799c: 41ec82bc
	CLR.W	(0,A0,D0.L)		;479a0: 42700800
	MOVE.W	(_player,A4),D0		;479a4: 302c99f4
	MULS	#$002e,D0		;479a8: c1fc002e
	LEA	(LAB_516AA,A4),A0	;479ac: 41ec82bc
	MOVE.W	#$0001,(0,A0,D0.L)	;479b0: 31bc00010800
	MOVE.B	#$81,(strHumanVsAmiga,A4) ;479b6: 197c00818936
	MOVE.B	#$80,(strAmigaVsAmiga,A4) ;479bc: 197c00808964
	MOVE.W	#$0001,(_serial_off,A4)	;479c2: 397c00018254
LAB_479C8:
	BRA.W	LAB_47DCA		;479c8: 60000400
LAB_479CC:
	TST.W	(_serial_off,A4)	;479cc: 4a6c8254
	BEQ.S	LAB_47A0E		;479d0: 673c
	MOVE.W	(-2,A5),D0		;479d2: 302dfffe
	MULS	#$002e,D0		;479d6: c1fc002e
	LEA	(strGameSetup,A4),A0	;479da: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;479de: 11bc00810800
	MOVE.W	(-2,A5),D0		;479e4: 302dfffe
	SUBQ.W	#1,D0			;479e8: 5340
	MULS	#$002e,D0		;479ea: c1fc002e
	LEA	(strGameSetup,A4),A0	;479ee: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;479f2: 11bc00800800
	CLR.W	-(A7)			;479f8: 4267
	JSR	(_two_players,PC)	;479fa: 4ebaeaac
	ADDQ.W	#2,A7			;479fe: 544f
	TST.W	D0			;47a00: 4a40
	BNE.W	LAB_47E4E		;47a02: 6600044a
	MOVE.W	#$0001,(-4,A5)		;47a06: 3b7c0001fffc
	BRA.S	LAB_47A18		;47a0c: 600a
LAB_47A0E:
	MOVE.W	#$0001,(_bring_up_two,A4) ;47a0e: 397c00013080
LAB_47A14:
	UNLK	A5			;47a14: 4e5d
	RTS				;47a16: 4e75
LAB_47A18:
	BRA.W	LAB_47DCA		;47a18: 600003b0
LAB_47A1C:
	MOVE.W	(-2,A5),D0		;47a1c: 302dfffe
	MULS	#$002e,D0		;47a20: c1fc002e
	LEA	(strGameSetup,A4),A0	;47a24: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47a28: 11bc00810800
	MOVE.W	(-2,A5),D0		;47a2e: 302dfffe
	ADDQ.W	#1,D0			;47a32: 5240
	MULS	#$002e,D0		;47a34: c1fc002e
	LEA	(strGameSetup,A4),A0	;47a38: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47a3c: 11bc00800800
	CLR.W	(_paint_map,A4)		;47a42: 426c9c24
	BRA.W	LAB_47DCA		;47a46: 60000382
LAB_47A4A:
	MOVE.W	(-2,A5),D0		;47a4a: 302dfffe
	MULS	#$002e,D0		;47a4e: c1fc002e
	LEA	(strGameSetup,A4),A0	;47a52: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47a56: 11bc00810800
	MOVE.W	(-2,A5),D0		;47a5c: 302dfffe
	SUBQ.W	#1,D0			;47a60: 5340
	MULS	#$002e,D0		;47a62: c1fc002e
	LEA	(strGameSetup,A4),A0	;47a66: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47a6a: 11bc00800800
	MOVE.W	#$0001,(_paint_map,A4)	;47a70: 397c00019c24
	BRA.W	LAB_47DCA		;47a76: 60000352
LAB_47A7A:
	MOVE.W	(-2,A5),D0		;47a7a: 302dfffe
	MULS	#$002e,D0		;47a7e: c1fc002e
	LEA	(strGameSetup,A4),A0	;47a82: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47a86: 11bc00810800
	MOVE.W	(-2,A5),D0		;47a8c: 302dfffe
	ADDQ.W	#1,D0			;47a90: 5240
	MULS	#$002e,D0		;47a92: c1fc002e
	LEA	(strGameSetup,A4),A0	;47a96: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47a9a: 11bc00800800
	MOVE.W	#$ffff,-(A7)		;47aa0: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47aa4: 3f3cffff
	JSR	(___set_tend_icons,A4)	;47aa8: 4eac802c
	ADDQ.W	#4,A7			;47aac: 584f
	MOVE.W	#$ffff,-(A7)		;47aae: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47ab2: 3f3cffff
	JSR	(___set_mode_icons,A4)	;47ab6: 4eac8032
	ADDQ.W	#4,A7			;47aba: 584f
	MOVE.W	(_not_player,A4),D0	;47abc: 302c825a
	MULS	#$002e,D0		;47ac0: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47ac4: 41ec82bc
	MOVE.W	(0,A0,D0.L),(-16,A5)	;47ac8: 3b700800fff0
	MOVE.W	(_player,A4),D0		;47ace: 302c99f4
	MULS	#$002e,D0		;47ad2: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47ad6: 41ec82bc
	MOVE.W	(0,A0,D0.L),(LAB_516AA,A4) ;47ada: 3970080082bc
	MOVE.W	(-16,A5),(LAB_516D8,A4)	;47ae0: 396dfff082ea
	CLR.W	(_player,A4)		;47ae6: 426c99f4
	CMPI.W	#$0002,(_mode,A4)	;47aea: 0c6c00028256
	BNE.S	LAB_47AFA		;47af0: 6608
	MOVE.W	#$0001,(_pointer,A4)	;47af2: 397c000184b6
	BRA.S	LAB_47B0C		;47af8: 6012
LAB_47AFA:
	BTST	#2,(bitfield_51645,A4)	;47afa: 082c00028257
	BEQ.S	LAB_47B0C		;47b00: 670a
	MOVE.W	(_player,A4),D0		;47b02: 302c99f4
	ADDQ.W	#2,D0			;47b06: 5440
	MOVE.W	D0,(_pointer,A4)	;47b08: 394084b6
LAB_47B0C:
	TST.W	(_player,A4)		;47b0c: 4a6c99f4
	BNE.S	LAB_47B1A		;47b10: 6608
	MOVE.W	#$0001,(_not_player,A4)	;47b12: 397c0001825a
	BRA.S	LAB_47B1E		;47b18: 6004
LAB_47B1A:
	CLR.W	(_not_player,A4)	;47b1a: 426c825a
LAB_47B1E:
	MOVE.W	#$ffff,-(A7)		;47b1e: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47b22: 3f3cffff
	JSR	(___set_tend_icons,A4)	;47b26: 4eac802c
	ADDQ.W	#4,A7			;47b2a: 584f
	MOVE.W	#$ffff,-(A7)		;47b2c: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47b30: 3f3cffff
	JSR	(___set_mode_icons,A4)	;47b34: 4eac8032
	ADDQ.W	#4,A7			;47b38: 584f
	BRA.W	LAB_47DCA		;47b3a: 6000028e
LAB_47B3E:
	MOVE.W	(-2,A5),D0		;47b3e: 302dfffe
	MULS	#$002e,D0		;47b42: c1fc002e
	LEA	(strGameSetup,A4),A0	;47b46: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47b4a: 11bc00810800
	MOVE.W	(-2,A5),D0		;47b50: 302dfffe
	SUBQ.W	#1,D0			;47b54: 5340
	MULS	#$002e,D0		;47b56: c1fc002e
	LEA	(strGameSetup,A4),A0	;47b5a: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47b5e: 11bc00800800
	MOVE.W	#$ffff,-(A7)		;47b64: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47b68: 3f3cffff
	JSR	(___set_tend_icons,A4)	;47b6c: 4eac802c
	ADDQ.W	#4,A7			;47b70: 584f
	MOVE.W	#$ffff,-(A7)		;47b72: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47b76: 3f3cffff
	JSR	(___set_mode_icons,A4)	;47b7a: 4eac8032
	ADDQ.W	#4,A7			;47b7e: 584f
	MOVE.W	(_not_player,A4),D0	;47b80: 302c825a
	MULS	#$002e,D0		;47b84: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47b88: 41ec82bc
	MOVE.W	(0,A0,D0.L),(-16,A5)	;47b8c: 3b700800fff0
	MOVE.W	(_player,A4),D0		;47b92: 302c99f4
	MULS	#$002e,D0		;47b96: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47b9a: 41ec82bc
	MOVE.W	(0,A0,D0.L),(LAB_516D8,A4) ;47b9e: 3970080082ea
	MOVE.W	(-16,A5),(LAB_516AA,A4)	;47ba4: 396dfff082bc
	MOVE.W	#$0001,(_player,A4)	;47baa: 397c000199f4
	CMPI.W	#$0002,(_mode,A4)	;47bb0: 0c6c00028256
	BNE.S	LAB_47BC0		;47bb6: 6608
	MOVE.W	#$0004,(_pointer,A4)	;47bb8: 397c000484b6
	BRA.S	LAB_47BD2		;47bbe: 6012
LAB_47BC0:
	BTST	#2,(bitfield_51645,A4)	;47bc0: 082c00028257
	BEQ.S	LAB_47BD2		;47bc6: 670a
	MOVE.W	(_player,A4),D0		;47bc8: 302c99f4
	ADDQ.W	#2,D0			;47bcc: 5440
	MOVE.W	D0,(_pointer,A4)	;47bce: 394084b6
LAB_47BD2:
	TST.W	(_player,A4)		;47bd2: 4a6c99f4
	BNE.S	LAB_47BE0		;47bd6: 6608
	MOVE.W	#$0001,(_not_player,A4)	;47bd8: 397c0001825a
	BRA.S	LAB_47BE4		;47bde: 6004
LAB_47BE0:
	CLR.W	(_not_player,A4)	;47be0: 426c825a
LAB_47BE4:
	MOVE.W	#$ffff,-(A7)		;47be4: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47be8: 3f3cffff
	JSR	(___set_tend_icons,A4)	;47bec: 4eac802c
	ADDQ.W	#4,A7			;47bf0: 584f
	MOVE.W	#$ffff,-(A7)		;47bf2: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47bf6: 3f3cffff
	JSR	(___set_mode_icons,A4)	;47bfa: 4eac8032
	ADDQ.W	#4,A7			;47bfe: 584f
	BRA.W	LAB_47DCA		;47c00: 600001c8
LAB_47C04:
	MOVE.W	(-2,A5),D0		;47c04: 302dfffe
	MULS	#$002e,D0		;47c08: c1fc002e
	LEA	(strGameSetup,A4),A0	;47c0c: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47c10: 11bc00810800
	MOVE.W	(-2,A5),D0		;47c16: 302dfffe
	ADDQ.W	#1,D0			;47c1a: 5240
	MULS	#$002e,D0		;47c1c: c1fc002e
	LEA	(strGameSetup,A4),A0	;47c20: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47c24: 11bc00800800
	MOVE.W	(_player,A4),D0		;47c2a: 302c99f4
	MULS	#$002e,D0		;47c2e: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47c32: 41ec82bc
	CLR.W	(0,A0,D0.L)		;47c36: 42700800
	TST.W	(_serial_off,A4)	;47c3a: 4a6c8254
	BEQ.S	LAB_47C5A		;47c3e: 671a
	TST.W	(_player,A4)		;47c40: 4a6c99f4
	BNE.S	LAB_47C4A		;47c44: 6604
	MOVEQ	#1,D0			;47c46: 7001
	BRA.S	LAB_47C4C		;47c48: 6002
LAB_47C4A:
	MOVEQ	#0,D0			;47c4a: 7000
LAB_47C4C:
	MULS	#$002e,D0		;47c4c: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47c50: 41ec82bc
	MOVE.W	#$0001,(0,A0,D0.L)	;47c54: 31bc00010800
LAB_47C5A:
	BRA.W	LAB_47DCA		;47c5a: 6000016e
LAB_47C5E:
	MOVE.W	(-2,A5),D0		;47c5e: 302dfffe
	MULS	#$002e,D0		;47c62: c1fc002e
	LEA	(strGameSetup,A4),A0	;47c66: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47c6a: 11bc00810800
	MOVE.W	(-2,A5),D0		;47c70: 302dfffe
	SUBQ.W	#1,D0			;47c74: 5340
	MULS	#$002e,D0		;47c76: c1fc002e
	LEA	(strGameSetup,A4),A0	;47c7a: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47c7e: 11bc00800800
	MOVE.W	(_player,A4),D0		;47c84: 302c99f4
	MULS	#$002e,D0		;47c88: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47c8c: 41ec82bc
	MOVE.W	#$0001,(0,A0,D0.L)	;47c90: 31bc00010800
	TST.W	(_serial_off,A4)	;47c96: 4a6c8254
	BEQ.S	LAB_47CB6		;47c9a: 671a
	TST.W	(_player,A4)		;47c9c: 4a6c99f4
	BNE.S	LAB_47CA6		;47ca0: 6604
	MOVEQ	#1,D0			;47ca2: 7001
	BRA.S	LAB_47CA8		;47ca4: 6002
LAB_47CA6:
	MOVEQ	#0,D0			;47ca6: 7000
LAB_47CA8:
	MULS	#$002e,D0		;47ca8: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47cac: 41ec82bc
	MOVE.W	#$0001,(0,A0,D0.L)	;47cb0: 31bc00010800
LAB_47CB6:
	BRA.W	LAB_47DCA		;47cb6: 60000112
LAB_47CBA:
	TST.W	(_serial_off,A4)	;47cba: 4a6c8254
	BEQ.S	LAB_47CFC		;47cbe: 673c
	MOVE.W	(-2,A5),D0		;47cc0: 302dfffe
	MULS	#$002e,D0		;47cc4: c1fc002e
	LEA	(strGameSetup,A4),A0	;47cc8: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47ccc: 11bc00810800
	MOVE.W	(-2,A5),D0		;47cd2: 302dfffe
	ADDQ.W	#1,D0			;47cd6: 5240
	MULS	#$002e,D0		;47cd8: c1fc002e
	LEA	(strGameSetup,A4),A0	;47cdc: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47ce0: 11bc00800800
	CLR.B	(_message,A4)		;47ce6: 422c3058
	JSR	(_show_world,PC)	;47cea: 4ebaf340
	MOVE.W	D0,(_in_conquest,A4)	;47cee: 394084ba
	MOVE.W	#$0001,(_new_map,A4)	;47cf2: 397c0001309a
	BRA.W	LAB_47E4E		;47cf8: 60000154
LAB_47CFC:
	BRA.W	LAB_47DCA		;47cfc: 600000cc
LAB_47D00:
	MOVE.W	(-2,A5),D0		;47d00: 302dfffe
	MULS	#$002e,D0		;47d04: c1fc002e
	LEA	(strGameSetup,A4),A0	;47d08: 41ec87f4
	MOVE.B	#$81,(0,A0,D0.L)	;47d0c: 11bc00810800
	MOVE.W	(-2,A5),D0		;47d12: 302dfffe
	SUBQ.W	#1,D0			;47d16: 5340
	MULS	#$002e,D0		;47d18: c1fc002e
	LEA	(strGameSetup,A4),A0	;47d1c: 41ec87f4
	MOVE.B	#$80,(0,A0,D0.L)	;47d20: 11bc00800800
	MOVE.W	#$ffff,(_in_conquest,A4) ;47d26: 397cffff84ba
	BRA.W	LAB_47DCA		;47d2c: 6000009c
LAB_47D30:
	JSR	(_set_options,PC)	;47d30: 4eba0124
	MOVE.W	#$0001,(-4,A5)		;47d34: 3b7c0001fffc
	BRA.W	LAB_47DCA		;47d3a: 6000008e
LAB_47D3E:
	MOVE.W	#$0001,-(A7)		;47d3e: 3f3c0001
	JSR	(_save_load,PC)		;47d42: 4ebaddd4
	ADDQ.W	#2,A7			;47d46: 544f
	TST.W	D0			;47d48: 4a40
	BNE.W	LAB_47E4E		;47d4a: 66000102
	MOVE.W	#$0001,(-4,A5)		;47d4e: 3b7c0001fffc
	BRA.S	LAB_47DCA		;47d54: 6074
LAB_47D56:
	TST.W	(_serial_off,A4)	;47d56: 4a6c8254
	BEQ.S	LAB_47D70		;47d5a: 6714
	CLR.W	-(A7)			;47d5c: 4267
	JSR	(_save_load,PC)		;47d5e: 4ebaddb8
	ADDQ.W	#2,A7			;47d62: 544f
	TST.W	D0			;47d64: 4a40
	BNE.W	LAB_47E4E		;47d66: 660000e6
	MOVE.W	#$0001,(-4,A5)		;47d6a: 3b7c0001fffc
LAB_47D70:
	BRA.S	LAB_47DCA		;47d70: 6058
LAB_47D72:
	MOVE.W	#$0001,(_new_map,A4)	;47d72: 397c0001309a
	BRA.W	LAB_47E4E		;47d78: 600000d4
LAB_47D7C:
	MOVE.W	(_ground_in,A4),D0	;47d7c: 302c99e6
	ADDQ.W	#2,D0			;47d80: 5440
	MOVE.W	D0,(_new_map,A4)	;47d82: 3940309a
	BRA.W	LAB_47E4E		;47d86: 600000c6
LAB_47D8A:
	MOVE.W	(_player,A4),(_surender,A4) ;47d8a: 396c99f48258
	BRA.W	LAB_47E4E		;47d90: 600000bc
LAB_47D94:
	BRA.S	LAB_47DCA		;47d94: 6034
LAB_47D96:
	DC.W	(LAB_47D94)-(LAB_47DC6+2) ;47d96: ffcc
	DC.W	(LAB_47968)-(LAB_47DC6+2) ;47d98: fba0
	DC.W	(LAB_479CC)-(LAB_47DC6+2) ;47d9a: fc04
	DC.W	(LAB_47A1C)-(LAB_47DC6+2) ;47d9c: fc54
	DC.W	(LAB_47A4A)-(LAB_47DC6+2) ;47d9e: fc82
	DC.W	(LAB_47A7A)-(LAB_47DC6+2) ;47da0: fcb2
	DC.W	(LAB_47B3E)-(LAB_47DC6+2) ;47da2: fd76
	DC.W	(LAB_47C04)-(LAB_47DC6+2) ;47da4: fe3c
	DC.W	(LAB_47C5E)-(LAB_47DC6+2) ;47da6: fe96
	DC.W	(LAB_47CBA)-(LAB_47DC6+2) ;47da8: fef2
	DC.W	(LAB_47D00)-(LAB_47DC6+2) ;47daa: ff38
	DC.W	(LAB_47D30)-(LAB_47DC6+2) ;47dac: ff68
	DC.W	(LAB_47D3E)-(LAB_47DC6+2) ;47dae: ff76
	DC.W	(LAB_47D56)-(LAB_47DC6+2) ;47db0: ff8e
	DC.W	(LAB_47D72)-(LAB_47DC6+2) ;47db2: ffaa
	DC.W	(LAB_47D7C)-(LAB_47DC6+2) ;47db4: ffb4
	DC.W	(LAB_47D8A)-(LAB_47DC6+2) ;47db6: ffc2
LAB_47DB8:
	CMP.L	#$00000011,D0		;47db8: b0bc00000011
	BCC.S	LAB_47D94		;47dbe: 64d4
	ASL.L	#1,D0			;47dc0: e380
	MOVE.W	(LAB_47D96,PC,D0.W),D0	;47dc2: 303b00d2
LAB_47DC6:
	JMP	(LAB_47DC6+2,PC,D0.W)	;47dc6: 4efb0000
LAB_47DCA:
	PEA	(_end_cancel,A4)	;47dca: 486c84f4
	PEA	(_end_ok,A4)		;47dce: 486c84c6
	JSR	(_check_cancel,PC)	;47dd2: 4ebaf17c
	ADDQ.W	#8,A7			;47dd6: 504f
	MOVE.W	D0,(-2,A5)		;47dd8: 3b40fffe
	BEQ.S	LAB_47E4A		;47ddc: 676c
	CMPI.W	#$0002,(-2,A5)		;47dde: 0c6d0002fffe
	BNE.S	LAB_47E48		;47de4: 6662
	MOVE.W	(-6,A5),(_serial_off,A4) ;47de6: 396dfffa8254
	MOVE.W	(-8,A5),(_paint_map,A4)	;47dec: 396dfff89c24
	MOVE.W	(_player,A4),D0		;47df2: 302c99f4
	CMP.W	(-10,A5),D0		;47df6: b06dfff6
	BEQ.S	LAB_47E1E		;47dfa: 6722
	MOVE.W	#$ffff,-(A7)		;47dfc: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47e00: 3f3cffff
	JSR	(___set_tend_icons,A4)	;47e04: 4eac802c
	ADDQ.W	#4,A7			;47e08: 584f
	MOVE.W	#$ffff,-(A7)		;47e0a: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;47e0e: 3f3cffff
	JSR	(___set_mode_icons,A4)	;47e12: 4eac8032
	ADDQ.W	#4,A7			;47e16: 584f
	MOVE.W	(-10,A5),(_player,A4)	;47e18: 396dfff699f4
LAB_47E1E:
	TST.W	(_player,A4)		;47e1e: 4a6c99f4
	BNE.S	LAB_47E2C		;47e22: 6608
	MOVE.W	#$0001,(_not_player,A4)	;47e24: 397c0001825a
	BRA.S	LAB_47E30		;47e2a: 6004
LAB_47E2C:
	CLR.W	(_not_player,A4)	;47e2c: 426c825a
LAB_47E30:
	MOVE.W	(_player,A4),D0		;47e30: 302c99f4
	MULS	#$002e,D0		;47e34: c1fc002e
	LEA	(LAB_516AA,A4),A0	;47e38: 41ec82bc
	MOVE.W	(-12,A5),(0,A0,D0.L)	;47e3c: 31adfff40800
	MOVE.W	(-14,A5),(_in_conquest,A4) ;47e42: 396dfff284ba
LAB_47E48:
	BRA.S	LAB_47E4E		;47e48: 6004
LAB_47E4A:
	BRA.W	LAB_47822		;47e4a: 6000f9d6
LAB_47E4E:
	JSR	(_return_to_game,PC)	;47e4e: 4eba0780
	BRA.W	LAB_47A14		;47e52: 6000fbc0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_options:
	LINK.W	A5,#-46			;47e56: 4e55ffd2
	MOVE.W	(_game_mode,A4),(-46,A5) ;47e5a: 3b6c84b8ffd2
	PEA	(_end_cancel,A4)	;47e60: 486c84f4
	PEA	(_end_ok,A4)		;47e64: 486c84c6
	MOVE.W	#$0070,-(A7)		;47e68: 3f3c0070
	MOVE.W	#$0100,-(A7)		;47e6c: 3f3c0100
	MOVE.W	#$0018,-(A7)		;47e70: 3f3c0018
	MOVE.W	#$0020,-(A7)		;47e74: 3f3c0020
	MOVE.L	(_d_screen,A4),-(A7)	;47e78: 2f2c99ec
	JSR	(_requester,PC)		;47e7c: 4ebad606
	LEA	($14,A7),A7		;47e80: 4fef0014
	PEA	(strGameOptions,A4)	;47e84: 486c8fc6
	MOVE.W	(LAB_523B0,A4),D0	;47e88: 302c8fc2
	ADD.W	#$0018,D0		;47e8c: d07c0018
	MOVE.W	D0,-(A7)		;47e90: 3f00
	MOVE.W	(_set_text,A4),D0	;47e92: 302c8fc0
	ADD.W	#$0020,D0		;47e96: d07c0020
	MOVE.W	D0,-(A7)		;47e9a: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;47e9c: 2f2c99ec
	JSR	(___text,A4)		;47ea0: 4eac813a
	LEA	($C,A7),A7		;47ea4: 4fef000c
	CLR.W	(-2,A5)			;47ea8: 426dfffe
LAB_47EAC:
	MOVEQ	#1,D0			;47eac: 7001
	MOVE.W	(-2,A5),D1		;47eae: 322dfffe
	ASL.W	D1,D0			;47eb2: e360
	AND.W	(_game_mode,A4),D0	;47eb4: c06c84b8
	BEQ.S	LAB_47EBE		;47eb8: 6704
	MOVEQ	#1,D0			;47eba: 7001
	BRA.S	LAB_47EC0		;47ebc: 6002
LAB_47EBE:
	MOVEQ	#0,D0			;47ebe: 7000
LAB_47EC0:
	ADDQ.W	#1,D0			;47ec0: 5240
	MOVE.W	D0,(-4,A5)		;47ec2: 3b40fffc
	PEA	(_blank,A4)		;47ec6: 486c91ba
	MOVE.W	(-2,A5),D0		;47eca: 302dfffe
	ASL.W	#1,D0			;47ece: e340
	ADD.W	(-4,A5),D0		;47ed0: d06dfffc
	MULS	#$002e,D0		;47ed4: c1fc002e
	LEA	(LAB_523B0,A4),A0	;47ed8: 41ec8fc2
	MOVE.W	(0,A0,D0.L),D1		;47edc: 32300800
	ADD.W	#$0018,D1		;47ee0: d27c0018
	MOVE.W	D1,-(A7)		;47ee4: 3f01
	MOVE.W	(-2,A5),D0		;47ee6: 302dfffe
	ASL.W	#1,D0			;47eea: e340
	ADD.W	(-4,A5),D0		;47eec: d06dfffc
	MULS	#$002e,D0		;47ef0: c1fc002e
	LEA	(_set_text,A4),A0	;47ef4: 41ec8fc0
	MOVE.W	(0,A0,D0.L),D1		;47ef8: 32300800
	ADD.W	#$0020,D1		;47efc: d27c0020
	MOVE.W	D1,-(A7)		;47f00: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;47f02: 2f2c99ec
	JSR	(___text,A4)		;47f06: 4eac813a
	LEA	($C,A7),A7		;47f0a: 4fef000c
	MOVE.W	(-2,A5),D0		;47f0e: 302dfffe
	ASL.W	#1,D0			;47f12: e340
	ADD.W	(-4,A5),D0		;47f14: d06dfffc
	MULS	#$002e,D0		;47f18: c1fc002e
	LEA	(strGameOptions,A4),A0	;47f1c: 41ec8fc6
	ADD.L	A0,D0			;47f20: d088
	MOVE.L	D0,-(A7)		;47f22: 2f00
	MOVE.W	(-2,A5),D0		;47f24: 302dfffe
	ASL.W	#1,D0			;47f28: e340
	ADD.W	(-4,A5),D0		;47f2a: d06dfffc
	MULS	#$002e,D0		;47f2e: c1fc002e
	LEA	(LAB_523B0,A4),A0	;47f32: 41ec8fc2
	MOVE.W	(0,A0,D0.L),D1		;47f36: 32300800
	ADD.W	#$0018,D1		;47f3a: d27c0018
	MOVE.W	D1,-(A7)		;47f3e: 3f01
	MOVE.W	(-2,A5),D0		;47f40: 302dfffe
	ASL.W	#1,D0			;47f44: e340
	ADD.W	(-4,A5),D0		;47f46: d06dfffc
	MULS	#$002e,D0		;47f4a: c1fc002e
	LEA	(_set_text,A4),A0	;47f4e: 41ec8fc0
	MOVE.W	(0,A0,D0.L),D1		;47f52: 32300800
	ADD.W	#$0020,D1		;47f56: d27c0020
	MOVE.W	D1,-(A7)		;47f5a: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;47f5c: 2f2c99ec
	JSR	(___text,A4)		;47f60: 4eac813a
	LEA	($C,A7),A7		;47f64: 4fef000c
	ADDQ.W	#1,(-2,A5)		;47f68: 526dfffe
	CMPI.W	#$0005,(-2,A5)		;47f6c: 0c6d0005fffe
	BLT.W	LAB_47EAC		;47f72: 6d00ff38
; ------------------------------------------------------------------------------
; new code added here
; Debug feature: adds the landscape number to the options page
; ------------------------------------------------------------------------------
	PEA	(strLandscapeNo,PC)	;47f76: 487a0202
	PEA	(-44,A5)		;47f7a: 486dffd4
	JSR	(___strcpy,A4)		;47f7e: 4eac81a0
	ADDQ.W	#8,A7			;47f82: 504f
	MOVE.W	(_start_seed,A4),-(A7)	;47f84: 3f2c99e4
	PEA	(-31,A5)		;47f88: 486dffe1
	JSR	(___word_asc,A4)	;47f8c: 4eac818e
	ADDQ.W	#6,A7			;47f90: 5c4f
	SUBQ.W	#1,(-2,A5)		;47f92: 536dfffe
	PEA	(-44,A5)		;47f96: 486dffd4
	MOVE.W	(-2,A5),D0		;47f9a: 302dfffe
	ASL.W	#1,D0			;47f9e: e340
	ADD.W	(-4,A5),D0		;47fa0: d06dfffc
	MULS	#$002e,D0		;47fa4: c1fc002e
	LEA	(LAB_523B0,A4),A0	;47fa8: 41ec8fc2
	MOVE.W	(0,A0,D0.L),D1		;47fac: 32300800
	ADD.W	#$0022,D1		;47fb0: d27c0022
	MOVE.W	D1,-(A7)		;47fb4: 3f01
	MOVE.W	(-2,A5),D0		;47fb6: 302dfffe
	ASL.W	#1,D0			;47fba: e340
	ADD.W	(-4,A5),D0		;47fbc: d06dfffc
	MULS	#$002e,D0		;47fc0: c1fc002e
	LEA	(_set_text,A4),A0	;47fc4: 41ec8fc0
	MOVE.W	(0,A0,D0.L),D1		;47fc8: 32300800
	ADD.W	#$0020,D1		;47fcc: d27c0020
	MOVE.W	D1,-(A7)		;47fd0: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;47fd2: 2f2c99ec
	JSR	(___text,A4)		;47fd6: 4eac813a
	LEA	($C,A7),A7		;47fda: 4fef000c
; ------------------------------------------------------------------------------
; new code ends here
; ------------------------------------------------------------------------------
LAB_47FDE:
	MOVE.W	#$0002,(_left_button,A4) ;47fde: 397c0002ae62
loop_47FE4:
	TST.W	(_left_button,A4)	;47fe4: 4a6cae62
	BEQ.S	LAB_47FEC		;47fe8: 6702
	BRA.S	loop_47FE4		;47fea: 60f8
LAB_47FEC:
	MOVE.W	#$0001,(-2,A5)		;47fec: 3b7c0001fffe
LAB_47FF2:
	MOVE.W	(-2,A5),D0		;47ff2: 302dfffe
	MULS	#$002e,D0		;47ff6: c1fc002e
	LEA	(_set_text,A4),A0	;47ffa: 41ec8fc0
	MOVE.W	(0,A0,D0.L),D1		;47ffe: 32300800
	ADD.W	#$0020,D1		;48002: d27c0020
	MOVE.W	(_mousex,A4),D0		;48006: 302c99aa
	CMP.W	D1,D0			;4800a: b041
	BLT.W	LAB_4813C		;4800c: 6d00012e
	CMPI.W	#$ffff,(_in_conquest,A4) ;48010: 0c6cffff84ba
	BNE.W	LAB_4813C		;48016: 66000124
	MOVE.W	(-2,A5),D0		;4801a: 302dfffe
	MULS	#$002e,D0		;4801e: c1fc002e
	LEA	(_set_text,A4),A0	;48022: 41ec8fc0
	MOVE.W	(-2,A5),D1		;48026: 322dfffe
	MULS	#$002e,D1		;4802a: c3fc002e
	LEA	(LAB_523B2,A4),A1	;4802e: 43ec8fc4
	MOVE.W	(0,A0,D0.L),D2		;48032: 34300800
	ADD.W	(0,A1,D1.L),D2		;48036: d4711800
	ADD.W	#$0020,D2		;4803a: d47c0020
	MOVE.W	(_mousex,A4),D0		;4803e: 302c99aa
	CMP.W	D2,D0			;48042: b042
	BGT.W	LAB_4813C		;48044: 6e0000f6
	MOVE.W	(-2,A5),D0		;48048: 302dfffe
	MULS	#$002e,D0		;4804c: c1fc002e
	LEA	(LAB_523B0,A4),A0	;48050: 41ec8fc2
	MOVE.W	(0,A0,D0.L),D1		;48054: 32300800
	ADD.W	#$0018,D1		;48058: d27c0018
	MOVE.W	(_mousey,A4),D0		;4805c: 302cae6e
	CMP.W	D1,D0			;48060: b041
	BLT.W	LAB_4813C		;48062: 6d0000d8
	MOVE.W	(-2,A5),D0		;48066: 302dfffe
	MULS	#$002e,D0		;4806a: c1fc002e
	LEA	(LAB_523B0,A4),A0	;4806e: 41ec8fc2
	MOVE.W	(0,A0,D0.L),D1		;48072: 32300800
	ADD.W	#$0020,D1		;48076: d27c0020
	MOVE.W	(_mousey,A4),D0		;4807a: 302cae6e
	CMP.W	D1,D0			;4807e: b041
	BGT.W	LAB_4813C		;48080: 6e0000ba
	MOVE.W	(-2,A5),D0		;48084: 302dfffe
	ASR.W	#1,D0			;48088: e240
	MOVEQ	#1,D1			;4808a: 7201
	ASL.W	D0,D1			;4808c: e161
	MOVE.W	D1,(-4,A5)		;4808e: 3b41fffc
	MOVE.W	(-4,A5),D0		;48092: 302dfffc
	EOR.W	D0,(_game_mode,A4)	;48096: b16c84b8
	MOVE.W	(_game_mode,A4),D0	;4809a: 302c84b8
	AND.W	(-4,A5),D0		;4809e: c06dfffc
	BEQ.S	LAB_480B0		;480a2: 670c
	MOVE.W	(-2,A5),D0		;480a4: 302dfffe
	ADDQ.W	#1,D0			;480a8: 5240
	MOVE.W	D0,(-4,A5)		;480aa: 3b40fffc
	BRA.S	LAB_480B6		;480ae: 6006
LAB_480B0:
	MOVE.W	(-2,A5),(-4,A5)		;480b0: 3b6dfffefffc
LAB_480B6:
	PEA	(_blank,A4)		;480b6: 486c91ba
	MOVE.W	(-4,A5),D0		;480ba: 302dfffc
	MULS	#$002e,D0		;480be: c1fc002e
	LEA	(LAB_523B0,A4),A0	;480c2: 41ec8fc2
	MOVE.W	(0,A0,D0.L),D1		;480c6: 32300800
	ADD.W	#$0018,D1		;480ca: d27c0018
	MOVE.W	D1,-(A7)		;480ce: 3f01
	MOVE.W	(-4,A5),D0		;480d0: 302dfffc
	MULS	#$002e,D0		;480d4: c1fc002e
	LEA	(_set_text,A4),A0	;480d8: 41ec8fc0
	MOVE.W	(0,A0,D0.L),D1		;480dc: 32300800
	ADD.W	#$0020,D1		;480e0: d27c0020
	MOVE.W	D1,-(A7)		;480e4: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;480e6: 2f2c99ec
	JSR	(___text,A4)		;480ea: 4eac813a
	LEA	($C,A7),A7		;480ee: 4fef000c
	MOVE.W	(-4,A5),D0		;480f2: 302dfffc
	MULS	#$002e,D0		;480f6: c1fc002e
	LEA	(strGameOptions,A4),A0	;480fa: 41ec8fc6
	ADD.L	A0,D0			;480fe: d088
	MOVE.L	D0,-(A7)		;48100: 2f00
	MOVE.W	(-4,A5),D0		;48102: 302dfffc
	MULS	#$002e,D0		;48106: c1fc002e
	LEA	(LAB_523B0,A4),A0	;4810a: 41ec8fc2
	MOVE.W	(0,A0,D0.L),D1		;4810e: 32300800
	ADD.W	#$0018,D1		;48112: d27c0018
	MOVE.W	D1,-(A7)		;48116: 3f01
	MOVE.W	(-4,A5),D0		;48118: 302dfffc
	MULS	#$002e,D0		;4811c: c1fc002e
	LEA	(_set_text,A4),A0	;48120: 41ec8fc0
	MOVE.W	(0,A0,D0.L),D1		;48124: 32300800
	ADD.W	#$0020,D1		;48128: d27c0020
	MOVE.W	D1,-(A7)		;4812c: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;4812e: 2f2c99ec
	JSR	(___text,A4)		;48132: 4eac813a
	LEA	($C,A7),A7		;48136: 4fef000c
	BRA.S	LAB_4814A		;4813a: 600e
LAB_4813C:
	ADDQ.W	#2,(-2,A5)		;4813c: 546dfffe
	CMPI.W	#$000a,(-2,A5)		;48140: 0c6d000afffe
	BLT.W	LAB_47FF2		;48146: 6d00feaa
LAB_4814A:
	PEA	(_end_cancel,A4)	;4814a: 486c84f4
	PEA	(_end_ok,A4)		;4814e: 486c84c6
	JSR	(_check_cancel,PC)	;48152: 4ebaedfc
	ADDQ.W	#8,A7			;48156: 504f
	MOVE.W	D0,(-2,A5)		;48158: 3b40fffe
	BEQ.S	LAB_4816E		;4815c: 6710
	CMPI.W	#$0002,(-2,A5)		;4815e: 0c6d0002fffe
	BNE.S	LAB_4816C		;48164: 6606
	MOVE.W	(-46,A5),(_game_mode,A4) ;48166: 396dffd284b8
LAB_4816C:
	BRA.S	LAB_48172		;4816c: 6004
LAB_4816E:
	BRA.W	LAB_47FDE		;4816e: 6000fe6e
LAB_48172:
	JSR	(_return_to_game,PC)	;48172: 4eba045c
	UNLK	A5			;48176: 4e5d
	RTS				;48178: 4e75
; ------------------------------------------------------------------------------
; "LANDSCAPE NO" string is new to this version
; It's used in the options page
; ------------------------------------------------------------------------------
strLandscapeNo:
	;4817a
	;DC.B	$4c,$41,$4e,$44,$53,$43,$41,$50,$45,$20,$4e,$4f,$20,$00
	DC.B	"LANDSCAPE NO ",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_options:
	LINK.W	A5,#-56			;48188: 4e55ffc8
	MOVE.W	#$0120,(-8,A5)		;4818c: 3b7c0120fff8
	MOVE.W	#$0010,(-10,A5)		;48192: 3b7c0010fff6
	LEA	(-56,A5),A0		;48198: 41edffc8
	MOVE.W	(8,A5),D0		;4819c: 302d0008
	MULS	#$002e,D0		;481a0: c1fc002e
	MOVEA.L	D0,A1			;481a4: 2240
	LEA	(_stats,A4),A6		;481a6: 4dec82b6
	ADDA.L	A6,A1			;481aa: d3ce
	MOVEQ	#$A,D0			;481ac: 700a
LAB_481AE:
	MOVE.L	(A1)+,(A0)+		;481ae: 20d9
	DBF	D0,LAB_481AE		;481b0: 51c8fffc
	MOVE.W	(A1)+,(A0)+		;481b4: 30d9
	MOVE.B	#$87,(-6,A5)		;481b6: 1b7c0087fffa
	CLR.B	(-5,A5)			;481bc: 422dfffb
	PEA	(_end_cancel,A4)	;481c0: 486c84f4
	PEA	(_end_ok,A4)		;481c4: 486c84c6
	MOVE.W	#$00a6,-(A7)		;481c8: 3f3c00a6
	MOVE.W	(-8,A5),-(A7)		;481cc: 3f2dfff8
	MOVE.W	#$0010,-(A7)		;481d0: 3f3c0010
	MOVE.W	(-10,A5),-(A7)		;481d4: 3f2dfff6
	MOVE.L	(_d_screen,A4),-(A7)	;481d8: 2f2c99ec
	JSR	(_requester,PC)		;481dc: 4ebad2a6
	LEA	($14,A7),A7		;481e0: 4fef0014
	MOVE.W	(8,A5),D0		;481e4: 302d0008
	MULS	#$002e,D0		;481e8: c1fc002e
	LEA	(LAB_516B0,A4),A0	;481ec: 41ec82c2
	MOVE.W	(8,A5),D1		;481f0: 322d0008
	MULS	#$002e,D1		;481f4: c3fc002e
	LEA	(LAB_516B0,A4),A1	;481f8: 43ec82c2
	MOVEQ	#$A,D2			;481fc: 740a
	SUB.W	(0,A1,D1.L),D2		;481fe: 94711800
	MOVE.W	D2,(0,A0,D0.L)		;48202: 31820800
	MOVE.W	(8,A5),D0		;48206: 302d0008
	MULS	#$002e,D0		;4820a: c1fc002e
	LEA	(LAB_516B4,A4),A0	;4820e: 41ec82c6
	MOVE.W	(8,A5),D1		;48212: 322d0008
	MULS	#$002e,D1		;48216: c3fc002e
	LEA	(LAB_516B4,A4),A1	;4821a: 43ec82c6
	MOVEQ	#$A,D2			;4821e: 740a
	SUB.W	(0,A1,D1.L),D2		;48220: 94711800
	MOVE.W	D2,(0,A0,D0.L)		;48224: 31820800
LAB_48228:
	MOVE.W	#$0002,(_left_button,A4) ;48228: 397c0002ae62
	CLR.W	(-2,A5)			;4822e: 426dfffe
	MOVE.W	#$0001,(-4,A5)		;48232: 3b7c0001fffc
	BRA.W	LAB_483BC		;48238: 60000182
LAB_4823C:
	TST.W	(-2,A5)			;4823c: 4a6dfffe
	BNE.S	LAB_4827E		;48240: 663c
	TST.W	(8,A5)			;48242: 4a6d0008
	BNE.S	LAB_48264		;48246: 661c
	PEA	(LAB_485C6,PC)		;48248: 487a037c
	MOVE.W	(-2,A5),D0		;4824c: 302dfffe
	MULS	#$002e,D0		;48250: c1fc002e
	LEA	(LAB_51922,A4),A0	;48254: 41ec8534
	ADD.L	A0,D0			;48258: d088
	MOVE.L	D0,-(A7)		;4825a: 2f00
	JSR	(___strcpy,A4)		;4825c: 4eac81a0
	ADDQ.W	#8,A7			;48260: 504f
	BRA.S	LAB_4827E		;48262: 601a
LAB_48264:
	PEA	(LAB_485CB,PC)		;48264: 487a0365
	MOVE.W	(-2,A5),D0		;48268: 302dfffe
	MULS	#$002e,D0		;4826c: c1fc002e
	LEA	(LAB_51922,A4),A0	;48270: 41ec8534
	ADD.L	A0,D0			;48274: d088
	MOVE.L	D0,-(A7)		;48276: 2f00
	JSR	(___strcpy,A4)		;48278: 4eac81a0
	ADDQ.W	#8,A7			;4827c: 504f
LAB_4827E:
	CMPI.W	#$0001,(-2,A5)		;4827e: 0c6d0001fffe
	BLT.S	LAB_482C2		;48284: 6d3c
	CMPI.W	#$000a,(-2,A5)		;48286: 0c6d000afffe
	BGE.S	LAB_482C2		;4828c: 6c34
	MOVE.W	(8,A5),D0		;4828e: 302d0008
	MULS	#$002e,D0		;48292: c1fc002e
	LEA	(LAB_516B2,A4),A0	;48296: 41ec82c4
	MOVE.W	(0,A0,D0.L),D1		;4829a: 32300800
	AND.W	(-4,A5),D1		;4829e: c26dfffc
	BEQ.S	LAB_482A8		;482a2: 6704
	MOVEQ	#1,D0			;482a4: 7001
	BRA.S	LAB_482AA		;482a6: 6002
LAB_482A8:
	MOVEQ	#0,D0			;482a8: 7000
LAB_482AA:
	ADD.W	#$0080,D0		;482aa: d07c0080
	MOVE.W	(-2,A5),D1		;482ae: 322dfffe
	MULS	#$002e,D1		;482b2: c3fc002e
	LEA	(LAB_51916,A4),A0	;482b6: 41ec8528
	MOVE.B	D0,(0,A0,D1.L)		;482ba: 11801800
	ASL	(-4,A5)			;482be: e1edfffc
LAB_482C2:
	MOVE.W	(-2,A5),D0		;482c2: 302dfffe
	MULS	#$002e,D0		;482c6: c1fc002e
	LEA	(LAB_51916,A4),A0	;482ca: 41ec8528
	ADD.L	A0,D0			;482ce: d088
	MOVE.L	D0,-(A7)		;482d0: 2f00
	MOVE.W	(-2,A5),D0		;482d2: 302dfffe
	MULS	#$002e,D0		;482d6: c1fc002e
	LEA	(LAB_51912,A4),A0	;482da: 41ec8524
	MOVE.W	(0,A0,D0.L),D1		;482de: 32300800
	ADD.W	#$0010,D1		;482e2: d27c0010
	MOVE.W	D1,-(A7)		;482e6: 3f01
	MOVE.W	(-2,A5),D0		;482e8: 302dfffe
	MULS	#$002e,D0		;482ec: c1fc002e
	LEA	(_option_text,A4),A0	;482f0: 41ec8522
	MOVE.W	(0,A0,D0.L),D1		;482f4: 32300800
	ADD.W	#$0010,D1		;482f8: d27c0010
	MOVE.W	D1,-(A7)		;482fc: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;482fe: 2f2c99ec
	JSR	(___text,A4)		;48302: 4eac813a
	LEA	($C,A7),A7		;48306: 4fef000c
	CMPI.W	#$000b,(-2,A5)		;4830a: 0c6d000bfffe
	BNE.S	LAB_48362		;48310: 6650
	PEA	(-6,A5)			;48312: 486dfffa
	MOVE.W	(-2,A5),D0		;48316: 302dfffe
	MULS	#$002e,D0		;4831a: c1fc002e
	LEA	(LAB_51912,A4),A0	;4831e: 41ec8524
	MOVE.W	(0,A0,D0.L),D1		;48322: 32300800
	ADD.W	#$0010,D1		;48326: d27c0010
	MOVE.W	D1,-(A7)		;4832a: 3f01
	MOVE.W	(8,A5),D0		;4832c: 302d0008
	MULS	#$002e,D0		;48330: c1fc002e
	LEA	(LAB_516B0,A4),A0	;48334: 41ec82c2
	MOVE.W	(0,A0,D0.L),D1		;48338: 32300800
	ASL.W	#3,D1			;4833c: e741
	MOVE.W	(-2,A5),D0		;4833e: 302dfffe
	MULS	#$002e,D0		;48342: c1fc002e
	LEA	(_option_text,A4),A0	;48346: 41ec8522
	ADD.W	(0,A0,D0.L),D1		;4834a: d2700800
	ADD.W	#$0028,D1		;4834e: d27c0028
	MOVE.W	D1,-(A7)		;48352: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;48354: 2f2c99ec
	JSR	(___text,A4)		;48358: 4eac813a
	LEA	($C,A7),A7		;4835c: 4fef000c
	BRA.S	LAB_483B8		;48360: 6056
LAB_48362:
	CMPI.W	#$000d,(-2,A5)		;48362: 0c6d000dfffe
	BNE.S	LAB_483B8		;48368: 664e
	PEA	(-6,A5)			;4836a: 486dfffa
	MOVE.W	(-2,A5),D0		;4836e: 302dfffe
	MULS	#$002e,D0		;48372: c1fc002e
	LEA	(LAB_51912,A4),A0	;48376: 41ec8524
	MOVE.W	(0,A0,D0.L),D1		;4837a: 32300800
	ADD.W	#$0010,D1		;4837e: d27c0010
	MOVE.W	D1,-(A7)		;48382: 3f01
	MOVE.W	(8,A5),D0		;48384: 302d0008
	MULS	#$002e,D0		;48388: c1fc002e
	LEA	(LAB_516B4,A4),A0	;4838c: 41ec82c6
	MOVE.W	(0,A0,D0.L),D1		;48390: 32300800
	ASL.W	#3,D1			;48394: e741
	MOVE.W	(-2,A5),D0		;48396: 302dfffe
	MULS	#$002e,D0		;4839a: c1fc002e
	LEA	(_option_text,A4),A0	;4839e: 41ec8522
	ADD.W	(0,A0,D0.L),D1		;483a2: d2700800
	ADD.W	#$0030,D1		;483a6: d27c0030
	MOVE.W	D1,-(A7)		;483aa: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;483ac: 2f2c99ec
	JSR	(___text,A4)		;483b0: 4eac813a
	LEA	($C,A7),A7		;483b4: 4fef000c
LAB_483B8:
	ADDQ.W	#1,(-2,A5)		;483b8: 526dfffe
LAB_483BC:
	CMPI.W	#$000e,(-2,A5)		;483bc: 0c6d000efffe
	BLT.W	LAB_4823C		;483c2: 6d00fe78
LAB_483C6:
	TST.W	(_left_button,A4)	;483c6: 4a6cae62
	BEQ.S	LAB_483CE		;483ca: 6702
	BRA.S	LAB_483C6		;483cc: 60f8
LAB_483CE:
	MOVE.W	#$0001,(-2,A5)		;483ce: 3b7c0001fffe
LAB_483D4:
	MOVE.W	(-2,A5),D0		;483d4: 302dfffe
	MULS	#$002e,D0		;483d8: c1fc002e
	LEA	(_option_text,A4),A0	;483dc: 41ec8522
	MOVE.W	(0,A0,D0.L),D1		;483e0: 32300800
	ADD.W	#$0010,D1		;483e4: d27c0010
	MOVE.W	(_mousex,A4),D0		;483e8: 302c99aa
	CMP.W	D1,D0			;483ec: b041
	BLT.S	LAB_48456		;483ee: 6d66
	MOVE.W	(-2,A5),D0		;483f0: 302dfffe
	MULS	#$002e,D0		;483f4: c1fc002e
	LEA	(_option_text,A4),A0	;483f8: 41ec8522
	MOVE.W	(-2,A5),D1		;483fc: 322dfffe
	MULS	#$002e,D1		;48400: c3fc002e
	LEA	(LAB_51914,A4),A1	;48404: 43ec8526
	MOVE.W	(0,A0,D0.L),D2		;48408: 34300800
	ADD.W	(0,A1,D1.L),D2		;4840c: d4711800
	ADD.W	#$0010,D2		;48410: d47c0010
	MOVE.W	(_mousex,A4),D0		;48414: 302c99aa
	CMP.W	D2,D0			;48418: b042
	BGT.S	LAB_48456		;4841a: 6e3a
	MOVE.W	(-2,A5),D0		;4841c: 302dfffe
	MULS	#$002e,D0		;48420: c1fc002e
	LEA	(LAB_51912,A4),A0	;48424: 41ec8524
	MOVE.W	(0,A0,D0.L),D1		;48428: 32300800
	ADD.W	#$0010,D1		;4842c: d27c0010
	MOVE.W	(_mousey,A4),D0		;48430: 302cae6e
	CMP.W	D1,D0			;48434: b041
	BLT.S	LAB_48456		;48436: 6d1e
	MOVE.W	(-2,A5),D0		;48438: 302dfffe
	MULS	#$002e,D0		;4843c: c1fc002e
	LEA	(LAB_51912,A4),A0	;48440: 41ec8524
	MOVE.W	(0,A0,D0.L),D1		;48444: 32300800
	ADD.W	#$0018,D1		;48448: d27c0018
	MOVE.W	(_mousey,A4),D0		;4844c: 302cae6e
	CMP.W	D1,D0			;48450: b041
	BGT.S	LAB_48456		;48452: 6e02
	BRA.S	LAB_48464		;48454: 600e
LAB_48456:
	ADDQ.W	#1,(-2,A5)		;48456: 526dfffe
	CMPI.W	#$000e,(-2,A5)		;4845a: 0c6d000efffe
	BLT.W	LAB_483D4		;48460: 6d00ff72
LAB_48464:
	CMPI.W	#$ffff,(_in_conquest,A4) ;48464: 0c6cffff84ba
	BNE.W	LAB_48536		;4846a: 660000ca
	CMPI.W	#$000a,(-2,A5)		;4846e: 0c6d000afffe
	BGE.S	LAB_4849C		;48474: 6c26
	MOVE.W	(-2,A5),D0		;48476: 302dfffe
	SUBQ.W	#1,D0			;4847a: 5340
	MOVEQ	#1,D1			;4847c: 7201
	ASL.W	D0,D1			;4847e: e161
	MOVE.W	D1,(-2,A5)		;48480: 3b41fffe
	MOVE.W	(8,A5),D0		;48484: 302d0008
	MULS	#$002e,D0		;48488: c1fc002e
	LEA	(LAB_516B2,A4),A0	;4848c: 41ec82c4
	ADDA.L	D0,A0			;48490: d1c0
	MOVE.W	(-2,A5),D0		;48492: 302dfffe
	EOR.W	D0,(A0)			;48496: b150
	BRA.W	LAB_48536		;48498: 6000009c
LAB_4849C:
	CMPI.W	#$000b,(-2,A5)		;4849c: 0c6d000bfffe
	BNE.S	LAB_484EA		;484a2: 6646
	MOVE.W	(-2,A5),D0		;484a4: 302dfffe
	MULS	#$002e,D0		;484a8: c1fc002e
	LEA	(_option_text,A4),A0	;484ac: 41ec8522
	MOVE.W	(0,A0,D0.L),D1		;484b0: 32300800
	ADD.W	#$0028,D1		;484b4: d27c0028
	MOVE.W	(_mousex,A4),D0		;484b8: 302c99aa
	SUB.W	D1,D0			;484bc: 9041
	EXT.L	D0			;484be: 48c0
	DIVS	#$0008,D0		;484c0: 81fc0008
	MOVE.W	D0,(-4,A5)		;484c4: 3b40fffc
	TST.W	(-4,A5)			;484c8: 4a6dfffc
	BLT.S	LAB_484E8		;484cc: 6d1a
	CMPI.W	#$0009,(-4,A5)		;484ce: 0c6d0009fffc
	BGT.S	LAB_484E8		;484d4: 6e12
	MOVE.W	(8,A5),D0		;484d6: 302d0008
	MULS	#$002e,D0		;484da: c1fc002e
	LEA	(LAB_516B0,A4),A0	;484de: 41ec82c2
	MOVE.W	(-4,A5),(0,A0,D0.L)	;484e2: 31adfffc0800
LAB_484E8:
	BRA.S	LAB_48536		;484e8: 604c
LAB_484EA:
	CMPI.W	#$000d,(-2,A5)		;484ea: 0c6d000dfffe
	BNE.S	LAB_48536		;484f0: 6644
	MOVE.W	(-2,A5),D0		;484f2: 302dfffe
	MULS	#$002e,D0		;484f6: c1fc002e
	LEA	(_option_text,A4),A0	;484fa: 41ec8522
	MOVE.W	(0,A0,D0.L),D1		;484fe: 32300800
	ADD.W	#$0030,D1		;48502: d27c0030
	MOVE.W	(_mousex,A4),D0		;48506: 302c99aa
	SUB.W	D1,D0			;4850a: 9041
	EXT.L	D0			;4850c: 48c0
	DIVS	#$0008,D0		;4850e: 81fc0008
	MOVE.W	D0,(-4,A5)		;48512: 3b40fffc
	TST.W	(-4,A5)			;48516: 4a6dfffc
	BLT.S	LAB_48536		;4851a: 6d1a
	CMPI.W	#$0009,(-4,A5)		;4851c: 0c6d0009fffc
	BGT.S	LAB_48536		;48522: 6e12
	MOVE.W	(8,A5),D0		;48524: 302d0008
	MULS	#$002e,D0		;48528: c1fc002e
	LEA	(LAB_516B4,A4),A0	;4852c: 41ec82c6
	MOVE.W	(-4,A5),(0,A0,D0.L)	;48530: 31adfffc0800
LAB_48536:
	PEA	(_end_cancel,A4)	;48536: 486c84f4
	PEA	(_end_ok,A4)		;4853a: 486c84c6
	JSR	(_check_cancel,PC)	;4853e: 4ebaea10
	ADDQ.W	#8,A7			;48542: 504f
	MOVE.W	D0,(-2,A5)		;48544: 3b40fffe
	BEQ.S	LAB_485B8		;48548: 676e
	CMPI.W	#$0002,(-2,A5)		;4854a: 0c6d0002fffe
	BNE.S	LAB_48572		;48550: 6620
	MOVE.W	(8,A5),D0		;48552: 302d0008
	MULS	#$002e,D0		;48556: c1fc002e
	MOVEA.L	D0,A0			;4855a: 2040
	LEA	(_stats,A4),A1		;4855c: 43ec82b6
	ADDA.L	A1,A0			;48560: d1c9
	LEA	(-56,A5),A1		;48562: 43edffc8
	MOVEQ	#$A,D0			;48566: 700a
LAB_48568:
	MOVE.L	(A1)+,(A0)+		;48568: 20d9
	DBF	D0,LAB_48568		;4856a: 51c8fffc
	MOVE.W	(A1)+,(A0)+		;4856e: 30d9
	BRA.S	LAB_485B6		;48570: 6044
LAB_48572:
	MOVE.W	(8,A5),D0		;48572: 302d0008
	MULS	#$002e,D0		;48576: c1fc002e
	LEA	(LAB_516B0,A4),A0	;4857a: 41ec82c2
	MOVE.W	(8,A5),D1		;4857e: 322d0008
	MULS	#$002e,D1		;48582: c3fc002e
	LEA	(LAB_516B0,A4),A1	;48586: 43ec82c2
	MOVEQ	#$A,D2			;4858a: 740a
	SUB.W	(0,A1,D1.L),D2		;4858c: 94711800
	MOVE.W	D2,(0,A0,D0.L)		;48590: 31820800
	MOVE.W	(8,A5),D0		;48594: 302d0008
	MULS	#$002e,D0		;48598: c1fc002e
	LEA	(LAB_516B4,A4),A0	;4859c: 41ec82c6
	MOVE.W	(8,A5),D1		;485a0: 322d0008
	MULS	#$002e,D1		;485a4: c3fc002e
	LEA	(LAB_516B4,A4),A1	;485a8: 43ec82c6
	MOVEQ	#$A,D2			;485ac: 740a
	SUB.W	(0,A1,D1.L),D2		;485ae: 94711800
	MOVE.W	D2,(0,A0,D0.L)		;485b2: 31820800
LAB_485B6:
	BRA.S	LAB_485C0		;485b6: 6008
LAB_485B8:
	TST.W	(-2,A5)			;485b8: 4a6dfffe
	BEQ.W	LAB_48228		;485bc: 6700fc6a
LAB_485C0:
	BSR.S	_return_to_game		;485c0: 610e
	UNLK	A5			;485c2: 4e5d
	RTS				;485c4: 4e75
LAB_485C6:
	;485c6
	;DC.B	$47,$4f,$4f,$44,$00
	DC.B	"GOOD",0
LAB_485CB:
	;485cb
	;DC.B	$45,$56,$49,$4c,$00
	DC.B	"EVIL",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_return_to_game:
	LINK.W	A5,#-4			;485d0: 4e55fffc
	MOVE.L	(_d_screen,A4),-(A7)	;485d4: 2f2c99ec
	MOVE.L	(_w_screen,A4),-(A7)	;485d8: 2f2c99e8
	JSR	(___copy_screen,A4)	;485dc: 4eac80aa
	ADDQ.W	#8,A7			;485e0: 504f
	MOVE.W	#$0002,(_left_button,A4) ;485e2: 397c0002ae62
	UNLK	A5			;485e8: 4e5d
	RTS				;485ea: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_start_game:
	LINK.W	A5,#-2			;485ec: 4e55fffe
	JSR	(___CloseWorkBench,A4)	;485f0: 4eac8224
	JSR	(___open_channels,A4)	;485f4: 4eac815e
	PEA	(LAB_48690,PC)		;485f8: 487a0096
	JSR	(___load_sound,A4)	;485fc: 4eac816a
	ADDQ.W	#4,A7			;48600: 584f
	JSR	(_read_back_scr,PC)	;48602: 4eba1af4
	JSR	(___create_mouse,A4)	;48606: 4eac800e
	CMPI.W	#$0003,(_start_of_game,A4) ;4860a: 0c6c00039898
	BNE.S	LAB_48666		;48610: 6654
	LEA	(_stats,A4),A0		;48612: 41ec82b6
	LEA	(_tutorial,A4),A1	;48616: 43ec8312
	MOVEQ	#$A,D0			;4861a: 700a
LAB_4861C:
	MOVE.L	(A1)+,(A0)+		;4861c: 20d9
	DBF	D0,LAB_4861C		;4861e: 51c8fffc
	MOVE.W	(A1)+,(A0)+		;48622: 30d9
	LEA	(strABC,A4),A0		;48624: 41ec82e4
	LEA	(LAB_5172E,A4),A1	;48628: 43ec8340
	MOVEQ	#$A,D0			;4862c: 700a
LAB_4862E:
	MOVE.L	(A1)+,(A0)+		;4862e: 20d9
	DBF	D0,LAB_4862E		;48630: 51c8fffc
	MOVE.W	(A1)+,(A0)+		;48634: 30d9
	MOVE.W	#$0001,(_pause,A4)	;48636: 397c00019c22
	MOVE.W	#$17e4,-(A7)		;4863c: 3f3c17e4
	MOVE.W	#$0003,-(A7)		;48640: 3f3c0003
	MOVE.W	#$0001,-(A7)		;48644: 3f3c0001
	MOVE.L	(_back_scr,A4),-(A7)	;48648: 2f2c9874
	JSR	(___toggle_icon,A4)	;4864c: 4eac8122
	LEA	($A,A7),A7		;48650: 4fef000a
	MOVE.W	#$69bc,(_seed,A4)	;48654: 397c69bc99e2
	MOVE.W	#$69bc,(_start_seed,A4)	;4865a: 397c69bc99e4
	MOVE.W	(_tutorial_game_mode,A4),(_game_mode,A4) ;48660: 396c836e84b8
LAB_48666:
	MOVE.W	#$0001,(_pointer,A4)	;48666: 397c000184b6
	MOVE.W	#$0002,(_left_button,A4) ;4866c: 397c0002ae62
	MOVE.W	#$ffff,-(A7)		;48672: 3f3cffff
	MOVE.L	(_back_scr,A4),-(A7)	;48676: 2f2c9874
	MOVE.L	(_back_scr,A4),-(A7)	;4867a: 2f2c9874
	JSR	(___Setscreen,A4)	;4867e: 4eac80c2
	LEA	($A,A7),A7		;48682: 4fef000a
	MOVE.L	(_the_prot4,A4),(___the_prot5,A4) ;48686: 296c309c819a
	UNLK	A5			;4868c: 4e5d
	RTS				;4868e: 4e75
LAB_48690:
	;48690
	;DC.B	$67,$6d,$75,$73,$69,$63,$31,$00
	DC.B	"gmusic1",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_end_game:
	LINK.W	A5,#-80			;48698: 4e55ffb0
	CLR.W	(-2,A5)			;4869c: 426dfffe
LAB_486A0:
	MOVEQ	#0,D0			;486a0: 7000
	MOVE.W	(-2,A5),D0		;486a2: 302dfffe
	BRA.W	LAB_489DA		;486a6: 60000332
LAB_486AA:
	CMPI.W	#$0001,(8,A5)		;486aa: 0c6d00010008
	BNE.S	LAB_486CE		;486b0: 661c
	PEA	(strLost,PC)		;486b2: 487a04d8
	MOVE.W	(-2,A5),D0		;486b6: 302dfffe
	MULU	#$002e,D0		;486ba: c0fc002e
	LEA	(strLOST,A4),A0		;486be: 41ec8e89
	ADD.L	A0,D0			;486c2: d088
	MOVE.L	D0,-(A7)		;486c4: 2f00
	JSR	(___strcpy,A4)		;486c6: 4eac81a0
	ADDQ.W	#8,A7			;486ca: 504f
	BRA.S	LAB_486E8		;486cc: 601a
LAB_486CE:
	PEA	(strWon,PC)		;486ce: 487a04c1
	MOVE.W	(-2,A5),D0		;486d2: 302dfffe
	MULU	#$002e,D0		;486d6: c0fc002e
	LEA	(strLOST,A4),A0		;486da: 41ec8e89
	ADD.L	A0,D0			;486de: d088
	MOVE.L	D0,-(A7)		;486e0: 2f00
	JSR	(___strcpy,A4)		;486e2: 4eac81a0
	ADDQ.W	#8,A7			;486e6: 504f
LAB_486E8:
	BRA.W	LAB_489EC		;486e8: 60000302
LAB_486EC:
	MOVE.W	(_player,A4),D0		;486ec: 302c99f4
	EXT.L	D0			;486f0: 48c0
	ASL.L	#1,D0			;486f2: e380
	LEA	(_battle_won,A4),A0	;486f4: 41ecae7a
	MOVE.W	(0,A0,D0.L),-(A7)	;486f8: 3f300800
	PEA	(-70,A5)		;486fc: 486dffba
	JSR	(___word_asc,A4)	;48700: 4eac818e
	ADDQ.W	#6,A7			;48704: 5c4f
	MOVE.W	(_not_player,A4),D0	;48706: 302c825a
	EXT.L	D0			;4870a: 48c0
	ASL.L	#1,D0			;4870c: e380
	LEA	(_battle_won,A4),A0	;4870e: 41ecae7a
	MOVE.W	(0,A0,D0.L),-(A7)	;48712: 3f300800
	PEA	(-80,A5)		;48716: 486dffb0
	JSR	(___word_asc,A4)	;4871a: 4eac818e
	ADDQ.W	#6,A7			;4871e: 5c4f
	BRA.W	LAB_489EC		;48720: 600002ca
LAB_48724:
	CLR.L	(-10,A5)		;48724: 42adfff6
	CLR.L	(-14,A5)		;48728: 42adfff2
	CLR.W	(-4,A5)			;4872c: 426dfffc
	BRA.S	LAB_4877C		;48730: 604a
LAB_48732:
	MOVE.W	(-4,A5),D0		;48732: 302dfffc
	MULU	#$0016,D0		;48736: c0fc0016
	LEA	(LAB_53022,A4),A0	;4873a: 41ec9c34
	TST.L	(0,A0,D0.L)		;4873e: 4ab00800
	BEQ.S	LAB_48778		;48742: 6734
	MOVE.W	(-4,A5),D0		;48744: 302dfffc
	MULU	#$0016,D0		;48748: c0fc0016
	LEA	(LAB_53018,A4),A0	;4874c: 41ec9c2a
	TST.W	(0,A0,D0.L)		;48750: 4a700800
	BEQ.S	LAB_48778		;48754: 6722
	MOVE.W	(-4,A5),D0		;48756: 302dfffc
	MULU	#$0016,D0		;4875a: c0fc0016
	LEA	(LAB_53015,A4),A0	;4875e: 41ec9c27
	MOVEQ	#0,D1			;48762: 7200
	MOVE.B	(0,A0,D0.L),D1		;48764: 12300800
	CMP.W	(_player,A4),D1		;48768: b26c99f4
	BNE.S	LAB_48774		;4876c: 6606
	ADDQ.L	#1,(-14,A5)		;4876e: 52adfff2
	BRA.S	LAB_48778		;48772: 6004
LAB_48774:
	ADDQ.L	#1,(-10,A5)		;48774: 52adfff6
LAB_48778:
	ADDQ.W	#1,(-4,A5)		;48778: 526dfffc
LAB_4877C:
	MOVE.W	(-4,A5),D0		;4877c: 302dfffc
	CMP.W	(_no_peeps,A4),D0	;48780: b06cae5e
	BCS.S	LAB_48732		;48784: 65ac
	MOVE.W	(-12,A5),-(A7)		;48786: 3f2dfff4
	PEA	(-70,A5)		;4878a: 486dffba
	JSR	(___word_asc,A4)	;4878e: 4eac818e
	ADDQ.W	#6,A7			;48792: 5c4f
	MOVE.W	(-8,A5),-(A7)		;48794: 3f2dfff8
	PEA	(-80,A5)		;48798: 486dffb0
	JSR	(___word_asc,A4)	;4879c: 4eac818e
	ADDQ.W	#6,A7			;487a0: 5c4f
	BRA.W	LAB_489EC		;487a2: 60000248
LAB_487A6:
	CLR.L	(-10,A5)		;487a6: 42adfff6
	CLR.L	(-14,A5)		;487aa: 42adfff2
	CLR.W	(-4,A5)			;487ae: 426dfffc
	BRA.S	LAB_48814		;487b2: 6060
LAB_487B4:
	MOVE.W	(-4,A5),D0		;487b4: 302dfffc
	MULU	#$0016,D0		;487b8: c0fc0016
	LEA	(_peeps,A4),A0		;487bc: 41ec9c26
	CMPI.B	#$01,(0,A0,D0.L)	;487c0: 0c3000010800
	BNE.S	LAB_48810		;487c6: 6648
	MOVE.W	(-4,A5),D0		;487c8: 302dfffc
	MULU	#$0016,D0		;487cc: c0fc0016
	LEA	(LAB_53018,A4),A0	;487d0: 41ec9c2a
	TST.W	(0,A0,D0.L)		;487d4: 4a700800
	BEQ.S	LAB_48810		;487d8: 6736
	MOVE.W	(-4,A5),D0		;487da: 302dfffc
	MULU	#$0016,D0		;487de: c0fc0016
	LEA	(LAB_53020,A4),A0	;487e2: 41ec9c32
	CMPI.W	#$002a,(0,A0,D0.L)	;487e6: 0c70002a0800
	BEQ.S	LAB_48810		;487ec: 6722
	MOVE.W	(-4,A5),D0		;487ee: 302dfffc
	MULU	#$0016,D0		;487f2: c0fc0016
	LEA	(LAB_53015,A4),A0	;487f6: 41ec9c27
	MOVEQ	#0,D1			;487fa: 7200
	MOVE.B	(0,A0,D0.L),D1		;487fc: 12300800
	CMP.W	(_player,A4),D1		;48800: b26c99f4
	BNE.S	LAB_4880C		;48804: 6606
	ADDQ.L	#1,(-14,A5)		;48806: 52adfff2
	BRA.S	LAB_48810		;4880a: 6004
LAB_4880C:
	ADDQ.L	#1,(-10,A5)		;4880c: 52adfff6
LAB_48810:
	ADDQ.W	#1,(-4,A5)		;48810: 526dfffc
LAB_48814:
	MOVE.W	(-4,A5),D0		;48814: 302dfffc
	CMP.W	(_no_peeps,A4),D0	;48818: b06cae5e
	BCS.S	LAB_487B4		;4881c: 6596
	MOVE.W	(-12,A5),-(A7)		;4881e: 3f2dfff4
	PEA	(-70,A5)		;48822: 486dffba
	JSR	(___word_asc,A4)	;48826: 4eac818e
	ADDQ.W	#6,A7			;4882a: 5c4f
	MOVE.W	(-8,A5),-(A7)		;4882c: 3f2dfff8
	PEA	(-80,A5)		;48830: 486dffb0
	JSR	(___word_asc,A4)	;48834: 4eac818e
	ADDQ.W	#6,A7			;48838: 5c4f
	BRA.W	LAB_489EC		;4883a: 600001b0
LAB_4883E:
	CLR.L	(-10,A5)		;4883e: 42adfff6
	CLR.L	(-14,A5)		;48842: 42adfff2
	CLR.W	(-4,A5)			;48846: 426dfffc
	BRA.S	LAB_488AC		;4884a: 6060
LAB_4884C:
	MOVE.W	(-4,A5),D0		;4884c: 302dfffc
	MULU	#$0016,D0		;48850: c0fc0016
	LEA	(_peeps,A4),A0		;48854: 41ec9c26
	CMPI.B	#$01,(0,A0,D0.L)	;48858: 0c3000010800
	BNE.S	LAB_488A8		;4885e: 6648
	MOVE.W	(-4,A5),D0		;48860: 302dfffc
	MULU	#$0016,D0		;48864: c0fc0016
	LEA	(LAB_53018,A4),A0	;48868: 41ec9c2a
	TST.W	(0,A0,D0.L)		;4886c: 4a700800
	BEQ.S	LAB_488A8		;48870: 6736
	MOVE.W	(-4,A5),D0		;48872: 302dfffc
	MULU	#$0016,D0		;48876: c0fc0016
	LEA	(LAB_53020,A4),A0	;4887a: 41ec9c32
	CMPI.W	#$002a,(0,A0,D0.L)	;4887e: 0c70002a0800
	BNE.S	LAB_488A8		;48884: 6622
	MOVE.W	(-4,A5),D0		;48886: 302dfffc
	MULU	#$0016,D0		;4888a: c0fc0016
	LEA	(LAB_53015,A4),A0	;4888e: 41ec9c27
	MOVEQ	#0,D1			;48892: 7200
	MOVE.B	(0,A0,D0.L),D1		;48894: 12300800
	CMP.W	(_player,A4),D1		;48898: b26c99f4
	BNE.S	LAB_488A4		;4889c: 6606
	ADDQ.L	#1,(-14,A5)		;4889e: 52adfff2
	BRA.S	LAB_488A8		;488a2: 6004
LAB_488A4:
	ADDQ.L	#1,(-10,A5)		;488a4: 52adfff6
LAB_488A8:
	ADDQ.W	#1,(-4,A5)		;488a8: 526dfffc
LAB_488AC:
	MOVE.W	(-4,A5),D0		;488ac: 302dfffc
	CMP.W	(_no_peeps,A4),D0	;488b0: b06cae5e
	BCS.S	LAB_4884C		;488b4: 6596
	MOVE.W	(-12,A5),-(A7)		;488b6: 3f2dfff4
	PEA	(-70,A5)		;488ba: 486dffba
	JSR	(___word_asc,A4)	;488be: 4eac818e
	ADDQ.W	#6,A7			;488c2: 5c4f
	MOVE.W	(-8,A5),-(A7)		;488c4: 3f2dfff8
	PEA	(-80,A5)		;488c8: 486dffb0
	JSR	(___word_asc,A4)	;488cc: 4eac818e
	ADDQ.W	#6,A7			;488d0: 5c4f
	MOVE.L	(-14,A5),(-10,A5)	;488d2: 2b6dfff2fff6
	BRA.W	LAB_489EC		;488d8: 60000112
LAB_488DC:
	MOVE.W	(_player,A4),D0		;488dc: 302c99f4
	EXT.L	D0			;488e0: 48c0
	ASL.L	#1,D0			;488e2: e380
	LEA	(_battle_won,A4),A0	;488e4: 41ecae7a
	MOVE.W	(_not_player,A4),D1	;488e8: 322c825a
	EXT.L	D1			;488ec: 48c1
	ASL.L	#1,D1			;488ee: e381
	LEA	(_battle_won,A4),A1	;488f0: 43ecae7a
	MOVE.W	(0,A0,D0.L),D2		;488f4: 34300800
	CMP.W	(0,A1,D1.L),D2		;488f8: b4711800
	BLE.S	LAB_48906		;488fc: 6f08
; +5000 points for winning armageddon?
	ADDI.L	#$00001388,(_score,A4)	;488fe: 06ac00001388ae72
LAB_48906:
	MOVE.W	#$0008,(-4,A5)		;48906: 3b7c0008fffc
LAB_4890C:
	MOVE.W	(_player,A4),D0		;4890c: 302c99f4
	MULS	#$002e,D0		;48910: c1fc002e
	LEA	(LAB_516B2,A4),A0	;48914: 41ec82c4
	MOVE.W	(0,A0,D0.L),D1		;48918: 32300800
	AND.W	(-4,A5),D1		;4891c: c26dfffc
	BNE.S	LAB_4892A		;48920: 6608
; +5000 points for ?
	ADDI.L	#$000003e8,(_score,A4)	;48922: 06ac000003e8ae72
LAB_4892A:
	MOVE.W	(_not_player,A4),D0	;4892a: 302c825a
	MULS	#$002e,D0		;4892e: c1fc002e
	LEA	(LAB_516B2,A4),A0	;48932: 41ec82c4
	MOVE.W	(0,A0,D0.L),D1		;48936: 32300800
	AND.W	(-4,A5),D1		;4893a: c26dfffc
	BEQ.S	LAB_48948		;4893e: 6708
; +5000 points for?
	ADDI.L	#$000003e8,(_score,A4)	;48940: 06ac000003e8ae72
LAB_48948:
	ASL	(-4,A5)			;48948: e1edfffc
	CMPI.W	#$0100,(-4,A5)		;4894c: 0c6d0100fffc
	BLS.S	LAB_4890C		;48952: 63b8
	TST.W	(_serial_off,A4)	;48954: 4a6c8254
	BEQ.S	LAB_48976		;48958: 671c
	MOVEQ	#$A,D0			;4895a: 700a
	MOVE.W	(_not_player,A4),D1	;4895c: 322c825a
	MULS	#$002e,D1		;48960: c3fc002e
	LEA	(LAB_516B4,A4),A0	;48964: 41ec82c6
	SUB.W	(0,A0,D1.L),D0		;48968: 90701800
; +15 points per ?
	MULS	#$000f,D0		;4896c: c1fc000f
	EXT.L	D0			;48970: 48c0
	ADD.L	D0,(_score,A4)		;48972: d1acae72
LAB_48976:
	TST.W	(8,A5)			;48976: 4a6d0008
	BNE.S	LAB_4898A		;4897a: 660e
	MOVEQ	#$A,D1			;4897c: 720a
; x10 points for winning
	MOVE.L	(_score,A4),D0		;4897e: 202cae72
	JSR	(___mulu,A4)		;48982: 4eac81c4
	MOVE.L	D0,(_score,A4)		;48986: 2940ae72
LAB_4898A:
; Minimum points 500
	CMPI.L	#$000001f4,(_score,A4)	;4898a: 0cac000001f4ae72
	BGE.S	LAB_4899C		;48992: 6c08
	MOVE.L	#$000001f4,(_score,A4)	;48994: 297c000001f4ae72
LAB_4899C:
; maximum points: if over 555,555, capped at 515,090
	CMPI.L	#$00087a23,(_score,A4)	;4899c: 0cac00087a23ae72
	BLE.S	LAB_489AE		;489a4: 6f08
	MOVE.L	#$0007dc12,(_score,A4)	;489a6: 297c0007dc12ae72
LAB_489AE:
	MOVE.L	(_score,A4),-(A7)	;489ae: 2f2cae72
	MOVE.W	(-2,A5),D0		;489b2: 302dfffe
	MULU	#$002e,D0		;489b6: c0fc002e
	LEA	(strScoreboard,A4),A0	;489ba: 41ec8e97
	ADD.L	A0,D0			;489be: d088
	MOVE.L	D0,-(A7)		;489c0: 2f00
	JSR	(___long_asc,A4)	;489c2: 4eac8188
	ADDQ.W	#8,A7			;489c6: 504f
	BRA.S	LAB_489EC		;489c8: 6022
LAB_489CA:
	BRA.S	LAB_489EC		;489ca: 6020
LAB_489CC:
	DC.W	(LAB_486AA)-(LAB_489E8+2) ;489cc: fcc0
	DC.W	(LAB_489CA)-(LAB_489E8+2) ;489ce: ffe0
	DC.W	(LAB_486EC)-(LAB_489E8+2) ;489d0: fd02
	DC.W	(LAB_48724)-(LAB_489E8+2) ;489d2: fd3a
	DC.W	(LAB_487A6)-(LAB_489E8+2) ;489d4: fdbc
	DC.W	(LAB_4883E)-(LAB_489E8+2) ;489d6: fe54
	DC.W	(LAB_488DC)-(LAB_489E8+2) ;489d8: fef2
LAB_489DA:
	CMP.L	#$00000007,D0		;489da: b0bc00000007
	BCC.S	LAB_489CA		;489e0: 64e8
	ASL.L	#1,D0			;489e2: e380
	MOVE.W	(LAB_489CC,PC,D0.W),D0	;489e4: 303b00e6
LAB_489E8:
	JMP	(LAB_489E8+2,PC,D0.W)	;489e8: 4efb0000
LAB_489EC:
	CMPI.W	#$0002,(-2,A5)		;489ec: 0c6d0002fffe
	BCS.S	LAB_48A6A		;489f2: 6576
	CMPI.W	#$0005,(-2,A5)		;489f4: 0c6d0005fffe
	BHI.S	LAB_48A6A		;489fa: 626e
	PEA	(-70,A5)		;489fc: 486dffba
	JSR	(___strlen,A4)		;48a00: 4eac81a6
	ADDQ.W	#4,A7			;48a04: 584f
	MOVE.W	D0,(-4,A5)		;48a06: 3b40fffc
	BRA.S	LAB_48A20		;48a0a: 6014
LAB_48A0C:
	MOVEQ	#0,D0			;48a0c: 7000
	MOVE.W	(-4,A5),D0		;48a0e: 302dfffc
	LEA	(-70,A5),A0		;48a12: 41edffba
	MOVE.B	#$20,(0,A0,D0.L)	;48a16: 11bc00200800
	ADDQ.W	#1,(-4,A5)		;48a1c: 526dfffc
LAB_48A20:
	CMPI.W	#$0005,(-4,A5)		;48a20: 0c6d0005fffc
	BCS.S	LAB_48A0C		;48a26: 65e4
	MOVEQ	#0,D0			;48a28: 7000
	MOVE.W	(-4,A5),D0		;48a2a: 302dfffc
	LEA	(-70,A5),A0		;48a2e: 41edffba
	CLR.B	(0,A0,D0.L)		;48a32: 42300800
	PEA	(-70,A5)		;48a36: 486dffba
	MOVE.W	(-2,A5),D0		;48a3a: 302dfffe
	MULU	#$002e,D0		;48a3e: c0fc002e
	LEA	(strScoreboard,A4),A0	;48a42: 41ec8e97
	ADD.L	A0,D0			;48a46: d088
	MOVE.L	D0,-(A7)		;48a48: 2f00
	JSR	(___strcpy,A4)		;48a4a: 4eac81a0
	ADDQ.W	#8,A7			;48a4e: 504f
	PEA	(-80,A5)		;48a50: 486dffb0
	MOVE.W	(-2,A5),D0		;48a54: 302dfffe
	MULU	#$002e,D0		;48a58: c0fc002e
	LEA	(strScoreboard,A4),A0	;48a5c: 41ec8e97
	ADD.L	A0,D0			;48a60: d088
	MOVE.L	D0,-(A7)		;48a62: 2f00
	JSR	(___strcat,A4)		;48a64: 4eac81be
	ADDQ.W	#8,A7			;48a68: 504f
LAB_48A6A:
	ADDQ.W	#1,(-2,A5)		;48a6a: 526dfffe
	CMPI.W	#$0007,(-2,A5)		;48a6e: 0c6d0007fffe
	BCS.W	LAB_486A0		;48a74: 6500fc2a
	TST.W	(8,A5)			;48a78: 4a6d0008
	BEQ.S	LAB_48A96		;48a7c: 6718
	CMPI.W	#$ffff,(_in_conquest,A4) ;48a7e: 0c6cffff84ba
	BEQ.S	LAB_48A96		;48a84: 6710
	PEA	(strTryItAgain,PC)	;48a86: 487a010d
	PEA	(-54,A5)		;48a8a: 486dffca
	JSR	(___strcpy,A4)		;48a8e: 4eac81a0
	ADDQ.W	#8,A7			;48a92: 504f
	BRA.S	LAB_48AA4		;48a94: 600e
LAB_48A96:
	PEA	(strNew_Game,PC)	;48a96: 487a010a
	PEA	(-54,A5)		;48a9a: 486dffca
	JSR	(___strcpy,A4)		;48a9e: 4eac81a0
	ADDQ.W	#8,A7			;48aa2: 504f
LAB_48AA4:
	CLR.L	-(A7)			;48aa4: 42a7
	PEA	(-60,A5)		;48aa6: 486dffc4
	MOVE.W	#$00a6,-(A7)		;48aaa: 3f3c00a6
	MOVE.W	#$0120,-(A7)		;48aae: 3f3c0120
	MOVE.W	#$0010,-(A7)		;48ab2: 3f3c0010
	MOVE.W	#$0010,-(A7)		;48ab6: 3f3c0010
	MOVE.L	(_d_screen,A4),-(A7)	;48aba: 2f2c99ec
	JSR	(_requester,PC)		;48abe: 4ebac9c4
	LEA	($14,A7),A7		;48ac2: 4fef0014
	CLR.W	(-2,A5)			;48ac6: 426dfffe
LAB_48ACA:
	MOVE.W	(-2,A5),D0		;48aca: 302dfffe
	MULU	#$002e,D0		;48ace: c0fc002e
	LEA	(strGAME_,A4),A0	;48ad2: 41ec8e84
	ADD.L	A0,D0			;48ad6: d088
	MOVE.L	D0,-(A7)		;48ad8: 2f00
	MOVE.W	(-2,A5),D0		;48ada: 302dfffe
	MULU	#$002e,D0		;48ade: c0fc002e
	LEA	(LAB_5226E,A4),A0	;48ae2: 41ec8e80
	MOVE.W	(0,A0,D0.L),D1		;48ae6: 32300800
	ADD.W	#$0010,D1		;48aea: d27c0010
	MOVE.W	D1,-(A7)		;48aee: 3f01
	MOVE.W	(-2,A5),D0		;48af0: 302dfffe
	MULU	#$002e,D0		;48af4: c0fc002e
	LEA	(_end_text,A4),A0	;48af8: 41ec8e7e
	MOVE.W	(0,A0,D0.L),D1		;48afc: 32300800
	ADD.W	#$0010,D1		;48b00: d27c0010
	MOVE.W	D1,-(A7)		;48b04: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;48b06: 2f2c99ec
	JSR	(___text,A4)		;48b0a: 4eac813a
	LEA	($C,A7),A7		;48b0e: 4fef000c
	ADDQ.W	#1,(-2,A5)		;48b12: 526dfffe
	CMPI.W	#$0007,(-2,A5)		;48b16: 0c6d0007fffe
	BCS.S	LAB_48ACA		;48b1c: 65ac
LAB_48B1E:
	MOVE.W	#$0002,(_left_button,A4) ;48b1e: 397c0002ae62
LAB_48B24:
	TST.W	(_left_button,A4)	;48b24: 4a6cae62
	BEQ.S	LAB_48B2C		;48b28: 6702
	BRA.S	LAB_48B24		;48b2a: 60f8
LAB_48B2C:
	CLR.L	-(A7)			;48b2c: 42a7
	PEA	(-60,A5)		;48b2e: 486dffc4
	JSR	(_check_cancel,PC)	;48b32: 4ebae41c
	ADDQ.W	#8,A7			;48b36: 504f
	TST.W	D0			;48b38: 4a40
	BNE.S	LAB_48B3E		;48b3a: 6602
	BRA.S	LAB_48B1E		;48b3c: 60e0
; ------------------------------------------------------------------------------
; lines cut here. original: 397c 00001 8e12
; ------------------------------------------------------------------------------
LAB_48B3E:
	TST.W	(8,A5)			;48b3e: 4a6d0008
	BNE.S	LAB_48B54		;48b42: 6610
	CMPI.W	#$ffff,(_in_conquest,A4) ;48b44: 0c6cffff84ba
	BEQ.S	LAB_48B54		;48b4a: 6708
	MOVE.L	(_score,A4),-(A7)	;48b4c: 2f2cae72
; ------------------------------------------------------------------------------
; Several lines removed from original build here
; ------------------------------------------------------------------------------
	BSR.S	_won_conquest		;48b50: 615a
	ADDQ.W	#4,A7			;48b52: 584f
; ------------------------------------------------------------------------------
; Conquest changes end
; ------------------------------------------------------------------------------
LAB_48B54:
	MOVE.W	(_player,A4),D0		;48b54: 302c99f4
	MULS	#$002e,D0		;48b58: c1fc002e
	LEA	(LAB_516AA,A4),A0	;48b5c: 41ec82bc
	CLR.W	(0,A0,D0.L)		;48b60: 42700800
	MOVE.L	(_d_screen,A4),-(A7)	;48b64: 2f2c99ec
	MOVE.L	(_w_screen,A4),-(A7)	;48b68: 2f2c99e8
	JSR	(___copy_screen,A4)	;48b6c: 4eac80aa
	ADDQ.W	#8,A7			;48b70: 504f
	MOVE.W	#$ffff,-(A7)		;48b72: 3f3cffff
	CLR.W	-(A7)			;48b76: 4267
	JSR	(___setup_display,A4)	;48b78: 4eac801a
	ADDQ.W	#4,A7			;48b7c: 584f
	CLR.W	(_go_protect,A4)	;48b7e: 426c8e4a
	MOVE.W	#$0002,(_left_button,A4) ;48b82: 397c0002ae62
; ------------------------------------------------------------------------------
; lines cut: 4a6c 3050 66a2
; ------------------------------------------------------------------------------
	UNLK	A5			;48b88: 4e5d
	RTS				;48b8a: 4e75
strLost:
	;48b8c
	;DC.B	$4c,$4f,$53,$54,$00
	DC.B	"LOST",0
strWon:
	DC.B	$57			;48b91
	DC.W	$4f4e			;48b92
	DS.B	1			;48b94
strTryItAgain:
	;48b95
	;DC.B	$54,$52,$59,$20,$49,$54,$20,$41,$47,$41,$49,$4e,$00
	DC.B	"TRY IT AGAIN",0
strNew_Game:
	;48ba2
	;DC.B	$4e,$45,$57,$20,$47,$41,$4d,$45,$00,$00
	DC.B	"NEW GAME",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_won_conquest:
	LINK.W	A5,#-122		;48bac: 4e55ff86
	CLR.W	(-122,A5)		;48bb0: 426dff86
	MOVE.W	(_level_number,A4),(-106,A5) ;48bb4: 3b6cae7eff96
; 5000
	MOVE.L	#$00001388,D1		;48bba: 223c00001388
	MOVE.L	(8,A5),D0		;48bc0: 202d0008
	JSR	(___divs,A4)		;48bc4: 4eac81ca
	ADDQ.L	#1,D0			;48bc8: 5280
	ADD.W	D0,(_level_number,A4)	;48bca: d16cae7e
	MOVE.W	(_level_number,A4),D0	;48bce: 302cae7e
; Presumably skips 1 level per 50,000 points
	EXT.L	D0			;48bd2: 48c0
	DIVS	#$0005,D0		;48bd4: 81fc0005
	SWAP	D0			;48bd8: 4840
	TST.W	D0			;48bda: 4a40
	BEQ.S	LAB_48BF2		;48bdc: 6714
	MOVE.W	(_level_number,A4),D0	;48bde: 302cae7e
	EXT.L	D0			;48be2: 48c0
	DIVS	#$0005,D0		;48be4: 81fc0005
	SWAP	D0			;48be8: 4840
	MOVEQ	#5,D1			;48bea: 7205
	SUB.W	D0,D1			;48bec: 9240
	ADD.W	D1,(_level_number,A4)	;48bee: d36cae7e
LAB_48BF2:
	CMPI.W	#$09a6,(_level_number,A4) ;48bf2: 0c6c09a6ae7e
	BLE.S	LAB_48C18		;48bf8: 6f1e
	CMPI.W	#$09a6,(-106,A5)	;48bfa: 0c6d09a6ff96
	BNE.S	LAB_48C12		;48c00: 6610
	CLR.W	(-106,A5)		;48c02: 426dff96
	CLR.W	(_level_number,A4)	;48c06: 426cae7e
	MOVE.W	#$0001,(-122,A5)	;48c0a: 3b7c0001ff86
	BRA.S	LAB_48C18		;48c10: 6006
LAB_48C12:
; Maximum level: WEAVUSPERT
	MOVE.W	#$09a6,(_level_number,A4) ;48c12: 397c09a6ae7e
LAB_48C18:
	MOVE.W	(_level_number,A4),(_seed,A4) ;48c18: 396cae7e99e2
	JSR	(___newrand,A4)		;48c1e: 4eac80fe
	MOVE.W	D0,-(A7)		;48c22: 3f00
	PEA	(_message,A4)		;48c24: 486c3058
	JSR	(_code,PC)		;48c28: 4eba03a4
	ADDQ.W	#6,A7			;48c2c: 5c4f
	MOVE.W	(_music_off,A4),(-116,A5) ;48c2e: 3b6c8250ff8c
	CLR.W	(_music_off,A4)		;48c34: 426c8250
	MOVE.W	(_effect_off,A4),(-118,A5) ;48c38: 3b6c8252ff8a
	CLR.W	(_effect_off,A4)	;48c3e: 426c8252
	MOVE.W	#$0004,-(A7)		;48c42: 3f3c0004
	CLR.W	-(A7)			;48c46: 4267
	JSR	(___kill_effect,A4)	;48c48: 4eac8170
	ADDQ.W	#4,A7			;48c4c: 584f
	JSR	(_read_lord,PC)		;48c4e: 4eba17fc
	TST.W	D0			;48c52: 4a40
	BEQ.W	LAB_48F84		;48c54: 6700032e
	JSR	(_read_mouth,PC)	;48c58: 4eba1852
	JSR	(___free_all_sounds,A4)	;48c5c: 4eac8158
	PEA	(str_gwords,PC)		;48c60: 487a0354
	JSR	(___load_sound,A4)	;48c64: 4eac816a
	ADDQ.W	#4,A7			;48c68: 584f
	MOVE.W	(-106,A5),(_seed,A4)	;48c6a: 396dff9699e2
	TST.W	(-122,A5)		;48c70: 4a6dff86
	BEQ.S	LAB_48CA0		;48c74: 672a
	MOVE.L	(LAB_52230,A4),-(A7)	;48c76: 2f2c8e42
	MOVE.W	#$00b2,-(A7)		;48c7a: 3f3c00b2
	MOVE.W	#$0008,-(A7)		;48c7e: 3f3c0008
	MOVE.L	(_w_screen,A4),-(A7)	;48c82: 2f2c99e8
	JSR	(___text,A4)		;48c86: 4eac813a
	LEA	($C,A7),A7		;48c8a: 4fef000c
	MOVE.L	(LAB_52234,A4),-(A7)	;48c8e: 2f2c8e46
	PEA	(-100,A5)		;48c92: 486dff9c
	JSR	(___strcpy,A4)		;48c96: 4eac81a0
	ADDQ.W	#8,A7			;48c9a: 504f
	BRA.W	LAB_48D34		;48c9c: 60000096
LAB_48CA0:
	MOVE.L	(LAB_52224,A4),-(A7)	;48ca0: 2f2c8e36
	PEA	(-100,A5)		;48ca4: 486dff9c
	JSR	(___strcpy,A4)		;48ca8: 4eac81a0
	ADDQ.W	#8,A7			;48cac: 504f
	MOVE.W	(_level_number,A4),D0	;48cae: 302cae7e
	EXT.L	D0			;48cb2: 48c0
	DIVS	#$00fa,D0		;48cb4: 81fc00fa
	MOVE.W	D0,(-114,A5)		;48cb8: 3b40ff8e
	MOVE.W	(-114,A5),D0		;48cbc: 302dff8e
	ADD.W	#$0018,D0		;48cc0: d07c0018
	EXT.L	D0			;48cc4: 48c0
	ASL.L	#2,D0			;48cc6: e580
	LEA	(_con_text,A4),A0	;48cc8: 41ec8dae
	MOVE.L	(0,A0,D0.L),-(A7)	;48ccc: 2f300800
	PEA	(-100,A5)		;48cd0: 486dff9c
	JSR	(___strcat,A4)		;48cd4: 4eac81be
	ADDQ.W	#8,A7			;48cd8: 504f
	MOVE.L	(LAB_52228,A4),-(A7)	;48cda: 2f2c8e3a
	PEA	(-100,A5)		;48cde: 486dff9c
	JSR	(___strcat,A4)		;48ce2: 4eac81be
	ADDQ.W	#8,A7			;48ce6: 504f
	PEA	(-100,A5)		;48ce8: 486dff9c
	MOVE.W	#$00b2,-(A7)		;48cec: 3f3c00b2
	MOVE.W	#$0008,-(A7)		;48cf0: 3f3c0008
	MOVE.L	(_w_screen,A4),-(A7)	;48cf4: 2f2c99e8
	JSR	(___text,A4)		;48cf8: 4eac813a
	LEA	($C,A7),A7		;48cfc: 4fef000c
	TST.W	(_seed,A4)		;48d00: 4a6c99e2
	BNE.S	LAB_48D16		;48d04: 6610
	PEA	(strGENESIS,PC)		;48d06: 487a02b5
	PEA	(-100,A5)		;48d0a: 486dff9c
	JSR	(___strcpy,A4)		;48d0e: 4eac81a0
	ADDQ.W	#8,A7			;48d12: 504f
	BRA.S	LAB_48D26		;48d14: 6010
LAB_48D16:
	JSR	(___newrand,A4)		;48d16: 4eac80fe
	MOVE.W	D0,-(A7)		;48d1a: 3f00
	PEA	(-100,A5)		;48d1c: 486dff9c
	JSR	(_code,PC)		;48d20: 4eba02ac
	ADDQ.W	#6,A7			;48d24: 5c4f
LAB_48D26:
	MOVE.L	(LAB_5222C,A4),-(A7)	;48d26: 2f2c8e3e
	PEA	(-100,A5)		;48d2a: 486dff9c
	JSR	(___strcat,A4)		;48d2e: 4eac81be
	ADDQ.W	#8,A7			;48d32: 504f
LAB_48D34:
	PEA	(_message,A4)		;48d34: 486c3058
	PEA	(-100,A5)		;48d38: 486dff9c
	JSR	(___strcat,A4)		;48d3c: 4eac81be
	ADDQ.W	#8,A7			;48d40: 504f
	PEA	(-100,A5)		;48d42: 486dff9c
	MOVE.W	#$00ba,-(A7)		;48d46: 3f3c00ba
	MOVE.W	#$0008,-(A7)		;48d4a: 3f3c0008
	MOVE.L	(_w_screen,A4),-(A7)	;48d4e: 2f2c99e8
	JSR	(___text,A4)		;48d52: 4eac813a
	LEA	($C,A7),A7		;48d56: 4fef000c
	CLR.W	(-108,A5)		;48d5a: 426dff94
LAB_48D5E:
	MOVE.W	(-108,A5),D0		;48d5e: 302dff94
	EXT.L	D0			;48d62: 48c0
	ASL.L	#1,D0			;48d64: e380
	LEA	(_palette,A4),A0	;48d66: 41ec83ca
	MOVE.W	(-108,A5),D1		;48d6a: 322dff94
	ADD.W	#$0010,D1		;48d6e: d27c0010
	EXT.L	D1			;48d72: 48c1
	ASL.L	#1,D1			;48d74: e381
	LEA	(_tcmap,A4),A1		;48d76: 43ec30a0
	MOVE.W	(0,A0,D0.L),(0,A1,D1.L)	;48d7a: 33b008001800
	ADDQ.W	#1,(-108,A5)		;48d80: 526dff94
	CMPI.W	#$0010,(-108,A5)	;48d84: 0c6d0010ff94
	BLT.S	LAB_48D5E		;48d8a: 6dd2
	MOVE.W	#$0004,-(A7)		;48d8c: 3f3c0004
	PEA	(_sprite_list,A4)	;48d90: 486c30e0
	PEA	(_tcmap,A4)		;48d94: 486c30a0
	MOVE.L	(_w_screen,A4),-(A7)	;48d98: 2f2c99e8
	MOVE.L	(_spare_cl,A4),-(A7)	;48d9c: 2f2c9890
	JSR	(_make_copper,PC)	;48da0: 4eba3cc4
	LEA	($12,A7),A7		;48da4: 4fef0012
	MOVE.L	(_spare_cl,A4),-(A7)	;48da8: 2f2c9890
	JSR	(_show_screen,PC)	;48dac: 4eba3dd4
	ADDQ.W	#4,A7			;48db0: 584f
	MOVE.W	#$0002,(_left_button,A4) ;48db2: 397c0002ae62
	MOVE.W	#$0001,(-110,A5)	;48db8: 3b7c0001ff92
	CLR.W	(-108,A5)		;48dbe: 426dff94
	CLR.W	(-120,A5)		;48dc2: 426dff88
LAB_48DC6:
	TST.W	(_left_button,A4)	;48dc6: 4a6cae62
	BEQ.W	LAB_48F4A		;48dca: 6700017e
	TST.W	(-122,A5)		;48dce: 4a6dff86
	BEQ.W	LAB_48E5A		;48dd2: 67000086
	CMPI.W	#$000a,(-120,A5)	;48dd6: 0c6d000aff88
	BLT.S	LAB_48E18		;48ddc: 6d3a
	CMPI.W	#$000e,(-120,A5)	;48dde: 0c6d000eff88
	BGT.S	LAB_48E18		;48de4: 6e32
	MOVE.W	#$0002,-(A7)		;48de6: 3f3c0002
	JSR	(___check_effect,A4)	;48dea: 4eac8176
	ADDQ.W	#2,A7			;48dee: 544f
	TST.W	D0			;48df0: 4a40
	BEQ.S	LAB_48E16		;48df2: 6722
	MOVE.W	#$0002,-(A7)		;48df4: 3f3c0002
	MOVE.W	(-120,A5),D0		;48df8: 302dff88
	SUB.W	#$000a,D0		;48dfc: 907c000a
	EXT.L	D0			;48e00: 48c0
	ASL.L	#1,D0			;48e02: e380
	LEA	(_end_words,A4),A0	;48e04: 41ec8e4c
	MOVE.W	(0,A0,D0.L),-(A7)	;48e08: 3f300800
	JSR	(___PlaySound,A4)	;48e0c: 4eac8152
	ADDQ.W	#4,A7			;48e10: 584f
	ADDQ.W	#1,(-120,A5)		;48e12: 526dff88
LAB_48E16:
	BRA.S	LAB_48E56		;48e16: 603e
LAB_48E18:
	CMPI.W	#$00c8,(-120,A5)	;48e18: 0c6d00c8ff88
	BLE.S	LAB_48E24		;48e1e: 6f04
	CLR.W	(-120,A5)		;48e20: 426dff88
LAB_48E24:
	CMPI.W	#$0010,(-120,A5)	;48e24: 0c6d0010ff88
	BNE.S	LAB_48E48		;48e2a: 661c
	MOVE.W	#$0005,-(A7)		;48e2c: 3f3c0005
	MOVE.W	#$0023,-(A7)		;48e30: 3f3c0023
	MOVE.W	#$004b,-(A7)		;48e34: 3f3c004b
	MOVE.W	#$0010,-(A7)		;48e38: 3f3c0010
	MOVE.L	(_w_screen,A4),-(A7)	;48e3c: 2f2c99e8
	JSR	(_draw_mouth,PC)	;48e40: 4eba3e84
	LEA	($C,A7),A7		;48e44: 4fef000c
LAB_48E48:
	ADDQ.W	#1,(-120,A5)		;48e48: 526dff88
	CLR.W	(-108,A5)		;48e4c: 426dff94
	MOVE.W	#$0001,(-110,A5)	;48e50: 3b7c0001ff92
LAB_48E56:
	BRA.W	LAB_48EF2		;48e56: 6000009a
LAB_48E5A:
	CMPI.W	#$000a,(-120,A5)	;48e5a: 0c6d000aff88
	BLT.S	LAB_48ED8		;48e60: 6d76
	CMPI.W	#$000c,(-120,A5)	;48e62: 0c6d000cff88
	BGT.S	LAB_48ED8		;48e68: 6e6e
	CMPI.W	#$000a,(-120,A5)	;48e6a: 0c6d000aff88
	BNE.S	LAB_48E84		;48e70: 6612
	MOVE.W	#$0002,-(A7)		;48e72: 3f3c0002
	CLR.W	-(A7)			;48e76: 4267
	JSR	(___PlaySound,A4)	;48e78: 4eac8152
	ADDQ.W	#4,A7			;48e7c: 584f
	ADDQ.W	#1,(-120,A5)		;48e7e: 526dff88
	BRA.S	LAB_48ED6		;48e82: 6052
LAB_48E84:
	MOVE.W	#$0002,-(A7)		;48e84: 3f3c0002
	JSR	(___check_effect,A4)	;48e88: 4eac8176
	ADDQ.W	#2,A7			;48e8c: 544f
	TST.W	D0			;48e8e: 4a40
	BEQ.S	LAB_48ED6		;48e90: 6744
	MOVE.W	(-114,A5),D0		;48e92: 302dff8e
	ASL.W	#1,D0			;48e96: e340
	ADD.W	(-120,A5),D0		;48e98: d06dff88
	SUB.W	#$000b,D0		;48e9c: 907c000b
	EXT.L	D0			;48ea0: 48c0
	ASL.L	#1,D0			;48ea2: e380
	LEA	(_words,A4),A0		;48ea4: 41ec8e56
	TST.W	(0,A0,D0.L)		;48ea8: 4a700800
	BLT.S	LAB_48ED2		;48eac: 6d24
	MOVE.W	#$0002,-(A7)		;48eae: 3f3c0002
	MOVE.W	(-114,A5),D0		;48eb2: 302dff8e
	ASL.W	#1,D0			;48eb6: e340
	ADD.W	(-120,A5),D0		;48eb8: d06dff88
	SUB.W	#$000b,D0		;48ebc: 907c000b
	EXT.L	D0			;48ec0: 48c0
	ASL.L	#1,D0			;48ec2: e380
	LEA	(_words,A4),A0		;48ec4: 41ec8e56
	MOVE.W	(0,A0,D0.L),-(A7)	;48ec8: 3f300800
	JSR	(___PlaySound,A4)	;48ecc: 4eac8152
	ADDQ.W	#4,A7			;48ed0: 584f
LAB_48ED2:
	ADDQ.W	#1,(-120,A5)		;48ed2: 526dff88
LAB_48ED6:
	BRA.S	LAB_48EF2		;48ed6: 601a
LAB_48ED8:
	CMPI.W	#$00fa,(-120,A5)	;48ed8: 0c6d00faff88
	BLE.S	LAB_48EE4		;48ede: 6f04
	CLR.W	(-120,A5)		;48ee0: 426dff88
LAB_48EE4:
	ADDQ.W	#1,(-120,A5)		;48ee4: 526dff88
	CLR.W	(-108,A5)		;48ee8: 426dff94
	MOVE.W	#$0001,(-110,A5)	;48eec: 3b7c0001ff92
LAB_48EF2:
	JSR	(_waittof,PC)		;48ef2: 4eba3cae
	JSR	(_waittof,PC)		;48ef6: 4eba3caa
	JSR	(_waittof,PC)		;48efa: 4eba3ca6
	JSR	(_waittof,PC)		;48efe: 4eba3ca2
	MOVE.W	(-108,A5),-(A7)		;48f02: 3f2dff94
	MOVE.W	#$0023,-(A7)		;48f06: 3f3c0023
	MOVE.W	#$0087,-(A7)		;48f0a: 3f3c0087
	MOVE.W	#$0012,-(A7)		;48f0e: 3f3c0012
	MOVE.L	(_w_screen,A4),-(A7)	;48f12: 2f2c99e8
	JSR	(_draw_mouth,PC)	;48f16: 4eba3dae
	LEA	($C,A7),A7		;48f1a: 4fef000c
	MOVE.W	#$0002,-(A7)		;48f1e: 3f3c0002
	JSR	(___check_effect,A4)	;48f22: 4eac8176
	ADDQ.W	#2,A7			;48f26: 544f
	TST.W	D0			;48f28: 4a40
	BNE.S	LAB_48F46		;48f2a: 661a
	MOVE.W	(-110,A5),D0		;48f2c: 302dff92
	ADD.W	D0,(-108,A5)		;48f30: d16dff94
	CMPI.W	#$0004,(-108,A5)	;48f34: 0c6d0004ff94
	BGE.S	LAB_48F42		;48f3a: 6c06
	TST.W	(-108,A5)		;48f3c: 4a6dff94
	BGT.S	LAB_48F46		;48f40: 6e04
LAB_48F42:
	NEG.W	(-110,A5)		;48f42: 446dff92
LAB_48F46:
	BRA.W	LAB_48DC6		;48f46: 6000fe7e
LAB_48F4A:
	MOVE.W	#$0002,(_left_button,A4) ;48f4a: 397c0002ae62
	MOVE.W	#$0004,-(A7)		;48f50: 3f3c0004
	CLR.W	-(A7)			;48f54: 4267
	JSR	(___kill_effect,A4)	;48f56: 4eac8170
	ADDQ.W	#4,A7			;48f5a: 584f
	JSR	(___clr_wsc,A4)		;48f5c: 4eac80a4
	MOVE.W	#$ffff,-(A7)		;48f60: 3f3cffff
	MOVE.L	(_d_screen,A4),-(A7)	;48f64: 2f2c99ec
	MOVE.L	(_d_screen,A4),-(A7)	;48f68: 2f2c99ec
	JSR	(___Setscreen,A4)	;48f6c: 4eac80c2
	LEA	($A,A7),A7		;48f70: 4fef000a
	JSR	(___free_all_sounds,A4)	;48f74: 4eac8158
	PEA	(str_gmusic1,PC)	;48f78: 487a004b
	JSR	(___load_sound,A4)	;48f7c: 4eac816a
	ADDQ.W	#4,A7			;48f80: 584f
	BRA.S	LAB_48F8E		;48f82: 600a
LAB_48F84:
	MOVE.W	(-106,A5),(_level_number,A4) ;48f84: 396dff96ae7e
	CLR.B	(_message,A4)		;48f8a: 422c3058
LAB_48F8E:
	MOVE.W	(-116,A5),(_music_off,A4) ;48f8e: 396dff8c8250
	MOVE.W	(-118,A5),(_effect_off,A4) ;48f94: 396dff8a8252
LAB_48F9A:
	JSR	(_show_world,PC)	;48f9a: 4ebae090
	MOVE.W	D0,(_in_conquest,A4)	;48f9e: 394084ba
	CMP.W	#$ffff,D0		;48fa2: b07cffff
	BNE.S	LAB_48FAA		;48fa6: 6602
	BRA.S	LAB_48F9A		;48fa8: 60f0
LAB_48FAA:
	JSR	(_return_to_game,PC)	;48faa: 4ebaf624
	JSR	(___swap_screens,A4)	;48fae: 4eac80c8
	UNLK	A5			;48fb2: 4e5d
	RTS				;48fb4: 4e75
str_gwords:
	;48fb6
	;DC.B	$67,$77,$6f,$72,$64,$73,$00
	DC.B	"gwords",0
strGENESIS:
	;48fbd
	;DC.B	$47,$45,$4e,$45,$53,$49,$53,$00
	DC.B	"GENESIS",0
str_gmusic1:
	;48fc5
	;DC.B	$67,$6d,$75,$73,$69,$63,$31,$00,$00
	DC.B	"gmusic1",0,0
; ------------------------------------------------------------------------------
; Function
; Generate level code
; ------------------------------------------------------------------------------
_code:
	LINK.W	A5,#0			;48fce: 4e550000
	MOVEM.L	D4-D5,-(A7)		;48fd2: 48e70c00
	MOVEQ	#0,D4			;48fd6: 7800
	BRA.S	LAB_49000		;48fd8: 6026
LAB_48FDA:
	MOVE.W	($C,A5),D0		;48fda: 302d000c
	AND.W	#$001f,D0		;48fde: c07c001f
	EXT.L	D0			;48fe2: 48c0
	ASL.L	#2,D0			;48fe4: e580
	LEA	(_start,A4),A0		;48fe6: 41ec9584
	MOVE.L	(0,A0,D0.L),D1		;48fea: 22300800
	MOVE.W	D4,D0			;48fee: 3004
	EXT.L	D0			;48ff0: 48c0
	MOVEA.L	D0,A0			;48ff2: 2040
	MOVEA.L	(8,A5),A1		;48ff4: 226d0008
	MOVE.B	(0,A0,D1.L),(0,A1,D4.W)	;48ff8: 13b018004000
	ADDQ.W	#1,D4			;48ffe: 5244
LAB_49000:
	MOVE.W	($C,A5),D0		;49000: 302d000c
	AND.W	#$001f,D0		;49004: c07c001f
	EXT.L	D0			;49008: 48c0
	ASL.L	#2,D0			;4900a: e580
	LEA	(_start,A4),A0		;4900c: 41ec9584
	MOVE.L	(0,A0,D0.L),D1		;49010: 22300800
	MOVE.W	D4,D0			;49014: 3004
	EXT.L	D0			;49016: 48c0
	MOVEA.L	D0,A0			;49018: 2040
	TST.B	(0,A0,D1.L)		;4901a: 4a301800
	BNE.S	LAB_48FDA		;4901e: 66ba
	MOVEQ	#0,D5			;49020: 7a00
	BRA.S	LAB_4904E		;49022: 602a
LAB_49024:
	MOVE.W	($C,A5),D0		;49024: 302d000c
	ASR.W	#5,D0			;49028: ea40
	AND.W	#$001f,D0		;4902a: c07c001f
	EXT.L	D0			;4902e: 48c0
	ASL.L	#2,D0			;49030: e580
	LEA	(_mid,A4),A0		;49032: 41ec9684
	MOVE.L	(0,A0,D0.L),D1		;49036: 22300800
	MOVE.W	D5,D0			;4903a: 3005
	EXT.L	D0			;4903c: 48c0
	MOVEA.L	D0,A0			;4903e: 2040
	MOVEA.L	(8,A5),A1		;49040: 226d0008
	MOVE.B	(0,A0,D1.L),(0,A1,D4.W)	;49044: 13b018004000
	ADDQ.W	#1,D5			;4904a: 5245
	ADDQ.W	#1,D4			;4904c: 5244
LAB_4904E:
	MOVE.W	($C,A5),D0		;4904e: 302d000c
	ASR.W	#5,D0			;49052: ea40
	AND.W	#$001f,D0		;49054: c07c001f
	EXT.L	D0			;49058: 48c0
	ASL.L	#2,D0			;4905a: e580
	LEA	(_mid,A4),A0		;4905c: 41ec9684
	MOVE.L	(0,A0,D0.L),D1		;49060: 22300800
	MOVE.W	D5,D0			;49064: 3005
	EXT.L	D0			;49066: 48c0
	MOVEA.L	D0,A0			;49068: 2040
	TST.B	(0,A0,D1.L)		;4906a: 4a301800
	BNE.S	LAB_49024		;4906e: 66b4
	MOVEQ	#0,D5			;49070: 7a00
	BRA.S	LAB_490A0		;49072: 602c
LAB_49074:
	MOVE.W	($C,A5),D0		;49074: 302d000c
	MOVEQ	#$A,D1			;49078: 720a
	ASR.W	D1,D0			;4907a: e260
	AND.W	#$001f,D0		;4907c: c07c001f
	EXT.L	D0			;49080: 48c0
	ASL.L	#2,D0			;49082: e580
	LEA	(_end,A4),A0		;49084: 41ec9604
	MOVE.L	(0,A0,D0.L),D1		;49088: 22300800
	MOVE.W	D5,D0			;4908c: 3005
	EXT.L	D0			;4908e: 48c0
	MOVEA.L	D0,A0			;49090: 2040
	MOVEA.L	(8,A5),A1		;49092: 226d0008
	MOVE.B	(0,A0,D1.L),(0,A1,D4.W)	;49096: 13b018004000
	ADDQ.W	#1,D5			;4909c: 5245
	ADDQ.W	#1,D4			;4909e: 5244
LAB_490A0:
	MOVE.W	($C,A5),D0		;490a0: 302d000c
	MOVEQ	#$A,D1			;490a4: 720a
	ASR.W	D1,D0			;490a6: e260
	AND.W	#$001f,D0		;490a8: c07c001f
	EXT.L	D0			;490ac: 48c0
	ASL.L	#2,D0			;490ae: e580
	LEA	(_end,A4),A0		;490b0: 41ec9604
	MOVE.L	(0,A0,D0.L),D1		;490b4: 22300800
	MOVE.W	D5,D0			;490b8: 3005
	EXT.L	D0			;490ba: 48c0
	MOVEA.L	D0,A0			;490bc: 2040
	TST.B	(0,A0,D1.L)		;490be: 4a301800
	BNE.S	LAB_49074		;490c2: 66b0
	MOVEA.L	(8,A5),A0		;490c4: 206d0008
	CLR.B	(0,A0,D4.W)		;490c8: 42304000
	MOVEM.L	(A7)+,D4-D5		;490cc: 4cdf0030
	UNLK	A5			;490d0: 4e5d
	RTS				;490d2: 4e75
; ------------------------------------------------------------------------------
; Function
; Decode level codes
; Each level code is made of a start, middle, and end segment.
; A 16-bit numeric code stores the password in three groups of five bits.
; There are 32 segments of each type, giving 32,768 possible combinations.
; However, only 1,001 codes are valid. They are calculated with rand(n*5)
; where n is a level number from 0 to 1,000.
; Decode function returns negative numbers for errors.
; ------------------------------------------------------------------------------
_decode:
	LINK.W	A5,#-4			;490d4: 4e55fffc
	MOVEM.L	D4-D5,-(A7)		;490d8: 48e70c00
	CLR.W	(-4,A5)			;490dc: 426dfffc
	MOVEQ	#0,D4			;490e0: 7800
LAB_490E2:
	MOVEQ	#0,D5			;490e2: 7a00
	BRA.S	LAB_490E8		;490e4: 6002
loop_490E6:
	ADDQ.W	#1,D5			;490e6: 5245
LAB_490E8:
	MOVEQ	#0,D0			;490e8: 7000
	MOVE.W	D4,D0			;490ea: 3004
	ASL.L	#2,D0			;490ec: e580
	LEA	(_start,A4),A0		;490ee: 41ec9584
	MOVE.L	(0,A0,D0.L),D1		;490f2: 22300800
	MOVEQ	#0,D0			;490f6: 7000
	MOVE.W	D5,D0			;490f8: 3005
	MOVEA.L	D0,A0			;490fa: 2040
	TST.B	(0,A0,D1.L)		;490fc: 4a301800
	BEQ.S	LAB_49134		;49100: 6732
	MOVE.W	(-4,A5),D0		;49102: 302dfffc
	ADD.W	D5,D0			;49106: d045
	MOVEQ	#0,D1			;49108: 7200
	MOVE.W	D0,D1			;4910a: 3200
	MOVEA.L	(8,A5),A0		;4910c: 206d0008
	MOVEQ	#0,D0			;49110: 7000
	MOVE.B	(0,A0,D1.L),D0		;49112: 10301800
	MOVEQ	#0,D1			;49116: 7200
	MOVE.W	D4,D1			;49118: 3204
	ASL.L	#2,D1			;4911a: e581
	LEA	(_start,A4),A0		;4911c: 41ec9584
	MOVE.L	(0,A0,D1.L),D2		;49120: 24301800
	MOVEQ	#0,D1			;49124: 7200
	MOVE.W	D5,D1			;49126: 3205
	MOVEA.L	D1,A0			;49128: 2041
	MOVE.B	(0,A0,D2.L),D1		;4912a: 12302800
	EXT.W	D1			;4912e: 4881
	CMP.W	D1,D0			;49130: b041
	BEQ.S	loop_490E6		;49132: 67b2
LAB_49134:
	MOVEQ	#0,D0			;49134: 7000
	MOVE.W	D4,D0			;49136: 3004
	ASL.L	#2,D0			;49138: e580
	LEA	(_start,A4),A0		;4913a: 41ec9584
	MOVE.L	(0,A0,D0.L),D1		;4913e: 22300800
	MOVEQ	#0,D0			;49142: 7000
	MOVE.W	D5,D0			;49144: 3005
	MOVEA.L	D0,A0			;49146: 2040
	TST.B	(0,A0,D1.L)		;49148: 4a301800
	BNE.S	LAB_49154		;4914c: 6606
	ADD.W	D5,(-4,A5)		;4914e: db6dfffc
	BRA.S	LAB_4915C		;49152: 6008
LAB_49154:
	ADDQ.W	#1,D4			;49154: 5244
	CMP.W	#$0020,D4		;49156: b87c0020
	BCS.S	LAB_490E2		;4915a: 6586
LAB_4915C:
	CMP.W	#$0020,D4		;4915c: b87c0020
	BNE.S	LAB_4916C		;49160: 660a
	MOVEQ	#-1,D0			;49162: 70ff
return_49164:
	MOVEM.L	(A7)+,D4-D5		;49164: 4cdf0030
	UNLK	A5			;49168: 4e5d
	RTS				;4916a: 4e75
LAB_4916C:
	MOVE.W	D4,(-2,A5)		;4916c: 3b44fffe
	MOVEQ	#0,D4			;49170: 7800
loop_49172:
	MOVEQ	#0,D5			;49172: 7a00
	BRA.S	LAB_49178		;49174: 6002
LAB_49176:
	ADDQ.W	#1,D5			;49176: 5245
LAB_49178:
	MOVEQ	#0,D0			;49178: 7000
	MOVE.W	D4,D0			;4917a: 3004
	ASL.L	#2,D0			;4917c: e580
	LEA	(_mid,A4),A0		;4917e: 41ec9684
	MOVE.L	(0,A0,D0.L),D1		;49182: 22300800
	MOVEQ	#0,D0			;49186: 7000
	MOVE.W	D5,D0			;49188: 3005
	MOVEA.L	D0,A0			;4918a: 2040
	TST.B	(0,A0,D1.L)		;4918c: 4a301800
	BEQ.S	LAB_491C4		;49190: 6732
	MOVE.W	(-4,A5),D0		;49192: 302dfffc
	ADD.W	D5,D0			;49196: d045
	MOVEQ	#0,D1			;49198: 7200
	MOVE.W	D0,D1			;4919a: 3200
	MOVEA.L	(8,A5),A0		;4919c: 206d0008
	MOVEQ	#0,D0			;491a0: 7000
	MOVE.B	(0,A0,D1.L),D0		;491a2: 10301800
	MOVEQ	#0,D1			;491a6: 7200
	MOVE.W	D4,D1			;491a8: 3204
	ASL.L	#2,D1			;491aa: e581
	LEA	(_mid,A4),A0		;491ac: 41ec9684
	MOVE.L	(0,A0,D1.L),D2		;491b0: 24301800
	MOVEQ	#0,D1			;491b4: 7200
	MOVE.W	D5,D1			;491b6: 3205
	MOVEA.L	D1,A0			;491b8: 2041
	MOVE.B	(0,A0,D2.L),D1		;491ba: 12302800
	EXT.W	D1			;491be: 4881
	CMP.W	D1,D0			;491c0: b041
	BEQ.S	LAB_49176		;491c2: 67b2
LAB_491C4:
	MOVEQ	#0,D0			;491c4: 7000
	MOVE.W	D4,D0			;491c6: 3004
	ASL.L	#2,D0			;491c8: e580
	LEA	(_mid,A4),A0		;491ca: 41ec9684
	MOVE.L	(0,A0,D0.L),D1		;491ce: 22300800
	MOVEQ	#0,D0			;491d2: 7000
	MOVE.W	D5,D0			;491d4: 3005
	MOVEA.L	D0,A0			;491d6: 2040
	TST.B	(0,A0,D1.L)		;491d8: 4a301800
	BNE.S	LAB_491E4		;491dc: 6606
	ADD.W	D5,(-4,A5)		;491de: db6dfffc
	BRA.S	LAB_491EC		;491e2: 6008
LAB_491E4:
	ADDQ.W	#1,D4			;491e4: 5244
	CMP.W	#$0020,D4		;491e6: b87c0020
	BCS.S	loop_49172		;491ea: 6586
LAB_491EC:
	CMP.W	#$0020,D4		;491ec: b87c0020
	BNE.S	LAB_491F8		;491f0: 6606
	MOVEQ	#-2,D0			;491f2: 70fe
	BRA.W	return_49164		;491f4: 6000ff6e
LAB_491F8:
	MOVE.W	D4,D0			;491f8: 3004
	ASL.W	#5,D0			;491fa: eb40
	OR.W	D0,(-2,A5)		;491fc: 816dfffe
	MOVEQ	#0,D4			;49200: 7800
loop_49202:
	MOVEQ	#0,D5			;49202: 7a00
	BRA.S	LAB_49208		;49204: 6002
LAB_49206:
	ADDQ.W	#1,D5			;49206: 5245
LAB_49208:
	MOVEQ	#0,D0			;49208: 7000
	MOVE.W	D4,D0			;4920a: 3004
	ASL.L	#2,D0			;4920c: e580
	LEA	(_end,A4),A0		;4920e: 41ec9604
	MOVE.L	(0,A0,D0.L),D1		;49212: 22300800
	MOVEQ	#0,D0			;49216: 7000
	MOVE.W	D5,D0			;49218: 3005
	MOVEA.L	D0,A0			;4921a: 2040
	TST.B	(0,A0,D1.L)		;4921c: 4a301800
	BEQ.S	LAB_49254		;49220: 6732
	MOVE.W	(-4,A5),D0		;49222: 302dfffc
	ADD.W	D5,D0			;49226: d045
	MOVEQ	#0,D1			;49228: 7200
	MOVE.W	D0,D1			;4922a: 3200
	MOVEA.L	(8,A5),A0		;4922c: 206d0008
	MOVEQ	#0,D0			;49230: 7000
	MOVE.B	(0,A0,D1.L),D0		;49232: 10301800
	MOVEQ	#0,D1			;49236: 7200
	MOVE.W	D4,D1			;49238: 3204
	ASL.L	#2,D1			;4923a: e581
	LEA	(_end,A4),A0		;4923c: 41ec9604
	MOVE.L	(0,A0,D1.L),D2		;49240: 24301800
	MOVEQ	#0,D1			;49244: 7200
	MOVE.W	D5,D1			;49246: 3205
	MOVEA.L	D1,A0			;49248: 2041
	MOVE.B	(0,A0,D2.L),D1		;4924a: 12302800
	EXT.W	D1			;4924e: 4881
	CMP.W	D1,D0			;49250: b041
	BEQ.S	LAB_49206		;49252: 67b2
LAB_49254:
	MOVEQ	#0,D0			;49254: 7000
	MOVE.W	D4,D0			;49256: 3004
	ASL.L	#2,D0			;49258: e580
	LEA	(_end,A4),A0		;4925a: 41ec9604
	MOVE.L	(0,A0,D0.L),D1		;4925e: 22300800
	MOVEQ	#0,D0			;49262: 7000
	MOVE.W	D5,D0			;49264: 3005
	MOVEA.L	D0,A0			;49266: 2040
	TST.B	(0,A0,D1.L)		;49268: 4a301800
	BNE.S	LAB_49274		;4926c: 6606
	ADD.W	D5,(-4,A5)		;4926e: db6dfffc
	BRA.S	LAB_4927C		;49272: 6008
LAB_49274:
	ADDQ.W	#1,D4			;49274: 5244
	CMP.W	#$0020,D4		;49276: b87c0020
	BCS.S	loop_49202		;4927a: 6586
LAB_4927C:
	CMP.W	#$0020,D4		;4927c: b87c0020
	BNE.S	LAB_49288		;49280: 6606
	MOVEQ	#-3,D0			;49282: 70fd
	BRA.W	return_49164		;49284: 6000fede
LAB_49288:
	MOVE.L	(8,A5),-(A7)		;49288: 2f2d0008
	JSR	(___strlen,A4)		;4928c: 4eac81a6
	ADDQ.W	#4,A7			;49290: 584f
	CMP.W	(-4,A5),D0		;49292: b06dfffc
	BEQ.S	LAB_4929E		;49296: 6706
	MOVEQ	#-4,D0			;49298: 70fc
	BRA.W	return_49164		;4929a: 6000fec8
LAB_4929E:
	MOVE.W	D4,D0			;4929e: 3004
	MOVEQ	#$A,D1			;492a0: 720a
	ASL.W	D1,D0			;492a2: e360
	OR.W	D0,(-2,A5)		;492a4: 816dfffe
; ------------------------------------------------------------------------------
; 1,000 valid level codes
; Calculated by advancing the random seed each time and adding 5
; ------------------------------------------------------------------------------
	MOVEQ	#0,D4			;492a8: 7800
loop_492AA:
	MOVE.W	D4,(_seed,A4)		;492aa: 394499e2
	JSR	(___newrand,A4)		;492ae: 4eac80fe
	MOVE.W	D0,D5			;492b2: 3a00
	CMP.W	(-2,A5),D5		;492b4: ba6dfffe
	BNE.S	LAB_492C0		;492b8: 6606
	MOVE.W	D4,D0			;492ba: 3004
	BRA.W	return_49164		;492bc: 6000fea6
LAB_492C0:
	ADDQ.W	#5,D4			;492c0: 5a44
; 5000
	CMP.W	#$1388,D4		;492c2: b87c1388
	BLS.S	loop_492AA		;492c6: 63e2
	MOVEQ	#-5,D0			;492c8: 70fb
	BRA.W	return_49164		;492ca: 6000fe98
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_paint_the_map:
	LINK.W	A5,#0			;492ce: 4e550000
	MOVE.L	A2,-(A7)		;492d2: 2f0a
	MOVEA.L	(8,A5),A2		;492d4: 246d0008
	TST.W	(_paint_map,A4)		;492d8: 4a6c9c24
	BEQ.W	return_493E4		;492dc: 67000106
	MOVE.B	(LAB_5C417,A4),(1,A2)	;492e0: 156c30290001
	MOVE.B	(LAB_5C415,A4),(2,A2)	;492e6: 156c30270002
	MOVEQ	#0,D0			;492ec: 7000
	MOVE.B	(_inkey,A4),D0		;492ee: 102cae6c
	BRA.W	LAB_493AA		;492f2: 600000b6
; ------------------------------------------------------------------------------
; F1: Place man
; Shift-F1: Place leader
; ------------------------------------------------------------------------------
paintF1_492F6:
	TST.W	(_shift,A4)		;492f6: 4a6c3100
	BEQ.S	LAB_49300		;492fa: 6704
	MOVEQ	#9,D0			;492fc: 7009
	BRA.S	LAB_49302		;492fe: 6002
LAB_49300:
	MOVEQ	#7,D0			;49300: 7007
LAB_49302:
	MOVE.B	D0,(A2)			;49302: 1480
	BRA.W	return_493E4		;49304: 600000de
; ------------------------------------------------------------------------------
; F2: Place enemy man
; Shift-F2: Place enemy leader
; ------------------------------------------------------------------------------
paintF2_49308:
	TST.W	(_shift,A4)		;49308: 4a6c3100
	BEQ.S	LAB_49312		;4930c: 6704
	MOVEQ	#$A,D0			;4930e: 700a
	BRA.S	LAB_49314		;49310: 6002
LAB_49312:
	MOVEQ	#8,D0			;49312: 7008
LAB_49314:
	MOVE.B	D0,(A2)			;49314: 1480
	BRA.W	return_493E4		;49316: 600000cc
; ------------------------------------------------------------------------------
; F3: Place tree
; ------------------------------------------------------------------------------
paintF3_4931A:
	MOVE.B	#$0b,(A2)		;4931a: 14bc000b
	BRA.W	return_493E4		;4931e: 600000c4
; ------------------------------------------------------------------------------
; F4: Place rock
; ------------------------------------------------------------------------------
paintF4_49322:
	MOVE.B	#$0c,(A2)		;49322: 14bc000c
	BRA.W	return_493E4		;49326: 600000bc
; ------------------------------------------------------------------------------
; F5: Delete object
; ------------------------------------------------------------------------------
paintF5_4932A:
	MOVE.B	#$0d,(A2)		;4932a: 14bc000d
	BRA.W	return_493E4		;4932e: 600000b4
; ------------------------------------------------------------------------------
; F6: Raise manna bar
; Shift-F6: Lower manna bar
; ------------------------------------------------------------------------------
paintF6_49332:
	MOVE.B	(LAB_5C4EF,A4),(1,A2)	;49332: 156c31010001
	MOVE.B	#$0e,(A2)		;49338: 14bc000e
	MOVE.B	#$09,(2,A2)		;4933c: 157c00090002
	BRA.W	return_493E4		;49342: 600000a0
; ------------------------------------------------------------------------------
; F7: Increase manna for evil, according to manual
; Shift-F7: Lower manna bar for evil
; ------------------------------------------------------------------------------
paintF7_49346:
	MOVE.B	(LAB_5C4EF,A4),(1,A2)	;49346: 156c31010001
	MOVE.B	#$0e,(A2)		;4934c: 14bc000e
	MOVE.B	#$0a,(2,A2)		;49350: 157c000a0002
	BRA.W	return_493E4		;49356: 6000008c
; ------------------------------------------------------------------------------
; F8: Mirror the landscape
; ------------------------------------------------------------------------------
paintF8_4935A:
	MOVE.B	#$0e,(A2)		;4935a: 14bc000e
	MOVE.B	#$0b,(2,A2)		;4935e: 157c000b0002
	BRA.S	return_493E4		;49364: 607e
; ------------------------------------------------------------------------------
; DEL: Clear all land
; ------------------------------------------------------------------------------
paintDelete_49366:
	MOVE.B	#$0e,(A2)		;49366: 14bc000e
	MOVE.B	#$0c,(2,A2)		;4936a: 157c000c0002
	BRA.S	return_493E4		;49370: 6072
LAB_49372:
	MOVEQ	#0,D0			;49372: 7000
	MOVE.B	(_inkey,A4),D0		;49374: 102cae6c
	CMP.W	#$00ed,D0		;49378: b07c00ed
	BCS.S	return_493A8		;4937c: 652a
	MOVEQ	#0,D0			;4937e: 7000
	MOVE.B	(_inkey,A4),D0		;49380: 102cae6c
; ------------------------------------------------------------------------------
; 1-9: Change terrain type
; 1: Grass
; 2: Desert
; 3: Snow
; 4: Volcano
; 5-9 Custom
; ------------------------------------------------------------------------------
; keyboard 1
	CMP.W	#$00fd,D0		;49384: b07c00fd
	BHI.S	return_493A8		;49388: 621e
	MOVEQ	#0,D0			;4938a: 7000
	MOVE.B	(_inkey,A4),D0		;4938c: 102cae6c
	SUB.W	#$00ed,D0		;49390: 907c00ed
	MOVEQ	#$10,D1			;49394: 7210
	SUB.W	D0,D1			;49396: 9240
	LSR.W	#1,D1			;49398: e249
	MOVE.B	D1,(1,A2)		;4939a: 15410001
	MOVE.B	#$0e,(A2)		;4939e: 14bc000e
	MOVE.B	#$0d,(2,A2)		;493a2: 157c000d0002
return_493A8:
	BRA.S	return_493E4		;493a8: 603a
LAB_493AA:
; F1-F8 and DEL for map paint
	SUB.L	#$00000051,D0		;493aa: 90bc00000051
; Big hill with trees
	BEQ.S	paintF8_4935A		;493b0: 67a8
	SUBQ.L	#2,D0			;493b2: 5580
; Raise enemy manna bar
	BEQ.S	paintF7_49346		;493b4: 6790
	SUBQ.L	#2,D0			;493b6: 5580
; Raise manna bar
	BEQ.W	paintF6_49332		;493b8: 6700ff78
	SUBQ.L	#2,D0			;493bc: 5580
; Delete object
	BEQ.W	paintF5_4932A		;493be: 6700ff6a
	SUBQ.L	#2,D0			;493c2: 5580
; Place rocks / cycle rock type
	BEQ.W	paintF4_49322		;493c4: 6700ff5c
	SUBQ.L	#2,D0			;493c8: 5580
; Place tree / cycle tree type
	BEQ.W	paintF3_4931A		;493ca: 6700ff4e
	SUBQ.L	#2,D0			;493ce: 5580
; Place enemy man
	BEQ.W	paintF2_49308		;493d0: 6700ff36
	SUBQ.L	#2,D0			;493d4: 5580
; Place man
	BEQ.W	paintF1_492F6		;493d6: 6700ff1e
	SUB.L	#$00000014,D0		;493da: 90bc00000014
; Clear map
	BEQ.S	paintDelete_49366	;493e0: 6784
	BRA.S	LAB_49372		;493e2: 608e
return_493E4:
	MOVEA.L	(A7)+,A2		;493e4: 245f
	UNLK	A5			;493e6: 4e5d
	RTS				;493e8: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_waitfor:
; wait for vertical blank
	LINK.W	A5,#-4			;493ea: 4e55fffc
	MOVE.W	(8,A5),D0		;493ee: 302d0008
	EXT.L	D0			;493f2: 48c0
	ADD.L	(_vbi_timer,PC),D0	;493f4: d0ba366a
	MOVE.L	D0,(-4,A5)		;493f8: 2b40fffc
LAB_493FC:
	MOVE.L	(-4,A5),D0		;493fc: 202dfffc
	CMP.L	(_vbi_timer,PC),D0	;49400: b0ba365e
	BGT.S	LAB_493FC		;49404: 6ef6
	UNLK	A5			;49406: 4e5d
	RTS				;49408: 4e75
; ------------------------------------------------------------------------------
; Function
; this whole function is new to the Hit Squad 1993 release
; Appears to be a screenshot tool for testers
; Not called anywhere
; ------------------------------------------------------------------------------
_write_iff:
	LINK.W	A5,#-438		;4940a: 4e55fe4a
	CLR.L	(-24,A5)		;4940e: 42adffe8
LAB_49412:
	MOVE.L	(-24,A5),D0		;49412: 202dffe8
	ADDQ.L	#1,(-24,A5)		;49416: 52adffe8
	MOVE.L	D0,-(A7)		;4941a: 2f00
	MOVE.L	(8,A5),-(A7)		;4941c: 2f2d0008
	PEA	(LAB_49778,PC)		;49420: 487a0356
	PEA	(-20,A5)		;49424: 486dffec
	JSR	(_sprintf,PC)		;49428: 4eba7676
	LEA	($10,A7),A7		;4942c: 4fef0010
	PEA	$3ED.W			;49430: 487803ed
	PEA	(-20,A5)		;49434: 486dffec
	JSR	(___Open,A4)		;49438: 4eac81e2
	ADDQ.W	#8,A7			;4943c: 504f
	MOVE.L	D0,(-28,A5)		;4943e: 2b40ffe4
	BEQ.S	LAB_4944E		;49442: 670a
	MOVE.L	(-28,A5),-(A7)		;49444: 2f2dffe4
	JSR	(___Close,A4)		;49448: 4eac81d6
	ADDQ.W	#4,A7			;4944c: 584f
LAB_4944E:
	TST.L	(-28,A5)		;4944e: 4aadffe4
	BNE.S	LAB_49412		;49452: 66be
	PEA	$3EE.W			;49454: 487803ee
	PEA	(-20,A5)		;49458: 486dffec
	JSR	(___Open,A4)		;4945c: 4eac81e2
	ADDQ.W	#8,A7			;49460: 504f
	MOVE.L	D0,(-28,A5)		;49462: 2b40ffe4
	BNE.S	LAB_4946E		;49466: 6606
	MOVEQ	#-1,D0			;49468: 70ff
LAB_4946A:
	UNLK	A5			;4946a: 4e5d
	RTS				;4946c: 4e75
LAB_4946E:
	LEA	(_dummy_bitmap,A4),A0	;4946e: 41ec3102
	MOVE.L	A0,(-438,A5)		;49472: 2b48fe4a
	MOVEA.L	(-438,A5),A0		;49476: 206dfe4a
	MOVE.W	#$0028,(A0)		;4947a: 30bc0028
	MOVEA.L	(-438,A5),A0		;4947e: 206dfe4a
	MOVE.W	#$00c8,(2,A0)		;49482: 317c00c80002
	MOVEA.L	(-438,A5),A0		;49488: 206dfe4a
	MOVE.B	#$04,(5,A0)		;4948c: 117c00040005
	CLR.L	(-24,A5)		;49492: 42adffe8
	BRA.S	LAB_494C6		;49496: 602e
LAB_49498:
	MOVEA.L	(-438,A5),A0		;49498: 206dfe4a
	MOVE.W	(A0),D0			;4949c: 3010
	MOVEA.L	(-438,A5),A0		;4949e: 206dfe4a
	MULU	(2,A0),D0		;494a2: c0e80002
	MOVE.L	(-24,A5),D1		;494a6: 222dffe8
	JSR	(___mulu,A4)		;494aa: 4eac81c4
	ADD.L	($C,A5),D0		;494ae: d0ad000c
	MOVE.L	(-24,A5),D1		;494b2: 222dffe8
	ASL.L	#2,D1			;494b6: e581
	MOVEA.L	D1,A0			;494b8: 2041
	ADDA.L	(-438,A5),A0		;494ba: d1edfe4a
	MOVE.L	D0,(8,A0)		;494be: 21400008
	ADDQ.L	#1,(-24,A5)		;494c2: 52adffe8
LAB_494C6:
	MOVEA.L	(-438,A5),A0		;494c6: 206dfe4a
	MOVEQ	#0,D0			;494ca: 7000
	MOVE.B	(5,A0),D0		;494cc: 10280005
	MOVE.L	(-24,A5),D1		;494d0: 222dffe8
	CMP.L	D0,D1			;494d4: b280
	BCS.S	LAB_49498		;494d6: 65c0
	MOVEA.L	(-438,A5),A0		;494d8: 206dfe4a
	MOVE.W	(A0),D0			;494dc: 3010
	ASL.W	#3,D0			;494de: e740
	MOVE.W	D0,(LAB_51628,A4)	;494e0: 3940823a
	MOVE.W	D0,(LAB_51618,A4)	;494e4: 3940822a
	MOVEA.L	(-438,A5),A0		;494e8: 206dfe4a
	MOVE.W	(2,A0),(LAB_5162A,A4)	;494ec: 39680002823c
	MOVE.W	(2,A0),(LAB_5161A,A4)	;494f2: 39680002822c
	MOVEA.L	(-438,A5),A0		;494f8: 206dfe4a
	MOVE.B	(5,A0),(LAB_51620,A4)	;494fc: 196800058232
	PEA	$00010000		;49502: 487900010000
	MOVEA.L	(-438,A5),A0		;49508: 206dfe4a
	MOVEQ	#0,D0			;4950c: 7000
	MOVE.B	(5,A0),D0		;4950e: 10280005
	MOVEA.L	(-438,A5),A0		;49512: 206dfe4a
	MULU	(2,A0),D0		;49516: c0e80002
	MOVEA.L	(-438,A5),A0		;4951a: 206dfe4a
	MULU	(A0),D0			;4951e: c0d0
	MOVEQ	#0,D1			;49520: 7200
	MOVE.W	D0,D1			;49522: 3200
	MOVE.L	D1,-(A7)		;49524: 2f01
	JSR	(___AllocMem,A4)	;49526: 4eac8200
	ADDQ.W	#8,A7			;4952a: 504f
	MOVE.L	D0,(-432,A5)		;4952c: 2b40fe50
	BNE.S	LAB_49542		;49530: 6610
	MOVE.L	(-28,A5),-(A7)		;49532: 2f2dffe4
	JSR	(___Close,A4)		;49536: 4eac81d6
	ADDQ.W	#4,A7			;4953a: 584f
	MOVEQ	#-1,D0			;4953c: 70ff
	BRA.W	LAB_4946A		;4953e: 6000ff2a
LAB_49542:
	PEA	$10.W			;49542: 48780010
	PEA	(LAB_4977F,PC)		;49546: 487a0237
	MOVE.L	(-28,A5),-(A7)		;4954a: 2f2dffe4
	JSR	(_Write,PC)		;4954e: 4eba7c30
	LEA	($C,A7),A7		;49552: 4fef000c
	MOVE.L	#$00000014,(-24,A5)	;49556: 2b7c00000014ffe8
	PEA	4.W			;4955e: 48780004
	PEA	(-24,A5)		;49562: 486dffe8
	MOVE.L	(-28,A5),-(A7)		;49566: 2f2dffe4
	JSR	(_Write,PC)		;4956a: 4eba7c14
	LEA	($C,A7),A7		;4956e: 4fef000c
	MOVE.L	(-24,A5),-(A7)		;49572: 2f2dffe8
	PEA	(LAB_51618,A4)		;49576: 486c822a
	MOVE.L	(-28,A5),-(A7)		;4957a: 2f2dffe4
	JSR	(_Write,PC)		;4957e: 4eba7c00
	LEA	($C,A7),A7		;49582: 4fef000c
	PEA	4.W			;49586: 48780004
	PEA	(LAB_49790,PC)		;4958a: 487a0204
	MOVE.L	(-28,A5),-(A7)		;4958e: 2f2dffe4
	JSR	(_Write,PC)		;49592: 4eba7bec
	LEA	($C,A7),A7		;49596: 4fef000c
	MOVEQ	#0,D0			;4959a: 7000
	MOVE.B	(LAB_51620,A4),D0	;4959c: 102c8232
	MOVEQ	#1,D1			;495a0: 7201
	ASL.W	D0,D1			;495a2: e161
	MULU	#$0003,D1		;495a4: c2fc0003
	MOVEQ	#0,D0			;495a8: 7000
	MOVE.W	D1,D0			;495aa: 3001
	MOVE.L	D0,(-24,A5)		;495ac: 2b40ffe8
	PEA	4.W			;495b0: 48780004
	PEA	(-24,A5)		;495b4: 486dffe8
	MOVE.L	(-28,A5),-(A7)		;495b8: 2f2dffe4
	JSR	(_Write,PC)		;495bc: 4eba7bc2
	LEA	($C,A7),A7		;495c0: 4fef000c
	CLR.L	(-24,A5)		;495c4: 42adffe8
	BRA.S	LAB_4962A		;495c8: 6060
LAB_495CA:
	MOVE.L	(-24,A5),D0		;495ca: 202dffe8
	ASL.L	#1,D0			;495ce: e380
	MOVEA.L	($10,A5),A0		;495d0: 206d0010
	MOVE.W	(0,A0,D0.L),D1		;495d4: 32300800
	LSR.W	#8,D1			;495d8: e049
	ASL.W	#4,D1			;495da: e941
	MOVE.B	D1,(-428,A5)		;495dc: 1b41fe54
	MOVE.L	(-24,A5),D0		;495e0: 202dffe8
	ASL.L	#1,D0			;495e4: e380
	MOVEA.L	($10,A5),A0		;495e6: 206d0010
	MOVE.W	(0,A0,D0.L),D1		;495ea: 32300800
	LSR.W	#4,D1			;495ee: e849
	AND.W	#$000f,D1		;495f0: c27c000f
	ASL.W	#4,D1			;495f4: e941
	MOVE.B	D1,(-427,A5)		;495f6: 1b41fe55
	MOVE.L	(-24,A5),D0		;495fa: 202dffe8
	ASL.L	#1,D0			;495fe: e380
	MOVEA.L	($10,A5),A0		;49600: 206d0010
	MOVE.W	(0,A0,D0.L),D1		;49604: 32300800
	AND.W	#$000f,D1		;49608: c27c000f
	ASL.W	#4,D1			;4960c: e941
	MOVE.B	D1,(-426,A5)		;4960e: 1b41fe56
	PEA	3.W			;49612: 48780003
	PEA	(-428,A5)		;49616: 486dfe54
	MOVE.L	(-28,A5),-(A7)		;4961a: 2f2dffe4
	JSR	(_Write,PC)		;4961e: 4eba7b60
	LEA	($C,A7),A7		;49622: 4fef000c
	ADDQ.L	#1,(-24,A5)		;49626: 52adffe8
LAB_4962A:
	MOVEQ	#0,D0			;4962a: 7000
	MOVE.B	(LAB_51620,A4),D0	;4962c: 102c8232
	MOVEQ	#1,D1			;49630: 7201
	ASL.W	D0,D1			;49632: e161
	MOVEQ	#0,D0			;49634: 7000
	MOVE.W	D1,D0			;49636: 3001
	MOVE.L	(-24,A5),D1		;49638: 222dffe8
	CMP.L	D0,D1			;4963c: b280
	BCS.S	LAB_495CA		;4963e: 658a
	CLR.W	(-434,A5)		;49640: 426dfe4e
LAB_49644:
	PEA	4.W			;49644: 48780004
	PEA	(LAB_49795,PC)		;49648: 487a014b
	MOVE.L	(-28,A5),-(A7)		;4964c: 2f2dffe4
	JSR	(_Write,PC)		;49650: 4eba7b2e
	LEA	($C,A7),A7		;49654: 4fef000c
	MOVE.L	#$00000008,(-24,A5)	;49658: 2b7c00000008ffe8
	PEA	4.W			;49660: 48780004
	PEA	(-24,A5)		;49664: 486dffe8
	MOVE.L	(-28,A5),-(A7)		;49668: 2f2dffe4
	JSR	(_Write,PC)		;4966c: 4eba7b12
	LEA	($C,A7),A7		;49670: 4fef000c
	CLR.L	(-24,A5)		;49674: 42adffe8
	PEA	4.W			;49678: 48780004
	PEA	(-24,A5)		;4967c: 486dffe8
	MOVE.L	(-28,A5),-(A7)		;49680: 2f2dffe4
	JSR	(_Write,PC)		;49684: 4eba7afa
	LEA	($C,A7),A7		;49688: 4fef000c
	PEA	4.W			;4968c: 48780004
	PEA	(-24,A5)		;49690: 486dffe8
	MOVE.L	(-28,A5),-(A7)		;49694: 2f2dffe4
	JSR	(_Write,PC)		;49698: 4eba7ae6
	LEA	($C,A7),A7		;4969c: 4fef000c
	ADDQ.W	#1,(-434,A5)		;496a0: 526dfe4e
	CMPI.W	#$0004,(-434,A5)	;496a4: 0c6d0004fe4e
	BNE.S	LAB_49644		;496aa: 6698
	MOVE.L	(-438,A5),-(A7)		;496ac: 2f2dfe4a
	MOVE.L	(-432,A5),-(A7)		;496b0: 2f2dfe50
	JSR	(_save_picture_body,PC)	;496b4: 4eba00ea
	ADDQ.W	#8,A7			;496b8: 504f
	MOVE.L	D0,(-24,A5)		;496ba: 2b40ffe8
	BTST	#0,(-21,A5)		;496be: 082d0000ffeb
	BEQ.S	LAB_496D8		;496c4: 6712
	MOVE.L	(-24,A5),D0		;496c6: 202dffe8
	ADDQ.L	#1,(-24,A5)		;496ca: 52adffe8
	MOVEA.L	(-432,A5),A0		;496ce: 206dfe50
	MOVE.B	#$80,(0,A0,D0.L)	;496d2: 11bc00800800
LAB_496D8:
	PEA	4.W			;496d8: 48780004
	PEA	(LAB_4979A,PC)		;496dc: 487a00bc
	MOVE.L	(-28,A5),-(A7)		;496e0: 2f2dffe4
	JSR	(_Write,PC)		;496e4: 4eba7a9a
	LEA	($C,A7),A7		;496e8: 4fef000c
	PEA	4.W			;496ec: 48780004
	PEA	(-24,A5)		;496f0: 486dffe8
	MOVE.L	(-28,A5),-(A7)		;496f4: 2f2dffe4
	JSR	(_Write,PC)		;496f8: 4eba7a86
	LEA	($C,A7),A7		;496fc: 4fef000c
	MOVE.L	(-24,A5),-(A7)		;49700: 2f2dffe8
	MOVE.L	(-432,A5),-(A7)		;49704: 2f2dfe50
	MOVE.L	(-28,A5),-(A7)		;49708: 2f2dffe4
	JSR	(_Write,PC)		;4970c: 4eba7a72
	LEA	($C,A7),A7		;49710: 4fef000c
	PEA	-1.W			;49714: 4878ffff
	PEA	4.W			;49718: 48780004
	MOVE.L	(-28,A5),-(A7)		;4971c: 2f2dffe4
	JSR	(___Seek,A4)		;49720: 4eac81ee
	LEA	($C,A7),A7		;49724: 4fef000c
	SUBQ.L	#8,D0			;49728: 5180
	MOVE.L	D0,(-24,A5)		;4972a: 2b40ffe8
	PEA	4.W			;4972e: 48780004
	PEA	(-24,A5)		;49732: 486dffe8
	MOVE.L	(-28,A5),-(A7)		;49736: 2f2dffe4
	JSR	(_Write,PC)		;4973a: 4eba7a44
	LEA	($C,A7),A7		;4973e: 4fef000c
	MOVEA.L	(-438,A5),A0		;49742: 206dfe4a
	MOVEQ	#0,D0			;49746: 7000
	MOVE.B	(5,A0),D0		;49748: 10280005
	MOVEA.L	(-438,A5),A0		;4974c: 206dfe4a
	MULU	(2,A0),D0		;49750: c0e80002
	MOVEA.L	(-438,A5),A0		;49754: 206dfe4a
	MULU	(A0),D0			;49758: c0d0
	MOVEQ	#0,D1			;4975a: 7200
	MOVE.W	D0,D1			;4975c: 3200
	MOVE.L	D1,-(A7)		;4975e: 2f01
	MOVE.L	(-432,A5),-(A7)		;49760: 2f2dfe50
	JSR	(___FreeMem,A4)		;49764: 4eac820c
	ADDQ.W	#8,A7			;49768: 504f
	MOVE.L	(-28,A5),-(A7)		;4976a: 2f2dffe4
	JSR	(___Close,A4)		;4976e: 4eac81d6
	ADDQ.W	#4,A7			;49772: 584f
	BRA.W	LAB_4946A		;49774: 6000fcf4
LAB_49778:
	;49778
	;DC.B	$25,$73,$2e,$25,$6c,$64,$00
	DC.B	"%s.%ld",0
LAB_4977F:
	;4977f
	;DC.B	$46,$4f,$52,$4d,$20,$20,$20,$20,$49,$4c,$42,$4d,$42,$4d,$48,$44
	;DC.B	$00
	DC.B	"FORM    ILBMBMHD",0
LAB_49790:
	;49790
	;DC.B	$43,$4d,$41,$50,$00
	DC.B	"CMAP",0
LAB_49795:
	;49795
	;DC.B	$43,$52,$4e,$47,$00
	DC.B	"CRNG",0
LAB_4979A:
	;4979a
	;DC.B	$42,$4f,$44,$59,$00,$00
	DC.B	"BODY",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_save_picture_body:
	LINK.W	A5,#-12			;497a0: 4e55fff4
	CLR.L	(-12,A5)		;497a4: 42adfff4
	CLR.W	(-2,A5)			;497a8: 426dfffe
	BRA.S	LAB_49814		;497ac: 6066
LAB_497AE:
	CLR.W	(-4,A5)			;497ae: 426dfffc
	BRA.S	LAB_49800		;497b2: 604c
LAB_497B4:
	MOVE.W	(LAB_51618,A4),-(A7)	;497b4: 3f2c822a
	MOVE.W	(-4,A5),D0		;497b8: 302dfffc
	EXT.L	D0			;497bc: 48c0
	ASL.L	#2,D0			;497be: e580
	MOVEA.L	D0,A0			;497c0: 2040
	ADDA.L	($C,A5),A0		;497c2: d1ed000c
	MOVEA.L	($C,A5),A1		;497c6: 226d000c
	MOVE.W	(A1),D0			;497ca: 3011
	MULU	(-2,A5),D0		;497cc: c0edfffe
	MOVEQ	#0,D1			;497d0: 7200
	MOVE.W	D0,D1			;497d2: 3200
	MOVEA.L	(8,A0),A1		;497d4: 22680008
	ADDA.L	D1,A1			;497d8: d3c1
	MOVE.L	A1,-(A7)		;497da: 2f09
	MOVE.L	(8,A5),-(A7)		;497dc: 2f2d0008
	BSR.S	_pack_picture_bits	;497e0: 6148
	LEA	($A,A7),A7		;497e2: 4fef000a
	EXT.L	D0			;497e6: 48c0
	MOVE.L	D0,(-8,A5)		;497e8: 2b40fff8
	MOVE.L	(-8,A5),D0		;497ec: 202dfff8
	ADD.L	D0,(8,A5)		;497f0: d1ad0008
	MOVE.L	(-8,A5),D0		;497f4: 202dfff8
	ADD.L	D0,(-12,A5)		;497f8: d1adfff4
	ADDQ.W	#1,(-4,A5)		;497fc: 526dfffc
LAB_49800:
	MOVEA.L	($C,A5),A0		;49800: 206d000c
	MOVEQ	#0,D0			;49804: 7000
	MOVE.B	(5,A0),D0		;49806: 10280005
	CMP.W	(-4,A5),D0		;4980a: b06dfffc
	BNE.S	LAB_497B4		;4980e: 66a4
	ADDQ.W	#1,(-2,A5)		;49810: 526dfffe
LAB_49814:
	MOVEA.L	($C,A5),A0		;49814: 206d000c
	MOVE.W	(2,A0),D0		;49818: 30280002
	CMP.W	(-2,A5),D0		;4981c: b06dfffe
	BNE.S	LAB_497AE		;49820: 668c
	MOVE.L	(-12,A5),D0		;49822: 202dfff4
	UNLK	A5			;49826: 4e5d
	RTS				;49828: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_pack_picture_bits:
	LINK.W	A5,#0			;4982a: 4e550000
	MOVEM.L	D4-D6/A2-A3,-(A7)	;4982e: 48e70e30
	MOVEA.L	($C,A5),A2		;49832: 246d000c
	MOVE.W	($10,A5),D4		;49836: 382d0010
	MOVEQ	#0,D5			;4983a: 7a00
	MOVEA.L	(8,A5),A3		;4983c: 266d0008
	MOVE.W	D4,D0			;49840: 3004
	ADD.W	#$000f,D0		;49842: d07c000f
	LSR.W	#4,D0			;49846: e848
	ASL.W	#1,D0			;49848: e340
	MOVE.W	D0,D4			;4984a: 3800
	SUBQ.W	#1,D4			;4984c: 5344
LAB_4984E:
	MOVE.W	D4,D0			;4984e: 3004
	ADDQ.W	#1,D0			;49850: 5240
	CMP.W	D0,D5			;49852: ba40
	BCC.W	LAB_49906		;49854: 640000b0
	CLR.B	(A3)			;49858: 4213
	MOVE.B	(0,A2,D5.W),(1,A3)	;4985a: 177250000001
	MOVE.W	D5,D0			;49860: 3005
	EXT.L	D0			;49862: 48c0
	MOVEA.L	D0,A0			;49864: 2040
	ADDA.L	A2,A0			;49866: d1ca
	MOVE.B	(0,A2,D5.W),D0		;49868: 10325000
	CMP.B	(1,A0),D0		;4986c: b0280001
	BEQ.S	LAB_49876		;49870: 6704
	CMP.W	D4,D5			;49872: ba44
	BNE.S	LAB_498A0		;49874: 662a
LAB_49876:
	MOVE.W	D5,D6			;49876: 3c05
LAB_49878:
	MOVE.W	D5,D0			;49878: 3005
	EXT.L	D0			;4987a: 48c0
	MOVEA.L	D0,A0			;4987c: 2040
	ADDA.L	A2,A0			;4987e: d1ca
	MOVE.B	(0,A2,D5.W),D0		;49880: 10325000
	CMP.B	(1,A0),D0		;49884: b0280001
	BNE.S	LAB_49892		;49888: 6608
	CMP.W	D4,D5			;4988a: ba44
	BCC.S	LAB_49892		;4988c: 6404
	ADDQ.W	#1,D5			;4988e: 5245
	BRA.S	LAB_49878		;49890: 60e6
LAB_49892:
	MOVE.W	D5,D0			;49892: 3005
	SUB.W	D6,D0			;49894: 9046
	NEG.W	D0			;49896: 4440
	MOVE.B	D0,(A3)			;49898: 1680
	ADDQ.L	#2,A3			;4989a: 548b
	ADDQ.W	#1,D5			;4989c: 5245
	BRA.S	LAB_49902		;4989e: 6062
LAB_498A0:
	MOVE.W	D5,D6			;498a0: 3c05
LAB_498A2:
	MOVE.W	D5,D0			;498a2: 3005
	EXT.L	D0			;498a4: 48c0
	MOVEA.L	D0,A0			;498a6: 2040
	ADDA.L	A2,A0			;498a8: d1ca
	MOVE.B	(0,A2,D5.W),D0		;498aa: 10325000
	CMP.B	(1,A0),D0		;498ae: b0280001
	BEQ.S	LAB_498BC		;498b2: 6708
	CMP.W	D4,D5			;498b4: ba44
	BCC.S	LAB_498BC		;498b6: 6404
	ADDQ.W	#1,D5			;498b8: 5245
	BRA.S	LAB_498A2		;498ba: 60e6
LAB_498BC:
	MOVE.W	D5,D0			;498bc: 3005
	SUB.W	D6,D0			;498be: 9046
	MOVE.W	D0,-(A7)		;498c0: 3f00
	MOVEA.L	A3,A0			;498c2: 204b
	ADDQ.L	#1,A0			;498c4: 5288
	MOVE.L	A0,-(A7)		;498c6: 2f08
	MOVE.W	D6,D0			;498c8: 3006
	EXT.L	D0			;498ca: 48c0
	ADD.L	A2,D0			;498cc: d08a
	MOVE.L	D0,-(A7)		;498ce: 2f00
	JSR	(_movmem,PC)		;498d0: 4eba6d06
	LEA	($A,A7),A7		;498d4: 4fef000a
	MOVE.W	D5,D0			;498d8: 3005
	SUB.W	D6,D0			;498da: 9046
	MOVE.W	D0,D6			;498dc: 3c00
	SUB.B	D6,(A3)			;498de: 9d13
	CMP.W	D4,D5			;498e0: ba44
	BNE.S	LAB_498F0		;498e2: 660c
	ADDQ.W	#1,D6			;498e4: 5246
	MOVE.B	(0,A2,D5.W),(0,A3,D6.W)	;498e6: 17b250006000
	SUBQ.B	#1,(A3)			;498ec: 5313
	ADDQ.W	#1,D5			;498ee: 5245
LAB_498F0:
	MOVE.B	(A3),D0			;498f0: 1013
	EXT.W	D0			;498f2: 4880
	ADDQ.W	#1,D0			;498f4: 5240
	NEG.W	D0			;498f6: 4440
	MOVE.B	D0,(A3)			;498f8: 1680
	MOVE.W	D6,D0			;498fa: 3006
	ADDQ.W	#1,D0			;498fc: 5240
	EXT.L	D0			;498fe: 48c0
	ADDA.L	D0,A3			;49900: d7c0
LAB_49902:
	BRA.W	LAB_4984E		;49902: 6000ff4a
LAB_49906:
	MOVE.L	A3,D0			;49906: 200b
	SUB.L	(8,A5),D0		;49908: 90ad0008
	MOVEM.L	(A7)+,D4-D6/A2-A3	;4990c: 4cdf0c70
	UNLK	A5			;49910: 4e5d
	RTS				;49912: 4e75
; ------------------------------------------------------------------------------
; Function
; End of new IFF routine
; ------------------------------------------------------------------------------
_drw_blk:
	LINK.W	A5,#0			;49914: 4e550000
	MOVEM.L	D0-D6/A0-A6,-(A7)	;49918: 48e7fefe
	MOVE.W	(8,A5),D0		;4991c: 302d0008
	MOVE.W	($A,A5),D1		;49920: 322d000a
	MOVE.W	($C,A5),D2		;49924: 342d000c
	MOVE.W	($E,A5),D3		;49928: 362d000e
	BSR.W	SUB_49938		;4992c: 6100000a
	MOVEM.L	(A7)+,D0-D6/A0-A6	;49930: 4cdf7f7f
	UNLK	A5			;49934: 4e5d
	RTS				;49936: 4e75
SUB_49938:
	MOVEA.L	_screen_origin,A0	;49938: 207900051630
	ADD.W	D0,D0			;4993e: d040
	ADD.W	D1,D1			;49940: d241
	EXT.L	D0			;49942: 48c0
	EXT.L	D1			;49944: 48c1
	ADDA.L	D0,A0			;49946: d1c0
	SUBA.L	D1,A0			;49948: 91c1
	MULU	#$00a0,D0		;4994a: c0fc00a0
	MULU	#$00a0,D1		;4994e: c2fc00a0
	ADDA.L	D0,A0			;49952: d1c0
	ADDA.L	D1,A0			;49954: d1c1
	MULU	#$0028,D2		;49956: c4fc0028
	SUBA.L	D2,A0			;4995a: 91c2
	BGE.S	LAB_49960		;4995c: 6c02
	RTS				;4995e: 4e75
LAB_49960:
	ADDA.L	_work_screen,A0		;49960: d1f90005c518
	MOVEA.L	_blk_data,A6		;49966: 2c7900052c5e
	MULU	#$01e0,D3		;4996c: c6fc01e0
	ADDA.L	D3,A6			;49970: ddc3
	MOVE.W	#$0017,D5		;49972: 3a3c0017
LAB_49976:
	MOVE.L	(A6)+,D4		;49976: 281e
	MOVE.L	(0,A0),D6		;49978: 2c280000
	AND.L	D4,D6			;4997c: cc84
	OR.L	(A6)+,D6		;4997e: 8c9e
	MOVE.L	D6,(0,A0)		;49980: 21460000
	MOVE.L	($1F40,A0),D6		;49984: 2c281f40
	AND.L	D4,D6			;49988: cc84
	OR.L	(A6)+,D6		;4998a: 8c9e
	MOVE.L	D6,($1F40,A0)		;4998c: 21461f40
	MOVE.L	($3E80,A0),D6		;49990: 2c283e80
	AND.L	D4,D6			;49994: cc84
	OR.L	(A6)+,D6		;49996: 8c9e
	MOVE.L	D6,($3E80,A0)		;49998: 21463e80
	MOVE.L	($5DC0,A0),D6		;4999c: 2c285dc0
	AND.L	D4,D6			;499a0: cc84
	OR.L	(A6)+,D6		;499a2: 8c9e
	MOVE.L	D6,($5DC0,A0)		;499a4: 21465dc0
	ADDA.L	#$00000028,A0		;499a8: d1fc00000028
	DBF	D5,LAB_49976		;499ae: 51cdffc6
	RTS				;499b2: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_draw_it:
	LINK.W	A5,#0			;499b4: 4e550000
	MOVEM.L	D0-D7/A0-A6,-(A7)	;499b8: 48e7fffe
	MOVE.W	(8,A5),D6		;499bc: 3c2d0008
	MOVE.W	($A,A5),D7		;499c0: 3e2d000a
	MOVEA.L	#_map_blk,A1		;499c4: 227c00056376
	MOVEA.L	#_map_alt,A3		;499ca: 267c00057376
	MOVEA.L	#_map_bk2,A2		;499d0: 247c00058376
	MOVEA.L	#_map_who,A0		;499d6: 207c0005b376
	MULU	#$0040,D7		;499dc: cefc0040
	EXT.L	D6			;499e0: 48c6
	ADDA.L	D7,A1			;499e2: d3c7
	ADDA.L	D6,A1			;499e4: d3c6
	ADDA.L	D7,A3			;499e6: d7c7
	ADDA.L	D6,A3			;499e8: d7c6
	MOVE.L	A3,-(A7)		;499ea: 2f0b
	ADDA.L	D7,A2			;499ec: d5c7
	ADDA.L	D6,A2			;499ee: d5c6
	ADDA.L	D7,A0			;499f0: d1c7
	ADDA.L	D6,A0			;499f2: d1c6
	MOVE.W	#$0000,D1		;499f4: 323c0000
LAB_499F8:
	MOVE.W	#$0000,D0		;499f8: 303c0000
LAB_499FC:
	MOVE.B	(A1),D3			;499fc: 1611
	BNE.W	LAB_49A12		;499fe: 66000012
	CMPI.W	#$0000,_toggle		;49a02: 0c79000000052e08
	BNE.W	LAB_49A12		;49a0a: 66000006
	MOVE.W	#$0010,D3		;49a0e: 363c0010
LAB_49A12:
	EXT.W	D3			;49a12: 4883
	MOVE.B	(A3),D2			;49a14: 1413
	EXT.W	D2			;49a16: 4882
	LSL.W	#3,D2			;49a18: e74a
	MOVEM.L	D0-D2/A0,-(A7)		;49a1a: 48e7e080
	BSR.W	SUB_49938		;49a1e: 6100ff18
	MOVEM.L	(A7)+,D0-D2/A0		;49a22: 4cdf0107
	ADDQ.W	#8,D2			;49a26: 5042
	MOVE.B	(A2)+,D3		;49a28: 161a
	BEQ.W	LAB_49A3C		;49a2a: 67000010
	EXT.W	D3			;49a2e: 4883
	MOVEM.L	D0-D2/A0,-(A7)		;49a30: 48e7e080
	BSR.W	SUB_49938		;49a34: 6100ff02
	MOVEM.L	(A7)+,D0-D2/A0		;49a38: 4cdf0107
LAB_49A3C:
	CLR.W	D3			;49a3c: 4243
	MOVE.B	(A0),D3			;49a3e: 1610
	BEQ.W	LAB_49A60		;49a40: 6700001e
	CMPI.L	#$00000a16,_screen_origin ;49a44: 0cb900000a1600051630
	BNE.W	LAB_49A60		;49a4e: 66000010
	EXT.W	D3			;49a52: 4883
	MOVEM.L	D0-D7/A0-A6,-(A7)	;49a54: 48e7fffe
	BSR.W	_move_sprite		;49a58: 61000184
	MOVEM.L	(A7)+,D0-D7/A0-A6	;49a5c: 4cdf7fff
LAB_49A60:
	MOVE.L	A1,D6			;49a60: 2c09
	SUBI.L	#_map_blk,D6		;49a62: 048600056376
	TST.W	_devil_magnet		;49a68: 4a7900054264
	BEQ.W	LAB_49A8C		;49a6e: 6700001c
	CMP.W	_devil_magnet,D6	;49a72: bc7900054264
	BNE.W	LAB_49A8C		;49a78: 66000012
	MOVE.W	#$002e,D3		;49a7c: 363c002e
	MOVEM.L	D0-D2/D6/A0,-(A7)	;49a80: 48e7e280
	BSR.W	SUB_49938		;49a84: 6100feb2
	MOVEM.L	(A7)+,D0-D2/D6/A0	;49a88: 4cdf0147
LAB_49A8C:
	TST.W	_god_magnet		;49a8c: 4a7900054266
	BEQ.W	LAB_49AB0		;49a92: 6700001c
	CMP.W	_god_magnet,D6		;49a96: bc7900054266
	BNE.W	LAB_49AB0		;49a9c: 66000012
	MOVE.W	#$002d,D3		;49aa0: 363c002d
	MOVEM.L	D0-D2/A0,-(A7)		;49aa4: 48e7e080
	BSR.W	SUB_49938		;49aa8: 6100fe8e
	MOVEM.L	(A7)+,D0-D2/A0		;49aac: 4cdf0107
LAB_49AB0:
	ADDA.L	#$00000001,A1		;49ab0: d3fc00000001
	ADDA.L	#$00000001,A0		;49ab6: d1fc00000001
	ADDQ.L	#1,A3			;49abc: 528b
	ADDQ.W	#1,D0			;49abe: 5240
	CMP.W	#$0008,D0		;49ac0: b07c0008
	BNE.W	LAB_499FC		;49ac4: 6600ff36
	ADDA.L	#$00000038,A1		;49ac8: d3fc00000038
	ADDA.L	#$00000038,A2		;49ace: d5fc00000038
	ADDA.L	#$00000038,A0		;49ad4: d1fc00000038
	ADDA.L	#$00000038,A3		;49ada: d7fc00000038
	ADDQ.W	#1,D1			;49ae0: 5241
	CMP.W	#$0008,D1		;49ae2: b27c0008
	BNE.W	LAB_499F8		;49ae6: 6600ff10
	MOVEA.L	(A7)+,A3		;49aea: 265f
	ADDA.L	#$00000007,A3		;49aec: d7fc00000007
	MOVEA.L	_work_screen,A0		;49af2: 20790005c518
	ADDA.L	_screen_origin,A0	;49af8: d1f900051630
	ADDA.L	#$00000a10,A0		;49afe: d1fc00000a10
	MOVEA.L	_sprite_data,A2		;49b04: 247900052c56
	ADDA.L	#$00003020,A2		;49b0a: d5fc00003020
	MOVE.W	#$0007,D1		;49b10: 323c0007
LAB_49B14:
	MOVE.B	(A3),D2			;49b14: 1413
	BEQ.W	LAB_49B30		;49b16: 67000018
	MOVEA.L	A0,A1			;49b1a: 2248
LAB_49B1C:
	BSR.W	SUB_49B90		;49b1c: 61000072
	SUBA.L	#$00000140,A0		;49b20: 91fc00000140
	SUBI.B	#$01,D2			;49b26: 04020001
	BNE.W	LAB_49B1C		;49b2a: 6600fff0
	MOVEA.L	A1,A0			;49b2e: 2049
LAB_49B30:
	ADDA.L	#$0000013e,A0		;49b30: d1fc0000013e
	ADDA.L	#$00000040,A3		;49b36: d7fc00000040
	DBF	D1,LAB_49B14		;49b3c: 51c9ffd6
	SUBA.L	#$00000040,A3		;49b40: 97fc00000040
	SUBA.L	#$00000140,A0		;49b46: 91fc00000140
	MOVEA.L	_sprite_data,A2		;49b4c: 247900052c56
	ADDA.L	#$00002f80,A2		;49b52: d5fc00002f80
	MOVE.W	#$0007,D0		;49b58: 303c0007
LAB_49B5C:
	MOVE.B	(A3),D2			;49b5c: 1413
	BEQ.W	LAB_49B78		;49b5e: 67000018
	MOVEA.L	A0,A1			;49b62: 2248
LAB_49B64:
	BSR.W	SUB_49B90		;49b64: 6100002a
	SUBA.L	#$00000140,A0		;49b68: 91fc00000140
	SUBI.B	#$01,D2			;49b6e: 04020001
	BNE.W	LAB_49B64		;49b72: 6600fff0
	MOVEA.L	A1,A0			;49b76: 2049
LAB_49B78:
	SUBA.L	#$00000142,A0		;49b78: 91fc00000142
	SUBA.L	#$00000001,A3		;49b7e: 97fc00000001
	DBF	D0,LAB_49B5C		;49b84: 51c8ffd6
	MOVEM.L	(A7)+,D0-D7/A0-A6	;49b88: 4cdf7fff
	UNLK	A5			;49b8c: 4e5d
	RTS				;49b8e: 4e75
SUB_49B90:
	MOVE.W	#$000f,D5		;49b90: 3a3c000f
LAB_49B94:
	MOVE.W	(A2)+,D4		;49b94: 381a
	MOVE.W	(0,A0),D6		;49b96: 3c280000
	AND.W	D4,D6			;49b9a: cc44
	OR.W	(A2)+,D6		;49b9c: 8c5a
	MOVE.W	D6,(0,A0)		;49b9e: 31460000
	MOVE.W	($1F40,A0),D6		;49ba2: 3c281f40
	AND.W	D4,D6			;49ba6: cc44
	OR.W	(A2)+,D6		;49ba8: 8c5a
	MOVE.W	D6,($1F40,A0)		;49baa: 31461f40
	MOVE.W	($3E80,A0),D6		;49bae: 3c283e80
	AND.W	D4,D6			;49bb2: cc44
	OR.W	(A2)+,D6		;49bb4: 8c5a
	MOVE.W	D6,($3E80,A0)		;49bb6: 31463e80
	MOVE.W	($5DC0,A0),D6		;49bba: 3c285dc0
	AND.W	D4,D6			;49bbe: cc44
	OR.W	(A2)+,D6		;49bc0: 8c5a
	MOVE.W	D6,($5DC0,A0)		;49bc2: 31465dc0
	ADDA.L	#$00000028,A0		;49bc6: d1fc00000028
	DBF	D5,LAB_49B94		;49bcc: 51cdffc6
	SUBA.L	#$00000280,A0		;49bd0: 91fc00000280
	SUBA.L	#$000000a0,A2		;49bd6: 95fc000000a0
	RTS				;49bdc: 4e75
_move_sprite:
	LSL.W	#3,D0			;49bde: e748
	LSL.W	#3,D1			;49be0: e749
	MOVE.W	D0,D5			;49be2: 3a00
	ADD.W	D1,D5			;49be4: da41
	SUB.W	D2,D5			;49be6: 9a42
	LSL.W	#1,D0			;49be8: e348
	LSL.W	#1,D1			;49bea: e349
	MOVE.W	D0,D4			;49bec: 3800
	SUB.W	D1,D4			;49bee: 9841
	CLR.W	D7			;49bf0: 4247
	MOVE.B	(A0),D7			;49bf2: 1e10
	SUBI.W	#$0001,D7		;49bf4: 04470001
	MOVE.W	D7,-(A7)		;49bf8: 3f07
	MULU	#$0016,D7		;49bfa: cefc0016
	MOVEA.L	#_peeps,A2		;49bfe: 247c00053014
	ADDA.L	D7,A2			;49c04: d5c7
	MOVE.B	(0,A2),D6		;49c06: 1c2a0000
	ANDI.W	#$00f8,D6		;49c0a: 024600f8
	MOVE.B	(1,A2),D7		;49c0e: 1e2a0001
	EXT.W	D7			;49c12: 4887
	CMP.W	_player,D7		;49c14: be7900052de2
	BNE.W	LAB_49C2C		;49c1a: 66000010
	MOVE.B	(0,A2),D6		;49c1e: 1c2a0000
	TST.W	($12,A2)		;49c22: 4a6a0012
	BEQ.S	LAB_49C2C		;49c26: 6704
	ORI.W	#$0001,D6		;49c28: 00460001
LAB_49C2C:
	CMPI.W	#$00d1,(A7)+		;49c2c: 0c5f00d1
	BGE.S	LAB_49C38		;49c30: 6c06
	OR.W	D6,_ok_to_build		;49c32: 8d7900052e0c
LAB_49C38:
	MOVE.B	(0,A2),D7		;49c38: 1e2a0000
	CMP.B	#$02,D7			;49c3c: be3c0002
	BEQ.W	LAB_49D3E		;49c40: 670000fc
	CMP.B	#$01,D7			;49c44: be3c0001
	BEQ.W	LAB_49D16		;49c48: 670000cc
	BTST	#4,D7			;49c4c: 08070004
	BNE.W	LAB_49D3E		;49c50: 660000ec
	BTST	#5,D7			;49c54: 08070005
	BNE.W	LAB_49CCC		;49c58: 66000072
	BTST	#6,D7			;49c5c: 08070006
	BNE.W	LAB_49CCC		;49c60: 6600006a
	BTST	#3,D7			;49c64: 08070003
	BNE.W	LAB_49CF8		;49c68: 6600008e
	BTST	#7,D7			;49c6c: 08070007
	BNE.W	LAB_49CA4		;49c70: 66000032
	ADDI.W	#$00c0,D4		;49c74: 064400c0
	ADDI.W	#$0040,D5		;49c78: 06450040
	MOVE.W	($C,A2),D6		;49c7c: 3c2a000c
	TST.L	($E,A2)			;49c80: 4aaa000e
	BEQ.W	LAB_49C8C		;49c84: 67000006
	ADDI.W	#$0020,D6		;49c88: 06460020
LAB_49C8C:
	TST.B	(1,A2)			;49c8c: 4a2a0001
	BEQ.S	LAB_49C96		;49c90: 6704
	ADDI.W	#$0004,D6		;49c92: 06460004
LAB_49C96:
	CLR.W	D1			;49c96: 4241
	MOVE.B	(A0),D1			;49c98: 1210
	BSR.W	SUB_49F72		;49c9a: 610002d6
	RTS				;49c9e: 4e75
	BRA.W	LAB_49F70		;49ca0: 600002ce
LAB_49CA4:
	BSET	#7,_sound_effect	;49ca4: 08f9000700052e0e
	ADDI.W	#$00b8,D4		;49cac: 064400b8
	ADDI.W	#$0040,D5		;49cb0: 06450040
	MOVE.W	_game_turn,D6		;49cb4: 3c3900054258
	ANDI.W	#$0003,D6		;49cba: 02460003
	ADDI.W	#$0069,D6		;49cbe: 06460069
	CLR.W	D1			;49cc2: 4241
	MOVE.B	(A0),D1			;49cc4: 1210
	BSR.W	SUB_49F72		;49cc6: 610002aa
	RTS				;49cca: 4e75
LAB_49CCC:
	ADDI.W	#$00c0,D4		;49ccc: 064400c0
	ADDI.W	#$0040,D5		;49cd0: 06450040
	MOVE.W	($C,A2),D6		;49cd4: 3c2a000c
	TST.L	($E,A2)			;49cd8: 4aaa000e
	BEQ.W	LAB_49CE4		;49cdc: 67000006
	ADDI.W	#$0018,D6		;49ce0: 06460018
LAB_49CE4:
	TST.B	(1,A2)			;49ce4: 4a2a0001
	BEQ.S	LAB_49CEE		;49ce8: 6704
	ADDI.W	#$0002,D6		;49cea: 06460002
LAB_49CEE:
	CLR.W	D1			;49cee: 4241
	MOVE.B	(A0),D1			;49cf0: 1210
	BSR.W	SUB_49F72		;49cf2: 6100027e
	RTS				;49cf6: 4e75
LAB_49CF8:
	BSET	#3,_sound_effect	;49cf8: 08f9000300052e0e
	ADDI.W	#$00c0,D4		;49d00: 064400c0
	ADDI.W	#$0040,D5		;49d04: 06450040
	MOVE.W	($C,A2),D6		;49d08: 3c2a000c
	CLR.W	D1			;49d0c: 4241
	MOVE.B	(A0),D1			;49d0e: 1210
	BSR.W	SUB_49F72		;49d10: 61000260
	RTS				;49d14: 4e75
LAB_49D16:
	ADDI.W	#$00c0,D4		;49d16: 064400c0
	ADDI.W	#$0040,D5		;49d1a: 06450040
	MOVE.W	#$0040,D6		;49d1e: 3c3c0040
	ADD.W	_toggle,D6		;49d22: dc7900052e08
	TST.B	(1,A2)			;49d28: 4a2a0001
	BEQ.W	LAB_49D34		;49d2c: 67000006
	ADDI.W	#$0002,D6		;49d30: 06460002
LAB_49D34:
	CLR.W	D1			;49d34: 4241
	MOVE.B	(A0),D1			;49d36: 1210
	BSR.W	SUB_49F72		;49d38: 61000238
	RTS				;49d3c: 4e75
LAB_49D3E:
	CMPI.W	#$0008,($C,A2)		;49d3e: 0c6a0008000c
	BLT.W	LAB_49D60		;49d44: 6d00001a
	MOVEM.L	D0-D7/A0-A6,-(A7)	;49d48: 48e7fffe
	MOVE.L	A2,-(A7)		;49d4c: 2f0a
	JSR	_debug			;49d4e: 4eb90003e52e
	ADDA.L	#$00000004,A7		;49d54: dffc00000004
	MOVEM.L	(A7)+,D0-D7/A0-A6	;49d5a: 4cdf7fff
	RTS				;49d5e: 4e75
LAB_49D60:
	MOVE.B	(A3),D6			;49d60: 1c13
	MOVE.W	($A,A2),D7		;49d62: 3e2a000a
	EXT.L	D7			;49d66: 48c7
	ADDA.L	D7,A3			;49d68: d7c7
	SUB.B	(A3),D6			;49d6a: 9c13
	EXT.W	D6			;49d6c: 4886
	MULS	($C,A2),D6		;49d6e: cdea000c
	ADD.W	D6,D5			;49d72: da46
	CMPI.B	#$0f,(A1)		;49d74: 0c11000f
	BEQ.W	LAB_49D80		;49d78: 67000006
	ADDI.W	#$0004,D5		;49d7c: 06450004
LAB_49D80:
	CMP.W	#$ffbf,D7		;49d80: be7cffbf
	BNE.W	LAB_49DAE		;49d84: 66000028
	CMPI.W	#$0004,($C,A2)		;49d88: 0c6a0004000c
	BLE.W	LAB_49D9E		;49d8e: 6f00000e
	TST.W	D0			;49d92: 4a40
	BEQ.W	LAB_49F70		;49d94: 670001da
	TST.W	D1			;49d98: 4a41
	BEQ.W	LAB_49F70		;49d9a: 670001d4
LAB_49D9E:
	MOVE.W	#$0000,D0		;49d9e: 303c0000
	MOVE.W	#$fffe,D1		;49da2: 323cfffe
	MOVE.W	#$0000,D6		;49da6: 3c3c0000
	BRA.W	LAB_49EF0		;49daa: 60000144
LAB_49DAE:
	CMP.W	#$ffc0,D7		;49dae: be7cffc0
	BNE.W	LAB_49DD6		;49db2: 66000022
	CMPI.W	#$0004,($C,A2)		;49db6: 0c6a0004000c
	BLE.W	LAB_49DC6		;49dbc: 6f000008
	TST.W	D1			;49dc0: 4a41
	BEQ.W	LAB_49F70		;49dc2: 670001ac
LAB_49DC6:
	MOVE.W	#$0002,D0		;49dc6: 303c0002
	MOVE.W	#$ffff,D1		;49dca: 323cffff
	MOVE.W	#$0002,D6		;49dce: 3c3c0002
	BRA.W	LAB_49EF0		;49dd2: 6000011c
LAB_49DD6:
	CMP.W	#$ffc1,D7		;49dd6: be7cffc1
	BNE.W	LAB_49E06		;49dda: 6600002a
	CMPI.W	#$0004,($C,A2)		;49dde: 0c6a0004000c
	BLE.W	LAB_49DF6		;49de4: 6f000010
	CMP.W	#$0070,D0		;49de8: b07c0070
	BEQ.W	LAB_49F70		;49dec: 67000182
	TST.W	D1			;49df0: 4a41
	BEQ.W	LAB_49F70		;49df2: 6700017c
LAB_49DF6:
	MOVE.W	#$0004,D0		;49df6: 303c0004
	MOVE.W	#$0000,D1		;49dfa: 323c0000
	MOVE.W	#$0004,D6		;49dfe: 3c3c0004
	BRA.W	LAB_49EF0		;49e02: 600000ec
LAB_49E06:
	CMP.W	#$0001,D7		;49e06: be7c0001
	BNE.W	LAB_49E30		;49e0a: 66000024
	CMPI.W	#$0004,($C,A2)		;49e0e: 0c6a0004000c
	BLE.W	LAB_49E20		;49e14: 6f00000a
	CMP.W	#$0070,D0		;49e18: b07c0070
	BEQ.W	LAB_49F70		;49e1c: 67000152
LAB_49E20:
	MOVE.W	#$0002,D0		;49e20: 303c0002
	MOVE.W	#$0001,D1		;49e24: 323c0001
	MOVE.W	#$0006,D6		;49e28: 3c3c0006
	BRA.W	LAB_49EF0		;49e2c: 600000c2
LAB_49E30:
	CMP.W	#$0041,D7		;49e30: be7c0041
	BNE.W	LAB_49E62		;49e34: 6600002c
	CMPI.W	#$0004,($C,A2)		;49e38: 0c6a0004000c
	BLE.W	LAB_49E52		;49e3e: 6f000012
	CMP.W	#$0070,D0		;49e42: b07c0070
	BEQ.W	LAB_49F70		;49e46: 67000128
	CMP.W	#$0070,D1		;49e4a: b27c0070
	BEQ.W	LAB_49F70		;49e4e: 67000120
LAB_49E52:
	MOVE.W	#$0000,D0		;49e52: 303c0000
	MOVE.W	#$0002,D1		;49e56: 323c0002
	MOVE.W	#$0008,D6		;49e5a: 3c3c0008
	BRA.W	LAB_49EF0		;49e5e: 60000090
LAB_49E62:
	CMP.W	#$0040,D7		;49e62: be7c0040
	BNE.W	LAB_49E8C		;49e66: 66000024
	CMPI.W	#$0004,($C,A2)		;49e6a: 0c6a0004000c
	BLE.W	LAB_49E7C		;49e70: 6f00000a
	CMP.W	#$0070,D1		;49e74: b27c0070
	BEQ.W	LAB_49F70		;49e78: 670000f6
LAB_49E7C:
	MOVE.W	#$fffe,D0		;49e7c: 303cfffe
	MOVE.W	#$0001,D1		;49e80: 323c0001
	MOVE.W	#$000a,D6		;49e84: 3c3c000a
	BRA.W	LAB_49EF0		;49e88: 60000066
LAB_49E8C:
	CMP.W	#$003f,D7		;49e8c: be7c003f
	BNE.W	LAB_49EBC		;49e90: 6600002a
	CMPI.W	#$0004,($C,A2)		;49e94: 0c6a0004000c
	BLE.W	LAB_49EAC		;49e9a: 6f000010
	TST.W	D0			;49e9e: 4a40
	BEQ.W	LAB_49F70		;49ea0: 670000ce
	CMP.W	#$0070,D1		;49ea4: b27c0070
	BEQ.W	LAB_49F70		;49ea8: 670000c6
LAB_49EAC:
	MOVE.W	#$fffc,D0		;49eac: 303cfffc
	MOVE.W	#$0000,D1		;49eb0: 323c0000
	MOVE.W	#$000c,D6		;49eb4: 3c3c000c
	BRA.W	LAB_49EF0		;49eb8: 60000036
LAB_49EBC:
	CMP.W	#$ffff,D7		;49ebc: be7cffff
	BNE.W	LAB_49EE4		;49ec0: 66000022
	CMPI.W	#$0004,($C,A2)		;49ec4: 0c6a0004000c
	BLE.W	LAB_49ED4		;49eca: 6f000008
	TST.W	D0			;49ece: 4a40
	BEQ.W	LAB_49F70		;49ed0: 6700009e
LAB_49ED4:
	MOVE.W	#$fffe,D0		;49ed4: 303cfffe
	MOVE.W	#$ffff,D1		;49ed8: 323cffff
	MOVE.W	#$000e,D6		;49edc: 3c3c000e
	BRA.W	LAB_49EF0		;49ee0: 6000000e
LAB_49EE4:
	MOVE.W	#$0000,D0		;49ee4: 303c0000
	MOVE.W	#$0000,D1		;49ee8: 323c0000
	MOVE.W	#$0008,D6		;49eec: 3c3c0008
LAB_49EF0:
	MOVE.B	(A0),D7			;49ef0: 1e10
	ANDI.W	#$00ff,D7		;49ef2: 024700ff
	CMP.W	#$00d1,D7		;49ef6: be7c00d1
	BLT.S	LAB_49F04		;49efa: 6d08
	MOVE.W	(6,A2),D6		;49efc: 3c2a0006
	BRA.W	LAB_49F54		;49f00: 60000052
LAB_49F04:
	MOVE.B	(0,A2),D7		;49f04: 1e2a0000
	BTST	#4,D7			;49f08: 08070004
	BEQ.S	LAB_49F38		;49f0c: 672a
	MOVE.W	_game_turn,D6		;49f0e: 3c3900054258
	ANDI.W	#$0003,D6		;49f14: 02460003
	ADDI.W	#$005d,D6		;49f18: 0646005d
	TST.L	($E,A2)			;49f1c: 4aaa000e
	BEQ.W	LAB_49F28		;49f20: 67000006
	ADDI.W	#$0010,D6		;49f24: 06460010
LAB_49F28:
	TST.B	(1,A2)			;49f28: 4a2a0001
	BEQ.W	LAB_49F54		;49f2c: 67000026
	ADDI.W	#$0004,D6		;49f30: 06460004
	BRA.W	LAB_49F54		;49f34: 6000001e
LAB_49F38:
	TST.W	($E,A2)			;49f38: 4a6a000e
	BEQ.S	LAB_49F42		;49f3c: 6704
	ADDI.W	#$0020,D6		;49f3e: 06460020
LAB_49F42:
	TST.B	(1,A2)			;49f42: 4a2a0001
	BEQ.W	LAB_49F4E		;49f46: 67000006
	ADDI.W	#$0010,D6		;49f4a: 06460010
LAB_49F4E:
	ADD.W	_toggle,D6		;49f4e: dc7900052e08
LAB_49F54:
	MULS	($C,A2),D0		;49f54: c1ea000c
	MULS	($C,A2),D1		;49f58: c3ea000c
	ADD.W	D0,D4			;49f5c: d840
	ADD.W	D1,D5			;49f5e: da41
	ADDI.W	#$0040,D5		;49f60: 06450040
	ADDI.W	#$00b8,D4		;49f64: 064400b8
	CLR.W	D1			;49f68: 4241
	MOVE.B	(A0),D1			;49f6a: 1210
	BSR.W	SUB_49F72		;49f6c: 61000004
LAB_49F70:
	RTS				;49f70: 4e75
SUB_49F72:
	MOVE.W	_no_sprites,D0		;49f72: 303900052e0a
	MULU	#$0008,D0		;49f78: c0fc0008
	LEA	_sprite,A6		;49f7c: 4df900052e10
	ADDA.L	D0,A6			;49f82: ddc0
	MOVE.W	D4,(0,A6)		;49f84: 3d440000
	MOVE.W	D5,(2,A6)		;49f88: 3d450002
	MOVE.W	D6,(4,A6)		;49f8c: 3d460004
	MOVE.W	D1,(6,A6)		;49f90: 3d410006
	ADDI.W	#$0001,_no_sprites	;49f94: 0679000100052e0a
	CMP.W	_view_who,D1		;49f9c: b27900054256
	BNE.W	LAB_49FCE		;49fa2: 6600002a
	ADDA.L	#$00000008,A6		;49fa6: ddfc00000008
	ADDI.W	#$0008,D4		;49fac: 06440008
	MOVE.W	D4,(0,A6)		;49fb0: 3d440000
	SUBI.W	#$0008,D4		;49fb4: 04440008
	MOVE.W	D5,(2,A6)		;49fb8: 3d450002
	MOVE.W	#$0044,(4,A6)		;49fbc: 3d7c00440004
	MOVE.W	D1,(6,A6)		;49fc2: 3d410006
	ADDI.W	#$0001,_no_sprites	;49fc6: 0679000100052e0a
LAB_49FCE:
	MOVE.B	(1,A2),D6		;49fce: 1c2a0001
	EXT.W	D6			;49fd2: 4886
	MOVEA.L	#_magnet,A2		;49fd4: 247c00052de4
	TST.W	D6			;49fda: 4a46
	BEQ.W	LAB_49FE6		;49fdc: 67000008
	ADDA.L	#$00000010,A2		;49fe0: d5fc00000010
LAB_49FE6:
	TST.W	(0,A2)			;49fe6: 4a6a0000
	BEQ.W	LAB_4A01C		;49fea: 67000030
	CMP.W	(0,A2),D1		;49fee: b26a0000
	BNE.W	LAB_4A01C		;49ff2: 66000028
	ADDI.W	#$004a,D6		;49ff6: 0646004a
	ADDA.L	#$00000008,A6		;49ffa: ddfc00000008
	ADDI.W	#$0008,D4		;4a000: 06440008
	MOVE.W	D4,(0,A6)		;4a004: 3d440000
	MOVE.W	D5,(2,A6)		;4a008: 3d450002
	MOVE.W	D6,(4,A6)		;4a00c: 3d460004
	MOVE.W	D1,(6,A6)		;4a010: 3d410006
	ADDI.W	#$0001,_no_sprites	;4a014: 0679000100052e0a
LAB_4A01C:
	RTS				;4a01c: 4e75
	DS.W	1			;4a01e
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_clr_wsc:
	LINK.W	A5,#0			;4a020: 4e550000
	MOVEM.L	A0-A1,-(A7)		;4a024: 48e700c0
	MOVEA.L	_w_screen,A0		;4a028: 207900052dd6
	MOVEA.L	_back_scr,A1		;4a02e: 227900052c62
	MOVE.W	#$1f3f,D0		;4a034: 303c1f3f
LAB_4A038:
	MOVE.L	(A1)+,(A0)+		;4a038: 20d9
	DBF	D0,LAB_4A038		;4a03a: 51c8fffc
	MOVEM.L	(A7)+,A0-A1		;4a03e: 4cdf0300
	UNLK	A5			;4a042: 4e5d
	RTS				;4a044: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_copy_screen:
	LINK.W	A5,#0			;4a046: 4e550000
	MOVEM.L	A0-A1,-(A7)		;4a04a: 48e700c0
	MOVEA.L	(8,A5),A1		;4a04e: 226d0008
	MOVEA.L	($C,A5),A0		;4a052: 206d000c
; 8000
	MOVE.W	#$1f3f,D0		;4a056: 303c1f3f
LAB_4A05A:
	MOVE.L	(A1)+,(A0)+		;4a05a: 20d9
	DBF	D0,LAB_4A05A		;4a05c: 51c8fffc
	MOVEM.L	(A7)+,A0-A1		;4a060: 4cdf0300
	UNLK	A5			;4a064: 4e5d
	RTS				;4a066: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_open_screen:
	LINK.W	A5,#-6			;4a068: 4e55fffa
	CLR.W	(-6,A5)			;4a06c: 426dfffa
LAB_4A070:
	MOVE.W	(-6,A5),D0		;4a070: 302dfffa
	EXT.L	D0			;4a074: 48c0
	ASL.L	#2,D0			;4a076: e580
	LEA	(_copper_list,A4),A0	;4a078: 41ec9884
	MOVE.W	(-6,A5),D1		;4a07c: 322dfffa
	MULS	#$012c,D1		;4a080: c3fc012c
	ADD.L	(_copper_list,A4),D1	;4a084: d2ac9884
	MOVE.L	D1,(0,A0,D0.L)		;4a088: 21810800
	MOVE.W	(-6,A5),D0		;4a08c: 302dfffa
	EXT.L	D0			;4a090: 48c0
	ASL.L	#2,D0			;4a092: e580
	LEA	(_screen_pointer,A4),A0	;4a094: 41ec9878
	MOVE.W	(-6,A5),D1		;4a098: 322dfffa
	MULS	#$7d00,D1		;4a09c: c3fc7d00
	ADD.L	(_screen_pointer,A4),D1	;4a0a0: d2ac9878
	MOVE.L	D1,(0,A0,D0.L)		;4a0a4: 21810800
	MOVE.W	#$0004,-(A7)		;4a0a8: 3f3c0004
	PEA	(_sprite_list,A4)	;4a0ac: 486c30e0
	PEA	(_palette,A4)		;4a0b0: 486c83ca
	MOVE.W	(-6,A5),D0		;4a0b4: 302dfffa
	EXT.L	D0			;4a0b8: 48c0
	ASL.L	#2,D0			;4a0ba: e580
	LEA	(_screen_pointer,A4),A0	;4a0bc: 41ec9878
	MOVE.L	(0,A0,D0.L),-(A7)	;4a0c0: 2f300800
	MOVE.W	(-6,A5),D0		;4a0c4: 302dfffa
	EXT.L	D0			;4a0c8: 48c0
	ASL.L	#2,D0			;4a0ca: e580
	LEA	(_copper_list,A4),A0	;4a0cc: 41ec9884
	MOVE.L	(0,A0,D0.L),-(A7)	;4a0d0: 2f300800
	JSR	(_make_copper,PC)	;4a0d4: 4eba2990
	LEA	($12,A7),A7		;4a0d8: 4fef0012
	ADDQ.W	#1,(-6,A5)		;4a0dc: 526dfffa
	CMPI.W	#$0002,(-6,A5)		;4a0e0: 0c6d0002fffa
	BLT.S	LAB_4A070		;4a0e6: 6d88
	MOVE.L	(_screen_pointer,A4),(_d_screen,A4) ;4a0e8: 296c987899ec
	MOVE.L	(LAB_52C6A,A4),(_w_screen,A4) ;4a0ee: 296c987c99e8
	UNLK	A5			;4a0f4: 4e5d
	RTS				;4a0f6: 4e75
; ------------------------------------------------------------------------------
; Function
; Loads background
; ------------------------------------------------------------------------------
_read_back_scr:
	LINK.W	A5,#-8			;4a0f8: 4e55fff8
	PEA	$3ED.W			;4a0fc: 487803ed
	PEA	(strQaz,PC)		;4a100: 487a006c
	JSR	(___Open,A4)		;4a104: 4eac81e2
	ADDQ.W	#8,A7			;4a108: 504f
	MOVE.L	D0,(-4,A5)		;4a10a: 2b40fffc
	BEQ.S	return_1_4A16A		;4a10e: 675a
; ------------------------------------------------------------------------------
; lines cut: 4eba 5624 2940 304c
; JSR and move d0 to a4,$304c
; ------------------------------------------------------------------------------
	PEA	$7D00.W			;4a110: 48787d00
	MOVE.L	(_back_scr,A4),-(A7)	;4a114: 2f2c9874
	MOVE.L	(-4,A5),-(A7)		;4a118: 2f2dfffc
	JSR	(___Read,A4)		;4a11c: 4eac81e8
	LEA	($C,A7),A7		;4a120: 4fef000c
	EXT.L	D0			;4a124: 48c0
	MOVE.L	D0,(-8,A5)		;4a126: 2b40fff8
	MOVE.L	(_back_scr,A4),(LAB_52C6E,A4) ;4a12a: 296c98749880
	MOVE.L	(_copper_list,A4),D0	;4a130: 202c9884
	ADD.L	#$00000258,D0		;4a134: d0bc00000258
	MOVE.L	D0,(LAB_52C7A,A4)	;4a13a: 2940988c
	MOVE.W	#$0004,-(A7)		;4a13e: 3f3c0004
	PEA	(_sprite_list,A4)	;4a142: 486c30e0
	PEA	(_palette,A4)		;4a146: 486c83ca
	MOVE.L	(LAB_52C6E,A4),-(A7)	;4a14a: 2f2c9880
	MOVE.L	(LAB_52C7A,A4),-(A7)	;4a14e: 2f2c988c
	JSR	(_make_copper,PC)	;4a152: 4eba2912
	LEA	($12,A7),A7		;4a156: 4fef0012
	MOVE.L	(-4,A5),-(A7)		;4a15a: 2f2dfffc
	JSR	(___Close,A4)		;4a15e: 4eac81d6
	ADDQ.W	#4,A7			;4a162: 584f
	MOVEQ	#0,D0			;4a164: 7000
return0_4A166:
	UNLK	A5			;4a166: 4e5d
	RTS				;4a168: 4e75
return_1_4A16A:
	MOVEQ	#-1,D0			;4a16a: 70ff
	BRA.S	return0_4A166		;4a16c: 60f8
strQaz:
	;4a16e
	;DC.B	$71,$61,$7a,$2e,$70,$69,$63,$00
	DC.B	"qaz.pic",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_read_sprites:
	LINK.W	A5,#-12			;4a176: 4e55fff4
	LEA	(LAB_4A224,PC),A0	;4a17a: 41fa00a8
	MOVE.L	A0,(-12,A5)		;4a17e: 2b48fff4
	MOVE.W	(8,A5),D0		;4a182: 302d0008
	ADD.W	#$0030,D0		;4a186: d07c0030
	MOVEA.L	(-12,A5),A0		;4a18a: 206dfff4
	MOVE.B	D0,(7,A0)		;4a18e: 11400007
	MOVE.W	(8,A5),(_sprites_in,A4)	;4a192: 396d0008989a
	PEA	$3ED.W			;4a198: 487803ed
	MOVE.L	(-12,A5),-(A7)		;4a19c: 2f2dfff4
	JSR	(___Open,A4)		;4a1a0: 4eac81e2
	ADDQ.W	#8,A7			;4a1a4: 504f
	MOVE.L	D0,(-4,A5)		;4a1a6: 2b40fffc
	BEQ.S	LAB_4A1D0		;4a1aa: 6724
	PEA	$5960.W			;4a1ac: 48785960
	MOVE.L	(_sprite_data,A4),-(A7)	;4a1b0: 2f2c9868
	MOVE.L	(-4,A5),-(A7)		;4a1b4: 2f2dfffc
	JSR	(___Read,A4)		;4a1b8: 4eac81e8
	LEA	($C,A7),A7		;4a1bc: 4fef000c
	EXT.L	D0			;4a1c0: 48c0
	MOVE.L	D0,(-8,A5)		;4a1c2: 2b40fff8
	MOVE.L	(-4,A5),-(A7)		;4a1c6: 2f2dfffc
	JSR	(___Close,A4)		;4a1ca: 4eac81d6
	ADDQ.W	#4,A7			;4a1ce: 584f
LAB_4A1D0:
	LEA	(LAB_4A231,PC),A0	;4a1d0: 41fa005f
	MOVE.L	A0,(-12,A5)		;4a1d4: 2b48fff4
	MOVE.W	(8,A5),D0		;4a1d8: 302d0008
	ADD.W	#$0030,D0		;4a1dc: d07c0030
	MOVEA.L	(-12,A5),A0		;4a1e0: 206dfff4
	MOVE.B	D0,(6,A0)		;4a1e4: 11400006
	PEA	$3ED.W			;4a1e8: 487803ed
	MOVE.L	(-12,A5),-(A7)		;4a1ec: 2f2dfff4
	JSR	(___Open,A4)		;4a1f0: 4eac81e2
	ADDQ.W	#8,A7			;4a1f4: 504f
	MOVE.L	D0,(-4,A5)		;4a1f6: 2b40fffc
	BEQ.S	LAB_4A220		;4a1fa: 6724
	PEA	$2080.W			;4a1fc: 48782080
	MOVE.L	(_sprite_data_32,A4),-(A7) ;4a200: 2f2c986c
	MOVE.L	(-4,A5),-(A7)		;4a204: 2f2dfffc
	JSR	(___Read,A4)		;4a208: 4eac81e8
	LEA	($C,A7),A7		;4a20c: 4fef000c
	EXT.L	D0			;4a210: 48c0
	MOVE.L	D0,(-8,A5)		;4a212: 2b40fff8
	MOVE.L	(-4,A5),-(A7)		;4a216: 2f2dfffc
	JSR	(___Close,A4)		;4a21a: 4eac81d6
	ADDQ.W	#4,A7			;4a21e: 584f
LAB_4A220:
	UNLK	A5			;4a220: 4e5d
	RTS				;4a222: 4e75
LAB_4A224:
	;4a224
	;DC.B	$73,$70,$72,$69,$74,$65,$73,$30,$2e,$64,$61,$74,$00
	DC.B	"sprites0.dat",0
LAB_4A231:
	;4a231
	;DC.B	$73,$70,$72,$5f,$33,$32,$30,$2e,$64,$61,$74,$00,$00
	DC.B	"spr_320.dat",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_load_ground:
	LINK.W	A5,#-14			;4a23e: 4e55fff2
	LEA	(strLAND,PC),A0		;4a242: 41fa0202
	MOVE.L	A0,(-14,A5)		;4a246: 2b48fff2
	MOVE.W	(8,A5),D0		;4a24a: 302d0008
	ADD.W	#$0030,D0		;4a24e: d07c0030
	MOVEA.L	(-14,A5),A0		;4a252: 206dfff2
	MOVE.B	D0,(4,A0)		;4a256: 11400004
LAB_4A25A:
	PEA	$3ED.W			;4a25a: 487803ed
	MOVE.L	(-14,A5),-(A7)		;4a25e: 2f2dfff2
	JSR	(___Open,A4)		;4a262: 4eac81e2
	ADDQ.W	#8,A7			;4a266: 504f
	MOVE.L	D0,(-4,A5)		;4a268: 2b40fffc
	BEQ.W	LAB_4A426		;4a26c: 670001b8
	PEA	2.W			;4a270: 48780002
	PEA	(_walk_death,A4)	;4a274: 486c2fb0
	MOVE.L	(-4,A5),-(A7)		;4a278: 2f2dfffc
	JSR	(___Read,A4)		;4a27c: 4eac81e8
	LEA	($C,A7),A7		;4a280: 4fef000c
	PEA	$16.W			;4a284: 48780016
	PEA	(_population_add,A4)	;4a288: 486c2fe2
	MOVE.L	(-4,A5),-(A7)		;4a28c: 2f2dfffc
	JSR	(___Read,A4)		;4a290: 4eac81e8
	LEA	($C,A7),A7		;4a294: 4fef000c
	PEA	$16.W			;4a298: 48780016
	PEA	(_mana_add,A4)		;4a29c: 486c2fb6
	MOVE.L	(-4,A5),-(A7)		;4a2a0: 2f2dfffc
	JSR	(___Read,A4)		;4a2a4: 4eac81e8
	LEA	($C,A7),A7		;4a2a8: 4fef000c
	PEA	$16.W			;4a2ac: 48780016
	PEA	(_weapons_add,A4)	;4a2b0: 486c2fcc
	MOVE.L	(-4,A5),-(A7)		;4a2b4: 2f2dfffc
	JSR	(___Read,A4)		;4a2b8: 4eac81e8
	LEA	($C,A7),A7		;4a2bc: 4fef000c
; ------------------------------------------------------------------------------
; lines cut here
; ------------------------------------------------------------------------------
	PEA	$16.W			;4a2c0: 48780016
	PEA	(_battle_add1,A4)	;4a2c4: 486c2ffa
	MOVE.L	(-4,A5),-(A7)		;4a2c8: 2f2dfffc
	JSR	(___Read,A4)		;4a2cc: 4eac81e8
	LEA	($C,A7),A7		;4a2d0: 4fef000c
	PEA	6.W			;4a2d4: 48780006
	PEA	(_battle_add2,A4)	;4a2d8: 486c3010
	MOVE.L	(-4,A5),-(A7)		;4a2dc: 2f2dfffc
	JSR	(___Read,A4)		;4a2e0: 4eac81e8
	LEA	($C,A7),A7		;4a2e4: 4fef000c
	PEA	$10.W			;4a2e8: 48780010
	PEA	(_map_colour,A4)	;4a2ec: 486c8370
	MOVE.L	(-4,A5),-(A7)		;4a2f0: 2f2dfffc
	JSR	(___Read,A4)		;4a2f4: 4eac81e8
	LEA	($C,A7),A7		;4a2f8: 4fef000c
	PEA	2.W			;4a2fc: 48780002
	PEA	(-6,A5)			;4a300: 486dfffa
	MOVE.L	(-4,A5),-(A7)		;4a304: 2f2dfffc
	JSR	(___Read,A4)		;4a308: 4eac81e8
	LEA	($C,A7),A7		;4a30c: 4fef000c
	PEA	$00008340		;4a310: 487900008340
	MOVE.L	(_blk_data,A4),-(A7)	;4a316: 2f2c9870
	MOVE.L	(-4,A5),-(A7)		;4a31a: 2f2dfffc
	JSR	(___Read,A4)		;4a31e: 4eac81e8
	LEA	($C,A7),A7		;4a322: 4fef000c
	MOVE.L	(-4,A5),-(A7)		;4a326: 2f2dfffc
	JSR	(___Close,A4)		;4a32a: 4eac81d6
	ADDQ.W	#4,A7			;4a32e: 584f
	MOVE.W	(-6,A5),D0		;4a330: 302dfffa
	CMP.W	(_sprites_in,A4),D0	;4a334: b06c989a
	BEQ.S	LAB_4A344		;4a338: 670a
	MOVE.W	(-6,A5),-(A7)		;4a33a: 3f2dfffa
	JSR	(_read_sprites,PC)	;4a33e: 4ebafe36
	ADDQ.W	#2,A7			;4a342: 544f
LAB_4A344:
	CLR.W	(-6,A5)			;4a344: 426dfffa
LAB_4A348:
	MOVE.W	(-6,A5),D0		;4a348: 302dfffa
	LEA	(_map_colour,A4),A0	;4a34c: 41ec8370
	MOVE.W	(-6,A5),D1		;4a350: 322dfffa
	ADD.W	#$0010,D1		;4a354: d27c0010
	LEA	(_map_colour,A4),A1	;4a358: 43ec8370
	MOVE.B	(0,A0,D0.W),(0,A1,D1.W)	;4a35c: 13b000001000
	ADDQ.W	#1,(-6,A5)		;4a362: 526dfffa
	CMPI.W	#$0010,(-6,A5)		;4a366: 0c6d0010fffa
	BLT.S	LAB_4A348		;4a36c: 6dda
	CLR.W	(-6,A5)			;4a36e: 426dfffa
LAB_4A372:
	MOVE.W	(-6,A5),D0		;4a372: 302dfffa
	EXT.L	D0			;4a376: 48c0
	ASL.L	#1,D0			;4a378: e380
	LEA	(_weapons_add,A4),A0	;4a37a: 41ec2fcc
	MOVE.W	(-6,A5),D1		;4a37e: 322dfffa
	EXT.L	D1			;4a382: 48c1
	ASL.L	#1,D1			;4a384: e381
	LEA	(_weapons_order,A4),A1	;4a386: 43ec2f96
	MOVE.W	(0,A0,D0.L),(0,A1,D1.L)	;4a38a: 33b008001800
	ADDQ.W	#1,(-6,A5)		;4a390: 526dfffa
	CMPI.W	#$000b,(-6,A5)		;4a394: 0c6d000bfffa
	BLT.S	LAB_4A372		;4a39a: 6dd6
	CLR.W	(-6,A5)			;4a39c: 426dfffa
LAB_4A3A0:
	CLR.W	(-8,A5)			;4a3a0: 426dfff8
LAB_4A3A4:
	MOVE.W	(-6,A5),D0		;4a3a4: 302dfffa
	EXT.L	D0			;4a3a8: 48c0
	ASL.L	#1,D0			;4a3aa: e380
	LEA	(_weapons_order,A4),A0	;4a3ac: 41ec2f96
	MOVE.W	(-8,A5),D1		;4a3b0: 322dfff8
	EXT.L	D1			;4a3b4: 48c1
	ASL.L	#1,D1			;4a3b6: e381
	LEA	(_weapons_order,A4),A1	;4a3b8: 43ec2f96
	MOVE.W	(0,A0,D0.L),D2		;4a3bc: 34300800
	CMP.W	(0,A1,D1.L),D2		;4a3c0: b4711800
	BGE.S	LAB_4A408		;4a3c4: 6c42
	MOVE.W	(-6,A5),D0		;4a3c6: 302dfffa
	EXT.L	D0			;4a3ca: 48c0
	ASL.L	#1,D0			;4a3cc: e380
	LEA	(_weapons_order,A4),A0	;4a3ce: 41ec2f96
	MOVE.W	(0,A0,D0.L),(-10,A5)	;4a3d2: 3b700800fff6
	MOVE.W	(-8,A5),D0		;4a3d8: 302dfff8
	EXT.L	D0			;4a3dc: 48c0
	ASL.L	#1,D0			;4a3de: e380
	LEA	(_weapons_order,A4),A0	;4a3e0: 41ec2f96
	MOVE.W	(-6,A5),D1		;4a3e4: 322dfffa
	EXT.L	D1			;4a3e8: 48c1
	ASL.L	#1,D1			;4a3ea: e381
	LEA	(_weapons_order,A4),A1	;4a3ec: 43ec2f96
	MOVE.W	(0,A0,D0.L),(0,A1,D1.L)	;4a3f0: 33b008001800
	MOVE.W	(-8,A5),D0		;4a3f6: 302dfff8
	EXT.L	D0			;4a3fa: 48c0
	ASL.L	#1,D0			;4a3fc: e380
	LEA	(_weapons_order,A4),A0	;4a3fe: 41ec2f96
	MOVE.W	(-10,A5),(0,A0,D0.L)	;4a402: 31adfff60800
LAB_4A408:
	ADDQ.W	#1,(-8,A5)		;4a408: 526dfff8
	CMPI.W	#$000b,(-8,A5)		;4a40c: 0c6d000bfff8
	BLT.S	LAB_4A3A4		;4a412: 6d90
	ADDQ.W	#1,(-6,A5)		;4a414: 526dfffa
	CMPI.W	#$000b,(-6,A5)		;4a418: 0c6d000bfffa
	BLT.S	LAB_4A3A0		;4a41e: 6d80
	MOVEQ	#1,D0			;4a420: 7001
return_4A422:
	UNLK	A5			;4a422: 4e5d
	RTS				;4a424: 4e75
LAB_4A426:
	MOVE.W	($A,A5),-(A7)		;4a426: 3f2d000a
	MOVE.L	(LAB_51BD8,A4),-(A7)	;4a42a: 2f2c87ea
	JSR	(_do_message,PC)	;4a42e: 4ebabe62
	ADDQ.W	#6,A7			;4a432: 5c4f
	CMP.W	#$0002,D0		;4a434: b07c0002
	BEQ.S	LAB_4A442		;4a438: 6708
	TST.L	(-4,A5)			;4a43a: 4aadfffc
	BEQ.W	LAB_4A25A		;4a43e: 6700fe1a
LAB_4A442:
	MOVEQ	#0,D0			;4a442: 7000
	BRA.S	return_4A422		;4a444: 60dc
strLAND:
	;4a446
	;DC.B	$4c,$41,$4e,$44,$30,$00
	DC.B	"LAND0",0
; ------------------------------------------------------------------------------
; Function
; Load win screen character
; ------------------------------------------------------------------------------
_read_lord:
	LINK.W	A5,#-4			;4a44c: 4e55fffc
	PEA	$3ED.W			;4a450: 487803ed
	PEA	(LAB_4A4A2,PC)		;4a454: 487a004c
	JSR	(___Open,A4)		;4a458: 4eac81e2
	ADDQ.W	#8,A7			;4a45c: 504f
	MOVE.L	D0,(-4,A5)		;4a45e: 2b40fffc
	TST.L	D0			;4a462: 4a80
	BLE.S	LAB_4A49E		;4a464: 6f38
	PEA	$7D00.W			;4a466: 48787d00
	MOVE.L	(_w_screen,A4),-(A7)	;4a46a: 2f2c99e8
	MOVE.L	(-4,A5),-(A7)		;4a46e: 2f2dfffc
	JSR	(___Read,A4)		;4a472: 4eac81e8
	LEA	($C,A7),A7		;4a476: 4fef000c
	PEA	$20.W			;4a47a: 48780020
	PEA	(_tcmap,A4)		;4a47e: 486c30a0
	MOVE.L	(-4,A5),-(A7)		;4a482: 2f2dfffc
	JSR	(___Read,A4)		;4a486: 4eac81e8
	LEA	($C,A7),A7		;4a48a: 4fef000c
	MOVE.L	(-4,A5),-(A7)		;4a48e: 2f2dfffc
	JSR	(___Close,A4)		;4a492: 4eac81d6
	ADDQ.W	#4,A7			;4a496: 584f
	MOVEQ	#1,D0			;4a498: 7001
LAB_4A49A:
	UNLK	A5			;4a49a: 4e5d
	RTS				;4a49c: 4e75
LAB_4A49E:
	MOVEQ	#0,D0			;4a49e: 7000
	BRA.S	LAB_4A49A		;4a4a0: 60f8
LAB_4A4A2:
	;4a4a2
	;DC.B	$6c,$6f,$72,$64,$2e,$70,$69,$63,$00,$00
	DC.B	"lord.pic",0,0
; ------------------------------------------------------------------------------
; Function
; Load win screen character's mouth animation
; ------------------------------------------------------------------------------
_read_mouth:
	LINK.W	A5,#-4			;4a4ac: 4e55fffc
	PEA	$3ED.W			;4a4b0: 487803ed
	PEA	(LAB_4A4E8,PC)		;4a4b4: 487a0032
	JSR	(___Open,A4)		;4a4b8: 4eac81e2
	ADDQ.W	#8,A7			;4a4bc: 504f
	MOVE.L	D0,(-4,A5)		;4a4be: 2b40fffc
	TST.L	D0			;4a4c2: 4a80
	BLE.S	LAB_4A4E4		;4a4c4: 6f1e
	PEA	$13B0.W			;4a4c6: 487813b0
	PEA	(_map_steps,A4)		;4a4ca: 486cff88
	MOVE.L	(-4,A5),-(A7)		;4a4ce: 2f2dfffc
	JSR	(___Read,A4)		;4a4d2: 4eac81e8
	LEA	($C,A7),A7		;4a4d6: 4fef000c
	MOVE.L	(-4,A5),-(A7)		;4a4da: 2f2dfffc
	JSR	(___Close,A4)		;4a4de: 4eac81d6
	ADDQ.W	#4,A7			;4a4e2: 584f
LAB_4A4E4:
	UNLK	A5			;4a4e4: 4e5d
	RTS				;4a4e6: 4e75
LAB_4A4E8:
	;4a4e8
	;DC.B	$6d,$6f,$75,$74,$68,$73,$2e,$70,$69,$63,$00,$00
	DC.B	"mouths.pic",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_Setscreen:
	LINK.W	A5,#-2			;4a4f4: 4e55fffe
	CMPI.L	#$ffffffff,($C,A5)	;4a4f8: 0cadffffffff000c
	BEQ.S	LAB_4A56A		;4a500: 6768
	CLR.W	(-2,A5)			;4a502: 426dfffe
LAB_4A506:
	MOVE.W	(-2,A5),D0		;4a506: 302dfffe
	EXT.L	D0			;4a50a: 48c0
	ASL.L	#2,D0			;4a50c: e580
	LEA	(_screen_pointer,A4),A0	;4a50e: 41ec9878
	MOVE.L	(0,A0,D0.L),D1		;4a512: 22300800
	CMP.L	($C,A5),D1		;4a516: b2ad000c
	BNE.S	LAB_4A55E		;4a51a: 6642
	MOVE.W	(_pointer,A4),D0	;4a51c: 302c84b6
	EXT.L	D0			;4a520: 48c0
	ASL.L	#2,D0			;4a522: e580
	LEA	(_a_sprite,A4),A0	;4a524: 41ec312e
	MOVE.L	(0,A0,D0.L),-(A7)	;4a528: 2f300800
	CLR.W	-(A7)			;4a52c: 4267
	MOVE.W	(-2,A5),D0		;4a52e: 302dfffe
	EXT.L	D0			;4a532: 48c0
	ASL.L	#2,D0			;4a534: e580
	LEA	(_copper_list,A4),A0	;4a536: 41ec9884
	MOVE.L	(0,A0,D0.L),-(A7)	;4a53a: 2f300800
	JSR	(_insert_sprite,PC)	;4a53e: 4eba270c
	LEA	($A,A7),A7		;4a542: 4fef000a
	MOVE.W	(-2,A5),D0		;4a546: 302dfffe
	EXT.L	D0			;4a54a: 48c0
	ASL.L	#2,D0			;4a54c: e580
	LEA	(_copper_list,A4),A0	;4a54e: 41ec9884
	MOVE.L	(0,A0,D0.L),-(A7)	;4a552: 2f300800
	JSR	(_show_screen,PC)	;4a556: 4eba262a
	ADDQ.W	#4,A7			;4a55a: 584f
	BRA.S	LAB_4A56A		;4a55c: 600c
LAB_4A55E:
	ADDQ.W	#1,(-2,A5)		;4a55e: 526dfffe
	CMPI.W	#$0003,(-2,A5)		;4a562: 0c6d0003fffe
	BNE.S	LAB_4A506		;4a568: 669c
LAB_4A56A:
	CMPI.L	#$ffffffff,(8,A5)	;4a56a: 0cadffffffff0008
	BEQ.S	LAB_4A57A		;4a572: 6706
	MOVE.L	(8,A5),(_work_screen,A4) ;4a574: 296d0008312a
LAB_4A57A:
	UNLK	A5			;4a57a: 4e5d
	RTS				;4a57c: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_swap_screens:
	LINK.W	A5,#-4			;4a57e: 4e55fffc
	MOVE.L	(_d_screen,A4),(-4,A5)	;4a582: 2b6c99ecfffc
	MOVE.L	(_w_screen,A4),(_d_screen,A4) ;4a588: 296c99e899ec
	MOVE.L	(-4,A5),(_w_screen,A4)	;4a58e: 296dfffc99e8
	MOVE.W	#$ffff,-(A7)		;4a594: 3f3cffff
	MOVE.L	(_d_screen,A4),-(A7)	;4a598: 2f2c99ec
	MOVE.L	(_w_screen,A4),-(A7)	;4a59c: 2f2c99e8
	JSR	(_Setscreen,PC)		;4a5a0: 4ebaff52
	LEA	($A,A7),A7		;4a5a4: 4fef000a
	UNLK	A5			;4a5a8: 4e5d
	RTS				;4a5aa: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_a_putpixel:
	LINK.W	A5,#0			;4a5ac: 4e550000
	MOVE.W	($A,A5),-(A7)		;4a5b0: 3f2d000a
	MOVE.W	(8,A5),D0		;4a5b4: 302d0008
	LSR.W	#6,D0			;4a5b8: ec48
	MOVE.W	(8,A5),D1		;4a5ba: 322d0008
	AND.W	#$003f,D1		;4a5be: c27c003f
	ADD.W	D1,D0			;4a5c2: d041
	LSR.W	#1,D0			;4a5c4: e248
	MOVE.W	D0,-(A7)		;4a5c6: 3f00
	MOVE.W	(8,A5),D0		;4a5c8: 302d0008
	AND.W	#$003f,D0		;4a5cc: c07c003f
	ADD.W	#$0040,D0		;4a5d0: d07c0040
	MOVE.W	(8,A5),D1		;4a5d4: 322d0008
	LSR.W	#6,D1			;4a5d8: ec49
	SUB.W	D1,D0			;4a5da: 9041
	MOVE.W	D0,-(A7)		;4a5dc: 3f00
	MOVE.L	(_work_screen,A4),-(A7)	;4a5de: 2f2c312a
	JSR	(___pixel,A4)		;4a5e2: 4eac8104
	LEA	($A,A7),A7		;4a5e6: 4fef000a
	UNLK	A5			;4a5ea: 4e5d
	RTS				;4a5ec: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_sprite_to_amiga:
	LINK.W	A5,#-2			;4a5ee: 4e55fffe
	CLR.W	(-2,A5)			;4a5f2: 426dfffe
LAB_4A5F6:
	PEA	$00010002		;4a5f6: 487900010002
	PEA	$90.W			;4a5fc: 48780090
	JSR	(___AllocMem,A4)	;4a600: 4eac8200
	ADDQ.W	#8,A7			;4a604: 504f
	MOVE.W	(-2,A5),D1		;4a606: 322dfffe
	EXT.L	D1			;4a60a: 48c1
	ASL.L	#2,D1			;4a60c: e581
	LEA	(_a_sprite,A4),A0	;4a60e: 41ec312e
	MOVE.L	D0,(0,A0,D1.L)		;4a612: 21801800
	ADDQ.W	#1,(-2,A5)		;4a616: 526dfffe
	CMPI.W	#$0008,(-2,A5)		;4a61a: 0c6d0008fffe
	BNE.S	LAB_4A5F6		;4a620: 66d4
	MOVE.L	(_a_sprite,A4),-(A7)	;4a622: 2f2c312e
	MOVE.W	#$0044,-(A7)		;4a626: 3f3c0044
	JSR	(_convert_sprite,PC)	;4a62a: 4eba25ca
	ADDQ.W	#6,A7			;4a62e: 5c4f
	MOVE.L	(LAB_5C520,A4),-(A7)	;4a630: 2f2c3132
	MOVE.W	#$004e,-(A7)		;4a634: 3f3c004e
	JSR	(_convert_sprite,PC)	;4a638: 4eba25bc
	ADDQ.W	#6,A7			;4a63c: 5c4f
	MOVE.L	(LAB_5C524,A4),-(A7)	;4a63e: 2f2c3136
	MOVE.W	#$0050,-(A7)		;4a642: 3f3c0050
	JSR	(_convert_sprite,PC)	;4a646: 4eba25ae
	ADDQ.W	#6,A7			;4a64a: 5c4f
	MOVE.L	(LAB_5C528,A4),-(A7)	;4a64c: 2f2c313a
	MOVE.W	#$0051,-(A7)		;4a650: 3f3c0051
	JSR	(_convert_sprite,PC)	;4a654: 4eba25a0
	ADDQ.W	#6,A7			;4a658: 5c4f
	MOVE.L	(LAB_5C52C,A4),-(A7)	;4a65a: 2f2c313e
	MOVE.W	#$004f,-(A7)		;4a65e: 3f3c004f
	JSR	(_convert_sprite,PC)	;4a662: 4eba2592
	ADDQ.W	#6,A7			;4a666: 5c4f
	MOVE.L	(LAB_5C530,A4),-(A7)	;4a668: 2f2c3142
	MOVE.W	#$0053,-(A7)		;4a66c: 3f3c0053
	JSR	(_convert_sprite,PC)	;4a670: 4eba2584
	ADDQ.W	#6,A7			;4a674: 5c4f
	MOVE.L	(LAB_5C534,A4),-(A7)	;4a676: 2f2c3146
	MOVE.W	#$0052,-(A7)		;4a67a: 3f3c0052
	JSR	(_convert_sprite,PC)	;4a67e: 4eba2576
	ADDQ.W	#6,A7			;4a682: 5c4f
	MOVE.L	(LAB_5C538,A4),-(A7)	;4a684: 2f2c314a
	MOVE.W	#$0081,-(A7)		;4a688: 3f3c0081
	JSR	(_convert_sprite,PC)	;4a68c: 4eba2568
	ADDQ.W	#6,A7			;4a690: 5c4f
	MOVE.L	(LAB_5C538,A4),(_sprite_list,A4) ;4a692: 296c314a30e0
	MOVE.L	(LAB_5C538,A4),D0	;4a698: 202c314a
	ADD.L	#$00000048,D0		;4a69c: d0bc00000048
	MOVE.L	D0,(LAB_5C4D2,A4)	;4a6a2: 294030e4
	UNLK	A5			;4a6a6: 4e5d
	RTS				;4a6a8: 4e75
; ------------------------------------------------------------------------------
; Function
; Same game directory
; ------------------------------------------------------------------------------
_get_a_dir:
	LINK.W	A5,#-12			;4a6aa: 4e55fff4
	CLR.W	(-2,A5)			;4a6ae: 426dfffe
	PEA	-2.W			;4a6b2: 4878fffe
	MOVE.L	(8,A5),-(A7)		;4a6b6: 2f2d0008
	JSR	(_Lock,PC)		;4a6ba: 4eba6a64
	ADDQ.W	#8,A7			;4a6be: 504f
	MOVE.L	D0,(-8,A5)		;4a6c0: 2b40fff8
	BEQ.W	LAB_4A7E0		;4a6c4: 6700011a
	MOVE.L	(_fb,A4),-(A7)		;4a6c8: 2f2c9894
	MOVE.L	(-8,A5),-(A7)		;4a6cc: 2f2dfff8
	JSR	(_Examine,PC)		;4a6d0: 4eba6a1a
	ADDQ.W	#8,A7			;4a6d4: 504f
	TST.L	D0			;4a6d6: 4a80
	BEQ.W	LAB_4A7D6		;4a6d8: 670000fc
	MOVE.L	(_fb,A4),-(A7)		;4a6dc: 2f2c9894
	MOVE.L	(-8,A5),-(A7)		;4a6e0: 2f2dfff8
	JSR	(_ExNext,PC)		;4a6e4: 4eba6a18
	ADDQ.W	#8,A7			;4a6e8: 504f
	BRA.W	LAB_4A7C8		;4a6ea: 600000dc
LAB_4A6EE:
	MOVEA.L	(_fb,A4),A0		;4a6ee: 206c9894
	TST.L	(4,A0)			;4a6f2: 4aa80004
	BGT.W	LAB_4A7BA		;4a6f6: 6e0000c2
	MOVEA.L	(_fb,A4),A0		;4a6fa: 206c9894
	ADDQ.L	#8,A0			;4a6fe: 5088
	MOVE.L	A0,(-12,A5)		;4a700: 2b48fff4
	CLR.W	(-4,A5)			;4a704: 426dfffc
	BRA.S	LAB_4A750		;4a708: 6046
LAB_4A70A:
	MOVEA.L	(-12,A5),A0		;4a70a: 206dfff4
	CMPI.B	#$61,(A0)		;4a70e: 0c100061
	BCS.S	LAB_4A72C		;4a712: 6518
	MOVEA.L	(-12,A5),A0		;4a714: 206dfff4
	CMPI.B	#$7a,(A0)		;4a718: 0c10007a
	BHI.S	LAB_4A72C		;4a71c: 620e
	MOVEA.L	(-12,A5),A0		;4a71e: 206dfff4
	MOVEQ	#0,D0			;4a722: 7000
	MOVE.B	(A0),D0			;4a724: 1010
	SUB.W	#$0020,D0		;4a726: 907c0020
	BRA.S	LAB_4A734		;4a72a: 6008
LAB_4A72C:
	MOVEA.L	(-12,A5),A0		;4a72c: 206dfff4
	MOVEQ	#0,D0			;4a730: 7000
	MOVE.B	(A0),D0			;4a732: 1010
LAB_4A734:
	MOVE.W	(-2,A5),D1		;4a734: 322dfffe
	ADD.W	(-4,A5),D1		;4a738: d26dfffc
	MOVEQ	#0,D2			;4a73c: 7400
	MOVE.W	D1,D2			;4a73e: 3401
	MOVEA.L	($C,A5),A0		;4a740: 206d000c
	MOVE.B	D0,(0,A0,D2.L)		;4a744: 11802800
	ADDQ.W	#1,(-4,A5)		;4a748: 526dfffc
	ADDQ.L	#1,(-12,A5)		;4a74c: 52adfff4
LAB_4A750:
	CMPI.W	#$001d,(-4,A5)		;4a750: 0c6d001dfffc
	BCC.S	LAB_4A760		;4a756: 6408
	MOVEA.L	(-12,A5),A0		;4a758: 206dfff4
	TST.B	(A0)			;4a75c: 4a10
	BNE.S	LAB_4A70A		;4a75e: 66aa
LAB_4A760:
	MOVE.W	(-2,A5),D0		;4a760: 302dfffe
	ADD.W	(-4,A5),D0		;4a764: d06dfffc
	MOVEQ	#0,D1			;4a768: 7200
	MOVE.W	D0,D1			;4a76a: 3200
	MOVEA.L	($C,A5),A0		;4a76c: 206d000c
	CLR.B	(0,A0,D1.L)		;4a770: 42301800
	CMPI.W	#$0004,(-4,A5)		;4a774: 0c6d0004fffc
	BCS.S	LAB_4A7BA		;4a77a: 653e
	PEA	(LAB_4A7EA,PC)		;4a77c: 487a006c
	MOVE.W	(-2,A5),D0		;4a780: 302dfffe
	ADD.W	(-4,A5),D0		;4a784: d06dfffc
	SUBQ.W	#4,D0			;4a788: 5940
	MOVEQ	#0,D1			;4a78a: 7200
	MOVE.W	D0,D1			;4a78c: 3200
	ADD.L	($C,A5),D1		;4a78e: d2ad000c
	MOVE.L	D1,-(A7)		;4a792: 2f01
	JSR	(___strcmp,A4)		;4a794: 4eac81b2
	ADDQ.W	#8,A7			;4a798: 504f
	TST.W	D0			;4a79a: 4a40
	BNE.S	LAB_4A7BA		;4a79c: 661c
	MOVE.W	(-2,A5),D0		;4a79e: 302dfffe
	ADD.W	(-4,A5),D0		;4a7a2: d06dfffc
	SUBQ.W	#4,D0			;4a7a6: 5940
	MOVEQ	#0,D1			;4a7a8: 7200
	MOVE.W	D0,D1			;4a7aa: 3200
	MOVEA.L	($C,A5),A0		;4a7ac: 206d000c
	CLR.B	(0,A0,D1.L)		;4a7b0: 42301800
	ADDI.W	#$0020,(-2,A5)		;4a7b4: 066d0020fffe
LAB_4A7BA:
	MOVE.L	(_fb,A4),-(A7)		;4a7ba: 2f2c9894
	MOVE.L	(-8,A5),-(A7)		;4a7be: 2f2dfff8
	JSR	(_ExNext,PC)		;4a7c2: 4eba693a
	ADDQ.W	#8,A7			;4a7c6: 504f
LAB_4A7C8:
	JSR	(_IoErr,PC)		;4a7c8: 4eba694a
	CMP.L	#$000000e8,D0		;4a7cc: b0bc000000e8
	BNE.W	LAB_4A6EE		;4a7d2: 6600ff1a
LAB_4A7D6:
	MOVE.L	(-8,A5),-(A7)		;4a7d6: 2f2dfff8
	JSR	(_UnLock,PC)		;4a7da: 4eba6994
	ADDQ.W	#4,A7			;4a7de: 584f
LAB_4A7E0:
	MOVE.W	(-2,A5),D0		;4a7e0: 302dfffe
	LSR.W	#5,D0			;4a7e4: ea48
	UNLK	A5			;4a7e6: 4e5d
	RTS				;4a7e8: 4e75
LAB_4A7EA:
	;4a7ea
	;DC.B	$2e,$47,$41,$4d,$00,$00
	DC.B	".GAM",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_baud_rate:
	LINK.W	A5,#0			;4a7f0: 4e550000
	MOVE.W	(_baud_rate,A4),(LAB_52C90,A4) ;4a7f4: 396c83b898a2
	JSR	(___set_serial,A4)	;4a7fa: 4eac8140
	UNLK	A5			;4a7fe: 4e5d
	RTS				;4a800: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_free_amiga_sprites:
	LINK.W	A5,#-2			;4a802: 4e55fffe
	CLR.W	(-2,A5)			;4a806: 426dfffe
LAB_4A80A:
	PEA	$90.W			;4a80a: 48780090
	MOVE.W	(-2,A5),D0		;4a80e: 302dfffe
	EXT.L	D0			;4a812: 48c0
	ASL.L	#2,D0			;4a814: e580
	LEA	(_a_sprite,A4),A0	;4a816: 41ec312e
	MOVE.L	(0,A0,D0.L),-(A7)	;4a81a: 2f300800
	JSR	(___FreeMem,A4)		;4a81e: 4eac820c
	ADDQ.W	#8,A7			;4a822: 504f
	ADDQ.W	#1,(-2,A5)		;4a824: 526dfffe
	CMPI.W	#$0008,(-2,A5)		;4a828: 0c6d0008fffe
	BNE.S	LAB_4A80A		;4a82e: 66da
	UNLK	A5			;4a830: 4e5d
	RTS				;4a832: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_check_serial:
	LINK.W	A5,#-2			;4a834: 4e55fffe
	MOVE.W	(_serial,A4),D0		;4a838: 302c989c
	SUB.W	(LAB_52C8C,A4),D0	;4a83c: 906c989e
	TST.W	D0			;4a840: 4a40
	BGE.S	LAB_4A850		;4a842: 6c0c
	MOVE.W	(_serial,A4),D0		;4a844: 302c989c
	SUB.W	(LAB_52C8C,A4),D0	;4a848: 906c989e
	NEG.W	D0			;4a84c: 4440
	BRA.S	LAB_4A858		;4a84e: 6008
LAB_4A850:
	MOVE.W	(_serial,A4),D0		;4a850: 302c989c
	SUB.W	(LAB_52C8C,A4),D0	;4a854: 906c989e
LAB_4A858:
	MOVE.W	D0,(-2,A5)		;4a858: 3b40fffe
	MOVE.W	(-2,A5),D0		;4a85c: 302dfffe
	CMP.W	(8,A5),D0		;4a860: b06d0008
	BLT.S	LAB_4A86C		;4a864: 6d06
	MOVEQ	#1,D0			;4a866: 7001
LAB_4A868:
	UNLK	A5			;4a868: 4e5d
	RTS				;4a86a: 4e75
LAB_4A86C:
	MOVEQ	#0,D0			;4a86c: 7000
	BRA.S	LAB_4A868		;4a86e: 60f8
; ------------------------------------------------------------------------------
; Function
; Displays debug info (game stats, copy protection variables, memory)
; Activated by pressing F9
; This debug code is absent from the original 1989 release
; ------------------------------------------------------------------------------
_display_debug:
	LINK.W	A5,#-504		;4a870: 4e55fe08
	MOVE.L	#$00000024,(-4,A5)	;4a874: 2b7c00000024fffc
	CLR.L	-(A7)			;4a87c: 42a7
	PEA	(_end_ok,A4)		;4a87e: 486c84c6
	MOVE.W	#$00be,-(A7)		;4a882: 3f3c00be
	MOVE.W	#$0120,-(A7)		;4a886: 3f3c0120
	MOVE.W	#$0005,-(A7)		;4a88a: 3f3c0005
	MOVE.W	#$0010,-(A7)		;4a88e: 3f3c0010
	MOVE.L	(_d_screen,A4),-(A7)	;4a892: 2f2c99ec
	JSR	(_requester,PC)		;4a896: 4ebaabec
	LEA	($14,A7),A7		;4a89a: 4fef0014
	MOVE.L	(_score,A4),-(A7)	;4a89e: 2f2cae72
	MOVE.W	(_battle_1,A4),-(A7)	;4a8a2: 3f2cae7c
	MOVE.W	(_battle_won,A4),-(A7)	;4a8a6: 3f2cae7a
; battles won wil always read n / 208
	MOVE.W	#$00d0,-(A7)		;4a8aa: 3f3c00d0
	MOVE.W	(_no_peeps,A4),-(A7)	;4a8ae: 3f2cae5e
	MOVE.W	(_game_turn,A4),-(A7)	;4a8b2: 3f2cae6a
	MOVE.W	(_start_seed,A4),-(A7)	;4a8b6: 3f2c99e4
	MOVE.W	(_seed,A4),-(A7)	;4a8ba: 3f2c99e2
	MOVE.W	(bad_castles,A4),-(A7)	;4a8be: 3f2c82f8
	MOVE.W	(bad_towns,A4),-(A7)	;4a8c2: 3f2c82fa
	MOVE.W	(good_castles,A4),-(A7)	;4a8c6: 3f2c82ca
	MOVE.W	(good_towns,A4),-(A7)	;4a8ca: 3f2c82cc
	MOVE.L	(bad_pop,A4),-(A7)	;4a8ce: 2f2c9a0e
	MOVE.L	(good_pop,A4),-(A7)	;4a8d2: 2f2c99fe
; five copy protection variables
; shown as long hex
	MOVE.L	(___the_prot5,A4),-(A7)	;4a8d6: 2f2c819a
	MOVE.L	(_the_prot4,A4),-(A7)	;4a8da: 2f2c309c
	MOVE.L	(_the_prot3,A4),-(A7)	;4a8de: 2f2cae82
; SIG 2
	MOVEA.L	(-4,A5),A0		;4a8e2: 206dfffc
	MOVE.L	(A0),-(A7)		;4a8e6: 2f10
	MOVE.L	(___the_prot1,A4),-(A7)	;4a8e8: 2f2c80f8
; fast memory
	PEA	4.W			;4a8ec: 48780004
	JSR	(_AvailMem,PC)		;4a8f0: 4eba68d2
	ADDQ.W	#4,A7			;4a8f4: 584f
	MOVE.L	D0,-(A7)		;4a8f6: 2f00
; chip memory
	PEA	2.W			;4a8f8: 48780002
	JSR	(_AvailMem,PC)		;4a8fc: 4eba68c6
	ADDQ.W	#4,A7			;4a900: 584f
	MOVE.L	D0,-(A7)		;4a902: 2f00
	PEA	(strGameStats,PC)	;4a904: 487a0048
	PEA	(-504,A5)		;4a908: 486dfe08
	JSR	(_sprintf,PC)		;4a90c: 4eba6192
	LEA	($46,A7),A7		;4a910: 4fef0046
	PEA	(-504,A5)		;4a914: 486dfe08
	MOVE.W	#$0010,-(A7)		;4a918: 3f3c0010
	MOVE.W	#$0020,-(A7)		;4a91c: 3f3c0020
	MOVE.L	(_d_screen,A4),-(A7)	;4a920: 2f2c99ec
	JSR	(___text,A4)		;4a924: 4eac813a
	LEA	($C,A7),A7		;4a928: 4fef000c
LAB_4A92C:
	MOVE.W	#$0002,(_left_button,A4) ;4a92c: 397c0002ae62
loop_4A932:
; mousewait
	TST.W	(_left_button,A4)	;4a932: 4a6cae62
	BEQ.S	LAB_4A93A		;4a936: 6702
	BRA.S	loop_4A932		;4a938: 60f8
LAB_4A93A:
	CLR.L	-(A7)			;4a93a: 42a7
	PEA	(_end_ok,A4)		;4a93c: 486c84c6
	JSR	(_check_cancel,PC)	;4a940: 4ebac60e
	ADDQ.W	#8,A7			;4a944: 504f
	TST.W	D0			;4a946: 4a40
	BEQ.S	LAB_4A92C		;4a948: 67e2
	UNLK	A5			;4a94a: 4e5d
	RTS				;4a94c: 4e75
strGameStats:
	;4a94e
	;DC.B	$43,$48,$49,$50,$20,$4d,$45,$4d,$4f,$52,$59,$20,$3d,$20,$25,$6c
	;DC.B	$64,$0a,$46,$41,$53,$54,$20,$4d,$45,$4d,$4f,$52,$59,$20,$3d,$20
	;DC.B	$25,$6c,$64,$0a,$53,$49,$47,$20,$31,$20,$3d,$20,$25,$6c,$78,$20
	;DC.B	$53,$49,$47,$20,$32,$20,$3d,$20,$25,$6c,$78,$0a,$53,$49,$47,$20
	;DC.B	$33,$20,$3d,$25,$6c,$78,$20,$53,$49,$47,$20,$34,$20,$3d,$20,$25
	;DC.B	$6c,$78,$0a,$53,$49,$47,$20,$35,$20,$3d,$20,$25,$6c,$78,$0a,$47
	;DC.B	$4f,$4f,$44,$20,$50,$4f,$50,$20,$3d,$20,$25,$6c,$64,$20,$42,$41
	;DC.B	$44,$20,$50,$4f,$50,$20,$3d,$20,$25,$6c,$64,$0a,$47,$4f,$4f,$44
	;DC.B	$20,$54,$4f,$57,$4e,$53,$20,$3d,$20,$25,$64,$20,$47,$4f,$4f,$44
	;DC.B	$20,$43,$41,$53,$54,$4c,$45,$20,$3d,$20,$25,$64,$0a,$42,$41,$44
	;DC.B	$20,$54,$4f,$57,$4e,$53,$20,$3d,$20,$25,$64,$20,$42,$41,$44,$20
	;DC.B	$43,$41,$53,$54,$4c,$45,$20,$3d,$20,$25,$64,$0a,$53,$45,$45,$44
	;DC.B	$20,$3d,$20,$25,$64,$20,$53,$54,$41,$52,$54,$20,$53,$45,$45,$44
	;DC.B	$3d,$25,$64,$0a,$47,$41,$4d,$45,$20,$54,$55,$52,$4e,$3d,$25,$64
	;DC.B	$20,$4e,$4f,$2e,$50,$45,$4f,$50,$4c,$45,$3d,$25,$64,$20,$2f,$20
	;DC.B	$25,$64,$0a,$20,$42,$41,$54,$54,$4c,$45,$5b,$30,$5d,$3d,$25,$64
	;DC.B	$2c,$42,$41,$54,$54,$4c,$45,$5b,$31,$5d,$3d,$25,$64,$0a,$53,$43
	;DC.B	$4f,$52,$45,$3d,$25,$6c,$64,$00
	DC.B	"CHIP MEMORY = %ld",$A
	DC.B	"FAST MEMORY = %ld",$A
	DC.B	"SIG 1 = %lx SIG 2 = %lx",$A
	DC.B	"SIG 3 =%lx SIG 4 = %lx",$A
	DC.B	"SIG 5 = %lx",$A
	DC.B	"GOOD POP = %ld BAD POP = %ld",$A
	DC.B	"GOOD TOWNS = %d GOOD CASTLE = %d",$A
	DC.B	"BAD TOWNS = %d BAD CASTLE = %d",$A
	DC.B	"SEED = %d START SEED=%d",$A
	DC.B	"GAME TURN=%d NO.PEOPLE=%d / %d",$A
	DC.B	" BATTLE[0]=%d,BATTLE[1]=%d",$A
	DC.B	"SCORE=%ld",0
; ------------------------------------------------------------------------------
; Function
; Save game routine. 
; ------------------------------------------------------------------------------
_save_game:
	LINK.W	A5,#-14			;4aa66: 4e55fff2
	MOVE.L	#$ffffb615,(-8,A5)	;4aa6a: 2b7cffffb615fff8
	MOVE.W	#$0001,(-12,A5)		;4aa72: 3b7c0001fff4
	MOVE.L	(8,A5),-(A7)		;4aa78: 2f2d0008
	JSR	(___strlen,A4)		;4aa7c: 4eac81a6
	ADDQ.W	#4,A7			;4aa80: 584f
	MOVE.W	D0,(-10,A5)		;4aa82: 3b40fff6
	CMPI.W	#$0004,(-10,A5)		;4aa86: 0c6d0004fff6
	BLT.S	LAB_4AABA		;4aa8c: 6d2c
	PEA	(strGAM1,PC)		;4aa8e: 487a0382
	MOVE.W	(-10,A5),D0		;4aa92: 302dfff6
	SUBQ.W	#4,D0			;4aa96: 5940
	EXT.L	D0			;4aa98: 48c0
	ADD.L	(8,A5),D0		;4aa9a: d0ad0008
	MOVE.L	D0,-(A7)		;4aa9e: 2f00
	JSR	(___strcmp,A4)		;4aaa0: 4eac81b2
	ADDQ.W	#8,A7			;4aaa4: 504f
	TST.W	D0			;4aaa6: 4a40
	BEQ.S	LAB_4AAB8		;4aaa8: 670e
	PEA	(strGAM2,PC)		;4aaaa: 487a036b
	MOVE.L	(8,A5),-(A7)		;4aaae: 2f2d0008
	JSR	(___strcat,A4)		;4aab2: 4eac81be
	ADDQ.W	#8,A7			;4aab6: 504f
LAB_4AAB8:
	BRA.S	LAB_4AAC8		;4aab8: 600e
LAB_4AABA:
	PEA	(strGAM3,PC)		;4aaba: 487a0360
	MOVE.L	(8,A5),-(A7)		;4aabe: 2f2d0008
	JSR	(___strcat,A4)		;4aac2: 4eac81be
	ADDQ.W	#8,A7			;4aac6: 504f
LAB_4AAC8:
	PEA	$3EE.W			;4aac8: 487803ee
	MOVE.L	(8,A5),-(A7)		;4aacc: 2f2d0008
	JSR	(___Open,A4)		;4aad0: 4eac81e2
	ADDQ.W	#8,A7			;4aad4: 504f
	MOVE.L	D0,(-4,A5)		;4aad6: 2b40fffc
	BEQ.W	LAB_4AE0A		;4aada: 6700032e
	PEA	$1081.W			;4aade: 48781081
	PEA	(_alt,A4)		;4aae2: 486cae86
	JSR	(_checksum,PC)		;4aae6: 4eba033a
	ADDQ.W	#8,A7			;4aaea: 504f
	MOVE.W	D0,(-14,A5)		;4aaec: 3b40fff2
	PEA	$800.W			;4aaf0: 48780800
	PEA	(_map_alt,A4)		;4aaf4: 486cdf88
	JSR	(_checksum,PC)		;4aaf8: 4eba0328
	ADDQ.W	#8,A7			;4aafc: 504f
	ADD.W	D0,(-14,A5)		;4aafe: d16dfff2
	PEA	$800.W			;4ab02: 48780800
	PEA	(_map_blk,A4)		;4ab06: 486ccf88
	JSR	(_checksum,PC)		;4ab0a: 4eba0316
	ADDQ.W	#8,A7			;4ab0e: 504f
	ADD.W	D0,(-14,A5)		;4ab10: d16dfff2
	PEA	$800.W			;4ab14: 48780800
	PEA	(_map_bk2,A4)		;4ab18: 486cef88
	JSR	(_checksum,PC)		;4ab1c: 4eba0304
	ADDQ.W	#8,A7			;4ab20: 504f
	ADD.W	D0,(-14,A5)		;4ab22: d16dfff2
	PEA	$800.W			;4ab26: 48780800
	PEA	(_map_who,A4)		;4ab2a: 486c1f88
	JSR	(_checksum,PC)		;4ab2e: 4eba02f2
	ADDQ.W	#8,A7			;4ab32: 504f
	ADD.W	D0,(-14,A5)		;4ab34: d16dfff2
	MOVE.L	(good_pop,A4),D0	;4ab38: 202c99fe
	ADD.L	(bad_pop,A4),D0		;4ab3c: d0ac9a0e
	ADD.W	D0,(-14,A5)		;4ab40: d16dfff2
	MOVE.W	(-14,A5),(_land_checksum,A4) ;4ab44: 396dfff23082
	PEA	4.W			;4ab4a: 48780004
	PEA	(-8,A5)			;4ab4e: 486dfff8
	MOVE.L	(-4,A5),-(A7)		;4ab52: 2f2dfffc
	JSR	(_Write,PC)		;4ab56: 4eba6628
	LEA	($C,A7),A7		;4ab5a: 4fef000c
	CMP.W	#$0004,D0		;4ab5e: b07c0004
	BNE.W	LAB_4AE00		;4ab62: 6600029c
	PEA	$2102.W			;4ab66: 48782102
	PEA	(_alt,A4)		;4ab6a: 486cae86
	MOVE.L	(-4,A5),-(A7)		;4ab6e: 2f2dfffc
	JSR	(_Write,PC)		;4ab72: 4eba660c
	LEA	($C,A7),A7		;4ab76: 4fef000c
	CMP.W	#$2102,D0		;4ab7a: b07c2102
	BNE.W	LAB_4AE00		;4ab7e: 66000280
	PEA	$1000.W			;4ab82: 48781000
	PEA	(_map_alt,A4)		;4ab86: 486cdf88
	MOVE.L	(-4,A5),-(A7)		;4ab8a: 2f2dfffc
	JSR	(_Write,PC)		;4ab8e: 4eba65f0
	LEA	($C,A7),A7		;4ab92: 4fef000c
	CMP.W	#$1000,D0		;4ab96: b07c1000
	BNE.W	LAB_4AE00		;4ab9a: 66000264
	PEA	$1000.W			;4ab9e: 48781000
	PEA	(_map_blk,A4)		;4aba2: 486ccf88
	MOVE.L	(-4,A5),-(A7)		;4aba6: 2f2dfffc
	JSR	(_Write,PC)		;4abaa: 4eba65d4
	LEA	($C,A7),A7		;4abae: 4fef000c
	CMP.W	#$1000,D0		;4abb2: b07c1000
	BNE.W	LAB_4AE00		;4abb6: 66000248
	PEA	$1000.W			;4abba: 48781000
	PEA	(_map_bk2,A4)		;4abbe: 486cef88
	MOVE.L	(-4,A5),-(A7)		;4abc2: 2f2dfffc
	JSR	(_Write,PC)		;4abc6: 4eba65b8
	LEA	($C,A7),A7		;4abca: 4fef000c
	CMP.W	#$1000,D0		;4abce: b07c1000
	BNE.W	LAB_4AE00		;4abd2: 6600022c
	PEA	$1000.W			;4abd6: 48781000
	PEA	(_map_who,A4)		;4abda: 486c1f88
	MOVE.L	(-4,A5),-(A7)		;4abde: 2f2dfffc
	JSR	(_Write,PC)		;4abe2: 4eba659c
	LEA	($C,A7),A7		;4abe6: 4fef000c
	CMP.W	#$1000,D0		;4abea: b07c1000
	BNE.W	LAB_4AE00		;4abee: 66000210
	PEA	$20.W			;4abf2: 48780020
	PEA	(_magnet,A4)		;4abf6: 486c99f6
	MOVE.L	(-4,A5),-(A7)		;4abfa: 2f2dfffc
	JSR	(_Write,PC)		;4abfe: 4eba6580
	LEA	($C,A7),A7		;4ac02: 4fef000c
	CMP.W	#$0020,D0		;4ac06: b07c0020
	BNE.W	LAB_4AE00		;4ac0a: 660001f4
	PEA	$1222.W			;4ac0e: 48781222
	PEA	(_peeps,A4)		;4ac12: 486c9c26
	MOVE.L	(-4,A5),-(A7)		;4ac16: 2f2dfffc
	JSR	(_Write,PC)		;4ac1a: 4eba6564
	LEA	($C,A7),A7		;4ac1e: 4fef000c
	CMP.W	#$1222,D0		;4ac22: b07c1222
	BNE.W	LAB_4AE00		;4ac26: 660001d8
	PEA	$2E.W			;4ac2a: 4878002e
	PEA	(_stats,A4)		;4ac2e: 486c82b6
	MOVE.L	(-4,A5),-(A7)		;4ac32: 2f2dfffc
	JSR	(_Write,PC)		;4ac36: 4eba6548
	LEA	($C,A7),A7		;4ac3a: 4fef000c
	CMP.W	#$002e,D0		;4ac3e: b07c002e
	BNE.W	LAB_4AE00		;4ac42: 660001bc
	PEA	$2E.W			;4ac46: 4878002e
	PEA	(strABC,A4)		;4ac4a: 486c82e4
	MOVE.L	(-4,A5),-(A7)		;4ac4e: 2f2dfffc
	JSR	(_Write,PC)		;4ac52: 4eba652c
	LEA	($C,A7),A7		;4ac56: 4fef000c
	CMP.W	#$002e,D0		;4ac5a: b07c002e
	BNE.W	LAB_4AE00		;4ac5e: 660001a0
	PEA	2.W			;4ac62: 48780002
	PEA	(_mode,A4)		;4ac66: 486c8256
	MOVE.L	(-4,A5),-(A7)		;4ac6a: 2f2dfffc
	JSR	(_Write,PC)		;4ac6e: 4eba6510
	LEA	($C,A7),A7		;4ac72: 4fef000c
	CMP.W	#$0002,D0		;4ac76: b07c0002
	BNE.W	LAB_4AE00		;4ac7a: 66000184
	PEA	2.W			;4ac7e: 48780002
	PEA	(_seed,A4)		;4ac82: 486c99e2
	MOVE.L	(-4,A5),-(A7)		;4ac86: 2f2dfffc
	JSR	(_Write,PC)		;4ac8a: 4eba64f4
	LEA	($C,A7),A7		;4ac8e: 4fef000c
	CMP.W	#$0002,D0		;4ac92: b07c0002
	BNE.W	LAB_4AE00		;4ac96: 66000168
	PEA	2.W			;4ac9a: 48780002
	PEA	(_start_seed,A4)	;4ac9e: 486c99e4
	MOVE.L	(-4,A5),-(A7)		;4aca2: 2f2dfffc
	JSR	(_Write,PC)		;4aca6: 4eba64d8
	LEA	($C,A7),A7		;4acaa: 4fef000c
	CMP.W	#$0002,D0		;4acae: b07c0002
	BNE.W	LAB_4AE00		;4acb2: 6600014c
	PEA	2.W			;4acb6: 48780002
	PEA	(_player,A4)		;4acba: 486c99f4
	MOVE.L	(-4,A5),-(A7)		;4acbe: 2f2dfffc
	JSR	(_Write,PC)		;4acc2: 4eba64bc
	LEA	($C,A7),A7		;4acc6: 4fef000c
	CMP.W	#$0002,D0		;4acca: b07c0002
	BNE.W	LAB_4AE00		;4acce: 66000130
	PEA	2.W			;4acd2: 48780002
	PEA	(_ground_in,A4)		;4acd6: 486c99e6
	MOVE.L	(-4,A5),-(A7)		;4acda: 2f2dfffc
	JSR	(_Write,PC)		;4acde: 4eba64a0
	LEA	($C,A7),A7		;4ace2: 4fef000c
	CMP.W	#$0002,D0		;4ace6: b07c0002
	BNE.W	LAB_4AE00		;4acea: 66000114
	PEA	2.W			;4acee: 48780002
	PEA	(_war,A4)		;4acf2: 486cae80
	MOVE.L	(-4,A5),-(A7)		;4acf6: 2f2dfffc
	JSR	(_Write,PC)		;4acfa: 4eba6484
	LEA	($C,A7),A7		;4acfe: 4fef000c
	CMP.W	#$0002,D0		;4ad02: b07c0002
	BNE.W	LAB_4AE00		;4ad06: 660000f8
	PEA	2.W			;4ad0a: 48780002
	PEA	(_game_turn,A4)		;4ad0e: 486cae6a
	MOVE.L	(-4,A5),-(A7)		;4ad12: 2f2dfffc
	JSR	(_Write,PC)		;4ad16: 4eba6468
	LEA	($C,A7),A7		;4ad1a: 4fef000c
	CMP.W	#$0002,D0		;4ad1e: b07c0002
	BNE.W	LAB_4AE00		;4ad22: 660000dc
	PEA	$A.W			;4ad26: 4878000a
	PEA	(_conquest,A4)		;4ad2a: 486c84bc
	MOVE.L	(-4,A5),-(A7)		;4ad2e: 2f2dfffc
	JSR	(_Write,PC)		;4ad32: 4eba644c
	LEA	($C,A7),A7		;4ad36: 4fef000c
	CMP.W	#$000a,D0		;4ad3a: b07c000a
	BNE.W	LAB_4AE00		;4ad3e: 660000c0
	PEA	2.W			;4ad42: 48780002
	PEA	(_in_conquest,A4)	;4ad46: 486c84ba
	MOVE.L	(-4,A5),-(A7)		;4ad4a: 2f2dfffc
	JSR	(_Write,PC)		;4ad4e: 4eba6430
	LEA	($C,A7),A7		;4ad52: 4fef000c
	CMP.W	#$0002,D0		;4ad56: b07c0002
	BNE.W	LAB_4AE00		;4ad5a: 660000a4
	PEA	2.W			;4ad5e: 48780002
	PEA	(_paint_map,A4)		;4ad62: 486c9c24
	MOVE.L	(-4,A5),-(A7)		;4ad66: 2f2dfffc
	JSR	(_Write,PC)		;4ad6a: 4eba6414
	LEA	($C,A7),A7		;4ad6e: 4fef000c
	CMP.W	#$0002,D0		;4ad72: b07c0002
	BNE.W	LAB_4AE00		;4ad76: 66000088
	PEA	4.W			;4ad7a: 48780004
	PEA	(_battle_won,A4)	;4ad7e: 486cae7a
	MOVE.L	(-4,A5),-(A7)		;4ad82: 2f2dfffc
	JSR	(_Write,PC)		;4ad86: 4eba63f8
	LEA	($C,A7),A7		;4ad8a: 4fef000c
	CMP.W	#$0004,D0		;4ad8e: b07c0004
	BNE.S	LAB_4AE00		;4ad92: 666c
	PEA	2.W			;4ad94: 48780002
	PEA	(_game_mode,A4)		;4ad98: 486c84b8
	MOVE.L	(-4,A5),-(A7)		;4ad9c: 2f2dfffc
	JSR	(_Write,PC)		;4ada0: 4eba63de
	LEA	($C,A7),A7		;4ada4: 4fef000c
	CMP.W	#$0002,D0		;4ada8: b07c0002
	BNE.S	LAB_4AE00		;4adac: 6652
	PEA	2.W			;4adae: 48780002
	PEA	(_level_number,A4)	;4adb2: 486cae7e
	MOVE.L	(-4,A5),-(A7)		;4adb6: 2f2dfffc
	JSR	(_Write,PC)		;4adba: 4eba63c4
	LEA	($C,A7),A7		;4adbe: 4fef000c
	CMP.W	#$0002,D0		;4adc2: b07c0002
	BNE.S	LAB_4AE00		;4adc6: 6638
	PEA	4.W			;4adc8: 48780004
	PEA	(_score,A4)		;4adcc: 486cae72
	MOVE.L	(-4,A5),-(A7)		;4add0: 2f2dfffc
	JSR	(_Write,PC)		;4add4: 4eba63aa
	LEA	($C,A7),A7		;4add8: 4fef000c
	CMP.W	#$0004,D0		;4addc: b07c0004
	BNE.S	LAB_4AE00		;4ade0: 661e
	PEA	2.W			;4ade2: 48780002
	PEA	(-14,A5)		;4ade6: 486dfff2
	MOVE.L	(-4,A5),-(A7)		;4adea: 2f2dfffc
	JSR	(_Write,PC)		;4adee: 4eba6390
	LEA	($C,A7),A7		;4adf2: 4fef000c
	CMP.W	#$0002,D0		;4adf6: b07c0002
	BNE.S	LAB_4AE00		;4adfa: 6604
	CLR.W	(-12,A5)		;4adfc: 426dfff4
LAB_4AE00:
	MOVE.L	(-4,A5),-(A7)		;4ae00: 2f2dfffc
	JSR	(___Close,A4)		;4ae04: 4eac81d6
	ADDQ.W	#4,A7			;4ae08: 584f
LAB_4AE0A:
	MOVE.W	(-12,A5),D0		;4ae0a: 302dfff4
	UNLK	A5			;4ae0e: 4e5d
	RTS				;4ae10: 4e75
strGAM1:
	;4ae12
	;DC.B	$2e,$47,$41,$4d,$00
	DC.B	".GAM",0
strGAM2:
	;4ae17
	;DC.B	$2e,$47,$41,$4d,$00
	DC.B	".GAM",0
strGAM3:
	;4ae1c
	;DC.B	$2e,$47,$41,$4d,$00,$00
	DC.B	".GAM",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_checksum:
	LINK.W	A5,#-6			;4ae22: 4e55fffa
	CLR.W	(-2,A5)			;4ae26: 426dfffe
	CLR.L	(-6,A5)			;4ae2a: 42adfffa
	BRA.S	LAB_4AE46		;4ae2e: 6016
LAB_4AE30:
	MOVE.L	(-6,A5),D0		;4ae30: 202dfffa
	ASL.L	#1,D0			;4ae34: e380
	MOVEA.L	(8,A5),A0		;4ae36: 206d0008
	MOVE.W	(0,A0,D0.L),D1		;4ae3a: 32300800
	ADD.W	D1,(-2,A5)		;4ae3e: d36dfffe
	ADDQ.L	#1,(-6,A5)		;4ae42: 52adfffa
LAB_4AE46:
	MOVE.L	(-6,A5),D0		;4ae46: 202dfffa
	CMP.L	($C,A5),D0		;4ae4a: b0ad000c
	BNE.S	LAB_4AE30		;4ae4e: 66e0
	MOVE.W	(-2,A5),D0		;4ae50: 302dfffe
	UNLK	A5			;4ae54: 4e5d
	RTS				;4ae56: 4e75
; ------------------------------------------------------------------------------
; Function
; Load game function
; ------------------------------------------------------------------------------
_load_game:
	LINK.W	A5,#-10			;4ae58: 4e55fff6
	MOVE.L	(8,A5),-(A7)		;4ae5c: 2f2d0008
	JSR	(___strlen,A4)		;4ae60: 4eac81a6
	ADDQ.W	#4,A7			;4ae64: 584f
	MOVE.W	D0,(-6,A5)		;4ae66: 3b40fffa
	CMPI.W	#$0004,(-6,A5)		;4ae6a: 0c6d0004fffa
	BLT.S	LAB_4AE9E		;4ae70: 6d2c
	PEA	(strGAM4,PC)		;4ae72: 487a03b6
	MOVE.W	(-6,A5),D0		;4ae76: 302dfffa
	SUBQ.W	#4,D0			;4ae7a: 5940
	EXT.L	D0			;4ae7c: 48c0
	ADD.L	(8,A5),D0		;4ae7e: d0ad0008
	MOVE.L	D0,-(A7)		;4ae82: 2f00
	JSR	(___strcmp,A4)		;4ae84: 4eac81b2
	ADDQ.W	#8,A7			;4ae88: 504f
	TST.W	D0			;4ae8a: 4a40
	BEQ.S	LAB_4AE9C		;4ae8c: 670e
	PEA	(strGAM5,PC)		;4ae8e: 487a039f
	MOVE.L	(8,A5),-(A7)		;4ae92: 2f2d0008
	JSR	(___strcat,A4)		;4ae96: 4eac81be
	ADDQ.W	#8,A7			;4ae9a: 504f
LAB_4AE9C:
	BRA.S	LAB_4AEAC		;4ae9c: 600e
LAB_4AE9E:
	PEA	(strGAM6,PC)		;4ae9e: 487a0394
	MOVE.L	(8,A5),-(A7)		;4aea2: 2f2d0008
	JSR	(___strcat,A4)		;4aea6: 4eac81be
	ADDQ.W	#8,A7			;4aeaa: 504f
LAB_4AEAC:
	PEA	$3ED.W			;4aeac: 487803ed
	MOVE.L	(8,A5),-(A7)		;4aeb0: 2f2d0008
	JSR	(___Open,A4)		;4aeb4: 4eac81e2
	ADDQ.W	#8,A7			;4aeb8: 504f
	MOVE.L	D0,(-4,A5)		;4aeba: 2b40fffc
	BEQ.W	LAB_4B226		;4aebe: 67000366
	PEA	4.W			;4aec2: 48780004
	PEA	(-10,A5)		;4aec6: 486dfff6
	MOVE.L	(-4,A5),-(A7)		;4aeca: 2f2dfffc
	JSR	(___Read,A4)		;4aece: 4eac81e8
	LEA	($C,A7),A7		;4aed2: 4fef000c
	CMPI.L	#$ffffb615,(-10,A5)	;4aed6: 0cadffffb615fff6
	BNE.W	LAB_4B21C		;4aede: 6600033c
	MOVE.W	#$ffff,-(A7)		;4aee2: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;4aee6: 3f3cffff
	JSR	(___set_tend_icons,A4)	;4aeea: 4eac802c
	ADDQ.W	#4,A7			;4aeee: 584f
	MOVE.W	#$ffff,-(A7)		;4aef0: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;4aef4: 3f3cffff
	JSR	(___set_mode_icons,A4)	;4aef8: 4eac8032
	ADDQ.W	#4,A7			;4aefc: 584f
	PEA	$2102.W			;4aefe: 48782102
	PEA	(_alt,A4)		;4af02: 486cae86
	MOVE.L	(-4,A5),-(A7)		;4af06: 2f2dfffc
	JSR	(___Read,A4)		;4af0a: 4eac81e8
	LEA	($C,A7),A7		;4af0e: 4fef000c
	PEA	$1000.W			;4af12: 48781000
	PEA	(_map_alt,A4)		;4af16: 486cdf88
	MOVE.L	(-4,A5),-(A7)		;4af1a: 2f2dfffc
	JSR	(___Read,A4)		;4af1e: 4eac81e8
	LEA	($C,A7),A7		;4af22: 4fef000c
	PEA	$1000.W			;4af26: 48781000
	PEA	(_map_blk,A4)		;4af2a: 486ccf88
	MOVE.L	(-4,A5),-(A7)		;4af2e: 2f2dfffc
	JSR	(___Read,A4)		;4af32: 4eac81e8
	LEA	($C,A7),A7		;4af36: 4fef000c
	PEA	$1000.W			;4af3a: 48781000
	PEA	(_map_bk2,A4)		;4af3e: 486cef88
	MOVE.L	(-4,A5),-(A7)		;4af42: 2f2dfffc
	JSR	(___Read,A4)		;4af46: 4eac81e8
	LEA	($C,A7),A7		;4af4a: 4fef000c
	PEA	$1000.W			;4af4e: 48781000
	PEA	(_map_who,A4)		;4af52: 486c1f88
	MOVE.L	(-4,A5),-(A7)		;4af56: 2f2dfffc
	JSR	(___Read,A4)		;4af5a: 4eac81e8
	LEA	($C,A7),A7		;4af5e: 4fef000c
	PEA	$20.W			;4af62: 48780020
	PEA	(_magnet,A4)		;4af66: 486c99f6
	MOVE.L	(-4,A5),-(A7)		;4af6a: 2f2dfffc
	JSR	(___Read,A4)		;4af6e: 4eac81e8
	LEA	($C,A7),A7		;4af72: 4fef000c
	PEA	$1222.W			;4af76: 48781222
	PEA	(_peeps,A4)		;4af7a: 486c9c26
	MOVE.L	(-4,A5),-(A7)		;4af7e: 2f2dfffc
	JSR	(___Read,A4)		;4af82: 4eac81e8
	LEA	($C,A7),A7		;4af86: 4fef000c
	PEA	$2E.W			;4af8a: 4878002e
	PEA	(_stats,A4)		;4af8e: 486c82b6
	MOVE.L	(-4,A5),-(A7)		;4af92: 2f2dfffc
	JSR	(___Read,A4)		;4af96: 4eac81e8
	LEA	($C,A7),A7		;4af9a: 4fef000c
	PEA	$2E.W			;4af9e: 4878002e
	PEA	(strABC,A4)		;4afa2: 486c82e4
	MOVE.L	(-4,A5),-(A7)		;4afa6: 2f2dfffc
	JSR	(___Read,A4)		;4afaa: 4eac81e8
	LEA	($C,A7),A7		;4afae: 4fef000c
	PEA	2.W			;4afb2: 48780002
	PEA	(_mode,A4)		;4afb6: 486c8256
	MOVE.L	(-4,A5),-(A7)		;4afba: 2f2dfffc
	JSR	(___Read,A4)		;4afbe: 4eac81e8
	LEA	($C,A7),A7		;4afc2: 4fef000c
	PEA	2.W			;4afc6: 48780002
	PEA	(_seed,A4)		;4afca: 486c99e2
	MOVE.L	(-4,A5),-(A7)		;4afce: 2f2dfffc
	JSR	(___Read,A4)		;4afd2: 4eac81e8
	LEA	($C,A7),A7		;4afd6: 4fef000c
	PEA	2.W			;4afda: 48780002
	PEA	(_start_seed,A4)	;4afde: 486c99e4
	MOVE.L	(-4,A5),-(A7)		;4afe2: 2f2dfffc
	JSR	(___Read,A4)		;4afe6: 4eac81e8
	LEA	($C,A7),A7		;4afea: 4fef000c
	PEA	2.W			;4afee: 48780002
	PEA	(_player,A4)		;4aff2: 486c99f4
	MOVE.L	(-4,A5),-(A7)		;4aff6: 2f2dfffc
	JSR	(___Read,A4)		;4affa: 4eac81e8
	LEA	($C,A7),A7		;4affe: 4fef000c
	PEA	2.W			;4b002: 48780002
	PEA	(_ground_in,A4)		;4b006: 486c99e6
	MOVE.L	(-4,A5),-(A7)		;4b00a: 2f2dfffc
	JSR	(___Read,A4)		;4b00e: 4eac81e8
	LEA	($C,A7),A7		;4b012: 4fef000c
	PEA	2.W			;4b016: 48780002
	PEA	(_war,A4)		;4b01a: 486cae80
	MOVE.L	(-4,A5),-(A7)		;4b01e: 2f2dfffc
	JSR	(___Read,A4)		;4b022: 4eac81e8
	LEA	($C,A7),A7		;4b026: 4fef000c
	PEA	2.W			;4b02a: 48780002
	PEA	(_game_turn,A4)		;4b02e: 486cae6a
	MOVE.L	(-4,A5),-(A7)		;4b032: 2f2dfffc
	JSR	(___Read,A4)		;4b036: 4eac81e8
	LEA	($C,A7),A7		;4b03a: 4fef000c
	PEA	$A.W			;4b03e: 4878000a
	PEA	(_conquest,A4)		;4b042: 486c84bc
	MOVE.L	(-4,A5),-(A7)		;4b046: 2f2dfffc
	JSR	(___Read,A4)		;4b04a: 4eac81e8
	LEA	($C,A7),A7		;4b04e: 4fef000c
	PEA	2.W			;4b052: 48780002
	PEA	(_in_conquest,A4)	;4b056: 486c84ba
	MOVE.L	(-4,A5),-(A7)		;4b05a: 2f2dfffc
	JSR	(___Read,A4)		;4b05e: 4eac81e8
	LEA	($C,A7),A7		;4b062: 4fef000c
	PEA	2.W			;4b066: 48780002
	PEA	(_paint_map,A4)		;4b06a: 486c9c24
	MOVE.L	(-4,A5),-(A7)		;4b06e: 2f2dfffc
	JSR	(___Read,A4)		;4b072: 4eac81e8
	LEA	($C,A7),A7		;4b076: 4fef000c
	PEA	4.W			;4b07a: 48780004
	PEA	(_battle_won,A4)	;4b07e: 486cae7a
	MOVE.L	(-4,A5),-(A7)		;4b082: 2f2dfffc
	JSR	(___Read,A4)		;4b086: 4eac81e8
	LEA	($C,A7),A7		;4b08a: 4fef000c
	PEA	2.W			;4b08e: 48780002
	PEA	(_game_mode,A4)		;4b092: 486c84b8
	MOVE.L	(-4,A5),-(A7)		;4b096: 2f2dfffc
	JSR	(___Read,A4)		;4b09a: 4eac81e8
	LEA	($C,A7),A7		;4b09e: 4fef000c
	PEA	2.W			;4b0a2: 48780002
	PEA	(_level_number,A4)	;4b0a6: 486cae7e
	MOVE.L	(-4,A5),-(A7)		;4b0aa: 2f2dfffc
	JSR	(___Read,A4)		;4b0ae: 4eac81e8
	LEA	($C,A7),A7		;4b0b2: 4fef000c
	PEA	4.W			;4b0b6: 48780004
	PEA	(_score,A4)		;4b0ba: 486cae72
	MOVE.L	(-4,A5),-(A7)		;4b0be: 2f2dfffc
	JSR	(___Read,A4)		;4b0c2: 4eac81e8
	LEA	($C,A7),A7		;4b0c6: 4fef000c
	PEA	2.W			;4b0ca: 48780002
	PEA	(_land_checksum,A4)	;4b0ce: 486c3082
	MOVE.L	(-4,A5),-(A7)		;4b0d2: 2f2dfffc
	JSR	(___Read,A4)		;4b0d6: 4eac81e8
	LEA	($C,A7),A7		;4b0da: 4fef000c
	MOVE.L	(-4,A5),-(A7)		;4b0de: 2f2dfffc
	JSR	(___Close,A4)		;4b0e2: 4eac81d6
	ADDQ.W	#4,A7			;4b0e6: 584f
	CLR.W	-(A7)			;4b0e8: 4267
	MOVE.W	(_ground_in,A4),-(A7)	;4b0ea: 3f2c99e6
	JSR	(___load_ground,A4)	;4b0ee: 4eac80bc
	ADDQ.W	#4,A7			;4b0f2: 584f
	TST.W	(_player,A4)		;4b0f4: 4a6c99f4
	BNE.S	LAB_4B102		;4b0f8: 6608
	MOVE.W	#$0001,(_not_player,A4)	;4b0fa: 397c0001825a
	BRA.S	LAB_4B106		;4b100: 6004
LAB_4B102:
	CLR.W	(_not_player,A4)	;4b102: 426c825a
LAB_4B106:
	MOVE.W	#$ffff,-(A7)		;4b106: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;4b10a: 3f3cffff
	JSR	(___set_tend_icons,A4)	;4b10e: 4eac802c
	ADDQ.W	#4,A7			;4b112: 584f
	MOVE.W	#$ffff,-(A7)		;4b114: 3f3cffff
	MOVE.W	#$ffff,-(A7)		;4b118: 3f3cffff
	JSR	(___set_mode_icons,A4)	;4b11c: 4eac8032
	ADDQ.W	#4,A7			;4b120: 584f
	MOVE.W	(LAB_52DE6,A4),(_god_magnet,A4) ;4b122: 396c99f8ae78
	MOVE.W	(LAB_52DF6,A4),(_devil_magnet,A4) ;4b128: 396c9a08ae76
	MOVE.W	#$ffff,-(A7)		;4b12e: 3f3cffff
	MOVE.L	(_back_scr,A4),-(A7)	;4b132: 2f2c9874
	MOVE.L	(_back_scr,A4),-(A7)	;4b136: 2f2c9874
	JSR	(___Setscreen,A4)	;4b13a: 4eac80c2
	LEA	($A,A7),A7		;4b13e: 4fef000a
	MOVE.W	#$003f,-(A7)		;4b142: 3f3c003f
	MOVE.W	#$003f,-(A7)		;4b146: 3f3c003f
	CLR.W	-(A7)			;4b14a: 4267
	CLR.W	-(A7)			;4b14c: 4267
	JSR	(___draw_map,A4)	;4b14e: 4eac8026
	ADDQ.W	#8,A7			;4b152: 504f
	MOVE.W	#$ffff,-(A7)		;4b154: 3f3cffff
	PEA	-1.W			;4b158: 4878ffff
	MOVE.L	(_w_screen,A4),-(A7)	;4b15c: 2f2c99e8
	JSR	(___Setscreen,A4)	;4b160: 4eac80c2
	LEA	($A,A7),A7		;4b164: 4fef000a
	MOVE.W	#$00cf,(-6,A5)		;4b168: 3b7c00cffffa
	BRA.S	LAB_4B174		;4b16e: 6004
LAB_4B170:
	SUBQ.W	#1,(-6,A5)		;4b170: 536dfffa
LAB_4B174:
	TST.W	(-6,A5)			;4b174: 4a6dfffa
	BLT.S	LAB_4B18C		;4b178: 6d12
	MOVE.W	(-6,A5),D0		;4b17a: 302dfffa
	MULS	#$0016,D0		;4b17e: c1fc0016
	LEA	(LAB_53018,A4),A0	;4b182: 41ec9c2a
	TST.W	(0,A0,D0.L)		;4b186: 4a700800
	BEQ.S	LAB_4B170		;4b18a: 67e4
LAB_4B18C:
	MOVE.W	(-6,A5),D0		;4b18c: 302dfffa
	ADDQ.W	#1,D0			;4b190: 5240
	MOVE.W	D0,(_no_peeps,A4)	;4b192: 3940ae5e
	CLR.W	(-6,A5)			;4b196: 426dfffa
LAB_4B19A:
	MOVE.W	(-6,A5),D0		;4b19a: 302dfffa
	LEA	(strABC,A4),A0		;4b19e: 41ec82e4
	CLR.B	(0,A0,D0.W)		;4b1a2: 42300000
	MOVE.W	(-6,A5),D0		;4b1a6: 302dfffa
	LEA	(_stats,A4),A0		;4b1aa: 41ec82b6
	CLR.B	(0,A0,D0.W)		;4b1ae: 42300000
	ADDQ.W	#1,(-6,A5)		;4b1b2: 526dfffa
	CMPI.W	#$0003,(-6,A5)		;4b1b6: 0c6d0003fffa
	BLT.S	LAB_4B19A		;4b1bc: 6ddc
	CLR.W	(-6,A5)			;4b1be: 426dfffa
	BRA.S	LAB_4B1F0		;4b1c2: 602c
LAB_4B1C4:
	MOVE.W	(-6,A5),D0		;4b1c4: 302dfffa
	MULS	#$0016,D0		;4b1c8: c1fc0016
	LEA	(LAB_53022,A4),A0	;4b1cc: 41ec9c34
	TST.L	(0,A0,D0.L)		;4b1d0: 4ab00800
	BEQ.S	LAB_4B1EC		;4b1d4: 6716
	MOVE.W	(-6,A5),D0		;4b1d6: 302dfffa
	MULS	#$0016,D0		;4b1da: c1fc0016
	LEA	(_peeps,A4),A0		;4b1de: 41ec9c26
	ADD.L	A0,D0			;4b1e2: d088
	MOVE.L	D0,-(A7)		;4b1e4: 2f00
	JSR	(___get_heading,A4)	;4b1e6: 4eac8038
	ADDQ.W	#4,A7			;4b1ea: 584f
LAB_4B1EC:
	ADDQ.W	#1,(-6,A5)		;4b1ec: 526dfffa
LAB_4B1F0:
	MOVE.W	(-6,A5),D0		;4b1f0: 302dfffa
	CMP.W	(_no_peeps,A4),D0	;4b1f4: b06cae5e
	BLT.S	LAB_4B1C4		;4b1f8: 6dca
	CMPI.W	#$0002,(_mode,A4)	;4b1fa: 0c6c00028256
	BNE.S	LAB_4B21A		;4b200: 6618
	CMPI.W	#$0001,(_player,A4)	;4b202: 0c6c000199f4
	BNE.S	LAB_4B20E		;4b208: 6604
	MOVEQ	#1,D0			;4b20a: 7001
	BRA.S	LAB_4B210		;4b20c: 6002
LAB_4B20E:
	MOVEQ	#0,D0			;4b20e: 7000
LAB_4B210:
	MULS	#$0003,D0		;4b210: c1fc0003
	ADDQ.W	#1,D0			;4b214: 5240
	MOVE.W	D0,(_pointer,A4)	;4b216: 394084b6
LAB_4B21A:
	BRA.S	LAB_4B226		;4b21a: 600a
LAB_4B21C:
	MOVE.L	(-4,A5),-(A7)		;4b21c: 2f2dfffc
	JSR	(___Close,A4)		;4b220: 4eac81d6
	ADDQ.W	#4,A7			;4b224: 584f
LAB_4B226:
	UNLK	A5			;4b226: 4e5d
	RTS				;4b228: 4e75
strGAM4:
	;4b22a
	;DC.B	$2e,$47,$41,$4d,$00
	DC.B	".GAM",0
strGAM5:
	;4b22f
	;DC.B	$2e,$47,$41,$4d,$00
	DC.B	".GAM",0
strGAM6:
	;4b234
	;DC.B	$2e,$47,$41,$4d,$00,$00
	DC.B	".GAM",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_get_message:
	LINK.W	A5,#-28			;4b23a: 4e55ffe4
	MOVE.L	D4,-(A7)		;4b23e: 2f04
	TST.W	(_serial_off,A4)	;4b240: 4a6c8254
	BNE.W	LAB_4B4E8		;4b244: 660002a2
	MOVE.W	(_player,A4),D0		;4b248: 302c99f4
	MULS	#$002e,D0		;4b24c: c1fc002e
	LEA	(_stats,A4),A0		;4b250: 41ec82b6
	ADD.L	A0,D0			;4b254: d088
	MOVE.L	D0,(-4,A5)		;4b256: 2b40fffc
	MOVE.W	(_not_player,A4),D0	;4b25a: 302c825a
	MULS	#$002e,D0		;4b25e: c1fc002e
	LEA	(_stats,A4),A0		;4b262: 41ec82b6
	ADD.L	A0,D0			;4b266: d088
	MOVE.L	D0,(-8,A5)		;4b268: 2b40fff8
	MOVEA.L	(-4,A5),A0		;4b26c: 206dfffc
	CMPI.B	#$3f,(1,A0)		;4b270: 0c28003f0001
	BLS.S	LAB_4B282		;4b276: 630a
	MOVEA.L	(-4,A5),A0		;4b278: 206dfffc
	MOVE.B	#$3f,(1,A0)		;4b27c: 117c003f0001
LAB_4B282:
	MOVEA.L	(-4,A5),A0		;4b282: 206dfffc
	CMPI.B	#$3f,(2,A0)		;4b286: 0c28003f0002
	BLS.S	LAB_4B298		;4b28c: 630a
	MOVEA.L	(-4,A5),A0		;4b28e: 206dfffc
	MOVE.B	#$3f,(2,A0)		;4b292: 117c003f0002
LAB_4B298:
	TST.W	(_quick_io,A4)		;4b298: 4a6c3056
	BEQ.W	LAB_4B3E8		;4b29c: 6700014a
	MOVE.L	(-4,A5),-(A7)		;4b2a0: 2f2dfffc
	JSR	(___compress,A4)	;4b2a4: 4eac8194
	ADDQ.W	#4,A7			;4b2a8: 584f
	MOVE.W	D0,(-24,A5)		;4b2aa: 3b40ffe8
	MOVE.W	(_seed,A4),(-28,A5)	;4b2ae: 3b6c99e2ffe4
	TST.W	(_player,A4)		;4b2b4: 4a6c99f4
	BNE.W	LAB_4B348		;4b2b8: 6600008e
	MOVE.W	(_game_turn,A4),D0	;4b2bc: 302cae6a
	AND.W	#$000f,D0		;4b2c0: c07c000f
	BNE.S	LAB_4B2FE		;4b2c4: 6638
	CLR.L	-(A7)			;4b2c6: 42a7
	MOVE.W	#$0002,-(A7)		;4b2c8: 3f3c0002
	PEA	(_seed,A4)		;4b2cc: 486c99e2
	JSR	(_write_serial,PC)	;4b2d0: 4eba1d00
	LEA	($A,A7),A7		;4b2d4: 4fef000a
	PEA	$1B.W			;4b2d8: 4878001b
	MOVE.W	#$0002,-(A7)		;4b2dc: 3f3c0002
	PEA	(-28,A5)		;4b2e0: 486dffe4
	JSR	(_read_serial,PC)	;4b2e4: 4eba1c2a
	LEA	($A,A7),A7		;4b2e8: 4fef000a
	TST.W	D0			;4b2ec: 4a40
	BEQ.S	LAB_4B2FE		;4b2ee: 670e
	MOVE.L	(LAB_51BCC,A4),-(A7)	;4b2f0: 2f2c87de
	JSR	(_serial_message,PC)	;4b2f4: 4ebab0aa
	ADDQ.W	#4,A7			;4b2f8: 584f
	BRA.W	LAB_4B4E8		;4b2fa: 600001ec
LAB_4B2FE:
	CLR.L	-(A7)			;4b2fe: 42a7
	MOVE.W	#$0002,-(A7)		;4b300: 3f3c0002
	PEA	(-24,A5)		;4b304: 486dffe8
	JSR	(_write_serial,PC)	;4b308: 4eba1cc8
	LEA	($A,A7),A7		;4b30c: 4fef000a
	PEA	$1B.W			;4b310: 4878001b
	MOVE.W	#$0002,-(A7)		;4b314: 3f3c0002
	PEA	(-26,A5)		;4b318: 486dffe6
	JSR	(_read_serial,PC)	;4b31c: 4eba1bf2
	LEA	($A,A7),A7		;4b320: 4fef000a
	TST.W	D0			;4b324: 4a40
	BEQ.S	LAB_4B336		;4b326: 670e
	MOVE.L	(LAB_51BCC,A4),-(A7)	;4b328: 2f2c87de
	JSR	(_serial_message,PC)	;4b32c: 4ebab072
	ADDQ.W	#4,A7			;4b330: 584f
	BRA.W	LAB_4B4E8		;4b332: 600001b4
LAB_4B336:
	MOVE.W	(-26,A5),-(A7)		;4b336: 3f2dffe6
	MOVE.L	(-8,A5),-(A7)		;4b33a: 2f2dfff8
	JSR	(_decompress,PC)	;4b33e: 4eba2bc4
	ADDQ.W	#6,A7			;4b342: 5c4f
	BRA.W	LAB_4B3D0		;4b344: 6000008a
LAB_4B348:
	MOVE.W	(_game_turn,A4),D0	;4b348: 302cae6a
	AND.W	#$000f,D0		;4b34c: c07c000f
	BNE.S	LAB_4B38A		;4b350: 6638
	PEA	$1B.W			;4b352: 4878001b
	MOVE.W	#$0002,-(A7)		;4b356: 3f3c0002
	PEA	(-28,A5)		;4b35a: 486dffe4
	JSR	(_read_serial,PC)	;4b35e: 4eba1bb0
	LEA	($A,A7),A7		;4b362: 4fef000a
	TST.W	D0			;4b366: 4a40
	BEQ.S	LAB_4B378		;4b368: 670e
	MOVE.L	(LAB_51BCC,A4),-(A7)	;4b36a: 2f2c87de
	JSR	(_serial_message,PC)	;4b36e: 4ebab030
	ADDQ.W	#4,A7			;4b372: 584f
	BRA.W	LAB_4B4E8		;4b374: 60000172
LAB_4B378:
	CLR.L	-(A7)			;4b378: 42a7
	MOVE.W	#$0002,-(A7)		;4b37a: 3f3c0002
	PEA	(_seed,A4)		;4b37e: 486c99e2
	JSR	(_write_serial,PC)	;4b382: 4eba1c4e
	LEA	($A,A7),A7		;4b386: 4fef000a
LAB_4B38A:
	PEA	$1B.W			;4b38a: 4878001b
	MOVE.W	#$0002,-(A7)		;4b38e: 3f3c0002
	PEA	(-26,A5)		;4b392: 486dffe6
	JSR	(_read_serial,PC)	;4b396: 4eba1b78
	LEA	($A,A7),A7		;4b39a: 4fef000a
	TST.W	D0			;4b39e: 4a40
	BEQ.S	LAB_4B3B0		;4b3a0: 670e
	MOVE.L	(LAB_51BCC,A4),-(A7)	;4b3a2: 2f2c87de
	JSR	(_serial_message,PC)	;4b3a6: 4ebaaff8
	ADDQ.W	#4,A7			;4b3aa: 584f
	BRA.W	LAB_4B4E8		;4b3ac: 6000013a
LAB_4B3B0:
	CLR.L	-(A7)			;4b3b0: 42a7
	MOVE.W	#$0002,-(A7)		;4b3b2: 3f3c0002
	PEA	(-24,A5)		;4b3b6: 486dffe8
	JSR	(_write_serial,PC)	;4b3ba: 4eba1c16
	LEA	($A,A7),A7		;4b3be: 4fef000a
	MOVE.W	(-26,A5),-(A7)		;4b3c2: 3f2dffe6
	MOVE.L	(-8,A5),-(A7)		;4b3c6: 2f2dfff8
	JSR	(_decompress,PC)	;4b3ca: 4eba2b38
	ADDQ.W	#6,A7			;4b3ce: 5c4f
LAB_4B3D0:
	MOVE.W	(-28,A5),D0		;4b3d0: 302dffe4
	CMP.W	(_seed,A4),D0		;4b3d4: b06c99e2
	BEQ.S	LAB_4B3E4		;4b3d8: 670a
	MOVE.L	(LAB_51BD4,A4),-(A7)	;4b3da: 2f2c87e6
	JSR	(_serial_message,PC)	;4b3de: 4ebaafc0
	ADDQ.W	#4,A7			;4b3e2: 584f
LAB_4B3E4:
	BRA.W	LAB_4B4E8		;4b3e4: 60000102
LAB_4B3E8:
	MOVEA.L	(-4,A5),A0		;4b3e8: 206dfffc
	MOVE.B	(LAB_52DD1,A4),(3,A0)	;4b3ec: 116c99e30003
	MOVEQ	#0,D4			;4b3f2: 7800
	MOVEA.L	(-4,A5),A0		;4b3f4: 206dfffc
	CLR.B	(4,A0)			;4b3f8: 42280004
	MOVEQ	#0,D0			;4b3fc: 7000
	MOVEQ	#0,D0			;4b3fe: 7000
	BRA.S	LAB_4B414		;4b400: 6012
LAB_4B402:
	MOVEA.L	(-4,A5),A0		;4b402: 206dfffc
	MOVEA.L	(-4,A5),A1		;4b406: 226dfffc
	MOVE.B	(0,A1,D4.W),D0		;4b40a: 10314000
	ADD.B	D0,(4,A0)		;4b40e: d1280004
	ADDQ.W	#1,D4			;4b412: 5244
LAB_4B414:
	CMP.W	#$0003,D4		;4b414: b87c0003
	BLE.S	LAB_4B402		;4b418: 6fe8
	TST.W	(_player,A4)		;4b41a: 4a6c99f4
	BNE.S	LAB_4B478		;4b41e: 6658
	MOVE.L	(-4,A5),-(A7)		;4b420: 2f2dfffc
	JSR	(_write_full,PC)	;4b424: 4eba047a
	ADDQ.W	#4,A7			;4b428: 584f
	MOVE.W	D0,D4			;4b42a: 3800
	BEQ.S	LAB_4B44A		;4b42c: 671c
	MOVE.W	D4,D0			;4b42e: 3004
	ADD.W	#$000c,D0		;4b430: d07c000c
	EXT.L	D0			;4b434: 48c0
	ASL.L	#2,D0			;4b436: e580
	LEA	(_g_text,A4),A0		;4b438: 41ec87aa
	MOVE.L	(0,A0,D0.L),-(A7)	;4b43c: 2f300800
	JSR	(_serial_message,PC)	;4b440: 4ebaaf5e
	ADDQ.W	#4,A7			;4b444: 584f
	BRA.W	LAB_4B4E8		;4b446: 600000a0
LAB_4B44A:
	MOVE.L	(-4,A5),-(A7)		;4b44a: 2f2dfffc
	MOVE.L	(-8,A5),-(A7)		;4b44e: 2f2dfff8
	JSR	(_read_full,PC)		;4b452: 4eba04b6
	ADDQ.W	#8,A7			;4b456: 504f
	MOVE.W	D0,D4			;4b458: 3800
	BEQ.S	LAB_4B476		;4b45a: 671a
	MOVE.W	D4,D0			;4b45c: 3004
	ADD.W	#$000c,D0		;4b45e: d07c000c
	EXT.L	D0			;4b462: 48c0
	ASL.L	#2,D0			;4b464: e580
	LEA	(_g_text,A4),A0		;4b466: 41ec87aa
	MOVE.L	(0,A0,D0.L),-(A7)	;4b46a: 2f300800
	JSR	(_serial_message,PC)	;4b46e: 4ebaaf30
	ADDQ.W	#4,A7			;4b472: 584f
	BRA.S	LAB_4B4E8		;4b474: 6072
LAB_4B476:
	BRA.S	LAB_4B4CC		;4b476: 6054
LAB_4B478:
	MOVE.L	(-4,A5),-(A7)		;4b478: 2f2dfffc
	MOVE.L	(-8,A5),-(A7)		;4b47c: 2f2dfff8
	JSR	(_read_full,PC)		;4b480: 4eba0488
	ADDQ.W	#8,A7			;4b484: 504f
	MOVE.W	D0,D4			;4b486: 3800
	BEQ.S	LAB_4B4A4		;4b488: 671a
	MOVE.W	D4,D0			;4b48a: 3004
	ADD.W	#$000c,D0		;4b48c: d07c000c
	EXT.L	D0			;4b490: 48c0
	ASL.L	#2,D0			;4b492: e580
	LEA	(_g_text,A4),A0		;4b494: 41ec87aa
	MOVE.L	(0,A0,D0.L),-(A7)	;4b498: 2f300800
	JSR	(_serial_message,PC)	;4b49c: 4ebaaf02
	ADDQ.W	#4,A7			;4b4a0: 584f
	BRA.S	LAB_4B4E8		;4b4a2: 6044
LAB_4B4A4:
	MOVE.L	(-4,A5),-(A7)		;4b4a4: 2f2dfffc
	JSR	(_write_full,PC)	;4b4a8: 4eba03f6
	ADDQ.W	#4,A7			;4b4ac: 584f
	MOVE.W	D0,D4			;4b4ae: 3800
	BEQ.S	LAB_4B4CC		;4b4b0: 671a
	MOVE.W	D4,D0			;4b4b2: 3004
	ADD.W	#$000c,D0		;4b4b4: d07c000c
	EXT.L	D0			;4b4b8: 48c0
	ASL.L	#2,D0			;4b4ba: e580
	LEA	(_g_text,A4),A0		;4b4bc: 41ec87aa
	MOVE.L	(0,A0,D0.L),-(A7)	;4b4c0: 2f300800
	JSR	(_serial_message,PC)	;4b4c4: 4ebaaeda
	ADDQ.W	#4,A7			;4b4c8: 584f
	BRA.S	LAB_4B4E8		;4b4ca: 601c
LAB_4B4CC:
	MOVEA.L	(-4,A5),A0		;4b4cc: 206dfffc
	MOVEA.L	(-8,A5),A1		;4b4d0: 226dfff8
	MOVE.B	(3,A0),D0		;4b4d4: 10280003
	CMP.B	(3,A1),D0		;4b4d8: b0290003
	BEQ.S	LAB_4B4E8		;4b4dc: 670a
	MOVE.L	(LAB_51BD4,A4),-(A7)	;4b4de: 2f2c87e6
	JSR	(_serial_message,PC)	;4b4e2: 4ebaaebc
	ADDQ.W	#4,A7			;4b4e6: 584f
LAB_4B4E8:
	MOVEQ	#0,D4			;4b4e8: 7800
LAB_4B4EA:
	MOVE.W	D4,D0			;4b4ea: 3004
	MULS	#$002e,D0		;4b4ec: c1fc002e
	LEA	(LAB_516AA,A4),A0	;4b4f0: 41ec82bc
	CMPI.W	#$0001,(0,A0,D0.L)	;4b4f4: 0c7000010800
	BNE.S	LAB_4B528		;4b4fa: 662c
	MOVE.W	D4,D0			;4b4fc: 3004
	MULS	#$002e,D0		;4b4fe: c1fc002e
	LEA	(LAB_516B4,A4),A0	;4b502: 41ec82c6
	MOVE.W	(_game_turn,A4),D1	;4b506: 322cae6a
	SWAP	D1			;4b50a: 4841
	CLR.W	D1			;4b50c: 4241
	SWAP	D1			;4b50e: 4841
	DIVU	(0,A0,D0.L),D1		;4b510: 82f00800
	SWAP	D1			;4b514: 4841
	TST.W	D1			;4b516: 4a41
	BNE.S	LAB_4B528		;4b518: 660e
	MOVE.W	D4,D0			;4b51a: 3004
	MULS	#$002e,D0		;4b51c: c1fc002e
	LEA	(LAB_516AC,A4),A0	;4b520: 41ec82be
	CLR.W	(0,A0,D0.L)		;4b524: 42700800
LAB_4B528:
	MOVE.W	D4,D0			;4b528: 3004
	MULS	#$002e,D0		;4b52a: c1fc002e
	LEA	(_stats,A4),A0		;4b52e: 41ec82b6
	MOVEQ	#0,D1			;4b532: 7200
	MOVE.B	(0,A0,D0.L),D1		;4b534: 12300800
	MOVE.W	D1,(-12,A5)		;4b538: 3b41fff4
	BEQ.W	LAB_4B84A		;4b53c: 6700030c
	MOVE.W	D4,D0			;4b540: 3004
	MULS	#$002e,D0		;4b542: c1fc002e
	LEA	(LAB_516A5,A4),A0	;4b546: 41ec82b7
	MOVEQ	#0,D1			;4b54a: 7200
	MOVE.B	(0,A0,D0.L),D1		;4b54c: 12300800
	MOVE.W	D1,(-14,A5)		;4b550: 3b41fff2
	MOVE.W	D4,D0			;4b554: 3004
	MULS	#$002e,D0		;4b556: c1fc002e
	LEA	(LAB_516A6,A4),A0	;4b55a: 41ec82b8
	MOVEQ	#0,D1			;4b55e: 7200
	MOVE.B	(0,A0,D0.L),D1		;4b560: 12300800
	MOVE.W	D1,(-16,A5)		;4b564: 3b41fff0
	MOVE.W	(-12,A5),D0		;4b568: 302dfff4
	EXT.L	D0			;4b56c: 48c0
	BRA.W	LAB_4B838		;4b56e: 600002c8
LAB_4B572:
	MOVE.W	(-16,A5),-(A7)		;4b572: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b576: 3f2dfff2
	MOVE.W	D4,-(A7)		;4b57a: 3f04
	JSR	(___do_magnet,A4)	;4b57c: 4eac8044
	ADDQ.W	#6,A7			;4b580: 5c4f
	BRA.W	LAB_4B84A		;4b582: 600002c6
LAB_4B586:
	MOVE.W	(-16,A5),-(A7)		;4b586: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b58a: 3f2dfff2
	MOVE.W	D4,-(A7)		;4b58e: 3f04
	JSR	(___do_raise_point,A4)	;4b590: 4eac8062
	ADDQ.W	#6,A7			;4b594: 5c4f
	BRA.W	LAB_4B84A		;4b596: 600002b2
LAB_4B59A:
	MOVE.W	(-16,A5),-(A7)		;4b59a: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b59e: 3f2dfff2
	MOVE.W	D4,-(A7)		;4b5a2: 3f04
	JSR	(___do_lower_point,A4)	;4b5a4: 4eac805c
	ADDQ.W	#6,A7			;4b5a8: 5c4f
	BRA.W	LAB_4B84A		;4b5aa: 6000029e
LAB_4B5AE:
	MOVE.W	(-16,A5),-(A7)		;4b5ae: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b5b2: 3f2dfff2
	MOVE.W	D4,-(A7)		;4b5b6: 3f04
	JSR	(___do_quake,A4)	;4b5b8: 4eac806e
	ADDQ.W	#6,A7			;4b5bc: 5c4f
	BRA.W	LAB_4B84A		;4b5be: 6000028a
LAB_4B5C2:
	MOVE.W	(-16,A5),-(A7)		;4b5c2: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b5c6: 3f2dfff2
	MOVE.W	D4,-(A7)		;4b5ca: 3f04
	JSR	(___do_swamp,A4)	;4b5cc: 4eac807a
	ADDQ.W	#6,A7			;4b5d0: 5c4f
	BRA.W	LAB_4B84A		;4b5d2: 60000276
LAB_4B5D6:
	MOVE.W	(-16,A5),-(A7)		;4b5d6: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b5da: 3f2dfff2
	MOVE.W	D4,-(A7)		;4b5de: 3f04
	JSR	(___do_volcano,A4)	;4b5e0: 4eac8074
	ADDQ.W	#6,A7			;4b5e4: 5c4f
	BRA.W	LAB_4B84A		;4b5e6: 60000262
LAB_4B5EA:
	CLR.W	-(A7)			;4b5ea: 4267
	MOVE.W	(-16,A5),-(A7)		;4b5ec: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b5f0: 3f2dfff2
	CLR.W	-(A7)			;4b5f4: 4267
	JSR	(___place_people,A4)	;4b5f6: 4eac8056
	ADDQ.W	#8,A7			;4b5fa: 504f
	BRA.W	LAB_4B84A		;4b5fc: 6000024c
LAB_4B600:
	CLR.W	-(A7)			;4b600: 4267
	MOVE.W	(-16,A5),-(A7)		;4b602: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b606: 3f2dfff2
	MOVE.W	#$0001,-(A7)		;4b60a: 3f3c0001
	JSR	(___place_people,A4)	;4b60e: 4eac8056
	ADDQ.W	#8,A7			;4b612: 504f
	BRA.W	LAB_4B84A		;4b614: 60000234
LAB_4B618:
	MOVE.W	#$0001,-(A7)		;4b618: 3f3c0001
	MOVE.W	(-16,A5),-(A7)		;4b61c: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b620: 3f2dfff2
	CLR.W	-(A7)			;4b624: 4267
	JSR	(___place_people,A4)	;4b626: 4eac8056
	ADDQ.W	#8,A7			;4b62a: 504f
	BRA.W	LAB_4B84A		;4b62c: 6000021c
LAB_4B630:
	MOVE.W	#$0001,-(A7)		;4b630: 3f3c0001
	MOVE.W	(-16,A5),-(A7)		;4b634: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b638: 3f2dfff2
	MOVE.W	#$0001,-(A7)		;4b63c: 3f3c0001
	JSR	(___place_people,A4)	;4b640: 4eac8056
	ADDQ.W	#8,A7			;4b644: 504f
	BRA.W	LAB_4B84A		;4b646: 60000202
LAB_4B64A:
	MOVE.W	(-16,A5),D0		;4b64a: 302dfff0
	ASL.W	#6,D0			;4b64e: ed40
	ADD.W	(-14,A5),D0		;4b650: d06dfff2
	LEA	(_map_alt,A4),A0	;4b654: 41ecdf88
	CMPI.B	#$07,(0,A0,D0.W)	;4b658: 0c3000070000
	BCC.S	LAB_4B6BE		;4b65e: 645e
	MOVE.W	(-16,A5),D0		;4b660: 302dfff0
	ASL.W	#6,D0			;4b664: ed40
	ADD.W	(-14,A5),D0		;4b666: d06dfff2
	LEA	(_map_bk2,A4),A0	;4b66a: 41ecef88
	MOVEQ	#0,D1			;4b66e: 7200
	MOVE.B	(0,A0,D0.W),D1		;4b670: 12300000
	MOVE.W	D1,(-10,A5)		;4b674: 3b41fff6
	CMPI.W	#$0032,(-10,A5)		;4b678: 0c6d0032fff6
	BLT.S	LAB_4B688		;4b67e: 6d08
	CMPI.W	#$0034,(-10,A5)		;4b680: 0c6d0034fff6
	BLE.S	LAB_4B690		;4b686: 6f08
LAB_4B688:
	MOVE.W	(_last_tree,A4),(-10,A5) ;4b688: 3b6c825cfff6
	BRA.S	LAB_4B6A4		;4b68e: 6014
LAB_4B690:
	CMPI.W	#$0034,(-10,A5)		;4b690: 0c6d0034fff6
	BNE.S	LAB_4B6A0		;4b696: 6608
	MOVE.W	#$0032,(-10,A5)		;4b698: 3b7c0032fff6
	BRA.S	LAB_4B6A4		;4b69e: 6004
LAB_4B6A0:
	ADDQ.W	#1,(-10,A5)		;4b6a0: 526dfff6
LAB_4B6A4:
	MOVE.W	(-10,A5),(_last_tree,A4) ;4b6a4: 396dfff6825c
	MOVE.W	(-16,A5),D0		;4b6aa: 302dfff0
	ASL.W	#6,D0			;4b6ae: ed40
	ADD.W	(-14,A5),D0		;4b6b0: d06dfff2
	LEA	(_map_bk2,A4),A0	;4b6b4: 41ecef88
	MOVE.B	(-9,A5),(0,A0,D0.W)	;4b6b8: 11adfff70000
LAB_4B6BE:
	BRA.W	LAB_4B84A		;4b6be: 6000018a
LAB_4B6C2:
	MOVE.W	(-16,A5),D0		;4b6c2: 302dfff0
	ASL.W	#6,D0			;4b6c6: ed40
	ADD.W	(-14,A5),D0		;4b6c8: d06dfff2
	LEA	(_map_alt,A4),A0	;4b6cc: 41ecdf88
	CMPI.B	#$07,(0,A0,D0.W)	;4b6d0: 0c3000070000
	BCC.S	LAB_4B736		;4b6d6: 645e
	MOVE.W	(-16,A5),D0		;4b6d8: 302dfff0
	ASL.W	#6,D0			;4b6dc: ed40
	ADD.W	(-14,A5),D0		;4b6de: d06dfff2
	LEA	(_map_blk,A4),A0	;4b6e2: 41eccf88
	MOVEQ	#0,D1			;4b6e6: 7200
	MOVE.B	(0,A0,D0.W),D1		;4b6e8: 12300000
	MOVE.W	D1,(-10,A5)		;4b6ec: 3b41fff6
	CMPI.W	#$002f,(-10,A5)		;4b6f0: 0c6d002ffff6
	BLT.S	LAB_4B700		;4b6f6: 6d08
	CMPI.W	#$0031,(-10,A5)		;4b6f8: 0c6d0031fff6
	BLE.S	LAB_4B708		;4b6fe: 6f08
LAB_4B700:
	MOVE.W	(_last_rock,A4),(-10,A5) ;4b700: 3b6c825efff6
	BRA.S	LAB_4B71C		;4b706: 6014
LAB_4B708:
	CMPI.W	#$0031,(-10,A5)		;4b708: 0c6d0031fff6
	BNE.S	LAB_4B718		;4b70e: 6608
	MOVE.W	#$002f,(-10,A5)		;4b710: 3b7c002ffff6
	BRA.S	LAB_4B71C		;4b716: 6004
LAB_4B718:
	ADDQ.W	#1,(-10,A5)		;4b718: 526dfff6
LAB_4B71C:
	MOVE.W	(-10,A5),(_last_rock,A4) ;4b71c: 396dfff6825e
	MOVE.W	(-16,A5),D0		;4b722: 302dfff0
	ASL.W	#6,D0			;4b726: ed40
	ADD.W	(-14,A5),D0		;4b728: d06dfff2
	LEA	(_map_blk,A4),A0	;4b72c: 41eccf88
	MOVE.B	(-9,A5),(0,A0,D0.W)	;4b730: 11adfff70000
LAB_4B736:
	BRA.W	LAB_4B84A		;4b736: 60000112
LAB_4B73A:
	MOVE.W	(-16,A5),D0		;4b73a: 302dfff0
	ASL.W	#6,D0			;4b73e: ed40
	ADD.W	(-14,A5),D0		;4b740: d06dfff2
	MOVE.W	D0,(-10,A5)		;4b744: 3b40fff6
	MOVE.W	(-10,A5),D0		;4b748: 302dfff6
	LEA	(_map_blk,A4),A0	;4b74c: 41eccf88
	CMPI.B	#$2f,(0,A0,D0.W)	;4b750: 0c30002f0000
	BCS.S	LAB_4B794		;4b756: 653c
	MOVE.W	(-10,A5),D0		;4b758: 302dfff6
	LEA	(_map_blk,A4),A0	;4b75c: 41eccf88
	CMPI.B	#$31,(0,A0,D0.W)	;4b760: 0c3000310000
	BHI.S	LAB_4B794		;4b766: 622c
	MOVE.W	(-10,A5),D0		;4b768: 302dfff6
	LEA	(_map_blk,A4),A0	;4b76c: 41eccf88
	MOVE.B	#$0f,(0,A0,D0.W)	;4b770: 11bc000f0000
	MOVE.W	(-16,A5),D0		;4b776: 302dfff0
	ADDQ.W	#1,D0			;4b77a: 5240
	MOVE.W	D0,-(A7)		;4b77c: 3f00
	MOVE.W	(-14,A5),D0		;4b77e: 302dfff2
	ADDQ.W	#1,D0			;4b782: 5240
	MOVE.W	D0,-(A7)		;4b784: 3f00
	MOVE.W	(-16,A5),-(A7)		;4b786: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b78a: 3f2dfff2
	JSR	(___make_map,A4)	;4b78e: 4eac8020
	ADDQ.W	#8,A7			;4b792: 504f
LAB_4B794:
	MOVE.W	(-10,A5),D0		;4b794: 302dfff6
	LEA	(_map_bk2,A4),A0	;4b798: 41ecef88
	CLR.B	(0,A0,D0.W)		;4b79c: 42300000
	MOVE.W	(-10,A5),D0		;4b7a0: 302dfff6
	EXT.L	D0			;4b7a4: 48c0
	LEA	(_map_who,A4),A0	;4b7a6: 41ec1f88
	ADD.L	A0,D0			;4b7aa: d088
	MOVE.L	D0,(-22,A5)		;4b7ac: 2b40ffea
	MOVEA.L	(-22,A5),A0		;4b7b0: 206dffea
	TST.B	(A0)			;4b7b4: 4a10
	BEQ.S	LAB_4B7F8		;4b7b6: 6740
	MOVEA.L	(-22,A5),A0		;4b7b8: 206dffea
	MOVEQ	#0,D0			;4b7bc: 7000
	MOVE.B	(A0),D0			;4b7be: 1010
	SUBQ.W	#1,D0			;4b7c0: 5340
	MOVE.W	D0,-(A7)		;4b7c2: 3f00
	MOVEA.L	(-22,A5),A0		;4b7c4: 206dffea
	MOVEQ	#0,D0			;4b7c8: 7000
	MOVE.B	(A0),D0			;4b7ca: 1010
	SUBQ.W	#1,D0			;4b7cc: 5340
	MULU	#$0016,D0		;4b7ce: c0fc0016
	LEA	(_peeps,A4),A0		;4b7d2: 41ec9c26
	ADD.L	A0,D0			;4b7d6: d088
	MOVE.L	D0,-(A7)		;4b7d8: 2f00
	JSR	(___zero_population,A4)	;4b7da: 4eac803e
	ADDQ.W	#6,A7			;4b7de: 5c4f
	MOVE.W	(-16,A5),D0		;4b7e0: 302dfff0
	ASL.W	#6,D0			;4b7e4: ed40
	ADD.W	(-14,A5),D0		;4b7e6: d06dfff2
	LEA	(_map_bk2,A4),A0	;4b7ea: 41ecef88
	CLR.B	(0,A0,D0.W)		;4b7ee: 42300000
	MOVEA.L	(-22,A5),A0		;4b7f2: 206dffea
	CLR.B	(A0)			;4b7f6: 4210
LAB_4B7F8:
	BRA.S	LAB_4B84A		;4b7f8: 6050
LAB_4B7FA:
	MOVE.W	(-16,A5),-(A7)		;4b7fa: 3f2dfff0
	MOVE.W	(-14,A5),-(A7)		;4b7fe: 3f2dfff2
	MOVE.W	D4,-(A7)		;4b802: 3f04
	JSR	(_do_action,PC)		;4b804: 4eba01da
	ADDQ.W	#6,A7			;4b808: 5c4f
	TST.W	D0			;4b80a: 4a40
	BEQ.S	LAB_4B816		;4b80c: 6708
	BSR.S	_clear_send		;4b80e: 6148
LAB_4B810:
	MOVE.L	(A7)+,D4		;4b810: 281f
	UNLK	A5			;4b812: 4e5d
	RTS				;4b814: 4e75
LAB_4B816:
	BRA.S	LAB_4B84A		;4b816: 6032
LAB_4B818:
	BRA.S	LAB_4B84A		;4b818: 6030
LAB_4B81A:
	DC.W	(LAB_4B818)-(LAB_4B846+2) ;4b81a: ffd0
	DC.W	(LAB_4B586)-(LAB_4B846+2) ;4b81c: fd3e
	DC.W	(LAB_4B59A)-(LAB_4B846+2) ;4b81e: fd52
	DC.W	(LAB_4B5AE)-(LAB_4B846+2) ;4b820: fd66
	DC.W	(LAB_4B5C2)-(LAB_4B846+2) ;4b822: fd7a
	DC.W	(LAB_4B572)-(LAB_4B846+2) ;4b824: fd2a
	DC.W	(LAB_4B5D6)-(LAB_4B846+2) ;4b826: fd8e
	DC.W	(LAB_4B5EA)-(LAB_4B846+2) ;4b828: fda2
	DC.W	(LAB_4B600)-(LAB_4B846+2) ;4b82a: fdb8
	DC.W	(LAB_4B618)-(LAB_4B846+2) ;4b82c: fdd0
	DC.W	(LAB_4B630)-(LAB_4B846+2) ;4b82e: fde8
	DC.W	(LAB_4B64A)-(LAB_4B846+2) ;4b830: fe02
	DC.W	(LAB_4B6C2)-(LAB_4B846+2) ;4b832: fe7a
	DC.W	(LAB_4B73A)-(LAB_4B846+2) ;4b834: fef2
	DC.W	(LAB_4B7FA)-(LAB_4B846+2) ;4b836: ffb2
LAB_4B838:
	CMP.L	#$0000000f,D0		;4b838: b0bc0000000f
	BCC.S	LAB_4B818		;4b83e: 64d8
	ASL.L	#1,D0			;4b840: e380
	MOVE.W	(LAB_4B81A,PC,D0.W),D0	;4b842: 303b00d6
LAB_4B846:
	JMP	(LAB_4B846+2,PC,D0.W)	;4b846: 4efb0000
LAB_4B84A:
	ADDQ.W	#1,D4			;4b84a: 5244
	CMP.W	#$0002,D4		;4b84c: b87c0002
	BLT.W	LAB_4B4EA		;4b850: 6d00fc98
	BSR.S	_clear_send		;4b854: 6102
	BRA.S	LAB_4B810		;4b856: 60b8
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_clear_send:
	LINK.W	A5,#-2			;4b858: 4e55fffe
	CLR.W	(-2,A5)			;4b85c: 426dfffe
LAB_4B860:
	MOVE.W	(-2,A5),D0		;4b860: 302dfffe
	MULS	#$002e,D0		;4b864: c1fc002e
	LEA	(_stats,A4),A0		;4b868: 41ec82b6
	CLR.B	(0,A0,D0.L)		;4b86c: 42300800
	MOVE.W	(-2,A5),D0		;4b870: 302dfffe
	MULS	#$002e,D0		;4b874: c1fc002e
	LEA	(LAB_516A5,A4),A0	;4b878: 41ec82b7
	CLR.B	(0,A0,D0.L)		;4b87c: 42300800
	MOVE.W	(-2,A5),D0		;4b880: 302dfffe
	MULS	#$002e,D0		;4b884: c1fc002e
	LEA	(LAB_516A6,A4),A0	;4b888: 41ec82b8
	CLR.B	(0,A0,D0.L)		;4b88c: 42300800
	ADDQ.W	#1,(-2,A5)		;4b890: 526dfffe
	CMPI.W	#$0002,(-2,A5)		;4b894: 0c6d0002fffe
	BLT.S	LAB_4B860		;4b89a: 6dc4
	UNLK	A5			;4b89c: 4e5d
	RTS				;4b89e: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_write_full:
	LINK.W	A5,#-8			;4b8a0: 4e55fff8
	MOVE.B	#$67,(-7,A5)		;4b8a4: 1b7c0067fff9
LAB_4B8AA:
	CLR.L	-(A7)			;4b8aa: 42a7
	MOVE.W	#$0005,-(A7)		;4b8ac: 3f3c0005
	MOVE.L	(8,A5),-(A7)		;4b8b0: 2f2d0008
	JSR	(_write_serial,PC)	;4b8b4: 4eba171c
	LEA	($A,A7),A7		;4b8b8: 4fef000a
LAB_4B8BC:
	PEA	$1B.W			;4b8bc: 4878001b
	MOVE.W	#$0001,-(A7)		;4b8c0: 3f3c0001
	PEA	(-1,A5)			;4b8c4: 486dffff
	JSR	(_read_serial,PC)	;4b8c8: 4eba1646
	LEA	($A,A7),A7		;4b8cc: 4fef000a
	TST.W	D0			;4b8d0: 4a40
	BEQ.S	LAB_4B8DA		;4b8d2: 6706
	MOVEQ	#1,D0			;4b8d4: 7001
LAB_4B8D6:
	UNLK	A5			;4b8d6: 4e5d
	RTS				;4b8d8: 4e75
LAB_4B8DA:
	CMPI.B	#$7c,(-1,A5)		;4b8da: 0c2d007cffff
	BNE.S	LAB_4B8E6		;4b8e0: 6604
	MOVEQ	#0,D0			;4b8e2: 7000
	BRA.S	LAB_4B8D6		;4b8e4: 60f0
LAB_4B8E6:
	JSR	(_clear_serial,PC)	;4b8e6: 4eba15c4
	CMPI.B	#$62,(-1,A5)		;4b8ea: 0c2d0062ffff
	BNE.S	LAB_4B8BC		;4b8f0: 66ca
	CLR.L	-(A7)			;4b8f2: 42a7
	MOVE.W	#$0001,-(A7)		;4b8f4: 3f3c0001
	PEA	(-7,A5)			;4b8f8: 486dfff9
	JSR	(_write_serial,PC)	;4b8fc: 4eba16d4
	LEA	($A,A7),A7		;4b900: 4fef000a
	BRA.S	LAB_4B8AA		;4b904: 60a4
	MOVEQ	#2,D0			;4b906: 7002
	BRA.S	LAB_4B8D6		;4b908: 60cc
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_read_full:
	LINK.W	A5,#-10			;4b90a: 4e55fff6
	MOVE.B	#$7c,(-5,A5)		;4b90e: 1b7c007cfffb
	MOVE.B	#$62,(-6,A5)		;4b914: 1b7c0062fffa
LAB_4B91A:
	PEA	$1B.W			;4b91a: 4878001b
	MOVE.W	#$0005,-(A7)		;4b91e: 3f3c0005
	MOVE.L	(8,A5),-(A7)		;4b922: 2f2d0008
	JSR	(_read_serial,PC)	;4b926: 4eba15e8
	LEA	($A,A7),A7		;4b92a: 4fef000a
	TST.W	D0			;4b92e: 4a40
	BEQ.S	LAB_4B938		;4b930: 6706
	MOVEQ	#1,D0			;4b932: 7001
LAB_4B934:
	UNLK	A5			;4b934: 4e5d
	RTS				;4b936: 4e75
LAB_4B938:
	CLR.B	(-9,A5)			;4b938: 422dfff7
	MOVEQ	#0,D0			;4b93c: 7000
	MOVEQ	#0,D0			;4b93e: 7000
	MOVE.W	D0,(-8,A5)		;4b940: 3b40fff8
	BRA.S	LAB_4B95A		;4b944: 6014
LAB_4B946:
	MOVE.W	(-8,A5),D0		;4b946: 302dfff8
	MOVEA.L	(8,A5),A0		;4b94a: 206d0008
	MOVE.B	(0,A0,D0.W),D1		;4b94e: 12300000
	ADD.B	D1,(-9,A5)		;4b952: d32dfff7
	ADDQ.W	#1,(-8,A5)		;4b956: 526dfff8
LAB_4B95A:
	CMPI.W	#$0003,(-8,A5)		;4b95a: 0c6d0003fff8
	BLE.S	LAB_4B946		;4b960: 6fe4
	MOVEA.L	(8,A5),A0		;4b962: 206d0008
	MOVE.B	(4,A0),D0		;4b966: 10280004
	CMP.B	(-9,A5),D0		;4b96a: b02dfff7
	BEQ.S	LAB_4B9BE		;4b96e: 674e
	JSR	(_clear_serial,PC)	;4b970: 4eba153a
	CLR.B	(-9,A5)			;4b974: 422dfff7
LAB_4B978:
	PEA	$1B.W			;4b978: 4878001b
	MOVE.W	#$0001,-(A7)		;4b97c: 3f3c0001
	PEA	(-6,A5)			;4b980: 486dfffa
	JSR	(_write_serial,PC)	;4b984: 4eba164c
	LEA	($A,A7),A7		;4b988: 4fef000a
	TST.W	D0			;4b98c: 4a40
	BEQ.S	LAB_4B994		;4b98e: 6704
	MOVEQ	#1,D0			;4b990: 7001
	BRA.S	LAB_4B934		;4b992: 60a0
LAB_4B994:
	MOVE.W	#$0001,-(A7)		;4b994: 3f3c0001
	JSR	(_check_serial,PC)	;4b998: 4ebaee9a
	ADDQ.W	#2,A7			;4b99c: 544f
	TST.W	D0			;4b99e: 4a40
	BEQ.S	LAB_4B9B4		;4b9a0: 6712
	CLR.L	-(A7)			;4b9a2: 42a7
	MOVE.W	#$0001,-(A7)		;4b9a4: 3f3c0001
	PEA	(-9,A5)			;4b9a8: 486dfff7
	JSR	(_read_serial,PC)	;4b9ac: 4eba1562
	LEA	($A,A7),A7		;4b9b0: 4fef000a
LAB_4B9B4:
	CMPI.B	#$67,(-9,A5)		;4b9b4: 0c2d0067fff7
	BNE.S	LAB_4B978		;4b9ba: 66bc
	BRA.S	LAB_4B9D6		;4b9bc: 6018
LAB_4B9BE:
	CLR.L	-(A7)			;4b9be: 42a7
	MOVE.W	#$0001,-(A7)		;4b9c0: 3f3c0001
	PEA	(-5,A5)			;4b9c4: 486dfffb
	JSR	(_write_serial,PC)	;4b9c8: 4eba1608
	LEA	($A,A7),A7		;4b9cc: 4fef000a
	MOVEQ	#0,D0			;4b9d0: 7000
	BRA.W	LAB_4B934		;4b9d2: 6000ff60
LAB_4B9D6:
	BRA.W	LAB_4B91A		;4b9d6: 6000ff42
	MOVEQ	#2,D0			;4b9da: 7002
	BRA.W	LAB_4B934		;4b9dc: 6000ff56
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_do_action:
	LINK.W	A5,#-2			;4b9e0: 4e55fffe
	MOVE.W	($C,A5),D0		;4b9e4: 302d000c
	EXT.L	D0			;4b9e8: 48c0
	BRA.W	LAB_4C18A		;4b9ea: 6000079e
LAB_4B9EE:
	MOVE.W	(8,A5),D0		;4b9ee: 302d0008
	CMP.W	(_player,A4),D0		;4b9f2: b06c99f4
	BNE.S	LAB_4BA1E		;4b9f6: 6626
	MOVE.W	($A,A5),D0		;4b9f8: 302d000a
	EXT.L	D0			;4b9fc: 48c0
	ASL.L	#1,D0			;4b9fe: e380
	LEA	(_tend_y,A4),A0		;4ba00: 41ec828a
	MOVE.W	(0,A0,D0.L),-(A7)	;4ba04: 3f300800
	MOVE.W	($A,A5),D0		;4ba08: 302d000a
	EXT.L	D0			;4ba0c: 48c0
	ASL.L	#1,D0			;4ba0e: e380
	LEA	(_tend_x,A4),A0		;4ba10: 41ec8282
	MOVE.W	(0,A0,D0.L),-(A7)	;4ba14: 3f300800
	JSR	(___set_tend_icons,A4)	;4ba18: 4eac802c
	ADDQ.W	#4,A7			;4ba1c: 584f
LAB_4BA1E:
	MOVE.W	(8,A5),D0		;4ba1e: 302d0008
	EXT.L	D0			;4ba22: 48c0
	ASL.L	#4,D0			;4ba24: e980
	LEA	(LAB_52DE8,A4),A0	;4ba26: 41ec99fa
	MOVE.W	($A,A5),(0,A0,D0.L)	;4ba2a: 31ad000a0800
	BRA.W	LAB_4C19C		;4ba30: 6000076a
LAB_4BA34:
	TST.W	(_serial_off,A4)	;4ba34: 4a6c8254
	BNE.W	LAB_4C19C		;4ba38: 66000762
	TST.W	(8,A5)			;4ba3c: 4a6d0008
	BNE.S	LAB_4BA46		;4ba40: 6604
	MOVEQ	#1,D0			;4ba42: 7001
	BRA.S	LAB_4BA48		;4ba44: 6002
LAB_4BA46:
	MOVEQ	#0,D0			;4ba46: 7000
LAB_4BA48:
	MULS	#$002e,D0		;4ba48: c1fc002e
	LEA	(LAB_516A6,A4),A0	;4ba4c: 41ec82b8
	CMPI.B	#$02,(0,A0,D0.L)	;4ba50: 0c3000020800
	BNE.S	LAB_4BA76		;4ba56: 661e
	TST.W	(8,A5)			;4ba58: 4a6d0008
	BNE.S	LAB_4BA62		;4ba5c: 6604
	MOVEQ	#1,D0			;4ba5e: 7001
	BRA.S	LAB_4BA64		;4ba60: 6002
LAB_4BA62:
	MOVEQ	#0,D0			;4ba62: 7000
LAB_4BA64:
	MULS	#$002e,D0		;4ba64: c1fc002e
	LEA	(_stats,A4),A0		;4ba68: 41ec82b6
	CMPI.B	#$0e,(0,A0,D0.L)	;4ba6c: 0c30000e0800
	BEQ.W	LAB_4C19C		;4ba72: 67000728
LAB_4BA76:
	MOVE.W	(8,A5),D0		;4ba76: 302d0008
	CMP.W	(_player,A4),D0		;4ba7a: b06c99f4
	BNE.S	LAB_4BAF8		;4ba7e: 6678
	PEA	(_message,A4)		;4ba80: 486c3058
	JSR	(_get_a_message,PC)	;4ba84: 4ebaa890
	ADDQ.W	#4,A7			;4ba88: 584f
	CLR.W	(-2,A5)			;4ba8a: 426dfffe
	BRA.S	LAB_4BAB0		;4ba8e: 6020
LAB_4BA90:
	CLR.L	-(A7)			;4ba90: 42a7
	MOVE.W	#$0001,-(A7)		;4ba92: 3f3c0001
	MOVE.W	(-2,A5),D0		;4ba96: 302dfffe
	EXT.L	D0			;4ba9a: 48c0
	LEA	(_message,A4),A0	;4ba9c: 41ec3058
	ADD.L	A0,D0			;4baa0: d088
	MOVE.L	D0,-(A7)		;4baa2: 2f00
	JSR	(_write_serial,PC)	;4baa4: 4eba152c
	LEA	($A,A7),A7		;4baa8: 4fef000a
	ADDQ.W	#1,(-2,A5)		;4baac: 526dfffe
LAB_4BAB0:
	MOVE.W	(-2,A5),D0		;4bab0: 302dfffe
	LEA	(_message,A4),A0	;4bab4: 41ec3058
	TST.B	(0,A0,D0.W)		;4bab8: 4a300000
	BNE.S	LAB_4BA90		;4babc: 66d2
	MOVE.W	(-2,A5),D0		;4babe: 302dfffe
	LEA	(_message,A4),A0	;4bac2: 41ec3058
	MOVE.B	#$65,(0,A0,D0.W)	;4bac6: 11bc00650000
	CLR.L	-(A7)			;4bacc: 42a7
	MOVE.W	#$0001,-(A7)		;4bace: 3f3c0001
	MOVE.W	(-2,A5),D0		;4bad2: 302dfffe
	EXT.L	D0			;4bad6: 48c0
	LEA	(_message,A4),A0	;4bad8: 41ec3058
	ADD.L	A0,D0			;4badc: d088
	MOVE.L	D0,-(A7)		;4bade: 2f00
	JSR	(_write_serial,PC)	;4bae0: 4eba14f0
	LEA	($A,A7),A7		;4bae4: 4fef000a
	MOVE.W	(-2,A5),D0		;4bae8: 302dfffe
	LEA	(_message,A4),A0	;4baec: 41ec3058
	CLR.B	(0,A0,D0.W)		;4baf0: 42300000
	BRA.W	LAB_4BC34		;4baf4: 6000013e
LAB_4BAF8:
	CLR.L	-(A7)			;4baf8: 42a7
	PEA	(_end_ok,A4)		;4bafa: 486c84c6
	MOVE.W	#$0050,-(A7)		;4bafe: 3f3c0050
	MOVE.W	#$0100,-(A7)		;4bb02: 3f3c0100
	MOVE.W	#$003c,-(A7)		;4bb06: 3f3c003c
	MOVE.W	#$0028,-(A7)		;4bb0a: 3f3c0028
	MOVE.L	(_d_screen,A4),-(A7)	;4bb0e: 2f2c99ec
	JSR	(_requester,PC)		;4bb12: 4eba9970
	LEA	($14,A7),A7		;4bb16: 4fef0014
	MOVE.W	(_not_player,A4),D0	;4bb1a: 302c825a
	ADDQ.W	#1,D0			;4bb1e: 5240
	EXT.L	D0			;4bb20: 48c0
	ASL.L	#2,D0			;4bb22: e580
	LEA	(_g_text,A4),A0		;4bb24: 41ec87aa
	MOVE.L	(0,A0,D0.L),-(A7)	;4bb28: 2f300800
	MOVE.W	#$004c,-(A7)		;4bb2c: 3f3c004c
	MOVE.W	(_not_player,A4),D0	;4bb30: 302c825a
	ADDQ.W	#1,D0			;4bb34: 5240
	EXT.L	D0			;4bb36: 48c0
	ASL.L	#2,D0			;4bb38: e580
	LEA	(_g_text,A4),A0		;4bb3a: 41ec87aa
	MOVE.L	(0,A0,D0.L),-(A7)	;4bb3e: 2f300800
	JSR	(___strlen,A4)		;4bb42: 4eac81a6
	ADDQ.W	#4,A7			;4bb46: 584f
	ASL.W	#3,D0			;4bb48: e740
	EXT.L	D0			;4bb4a: 48c0
	DIVS	#$0002,D0		;4bb4c: 81fc0002
	MOVE.W	#$00a8,D1		;4bb50: 323c00a8
	SUB.W	D0,D1			;4bb54: 9240
	MOVE.W	D1,-(A7)		;4bb56: 3f01
	MOVE.L	(_d_screen,A4),-(A7)	;4bb58: 2f2c99ec
	JSR	(___text,A4)		;4bb5c: 4eac813a
	LEA	($C,A7),A7		;4bb60: 4fef000c
	CLR.W	(-2,A5)			;4bb64: 426dfffe
LAB_4BB68:
	PEA	$1B.W			;4bb68: 4878001b
	MOVE.W	#$0001,-(A7)		;4bb6c: 3f3c0001
	MOVE.W	(-2,A5),D0		;4bb70: 302dfffe
	EXT.L	D0			;4bb74: 48c0
	LEA	(_message,A4),A0	;4bb76: 41ec3058
	ADD.L	A0,D0			;4bb7a: d088
	MOVE.L	D0,-(A7)		;4bb7c: 2f00
	JSR	(_read_serial,PC)	;4bb7e: 4eba1390
	LEA	($A,A7),A7		;4bb82: 4fef000a
	TST.W	D0			;4bb86: 4a40
	BEQ.S	LAB_4BB9A		;4bb88: 6710
	MOVE.L	(LAB_51BCC,A4),-(A7)	;4bb8a: 2f2c87de
	JSR	(_serial_message,PC)	;4bb8e: 4ebaa810
	ADDQ.W	#4,A7			;4bb92: 584f
	MOVEQ	#1,D0			;4bb94: 7001
LAB_4BB96:
	UNLK	A5			;4bb96: 4e5d
	RTS				;4bb98: 4e75
LAB_4BB9A:
	MOVE.W	(-2,A5),D0		;4bb9a: 302dfffe
	LEA	(_message,A4),A0	;4bb9e: 41ec3058
	CMPI.B	#$65,(0,A0,D0.W)	;4bba2: 0c3000650000
	BEQ.S	LAB_4BBF0		;4bba8: 6746
	MOVE.W	(-2,A5),D0		;4bbaa: 302dfffe
	ADDQ.W	#1,D0			;4bbae: 5240
	LEA	(_message,A4),A0	;4bbb0: 41ec3058
	CLR.B	(0,A0,D0.W)		;4bbb4: 42300000
	MOVE.W	(-2,A5),D0		;4bbb8: 302dfffe
	EXT.L	D0			;4bbbc: 48c0
	LEA	(_message,A4),A0	;4bbbe: 41ec3058
	ADD.L	A0,D0			;4bbc2: d088
	MOVE.L	D0,-(A7)		;4bbc4: 2f00
	MOVE.W	#$0064,-(A7)		;4bbc6: 3f3c0064
	MOVE.W	(-2,A5),D0		;4bbca: 302dfffe
	ASL.W	#3,D0			;4bbce: e740
	ADD.W	#$0030,D0		;4bbd0: d07c0030
	MOVE.W	D0,-(A7)		;4bbd4: 3f00
	MOVE.L	(_d_screen,A4),-(A7)	;4bbd6: 2f2c99ec
	JSR	(___text,A4)		;4bbda: 4eac813a
	LEA	($C,A7),A7		;4bbde: 4fef000c
	ADDQ.W	#1,(-2,A5)		;4bbe2: 526dfffe
	CMPI.W	#$0064,(-2,A5)		;4bbe6: 0c6d0064fffe
	BLT.W	LAB_4BB68		;4bbec: 6d00ff7a
LAB_4BBF0:
	TST.W	(-2,A5)			;4bbf0: 4a6dfffe
	BEQ.S	enter_4BC2A		;4bbf4: 6734
	MOVE.W	#$0002,(_left_button,A4) ;4bbf6: 397c0002ae62
mousewait_4BBFC:
	TST.W	(_left_button,A4)	;4bbfc: 4a6cae62
	BEQ.S	LAB_4BC04		;4bc00: 6702
	BRA.S	mousewait_4BBFC		;4bc02: 60f8
LAB_4BC04:
	CLR.L	-(A7)			;4bc04: 42a7
	PEA	(_end_ok,A4)		;4bc06: 486c84c6
	JSR	(_check_cancel,PC)	;4bc0a: 4ebab344
	ADDQ.W	#8,A7			;4bc0e: 504f
	TST.W	D0			;4bc10: 4a40
	BNE.S	enter_4BC2A		;4bc12: 6616
; $77=Enter, $79=Numpad enter
	JSR	(___keyboard,A4)	;4bc14: 4eac80f2
	CMPI.B	#$77,(_inkey,A4)	;4bc18: 0c2c0077ae6c
	BEQ.S	enter_4BC2A		;4bc1e: 670a
	CMPI.B	#$79,(_inkey,A4)	;4bc20: 0c2c0079ae6c
	BEQ.S	enter_4BC2A		;4bc26: 6702
	BRA.S	LAB_4BBF0		;4bc28: 60c6
enter_4BC2A:
	MOVE.W	#$0002,(_left_button,A4) ;4bc2a: 397c0002ae62
	CLR.B	(_message,A4)		;4bc30: 422c3058
LAB_4BC34:
	BRA.W	LAB_4C19C		;4bc34: 60000566
LAB_4BC38:
	MOVE.W	(8,A5),-(A7)		;4bc38: 3f2d0008
	JSR	(_do_war,PC)		;4bc3c: 4eba86f0
	ADDQ.W	#2,A7			;4bc40: 544f
	BRA.W	LAB_4C19C		;4bc42: 60000558
LAB_4BC46:
	MOVE.W	(8,A5),-(A7)		;4bc46: 3f2d0008
	JSR	(___do_flood,A4)	;4bc4a: 4eac8068
	ADDQ.W	#2,A7			;4bc4e: 544f
	BRA.W	LAB_4C19C		;4bc50: 6000054a
LAB_4BC54:
	MOVE.W	(8,A5),-(A7)		;4bc54: 3f2d0008
	JSR	(_do_knight,PC)		;4bc58: 4eba85d0
	ADDQ.W	#2,A7			;4bc5c: 544f
	BRA.W	LAB_4C19C		;4bc5e: 6000053c
LAB_4BC62:
	MOVE.W	#$17e4,-(A7)		;4bc62: 3f3c17e4
	MOVE.W	#$0003,-(A7)		;4bc66: 3f3c0003
	MOVE.W	#$0001,-(A7)		;4bc6a: 3f3c0001
	MOVE.L	(_back_scr,A4),-(A7)	;4bc6e: 2f2c9874
	JSR	(___toggle_icon,A4)	;4bc72: 4eac8122
	LEA	($A,A7),A7		;4bc76: 4fef000a
	TST.W	(_pause,A4)		;4bc7a: 4a6c9c22
	BNE.S	LAB_4BC88		;4bc7e: 6608
	MOVE.W	#$0001,(_pause,A4)	;4bc80: 397c00019c22
	BRA.S	LAB_4BC8C		;4bc86: 6004
LAB_4BC88:
	CLR.W	(_pause,A4)		;4bc88: 426c9c22
LAB_4BC8C:
	CLR.W	(_toggle,A4)		;4bc8c: 426c9a1a
	BRA.W	LAB_4C19C		;4bc90: 6000050a
LAB_4BC94:
	TST.W	(8,A5)			;4bc94: 4a6d0008
	BNE.S	LAB_4BC9E		;4bc98: 6604
	MOVEQ	#1,D0			;4bc9a: 7001
	BRA.S	LAB_4BCA0		;4bc9c: 6002
LAB_4BC9E:
	MOVEQ	#0,D0			;4bc9e: 7000
LAB_4BCA0:
	MULS	#$002e,D0		;4bca0: c1fc002e
	LEA	(LAB_516A6,A4),A0	;4bca4: 41ec82b8
	CMPI.B	#$07,(0,A0,D0.L)	;4bca8: 0c3000070800
	BNE.S	LAB_4BCCE		;4bcae: 661e
	TST.W	(8,A5)			;4bcb0: 4a6d0008
	BNE.S	LAB_4BCBA		;4bcb4: 6604
	MOVEQ	#1,D0			;4bcb6: 7001
	BRA.S	LAB_4BCBC		;4bcb8: 6002
LAB_4BCBA:
	MOVEQ	#0,D0			;4bcba: 7000
LAB_4BCBC:
	MULS	#$002e,D0		;4bcbc: c1fc002e
	LEA	(_stats,A4),A0		;4bcc0: 41ec82b6
	CMPI.B	#$0e,(0,A0,D0.L)	;4bcc4: 0c30000e0800
	BEQ.W	LAB_4C19C		;4bcca: 670004d0
LAB_4BCCE:
	MOVE.W	(_player,A4),D0		;4bcce: 302c99f4
	CMP.W	(8,A5),D0		;4bcd2: b06d0008
	BNE.W	LAB_4BD5A		;4bcd6: 66000082
	TST.W	($A,A5)			;4bcda: 4a6d000a
	BEQ.S	LAB_4BCF2		;4bcde: 6712
	MOVE.W	(_player,A4),-(A7)	;4bce0: 3f2c99f4
	JSR	(_options,PC)		;4bce4: 4ebac4a2
	ADDQ.W	#2,A7			;4bce8: 544f
	MOVE.W	(_player,A4),(-2,A5)	;4bcea: 3b6c99f4fffe
	BRA.S	LAB_4BD02		;4bcf0: 6010
LAB_4BCF2:
	MOVE.W	(_not_player,A4),-(A7)	;4bcf2: 3f2c825a
	JSR	(_options,PC)		;4bcf6: 4ebac490
	ADDQ.W	#2,A7			;4bcfa: 544f
	MOVE.W	(_not_player,A4),(-2,A5) ;4bcfc: 3b6c825afffe
LAB_4BD02:
	TST.W	(_serial_off,A4)	;4bd02: 4a6c8254
	BNE.S	LAB_4BD56		;4bd06: 664e
	MOVE.W	(-2,A5),D0		;4bd08: 302dfffe
	MULS	#$002e,D0		;4bd0c: c1fc002e
	LEA	(LAB_516B2,A4),A0	;4bd10: 41ec82c4
	MOVE.W	(0,A0,D0.L),(_message,A4) ;4bd14: 397008003058
	MOVE.B	(-1,A5),(LAB_5C448,A4)	;4bd1a: 196dffff305a
	MOVE.W	(-2,A5),D0		;4bd20: 302dfffe
	MULS	#$002e,D0		;4bd24: c1fc002e
	LEA	(LAB_516B0,A4),A0	;4bd28: 41ec82c2
	MOVE.B	(1,A0,D0.L),(LAB_5C449,A4) ;4bd2c: 19700801305b
	MOVE.W	(-2,A5),D0		;4bd32: 302dfffe
	MULS	#$002e,D0		;4bd36: c1fc002e
	LEA	(LAB_516B4,A4),A0	;4bd3a: 41ec82c6
	MOVE.B	(1,A0,D0.L),(LAB_5C44A,A4) ;4bd3e: 19700801305c
	CLR.L	-(A7)			;4bd44: 42a7
	MOVE.W	#$0005,-(A7)		;4bd46: 3f3c0005
	PEA	(_message,A4)		;4bd4a: 486c3058
	JSR	(_write_serial,PC)	;4bd4e: 4eba1282
	LEA	($A,A7),A7		;4bd52: 4fef000a
LAB_4BD56:
	BRA.W	LAB_4BE0E		;4bd56: 600000b6
LAB_4BD5A:
	TST.W	(_serial_off,A4)	;4bd5a: 4a6c8254
	BNE.W	LAB_4BE0E		;4bd5e: 660000ae
	PEA	$1B.W			;4bd62: 4878001b
	MOVE.W	#$0005,-(A7)		;4bd66: 3f3c0005
	PEA	(_message,A4)		;4bd6a: 486c3058
	JSR	(_read_serial,PC)	;4bd6e: 4eba11a0
	LEA	($A,A7),A7		;4bd72: 4fef000a
	TST.W	D0			;4bd76: 4a40
	BEQ.S	LAB_4BD8A		;4bd78: 6710
	MOVE.L	(LAB_51BCC,A4),-(A7)	;4bd7a: 2f2c87de
	JSR	(_serial_message,PC)	;4bd7e: 4ebaa620
	ADDQ.W	#4,A7			;4bd82: 584f
	MOVEQ	#1,D0			;4bd84: 7001
	BRA.W	LAB_4BB96		;4bd86: 6000fe0e
LAB_4BD8A:
	MOVEQ	#0,D0			;4bd8a: 7000
	MOVE.B	(LAB_5C448,A4),D0	;4bd8c: 102c305a
	MOVE.W	D0,(-2,A5)		;4bd90: 3b40fffe
	MOVE.W	(-2,A5),D0		;4bd94: 302dfffe
	MULS	#$002e,D0		;4bd98: c1fc002e
	LEA	(LAB_516B2,A4),A0	;4bd9c: 41ec82c4
	MOVE.W	(0,A0,D0.L),D1		;4bda0: 32300800
	CMP.W	(_message,A4),D1	;4bda4: b26c3058
	BEQ.S	LAB_4BDD0		;4bda8: 6726
	CLR.W	-(A7)			;4bdaa: 4267
	MOVE.W	(-2,A5),D0		;4bdac: 302dfffe
	CMP.W	(_player,A4),D0		;4bdb0: b06c99f4
	BNE.S	LAB_4BDBA		;4bdb4: 6604
	MOVEQ	#1,D0			;4bdb6: 7001
	BRA.S	LAB_4BDBC		;4bdb8: 6002
LAB_4BDBA:
	MOVEQ	#0,D0			;4bdba: 7000
LAB_4BDBC:
	ADDQ.W	#8,D0			;4bdbc: 5040
	EXT.L	D0			;4bdbe: 48c0
	ASL.L	#2,D0			;4bdc0: e580
	LEA	(_g_text,A4),A0		;4bdc2: 41ec87aa
	MOVE.L	(0,A0,D0.L),-(A7)	;4bdc6: 2f300800
	JSR	(_do_message,PC)	;4bdca: 4ebaa4c6
	ADDQ.W	#6,A7			;4bdce: 5c4f
LAB_4BDD0:
	MOVE.W	(-2,A5),D0		;4bdd0: 302dfffe
	MULS	#$002e,D0		;4bdd4: c1fc002e
	LEA	(LAB_516B2,A4),A0	;4bdd8: 41ec82c4
	MOVE.W	(_message,A4),(0,A0,D0.L) ;4bddc: 31ac30580800
	MOVEQ	#0,D0			;4bde2: 7000
	MOVE.B	(LAB_5C449,A4),D0	;4bde4: 102c305b
	MOVE.W	(-2,A5),D1		;4bde8: 322dfffe
	MULS	#$002e,D1		;4bdec: c3fc002e
	LEA	(LAB_516B0,A4),A0	;4bdf0: 41ec82c2
	MOVE.W	D0,(0,A0,D1.L)		;4bdf4: 31801800
	MOVEQ	#0,D0			;4bdf8: 7000
	MOVE.B	(LAB_5C44A,A4),D0	;4bdfa: 102c305c
	MOVE.W	(-2,A5),D1		;4bdfe: 322dfffe
	MULS	#$002e,D1		;4be02: c3fc002e
	LEA	(LAB_516B4,A4),A0	;4be06: 41ec82c6
	MOVE.W	D0,(0,A0,D1.L)		;4be0a: 31801800
LAB_4BE0E:
	BRA.W	LAB_4C19C		;4be0e: 6000038c
LAB_4BE12:
	MOVE.W	(8,A5),D0		;4be12: 302d0008
	CMP.W	(_player,A4),D0		;4be16: b06c99f4
	BNE.S	LAB_4BE88		;4be1a: 666c
	CLR.W	(_new_map,A4)		;4be1c: 426c309a
	MOVE.W	(_serial_off,A4),(-2,A5) ;4be20: 3b6c8254fffe
	JSR	(_game_options,PC)	;4be26: 4ebab8fa
	TST.W	(-2,A5)			;4be2a: 4a6dfffe
	BNE.S	LAB_4BE84		;4be2e: 6654
	MOVE.W	(_game_mode,A4),(_message,A4) ;4be30: 396c84b83058
	MOVE.B	(LAB_51643,A4),(LAB_5C448,A4) ;4be36: 196c8255305a
	MOVE.B	(LAB_53013,A4),(LAB_5C449,A4) ;4be3c: 196c9c25305b
	MOVE.B	(LAB_52DE3,A4),(LAB_5C44A,A4) ;4be42: 196c99f5305c
	MOVE.B	(LAB_516AB,A4),(LAB_5C44B,A4) ;4be48: 196c82bd305d
	MOVE.B	(LAB_516D9,A4),(LAB_5C44C,A4) ;4be4e: 196c82eb305e
	MOVE.B	(LAB_5C489,A4),(LAB_5C44D,A4) ;4be54: 196c309b305f
	MOVE.B	(LAB_51647,A4),(LAB_5C44E,A4) ;4be5a: 196c82593060
	MOVE.B	(LAB_5C443,A4),(LAB_5C44F,A4) ;4be60: 196c30553061
	MOVE.B	(LAB_51643,A4),(LAB_5C450,A4) ;4be66: 196c82553062
	MOVE.B	(LAB_5C46F,A4),(LAB_5C451,A4) ;4be6c: 196c30813063
	CLR.L	-(A7)			;4be72: 42a7
	MOVE.W	#$000c,-(A7)		;4be74: 3f3c000c
	PEA	(_message,A4)		;4be78: 486c3058
	JSR	(_write_serial,PC)	;4be7c: 4eba1154
	LEA	($A,A7),A7		;4be80: 4fef000a
LAB_4BE84:
	BRA.W	LAB_4C070		;4be84: 600001ea
LAB_4BE88:
	TST.W	(_serial_off,A4)	;4be88: 4a6c8254
	BNE.W	LAB_4C070		;4be8c: 660001e2
	PEA	$1B.W			;4be90: 4878001b
	MOVE.W	#$000c,-(A7)		;4be94: 3f3c000c
	PEA	(_message,A4)		;4be98: 486c3058
	JSR	(_read_serial,PC)	;4be9c: 4eba1072
	LEA	($A,A7),A7		;4bea0: 4fef000a
	TST.W	D0			;4bea4: 4a40
	BEQ.S	LAB_4BEB6		;4bea6: 670e
	MOVE.L	(LAB_51BCC,A4),-(A7)	;4bea8: 2f2c87de
	JSR	(_serial_message,PC)	;4beac: 4ebaa4f2
	ADDQ.W	#4,A7			;4beb0: 584f
	BRA.W	LAB_4BB96		;4beb2: 6000fce2
LAB_4BEB6:
	MOVE.W	(_game_mode,A4),D0	;4beb6: 302c84b8
	CMP.W	(_message,A4),D0	;4beba: b06c3058
	BEQ.S	LAB_4BECC		;4bebe: 670c
	CLR.W	-(A7)			;4bec0: 4267
	MOVE.L	(LAB_51BAC,A4),-(A7)	;4bec2: 2f2c87be
	JSR	(_do_message,PC)	;4bec6: 4ebaa3ca
	ADDQ.W	#6,A7			;4beca: 5c4f
LAB_4BECC:
	MOVE.W	(_message,A4),(_game_mode,A4) ;4becc: 396c305884b8
	TST.W	(_paint_map,A4)		;4bed2: 4a6c9c24
	BNE.S	LAB_4BEEA		;4bed6: 6612
	TST.B	(LAB_5C449,A4)		;4bed8: 4a2c305b
	BEQ.S	LAB_4BEEA		;4bedc: 670c
	CLR.W	-(A7)			;4bede: 4267
	MOVE.L	(LAB_51BB0,A4),-(A7)	;4bee0: 2f2c87c2
	JSR	(_do_message,PC)	;4bee4: 4ebaa3ac
	ADDQ.W	#6,A7			;4bee8: 5c4f
LAB_4BEEA:
	MOVEQ	#0,D0			;4beea: 7000
	MOVE.B	(LAB_5C448,A4),D0	;4beec: 102c305a
	CMP.W	(_serial_off,A4),D0	;4bef0: b06c8254
	BEQ.S	LAB_4BF04		;4bef4: 670e
	CLR.W	-(A7)			;4bef6: 4267
	MOVE.L	(LAB_51BC8,A4),-(A7)	;4bef8: 2f2c87da
	JSR	(_do_message,PC)	;4befc: 4ebaa394
	ADDQ.W	#6,A7			;4bf00: 5c4f
	BRA.S	LAB_4BF60		;4bf02: 605c
LAB_4BF04:
	MOVEQ	#0,D0			;4bf04: 7000
	MOVE.B	(LAB_5C44B,A4),D0	;4bf06: 102c305d
	CMP.W	(LAB_516AA,A4),D0	;4bf0a: b06c82bc
	BEQ.S	LAB_4BF32		;4bf0e: 6722
	CMPI.B	#$01,(LAB_5C44B,A4)	;4bf10: 0c2c0001305d
	BNE.S	LAB_4BF26		;4bf16: 660e
	CLR.W	-(A7)			;4bf18: 4267
	MOVE.L	(LAB_51BC0,A4),-(A7)	;4bf1a: 2f2c87d2
	JSR	(_do_message,PC)	;4bf1e: 4ebaa372
	ADDQ.W	#6,A7			;4bf22: 5c4f
	BRA.S	LAB_4BF32		;4bf24: 600c
LAB_4BF26:
	CLR.W	-(A7)			;4bf26: 4267
	MOVE.L	(LAB_51BC4,A4),-(A7)	;4bf28: 2f2c87d6
	JSR	(_do_message,PC)	;4bf2c: 4ebaa364
	ADDQ.W	#6,A7			;4bf30: 5c4f
LAB_4BF32:
	MOVEQ	#0,D0			;4bf32: 7000
	MOVE.B	(LAB_5C44C,A4),D0	;4bf34: 102c305e
	CMP.W	(LAB_516D8,A4),D0	;4bf38: b06c82ea
	BEQ.S	LAB_4BF60		;4bf3c: 6722
	CMPI.B	#$01,(LAB_5C44C,A4)	;4bf3e: 0c2c0001305e
	BNE.S	LAB_4BF54		;4bf44: 660e
	CLR.W	-(A7)			;4bf46: 4267
	MOVE.L	(LAB_51BC0,A4),-(A7)	;4bf48: 2f2c87d2
	JSR	(_do_message,PC)	;4bf4c: 4ebaa344
	ADDQ.W	#6,A7			;4bf50: 5c4f
	BRA.S	LAB_4BF60		;4bf52: 600c
LAB_4BF54:
	CLR.W	-(A7)			;4bf54: 4267
	MOVE.L	(LAB_51BC4,A4),-(A7)	;4bf56: 2f2c87d6
	JSR	(_do_message,PC)	;4bf5a: 4ebaa336
	ADDQ.W	#6,A7			;4bf5e: 5c4f
LAB_4BF60:
	MOVEQ	#0,D0			;4bf60: 7000
	MOVE.B	(LAB_5C448,A4),D0	;4bf62: 102c305a
	MOVE.W	D0,(_serial_off,A4)	;4bf66: 39408254
	MOVEQ	#0,D0			;4bf6a: 7000
	MOVE.B	(LAB_5C449,A4),D0	;4bf6c: 102c305b
	MOVE.W	D0,(_paint_map,A4)	;4bf70: 39409c24
	MOVEQ	#0,D0			;4bf74: 7000
	MOVE.B	(LAB_5C44A,A4),D0	;4bf76: 102c305c
	CMP.W	(_not_player,A4),D0	;4bf7a: b06c825a
	BEQ.S	LAB_4BFA2		;4bf7e: 6722
	CLR.W	-(A7)			;4bf80: 4267
	MOVE.L	(LAB_51BB4,A4),-(A7)	;4bf82: 2f2c87c6
	JSR	(_do_message,PC)	;4bf86: 4ebaa30a
	ADDQ.W	#6,A7			;4bf8a: 5c4f
	CMPI.W	#$0002,(_mode,A4)	;4bf8c: 0c6c00028256
	BNE.S	LAB_4BFA2		;4bf92: 660e
	MOVE.W	(_not_player,A4),D0	;4bf94: 302c825a
	MULS	#$0003,D0		;4bf98: c1fc0003
	ADDQ.W	#1,D0			;4bf9c: 5240
	MOVE.W	D0,(_pointer,A4)	;4bf9e: 394084b6
LAB_4BFA2:
	MOVEQ	#0,D0			;4bfa2: 7000
	MOVE.B	(LAB_5C44A,A4),D0	;4bfa4: 102c305c
	MOVE.W	D0,(_not_player,A4)	;4bfa8: 3940825a
	TST.W	(_not_player,A4)	;4bfac: 4a6c825a
	BNE.S	LAB_4BFBA		;4bfb0: 6608
	MOVE.W	#$0001,(_player,A4)	;4bfb2: 397c000199f4
	BRA.S	LAB_4BFBE		;4bfb8: 6004
LAB_4BFBA:
	CLR.W	(_player,A4)		;4bfba: 426c99f4
LAB_4BFBE:
	MOVEQ	#0,D0			;4bfbe: 7000
	MOVE.B	(LAB_5C44B,A4),D0	;4bfc0: 102c305d
	MOVE.W	D0,(LAB_516AA,A4)	;4bfc4: 394082bc
	MOVEQ	#0,D0			;4bfc8: 7000
	MOVE.B	(LAB_5C44C,A4),D0	;4bfca: 102c305e
	MOVE.W	D0,(LAB_516D8,A4)	;4bfce: 394082ea
	MOVEQ	#0,D0			;4bfd2: 7000
	MOVE.B	(LAB_5C44D,A4),D0	;4bfd4: 102c305f
	MOVE.W	D0,(_new_map,A4)	;4bfd8: 3940309a
	MOVEQ	#0,D0			;4bfdc: 7000
	MOVE.B	(LAB_5C44E,A4),D0	;4bfde: 102c3060
	MOVE.W	D0,(_surender,A4)	;4bfe2: 39408258
	MOVEQ	#0,D0			;4bfe6: 7000
	MOVE.B	(LAB_5C450,A4),D0	;4bfe8: 102c3062
	MOVE.W	D0,(_serial_off,A4)	;4bfec: 39408254
	MOVEQ	#0,D0			;4bff0: 7000
	MOVE.B	(LAB_5C451,A4),D0	;4bff2: 102c3063
	MOVE.W	D0,(_bring_up_two,A4)	;4bff6: 39403080
	TST.B	(LAB_5C44F,A4)		;4bffa: 4a2c3061
	BEQ.S	LAB_4C070		;4bffe: 6770
	PEA	(_end_cancel,A4)	;4c000: 486c84f4
	PEA	(_end_ok,A4)		;4c004: 486c84c6
	MOVE.W	#$0050,-(A7)		;4c008: 3f3c0050
	MOVE.W	#$0100,-(A7)		;4c00c: 3f3c0100
	MOVE.W	#$003c,-(A7)		;4c010: 3f3c003c
	MOVE.W	#$0020,-(A7)		;4c014: 3f3c0020
	MOVE.L	(_d_screen,A4),-(A7)	;4c018: 2f2c99ec
	JSR	(_requester,PC)		;4c01c: 4eba9466
	LEA	($14,A7),A7		;4c020: 4fef0014
	MOVE.L	(LAB_51BA8,A4),-(A7)	;4c024: 2f2c87ba
	MOVE.W	#$004c,-(A7)		;4c028: 3f3c004c
	MOVE.W	#$0030,-(A7)		;4c02c: 3f3c0030
	MOVE.L	(_d_screen,A4),-(A7)	;4c030: 2f2c99ec
	JSR	(___text,A4)		;4c034: 4eac813a
	LEA	($C,A7),A7		;4c038: 4fef000c
LAB_4C03C:
	MOVE.W	#$0002,(_left_button,A4) ;4c03c: 397c0002ae62
LAB_4C042:
	TST.W	(_left_button,A4)	;4c042: 4a6cae62
	BEQ.S	LAB_4C04A		;4c046: 6702
	BRA.S	LAB_4C042		;4c048: 60f8
LAB_4C04A:
	PEA	(_end_cancel,A4)	;4c04a: 486c84f4
	PEA	(_end_ok,A4)		;4c04e: 486c84c6
	JSR	(_check_cancel,PC)	;4c052: 4ebaaefc
	ADDQ.W	#8,A7			;4c056: 504f
	MOVE.W	D0,(-2,A5)		;4c058: 3b40fffe
	BEQ.S	LAB_4C03C		;4c05c: 67de
	CMPI.W	#$0001,(-2,A5)		;4c05e: 0c6d0001fffe
	BNE.S	LAB_4C070		;4c064: 660a
	MOVE.W	#$0001,-(A7)		;4c066: 3f3c0001
	JSR	(_save_load,PC)		;4c06a: 4eba9aac
	ADDQ.W	#2,A7			;4c06e: 544f
LAB_4C070:
	TST.W	(_new_map,A4)		;4c070: 4a6c309a
	BEQ.S	LAB_4C09A		;4c074: 6724
	CMPI.W	#$0001,(_new_map,A4)	;4c076: 0c6c0001309a
	BEQ.S	LAB_4C084		;4c07c: 6706
	MOVE.W	(_start_seed,A4),(_seed,A4) ;4c07e: 396c99e499e2
LAB_4C084:
	MOVE.W	(_new_map,A4),D0	;4c084: 302c309a
	SUBQ.W	#2,D0			;4c088: 5540
	MOVE.W	D0,-(A7)		;4c08a: 3f00
	CLR.W	-(A7)			;4c08c: 4267
	JSR	(___setup_display,A4)	;4c08e: 4eac801a
	ADDQ.W	#4,A7			;4c092: 584f
	MOVEQ	#1,D0			;4c094: 7001
	BRA.W	LAB_4BB96		;4c096: 6000fafe
LAB_4C09A:
	TST.W	(_bring_up_two,A4)	;4c09a: 4a6c3080
	BEQ.S	LAB_4C0B4		;4c09e: 6714
	MOVE.W	#$0001,-(A7)		;4c0a0: 3f3c0001
	JSR	(_two_players,PC)	;4c0a4: 4ebaa402
	ADDQ.W	#2,A7			;4c0a8: 544f
	JSR	(___return_to_game,A4)	;4c0aa: 4eac8086
	MOVEQ	#1,D0			;4c0ae: 7001
	BRA.W	LAB_4BB96		;4c0b0: 6000fae4
LAB_4C0B4:
	BRA.W	LAB_4C19C		;4c0b4: 600000e6
LAB_4C0B8:
	TST.W	($A,A5)			;4c0b8: 4a6d000a
	BEQ.S	LAB_4C0CE		;4c0bc: 6710
	MOVEQ	#2,D1			;4c0be: 7202
	MOVE.L	(LAB_52DF0,A4),D0	;4c0c0: 202c9a02
	JSR	(___divs,A4)		;4c0c4: 4eac81ca
	MOVE.L	D0,(LAB_52DF0,A4)	;4c0c8: 29409a02
	BRA.S	LAB_4C0E8		;4c0cc: 601a
LAB_4C0CE:
	CMPI.L	#$000186a0,(LAB_52DF0,A4) ;4c0ce: 0cac000186a09a02
	BGE.S	LAB_4C0E8		;4c0d6: 6c10
	MOVE.L	(LAB_52DF0,A4),D0	;4c0d8: 202c9a02
	ASL.L	#1,D0			;4c0dc: e380
	ADD.L	#$000001f4,D0		;4c0de: d0bc000001f4
	MOVE.L	D0,(LAB_52DF0,A4)	;4c0e4: 29409a02
LAB_4C0E8:
	BRA.W	LAB_4C19C		;4c0e8: 600000b2
LAB_4C0EC:
	TST.W	($A,A5)			;4c0ec: 4a6d000a
	BEQ.S	LAB_4C102		;4c0f0: 6710
	MOVEQ	#2,D1			;4c0f2: 7202
	MOVE.L	(LAB_52E00,A4),D0	;4c0f4: 202c9a12
	JSR	(___divs,A4)		;4c0f8: 4eac81ca
	MOVE.L	D0,(LAB_52E00,A4)	;4c0fc: 29409a12
	BRA.S	LAB_4C11C		;4c100: 601a
LAB_4C102:
	CMPI.L	#$000186a0,(LAB_52E00,A4) ;4c102: 0cac000186a09a12
	BGE.S	LAB_4C11C		;4c10a: 6c10
	MOVE.L	(LAB_52E00,A4),D0	;4c10c: 202c9a12
	ASL.L	#1,D0			;4c110: e380
	ADD.L	#$000001f4,D0		;4c112: d0bc000001f4
	MOVE.L	D0,(LAB_52E00,A4)	;4c118: 29409a12
LAB_4C11C:
	BRA.S	LAB_4C19C		;4c11c: 607e
LAB_4C11E:
	JSR	(___rotate_all_map,A4)	;4c11e: 4eac804a
	BRA.S	LAB_4C19C		;4c122: 6078
LAB_4C124:
	JSR	(___clear_all_map,A4)	;4c124: 4eac8050
	BRA.S	LAB_4C19C		;4c128: 6072
LAB_4C12A:
	MOVE.W	($A,A5),(_ground_in,A4)	;4c12a: 396d000a99e6
	MOVE.W	#$0001,-(A7)		;4c130: 3f3c0001
	MOVE.W	($A,A5),-(A7)		;4c134: 3f2d000a
	JSR	(___load_ground,A4)	;4c138: 4eac80bc
	ADDQ.W	#4,A7			;4c13c: 584f
	TST.W	D0			;4c13e: 4a40
	BEQ.S	LAB_4C148		;4c140: 6706
	MOVE.W	($A,A5),(_ground_in,A4)	;4c142: 396d000a99e6
LAB_4C148:
	MOVE.W	#$003f,-(A7)		;4c148: 3f3c003f
	MOVE.W	#$003f,-(A7)		;4c14c: 3f3c003f
	CLR.W	-(A7)			;4c150: 4267
	CLR.W	-(A7)			;4c152: 4267
	JSR	(___draw_map,A4)	;4c154: 4eac8026
	ADDQ.W	#8,A7			;4c158: 504f
	BRA.S	LAB_4C19C		;4c15a: 6040
LAB_4C15C:
	MOVE.W	($A,A5),D0		;4c15c: 302d000a
	ADDQ.W	#1,D0			;4c160: 5240
	MOVE.W	D0,(_cheat,A4)		;4c162: 39402fb4
	BRA.S	LAB_4C19C		;4c166: 6034
LAB_4C168:
	BRA.S	LAB_4C19C		;4c168: 6032
LAB_4C16A:
	DC.W	(LAB_4C168)-(LAB_4C198+2) ;4c16a: ffce
	DC.W	(LAB_4B9EE)-(LAB_4C198+2) ;4c16c: f854
	DC.W	(LAB_4BA34)-(LAB_4C198+2) ;4c16e: f89a
	DC.W	(LAB_4BC38)-(LAB_4C198+2) ;4c170: fa9e
	DC.W	(LAB_4BC46)-(LAB_4C198+2) ;4c172: faac
	DC.W	(LAB_4BC54)-(LAB_4C198+2) ;4c174: faba
	DC.W	(LAB_4BC62)-(LAB_4C198+2) ;4c176: fac8
	DC.W	(LAB_4BC94)-(LAB_4C198+2) ;4c178: fafa
	DC.W	(LAB_4BE12)-(LAB_4C198+2) ;4c17a: fc78
	DC.W	(LAB_4C0B8)-(LAB_4C198+2) ;4c17c: ff1e
	DC.W	(LAB_4C0EC)-(LAB_4C198+2) ;4c17e: ff52
	DC.W	(LAB_4C11E)-(LAB_4C198+2) ;4c180: ff84
	DC.W	(LAB_4C124)-(LAB_4C198+2) ;4c182: ff8a
	DC.W	(LAB_4C12A)-(LAB_4C198+2) ;4c184: ff90
	DC.W	(LAB_4C168)-(LAB_4C198+2) ;4c186: ffce
	DC.W	(LAB_4C15C)-(LAB_4C198+2) ;4c188: ffc2
LAB_4C18A:
	CMP.L	#$00000010,D0		;4c18a: b0bc00000010
	BCC.S	LAB_4C168		;4c190: 64d6
	ASL.L	#1,D0			;4c192: e380
	MOVE.W	(LAB_4C16A,PC,D0.W),D0	;4c194: 303b00d4
LAB_4C198:
	JMP	(LAB_4C198+2,PC,D0.W)	;4c198: 4efb0000
LAB_4C19C:
	MOVEQ	#0,D0			;4c19c: 7000
	BRA.W	LAB_4BB96		;4c19e: 6000f9f6
; ------------------------------------------------------------------------------
; Key reading routine
; ------------------------------------------------------------------------------
_keyboard:
	MOVE.L	A0,-(A7)		;4c1a2: 2f08
	CLR.B	_inkey			;4c1a4: 42390005425a
	CLR.B	_asckey			;4c1aa: 42390005c418
	CLR.W	D0			;4c1b0: 4240
	MOVE.B	CIAA_SDR,D0		;4c1b2: 103900bfec01
	TST.W	keyrepeat		;4c1b8: 4a790004c21a
	BEQ.S	LAB_4C1CE		;4c1be: 670e
	BTST	#0,D0			;4c1c0: 08000000
	BNE.S	clear_4C212		;4c1c4: 664c
	CLR.W	keyrepeat		;4c1c6: 42790004c21a
	BRA.S	clear_4C212		;4c1cc: 6044
LAB_4C1CE:
	BTST	#0,D0			;4c1ce: 08000000
	BEQ.W	clear_4C212		;4c1d2: 6700003e
	MOVE.B	D0,_inkey		;4c1d6: 13c00005425a
	NEG.B	D0			;4c1dc: 4400
	LSR.B	#1,D0			;4c1de: e208
	CMP.B	#$60,D0			;4c1e0: b03c0060
	BGE.S	clear_4C212		;4c1e4: 6c2c
	LEA	keycodes,A0		;4c1e6: 41f90004c220
	TST.W	_shift			;4c1ec: 4a790005c4ee
	BEQ.S	LAB_4C1F8		;4c1f2: 6704
	ADDI.W	#$0060,D0		;4c1f4: 06400060
LAB_4C1F8:
	MOVE.B	(0,A0,D0.W),_asckey	;4c1f8: 13f000000005c418
	CLR.L	D0			;4c200: 4280
	MOVE.B	_asckey,D0		;4c202: 10390005c418
	MOVE.W	#$0001,keyrepeat	;4c208: 33fc00010004c21a
	BRA.S	LAB_4C214		;4c210: 6002
clear_4C212:
	CLR.L	D0			;4c212: 4280
LAB_4C214:
	TST.L	D0			;4c214: 4a80
	MOVEA.L	(A7)+,A0		;4c216: 205f
	RTS				;4c218: 4e75
keyrepeat:
	DS.B	1			;4c21a
_the_prot1:
; anti-piracy protection
	DS.B	1			;4c21b
	DS.L	1			;4c21c
; ------------------------------------------------------------------------------
; Keycodes $00 to $5F are Amiga keyboard codes
; Here, entries $60 to $BF are their shifted versions
; Cursor keys are $0c - $0f, F-keys are $01-$09, shifted +$10
; $45 is escape, $46 is delete
; ------------------------------------------------------------------------------
keycodes:
	;4c220
	;DC.B	$27,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$2d,$3d,$60,$00,$30
	;DC.B	$71,$77,$65,$72,$74,$79,$75,$69,$6f,$70,$5b,$5d,$00,$31,$32,$33
	;DC.B	$61,$73,$64,$66,$67,$68,$6a,$6b,$6c,$3b,$27,$23,$00,$34,$35,$36
	;DC.B	$00,$7a,$78,$63,$76,$62,$6e,$4d,$2c,$2e,$2f,$00,$2e,$37,$38,$39
	;DC.B	$20
	DC.B	"'1234567890-=`",0
	DC.B	"0qwertyuiop[]",0
	DC.B	"123asdfghjkl;'#",0
	DC.B	"456",0
	DC.B	"zxcvbnM,./",0
	DC.B	".789 "
	DC.B	$08			;4c261
	DC.L	$090d0d1b,$7f000000,$2d000c0d,$0e0f0102 ;4c262
	DC.L	$03040506,$0708090a	;4c272
	DS.L	1			;4c27a
	DC.W	$000b			;4c27e
	;4c280
	;DC.B	$5f,$21,$40,$23,$24,$25,$5f,$26,$2a,$28,$29,$7e,$2b,$7c,$00,$30
	;DC.B	$51,$57,$45,$52,$54,$59,$55,$49,$4f,$50,$7b,$7d,$00,$31,$32,$33
	;DC.B	$41,$53,$44,$46,$47,$48,$4a,$4b,$4c,$3a,$22,$23,$00,$34,$35,$36
	;DC.B	$00,$5a,$58,$43,$56,$42,$4e,$4d,$3c,$3e,$3f,$00,$2e,$37,$38,$39
	;DC.B	$20
	DC.B	"_!@#$%_&*()~+|",0
	DC.B	"0QWERTYUIOP{}",0
	DC.B	"123ASDFGHJKL:""#",0
	DC.B	"456",0
	DC.B	"ZXCVBNM<>?",0
	DC.B	".789 "
	DC.B	$08			;4c2c1
	DC.L	$090d0d1b,$7f000000,$2d001c1d,$1e1f1112 ;4c2c2
	DC.L	$13141516,$1718191a	;4c2d2
	DS.L	1			;4c2da
	DC.W	$000b			;4c2de
_prot_num4:
; more anti-piracy protection
	DC.L	$acc5ec38		;4c2e0
	DS.W	1			;4c2e4
; ------------------------------------------------------------------------------
; Random number generator
; Linear congruential generator
; Loops every 2^15 (32,768)
; ------------------------------------------------------------------------------
_newrand:
	MOVE.W	_seed,D0		;4c2e6: 303900052dd0
	MULU	#$24a1,D0		;4c2ec: c0fc24a1
	ADDI.W	#$24df,D0		;4c2f0: 064024df
	BCLR	#$F,D0			;4c2f4: 0880000f
	MOVE.W	D0,_seed		;4c2f8: 33c000052dd0
	RTS				;4c2fe: 4e75
	DS.W	1			;4c300
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_pixel:
	LINK.W	A5,#0			;4c302: 4e550000
	MOVEM.L	D0-D5/A0,-(A7)		;4c306: 48e7fc80
	MOVEA.L	(8,A5),A0		;4c30a: 206d0008
	MOVE.W	($C,A5),D0		;4c30e: 302d000c
	MOVE.W	($E,A5),D1		;4c312: 322d000e
	MOVE.W	($10,A5),D4		;4c316: 382d0010
	CMP.W	#$0140,D0		;4c31a: b07c0140
	BGE.W	LAB_4C36C		;4c31e: 6c00004c
	TST.W	D0			;4c322: 4a40
	BLT.W	LAB_4C36C		;4c324: 6d000046
	CMP.W	#$00c8,D1		;4c328: b27c00c8
	BGE.W	LAB_4C36C		;4c32c: 6c00003e
	TST.W	D1			;4c330: 4a41
	BLT.W	LAB_4C36C		;4c332: 6d000038
	MULU	#$0028,D1		;4c336: c2fc0028
	ADDA.L	D1,A0			;4c33a: d1c1
	MOVE.W	D0,D2			;4c33c: 3400
	ANDI.W	#$0007,D2		;4c33e: 02420007
	MOVE.W	#$0007,D3		;4c342: 363c0007
	SUB.W	D2,D3			;4c346: 9642
	LSR.W	#3,D0			;4c348: e648
	EXT.L	D0			;4c34a: 48c0
	ADDA.L	D0,A0			;4c34c: d1c0
	MOVE.L	#$00001f40,D2		;4c34e: 243c00001f40
	MOVE.W	#$0003,D5		;4c354: 3a3c0003
LAB_4C358:
	LSR.W	#1,D4			;4c358: e24c
	BCC.W	LAB_4C364		;4c35a: 64000008
	BSET	D3,(A0)			;4c35e: 07d0
	BRA.W	LAB_4C366		;4c360: 60000004
LAB_4C364:
	BCLR	D3,(A0)			;4c364: 0790
LAB_4C366:
	ADDA.L	D2,A0			;4c366: d1c2
	DBF	D5,LAB_4C358		;4c368: 51cdffee
LAB_4C36C:
	MOVEM.L	(A7)+,D0-D5/A0		;4c36c: 4cdf013f
	UNLK	A5			;4c370: 4e5d
	RTS				;4c372: 4e75
	DS.W	1			;4c374
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_draw_icon:
	LINK.W	A5,#0			;4c376: 4e550000
	MOVEM.L	D0-D5/A0-A1,-(A7)	;4c37a: 48e7fcc0
	MOVEA.L	(8,A5),A0		;4c37e: 206d0008
	MOVE.W	($C,A5),D0		;4c382: 302d000c
	MOVE.W	($E,A5),D1		;4c386: 322d000e
	MOVE.W	($10,A5),D4		;4c38a: 382d0010
	MULU	#$0028,D1		;4c38e: c2fc0028
	LSL.W	#1,D0			;4c392: e348
	EXT.L	D0			;4c394: 48c0
	ADDA.L	D0,A0			;4c396: d1c0
	ADDA.L	D1,A0			;4c398: d1c1
	LSL.W	#7,D4			;4c39a: ef4c
	LEA	_icon_data,A1		;4c39c: 43f90004e4c6
	ADDA.L	D4,A1			;4c3a2: d3c4
	MOVE.W	#$000f,D5		;4c3a4: 3a3c000f
LAB_4C3A8:
	MOVE.W	(A1)+,(0,A0)		;4c3a8: 31590000
	MOVE.W	(A1)+,($1F40,A0)	;4c3ac: 31591f40
	MOVE.W	(A1)+,($3E80,A0)	;4c3b0: 31593e80
	MOVE.W	(A1)+,($5DC0,A0)	;4c3b4: 31595dc0
	ADDA.L	#$00000028,A0		;4c3b8: d1fc00000028
	DBF	D5,LAB_4C3A8		;4c3be: 51cdffe8
	MOVEM.L	(A7)+,D0-D5/A0-A1	;4c3c2: 4cdf033f
	UNLK	A5			;4c3c6: 4e5d
	RTS				;4c3c8: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_draw_bar:
	LINK.W	A5,#0			;4c3ca: 4e550000
	MOVEM.L	D0-D5/A0,-(A7)		;4c3ce: 48e7fc80
	MOVEA.L	(8,A5),A0		;4c3d2: 206d0008
	MOVE.W	($C,A5),D0		;4c3d6: 302d000c
	MOVE.W	($E,A5),D1		;4c3da: 322d000e
	MOVE.W	($10,A5),D5		;4c3de: 3a2d0010
	MOVE.W	($12,A5),D4		;4c3e2: 382d0012
	MOVE.W	($14,A5),D3		;4c3e6: 362d0014
	MULU	#$0028,D1		;4c3ea: c2fc0028
	EXT.L	D0			;4c3ee: 48c0
	ADDA.L	D0,A0			;4c3f0: d1c0
	ADDA.L	D1,A0			;4c3f2: d1c1
	TST.W	D4			;4c3f4: 4a44
	BGE.W	LAB_4C3FE		;4c3f6: 6c000006
	MOVE.W	#$0000,D4		;4c3fa: 383c0000
LAB_4C3FE:
	CMP.W	D5,D4			;4c3fe: b845
	BLE.W	LAB_4C406		;4c400: 6f000004
	MOVE.W	D5,D4			;4c404: 3805
LAB_4C406:
	SUB.W	D4,D5			;4c406: 9a44
	SUBI.W	#$0001,D4		;4c408: 04440001
	BLT.W	LAB_4C414		;4c40c: 6d000006
	BSR.W	LAB_4C42E		;4c410: 6100001c
LAB_4C414:
	MOVE.W	D5,D4			;4c414: 3805
	SUBI.W	#$0001,D4		;4c416: 04440001
	BLT.W	LAB_4C426		;4c41a: 6d00000a
	MOVE.W	#$0002,D3		;4c41e: 363c0002
	BSR.W	LAB_4C42E		;4c422: 6100000a
LAB_4C426:
	MOVEM.L	(A7)+,D0-D5/A0		;4c426: 4cdf013f
	UNLK	A5			;4c42a: 4e5d
	RTS				;4c42c: 4e75
LAB_4C42E:
	BTST	#0,D3			;4c42e: 08030000
	BEQ.W	LAB_4C440		;4c432: 6700000c
	ORI.B	#$3c,(0,A0)		;4c436: 0028003c0000
	BRA.W	LAB_4C446		;4c43c: 60000008
LAB_4C440:
	ANDI.B	#$c3,(0,A0)		;4c440: 022800c30000
LAB_4C446:
	BTST	#1,D3			;4c446: 08030001
	BEQ.W	LAB_4C458		;4c44a: 6700000c
	ORI.B	#$3c,($1F40,A0)		;4c44e: 0028003c1f40
	BRA.W	LAB_4C45E		;4c454: 60000008
LAB_4C458:
	ANDI.B	#$c3,($1F40,A0)		;4c458: 022800c31f40
LAB_4C45E:
	BTST	#2,D3			;4c45e: 08030002
	BEQ.W	LAB_4C470		;4c462: 6700000c
	ORI.B	#$3c,($3E80,A0)		;4c466: 0028003c3e80
	BRA.W	LAB_4C476		;4c46c: 60000008
LAB_4C470:
	ANDI.B	#$c3,($3E80,A0)		;4c470: 022800c33e80
LAB_4C476:
	BTST	#3,D3			;4c476: 08030003
	BEQ.W	LAB_4C488		;4c47a: 6700000c
	ORI.B	#$3c,($5DC0,A0)		;4c47e: 0028003c5dc0
	BRA.W	LAB_4C48E		;4c484: 60000008
LAB_4C488:
	ANDI.B	#$c3,($5DC0,A0)		;4c488: 022800c35dc0
LAB_4C48E:
	SUBA.L	#$00000028,A0		;4c48e: 91fc00000028
	DBF	D4,LAB_4C42E		;4c494: 51ccff98
	RTS				;4c498: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_draw_sprite:
	LINK.W	A5,#0			;4c49a: 4e550000
	MOVEM.L	D0-D7/A0-A1,-(A7)	;4c49e: 48e7ffc0
	MOVEA.L	(8,A5),A0		;4c4a2: 206d0008
	MOVE.W	($C,A5),D0		;4c4a6: 302d000c
	MOVE.W	($E,A5),D1		;4c4aa: 322d000e
	MOVE.W	($10,A5),D2		;4c4ae: 342d0010
	TST.W	D1			;4c4b2: 4a41
	BMI.W	LAB_4C582		;4c4b4: 6b0000cc
	MOVE.W	#$000f,D3		;4c4b8: 363c000f
	CMP.W	#$00b8,D1		;4c4bc: b27c00b8
	BLE.W	LAB_4C4CE		;4c4c0: 6f00000c
	MOVE.W	#$00c8,D3		;4c4c4: 363c00c8
	SUB.W	D1,D3			;4c4c8: 9641
	BLE.W	LAB_4C582		;4c4ca: 6f0000b6
LAB_4C4CE:
	MOVE.L	#$00000026,D7		;4c4ce: 2e3c00000026
	CMP.W	#$0130,D0		;4c4d4: b07c0130
	BLE.W	LAB_4C4E2		;4c4d8: 6f000008
	MOVE.L	#$00000028,D7		;4c4dc: 2e3c00000028
LAB_4C4E2:
	MOVE.W	D0,D6			;4c4e2: 3c00
	MULU	#$0028,D1		;4c4e4: c2fc0028
	LSR.W	#4,D6			;4c4e8: e84e
	LSL.W	#1,D6			;4c4ea: e34e
	EXT.L	D6			;4c4ec: 48c6
	ADDA.L	D6,A0			;4c4ee: d1c6
	ADDA.L	D1,A0			;4c4f0: d1c1
	ANDI.W	#$000f,D0		;4c4f2: 0240000f
	MULU	#$00a0,D2		;4c4f6: c4fc00a0
	MOVEA.L	_sprite_data,A1		;4c4fa: 227900052c56
	ADDA.L	D2,A1			;4c500: d3c2
LAB_4C502:
	MOVE.L	#$ffffffff,D1		;4c502: 223cffffffff
	CLR.L	D2			;4c508: 4282
	CLR.L	D4			;4c50a: 4284
	CLR.L	D5			;4c50c: 4285
	CLR.L	D6			;4c50e: 4286
	MOVE.W	(A1)+,D1		;4c510: 3219
	MOVE.W	(A1)+,D2		;4c512: 3419
	MOVE.W	(A1)+,D4		;4c514: 3819
	MOVE.W	(A1)+,D5		;4c516: 3a19
	MOVE.W	(A1)+,D6		;4c518: 3c19
	ROR.L	D0,D1			;4c51a: e0b9
	ROR.L	D0,D2			;4c51c: e0ba
	ROR.L	D0,D4			;4c51e: e0bc
	ROR.L	D0,D5			;4c520: e0bd
	ROR.L	D0,D6			;4c522: e0be
	AND.W	D1,(0,A0)		;4c524: c3680000
	AND.W	D1,($1F40,A0)		;4c528: c3681f40
	AND.W	D1,($3E80,A0)		;4c52c: c3683e80
	AND.W	D1,($5DC0,A0)		;4c530: c3685dc0
	OR.W	D2,(0,A0)		;4c534: 85680000
	OR.W	D4,($1F40,A0)		;4c538: 89681f40
	OR.W	D5,($3E80,A0)		;4c53c: 8b683e80
	OR.W	D6,($5DC0,A0)		;4c540: 8d685dc0
	CMP.W	#$0028,D7		;4c544: be7c0028
	BEQ.W	LAB_4C57C		;4c548: 67000032
	SWAP	D1			;4c54c: 4841
	SWAP	D2			;4c54e: 4842
	SWAP	D4			;4c550: 4844
	SWAP	D5			;4c552: 4845
	SWAP	D6			;4c554: 4846
	ADDA.L	#$00000002,A0		;4c556: d1fc00000002
	AND.W	D1,(0,A0)		;4c55c: c3680000
	AND.W	D1,($1F40,A0)		;4c560: c3681f40
	AND.W	D1,($3E80,A0)		;4c564: c3683e80
	AND.W	D1,($5DC0,A0)		;4c568: c3685dc0
	OR.W	D2,(0,A0)		;4c56c: 85680000
	OR.W	D4,($1F40,A0)		;4c570: 89681f40
	OR.W	D5,($3E80,A0)		;4c574: 8b683e80
	OR.W	D6,($5DC0,A0)		;4c578: 8d685dc0
LAB_4C57C:
	ADDA.L	D7,A0			;4c57c: d1c7
	DBF	D3,LAB_4C502		;4c57e: 51cbff82
LAB_4C582:
	MOVEM.L	(A7)+,D0-D7/A0-A1	;4c582: 4cdf03ff
	UNLK	A5			;4c586: 4e5d
	RTS				;4c588: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_draw_s_32:
	LINK.W	A5,#0			;4c58a: 4e550000
	MOVEM.L	D0-D7/A0-A1,-(A7)	;4c58e: 48e7ffc0
	MOVEA.L	(8,A5),A0		;4c592: 206d0008
	MOVE.W	($C,A5),D0		;4c596: 302d000c
	MOVE.W	($E,A5),D1		;4c59a: 322d000e
	MOVE.W	($10,A5),D2		;4c59e: 342d0010
	TST.W	D1			;4c5a2: 4a41
	BMI.W	LAB_4C700		;4c5a4: 6b00015a
	MOVE.W	#$001f,D3		;4c5a8: 363c001f
	CMP.W	#$00a8,D1		;4c5ac: b27c00a8
	BLT.W	LAB_4C5BE		;4c5b0: 6d00000c
	MOVE.W	#$00c7,D3		;4c5b4: 363c00c7
	SUB.W	D1,D3			;4c5b8: 9641
	BLE.W	LAB_4C700		;4c5ba: 6f000144
LAB_4C5BE:
	MOVE.L	#$00000024,D7		;4c5be: 2e3c00000024
	CMP.W	#$0120,D0		;4c5c4: b07c0120
	BLE.W	LAB_4C5E0		;4c5c8: 6f000016
	MOVE.L	#$00000026,D7		;4c5cc: 2e3c00000026
	CMP.W	#$0130,D0		;4c5d2: b07c0130
	BLE.W	LAB_4C5E0		;4c5d6: 6f000008
	MOVE.L	#$00000028,D7		;4c5da: 2e3c00000028
LAB_4C5E0:
	MOVE.W	D0,D6			;4c5e0: 3c00
	MULU	#$0028,D1		;4c5e2: c2fc0028
	LSR.W	#4,D6			;4c5e6: e84e
	LSL.W	#1,D6			;4c5e8: e34e
	EXT.L	D6			;4c5ea: 48c6
	ADDA.L	D6,A0			;4c5ec: d1c6
	ADDA.L	D1,A0			;4c5ee: d1c1
	ANDI.W	#$000f,D0		;4c5f0: 0240000f
	MULU	#$0280,D2		;4c5f4: c4fc0280
	MOVEA.L	_sprite_data_32,A1	;4c5f8: 227900052c5a
	ADDA.L	D2,A1			;4c5fe: d3c2
LAB_4C600:
	MOVE.L	#$ffffffff,D1		;4c600: 223cffffffff
	CLR.L	D2			;4c606: 4282
	CLR.L	D4			;4c608: 4284
	CLR.L	D5			;4c60a: 4285
	CLR.L	D6			;4c60c: 4286
	MOVE.W	(A1)+,D1		;4c60e: 3219
	MOVE.W	(A1)+,D2		;4c610: 3419
	MOVE.W	(A1)+,D4		;4c612: 3819
	MOVE.W	(A1)+,D5		;4c614: 3a19
	MOVE.W	(A1)+,D6		;4c616: 3c19
	ROR.L	D0,D1			;4c618: e0b9
	ROR.L	D0,D2			;4c61a: e0ba
	ROR.L	D0,D4			;4c61c: e0bc
	ROR.L	D0,D5			;4c61e: e0bd
	ROR.L	D0,D6			;4c620: e0be
	AND.W	D1,(0,A0)		;4c622: c3680000
	AND.W	D1,($1F40,A0)		;4c626: c3681f40
	AND.W	D1,($3E80,A0)		;4c62a: c3683e80
	AND.W	D1,($5DC0,A0)		;4c62e: c3685dc0
	OR.W	D2,(0,A0)		;4c632: 85680000
	OR.W	D4,($1F40,A0)		;4c636: 89681f40
	OR.W	D5,($3E80,A0)		;4c63a: 8b683e80
	OR.W	D6,($5DC0,A0)		;4c63e: 8d685dc0
	CMP.W	#$0028,D7		;4c642: be7c0028
	BEQ.W	LAB_4C6F4		;4c646: 670000ac
	SWAP	D1			;4c64a: 4841
	SWAP	D2			;4c64c: 4842
	SWAP	D4			;4c64e: 4844
	SWAP	D5			;4c650: 4845
	SWAP	D6			;4c652: 4846
	ADDA.W	#$0002,A0		;4c654: d0fc0002
	AND.W	D1,(0,A0)		;4c658: c3680000
	AND.W	D1,($1F40,A0)		;4c65c: c3681f40
	AND.W	D1,($3E80,A0)		;4c660: c3683e80
	AND.W	D1,($5DC0,A0)		;4c664: c3685dc0
	OR.W	D2,(0,A0)		;4c668: 85680000
	OR.W	D4,($1F40,A0)		;4c66c: 89681f40
	OR.W	D5,($3E80,A0)		;4c670: 8b683e80
	OR.W	D6,($5DC0,A0)		;4c674: 8d685dc0
	MOVE.L	#$ffffffff,D1		;4c678: 223cffffffff
	CLR.L	D2			;4c67e: 4282
	CLR.L	D4			;4c680: 4284
	CLR.L	D5			;4c682: 4285
	CLR.L	D6			;4c684: 4286
	MOVE.W	(A1)+,D1		;4c686: 3219
	MOVE.W	(A1)+,D2		;4c688: 3419
	MOVE.W	(A1)+,D4		;4c68a: 3819
	MOVE.W	(A1)+,D5		;4c68c: 3a19
	MOVE.W	(A1)+,D6		;4c68e: 3c19
	ROR.L	D0,D1			;4c690: e0b9
	ROR.L	D0,D2			;4c692: e0ba
	ROR.L	D0,D4			;4c694: e0bc
	ROR.L	D0,D5			;4c696: e0bd
	ROR.L	D0,D6			;4c698: e0be
	AND.W	D1,(0,A0)		;4c69a: c3680000
	AND.W	D1,($1F40,A0)		;4c69e: c3681f40
	AND.W	D1,($3E80,A0)		;4c6a2: c3683e80
	AND.W	D1,($5DC0,A0)		;4c6a6: c3685dc0
	OR.W	D2,(0,A0)		;4c6aa: 85680000
	OR.W	D4,($1F40,A0)		;4c6ae: 89681f40
	OR.W	D5,($3E80,A0)		;4c6b2: 8b683e80
	OR.W	D6,($5DC0,A0)		;4c6b6: 8d685dc0
	CMP.W	#$0026,D7		;4c6ba: be7c0026
	BEQ.W	LAB_4C6FA		;4c6be: 6700003a
	SWAP	D1			;4c6c2: 4841
	SWAP	D2			;4c6c4: 4842
	SWAP	D4			;4c6c6: 4844
	SWAP	D5			;4c6c8: 4845
	SWAP	D6			;4c6ca: 4846
	ADDA.W	#$0002,A0		;4c6cc: d0fc0002
	AND.W	D1,(0,A0)		;4c6d0: c3680000
	AND.W	D1,($1F40,A0)		;4c6d4: c3681f40
	AND.W	D1,($3E80,A0)		;4c6d8: c3683e80
	AND.W	D1,($5DC0,A0)		;4c6dc: c3685dc0
	OR.W	D2,(0,A0)		;4c6e0: 85680000
	OR.W	D4,($1F40,A0)		;4c6e4: 89681f40
	OR.W	D5,($3E80,A0)		;4c6e8: 8b683e80
	OR.W	D6,($5DC0,A0)		;4c6ec: 8d685dc0
	BRA.W	LAB_4C6FA		;4c6f0: 60000008
LAB_4C6F4:
	ADDA.L	#$0000000a,A1		;4c6f4: d3fc0000000a
LAB_4C6FA:
	ADDA.L	D7,A0			;4c6fa: d1c7
	DBF	D3,LAB_4C600		;4c6fc: 51cbff02
LAB_4C700:
	MOVEM.L	(A7)+,D0-D7/A0-A1	;4c700: 4cdf03ff
	UNLK	A5			;4c704: 4e5d
	RTS				;4c706: 4e75
	DS.W	1			;4c708
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_toggle_icon:
	LINK.W	A5,#0			;4c70a: 4e550000
	MOVEM.L	D0-D3/A0-A1,-(A7)	;4c70e: 48e7f0c0
	MOVEA.L	(8,A5),A0		;4c712: 206d0008
	MOVE.W	($C,A5),D0		;4c716: 302d000c
	MOVE.W	($E,A5),D1		;4c71a: 322d000e
	MULU	#$0142,D0		;4c71e: c0fc0142
	MULU	#$013e,D1		;4c722: c2fc013e
	ADD.W	D0,D1			;4c726: d240
	ADD.W	($10,A5),D1		;4c728: d26d0010
	EXT.L	D1			;4c72c: 48c1
	ADDA.L	D1,A0			;4c72e: d1c1
	MOVE.W	#$000f,D2		;4c730: 343c000f
	LEA	LAB_4C750,A1		;4c734: 43f90004c750
LAB_4C73A:
	MOVE.L	(A1)+,D3		;4c73a: 2619
	EOR.L	D3,(A0)			;4c73c: b790
	ADDA.L	#$00000028,A0		;4c73e: d1fc00000028
	DBF	D2,LAB_4C73A		;4c744: 51cafff4
	MOVEM.L	(A7)+,D0-D3/A0-A1	;4c748: 4cdf030f
	UNLK	A5			;4c74c: 4e5d
	RTS				;4c74e: 4e75
LAB_4C750:
	DS.L	1			;4c750
	DC.L	$0000c000,$0003f000,$000ffc00,$003fff00 ;4c754
	DC.L	$00ffffc0,$03fffff0,$0ffffffc,$3fffffff ;4c764
	DC.L	$0ffffffc,$03fffff0,$00ffffc0,$003fff00 ;4c774
	DC.L	$000ffc00,$0003f000,$0000c000 ;4c784
	DS.W	1			;4c790
_mouse:
	MOVEM.L	D0-D1/A0/A4,-(A7)	;4c792: 48e7c088
	JSR	_geta4			;4c796: 4eb900050674
	CLR.L	D0			;4c79c: 4280
	ADDI.L	#$00000001,_vbi_timer	;4c79e: 06b9000000010004ca60
	MOVE.W	JOY0DAT,D0		;4c7a8: 303900dff00a
	ANDI.W	#$00ff,D0		;4c7ae: 024000ff
	MOVE.W	LAB_4CA5C,D1		;4c7b2: 32390004ca5c
	MOVE.W	D0,LAB_4CA5C		;4c7b8: 33c00004ca5c
	SUB.W	D1,D0			;4c7be: 9041
	CMP.W	#$007f,D0		;4c7c0: b07c007f
	BLE.W	LAB_4C7CC		;4c7c4: 6f000006
	SUBI.W	#$0100,D0		;4c7c8: 04400100
LAB_4C7CC:
	CMP.W	#$ff81,D0		;4c7cc: b07cff81
	BGE.W	LAB_4C7D8		;4c7d0: 6c000006
	ADDI.W	#$0100,D0		;4c7d4: 06400100
LAB_4C7D8:
	ADD.W	_big_mousex,D0		;4c7d8: d07900052d9e
	BPL.W	LAB_4C7E6		;4c7de: 6a000006
	MOVE.W	#$0000,D0		;4c7e2: 303c0000
LAB_4C7E6:
	CMP.W	#$027f,D0		;4c7e6: b07c027f
	BLE.W	LAB_4C7F2		;4c7ea: 6f000006
	MOVE.W	#$027f,D0		;4c7ee: 303c027f
LAB_4C7F2:
	MOVE.W	D0,_big_mousex		;4c7f2: 33c000052d9e
	LSR.W	#1,D0			;4c7f8: e248
	MOVE.W	D0,_mmousex		;4c7fa: 33c00005c53c
	ADDI.W	#$0040,D0		;4c800: 06400040
	MOVE.W	D0,-(A7)		;4c804: 3f00
	MOVE.W	JOY0DAT,D0		;4c806: 303900dff00a
	MOVE.W	#$0008,D1		;4c80c: 323c0008
	LSR.W	D1,D0			;4c810: e268
	MOVE.W	LAB_4CA5E,D1		;4c812: 32390004ca5e
	MOVE.W	D0,LAB_4CA5E		;4c818: 33c00004ca5e
	SUB.W	D1,D0			;4c81e: 9041
	CMP.W	#$007f,D0		;4c820: b07c007f
	BLE.W	LAB_4C82C		;4c824: 6f000006
	SUBI.W	#$0100,D0		;4c828: 04400100
LAB_4C82C:
	CMP.W	#$ff81,D0		;4c82c: b07cff81
	BGE.W	LAB_4C838		;4c830: 6c000006
	ADDI.W	#$0100,D0		;4c834: 06400100
LAB_4C838:
	ADD.W	_big_mousey,D0		;4c838: d07900052da0
	BPL.W	LAB_4C846		;4c83e: 6a000006
	MOVE.W	#$0000,D0		;4c842: 303c0000
LAB_4C846:
	CMP.W	_mouse_limit,D0		;4c846: b07900052d96
	BLE.W	LAB_4C856		;4c84c: 6f000008
	MOVE.W	_mouse_limit,D0		;4c850: 303900052d96
LAB_4C856:
	MOVE.W	D0,_big_mousey		;4c856: 33c000052da0
	LSR.W	#1,D0			;4c85c: e248
	MOVE.W	D0,_mmousey		;4c85e: 33c00005c53e
	MOVE.W	D0,-(A7)		;4c864: 3f00
	MOVE.B	EXT_BFE0FF,D0		;4c866: 103900bfe0ff
	ANDI.B	#$40,D0			;4c86c: 02000040
	EXT.W	D0			;4c870: 4880
	TST.W	_left_button		;4c872: 4a7900054250
	BEQ.W	LAB_4C8A8		;4c878: 6700002e
	CMPI.W	#$0002,_left_button	;4c87c: 0c79000200054250
	BNE.W	LAB_4C88E		;4c884: 66000008
	TST.W	D0			;4c888: 4a40
	BEQ.W	LAB_4C8A8		;4c88a: 6700001c
LAB_4C88E:
	MOVE.W	D0,_left_button		;4c88e: 33c000054250
	MOVE.W	_mmousex,_mousex	;4c894: 33f90005c53c00052d98
	MOVE.W	_mmousey,_mousey	;4c89e: 33f90005c53e0005425c
LAB_4C8A8:
	MOVE.W	#$0c00,POTGO		;4c8a8: 33fc0c0000dff034
	MOVE.W	POTGOR,D0		;4c8b0: 303900dff016
	ANDI.W	#$0400,D0		;4c8b6: 02400400
	TST.W	_right_button		;4c8ba: 4a7900054252
	BEQ.W	LAB_4C8F0		;4c8c0: 6700002e
	CMPI.W	#$0002,_right_button	;4c8c4: 0c79000200054252
	BNE.W	LAB_4C8D6		;4c8cc: 66000008
	TST.W	D0			;4c8d0: 4a40
	BEQ.W	LAB_4C8F0		;4c8d2: 6700001c
LAB_4C8D6:
	MOVE.W	D0,_right_button	;4c8d6: 33c000054252
	MOVE.W	_mmousex,_mousex	;4c8dc: 33f90005c53c00052d98
	MOVE.W	_mmousey,_mousey	;4c8e6: 33f90005c53e0005425c
LAB_4C8F0:
	CLR.W	-(A7)			;4c8f0: 4267
	JSR	_move_pointer		;4c8f2: 4eb90004cd2e
	ADDA.L	#$00000006,A7		;4c8f8: dffc00000006
	MOVE.B	CIAA_SDR,D0		;4c8fe: 103900bfec01
	SUBI.B	#$3c,D0			;4c904: 0400003c
	BMI.S	LAB_4C924		;4c908: 6b1a
	CMP.B	#$04,D0			;4c90a: b03c0004
	BGE.S	LAB_4C924		;4c90e: 6c14
	CLR.W	_shift			;4c910: 42790005c4ee
	BTST	#0,D0			;4c916: 08000000
	BEQ.S	LAB_4C924		;4c91a: 6708
	MOVE.W	#$0001,_shift		;4c91c: 33fc00010005c4ee
LAB_4C924:
	JSR	_int_start		;4c924: 4eb9000505c2
	TST.W	_music_off		;4c92a: 4a790005163e
	BEQ.S	LAB_4C95A		;4c930: 6728
	MOVE.W	_music_now,D0		;4c932: 30390005c540
	ADDI.W	#$0001,D0		;4c938: 06400001
	CMP.W	_music,D0		;4c93c: b0790005c542
	BNE.S	LAB_4C954		;4c942: 6610
	MOVE.W	#$000a,_music		;4c944: 33fc000a0005c542
	JSR	_PlayMeas		;4c94c: 4eb90004d752
	CLR.W	D0			;4c952: 4240
LAB_4C954:
	MOVE.W	D0,_music_now		;4c954: 33c00005c540
LAB_4C95A:
	TST.W	_effect_off		;4c95a: 4a7900051640
	BEQ.W	LAB_4CA1A		;4c960: 670000b8
	TST.W	_effect			;4c964: 4a790005c39a
	BEQ.W	LAB_4C9AC		;4c96a: 67000040
	MOVE.W	#$0028,_music		;4c96e: 33fc00280005c542
	MOVE.W	#$0002,-(A7)		;4c976: 3f3c0002
	MOVE.W	_effect,-(A7)		;4c97a: 3f390005c39a
	JSR	_PlaySound		;4c980: 4eb90004d5f8
	ADDA.L	#$00000004,A7		;4c986: dffc00000004
	MOVE.W	#$0003,-(A7)		;4c98c: 3f3c0003
	MOVE.W	_effect,-(A7)		;4c990: 3f390005c39a
	JSR	_PlaySound		;4c996: 4eb90004d5f8
	ADDA.L	#$00000004,A7		;4c99c: dffc00000004
	CLR.W	_effect			;4c9a2: 42790005c39a
	BRA.W	LAB_4CA1A		;4c9a8: 60000070
LAB_4C9AC:
	TST.W	_sound_in		;4c9ac: 4a790005c544
	BNE.W	LAB_4CA1A		;4c9b2: 66000066
	TST.W	_tempo			;4c9b6: 4a790005163c
	BEQ.S	LAB_4CA1A		;4c9bc: 675c
	MOVE.W	_tempo_now,D0		;4c9be: 303900052e06
	ADDI.W	#$0001,D0		;4c9c4: 06400001
	MOVE.W	D0,_tempo_now		;4c9c8: 33c000052e06
	CMP.W	_tempo,D0		;4c9ce: b0790005163c
	BLT.S	LAB_4C9F2		;4c9d4: 6d1c
	MOVE.W	#$0000,-(A7)		;4c9d6: 3f3c0000
	MOVE.W	#$0047,-(A7)		;4c9da: 3f3c0047
	JSR	_PlaySound		;4c9de: 4eb90004d5f8
	ADDA.L	#$00000004,A7		;4c9e4: dffc00000004
	CLR.W	_tempo_now		;4c9ea: 427900052e06
	BRA.S	LAB_4CA1A		;4c9f0: 6028
LAB_4C9F2:
	MOVE.W	_tempo,D0		;4c9f2: 30390005163c
	SUB.W	_beat_two,D0		;4c9f8: 907900052e04
	CMP.W	_tempo_now,D0		;4c9fe: b07900052e06
	BNE.S	LAB_4CA1A		;4ca04: 6614
	MOVE.W	#$0000,-(A7)		;4ca06: 3f3c0000
	MOVE.W	#$0048,-(A7)		;4ca0a: 3f3c0048
	JSR	_PlaySound		;4ca0e: 4eb90004d5f8
	ADDA.L	#$00000004,A7		;4ca14: dffc00000004
LAB_4CA1A:
	JSR	_int_end		;4ca1a: 4eb9000505d0
	MOVE.L	#$00000000,D0		;4ca20: 203c00000000
	MOVEM.L	(A7)+,D0-D1/A0/A4	;4ca26: 4cdf1103
	RTS				;4ca2a: 4e75
_setup_mouse:
	MOVE.W	JOY0DAT,D0		;4ca2c: 303900dff00a
	ANDI.W	#$00ff,D0		;4ca32: 024000ff
	MOVE.W	D0,LAB_4CA5C		;4ca36: 33c00004ca5c
	MOVE.W	JOY0DAT,D0		;4ca3c: 303900dff00a
	MOVE.W	#$0008,D1		;4ca42: 323c0008
	LSR.W	D1,D0			;4ca46: e268
	MOVE.W	D0,LAB_4CA5E		;4ca48: 33c00004ca5e
	MOVE.W	#$0000,D0		;4ca4e: 303c0000
	MOVE.W	#$000a,_music		;4ca52: 33fc000a0005c542
	RTS				;4ca5a: 4e75
LAB_4CA5C:
	DS.W	1			;4ca5c
LAB_4CA5E:
	DS.W	1			;4ca5e
_vbi_timer:
	DS.L	1			;4ca60
	DS.W	1			;4ca64
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_make_copper:
	LINK.W	A5,#0			;4ca66: 4e550000
	MOVEM.L	D0-D4/A0-A2,-(A7)	;4ca6a: 48e7f8e0
	MOVEA.L	(8,A5),A0		;4ca6e: 206d0008
	MOVE.L	($C,A5),D1		;4ca72: 222d000c
	MOVEA.L	($10,A5),A1		;4ca76: 226d0010
	MOVEA.L	($14,A5),A2		;4ca7a: 246d0014
	MOVE.L	A0,D4			;4ca7e: 2808
	CLR.L	(A0)+			;4ca80: 4298
	MOVE.W	#$000c,D3		;4ca82: 363c000c
	CLR.L	D2			;4ca86: 4282
	MOVE.W	($18,A5),D2		;4ca88: 342d0018
	LSL.W	D3,D2			;4ca8c: e76a
	ORI.L	#$01000200,D2		;4ca8e: 008201000200
	MOVE.L	D2,(A0)+		;4ca94: 20c2
	MOVE.L	#$01020000,(A0)+	;4ca96: 20fc01020000
	MOVE.L	#$01040024,(A0)+	;4ca9c: 20fc01040024
	TST.W	_pal			;4caa2: 4a7900052dce
	BEQ.S	LAB_4CAB8		;4caa8: 670e
	MOVE.L	#$008e3681,(A0)+	;4caaa: 20fc008e3681
	MOVE.L	#$0090fec1,(A0)+	;4cab0: 20fc0090fec1
	BRA.S	LAB_4CAC4		;4cab6: 600c
LAB_4CAB8:
	MOVE.L	#$008e2c81,(A0)+	;4cab8: 20fc008e2c81
	MOVE.L	#$0090f4c1,(A0)+	;4cabe: 20fc0090f4c1
LAB_4CAC4:
	MOVE.L	#$00920038,(A0)+	;4cac4: 20fc00920038
	MOVE.L	#$009400d0,(A0)+	;4caca: 20fc009400d0
	MOVE.L	#$01080000,(A0)+	;4cad0: 20fc01080000
	MOVE.L	#$010a0000,(A0)+	;4cad6: 20fc010a0000
	MOVE.W	#$001f,D3		;4cadc: 363c001f
	MOVE.W	#$0180,D0		;4cae0: 303c0180
LAB_4CAE4:
	MOVE.W	D0,(A0)+		;4cae4: 30c0
	MOVE.W	(A1)+,(A0)+		;4cae6: 30d9
	ADDI.W	#$0002,D0		;4cae8: 06400002
	DBF	D3,LAB_4CAE4		;4caec: 51cbfff6
	MOVE.W	#$00e0,D0		;4caf0: 303c00e0
	MOVE.W	($18,A5),D3		;4caf4: 362d0018
	SUBI.W	#$0001,D3		;4caf8: 04430001
LAB_4CAFC:
	MOVE.W	D0,(A0)+		;4cafc: 30c0
	ADDI.W	#$0002,D0		;4cafe: 06400002
	SWAP	D1			;4cb02: 4841
	MOVE.W	D1,(A0)+		;4cb04: 30c1
	MOVE.W	D0,(A0)+		;4cb06: 30c0
	ADDI.W	#$0002,D0		;4cb08: 06400002
	SWAP	D1			;4cb0c: 4841
	MOVE.W	D1,(A0)+		;4cb0e: 30c1
	ADDI.L	#$00001f40,D1		;4cb10: 068100001f40
	DBF	D3,LAB_4CAFC		;4cb16: 51cbffe4
	MOVE.W	#$0120,D0		;4cb1a: 303c0120
	MOVE.W	#$0007,D3		;4cb1e: 363c0007
LAB_4CB22:
	MOVE.W	D0,(A0)+		;4cb22: 30c0
	ADDI.W	#$0002,D0		;4cb24: 06400002
	TST.L	(A2)			;4cb28: 4a92
	BEQ.W	LAB_4CB3C		;4cb2a: 67000010
	MOVE.W	(A2)+,(A0)+		;4cb2e: 30da
	MOVE.W	D0,(A0)+		;4cb30: 30c0
	ADDI.W	#$0002,D0		;4cb32: 06400002
	MOVE.W	(A2)+,(A0)+		;4cb36: 30da
	BRA.W	LAB_4CB50		;4cb38: 60000016
LAB_4CB3C:
	ADDA.L	#$00000004,A2		;4cb3c: d5fc00000004
	SWAP	D4			;4cb42: 4844
	MOVE.W	D4,(A0)+		;4cb44: 30c4
	MOVE.W	D0,(A0)+		;4cb46: 30c0
	ADDI.W	#$0002,D0		;4cb48: 06400002
	SWAP	D4			;4cb4c: 4844
	MOVE.W	D4,(A0)+		;4cb4e: 30c4
LAB_4CB50:
	DBF	D3,LAB_4CB22		;4cb50: 51cbffd0
	MOVE.L	#$fffffffe,(A0)		;4cb54: 20bcfffffffe
	MOVE.W	#$83f0,DMACON		;4cb5a: 33fc83f000dff096
	MOVEM.L	(A7)+,D0-D4/A0-A2	;4cb62: 4cdf071f
	UNLK	A5			;4cb66: 4e5d
	RTS				;4cb68: 4e75
_reset_screen:
	MOVE.L	(4,A7),COP1LCH		;4cb6a: 23ef000400dff080
	MOVE.W	COPJMP1,D0		;4cb72: 303900dff088
	MOVE.W	#$83f0,DMACON		;4cb78: 33fc83f000dff096
	RTS				;4cb80: 4e75
_show_screen:
	MOVE.L	(4,A7),D0		;4cb82: 202f0004
	ADDI.L	#$00000004,D0		;4cb86: 068000000004
	MOVE.L	D0,COP1LCH		;4cb8c: 23c000dff080
LAB_4CB92:
	MOVE.W	INTREQR,D0		;4cb92: 303900dff01e
	ANDI.W	#$0020,D0		;4cb98: 02400020
	BEQ.W	LAB_4CB92		;4cb9c: 6700fff4
	RTS				;4cba0: 4e75
_waittof:
	MOVE.W	#$0020,INTREQ		;4cba2: 33fc002000dff09c
LAB_4CBAA:
	MOVE.W	INTREQR,D0		;4cbaa: 303900dff01e
	ANDI.W	#$0020,D0		;4cbb0: 02400020
	BEQ.W	LAB_4CBAA		;4cbb4: 6700fff4
	RTS				;4cbb8: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_change_palette:
	LINK.W	A5,#0			;4cbba: 4e550000
	MOVEM.L	A0-A1,-(A7)		;4cbbe: 48e700c0
	MOVEA.L	(8,A5),A0		;4cbc2: 206d0008
	MOVEA.L	($C,A5),A1		;4cbc6: 226d000c
LAB_4CBCA:
	ADDA.L	#$00000004,A0		;4cbca: d1fc00000004
	CMPI.W	#$0180,(A0)		;4cbd0: 0c500180
	BNE.S	LAB_4CBCA		;4cbd4: 66f4
	ADDA.L	#$00000002,A0		;4cbd6: d1fc00000002
	MOVE.W	#$001f,D0		;4cbdc: 303c001f
LAB_4CBE0:
	MOVE.W	(A1)+,(A0)		;4cbe0: 3099
	ADDA.L	#$00000004,A0		;4cbe2: d1fc00000004
	DBF	D0,LAB_4CBE0		;4cbe8: 51c8fff6
	MOVEM.L	(A7)+,A0-A1		;4cbec: 4cdf0300
	UNLK	A5			;4cbf0: 4e5d
	RTS				;4cbf2: 4e75
	DS.W	1			;4cbf4
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_convert_sprite:
	LINK.W	A5,#0			;4cbf6: 4e550000
	MOVEM.L	A0-A2,-(A7)		;4cbfa: 48e700e0
	MOVE.W	(8,A5),D0		;4cbfe: 302d0008
	MOVEA.L	($A,A5),A1		;4cc02: 226d000a
	MOVEA.L	_sprite_data,A0		;4cc06: 207900052c56
	MULU	#$00a0,D0		;4cc0c: c0fc00a0
	ADDA.L	D0,A0			;4cc10: d1c0
	MOVEA.L	A1,A2			;4cc12: 2449
	ADDA.L	#$00000004,A1		;4cc14: d3fc00000004
	ADDA.L	#$00000048,A2		;4cc1a: d5fc00000048
	MOVE.L	#$00000080,(A2)+	;4cc20: 24fc00000080
	MOVE.W	#$000f,D0		;4cc26: 303c000f
LAB_4CC2A:
	ADDA.L	#$00000002,A0		;4cc2a: d1fc00000002
	MOVE.L	(A0)+,(A1)+		;4cc30: 22d8
	MOVE.L	(A0)+,(A2)+		;4cc32: 24d8
	DBF	D0,LAB_4CC2A		;4cc34: 51c8fff4
	MOVE.L	#$00000000,(A1)		;4cc38: 22bc00000000
	MOVE.L	#$00000000,(A2)		;4cc3e: 24bc00000000
	MOVEM.L	(A7)+,A0-A2		;4cc44: 4cdf0700
	UNLK	A5			;4cc48: 4e5d
	RTS				;4cc4a: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_insert_sprite:
	LINK.W	A5,#0			;4cc4c: 4e550000
	MOVEM.L	A0-A2,-(A7)		;4cc50: 48e700e0
	MOVEA.L	(8,A5),A0		;4cc54: 206d0008
	MOVE.W	($C,A5),D0		;4cc58: 302d000c
	MOVEA.L	A0,A2			;4cc5c: 2448
	ADDA.L	#$000000c8,A0		;4cc5e: d1fc000000c8
	LSL.W	#2,D0			;4cc64: e548
	EXT.L	D0			;4cc66: 48c0
	LEA	_sprite_list,A1		;4cc68: 43f90005c4ce
	ADDA.L	D0,A1			;4cc6e: d3c0
	LSL.W	#1,D0			;4cc70: e348
	ADDA.L	D0,A0			;4cc72: d1c0
	MOVE.L	($E,A5),D0		;4cc74: 202d000e
	BEQ.W	LAB_4CCA2		;4cc78: 67000028
	MOVE.L	D0,(A1)+		;4cc7c: 22c0
	SWAP	D0			;4cc7e: 4840
	MOVE.W	D0,(2,A0)		;4cc80: 31400002
	SWAP	D0			;4cc84: 4840
	MOVE.W	D0,(6,A0)		;4cc86: 31400006
	ADDI.L	#$00000048,D0		;4cc8a: 068000000048
	MOVE.L	D0,(A1)			;4cc90: 2280
	SWAP	D0			;4cc92: 4840
	MOVE.W	D0,($A,A0)		;4cc94: 3140000a
	SWAP	D0			;4cc98: 4840
	MOVE.W	D0,($E,A0)		;4cc9a: 3140000e
	BRA.W	LAB_4CCBC		;4cc9e: 6000001c
LAB_4CCA2:
	MOVE.L	A2,D0			;4cca2: 200a
	CLR.L	(A1)+			;4cca4: 4299
	CLR.L	(A1)			;4cca6: 4291
	SWAP	D0			;4cca8: 4840
	MOVE.W	D0,(2,A0)		;4ccaa: 31400002
	MOVE.W	D0,($A,A0)		;4ccae: 3140000a
	SWAP	D0			;4ccb2: 4840
	MOVE.W	D0,(6,A0)		;4ccb4: 31400006
	MOVE.W	D0,($E,A0)		;4ccb8: 3140000e
LAB_4CCBC:
	MOVEM.L	(A7)+,A0-A2		;4ccbc: 4cdf0700
	UNLK	A5			;4ccc0: 4e5d
	RTS				;4ccc2: 4e75
	DS.W	1			;4ccc4
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_draw_mouth:
	LINK.W	A5,#0			;4ccc6: 4e550000
	MOVEM.L	A0-A1,-(A7)		;4ccca: 48e700c0
	MOVEA.L	(8,A5),A0		;4ccce: 206d0008
	MOVE.W	($C,A5),D0		;4ccd2: 302d000c
	EXT.L	D0			;4ccd6: 48c0
	ADDA.L	D0,A0			;4ccd8: d1c0
	MOVE.W	($E,A5),D0		;4ccda: 302d000e
	MULU	#$0028,D0		;4ccde: c0fc0028
	ADDA.L	D0,A0			;4cce2: d1c0
	LEA	_map_steps,A1		;4cce4: 43f900059376
	MOVE.W	($12,A5),D0		;4ccea: 302d0012
	MULU	#$0348,D0		;4ccee: c0fc0348
	ADDA.L	D0,A1			;4ccf2: d3c0
	MOVE.W	($10,A5),D0		;4ccf4: 302d0010
	SUBI.W	#$0001,D0		;4ccf8: 04400001
LAB_4CCFC:
	MOVE.L	(A1)+,(A0)		;4ccfc: 2099
	MOVE.W	(A1)+,(4,A0)		;4ccfe: 31590004
	MOVE.L	(A1)+,($1F40,A0)	;4cd02: 21591f40
	MOVE.W	(A1)+,($1F44,A0)	;4cd06: 31591f44
	MOVE.L	(A1)+,($3E80,A0)	;4cd0a: 21593e80
	MOVE.W	(A1)+,($3E84,A0)	;4cd0e: 31593e84
	MOVE.L	(A1)+,($5DC0,A0)	;4cd12: 21595dc0
	MOVE.W	(A1)+,($5DC4,A0)	;4cd16: 31595dc4
	ADDA.L	#$00000028,A0		;4cd1a: d1fc00000028
	DBF	D0,LAB_4CCFC		;4cd20: 51c8ffda
	MOVEM.L	(A7)+,A0-A1		;4cd24: 4cdf0300
	UNLK	A5			;4cd28: 4e5d
	RTS				;4cd2a: 4e75
	DS.W	1			;4cd2c
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_move_pointer:
	LINK.W	A5,#0			;4cd2e: 4e550000
	MOVEM.L	D0-D3/A0,-(A7)		;4cd32: 48e7f080
	MOVE.W	(8,A5),D0		;4cd36: 302d0008
	MOVE.W	($A,A5),D1		;4cd3a: 322d000a
	MOVE.W	($C,A5),D2		;4cd3e: 342d000c
	MOVEA.L	#_sprite_list,A0	;4cd42: 207c0005c4ce
	LSL.W	#2,D0			;4cd48: e548
	MOVEA.L	(0,A0,D0.W),A0		;4cd4a: 20700000
	MOVE.B	($4B,A0),D3		;4cd4e: 1628004b
	ANDI.B	#$80,D3			;4cd52: 02030080
	ADDI.W	#$0040,D2		;4cd56: 06420040
	LSR.W	#1,D2			;4cd5a: e24a
	BCC.W	LAB_4CD64		;4cd5c: 64000006
	BSET	#0,D3			;4cd60: 08c30000
LAB_4CD64:
	MOVE.B	D2,(1,A0)		;4cd64: 11420001
	MOVE.B	D2,($49,A0)		;4cd68: 11420049
	ADDI.W	#$002c,D1		;4cd6c: 0641002c
	TST.W	_pal			;4cd70: 4a7900052dce
	BEQ.S	LAB_4CD7C		;4cd76: 6704
	ADDI.W	#$000a,D1		;4cd78: 0641000a
LAB_4CD7C:
	BTST	#8,D1			;4cd7c: 08010008
	BEQ.W	LAB_4CD88		;4cd80: 67000006
	BSET	#2,D3			;4cd84: 08c30002
LAB_4CD88:
	MOVE.B	D1,(0,A0)		;4cd88: 11410000
	MOVE.B	D1,($48,A0)		;4cd8c: 11410048
	ADDI.W	#$000f,D1		;4cd90: 0641000f
	BTST	#8,D1			;4cd94: 08010008
	BEQ.W	LAB_4CDA0		;4cd98: 67000006
	BSET	#1,D3			;4cd9c: 08c30001
LAB_4CDA0:
	MOVE.B	D1,(2,A0)		;4cda0: 11410002
	MOVE.B	D1,($4A,A0)		;4cda4: 1141004a
	MOVE.B	D3,(3,A0)		;4cda8: 11430003
	MOVE.B	D3,($4B,A0)		;4cdac: 1143004b
	MOVEM.L	(A7)+,D0-D3/A0		;4cdb0: 4cdf010f
	UNLK	A5			;4cdb4: 4e5d
	RTS				;4cdb6: 4e75
	DS.W	1			;4cdb8
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_text:
	LINK.W	A5,#0			;4cdba: 4e550000
	MOVEM.L	D0-D2/A0-A3,-(A7)	;4cdbe: 48e7e0f0
	MOVEA.L	(8,A5),A0		;4cdc2: 206d0008
	MOVE.W	($C,A5),D0		;4cdc6: 302d000c
	LSR.W	#3,D0			;4cdca: e648
	EXT.L	D0			;4cdcc: 48c0
	ADDA.L	D0,A0			;4cdce: d1c0
	MOVE.W	($E,A5),D0		;4cdd0: 302d000e
	MULU	#$0028,D0		;4cdd4: c0fc0028
	ADDA.L	D0,A0			;4cdd8: d1c0
	MOVEA.L	A0,A1			;4cdda: 2248
	MOVEA.L	($10,A5),A2		;4cddc: 246d0010
LAB_4CDE0:
	MOVE.B	(A2)+,D0		;4cde0: 101a
	BEQ.S	LAB_4CE4C		;4cde2: 6768
	CMP.B	#$0a,D0			;4cde4: b03c000a
	BNE.S	LAB_4CDF4		;4cde8: 660a
	ADDA.L	#$00000140,A1		;4cdea: d3fc00000140
	MOVEA.L	A1,A0			;4cdf0: 2049
	BRA.S	LAB_4CDE0		;4cdf2: 60ec
LAB_4CDF4:
	ANDI.W	#$00ff,D0		;4cdf4: 024000ff
	SUBI.W	#$0020,D0		;4cdf8: 04400020
	MULU	#$0028,D0		;4cdfc: c0fc0028
	LEA	_font_data,A3		;4ce00: 47f90004f3ce
	ADDA.L	D0,A3			;4ce06: d7c0
	MOVE.W	#$0007,D1		;4ce08: 323c0007
LAB_4CE0C:
	MOVE.B	(A3)+,D2		;4ce0c: 141b
	MOVE.B	(A0),D0			;4ce0e: 1010
	AND.B	D2,D0			;4ce10: c002
	OR.B	(A3)+,D0		;4ce12: 801b
	MOVE.B	D0,(A0)			;4ce14: 1080
	MOVE.B	($1F40,A0),D0		;4ce16: 10281f40
	AND.B	D2,D0			;4ce1a: c002
	OR.B	(A3)+,D0		;4ce1c: 801b
	MOVE.B	D0,($1F40,A0)		;4ce1e: 11401f40
	MOVE.B	($3E80,A0),D0		;4ce22: 10283e80
	AND.B	D2,D0			;4ce26: c002
	OR.B	(A3)+,D0		;4ce28: 801b
	MOVE.B	D0,($3E80,A0)		;4ce2a: 11403e80
	MOVE.B	($5DC0,A0),D0		;4ce2e: 10285dc0
	AND.B	D2,D0			;4ce32: c002
	OR.B	(A3)+,D0		;4ce34: 801b
	MOVE.B	D0,($5DC0,A0)		;4ce36: 11405dc0
	ADDA.L	#$00000028,A0		;4ce3a: d1fc00000028
	DBF	D1,LAB_4CE0C		;4ce40: 51c9ffca
	SUBA.L	#$0000013f,A0		;4ce44: 91fc0000013f
	BRA.S	LAB_4CDE0		;4ce4a: 6094
LAB_4CE4C:
	MOVEM.L	(A7)+,D0-D2/A0-A3	;4ce4c: 4cdf0f07
	UNLK	A5			;4ce50: 4e5d
	RTS				;4ce52: 4e75
	DS.W	1			;4ce54
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_set_serial:
	LINK.W	A5,#0			;4ce56: 4e550000
	MOVEM.L	D1/A1,-(A7)		;4ce5a: 48e74040
	LEA	_serial,A1		;4ce5e: 43f900052c8a
	CLR.L	D0			;4ce64: 4280
	MOVE.W	(6,A1),D0		;4ce66: 30290006
	LSL.W	#3,D0			;4ce6a: e748
	SUB.W	(6,A1),D0		;4ce6c: 90690006
	MOVE.L	#$00369cda,D1		;4ce70: 223c00369cda
	DIVU	(6,A1),D1		;4ce76: 82e90006
	SUBI.W	#$0001,D1		;4ce7a: 04410001
	MOVE.W	D1,SERPER		;4ce7e: 33c100dff032
	MOVE.W	#$8801,INTENA		;4ce84: 33fc880100dff09a
	MOVE.W	#$0801,INTREQ		;4ce8c: 33fc080100dff09c
	MOVE.B	CIAB_PRA,D1		;4ce94: 123900bfd000
	ANDI.B	#$3f,D1			;4ce9a: 0201003f
	MOVE.B	D1,CIAB_PRA		;4ce9e: 13c100bfd000
	MOVEM.L	(A7)+,D1/A1		;4cea4: 4cdf0202
	UNLK	A5			;4cea8: 4e5d
	RTS				;4ceaa: 4e75
_clear_serial:
	MOVEM.L	A1,-(A7)		;4ceac: 48e70040
	LEA	_serial,A1		;4ceb0: 43f900052c8a
	CLR.W	(0,A1)			;4ceb6: 42690000
	CLR.W	(2,A1)			;4ceba: 42690002
	MOVEM.L	(A7)+,A1		;4cebe: 4cdf0200
	RTS				;4cec2: 4e75
_r_ser_buff:
	CLR.L	D0			;4cec4: 4280
	MOVE.W	(2,A1),D0		;4cec6: 30290002
	MOVE.B	EXT_DFF019,(8,A1,D0.W)	;4ceca: 13b900dff0190008
	MOVE.W	(2,A1),D0		;4ced2: 30290002
	ADDI.W	#$0001,D0		;4ced6: 06400001
	CMP.W	#$0078,D0		;4ceda: b07c0078
	BNE.W	LAB_4CEE6		;4cede: 66000006
	MOVE.W	#$0000,D0		;4cee2: 303c0000
LAB_4CEE6:
	MOVE.W	D0,(2,A1)		;4cee6: 33400002
	MOVE.W	#$0800,INTREQ		;4ceea: 33fc080000dff09c
	MOVE.L	#$00000000,D0		;4cef2: 203c00000000
	RTS				;4cef8: 4e75
_w_ser_buff:
	MOVE.W	#$0000,(4,A1)		;4cefa: 337c00000004
	MOVE.W	#$0001,INTREQ		;4cf00: 33fc000100dff09c
	MOVE.L	#$00000000,D0		;4cf08: 203c00000000
	RTS				;4cf0e: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_read_serial:
	LINK.W	A5,#0			;4cf10: 4e550000
	MOVEM.L	D1/A0-A1,-(A7)		;4cf14: 48e740c0
	MOVEA.L	(8,A5),A0		;4cf18: 206d0008
	MOVE.W	($C,A5),D1		;4cf1c: 322d000c
	LEA	_serial,A1		;4cf20: 43f900052c8a
LAB_4CF26:
	MOVE.L	($E,A5),D0		;4cf26: 202d000e
	BEQ.W	LAB_4CF84		;4cf2a: 67000058
	CMP.L	#$000000ff,D0		;4cf2e: b0bc000000ff
	BGT.W	LAB_4CF54		;4cf34: 6e00001e
	TST.W	_shift			;4cf38: 4a790005c4ee
	BEQ.W	LAB_4CF84		;4cf3e: 67000044
	JSR	_keyboard		;4cf42: 4eb90004c1a2
	CMP.W	($10,A5),D0		;4cf48: b06d0010
	BNE.W	LAB_4CF84		;4cf4c: 66000036
	BRA.W	LAB_4CFC8		;4cf50: 60000076
LAB_4CF54:
	MOVEM.L	D1/A0-A1,-(A7)		;4cf54: 48e740c0
	CLR.L	-(A7)			;4cf58: 42a7
	MOVE.L	($E,A5),-(A7)		;4cf5a: 2f2d000e
	JSR	_check_cancel		;4cf5e: 4eb900046f50
	ADDA.L	#$00000008,A7		;4cf64: dffc00000008
	TST.W	_left_button		;4cf6a: 4a7900054250
	BNE.S	LAB_4CF7A		;4cf70: 6608
	MOVE.W	#$0002,_left_button	;4cf72: 33fc000200054250
LAB_4CF7A:
	MOVEM.L	(A7)+,D1/A0-A1		;4cf7a: 4cdf0302
	TST.W	D0			;4cf7e: 4a40
	BNE.W	LAB_4CFC8		;4cf80: 66000046
LAB_4CF84:
	MOVE.W	(0,A1),D0		;4cf84: 30290000
	CMP.W	(2,A1),D0		;4cf88: b0690002
	BEQ.S	LAB_4CF26		;4cf8c: 6798
	MOVE.B	(8,A1,D0.W),(A0)	;4cf8e: 10b10008
	ADDI.W	#$0001,D0		;4cf92: 06400001
	CMP.W	#$0078,D0		;4cf96: b07c0078
	BNE.S	LAB_4CFA0		;4cf9a: 6604
	MOVE.W	#$0000,D0		;4cf9c: 303c0000
LAB_4CFA0:
	MOVE.W	D0,(0,A1)		;4cfa0: 33400000
	TST.W	D1			;4cfa4: 4a41
	BNE.S	LAB_4CFB4		;4cfa6: 660c
	TST.B	(A0)+			;4cfa8: 4a18
	BNE.W	LAB_4CF26		;4cfaa: 6600ff7a
	MOVE.B	#$00,(A0)		;4cfae: 10bc0000
	BRA.S	LAB_4CFC2		;4cfb2: 600e
LAB_4CFB4:
	ADDA.L	#$00000001,A0		;4cfb4: d1fc00000001
	SUBI.W	#$0001,D1		;4cfba: 04410001
	BNE.W	LAB_4CF26		;4cfbe: 6600ff66
LAB_4CFC2:
	MOVE.L	#$00000000,D0		;4cfc2: 203c00000000
LAB_4CFC8:
	TST.W	D0			;4cfc8: 4a40
	MOVEM.L	(A7)+,D1/A0-A1		;4cfca: 4cdf0302
	UNLK	A5			;4cfce: 4e5d
	RTS				;4cfd0: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_write_serial:
	LINK.W	A5,#0			;4cfd2: 4e550000
	MOVEM.L	D1/A0-A1,-(A7)		;4cfd6: 48e740c0
	MOVEA.L	(8,A5),A0		;4cfda: 206d0008
	MOVE.W	($C,A5),D1		;4cfde: 322d000c
	SUBI.W	#$0001,D1		;4cfe2: 04410001
	LEA	_serial,A1		;4cfe6: 43f900052c8a
LAB_4CFEC:
	MOVE.L	($E,A5),D0		;4cfec: 202d000e
	BEQ.W	LAB_4D04A		;4cff0: 67000058
	CMP.L	#$000000ff,D0		;4cff4: b0bc000000ff
	BGT.W	LAB_4D01A		;4cffa: 6e00001e
	TST.W	_shift			;4cffe: 4a790005c4ee
	BEQ.W	LAB_4D04A		;4d004: 67000044
	JSR	_keyboard		;4d008: 4eb90004c1a2
	CMP.W	($10,A5),D0		;4d00e: b06d0010
	BNE.W	LAB_4D04A		;4d012: 66000036
	BRA.W	LAB_4D06E		;4d016: 60000056
LAB_4D01A:
	MOVEM.L	D1/A0-A1,-(A7)		;4d01a: 48e740c0
	CLR.L	-(A7)			;4d01e: 42a7
	MOVE.L	($E,A5),-(A7)		;4d020: 2f2d000e
	JSR	_check_cancel		;4d024: 4eb900046f50
	ADDA.L	#$00000008,A7		;4d02a: dffc00000008
	TST.W	_left_button		;4d030: 4a7900054250
	BNE.S	LAB_4D040		;4d036: 6608
	MOVE.W	#$0002,_left_button	;4d038: 33fc000200054250
LAB_4D040:
	MOVEM.L	(A7)+,D1/A0-A1		;4d040: 4cdf0302
	TST.W	D0			;4d044: 4a40
	BNE.W	LAB_4D06E		;4d046: 66000026
LAB_4D04A:
	TST.W	(4,A1)			;4d04a: 4a690004
	BNE.S	LAB_4CFEC		;4d04e: 669c
	CLR.L	D0			;4d050: 4280
	MOVE.B	(A0)+,D0		;4d052: 1018
	ORI.W	#$0100,D0		;4d054: 00400100
	MOVE.W	#$0001,(4,A1)		;4d058: 337c00010004
	MOVE.W	D0,SERDAT		;4d05e: 33c000dff030
	DBF	D1,LAB_4CFEC		;4d064: 51c9ff86
	MOVE.L	#$00000000,D0		;4d068: 203c00000000
LAB_4D06E:
	TST.W	D0			;4d06e: 4a40
	MOVEM.L	(A7)+,D1/A0-A1		;4d070: 4cdf0302
	UNLK	A5			;4d074: 4e5d
	RTS				;4d076: 4e75
; ------------------------------------------------------------------------------
; More anti-piracy protection.
; It appears that it is not called in this version.
; ------------------------------------------------------------------------------
_PROTECT3:
	MOVEM.L	D1/A0,-(A7)		;4d078: 48e74080
	MOVE.W	#$0534,D1		;4d07c: 323c0534
	SUBI.W	#$0001,D1		;4d080: 04410001
	LEA	LAB_4D092,A0		;4d084: 41f90004d092
LAB_4D08A:
	EORI.B	#$5b,(A0)+		;4d08a: 0a18005b
	DBF	D1,LAB_4D08A		;4d08e: 51c9fffa
; ------------------------------------------------------------------------------
; Encrypted code.
; Decrypts just before it runs and re-encrypts after.
; The 1989 release has several differences in this section.
; ------------------------------------------------------------------------------
LAB_4D092:
	DC.L	$3b5b5be1,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d092
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d0a2
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d0b2
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d0c2
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d0d2
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d0e2
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d0f2
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d102
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d112
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5b5b5b,$5b5b5b5b ;4d122
	DC.L	$5b5b5b5b,$5b5b5b5b,$5b5ba4a4,$a4a45b5b ;4d132
	DC.L	$5b5a5b5b,$5b5b5b5b,$5b5b5b5b,$745516a1 ;4d142
	DC.L	$a4d1138d,$a4a416b5,$5b1b7604,$a4a37b62 ;4d152
	DC.L	$5b5b5b4b,$13215b51,$78845b5b,$5b4b11a7 ;4d162
	DC.L	$789b5b5b,$5b4b17a2,$5ba45b5b,$5b53138d ;4d172
	DC.L	$5ba41aa1,$5b257893,$5b5b5b4b,$11a78e58 ;4d182
	DC.L	$a4ba3b45,$719dee62,$c4d85b27,$11978e68 ;4d192
	DC.L	$a4d23b2d,$718dee72,$c4f05b0f,$11df8e20 ;4d1a2
	DC.L	$5b12c4ed,$71d9ee26,$3b1ca4e3,$11c38e3c ;4d1b2
	DC.L	$5b2ac4d5,$71edee12,$3b38a4c7,$ee0f71f0 ;4d1c2
	DC.L	$a4da3b25,$8e9b1164,$c4dc5b23,$11258eda ;4d1d2
	DC.L	$a4da3b25,$8e971168,$3b60a49f,$115d8ea2 ;4d1e2
	DC.L	$a4b23b4d,$8eb3114c,$3b44a4bb,$11658e9a ;4d1f2
	DC.L	$a4ae13bc,$db9b1aa1,$5b6f7893,$5b5b5b7f ;4d202
	DC.L	$1aa158e9,$78935b5b,$5b7b5df4,$5b5b5b59 ;4d212
	DC.L	$5b555b74,$5b5c5b57,$53345b5c,$5b5718a1 ;4d222
	DC.L	$a44f3c41,$7b0a7bf2,$5b5f3b7d,$5927a3a4 ;4d232
	DC.L	$13bcdb9b,$18a1a5a5,$7b0a7bf2,$5b5f7b34 ;4d242
	DC.L	$5b5579d3,$780b5b5f,$7b73a4a7,$1ddb131b ;4d252
	DC.L	$eacb1784,$585a1528,$ab2da7bb,$1bbd54d2 ;4d262
	DC.L	$5b53e156,$55f5da0d,$57f29a15,$b7606a5e ;4d272
	DC.L	$c469b769,$28963b84,$5fa35f23,$5bed5e63 ;4d282
	DC.L	$5e235ea3,$5f235bab,$e7ae5e5c,$e30a184d ;4d292
	DC.L	$86b21d7d,$84b20f4d,$91b27a87,$e3505d55 ;4d2a2
	DC.L	$789cf766,$69c9b036,$3fcda178,$7c87a37b ;4d2b2
	DC.L	$3d98b261,$2cdef122,$6fc9a40c,$f0ab6e54 ;4d2c2
	DC.L	$5a57c4a8,$90c54f00,$c5095af6,$b245dd3b ;4d2d2
	DC.L	$49e676e5,$22a05d9e,$125ddd5b,$4fb2c04d ;4d2e2
	DC.L	$4db79000,$bf66a301,$0d37bf63,$03660cd4 ;4d2f2
	DC.L	$d06bfc85,$4d0ffa17,$e33a7d97,$a6687980 ;4d302
	DC.L	$807f5927,$c7904a62,$b65d6ba2,$b45c2acb ;4d312
	DC.L	$b2ce63b1,$ac5ee6e1,$1b5e06f4,$9fe523f2 ;4d322
	DC.L	$f91376ee,$ab210eec,$d5225cde,$a1a07f88 ;4d332
	DC.L	$0e0ef373,$d5220e0e,$12786906,$b77be579 ;4d342
	DC.L	$42060dc5,$1a9c83bf,$309fe764,$56eee1f6 ;4d352
	DC.L	$789bcf24,$14db992b,$835c9f31,$05c2f23d ;4d362
	DC.L	$60ccf939,$0e069f32,$00c9f7f6,$60cdcefb ;4d372
	DC.L	$f7e144c1,$31028088,$3790be3d,$638add8c ;4d382
	DC.L	$411dab5b,$65e4be9c,$20639bdb,$55589f9c ;4d392
	DC.L	$5b7f85c9,$6043aec0,$1c365bc5,$954676c9 ;4d3a2
	DC.L	$5bc59546,$09265bcd,$954ef6db,$5bc79544 ;4d3b2
	DC.L	$89245b7f,$95fcf6db,$5b7fc580,$0934c7b7 ;4d3c2
	DC.L	$3e7f5bc5,$eeba5d9a,$a73416be,$a3bd295b ;4d3d2
	DC.L	$2f6a6d67,$58964b73,$5b41535b,$5b5f3cad ;4d3e2
	DC.L	$09da6b73,$5b4131a3,$499b0a91,$a4af09da ;4d3f2
	DC.L	$6b735b41,$31a30a90,$a4ad6b73,$5b456a27 ;4d402
	DC.L	$5b595bc7,$6a271b5b,$5b7f535b,$5b5a3d5f ;4d412
	DC.L	$2b5b3b59,$7b5a11a7,$a02d2d2d,$da535fd5 ;4d422
	DC.L	$c1381efb,$a029561b,$c8e45e82,$c07d3701 ;4d432
	DC.L	$868b0b8b,$b58d79cb,$8a5b6525,$aae08954 ;4d442
	DC.L	$202bde55,$312b80a1,$3ea7ce6b,$bb5a6499 ;4d452
	DC.L	$3194980b,$6fe4ce6e,$5697fae8,$6fe1de6b ;4d462
	DC.L	$5194e01e,$5706d26b,$17968969,$2d4ad0f0 ;4d472
	DC.L	$76e9ee1a,$21df75ae,$eb51de1a,$19e48c13 ;4d482
	DC.L	$12ece625,$7ff2f80d,$bdb62547,$b7be2931 ;4d492
	DC.L	$844a1b41,$85d829a3,$b6b2284d,$d6f21937 ;4d4a2
	DC.L	$2b3c378b,$898e2847,$e63c7671,$f98e4aae ;4d4b2
	DC.L	$89b0383a,$248d9a88,$3bb7f678,$6577d4fd ;4d4c2
	DC.L	$63e5e288,$652292e4,$1d735be4,$bb5a23a9 ;4d4d2
	DC.L	$bd56448f,$eabcbd59,$3259adbc,$627931f6 ;4d4e2
	DC.L	$2d419344,$324f8fc0,$6cbbe311,$8c6a326f ;4d4f2
	DC.L	$e0ac2fd3,$a02c130c,$d03261b8,$ea4675bb ;4d502
	DC.L	$fe443181,$766ebbab,$3256db90,$44eb8a5b ;4d512
	DC.L	$75a7bb6b,$42948a5b,$74278fd8,$75a7c059 ;4d522
	DC.L	$58a2afde,$3fa48a59,$13a2e4de,$75a782db ;4d532
	DC.L	$1b21f71d,$7d9b8a5b,$7d678264,$6e588227 ;4d542
	DC.L	$8a5b5598,$7dd850e3,$cf2800ed,$54fe993b ;4d552
	DC.L	$04f2c40f,$2fc9fbb2,$8a5b75a6,$0432fdcd ;4d562
	DC.L	$8a5a7427,$8fd875a6,$c05858a3,$afde3fa5 ;4d572
	DC.L	$d398509e,$8a5b5598,$af615e87,$95678010 ;4d582
	DC.L	$2c6fb56c,$04e6bae3,$b1d16eae,$ddab4ed1 ;4d592
	DC.L	$a0217fe7,$b12e5b5f,$86a038a5,$a4b8740f ;4d5a2
	DC.L	$c758725b,$13a25ba4,$5b5b5b53,$17a124a4 ;4d5b2
	DC.L	$a0411528		;4d5c2
LAB_4D5C6:
	MOVE.W	#$0000,_p_done		;4d5c6: 33fc00000005c546
; re-encrypts to make analysis more difficult
	MOVE.W	#$0534,D1		;4d5ce: 323c0534
	SUBI.W	#$0001,D1		;4d5d2: 04410001
	LEA	LAB_4D092,A0		;4d5d6: 41f90004d092
LAB_4D5DC:
	EORI.B	#$5b,(A0)+		;4d5dc: 0a18005b
	DBF	D1,LAB_4D5DC		;4d5e0: 51c9fffa
	MOVEM.L	(A7)+,D1/A0		;4d5e4: 4cdf0102
	RTS				;4d5e8: 4e75
strSoundChannel:
	;4d5ea
	;DC.B	$53,$6f,$75,$6e,$64,$20,$43,$68,$61,$6e,$6e,$65,$6c,$00
	DC.B	"Sound Channel",0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_PlaySound:
	LINK.W	A5,#0			;4d5f8: 4e550000
	MOVEM.L	A2-A3,-(A7)		;4d5fc: 48e70030
	MOVE.W	(8,A5),D0		;4d600: 302d0008
	CMP.W	(_no_sounds,A4),D0	;4d604: b06c3542
	BCC.S	LAB_4D612		;4d608: 6408
	CMPI.W	#$0003,($A,A5)		;4d60a: 0c6d0003000a
	BLS.S	LAB_4D61C		;4d610: 630a
LAB_4D612:
	MOVEQ	#0,D0			;4d612: 7000
LAB_4D614:
	MOVEM.L	(A7)+,A2-A3		;4d614: 4cdf0c00
	UNLK	A5			;4d618: 4e5d
	RTS				;4d61a: 4e75
LAB_4D61C:
	MOVEQ	#0,D0			;4d61c: 7000
	MOVE.W	(8,A5),D0		;4d61e: 302d0008
	ASL.L	#3,D0			;4d622: e780
	MOVEA.L	D0,A2			;4d624: 2440
	ADDA.L	(_drumkit,A4),A2	;4d626: d5ec353a
	MOVEQ	#0,D0			;4d62a: 7000
	MOVE.W	($A,A5),D0		;4d62c: 302d000a
	ASL.L	#2,D0			;4d630: e580
	LEA	(_ioas,A4),A0		;4d632: 41ec3162
	MOVEA.L	(0,A0,D0.L),A3		;4d636: 26700800
	MOVE.L	A3,-(A7)		;4d63a: 2f0b
	JSR	(_CheckIO,PC)		;4d63c: 4eba3b9e
	ADDQ.W	#4,A7			;4d640: 584f
	TST.W	D0			;4d642: 4a40
	BNE.S	LAB_4D662		;4d644: 661c
	MOVE.B	(4,A2),D0		;4d646: 102a0004
	EXT.W	D0			;4d64a: 4880
	MOVEQ	#0,D1			;4d64c: 7200
	MOVE.W	($A,A5),D1		;4d64e: 322d000a
	ASL.L	#1,D1			;4d652: e381
	LEA	(_Soundpri,A4),A0	;4d654: 41ec354e
	CMP.W	(0,A0,D1.L),D0		;4d658: b0701800
	BGE.S	LAB_4D662		;4d65c: 6c04
	MOVEQ	#0,D0			;4d65e: 7000
	BRA.S	LAB_4D614		;4d660: 60b2
LAB_4D662:
	MOVE.L	A3,-(A7)		;4d662: 2f0b
	JSR	(_AbortIO,PC)		;4d664: 4eba3b2c
	ADDQ.W	#4,A7			;4d668: 584f
	MOVE.B	(4,A2),D0		;4d66a: 102a0004
	EXT.W	D0			;4d66e: 4880
	MOVEQ	#0,D1			;4d670: 7200
	MOVE.W	($A,A5),D1		;4d672: 322d000a
	ASL.L	#1,D1			;4d676: e381
	LEA	(_Soundpri,A4),A0	;4d678: 41ec354e
	MOVE.W	D0,(0,A0,D1.L)		;4d67c: 31801800
	MOVE.W	#$0001,-(A7)		;4d680: 3f3c0001
	CLR.L	-(A7)			;4d684: 42a7
	MOVE.L	A2,-(A7)		;4d686: 2f0a
	MOVE.L	A3,-(A7)		;4d688: 2f0b
	BSR.S	_setsound		;4d68a: 6142
	LEA	($E,A7),A7		;4d68c: 4fef000e
	TST.W	D0			;4d690: 4a40
	BEQ.S	LAB_4D6CA		;4d692: 6736
	MOVE.L	A3,-(A7)		;4d694: 2f0b
	JSR	(_BeginIO,PC)		;4d696: 4eba3b38
	ADDQ.W	#4,A7			;4d69a: 584f
	TST.W	(6,A2)			;4d69c: 4a6a0006
	BEQ.S	LAB_4D6CA		;4d6a0: 6728
	MOVE.W	(6,A2),-(A7)		;4d6a2: 3f2a0006
	MOVE.B	(5,A2),D0		;4d6a6: 102a0005
	EXT.W	D0			;4d6aa: 4880
	EXT.L	D0			;4d6ac: 48c0
	ASL.L	#3,D0			;4d6ae: e780
	LEA	(LAB_5C7EA,A4),A0	;4d6b0: 41ec33fc
	MOVE.W	(0,A0,D0.L),-(A7)	;4d6b4: 3f300800
	MOVE.L	A2,-(A7)		;4d6b8: 2f0a
	MOVE.L	A3,-(A7)		;4d6ba: 2f0b
	BSR.S	_setsound		;4d6bc: 6110
	LEA	($C,A7),A7		;4d6be: 4fef000c
	MOVE.L	A3,-(A7)		;4d6c2: 2f0b
	JSR	(_BeginIO,PC)		;4d6c4: 4eba3b0a
	ADDQ.W	#4,A7			;4d6c8: 584f
LAB_4D6CA:
	BRA.W	LAB_4D614		;4d6ca: 6000ff48
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_setsound:
	LINK.W	A5,#0			;4d6ce: 4e550000
	MOVEA.L	($C,A5),A0		;4d6d2: 206d000c
	MOVEA.L	(8,A5),A1		;4d6d6: 226d0008
	MOVE.W	(A0),($2A,A1)		;4d6da: 3350002a
	MOVEA.L	($C,A5),A0		;4d6de: 206d000c
	MOVE.B	(4,A0),D0		;4d6e2: 10280004
	EXT.W	D0			;4d6e6: 4880
	MOVEA.L	(8,A5),A0		;4d6e8: 206d0008
	MOVE.W	D0,($2C,A0)		;4d6ec: 3140002c
	MOVEA.L	(8,A5),A0		;4d6f0: 206d0008
	MOVEA.L	($C,A5),A1		;4d6f4: 226d000c
	MOVEQ	#0,D0			;4d6f8: 7000
	MOVE.W	(2,A1),D0		;4d6fa: 30290002
	SUB.L	($10,A5),D0		;4d6fe: 90ad0010
	MOVE.L	D0,($26,A0)		;4d702: 21400026
	MOVEA.L	(8,A5),A0		;4d706: 206d0008
	MOVE.W	($14,A5),($2E,A0)	;4d70a: 316d0014002e
	MOVEA.L	(8,A5),A0		;4d710: 206d0008
	MOVE.B	#$10,($1E,A0)		;4d714: 117c0010001e
	MOVEA.L	(8,A5),A0		;4d71a: 206d0008
	MOVE.W	#$0003,($1C,A0)		;4d71e: 317c0003001c
	MOVEA.L	($C,A5),A0		;4d724: 206d000c
	MOVE.B	(5,A0),D0		;4d728: 10280005
	EXT.W	D0			;4d72c: 4880
	EXT.L	D0			;4d72e: 48c0
	ASL.L	#3,D0			;4d730: e780
	LEA	(LAB_5C7EC,A4),A0	;4d732: 41ec33fe
	MOVE.L	(0,A0,D0.L),D1		;4d736: 22300800
	ADD.L	($10,A5),D1		;4d73a: d2ad0010
	MOVEA.L	(8,A5),A0		;4d73e: 206d0008
	MOVE.L	D1,($22,A0)		;4d742: 21410022
	BEQ.S	LAB_4D74C		;4d746: 6704
	MOVEQ	#1,D0			;4d748: 7001
	BRA.S	return_4D74E		;4d74a: 6002
LAB_4D74C:
	MOVEQ	#0,D0			;4d74c: 7000
return_4D74E:
	UNLK	A5			;4d74e: 4e5d
	RTS				;4d750: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_PlayMeas:
	LINK.W	A5,#0			;4d752: 4e550000
	CLR.W	-(A7)			;4d756: 4267
	MOVEQ	#0,D0			;4d758: 7000
	MOVE.W	(_curbeat,A4),D0	;4d75a: 302c3546
	MOVEA.L	(_curmeas,A4),A0	;4d75e: 206c354a
	MOVEQ	#0,D1			;4d762: 7200
	MOVE.B	(0,A0,D0.L),D1		;4d764: 12300800
	SUB.W	#$0041,D1		;4d768: 927c0041
	MOVE.W	D1,-(A7)		;4d76c: 3f01
	JSR	(_PlaySound,PC)		;4d76e: 4ebafe88
	ADDQ.W	#4,A7			;4d772: 584f
	MOVE.W	#$0001,-(A7)		;4d774: 3f3c0001
	MOVEQ	#0,D0			;4d778: 7000
	MOVE.W	(_curbeat,A4),D0	;4d77a: 302c3546
	MOVEA.L	D0,A0			;4d77e: 2040
	ADDA.L	(_curmeas,A4),A0	;4d780: d1ec354a
	MOVEQ	#0,D0			;4d784: 7000
	MOVE.B	($40,A0),D0		;4d786: 10280040
	SUB.W	#$0041,D0		;4d78a: 907c0041
	MOVE.W	D0,-(A7)		;4d78e: 3f00
	JSR	(_PlaySound,PC)		;4d790: 4ebafe66
	ADDQ.W	#4,A7			;4d794: 584f
	MOVE.W	#$0002,-(A7)		;4d796: 3f3c0002
	MOVEQ	#0,D0			;4d79a: 7000
	MOVE.W	(_curbeat,A4),D0	;4d79c: 302c3546
	MOVEA.L	D0,A0			;4d7a0: 2040
	ADDA.L	(_curmeas,A4),A0	;4d7a2: d1ec354a
	MOVEQ	#0,D0			;4d7a6: 7000
	MOVE.B	($80,A0),D0		;4d7a8: 10280080
	SUB.W	#$0041,D0		;4d7ac: 907c0041
	MOVE.W	D0,-(A7)		;4d7b0: 3f00
	JSR	(_PlaySound,PC)		;4d7b2: 4ebafe44
	ADDQ.W	#4,A7			;4d7b6: 584f
	MOVE.W	#$0003,-(A7)		;4d7b8: 3f3c0003
	MOVE.W	(_curbeat,A4),D0	;4d7bc: 302c3546
	ADDQ.W	#1,(_curbeat,A4)	;4d7c0: 526c3546
	MOVEQ	#0,D1			;4d7c4: 7200
	MOVE.W	D0,D1			;4d7c6: 3200
	MOVEA.L	D1,A0			;4d7c8: 2041
	ADDA.L	(_curmeas,A4),A0	;4d7ca: d1ec354a
	MOVEQ	#0,D0			;4d7ce: 7000
	MOVE.B	($C0,A0),D0		;4d7d0: 102800c0
	SUB.W	#$0041,D0		;4d7d4: 907c0041
	MOVE.W	D0,-(A7)		;4d7d8: 3f00
	JSR	(_PlaySound,PC)		;4d7da: 4ebafe1c
	ADDQ.W	#4,A7			;4d7de: 584f
	MOVEQ	#0,D0			;4d7e0: 7000
	MOVE.W	(_curseq,A4),D0		;4d7e2: 302c3544
	ASL.L	#2,D0			;4d7e6: e580
	LEA	(_sequn,A4),A0		;4d7e8: 41ec3178
	MOVEQ	#0,D1			;4d7ec: 7200
	MOVE.W	(0,A0,D0.L),D1		;4d7ee: 32300800
	ASL.L	#1,D1			;4d7f2: e381
	LEA	(_measln,A4),A0		;4d7f4: 41ec337a
	MOVE.W	(0,A0,D1.L),D0		;4d7f8: 30301800
	CMP.W	(_curbeat,A4),D0	;4d7fc: b06c3546
	BNE.S	LAB_4D850		;4d800: 664e
	ADDQ.W	#1,(_curtime,A4)	;4d802: 526c3548
	CLR.W	(_curbeat,A4)		;4d806: 426c3546
	MOVEQ	#0,D0			;4d80a: 7000
	MOVE.W	(_curseq,A4),D0		;4d80c: 302c3544
	ASL.L	#2,D0			;4d810: e580
	LEA	(LAB_5C568,A4),A0	;4d812: 41ec317a
	MOVE.W	(_curtime,A4),D1	;4d816: 322c3548
	CMP.W	(0,A0,D0.L),D1		;4d81a: b2700800
	BCS.S	LAB_4D832		;4d81e: 6512
	ADDQ.W	#1,(_curseq,A4)		;4d820: 526c3544
	MOVE.W	(_curseq,A4),D0		;4d824: 302c3544
	CMP.W	(_seqlen,A4),D0		;4d828: b06c3378
	BNE.S	LAB_4D832		;4d82c: 6604
	CLR.W	(_curseq,A4)		;4d82e: 426c3544
LAB_4D832:
	MOVEQ	#0,D0			;4d832: 7000
	MOVE.W	(_curseq,A4),D0		;4d834: 302c3544
	ASL.L	#2,D0			;4d838: e580
	LEA	(_sequn,A4),A0		;4d83a: 41ec3178
	MOVE.W	(0,A0,D0.L),D1		;4d83e: 32300800
	ASL.W	#8,D1			;4d842: e141
	MOVEQ	#0,D0			;4d844: 7000
	MOVE.W	D1,D0			;4d846: 3001
	ADD.L	(_measures,A4),D0	;4d848: d0ac3174
	MOVE.L	D0,(_curmeas,A4)	;4d84c: 2940354a
LAB_4D850:
	UNLK	A5			;4d850: 4e5d
	RTS				;4d852: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_free_all_sounds:
	LINK.W	A5,#-2			;4d854: 4e55fffe
	CLR.W	(-2,A5)			;4d858: 426dfffe
LAB_4D85C:
	MOVE.W	(-2,A5),D0		;4d85c: 302dfffe
	EXT.L	D0			;4d860: 48c0
	ASL.L	#2,D0			;4d862: e580
	LEA	(_ioas,A4),A0		;4d864: 41ec3162
	MOVE.L	(0,A0,D0.L),-(A7)	;4d868: 2f300800
	JSR	(_AbortIO,PC)		;4d86c: 4eba3924
	ADDQ.W	#4,A7			;4d870: 584f
	ADDQ.W	#1,(-2,A5)		;4d872: 526dfffe
	CMPI.W	#$0004,(-2,A5)		;4d876: 0c6d0004fffe
	BLT.S	LAB_4D85C		;4d87c: 6dde
	TST.L	(_measures,A4)		;4d87e: 4aac3174
	BEQ.S	LAB_4D892		;4d882: 670e
	PEA	$1000.W			;4d884: 48781000
	MOVE.L	(_measures,A4),-(A7)	;4d888: 2f2c3174
	JSR	(___FreeMem,A4)		;4d88c: 4eac820c
	ADDQ.W	#8,A7			;4d890: 504f
LAB_4D892:
	TST.L	(_all_sample,A4)	;4d892: 4aac315e
	BEQ.S	LAB_4D8A6		;4d896: 670e
	MOVE.L	(_all_sample_length,A4),-(A7) ;4d898: 2f2c315a
	MOVE.L	(_all_sample,A4),-(A7)	;4d89c: 2f2c315e
	JSR	(___FreeMem,A4)		;4d8a0: 4eac820c
	ADDQ.W	#8,A7			;4d8a4: 504f
LAB_4D8A6:
	TST.L	(_drumkit,A4)		;4d8a6: 4aac353a
	BEQ.S	LAB_4D8C2		;4d8aa: 6716
	MOVE.W	(_no_sounds,A4),D0	;4d8ac: 302c3542
	ASL.W	#3,D0			;4d8b0: e740
	MOVEQ	#0,D1			;4d8b2: 7200
	MOVE.W	D0,D1			;4d8b4: 3200
	MOVE.L	D1,-(A7)		;4d8b6: 2f01
	MOVE.L	(_drumkit,A4),-(A7)	;4d8b8: 2f2c353a
	JSR	(___FreeMem,A4)		;4d8bc: 4eac820c
	ADDQ.W	#8,A7			;4d8c0: 504f
LAB_4D8C2:
	CLR.L	(_measures,A4)		;4d8c2: 42ac3174
	CLR.L	(_all_sample,A4)	;4d8c6: 42ac315e
	CLR.L	(_drumkit,A4)		;4d8ca: 42ac353a
	UNLK	A5			;4d8ce: 4e5d
	RTS				;4d8d0: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_open_channels:
	LINK.W	A5,#-6			;4d8d2: 4e55fffa
	CLR.W	(-2,A5)			;4d8d6: 426dfffe
LAB_4D8DA:
	PEA	$00010001		;4d8da: 487900010001
	PEA	$44.W			;4d8e0: 48780044
	JSR	(___AllocMem,A4)	;4d8e4: 4eac8200
	ADDQ.W	#8,A7			;4d8e8: 504f
	MOVEQ	#0,D1			;4d8ea: 7200
	MOVE.W	(-2,A5),D1		;4d8ec: 322dfffe
	ASL.L	#2,D1			;4d8f0: e581
	LEA	(_ioas,A4),A0		;4d8f2: 41ec3162
	MOVE.L	D0,(0,A0,D1.L)		;4d8f6: 21801800
	BEQ.W	LAB_4D99E		;4d8fa: 670000a2
	MOVEQ	#1,D0			;4d8fe: 7001
	MOVE.W	(-2,A5),D1		;4d900: 322dfffe
	ASL.W	D1,D0			;4d904: e360
	MOVE.B	D0,(_allocationMap,A4)	;4d906: 19403172
	MOVEQ	#0,D0			;4d90a: 7000
	MOVE.W	(-2,A5),D0		;4d90c: 302dfffe
	ASL.L	#2,D0			;4d910: e580
	LEA	(_ioas,A4),A0		;4d912: 41ec3162
	MOVEA.L	(0,A0,D0.L),A1		;4d916: 22700800
	MOVE.B	#$7f,(9,A1)		;4d91a: 137c007f0009
	CLR.L	-(A7)			;4d920: 42a7
	MOVE.L	(_PortName,A4),-(A7)	;4d922: 2f2c823e
	JSR	(_CreatePort,PC)	;4d926: 4eba38dc
	ADDQ.W	#8,A7			;4d92a: 504f
	MOVE.L	D0,(-6,A5)		;4d92c: 2b40fffa
	BEQ.S	LAB_4D99E		;4d930: 676c
	MOVEQ	#0,D0			;4d932: 7000
	MOVE.W	(-2,A5),D0		;4d934: 302dfffe
	ASL.L	#2,D0			;4d938: e580
	LEA	(_ioas,A4),A0		;4d93a: 41ec3162
	MOVEA.L	(0,A0,D0.L),A1		;4d93e: 22700800
	MOVE.L	(-6,A5),($E,A1)		;4d942: 236dfffa000e
	LEA	(_allocationMap,A4),A0	;4d948: 41ec3172
	MOVEQ	#0,D0			;4d94c: 7000
	MOVE.W	(-2,A5),D0		;4d94e: 302dfffe
	ASL.L	#2,D0			;4d952: e580
	LEA	(_ioas,A4),A1		;4d954: 43ec3162
	MOVEA.L	(0,A1,D0.L),A6		;4d958: 2c710800
	MOVE.L	A0,($22,A6)		;4d95c: 2d480022
	MOVEQ	#0,D0			;4d960: 7000
	MOVE.W	(-2,A5),D0		;4d962: 302dfffe
	ASL.L	#2,D0			;4d966: e580
	LEA	(_ioas,A4),A0		;4d968: 41ec3162
	MOVEA.L	(0,A0,D0.L),A1		;4d96c: 22700800
	MOVE.L	#$00000001,($26,A1)	;4d970: 237c000000010026
	CLR.L	-(A7)			;4d978: 42a7
	MOVEQ	#0,D0			;4d97a: 7000
	MOVE.W	(-2,A5),D0		;4d97c: 302dfffe
	ASL.L	#2,D0			;4d980: e580
	LEA	(_ioas,A4),A0		;4d982: 41ec3162
	MOVE.L	(0,A0,D0.L),-(A7)	;4d986: 2f300800
	CLR.L	-(A7)			;4d98a: 42a7
	PEA	(strAudioDev,PC)	;4d98c: 487a002a
	JSR	(_OpenDevice,PC)	;4d990: 4eba39c4
	LEA	($10,A7),A7		;4d994: 4fef0010
	TST.W	D0			;4d998: 4a40
	BNE.S	LAB_4D99E		;4d99a: 6602
	BRA.S	LAB_4D9A6		;4d99c: 6008
LAB_4D99E:
	BSR.S	_close_channels		;4d99e: 6126
	MOVEQ	#0,D0			;4d9a0: 7000
LAB_4D9A2:
	UNLK	A5			;4d9a2: 4e5d
	RTS				;4d9a4: 4e75
LAB_4D9A6:
	ADDQ.W	#1,(-2,A5)		;4d9a6: 526dfffe
	CMPI.W	#$0004,(-2,A5)		;4d9aa: 0c6d0004fffe
	BNE.W	LAB_4D8DA		;4d9b0: 6600ff28
	MOVEQ	#1,D0			;4d9b4: 7001
	BRA.S	LAB_4D9A2		;4d9b6: 60ea
strAudioDev:
	;4d9b8
	;DC.B	$61,$75,$64,$69,$6f,$2e,$64,$65,$76,$69,$63,$65,$00,$00
	DC.B	"audio.device",0,0
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_close_channels:
	LINK.W	A5,#-2			;4d9c6: 4e55fffe
	CLR.W	(-2,A5)			;4d9ca: 426dfffe
LAB_4D9CE:
	MOVE.W	(-2,A5),D0		;4d9ce: 302dfffe
	EXT.L	D0			;4d9d2: 48c0
	ASL.L	#2,D0			;4d9d4: e580
	LEA	(_ioas,A4),A0		;4d9d6: 41ec3162
	TST.L	(0,A0,D0.L)		;4d9da: 4ab00800
	BEQ.W	LAB_4DA68		;4d9de: 67000088
	MOVE.W	(-2,A5),D0		;4d9e2: 302dfffe
	EXT.L	D0			;4d9e6: 48c0
	ASL.L	#2,D0			;4d9e8: e580
	LEA	(_ioas,A4),A0		;4d9ea: 41ec3162
	MOVEA.L	(0,A0,D0.L),A1		;4d9ee: 22700800
	TST.L	($E,A1)			;4d9f2: 4aa9000e
	BEQ.S	LAB_4DA3E		;4d9f6: 6746
	MOVE.W	(-2,A5),D0		;4d9f8: 302dfffe
	EXT.L	D0			;4d9fc: 48c0
	ASL.L	#2,D0			;4d9fe: e580
	LEA	(_ioas,A4),A0		;4da00: 41ec3162
	MOVEA.L	(0,A0,D0.L),A1		;4da04: 22700800
	MOVE.L	($E,A1),-(A7)		;4da08: 2f29000e
	JSR	(_DeletePort,PC)	;4da0c: 4eba3882
	ADDQ.W	#4,A7			;4da10: 584f
	MOVE.W	(-2,A5),D0		;4da12: 302dfffe
	EXT.L	D0			;4da16: 48c0
	ASL.L	#2,D0			;4da18: e580
	LEA	(_ioas,A4),A0		;4da1a: 41ec3162
	MOVEA.L	(0,A0,D0.L),A1		;4da1e: 22700800
	TST.L	($14,A1)		;4da22: 4aa90014
	BEQ.S	LAB_4DA3E		;4da26: 6716
	MOVE.W	(-2,A5),D0		;4da28: 302dfffe
	EXT.L	D0			;4da2c: 48c0
	ASL.L	#2,D0			;4da2e: e580
	LEA	(_ioas,A4),A0		;4da30: 41ec3162
	MOVE.L	(0,A0,D0.L),-(A7)	;4da34: 2f300800
	JSR	(_CloseDevice,PC)	;4da38: 4eba37ae
	ADDQ.W	#4,A7			;4da3c: 584f
LAB_4DA3E:
	PEA	$44.W			;4da3e: 48780044
	MOVE.W	(-2,A5),D0		;4da42: 302dfffe
	EXT.L	D0			;4da46: 48c0
	ASL.L	#2,D0			;4da48: e580
	LEA	(_ioas,A4),A0		;4da4a: 41ec3162
	MOVE.L	(0,A0,D0.L),-(A7)	;4da4e: 2f300800
	JSR	(___FreeMem,A4)		;4da52: 4eac820c
	ADDQ.W	#8,A7			;4da56: 504f
	MOVE.W	(-2,A5),D0		;4da58: 302dfffe
	EXT.L	D0			;4da5c: 48c0
	ASL.L	#2,D0			;4da5e: e580
	LEA	(_ioas,A4),A0		;4da60: 41ec3162
	CLR.L	(0,A0,D0.L)		;4da64: 42b00800
LAB_4DA68:
	ADDQ.W	#1,(-2,A5)		;4da68: 526dfffe
	CMPI.W	#$0004,(-2,A5)		;4da6c: 0c6d0004fffe
	BNE.W	LAB_4D9CE		;4da72: 6600ff5a
	UNLK	A5			;4da76: 4e5d
	RTS				;4da78: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_load_sound:
	LINK.W	A5,#-14			;4da7a: 4e55fff2
	PEA	$3ED.W			;4da7e: 487803ed
	MOVE.L	(8,A5),-(A7)		;4da82: 2f2d0008
	JSR	(___Open,A4)		;4da86: 4eac81e2
	ADDQ.W	#8,A7			;4da8a: 504f
	MOVE.L	D0,(-4,A5)		;4da8c: 2b40fffc
	BNE.S	LAB_4DA98		;4da90: 6606
	MOVEQ	#-1,D0			;4da92: 70ff
LAB_4DA94:
	UNLK	A5			;4da94: 4e5d
	RTS				;4da96: 4e75
LAB_4DA98:
	PEA	$80.W			;4da98: 48780080
	PEA	(_measln,A4)		;4da9c: 486c337a
	MOVE.L	(-4,A5),-(A7)		;4daa0: 2f2dfffc
	JSR	(___Read,A4)		;4daa4: 4eac81e8
	LEA	($C,A7),A7		;4daa8: 4fef000c
	PEA	2.W			;4daac: 48780002
	PEA	(_seqlen,A4)		;4dab0: 486c3378
	MOVE.L	(-4,A5),-(A7)		;4dab4: 2f2dfffc
	JSR	(___Read,A4)		;4dab8: 4eac81e8
	LEA	($C,A7),A7		;4dabc: 4fef000c
	MOVE.W	(_seqlen,A4),D0		;4dac0: 302c3378
	ASL.W	#2,D0			;4dac4: e540
	MOVEQ	#0,D1			;4dac6: 7200
	MOVE.W	D0,D1			;4dac8: 3200
	MOVE.L	D1,-(A7)		;4daca: 2f01
	PEA	(_sequn,A4)		;4dacc: 486c3178
	MOVE.L	(-4,A5),-(A7)		;4dad0: 2f2dfffc
	JSR	(___Read,A4)		;4dad4: 4eac81e8
	LEA	($C,A7),A7		;4dad8: 4fef000c
	PEA	4.W			;4dadc: 48780004
	PEA	(_measure_length,A4)	;4dae0: 486c353e
	MOVE.L	(-4,A5),-(A7)		;4dae4: 2f2dfffc
	JSR	(___Read,A4)		;4dae8: 4eac81e8
	LEA	($C,A7),A7		;4daec: 4fef000c
	CLR.L	-(A7)			;4daf0: 42a7
	PEA	$1000.W			;4daf2: 48781000
	JSR	(___AllocMem,A4)	;4daf6: 4eac8200
	ADDQ.W	#8,A7			;4dafa: 504f
	MOVE.L	D0,(_measures,A4)	;4dafc: 29403174
	BEQ.W	LAB_4DC86		;4db00: 67000184
	PEA	$1000.W			;4db04: 48781000
	MOVE.L	(_measures,A4),-(A7)	;4db08: 2f2c3174
	MOVE.L	(-4,A5),-(A7)		;4db0c: 2f2dfffc
	JSR	(___Read,A4)		;4db10: 4eac81e8
	LEA	($C,A7),A7		;4db14: 4fef000c
	CMPI.L	#$00001000,(_measure_length,A4) ;4db18: 0cac00001000353e
	BLE.S	LAB_4DB38		;4db20: 6f16
	CLR.L	-(A7)			;4db22: 42a7
	MOVEA.L	(_measure_length,A4),A0	;4db24: 206c353e
	PEA	(-4096,A0)		;4db28: 4868f000
	MOVE.L	(-4,A5),-(A7)		;4db2c: 2f2dfffc
	JSR	(___Seek,A4)		;4db30: 4eac81ee
	LEA	($C,A7),A7		;4db34: 4fef000c
LAB_4DB38:
	PEA	2.W			;4db38: 48780002
	PEA	(_no_sounds,A4)		;4db3c: 486c3542
	MOVE.L	(-4,A5),-(A7)		;4db40: 2f2dfffc
	JSR	(___Read,A4)		;4db44: 4eac81e8
	LEA	($C,A7),A7		;4db48: 4fef000c
	CLR.L	-(A7)			;4db4c: 42a7
	MOVE.W	(_no_sounds,A4),D0	;4db4e: 302c3542
	ASL.W	#3,D0			;4db52: e740
	MOVEQ	#0,D1			;4db54: 7200
	MOVE.W	D0,D1			;4db56: 3200
	MOVE.L	D1,-(A7)		;4db58: 2f01
	JSR	(___AllocMem,A4)	;4db5a: 4eac8200
	ADDQ.W	#8,A7			;4db5e: 504f
	MOVE.L	D0,(_drumkit,A4)	;4db60: 2940353a
	BEQ.W	LAB_4DC86		;4db64: 67000120
	MOVE.W	(_no_sounds,A4),D0	;4db68: 302c3542
	ASL.W	#3,D0			;4db6c: e740
	MOVEQ	#0,D1			;4db6e: 7200
	MOVE.W	D0,D1			;4db70: 3200
	MOVE.L	D1,-(A7)		;4db72: 2f01
	MOVE.L	(_drumkit,A4),-(A7)	;4db74: 2f2c353a
	MOVE.L	(-4,A5),-(A7)		;4db78: 2f2dfffc
	JSR	(___Read,A4)		;4db7c: 4eac81e8
	LEA	($C,A7),A7		;4db80: 4fef000c
	PEA	2.W			;4db84: 48780002
	PEA	(-14,A5)		;4db88: 486dfff2
	MOVE.L	(-4,A5),-(A7)		;4db8c: 2f2dfffc
	JSR	(___Read,A4)		;4db90: 4eac81e8
	LEA	($C,A7),A7		;4db94: 4fef000c
	MOVE.W	(-14,A5),D0		;4db98: 302dfff2
	ASL.W	#3,D0			;4db9c: e740
	MOVEQ	#0,D1			;4db9e: 7200
	MOVE.W	D0,D1			;4dba0: 3200
	MOVE.L	D1,-(A7)		;4dba2: 2f01
	PEA	(_sams,A4)		;4dba4: 486c33fa
	MOVE.L	(-4,A5),-(A7)		;4dba8: 2f2dfffc
	JSR	(___Read,A4)		;4dbac: 4eac81e8
	LEA	($C,A7),A7		;4dbb0: 4fef000c
	PEA	4.W			;4dbb4: 48780004
	PEA	(_all_sample_length,A4)	;4dbb8: 486c315a
	MOVE.L	(-4,A5),-(A7)		;4dbbc: 2f2dfffc
	JSR	(___Read,A4)		;4dbc0: 4eac81e8
	LEA	($C,A7),A7		;4dbc4: 4fef000c
	PEA	2.W			;4dbc8: 48780002
	MOVE.L	(_all_sample_length,A4),-(A7) ;4dbcc: 2f2c315a
	JSR	(___AllocMem,A4)	;4dbd0: 4eac8200
	ADDQ.W	#8,A7			;4dbd4: 504f
	MOVE.L	D0,(_all_sample,A4)	;4dbd6: 2940315e
	BEQ.W	LAB_4DC86		;4dbda: 670000aa
	MOVE.L	(_all_sample_length,A4),-(A7) ;4dbde: 2f2c315a
	MOVE.L	(_all_sample,A4),-(A7)	;4dbe2: 2f2c315e
	MOVE.L	(-4,A5),-(A7)		;4dbe6: 2f2dfffc
	JSR	(___Read,A4)		;4dbea: 4eac81e8
	LEA	($C,A7),A7		;4dbee: 4fef000c
	MOVE.L	(_all_sample,A4),(-12,A5) ;4dbf2: 2b6c315efff4
	CLR.L	(-8,A5)			;4dbf8: 42adfff8
	BRA.S	LAB_4DC26		;4dbfc: 6028
LAB_4DBFE:
	MOVE.L	(-8,A5),D0		;4dbfe: 202dfff8
	ASL.L	#3,D0			;4dc02: e780
	LEA	(LAB_5C7EC,A4),A0	;4dc04: 41ec33fe
	MOVE.L	(-12,A5),(0,A0,D0.L)	;4dc08: 21adfff40800
	MOVE.L	(-8,A5),D0		;4dc0e: 202dfff8
	ASL.L	#3,D0			;4dc12: e780
	LEA	(_sams,A4),A0		;4dc14: 41ec33fa
	MOVEQ	#0,D1			;4dc18: 7200
	MOVE.W	(0,A0,D0.L),D1		;4dc1a: 32300800
	ADD.L	D1,(-12,A5)		;4dc1e: d3adfff4
	ADDQ.L	#1,(-8,A5)		;4dc22: 52adfff8
LAB_4DC26:
	MOVE.W	(-14,A5),D0		;4dc26: 302dfff2
	EXT.L	D0			;4dc2a: 48c0
	MOVE.L	(-8,A5),D1		;4dc2c: 222dfff8
	CMP.L	D0,D1			;4dc30: b280
	BLT.S	LAB_4DBFE		;4dc32: 6dca
	MOVE.W	(_sequn,A4),D0		;4dc34: 302c3178
	ASL.W	#8,D0			;4dc38: e140
	MOVEQ	#0,D1			;4dc3a: 7200
	MOVE.W	D0,D1			;4dc3c: 3200
	ADD.L	(_measures,A4),D1	;4dc3e: d2ac3174
	MOVE.L	D1,(_curmeas,A4)	;4dc42: 2941354a
	CLR.W	(_curtime,A4)		;4dc46: 426c3548
	CLR.W	(_curseq,A4)		;4dc4a: 426c3544
	CLR.W	(_curbeat,A4)		;4dc4e: 426c3546
	CLR.W	(LAB_5C942,A4)		;4dc52: 426c3554
	CLR.W	(LAB_5C940,A4)		;4dc56: 426c3552
	CLR.W	(LAB_5C93E,A4)		;4dc5a: 426c3550
	CLR.W	(_Soundpri,A4)		;4dc5e: 426c354e
	PEA	2.W			;4dc62: 48780002
	PEA	(-14,A5)		;4dc66: 486dfff2
	MOVE.L	(-4,A5),-(A7)		;4dc6a: 2f2dfffc
	JSR	(___Read,A4)		;4dc6e: 4eac81e8
	LEA	($C,A7),A7		;4dc72: 4fef000c
	MOVE.L	(-4,A5),-(A7)		;4dc76: 2f2dfffc
	JSR	(___Close,A4)		;4dc7a: 4eac81d6
	ADDQ.W	#4,A7			;4dc7e: 584f
	MOVEQ	#0,D0			;4dc80: 7000
	BRA.W	LAB_4DA94		;4dc82: 6000fe10
LAB_4DC86:
	MOVE.L	(-4,A5),-(A7)		;4dc86: 2f2dfffc
	JSR	(___Close,A4)		;4dc8a: 4eac81d6
	ADDQ.W	#4,A7			;4dc8e: 584f
	MOVEQ	#-1,D0			;4dc90: 70ff
	BRA.W	LAB_4DA94		;4dc92: 6000fe00
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_kill_effect:
	LINK.W	A5,#-2			;4dc96: 4e55fffe
	MOVE.W	(8,A5),(-2,A5)		;4dc9a: 3b6d0008fffe
	BRA.S	LAB_4DCBC		;4dca0: 601a
LAB_4DCA2:
	MOVE.W	(-2,A5),D0		;4dca2: 302dfffe
	EXT.L	D0			;4dca6: 48c0
	ASL.L	#2,D0			;4dca8: e580
	LEA	(_ioas,A4),A0		;4dcaa: 41ec3162
	MOVE.L	(0,A0,D0.L),-(A7)	;4dcae: 2f300800
	JSR	(_AbortIO,PC)		;4dcb2: 4eba34de
	ADDQ.W	#4,A7			;4dcb6: 584f
	ADDQ.W	#1,(-2,A5)		;4dcb8: 526dfffe
LAB_4DCBC:
	MOVE.W	(-2,A5),D0		;4dcbc: 302dfffe
	CMP.W	($A,A5),D0		;4dcc0: b06d000a
	BLT.S	LAB_4DCA2		;4dcc4: 6ddc
	UNLK	A5			;4dcc6: 4e5d
	RTS				;4dcc8: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_check_effect:
	LINK.W	A5,#0			;4dcca: 4e550000
	MOVE.W	(8,A5),D0		;4dcce: 302d0008
	EXT.L	D0			;4dcd2: 48c0
	ASL.L	#2,D0			;4dcd4: e580
	LEA	(_ioas,A4),A0		;4dcd6: 41ec3162
	MOVE.L	(0,A0,D0.L),-(A7)	;4dcda: 2f300800
	JSR	(_CheckIO,PC)		;4dcde: 4eba34fc
	ADDQ.W	#4,A7			;4dce2: 584f
	UNLK	A5			;4dce4: 4e5d
	RTS				;4dce6: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_valid_move:
	LINK.W	A5,#0			;4dce8: 4e550000
	MOVEM.L	D1-D4/A0,-(A7)		;4dcec: 48e77880
	CLR.L	D0			;4dcf0: 4280
	MOVE.W	(8,A5),D2		;4dcf2: 342d0008
	MOVE.W	($A,A5),D3		;4dcf6: 362d000a
	BEQ.S	LAB_4DD4C		;4dcfa: 6750
	MOVE.W	D2,D4			;4dcfc: 3802
	ADD.W	D3,D4			;4dcfe: d843
	BLT.S	LAB_4DD3C		;4dd00: 6d3a
	CMP.W	#$1000,D4		;4dd02: b87c1000
	BGE.S	LAB_4DD3C		;4dd06: 6c34
	ANDI.W	#$003f,D3		;4dd08: 0243003f
	CMP.W	#$0003,D3		;4dd0c: b67c0003
	BLE.S	LAB_4DD16		;4dd10: 6f04
	ORI.W	#$ffc0,D3		;4dd12: 0043ffc0
LAB_4DD16:
	ANDI.W	#$003f,D2		;4dd16: 0242003f
	ADD.W	D2,D3			;4dd1a: d642
	BLT.S	LAB_4DD3C		;4dd1c: 6d1e
	CMP.W	#$003f,D3		;4dd1e: b67c003f
	BGT.S	LAB_4DD3C		;4dd22: 6e18
	LEA	_map_blk,A0		;4dd24: 41f900056376
	EXT.L	D4			;4dd2a: 48c4
	ADDA.L	D4,A0			;4dd2c: d1c4
	CMPI.B	#$00,(A0)		;4dd2e: 0c100000
	BEQ.S	LAB_4DD48		;4dd32: 6714
	CMPI.B	#$2f,(A0)		;4dd34: 0c10002f
	BEQ.S	LAB_4DD42		;4dd38: 6708
	BRA.S	LAB_4DD4C		;4dd3a: 6010
LAB_4DD3C:
	MOVE.W	#$0001,D0		;4dd3c: 303c0001
	BRA.S	LAB_4DD4C		;4dd40: 600a
LAB_4DD42:
	MOVE.W	#$0002,D0		;4dd42: 303c0002
	BRA.S	LAB_4DD4C		;4dd46: 6004
LAB_4DD48:
	MOVE.W	#$0003,D0		;4dd48: 303c0003
LAB_4DD4C:
	MOVEM.L	(A7)+,D1-D4/A0		;4dd4c: 4cdf011e
	UNLK	A5			;4dd50: 4e5d
	TST.W	D0			;4dd52: 4a40
	RTS				;4dd54: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_check_life:
	LINK.W	A5,#0			;4dd56: 4e550000
	MOVEM.L	D1-D6/A0-A2,-(A7)	;4dd5a: 48e77ee0
	MOVE.W	(8,A5),D6		;4dd5e: 3c2d0008
	ADDI.W	#$001f,D6		;4dd62: 0646001f
	MOVE.W	($A,A5),D2		;4dd66: 342d000a
	CLR.W	D4			;4dd6a: 4244
	CLR.W	_all_of_city		;4dd6c: 42790005c3e6
	LEA	_offset_vector,A2	;4dd72: 45f90005181a
	LEA	_map_blk,A0		;4dd78: 41f900056376
	LEA	_map_bk2,A1		;4dd7e: 43f900058376
	CLR.W	D5			;4dd84: 4245
	CLR.W	_a_flat_block		;4dd86: 42790005c3a0
LAB_4DD8C:
	MOVE.W	(A2)+,D3		;4dd8c: 361a
	MOVE.W	D3,-(A7)		;4dd8e: 3f03
	MOVE.W	D2,-(A7)		;4dd90: 3f02
	JSR	_valid_move		;4dd92: 4eb90004dce8
	ADDA.L	#$00000004,A7		;4dd98: dffc00000004
	TST.W	D0			;4dd9e: 4a40
	BEQ.S	LAB_4DDB0		;4dda0: 670e
	CMP.W	#$0002,D0		;4dda2: b07c0002
	BNE.W	LAB_4DE2A		;4dda6: 66000082
	ADDI.W	#$fff1,D4		;4ddaa: 0644fff1
	BRA.S	LAB_4DE2A		;4ddae: 607a
LAB_4DDB0:
	ADD.W	D2,D3			;4ddb0: d642
	CMP.B	(0,A0,D3.W),D6		;4ddb2: bc303000
	BEQ.W	LAB_4DDCC		;4ddb6: 67000014
	CMPI.B	#$0f,(0,A0,D3.W)	;4ddba: 0c30000f3000
	BNE.W	LAB_4DDDA		;4ddc0: 66000018
	MOVE.W	#$0001,_a_flat_block	;4ddc4: 33fc00010005c3a0
LAB_4DDCC:
	TST.W	D4			;4ddcc: 4a44
	BNE.S	LAB_4DDD4		;4ddce: 6604
	MOVE.W	#$0032,D4		;4ddd0: 383c0032
LAB_4DDD4:
	ADDI.W	#$000f,D4		;4ddd4: 0644000f
	BRA.S	LAB_4DDE8		;4ddd8: 600e
LAB_4DDDA:
	TST.W	D5			;4ddda: 4a45
	BNE.S	LAB_4DDE8		;4dddc: 660a
	MOVEM.L	(A7)+,D1-D6/A0-A2	;4ddde: 4cdf077e
	UNLK	A5			;4dde2: 4e5d
	CLR.W	D0			;4dde4: 4240
	RTS				;4dde6: 4e75
LAB_4DDE8:
	MOVE.B	(0,A1,D3.W),D1		;4dde8: 12313000
	CMP.W	#$0009,D5		;4ddec: ba7c0009
	BGE.S	LAB_4DE10		;4ddf0: 6c1e
	CMPI.B	#$2a,(0,A1,D2.W)	;4ddf2: 0c31002a2000
	BNE.S	LAB_4DE10		;4ddf8: 6616
	CMP.B	#$29,D1			;4ddfa: b23c0029
	BLT.S	LAB_4DE10		;4ddfe: 6d10
	CMP.B	#$2c,D1			;4de00: b23c002c
	BGT.S	LAB_4DE10		;4de04: 6e0a
	ADDI.W	#$0001,_all_of_city	;4de06: 067900010005c3e6
	BRA.S	LAB_4DE2A		;4de0e: 601a
LAB_4DE10:
	TST.W	D5			;4de10: 4a45
	BEQ.S	LAB_4DE2A		;4de12: 6716
	CMP.B	#$20,D1			;4de14: b23c0020
	BLE.S	LAB_4DE2A		;4de18: 6f10
	CMP.B	#$2c,D1			;4de1a: b23c002c
	BGT.S	LAB_4DE2A		;4de1e: 6e0a
	MOVEM.L	(A7)+,D1-D6/A0-A2	;4de20: 4cdf077e
	UNLK	A5			;4de24: 4e5d
	CLR.W	D0			;4de26: 4240
	RTS				;4de28: 4e75
LAB_4DE2A:
	ADDI.W	#$0001,D5		;4de2a: 06450001
	CMP.W	#$0011,D5		;4de2e: ba7c0011
	BNE.W	LAB_4DD8C		;4de32: 6600ff58
	CMP.W	#$0023,D4		;4de36: b87c0023
	BGE.W	LAB_4DE40		;4de3a: 6c000004
	CLR.W	D4			;4de3e: 4244
LAB_4DE40:
	CMP.W	#$0131,D4		;4de40: b87c0131
	BNE.W	LAB_4DE4C		;4de44: 66000006
	MOVE.W	#$0bea,D4		;4de48: 383c0bea
LAB_4DE4C:
	MOVE.W	D4,D0			;4de4c: 3004
	MOVEM.L	(A7)+,D1-D6/A0-A2	;4de4e: 4cdf077e
	UNLK	A5			;4de52: 4e5d
	RTS				;4de54: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_long_asc:
	LINK.W	A5,#0			;4de56: 4e550000
	MOVEM.L	D0-D1/A0,-(A7)		;4de5a: 48e7c080
	MOVE.L	($C,A5),D0		;4de5e: 202d000c
	BRA.S	LAB_4DE86		;4de62: 6022
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_word_asc:
	LINK.W	A5,#0			;4de64: 4e550000
	MOVEM.L	D0-D1/A0,-(A7)		;4de68: 48e7c080
	MOVE.W	($C,A5),D0		;4de6c: 302d000c
	EXT.L	D0			;4de70: 48c0
	BRA.S	LAB_4DE86		;4de72: 6012
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_uword_asc:
	LINK.W	A5,#0			;4de74: 4e550000
	MOVEM.L	D0-D1/A0,-(A7)		;4de78: 48e7c080
	MOVE.W	($C,A5),D0		;4de7c: 302d000c
	ANDI.L	#$0000ffff,D0		;4de80: 02800000ffff
LAB_4DE86:
	MOVEA.L	(8,A5),A0		;4de86: 206d0008
	TST.L	D0			;4de8a: 4a80
	BEQ.S	LAB_4DEBC		;4de8c: 672e
	BGE.S	LAB_4DE96		;4de8e: 6c06
	MOVE.B	#$2d,(A0)+		;4de90: 10fc002d
	NEG.L	D0			;4de94: 4480
LAB_4DE96:
	CLR.W	D1			;4de96: 4241
LAB_4DE98:
	DIVU	#$000a,D0		;4de98: 80fc000a
	TST.L	D0			;4de9c: 4a80
	BEQ.S	LAB_4DEAC		;4de9e: 670c
	SWAP	D0			;4dea0: 4840
	MOVE.W	D0,-(A7)		;4dea2: 3f00
	ADDQ.W	#1,D1			;4dea4: 5241
	CLR.W	D0			;4dea6: 4240
	SWAP	D0			;4dea8: 4840
	BRA.S	LAB_4DE98		;4deaa: 60ec
LAB_4DEAC:
	TST.W	D1			;4deac: 4a41
	BEQ.S	LAB_4DEC0		;4deae: 6710
	SUBQ.W	#1,D1			;4deb0: 5341
	MOVE.W	(A7)+,D0		;4deb2: 301f
	ADDI.B	#$30,D0			;4deb4: 06000030
	MOVE.B	D0,(A0)+		;4deb8: 10c0
	BRA.S	LAB_4DEAC		;4deba: 60f0
LAB_4DEBC:
	MOVE.B	#$30,(A0)+		;4debc: 10fc0030
LAB_4DEC0:
	MOVE.B	#$00,(A0)		;4dec0: 10bc0000
	MOVEM.L	(A7)+,D0-D1/A0		;4dec4: 4cdf0103
	UNLK	A5			;4dec8: 4e5d
	RTS				;4deca: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_compress:
	LINK.W	A5,#0			;4decc: 4e550000
	MOVEM.L	D1/A0,-(A7)		;4ded0: 48e74080
	MOVEA.L	(8,A5),A0		;4ded4: 206d0008
	MOVE.B	(A0)+,D0		;4ded8: 1018
	ANDI.L	#$0000000f,D0		;4deda: 02800000000f
	MOVE.W	#$000c,D1		;4dee0: 323c000c
	LSL.W	D1,D0			;4dee4: e368
	MOVE.B	(A0)+,D1		;4dee6: 1218
	ANDI.L	#$0000003f,D1		;4dee8: 02810000003f
	LSL.W	#6,D1			;4deee: ed49
	OR.W	D1,D0			;4def0: 8041
	MOVE.B	(A0),D1			;4def2: 1210
	ANDI.L	#$0000003f,D1		;4def4: 02810000003f
	OR.W	D1,D0			;4defa: 8041
	MOVEM.L	(A7)+,D1/A0		;4defc: 4cdf0102
	UNLK	A5			;4df00: 4e5d
	RTS				;4df02: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_decompress:
	LINK.W	A5,#0			;4df04: 4e550000
	MOVEM.L	D1/A0,-(A7)		;4df08: 48e74080
	MOVEA.L	(8,A5),A0		;4df0c: 206d0008
	MOVE.W	($C,A5),D0		;4df10: 302d000c
	MOVE.W	D0,D1			;4df14: 3200
	ANDI.W	#$003f,D1		;4df16: 0241003f
	MOVE.B	D1,(2,A0)		;4df1a: 11410002
	LSR.W	#6,D0			;4df1e: ec48
	MOVE.W	D0,D1			;4df20: 3200
	ANDI.W	#$003f,D1		;4df22: 0241003f
	MOVE.B	D1,(1,A0)		;4df26: 11410001
	LSR.W	#6,D0			;4df2a: ec48
	ANDI.W	#$000f,D0		;4df2c: 0240000f
	MOVE.B	D0,(A0)			;4df30: 1080
	MOVEM.L	(A7)+,D1/A0		;4df32: 4cdf0102
	UNLK	A5			;4df36: 4e5d
	RTS				;4df38: 4e75
	DS.W	1			;4df3a
strsendMessage:
	;4df3c
	;DC.B	$53,$45,$4e,$44,$20,$41,$20,$4d,$45,$53,$53,$41,$47,$45,$00
	DC.B	"SEND A MESSAGE",0
strMessageGood:
	;4df4b
	;DC.B	$4d,$45,$53,$53,$41,$47,$45,$20,$46,$52,$4f,$4d,$20,$47,$4f,$4f
	;DC.B	$44,$00
	DC.B	"MESSAGE FROM GOOD",0
strMessageEvil:
	;4df5d
	;DC.B	$4d,$45,$53,$53,$41,$47,$45,$20,$46,$52,$4f,$4d,$20,$45,$56,$49
	;DC.B	$4c,$00
	DC.B	"MESSAGE FROM EVIL",0
strTwoPlayerSer:
	;4df6f
	;DC.B	$4f,$4e,$20,$54,$57,$4f,$20,$50,$4c,$41,$59,$45,$52,$20,$53,$45
	;DC.B	$52,$49,$41,$4c,$20,$47,$41,$4d,$45,$0a,$53,$57,$49,$54,$43,$48
	;DC.B	$49,$4e,$47,$20,$42,$41,$43,$4b,$20,$54,$4f,$20,$4f,$4e,$45,$0a
	;DC.B	$20,$50,$4c,$41,$59,$45,$52,$20,$47,$41,$4d,$45,$20,$49,$4e,$20
	;DC.B	$50,$41,$55,$53,$45,$00
	DC.B	"ON TWO PLAYER SERIAL GAME",$A
	DC.B	"SWITCHING BACK TO ONE",$A
	DC.B	" PLAYER GAME IN PAUSE",0
strOnePlayerSave:
	;4dfb5
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$53,$41,$56,$45,$44,$20,$48,$49,$53,$0a,$47,$41,$4d,$45,$20
	;DC.B	$44,$4f,$20,$59,$4f,$55,$20,$57,$41,$4e,$54,$20,$54,$4f,$20,$53
	;DC.B	$41,$56,$45,$0a,$59,$4f,$55,$52,$20,$47,$41,$4d,$45,$20,$4e,$4f
	;DC.B	$57,$20,$41,$53,$20,$57,$45,$4c,$4c,$00
	DC.B	"OTHER PLAYER HAS SAVED HIS",$A
	DC.B	"GAME DO YOU WANT TO SAVE",$A
	DC.B	"YOUR GAME NOW AS WELL",0
strOtherChangeOpt:
	;4dfff
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$43,$48,$41,$4e,$47,$45,$44,$0a,$47,$41,$4d,$45,$20,$4f,$50
	;DC.B	$54,$49,$4f,$4e,$53,$00
	DC.B	"OTHER PLAYER HAS CHANGED",$A
	DC.B	"GAME OPTIONS",0
strOtherPaint:
	;4e025
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$53,$45,$4c,$45,$43,$54,$45,$44,$0a,$50,$41,$49,$4e,$54,$20
	;DC.B	$4d,$4f,$44,$45,$00
	DC.B	"OTHER PLAYER HAS SELECTED",$A
	DC.B	"PAINT MODE",0
strOtherSides:
	;4e04a
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$43,$48,$41,$4e,$47,$45,$44,$0a,$53,$49,$44,$45,$53,$00
	DC.B	"OTHER PLAYER HAS CHANGED",$A
	DC.B	"SIDES",0
strOtherChangeHisOpts:
	;4e069
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$43,$48,$41,$4e,$47,$45,$44,$0a,$48,$49,$53,$20,$4f,$50,$54
	;DC.B	$49,$4f,$4e,$53,$00
	DC.B	"OTHER PLAYER HAS CHANGED",$A
	DC.B	"HIS OPTIONS",0
strOtherChangeYourOpt:
	;4e08e
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$43,$48,$41,$4e,$47,$45,$44,$0a,$59,$4f,$55,$52,$20,$4f,$50
	;DC.B	$54,$49,$4f,$4e,$53,$00
	DC.B	"OTHER PLAYER HAS CHANGED",$A
	DC.B	"YOUR OPTIONS",0
strOtherAssistOn:
	;4e0b4
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$53,$45,$4c,$45,$43,$54,$45,$44,$0a,$43,$4f,$4d,$50,$55,$54
	;DC.B	$45,$52,$20,$41,$53,$53,$49,$53,$54,$41,$4e,$43,$45,$00
	DC.B	"OTHER PLAYER HAS SELECTED",$A
	DC.B	"COMPUTER ASSISTANCE",0
strOtherAssistOff:
	;4e0e2
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$54,$55,$52,$4e,$45,$44,$20,$4f,$46,$46,$0a,$43,$4f,$4d,$50
	;DC.B	$55,$54,$45,$52,$20,$41,$53,$53,$49,$53,$54,$41,$4e,$43,$45,$00
	DC.B	"OTHER PLAYER HAS TURNED OFF",$A
	DC.B	"COMPUTER ASSISTANCE",0
strOtherPlanerGone:
	;4e112
	;DC.B	$4f,$54,$48,$45,$52,$20,$50,$4c,$41,$59,$45,$52,$20,$48,$41,$53
	;DC.B	$20,$47,$4f,$4e,$45,$20,$4f,$46,$46,$0a,$4c,$49,$4e,$45,$2c,$20
	;DC.B	$4e,$4f,$57,$20,$49,$4e,$20,$4f,$4e,$45,$20,$50,$4c,$41,$59,$45
	;DC.B	$52,$00
	DC.B	"OTHER PLAYER HAS GONE OFF",$A
	DC.B	"LINE, NOW IN ONE PLAYER",0
strSerialIOAbort:
	;4e144
	;DC.B	$53,$45,$52,$49,$41,$4c,$20,$49,$4f,$20,$41,$42,$4f,$52,$54,$45
	;DC.B	$44,$00
	DC.B	"SERIAL IO ABORTED",0
strSerialChecksumErr:
	;4e156
	;DC.B	$53,$45,$52,$49,$41,$4c,$20,$43,$48,$45,$43,$4b,$53,$55,$4d,$20
	;DC.B	$45,$52,$52,$4f,$52,$00
	DC.B	"SERIAL CHECKSUM ERROR",0
strIncompatLandscap:
	;4e16c
	;DC.B	$49,$4e,$43,$4f,$4d,$50,$41,$54,$41,$42,$4c,$45,$20,$4c,$41,$4e
	;DC.B	$44,$53,$43,$41,$50,$45,$20,$45,$52,$52,$4f,$52,$00
	DC.B	"INCOMPATABLE LANDSCAPE ERROR",0
strInsertDisk:
	;4e189
	;DC.B	$49,$4e,$53,$45,$52,$54,$20,$54,$48,$45,$20,$4f,$52,$49,$47,$49
	;DC.B	$4e,$41,$4c,$0a,$50,$4f,$50,$55,$4c,$4f,$55,$53,$20,$44,$49,$53
	;DC.B	$4b,$20,$49,$4e,$20,$44,$46,$30,$3a,$00,$00
	DC.B	"INSERT THE ORIGINAL",$A
	DC.B	"POPULOUS DISK IN DF0:",0,0
strGrassPlanes:
	;4e1b4
	;DC.B	$47,$52,$41,$53,$53,$20,$50,$4c,$41,$4e,$45,$53,$00
	DC.B	"GRASS PLANES",0
strDesert:
	;4e1c1
	;DC.B	$44,$45,$53,$45,$52,$54,$00
	DC.B	"DESERT",0
strSnowAndIce:
	;4e1c8
	;DC.B	$53,$4e,$4f,$57,$20,$41,$4e,$44,$20,$49,$43,$45,$00
	DC.B	"SNOW AND ICE",0
strRocky:
	;4e1d5
	;DC.B	$52,$4f,$43,$4b,$59,$00
	DC.B	"ROCKY",0
strVerySlow:
	;4e1db
	;DC.B	$56,$45,$52,$59,$20,$53,$4c,$4f,$57,$00
	DC.B	"VERY SLOW",0
strSlow:
	;4e1e5
	;DC.B	$53,$4c,$4f,$57,$00
	DC.B	"SLOW",0
strMedium:
	;4e1ea
	;DC.B	$4d,$45,$44,$49,$55,$4d,$00
	DC.B	"MEDIUM",0
strFast:
	;4e1f1
	;DC.B	$46,$41,$53,$54,$00
	DC.B	"FAST",0
strVeryFast:
	;4e1f6
	;DC.B	$56,$45,$52,$59,$20,$46,$41,$53,$54,$00
	DC.B	"VERY FAST",0
strVeryPoor:
	;4e200
	;DC.B	$56,$45,$52,$59,$20,$50,$4f,$4f,$52,$00
	DC.B	"VERY POOR",0
strPoor:
	;4e20a
	;DC.B	$50,$4f,$4f,$52,$00
	DC.B	"POOR",0
strAverage:
	;4e20f
	;DC.B	$41,$56,$45,$52,$41,$47,$45,$00
	DC.B	"AVERAGE",0
strGood3:
	;4e217
	;DC.B	$47,$4f,$4f,$44,$00
	DC.B	"GOOD",0
strVeryGood:
	;4e21c
	;DC.B	$56,$45,$52,$59,$20,$47,$4f,$4f,$44,$00
	DC.B	"VERY GOOD",0
strCannotBeBuilt:
	;4e226
	;DC.B	$43,$41,$4e,$4e,$4f,$54,$20,$42,$45,$20,$42,$55,$49,$4c,$54,$00
	DC.B	"CANNOT BE BUILT",0
strBuiltOnTowns:
	;4e236
	;DC.B	$42,$55,$49,$4c,$54,$20,$4a,$55,$53,$54,$20,$4f,$4e,$20,$54,$4f
	;DC.B	$57,$4e,$53,$00
	DC.B	"BUILT JUST ON TOWNS",0
strOnlyBuiltUp:
	;4e24a
	;DC.B	$4f,$4e,$4c,$59,$20,$42,$55,$49,$4c,$54,$20,$55,$50,$00
	DC.B	"ONLY BUILT UP",0
strBuiltOnPeople:
	;4e258
	;DC.B	$42,$55,$49,$4c,$54,$20,$4f,$4e,$20,$50,$45,$4f,$50,$4c,$45,$00
	DC.B	"BUILT ON PEOPLE",0
strShallow:
	;4e268
	;DC.B	$53,$48,$41,$4c,$4c,$4f,$57,$00
	DC.B	"SHALLOW",0
strBottomless:
	;4e270
	;DC.B	$42,$4f,$54,$54,$4f,$4d,$4c,$45,$53,$53,$00
	DC.B	"BOTTOMLESS",0
strHarmful:
	;4e27b
	;DC.B	$48,$41,$52,$4d,$46,$55,$4c,$00
	DC.B	"HARMFUL",0
strFatal:
	;4e283
	;DC.B	$46,$41,$54,$41,$4c,$00
	DC.B	"FATAL",0
strYes:
	DC.B	$59			;4e289
	DC.W	$4553			;4e28a
	DS.B	1			;4e28c
strNo:
	DC.B	$4e			;4e28d
	DC.W	$4f00			;4e28e
strMortal:
	;4e290
	;DC.B	$4d,$4f,$52,$54,$41,$4c,$00
	DC.B	"MORTAL",0
strImmortal:
	;4e297
	;DC.B	$49,$4d,$4d,$4f,$52,$54,$41,$4c,$00
	DC.B	"IMMORTAL",0
strEternal:
	;4e2a0
	;DC.B	$45,$54,$45,$52,$4e,$41,$4c,$00
	DC.B	"ETERNAL",0
strDeva:
	;4e2a8
	;DC.B	$44,$45,$56,$41,$00
	DC.B	"DEVA",0
strGreaterBeing:
	;4e2ad
	;DC.B	$47,$52,$45,$41,$54,$45,$52,$20,$42,$45,$49,$4e,$47,$00
	DC.B	"GREATER BEING",0
strDeity:
	;4e2bb
	;DC.B	$44,$45,$49,$54,$59,$00
	DC.B	"DEITY",0
strGreaterDeity:
	;4e2c1
	;DC.B	$47,$52,$45,$41,$54,$45,$52,$20,$44,$45,$49,$54,$59,$00
	DC.B	"GREATER DEITY",0
strMortalGod:
	;4e2cf
	;DC.B	$4d,$4f,$52,$54,$41,$4c,$20,$47,$4f,$44,$00
	DC.B	"MORTAL GOD",0
strGreaterGod:
	;4e2da
	;DC.B	$47,$52,$45,$41,$54,$45,$52,$20,$47,$4f,$44,$00
	DC.B	"GREATER GOD",0
strEternalGod:
	;4e2e6
	;DC.B	$45,$54,$45,$52,$4e,$41,$4c,$20,$47,$4f,$44,$00
	DC.B	"ETERNAL GOD",0
strWellDone:
	;4e2f2
	;DC.B	$57,$45,$4c,$4c,$20,$44,$4f,$4e,$45,$20,$00
	DC.B	"WELL DONE ",0
strYouConquered:
	;4e2fd
	;DC.B	$20,$59,$4f,$55,$20,$43,$4f,$4e,$51,$55,$45,$52,$45,$44,$20,$00
	DC.B	" YOU CONQUERED ",0
strNowBattleAt:
	;4e30d
	;DC.B	$20,$4e,$4f,$57,$20,$42,$41,$54,$54,$4c,$45,$20,$41,$54,$20,$00
	DC.B	" NOW BATTLE AT ",0
strWellDoneConq:
	;4e31d
	;DC.B	$57,$45,$4c,$4c,$20,$44,$4f,$4e,$45,$20,$59,$4f,$55,$20,$48,$41
	;DC.B	$56,$45,$20,$43,$4f,$4e,$51,$55,$45,$52,$45,$44,$20,$45,$56,$49
	;DC.B	$4c,$00
	DC.B	"WELL DONE YOU HAVE CONQUERED EVIL",0
strBattleOverTry:
; THE BATTLE IS OVER BUT TRY SHISODING ( = genesis)
	;4e33f
	;DC.B	$54,$48,$45,$20,$42,$41,$54,$54,$4c,$45,$20,$49,$53,$20,$4f,$56
	;DC.B	$45,$52,$20,$42,$55,$54,$20,$54,$52,$59,$20,$00,$00
	DC.B	"THE BATTLE IS OVER BUT TRY ",0,0
; ------------------------------------------------------------------------------
; Strings here used for map names
; ------------------------------------------------------------------------------
strRING:
	;4e35c
	;DC.B	$52,$49,$4e,$47,$00
	DC.B	"RING",0
strVERY:
	;4e361
	;DC.B	$56,$45,$52,$59,$00
	DC.B	"VERY",0
strKILL:
	;4e366
	;DC.B	$4b,$49,$4c,$4c,$00
	DC.B	"KILL",0
strSHAD:
	;4e36b
	;DC.B	$53,$48,$41,$44,$00
	DC.B	"SHAD",0
strHURT:
	;4e370
	;DC.B	$48,$55,$52,$54,$00
	DC.B	"HURT",0
strWEAV:
	;4e375
	;DC.B	$57,$45,$41,$56,$00
	DC.B	"WEAV",0
strMIN:
	DC.L	$4d494e00		;4e37a
strEOA:
	DC.L	$454f4100		;4e37e
strCOR:
	DC.L	$434f5200		;4e382
strJOS:
	DC.L	$4a4f5300		;4e386
strALP:
	DC.L	$414c5000		;4e38a
strHAM2:
	DC.L	$48414d00		;4e38e
strBUR:
	DC.L	$42555200		;4e392
strBIN:
	DC.L	$42494e00		;4e396
strTIM:
	DC.L	$54494d00		;4e39a
strBAD:
	DC.L	$42414400		;4e39e
strFUT:
	DC.L	$46555400		;4e3a2
strMOR:
	DC.L	$4d4f5200		;4e3a6
strSAD:
	DC.L	$53414400		;4e3aa
strCAL:
	DC.L	$43414c00		;4e3ae
strIMM:
	DC.L	$494d4d00		;4e3b2
strSUZ:
	DC.L	$53555a00		;4e3b6
strNIM:
	DC.L	$4e494d00		;4e3ba
strLOW:
	DC.L	$4c4f5700		;4e3be
strSCO:
	DC.L	$53434f00		;4e3c2
strHOB:
	DC.L	$484f4200		;4e3c6
strDOU:
	DC.L	$444f5500		;4e3ca
strBIL:
	DC.L	$42494c00		;4e3ce
strQAZ2:
	DC.L	$51415a00		;4e3d2
strSWA:
	DC.L	$53574100		;4e3d6
strBUG:
	DC.L	$42554700		;4e3da
strSHI:
	DC.L	$53484900		;4e3de
strHILL:
	;4e3e2
	;DC.B	$48,$49,$4c,$4c,$00
	DC.B	"HILL",0
strTORY:
	;4e3e7
	;DC.B	$54,$4f,$52,$59,$00
	DC.B	"TORY",0
strHOLE:
	;4e3ec
	;DC.B	$48,$4f,$4c,$45,$00
	DC.B	"HOLE",0
strPERT:
	;4e3f1
	;DC.B	$50,$45,$52,$54,$00
	DC.B	"PERT",0
strMAR:
	DC.L	$4d415200		;4e3f6
strCON:
	DC.L	$434f4e00		;4e3fa
strLOW2:
	DC.L	$4c4f5700		;4e3fe
strDOR:
	DC.L	$444f5200		;4e402
strLIN:
	DC.L	$4c494e00		;4e406
strING:
	DC.L	$494e4700		;4e40a
strHAM:
	DC.L	$48414d00		;4e40e
strOLD:
	DC.L	$4f4c4400		;4e412
strPIL:
	DC.L	$50494c00		;4e416
strBAR:
	DC.L	$42415200		;4e41a
strMET:
	DC.L	$4d455400		;4e41e
strEND:
	DC.L	$454e4400		;4e422
strLAS:
	DC.L	$4c415300		;4e426
strOUT:
	DC.L	$4f555400		;4e42a
strLUG:
	DC.L	$4c554700		;4e42e
strILL:
	DC.L	$494c4c00		;4e432
strICK:
	DC.L	$49434b00		;4e436
strPAL:
	DC.L	$50414c00		;4e43a
strDON:
	DC.L	$444f4e00		;4e43e
strORD:
	DC.L	$4f524400		;4e442
strOND:
	DC.L	$4f4e4400		;4e446
strBOY:
	DC.L	$424f5900		;4e44a
strJOB:
	DC.L	$4a4f4200		;4e44e
strER:
	DC.W	$4552			;4e452
	DS.B	1			;4e454
strED:
	DC.B	$45			;4e455
	DC.W	$4400			;4e456
strME:
	DC.W	$4d45			;4e458
	DS.B	1			;4e45a
strAL:
	DC.B	$41			;4e45b
	DC.W	$4c00			;4e45c
strT:
	DC.W	$5400			;4e45e
strOUT2:
	DC.L	$4f555400		;4e460
strQAZ:
	DC.L	$51415a00		;4e464
strING2:
	DC.L	$494e4700		;4e468
strOGO:
	DC.L	$4f474f00		;4e46c
strQUE:
	DC.L	$51554500		;4e470
strLOP:
	DC.L	$4c4f5000		;4e474
strSOD:
	DC.L	$534f4400		;4e478
strHIP:
	DC.L	$48495000		;4e47c
strKOP:
	DC.L	$4b4f5000		;4e480
strWIL:
	DC.L	$57494c00		;4e484
strIKE:
	DC.L	$494b4500		;4e488
strDIE:
	DC.L	$44494500		;4e48c
strIN:
	DC.W	$494e			;4e490
	DS.B	1			;4e492
strAS:
	DC.B	$41			;4e493
	DC.W	$5300			;4e494
strMP:
	DC.W	$4d50			;4e496
	DS.B	1			;4e498
strDI:
	DC.B	$44			;4e499
	DC.W	$4900			;4e49a
strOZ:
	DC.W	$4f5a			;4e49c
	DS.B	1			;4e49e
strEA:
	DC.B	$45			;4e49f
	DC.W	$4100			;4e4a0
strUS:
	DC.W	$5553			;4e4a2
	DS.B	1			;4e4a4
strGB:
	DC.B	$47			;4e4a5
	DC.W	$4200			;4e4a6
strCE:
	DC.W	$4345			;4e4a8
	DS.B	1			;4e4aa
strME2:
	DC.B	$4d			;4e4ab
	DC.W	$4500			;4e4ac
strDE:
	DC.W	$4445			;4e4ae
	DS.B	1			;4e4b0
strPE:
	DC.B	$50			;4e4b1
	DC.W	$4500			;4e4b2
strOX:
	DC.W	$4f58			;4e4b4
	DS.B	1			;4e4b6
strA:
	DC.B	$41			;4e4b7
	DS.B	1			;4e4b8
strE:
	DC.B	$45			;4e4b9
	DS.B	1			;4e4ba
strI:
	DC.B	$49			;4e4bb
	DS.B	1			;4e4bc
strO:
	DC.B	$4f			;4e4bd
	DS.B	1			;4e4be
strU:
	DC.B	$55			;4e4bf
	DS.B	1			;4e4c0
strT2:
	DC.B	$54			;4e4c1
	DS.B	1			;4e4c2
strY:
	DC.B	$59			;4e4c3
	DS.W	1			;4e4c4
_icon_data:
	DC.L	$ffbeff7f,$00800000,$ff7efebf,$01400000 ;4e4c6
	DC.L	$fefefdbf,$02400000,$febefd67,$02980000 ;4e4d6
	DC.L	$fd66fe9f,$01600000,$ff9efe7f,$01800000 ;4e4e6
	DC.L	$fe7ef9ff,$06000000,$f97ee6ff,$19000000 ;4e4f6
	DC.L	$e77efeff,$01000000,$ff7efeff,$01000000 ;4e506
	DC.L	$ff7efeff,$01000000,$ff7efeff,$01000000 ;4e516
	DC.L	$ff7efeff,$01000000,$ff7efeff,$01000000 ;4e526
	DC.L	$fffeffff		;4e536
	DS.L	1			;4e53a
	DC.L	$0000ffff		;4e53e
	DS.L	1			;4e542
	DC.L	$fffeffff		;4e546
	DS.L	1			;4e54a
	DC.L	$fffeffff		;4e54e
	DS.L	1			;4e552
	DC.L	$fffeffff		;4e556
	DS.L	1			;4e55a
	DC.L	$ffffffff,$80010000,$fffece73,$4db2300c ;4e55e
	DC.L	$fffef00f,$17e80810,$df3ae007,$1ff80000 ;4e56e
	DC.L	$bef8c003,$3ffc0000,$b7e8ca53,$318c0000 ;4e57e
	DC.L	$dbd2e007,$11880420,$e5a6f19f,$0a400000 ;4e58e
	DC.L	$e3e6f40f,$0bd00000,$f42efbdf,$04200000 ;4e59e
	DC.L	$fa1efdbf,$02400000,$fdbeffff ;4e5ae
	DS.L	1			;4e5ba
	DC.L	$0000ffff		;4e5be
	DS.L	1			;4e5c2
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e5c6
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e5d6
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e5e6
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e5f6
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e606
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e616
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e626
	DC.L	$80000000,$0000ffff,$00007fff,$7fff8000 ;4e636
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e646
	DC.L	$81800000,$0000ffff,$83e00200,$0200fdff ;4e656
	DC.L	$9ff800c0,$00c0ff3f,$bf9f0de0,$0de0f21f ;4e666
	DC.L	$bdbf02e0,$02e0fd1f,$9f3f0e7f,$0e7ff100 ;4e676
	DC.L	$9e1f017f,$017ffe00,$8f0006bf,$06bff900 ;4e686
	DC.L	$8e0001df,$01dffe00,$87c00340,$0340fc80 ;4e696
	DC.L	$87000000,$0000ff3f,$80000000,$0000fcff ;4e6a6
	DC.L	$80000000,$0000ffff,$00007fff,$7fff8000 ;4e6b6
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e6c6
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e6d6
	DC.L	$82c003a0,$0020fc1f,$85400590,$0210f80f ;4e6e6
	DC.L	$82400b90,$0410f00f,$8b600a90,$0410f00f ;4e6f6
	DC.L	$8d600e90,$0000f00f,$82c00d30,$0810f00f ;4e706
	DC.L	$800006e0,$06a0f81f,$80000180,$0180fe7f ;4e716
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e726
	DC.L	$80000000,$0000ffff,$00007fff,$7fff8000 ;4e736
	DC.L	$80100008,$0008fff7,$80380004,$0004fffb ;4e746
	DC.L	$807c0012,$0012ffec,$807c000e,$000efff0 ;4e756
	DC.L	$80f0003e,$003effc0,$81e800be,$00beff40 ;4e766
	DC.L	$81f0007c,$007cff81,$81a000f8,$00f8ff03 ;4e776
	DC.L	$834001e0,$01e0fe07,$878001c0,$01c0fe0f ;4e786
	DC.L	$87000300,$0300fc3f,$8e000600,$0600f8ff ;4e796
	DC.L	$88000400,$0400f9ff,$90000800,$0800f3ff ;4e7a6
	DC.L	$80000000,$0000ffff,$00007fff,$7fff8000 ;4e7b6
	DC.L	$80030001,$0001fffe,$80060003,$0003fffc ;4e7c6
	DC.L	$800c0006,$0006fff8,$8018000c,$000cfff1 ;4e7d6
	DC.L	$80300018,$0018ffe3,$80600030,$0030ffc7 ;4e7e6
	DC.L	$80c00060,$0060ff8f,$818000c0,$00c0ff1f ;4e7f6
	DC.L	$83000180,$0180fe3f,$86000300,$0300fc7f ;4e806
	DC.L	$8c000600,$0600f8ff,$98000c00,$0c00f1ff ;4e816
	DC.L	$b0003800,$580083ff,$50006000,$800007ff ;4e826
	DC.L	$20004000,$80000fff,$c0009fff,$1fff0000 ;4e836
	DC.L	$91000080,$1c80e37f,$966007e0,$1800e01f ;4e846
	DC.L	$95980678,$1800e007,$91800640,$1800e003 ;4e856
	DC.L	$91000080,$1c80e13f,$91000080,$1080e13f ;4e866
	DC.L	$81000080,$0080f73f,$81000080,$0080ff3f ;4e876
	DC.L	$81000080,$0080ff3f,$81000080,$0080ff3f ;4e886
	DC.L	$81000080,$0080ff3f,$81000080,$0080ff3f ;4e896
	DC.L	$81000080,$0080ff3f,$81000080,$0080ff3f ;4e8a6
	DC.L	$81000080,$0080ff3f,$00007f3f,$7f3f8000 ;4e8b6
	DC.L	$00076000,$80001fff,$40394007,$80061ff8 ;4e8c6
	DC.L	$40c1603b,$e03a0fc4,$a30230c2,$30c0c73d ;4e8d6
	DC.L	$90021b02,$1b00e0fd,$88040c04,$0c00f1fb ;4e8e6
	DC.L	$94040e04,$0e00f0fb,$92040b04,$0b00f47b ;4e8f6
	DC.L	$a1681188,$11e0ee77,$a0381048,$10f0efb7 ;4e906
	DC.L	$80106030,$20e0dfcf,$80306030,$2040dfcf ;4e916
	DC.L	$80c060c0,$2000df3f,$0700c700,$4000b8ff ;4e926
	DC.L	$1800f800,$600087ff,$6000dfff,$1fff8000 ;4e936
	DC.L	$80000000,$0000ffff,$80000000,$0000ffff ;4e946
	DC.L	$80000000,$0000ffff,$81c00030,$0000fe0f ;4e956
	DC.L	$82200118,$0100fc07,$8410020c,$0200f9c3 ;4e966
	DC.L	$88080406,$0400f3e1,$88040403,$0400f3f0 ;4e976
	DC.L	$84010000,$0000fbf8,$82000000,$0000fdfc ;4e986
	DC.L	$82000100,$0100fcff,$94004200,$0200a9ff ;4e996
	DC.L	$3800c400,$040003ff,$e0000800,$080087ff ;4e9a6
	DC.L	$c0000000,$000007ff,$40002fff,$2fff8000 ;4e9b6
	DC.L	$80000000,$0000ffff,$82000200,$0000fdff ;4e9c6
	DC.L	$84000500,$0100faff,$94000480,$0080fb7f ;4e9d6
	DC.L	$b8001840,$1040e7bf,$98000820,$0020f7df ;4e9e6
	DC.L	$98080818,$0018f7e7,$9ff4105c,$401cafe3 ;4e9f6
	DC.L	$00a0403f,$80ff00c0,$d0401fb4,$0ff4a043 ;4ea06
	DC.L	$98001818,$1018e7e7,$98001820,$1020e7df ;4ea16
	DC.L	$a8003840,$3040c7bf,$94001480,$1080eb7f ;4ea26
	DC.L	$84000500,$0100faff,$02007fff,$7dff8000 ;4ea36
	DC.L	$80010001,$0002fffc,$80020002,$0004fff8 ;4ea46
	DC.L	$80060005,$0009fff0,$8008000c,$0010ffe1 ;4ea56
	DC.L	$80100018,$0020ffc3,$80200030,$0040ff87 ;4ea66
	DC.L	$80400060,$0080ff0f,$908000c0,$0100ee1f ;4ea76
	DC.L	$a1000180,$0200cc3f,$aa000300,$0400c07f ;4ea86
	DC.L	$94000600,$0000e0ff,$9a000000,$0000e1ff ;4ea96
	DC.L	$a1000000,$0000c07f,$c0000000,$000084ff ;4eaa6
	DC.L	$80000000,$00000fff,$00001fff,$1fff0000 ;4eab6
	DC.L	$ffff0000,$ffff0000,$c0000000,$ffff0000 ;4eac6
	DC.L	$dfff1fff,$e0000000,$dc2b1000,$efff0000 ;4ead6
	DC.L	$dfff17ff,$e8000000,$dfd4102b,$e8000000 ;4eae6
	DC.L	$dfff13ff,$e8000000,$de0013ff,$e8000000 ;4eaf6
	DC.L	$de0013ff,$e8ff0000,$de0013ff,$e8ff0000 ;4eb06
	DC.L	$d20017ff,$e8ff0000,$de0013ff,$e8ff0000 ;4eb16
	DC.L	$d20017ff,$e8ff0000,$de0013ff,$e8ff0000 ;4eb26
	DC.L	$d20017ff,$e8ff0000,$de001fff,$e0ff0000 ;4eb36
	DC.L	$ffff0000,$ffff0000	;4eb46
	DS.L	1			;4eb4e
	DC.L	$ffff0000,$ffffffff	;4eb52
	DS.L	1			;4eb5a
	DC.L	$d42b0000,$ffff0000,$ffffffff ;4eb5e
	DS.L	1			;4eb6a
	DC.L	$2bd4d42b		;4eb6e
	DS.L	1			;4eb72
	DC.L	$ffffffff		;4eb76
	DS.L	1			;4eb7a
	DC.L	$0000ffff		;4eb7e
	DS.L	1			;4eb82
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eb86
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eb96
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eba6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4ebb6
	DC.L	$fffd0001,$fffe0000,$00020003,$fffc0000 ;4ebc6
	DC.L	$fffbfffc		;4ebd6
	DS.L	1			;4ebda
	DC.L	$d43b001c,$ffe00000,$fffbffec ;4ebde
	DS.L	1			;4ebea
	DC.L	$2bfbd42c		;4ebee
	DS.L	1			;4ebf2
	DC.L	$fffbffcc,$00200000,$00fbffcc,$00200000 ;4ebf6
	DC.L	$007bff4c,$ffa00000,$007bff4c,$ffa00000 ;4ec06
	DC.L	$004bff5c,$ffa00000,$007bff4c,$ffa00000 ;4ec16
	DC.L	$004bff5c,$ffa00000,$007bff4c,$ffa00000 ;4ec26
	DC.L	$004bff5c,$ffa00000,$007bff7c,$ff800000 ;4ec36
	DC.L	$df001f00,$e0ff0000,$dfff1fff,$e0000000 ;4ec46
	DC.L	$dfff1fff,$e0000000,$dfff1fff,$e0000000 ;4ec56
	DC.L	$dfff1fff,$e0000000,$dfff1fff,$e0000000 ;4ec66
	DC.L	$dfff1fff,$e0000000,$dfff1fff,$e0000000 ;4ec76
	DC.L	$dfff1fff,$e0000000,$dfff1fff,$e0000000 ;4ec86
	DC.L	$dfff1fff,$e0000000,$dfff1fff,$e0000000 ;4ec96
	DC.L	$dfff1fff,$e0000000,$dfff1fff,$e0000000 ;4eca6
	DC.L	$a0003fff,$c0000000,$bfffc000 ;4ecb6
	DS.L	2			;4ecc2
	DC.L	$ffff0000,$ffffffff	;4ecca
	DS.L	1			;4ecd2
	DC.L	$ffffffff		;4ecd6
	DS.L	1			;4ecda
	DC.L	$ffffffff		;4ecde
	DS.L	1			;4ece2
	DC.L	$ffffffff		;4ece6
	DS.L	1			;4ecea
	DC.L	$ffffffff		;4ecee
	DS.L	1			;4ecf2
	DC.L	$ffffffff		;4ecf6
	DS.L	1			;4ecfa
	DC.L	$ffffffff		;4ecfe
	DS.L	1			;4ed02
	DC.L	$ffffffff		;4ed06
	DS.L	1			;4ed0a
	DC.L	$ffffffff		;4ed0e
	DS.L	1			;4ed12
	DC.L	$ffffffff		;4ed16
	DS.L	1			;4ed1a
	DC.L	$ffffffff		;4ed1e
	DS.L	1			;4ed22
	DC.L	$ffffffff		;4ed26
	DS.L	1			;4ed2a
	DC.L	$ffffffff		;4ed2e
	DS.L	1			;4ed32
	DC.L	$0000ffff		;4ed36
	DS.L	1			;4ed3a
	DC.L	$ffff0000		;4ed3e
	DS.L	1			;4ed42
	DC.L	$00fb00fc,$ff000000,$fffbfffc ;4ed46
	DS.L	1			;4ed52
	DC.L	$fffbfffc		;4ed56
	DS.L	1			;4ed5a
	DC.L	$fffbfffc		;4ed5e
	DS.L	1			;4ed62
	DC.L	$fffbfffc		;4ed66
	DS.L	1			;4ed6a
	DC.L	$fffbfffc		;4ed6e
	DS.L	1			;4ed72
	DC.L	$fffbfffc		;4ed76
	DS.L	1			;4ed7a
	DC.L	$fffbfffc		;4ed7e
	DS.L	1			;4ed82
	DC.L	$fffbfffc		;4ed86
	DS.L	1			;4ed8a
	DC.L	$fffbfffc		;4ed8e
	DS.L	1			;4ed92
	DC.L	$fffbfffc		;4ed96
	DS.L	1			;4ed9a
	DC.L	$fffbfffc		;4ed9e
	DS.L	1			;4eda2
	DC.L	$fffbfffc		;4eda6
	DS.L	1			;4edaa
	DC.L	$fffbfffc		;4edae
	DS.L	1			;4edb2
	DC.L	$0003fffc		;4edb6
	DS.L	1			;4edba
	DC.L	$ffff0000		;4edbe
	DS.L	1			;4edc2
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4edc6
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4edd6
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4ede6
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4edf6
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4ee06
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4ee16
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4ee26
	DC.L	$de001fff,$e0ff0000,$de001fff,$e0ff0000 ;4ee36
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4ee46
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4ee56
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4ee66
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4ee76
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4ee86
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4ee96
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4eea6
	DC.L	$007bff7c,$ff800000,$007bff7c,$ff800000 ;4eeb6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eec6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eed6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eee6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eef6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4ef06
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4ef16
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4ef26
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4ef36
	DS.L	1			;4ef46
	DC.L	$ffff0000,$f800ffff	;4ef4a
	DS.L	1			;4ef52
	DC.L	$fbfffdff,$01ff0200,$fbfffeff,$02ff0100 ;4ef56
	DC.L	$fb00ffff,$03ff0000,$fb00ffff,$03ff0000 ;4ef66
	DC.L	$fb00ffff,$03ff0000,$fb00ffff,$03ff0000 ;4ef76
	DC.L	$fb00ffff,$03ff0000,$fb00ffff,$03ff0000 ;4ef86
	DC.L	$fb00ffff,$03ff0000,$fa00ff00,$03000000 ;4ef96
	DC.L	$f800fe00,$02000000,$fc00fc00,$03ff0000 ;4efa6
	DC.L	$0000ffff		;4efb6
	DS.L	1			;4efba
	DC.L	$ffff0000		;4efbe
	DS.L	2			;4efc2
	DC.L	$ffff0000,$0000ffff	;4efca
	DS.L	1			;4efd2
	DC.L	$ffffffff,$ffff0000,$ffffffff,$ffff0000 ;4efd6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4efe6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4eff6
	DC.L	$0000ffff,$ffff0000,$0000ffff,$ffff0000 ;4f006
	DC.L	$0000ffff,$ffff0000	;4f016
	DS.L	5			;4f01e
	DC.L	$ffff0000,$0000ffff	;4f032
	DS.L	1			;4f03a
	DC.L	$ffff0000		;4f03e
	DS.L	2			;4f042
	DC.L	$ffff0000,$003fffff	;4f04a
	DS.L	1			;4f052
	DC.L	$ff9fffdf,$ffe00000,$ff1fff9f,$ffa00000 ;4f056
	DC.L	$001fff1f,$ff200000,$001fff1f,$ff200000 ;4f066
	DC.L	$001fff1f,$ff200000,$001fff1f,$ff200000 ;4f076
	DC.L	$001fff1f,$ff200000,$001fff1f,$ff200000 ;4f086
	DC.L	$001fff1f,$ff200000,$001f001f,$00200000 ;4f096
	DC.L	$001f001f,$00200000,$001f001f,$ffe00000 ;4f0a6
	DC.L	$0000ffff		;4f0b6
	DS.L	1			;4f0ba
	DC.L	$ffff0000		;4f0be
	DS.L	$29			;4f0c2
	DC.L	$00200000		;4f166
	DS.L	1			;4f16a
	DC.L	$00060000		;4f16e
	DS.L	$3F			;4f172
	DC.L	$00400000		;4f26e
	DS.L	$55			;4f272
; ------------------------------------------------------------------------------
; The original release has several lines of code here
; Used for copy protection, they are removed in the
; Hit Squad 1993 budget release
; ------------------------------------------------------------------------------
_PROTECT1:
	RTS				;4f3c6: 4e75
_the_prot5:
	ORI.B	#$00,D0			;4f3c8: 00000000
; ------------------------------------------------------------------------------
; More copy-protection code omitted
; ------------------------------------------------------------------------------
_PROTECT2:
	RTS				;4f3cc: 4e75
_font_data:
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;4f3ce
	DS.L	1			;4f3de
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;4f3e2
	DS.L	1			;4f3f2
	DC.L	$ff000000,$00ff0000,$0000e700,$180018e7 ;4f3f6
	DC.L	$08100018,$e7081000,$18ff0000,$0000e718 ;4f406
	DC.L	$000018ff		;4f416
	DS.L	1			;4f41a
	DC.L	$ff000000,$00ff0000,$0000930c,$60006c93 ;4f41e
	DC.L	$2c40006c,$ff000000,$00ff0000,$0000ff00 ;4f42e
	DC.L	$000000ff		;4f43e
	DS.L	1			;4f442
	DC.L	$ff000000,$00ff0000,$0000db04,$20002481 ;4f446
	DC.L	$3e40007e,$db240000,$24817608,$007edb24 ;4f456
	DC.L	$000024ff		;4f466
	DS.L	1			;4f46a
	DC.L	$ff000000,$00e71800,$0018c11e,$20003e9f ;4f46e
	DC.L	$20400060,$c33c0000,$3cf90204,$0006837c ;4f47e
	DC.L	$00007ce7,$18000018,$ff000000,$00ff0000 ;4f48e
	DC.L	$00009906,$60006693,$2c40006c,$e7180000 ;4f49e
	DC.L	$18c93204,$00369966,$000066ff ;4f4ae
	DS.L	1			;4f4ba
	DC.L	$ff000000,$00ff0000,$0000f708,$000008eb ;4f4be
	DC.L	$04100014,$c51a2000,$3a9b6400,$0064c53a ;4f4ce
	DC.L	$00003aff		;4f4de
	DS.L	1			;4f4e2
	DC.L	$ff000000,$00ff0000,$0000e708,$100018cf ;4f4e6
	DC.L	$10200030,$ff000000,$00ff0000,$0000ff00 ;4f4f6
	DC.L	$000000ff		;4f506
	DS.L	1			;4f50a
	DC.L	$ff000000,$00ff0000,$0000e708,$100018cf ;4f50e
	DC.L	$10200030,$df002000,$20cf3000,$0030e718 ;4f51e
	DC.L	$000018ff		;4f52e
	DS.L	1			;4f532
	DC.L	$ff000000,$00ff0000,$0000f308,$04000cf9 ;4f536
	DC.L	$04020006,$fd000200,$02f90600,$0006f30c ;4f546
	DC.L	$00000cff		;4f556
	DS.L	1			;4f55a
	DC.L	$ff000000,$00ff0000,$0000ab14,$400054c7 ;4f55e
	DC.L	$38000038,$833c4000,$7cc72810,$0038ab54 ;4f56e
	DC.L	$000054ff		;4f57e
	DS.L	1			;4f582
	DC.L	$ff000000,$00ff0000,$0000e718,$000018e7 ;4f586
	DC.L	$18000018,$813e4000,$7ee70810,$0018e718 ;4f596
	DC.L	$000018ff		;4f5a6
	DS.L	1			;4f5aa
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;4f5ae
	DS.L	1			;4f5be
	DC.L	$e7081000,$18e71800,$0018cf10,$200030ff ;4f5c2
	DS.L	1			;4f5d2
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;4f5d6
	DS.L	1			;4f5e6
	DC.L	$c30c3000,$3cff0000,$0000ff00,$000000ff ;4f5ea
	DS.L	1			;4f5fa
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;4f5fe
	DS.L	1			;4f60e
	DC.L	$ff000000,$00e70018,$0018e708,$100018ff ;4f612
	DS.L	1			;4f622
	DC.L	$ff000000,$00ff0000,$0000f906,$000006f3 ;4f626
	DC.L	$0c00000c,$e7180000,$18cf1020,$00309f60 ;4f636
	DC.L	$000060ff		;4f646
	DS.L	1			;4f64a
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c99 ;4f64e
	DC.L	$26400066,$99660000,$66996204,$0066c33c ;4f65e
	DC.L	$00003cff		;4f66e
	DS.L	1			;4f672
	DC.L	$ff000000,$00ff0000,$0000e708,$100018c7 ;4f676
	DC.L	$18200038,$e7180000,$18e70810,$0018817e ;4f686
	DC.L	$00007eff		;4f696
	DS.L	1			;4f69a
	DC.L	$ff000000,$00ff0000,$0000831c,$60007cf9 ;4f69e
	DC.L	$06000006,$c33c0000,$3c9f2040,$0060817e ;4f6ae
	DC.L	$00007eff		;4f6be
	DS.L	1			;4f6c2
	DC.L	$ff000000,$00ff0000,$0000831c,$60007cf9 ;4f6c6
	DC.L	$06000006,$c33c0000,$3cf90204,$0006837c ;4f6d6
	DC.L	$00007cff		;4f6e6
	DS.L	1			;4f6ea
	DC.L	$ff000000,$00ff0000,$00009906,$60006699 ;4f6ee
	DC.L	$26400066,$813e4000,$7ef90204,$0006f906 ;4f6fe
	DC.L	$000006ff		;4f70e
	DS.L	1			;4f712
	DC.L	$ff000000,$00ff0000,$0000811e,$60007e9f ;4f716
	DC.L	$20400060,$833c4000,$7cf90204,$0006837c ;4f726
	DC.L	$00007cff		;4f736
	DS.L	1			;4f73a
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c9f ;4f73e
	DC.L	$20400060,$833c4000,$7c996204,$0066c33c ;4f74e
	DC.L	$00003cff		;4f75e
	DS.L	1			;4f762
	DC.L	$ff000000,$00ff0000,$0000811e,$60007ef3 ;4f766
	DC.L	$0c00000c,$e7180000,$18cf1020,$0030cf30 ;4f776
	DC.L	$000030ff		;4f786
	DS.L	1			;4f78a
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c99 ;4f78e
	DC.L	$26400066,$c33c0000,$3c996204,$0066c33c ;4f79e
	DC.L	$00003cff		;4f7ae
	DS.L	1			;4f7b2
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c99 ;4f7b6
	DC.L	$26400066,$c13e0000,$3ef90204,$0006c33c ;4f7c6
	DC.L	$00003cff		;4f7d6
	DS.L	1			;4f7da
	DC.L	$ff000000,$00ff0000,$0000e700,$180018e7 ;4f7de
	DC.L	$08100018,$ff000000,$00e70810,$0018e718 ;4f7ee
	DC.L	$000018ff		;4f7fe
	DS.L	1			;4f802
	DC.L	$ff000000,$00ff0000,$0000e700,$180018e7 ;4f806
	DC.L	$08100018,$ff000000,$00f70800,$0008ef10 ;4f816
	DC.L	$000010ff		;4f826
	DS.L	1			;4f82a
	DC.L	$ff000000,$00ff0000,$0000f900,$060006f3 ;4f82e
	DC.L	$0804000c,$e7180000,$18f30408,$000cf906 ;4f83e
	DC.L	$000006ff		;4f84e
	DS.L	1			;4f852
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000c7 ;4f856
	DC.L	$08300038,$ff000000,$00c71820,$0038ff00 ;4f866
	DC.L	$000000ff		;4f876
	DS.L	1			;4f87a
	DC.L	$ff000000,$00ff0000,$00009f00,$600060cf ;4f87e
	DC.L	$30000030,$e7180000,$18cf1020,$00309f60 ;4f88e
	DC.L	$000060ff		;4f89e
	DS.L	1			;4f8a2
	DC.L	$ff000000,$00ff0000,$0000c30c,$30003cf9 ;4f8a6
	DC.L	$06000006,$e31c0000,$1cff0000,$0000e718 ;4f8b6
	DC.L	$000018ff		;4f8c6
	DS.L	1			;4f8ca
	DC.L	$ff000000,$00ff0000,$0000811e,$60007e99 ;4f8ce
	DC.L	$26400066,$912e4000,$6e9f6000,$0060837c ;4f8de
	DC.L	$00007cff		;4f8ee
	DS.L	1			;4f8f2
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c99 ;4f8f6
	DC.L	$26400066,$813e4000,$7e996204,$00669966 ;4f906
	DC.L	$000066ff		;4f916
	DS.L	1			;4f91a
	DC.L	$ff000000,$00ff0000,$0000831c,$60007c99 ;4f91e
	DC.L	$26400066,$833c4000,$7c996204,$0066837c ;4f92e
	DC.L	$00007cff		;4f93e
	DS.L	1			;4f942
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c99 ;4f946
	DC.L	$26400066,$9f204000,$60996204,$0066c33c ;4f956
	DC.L	$00003cff		;4f966
	DS.L	1			;4f96a
	DC.L	$ff000000,$00ff0000,$0000831c,$60007c99 ;4f96e
	DC.L	$26400066,$99264000,$66996204,$0066837c ;4f97e
	DC.L	$00007cff		;4f98e
	DS.L	1			;4f992
	DC.L	$ff000000,$00ff0000,$0000811e,$60007e9f ;4f996
	DC.L	$20400060,$87384000,$789f6000,$0060817e ;4f9a6
	DC.L	$00007eff		;4f9b6
	DS.L	1			;4f9ba
	DC.L	$ff000000,$00ff0000,$0000811e,$60007e9f ;4f9be
	DC.L	$20400060,$87384000,$789f6000,$00609f60 ;4f9ce
	DC.L	$000060ff		;4f9de
	DS.L	1			;4f9e2
	DC.L	$ff000000,$00ff0000,$0000c11e,$20003e9f ;4f9e6
	DC.L	$20400060,$912e4000,$6e996204,$0066c13e ;4f9f6
	DC.L	$00003eff		;4fa06
	DS.L	1			;4fa0a
	DC.L	$ff000000,$00ff0000,$00009906,$60006699 ;4fa0e
	DC.L	$26400066,$813e4000,$7e996204,$00669966 ;4fa1e
	DC.L	$000066ff		;4fa2e
	DS.L	1			;4fa32
	DC.L	$ff000000,$00ff0000,$0000811e,$60007ee7 ;4fa36
	DC.L	$18000018,$e7180000,$18e71800,$0018817e ;4fa46
	DC.L	$00007eff		;4fa56
	DS.L	1			;4fa5a
	DC.L	$ff000000,$00ff0000,$0000f900,$060006f9 ;4fa5e
	DC.L	$02040006,$f9020400,$06994620,$0066c33c ;4fa6e
	DC.L	$00003cff		;4fa7e
	DS.L	1			;4fa82
	DC.L	$ff000000,$00ff0000,$00009906,$60006693 ;4fa86
	DC.L	$2c40006c,$87384000,$78936408,$006c9966 ;4fa96
	DC.L	$000066ff		;4faa6
	DS.L	1			;4faaa
	DC.L	$ff000000,$00ff0000,$00009f00,$6000609f ;4faae
	DC.L	$20400060,$9f204000,$609f6000,$0060817e ;4fabe
	DC.L	$00007eff		;4face
	DS.L	1			;4fad2
	DC.L	$ff000000,$00ff0000,$00009c03,$60006388 ;4fad6
	DC.L	$37400077,$803f4000,$7f946902,$006b9c63 ;4fae6
	DC.L	$000063ff		;4faf6
	DS.L	1			;4fafa
	DC.L	$ff000000,$00ff0000,$00009906,$60006689 ;4fafe
	DC.L	$36400076,$813e4000,$7e916608,$006e9966 ;4fb0e
	DC.L	$000066ff		;4fb1e
	DS.L	1			;4fb22
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c99 ;4fb26
	DC.L	$26400066,$99264000,$66996204,$0066c33c ;4fb36
	DC.L	$00003cff		;4fb46
	DS.L	1			;4fb4a
	DC.L	$ff000000,$00ff0000,$0000831c,$60007c99 ;4fb4e
	DC.L	$26400066,$833c4000,$7c9f6000,$00609f60 ;4fb5e
	DC.L	$000060ff		;4fb6e
	DS.L	1			;4fb72
	DC.L	$ff000000,$00ff0000,$0000c31c,$20003c99 ;4fb76
	DC.L	$26400066,$99264000,$66936804,$006cc13e ;4fb86
	DC.L	$00003eff		;4fb96
	DS.L	1			;4fb9a
	DC.L	$ff000000,$00ff0000,$0000831c,$60007c99 ;4fb9e
	DC.L	$26400066,$833c4000,$7c996204,$00669966 ;4fbae
	DC.L	$000066ff		;4fbbe
	DS.L	1			;4fbc2
	DC.L	$ff000000,$00ff0000,$0000c11e,$20003e9f ;4fbc6
	DC.L	$20400060,$c33c0000,$3cf90204,$0006837c ;4fbd6
	DC.L	$00007cff		;4fbe6
	DS.L	1			;4fbea
	DC.L	$ff000000,$00ff0000,$0000811e,$60007ee7 ;4fbee
	DC.L	$18000018,$e7180000,$18e70810,$0018e718 ;4fbfe
	DC.L	$000018ff		;4fc0e
	DS.L	1			;4fc12
	DC.L	$ff000000,$00ff0000,$00009906,$60006699 ;4fc16
	DC.L	$26400066,$99264000,$66996204,$0066c33c ;4fc26
	DC.L	$00003cff		;4fc36
	DS.L	1			;4fc3a
	DC.L	$ff000000,$00ff0000,$00009906,$60006699 ;4fc3e
	DC.L	$26400066,$99224400,$66c33c00,$003ce718 ;4fc4e
	DC.L	$000018ff		;4fc5e
	DS.L	1			;4fc62
	DC.L	$ff000000,$00ff0000,$00009c03,$60006394 ;4fc66
	DC.L	$2b40006b,$803f4000,$7f887502,$00779c63 ;4fc76
	DC.L	$000063ff		;4fc86
	DS.L	1			;4fc8a
	DC.L	$ff000000,$00ff0000,$00009906,$600066c3 ;4fc8e
	DC.L	$3c00003c,$e7180000,$18c33408,$003c9966 ;4fc9e
	DC.L	$000066ff		;4fcae
	DS.L	1			;4fcb2
	DC.L	$ff000000,$00ff0000,$00009906,$60006699 ;4fcb6
	DC.L	$26400066,$c33c0000,$3ce70810,$0018e718 ;4fcc6
	DC.L	$000018ff		;4fcd6
	DS.L	1			;4fcda
	DC.L	$ff000000,$00ff0000,$0000811e,$60007ef3 ;4fcde
	DC.L	$0c00000c,$e7180000,$18cf1020,$0030817e ;4fcee
	DC.L	$00007eff		;4fcfe
	DS.L	1			;4fd02
	DC.L	$ff000000,$00ff0000,$00008718,$6000789f ;4fd06
	DC.L	$20400060,$9f204000,$609f6000,$00608778 ;4fd16
	DC.L	$000078ff		;4fd26
	DS.L	1			;4fd2a
	DC.L	$ff000000,$00ff0000,$00009f00,$600060cf ;4fd2e
	DC.L	$30000030,$e7180000,$18f30408,$000cf906 ;4fd3e
	DC.L	$000006ff		;4fd4e
	DS.L	1			;4fd52
	DC.L	$ff000000,$00ff0000,$0000e10e,$10001ef9 ;4fd56
	DC.L	$06000006,$f9060000,$06f90204,$0006e11e ;4fd66
	DC.L	$00001eff		;4fd76
	DS.L	1			;4fd7a
	DC.L	$0000ffff,$000000ff,$ff000000,$ffff0000 ;4fd7e
	DC.L	$00ffff00,$0000ffff,$000000ff,$ff000000 ;4fd8e
	DC.L	$ffff0000,$00ffff00,$ff000000,$00ff0000 ;4fd9e
	DC.L	$0000ff00,$000000ff	;4fdae
	DS.L	1			;4fdb6
	DC.L	$ff000000,$00ff0000,$0000ff00,$00000001 ;4fdba
	DC.L	$7e8000fe,$ff000000,$00ff0000,$0000cf00 ;4fdca
	DC.L	$300030e7,$18000018,$f30c0000,$0cf90204 ;4fdda
	DC.L	$0006fc03,$000003ff	;4fdea
	DS.L	1			;4fdf2
	DC.L	$ff000000,$00ff0000,$0000c320,$00003c99 ;4fdf6
	DC.L	$40000066,$81400000,$7e990400,$00669900 ;4fe06
	DC.L	$000066ff		;4fe16
	DS.L	1			;4fe1a
	DC.L	$ff000000,$00ff0000,$00008360,$00007c99 ;4fe1e
	DC.L	$40000066,$83400000,$7c990400,$00668300 ;4fe2e
	DC.L	$00007cff		;4fe3e
	DS.L	1			;4fe42
	DC.L	$ff000000,$00ff0000,$0000c320,$00003c99 ;4fe46
	DC.L	$40000066,$9f400000,$60990400,$0066c300 ;4fe56
	DC.L	$00003cff		;4fe66
	DS.L	1			;4fe6a
	DC.L	$ff000000,$00ff0000,$00008360,$00007c99 ;4fe6e
	DC.L	$40000066,$99400000,$66990400,$00668300 ;4fe7e
	DC.L	$00007cff		;4fe8e
	DS.L	1			;4fe92
	DC.L	$ff000000,$00ff0000,$00008160,$00007e9f ;4fe96
	DC.L	$40000060,$87400000,$789f0000,$00608100 ;4fea6
	DC.L	$00007eff		;4feb6
	DS.L	1			;4feba
	DC.L	$ff000000,$00ff0000,$00008160,$00007e9f ;4febe
	DC.L	$40000060,$87400000,$789f0000,$00609f00 ;4fece
	DC.L	$000060ff		;4fede
	DS.L	1			;4fee2
	DC.L	$ff000000,$00ff0000,$0000c120,$00003e9f ;4fee6
	DC.L	$40000060,$91400000,$6e990400,$0066c100 ;4fef6
	DC.L	$00003eff		;4ff06
	DS.L	1			;4ff0a
	DC.L	$ff000000,$00ff0000,$00009960,$00006699 ;4ff0e
	DC.L	$40000066,$81400000,$7e990400,$00669900 ;4ff1e
	DC.L	$000066ff		;4ff2e
	DS.L	1			;4ff32
	DC.L	$ff000000,$00ff0000,$00008160,$00007ee7 ;4ff36
	DC.L	$00000018,$e7000000,$18e70000,$00188100 ;4ff46
	DC.L	$00007eff		;4ff56
	DS.L	1			;4ff5a
	DC.L	$ff000000,$00ff0000,$0000f906,$000006f9 ;4ff5e
	DC.L	$04000006,$f9040000,$06992000,$0066c300 ;4ff6e
	DC.L	$00003cff		;4ff7e
	DS.L	1			;4ff82
	DC.L	$ff000000,$00ff0000,$00009960,$00006693 ;4ff86
	DC.L	$4000006c,$87400000,$78930800,$006c9900 ;4ff96
	DC.L	$000066ff		;4ffa6
	DS.L	1			;4ffaa
	DC.L	$ff000000,$00ff0000,$00009f60,$0000609f ;4ffae
	DC.L	$40000060,$9f400000,$609f0000,$00608100 ;4ffbe
	DC.L	$00007eff		;4ffce
	DS.L	1			;4ffd2
	DC.L	$ff000000,$00ff0000,$00009c60,$00006388 ;4ffd6
	DC.L	$40000077,$80400000,$7f940200,$006b9c00 ;4ffe6
	DC.L	$000063ff		;4fff6
	DS.L	1			;4fffa
	DC.L	$ff000000,$00ff0000,$00009960,$00006689 ;4fffe
	DC.L	$40000076,$81400000,$7e910800,$006e9900 ;5000e
	DC.L	$000066ff		;5001e
	DS.L	1			;50022
	DC.L	$ff000000,$00ff0000,$0000c320,$00003c99 ;50026
	DC.L	$40000066,$99400000,$66990400,$0066c300 ;50036
	DC.L	$00003cff		;50046
	DS.L	1			;5004a
	DC.L	$ff000000,$00ff0000,$00008360,$00007c99 ;5004e
	DC.L	$40000066,$83400000,$7c9f0000,$00609f00 ;5005e
	DC.L	$000060ff		;5006e
	DS.L	1			;50072
	DC.L	$ff000000,$00ff0000,$0000c320,$00003c99 ;50076
	DC.L	$40000066,$99400000,$66930400,$006cc100 ;50086
	DC.L	$00003eff		;50096
	DS.L	1			;5009a
	DC.L	$ff000000,$00ff0000,$00008360,$00007c99 ;5009e
	DC.L	$40000066,$83400000,$7c990400,$00669900 ;500ae
	DC.L	$000066ff		;500be
	DS.L	1			;500c2
	DC.L	$ff000000,$00ff0000,$0000c120,$00003e9f ;500c6
	DC.L	$40000060,$c3000000,$3cf90400,$00068300 ;500d6
	DC.L	$00007cff		;500e6
	DS.L	1			;500ea
	DC.L	$ff000000,$00ff0000,$00008160,$00007ee7 ;500ee
	DC.L	$00000018,$e7000000,$18e71000,$0018e700 ;500fe
	DC.L	$000018ff		;5010e
	DS.L	1			;50112
	DC.L	$ff000000,$00ff0000,$00009960,$00006699 ;50116
	DC.L	$40000066,$99400000,$66990400,$0066c300 ;50126
	DC.L	$00003cff		;50136
	DS.L	1			;5013a
	DC.L	$ff000000,$00ff0000,$00009960,$00006699 ;5013e
	DC.L	$40000066,$99440000,$66c30000,$003ce700 ;5014e
	DC.L	$000018ff		;5015e
	DS.L	1			;50162
	DC.L	$ff000000,$00ff0000,$00009c60,$00006394 ;50166
	DC.L	$4000006b,$80400000,$7f880200,$00779c00 ;50176
	DC.L	$000063ff		;50186
	DS.L	1			;5018a
	DC.L	$ff000000,$00ff0000,$00009960,$000066c3 ;5018e
	DC.L	$0000003c,$e7000000,$18c30800,$003c9900 ;5019e
	DC.L	$000066ff		;501ae
	DS.L	1			;501b2
	DC.L	$ff000000,$00ff0000,$00009960,$00006699 ;501b6
	DC.L	$40000066,$c3000000,$3ce71000,$0018e700 ;501c6
	DC.L	$000018ff		;501d6
	DS.L	1			;501da
	DC.L	$ff000000,$00ff0000,$00008160,$00007ef3 ;501de
	DC.L	$0000000c,$e7000000,$18cf2000,$00308100 ;501ee
	DC.L	$00007eff		;501fe
	DS.L	1			;50202
	DC.L	$ff000000,$00ff0000,$0000f102,$0c000ee7 ;50206
	DC.L	$08100018,$cf300000,$30e71800,$0018f10e ;50216
	DC.L	$00000eff		;50226
	DS.L	1			;5022a
	DC.L	$ff000000,$00ff0000,$0000f700,$080008f7 ;5022e
	DC.L	$00080008,$f7080000,$08f70800,$0008f708 ;5023e
	DC.L	$000008ff		;5024e
	DS.L	1			;50252
	DC.L	$ff000000,$00ff0000,$0000c700,$380038f3 ;50256
	DC.L	$0c00000c,$f9060000,$06f30408,$000cc738 ;50266
	DC.L	$000038ff		;50276
	DS.L	1			;5027a
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;5027e
	DS.L	1			;5028e
	DC.L	$811e6000,$7eff0000,$0000ff00,$000000ff ;50292
	DS.L	1			;502a2
	DC.L	$ff000000,$00c1003e,$003e8001,$49017e80 ;502a6
	DC.L	$0155017e,$80015101,$7e800155,$017e8001 ;502b6
	DC.L	$49017ec1,$003e3e00,$00fc05f9,$0000fc78 ;502c6
	DC.L	$800000fc,$78800000,$fc788000,$00fc7880 ;502d6
	DC.L	$0000fc80		;502e6
	DS.L	1			;502ea
	DC.L	$80800000,$00c0c000,$000007fb,$0000007b ;502ee
	DC.L	$83000000,$7b830000,$007b8300,$00007b83 ;502fe
	DC.L	$00000083,$03000000,$ffff0000,$00ffff00 ;5030e
	DC.L	$00ff0000,$0000ff00,$000000ff ;5031e
	DS.L	1			;5032a
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;5032e
	DS.L	1			;5033e
	DC.L	$ff000000,$0000ffff,$00007eff,$ff00007e ;50342
	DC.L	$c3c33c00,$66dbc33c,$0066dbc3,$3c007ec3 ;50352
	DC.L	$c33c007e,$ffff0000,$00ffff00,$0000ff00 ;50362
	DC.L	$ff000080,$00800000,$80008000,$00800080 ;50372
	DC.L	$00008000,$80000080,$00800000,$80008000 ;50382
	DC.L	$7fff7f80,$0000ff00,$ff000000 ;50392
	DS.L	7			;5039e
	DC.L	$ffffff00,$0001ff01,$fe000101,$01000001 ;503ba
	DC.L	$01010000,$01010100,$00010101,$00000101 ;503ca
	DC.L	$01000001,$01010000,$ffffff00,$ff000000 ;503da
	DC.L	$00e70818,$0810c31c,$24043881,$3e42027c ;503ea
	DC.L	$813e4202,$7c813e42,$027ce708,$180810ff ;503fa
	DS.L	1			;5040a
	DC.L	$00ff0000,$0000817a,$00180081,$7c003c00 ;5040e
	DC.L	$817e007e,$00817800,$1800817a,$00180081 ;5041e
	DC.L	$7a001800,$ff000000,$00ff0000,$0000817a ;5042e
	DC.L	$00180081,$7a001800,$81780018,$00817e00 ;5043e
	DC.L	$7e00817c,$003c0081,$7a001800,$ff000000 ;5044e
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;5045e
	DS.L	1			;5046e
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;50472
	DS.L	1			;50482
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;50486
	DS.L	1			;50496
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;5049a
	DS.L	1			;504aa
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;504ae
	DS.L	1			;504be
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;504c2
	DS.L	1			;504d2
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;504d6
	DS.L	1			;504e6
	DC.L	$ff000000,$00ff0000,$0000ff00,$000000ff ;504ea
	DS.L	1			;504fa
_strcpy:
	MOVEA.L	(4,A7),A0		;504fe: 206f0004
	MOVE.L	A0,D0			;50502: 2008
	MOVEA.L	(8,A7),A1		;50504: 226f0008
LAB_50508:
	MOVE.B	(A1)+,(A0)+		;50508: 10d9
	BNE.S	LAB_50508		;5050a: 66fc
	RTS				;5050c: 4e75
_strlen:
	MOVEA.L	(4,A7),A0		;5050e: 206f0004
	MOVE.L	A0,D0			;50512: 2008
LAB_50514:
	TST.B	(A0)+			;50514: 4a18
	BNE.S	LAB_50514		;50516: 66fc
	SUBA.L	D0,A0			;50518: 91c0
	MOVE.L	A0,D0			;5051a: 2008
	SUBQ.L	#1,D0			;5051c: 5380
	RTS				;5051e: 4e75
; ------------------------------------------------------------------------------
; Function
; ASCII to integer
; ------------------------------------------------------------------------------
_atoi:
	LINK.W	A5,#0			;50520: 4e550000
	MOVEM.L	D4-D5/A2,-(A7)		;50524: 48e70c20
	MOVEA.L	(8,A5),A2		;50528: 246d0008
LAB_5052C:
	CMPI.B	#$20,(A2)		;5052c: 0c120020
	BEQ.S	LAB_50538		;50530: 6706
	CMPI.B	#$09,(A2)		;50532: 0c120009
	BNE.S	LAB_5053C		;50536: 6604
LAB_50538:
	ADDQ.L	#1,A2			;50538: 528a
	BRA.S	LAB_5052C		;5053a: 60f0
LAB_5053C:
	MOVEQ	#0,D5			;5053c: 7a00
	CMPI.B	#$2d,(A2)		;5053e: 0c12002d
	BNE.S	LAB_5054A		;50542: 6606
	MOVEQ	#1,D5			;50544: 7a01
	ADDQ.L	#1,A2			;50546: 528a
	BRA.S	LAB_50552		;50548: 6008
LAB_5054A:
	CMPI.B	#$2b,(A2)		;5054a: 0c12002b
	BNE.S	LAB_50552		;5054e: 6602
	ADDQ.L	#1,A2			;50550: 528a
LAB_50552:
	MOVEQ	#0,D4			;50552: 7800
	BRA.S	LAB_5056C		;50554: 6016
LAB_50556:
	MOVEA.L	A2,A0			;50556: 204a
	ADDQ.L	#1,A2			;50558: 528a
	MOVE.B	(A0),D0			;5055a: 1010
	EXT.W	D0			;5055c: 4880
	MOVE.W	D4,D1			;5055e: 3204
	MULU	#$000a,D1		;50560: c2fc000a
	ADD.W	D1,D0			;50564: d041
	MOVE.W	D0,D4			;50566: 3800
	SUB.W	#$0030,D4		;50568: 987c0030
LAB_5056C:
	MOVE.B	(A2),D0			;5056c: 1012
	EXT.W	D0			;5056e: 4880
	ADDQ.W	#1,D0			;50570: 5240
	LEA	(_ctp_,A4),A0		;50572: 41ec97b8
	BTST	#2,(0,A0,D0.W)		;50576: 083000020000
	BNE.S	LAB_50556		;5057c: 66d8
	TST.W	D5			;5057e: 4a45
	BEQ.S	LAB_50588		;50580: 6706
	MOVE.W	D4,D0			;50582: 3004
	NEG.W	D0			;50584: 4440
	BRA.S	LAB_5058A		;50586: 6002
LAB_50588:
	MOVE.W	D4,D0			;50588: 3004
LAB_5058A:
	MOVEM.L	(A7)+,D4-D5/A2		;5058a: 4cdf0430
	UNLK	A5			;5058e: 4e5d
	RTS				;50590: 4e75
_strcmp:
	MOVE.W	#$7fff,D0		;50592: 303c7fff
	BRA.S	LAB_5059C		;50596: 6004
_strncmp:
	MOVE.W	($C,A7),D0		;50598: 302f000c
LAB_5059C:
	SUBQ.W	#1,D0			;5059c: 5340
	BMI.S	LAB_505B4		;5059e: 6b14
	MOVEA.L	(4,A7),A0		;505a0: 206f0004
	MOVEA.L	(8,A7),A1		;505a4: 226f0008
LAB_505A8:
	CMPM.B	(A1)+,(A0)+		;505a8: b109
	BNE.S	LAB_505B8		;505aa: 660c
	SUBQ.W	#1,A0			;505ac: 5348
	TST.B	(A0)+			;505ae: 4a18
	DBEQ	D0,LAB_505A8		;505b0: 57c8fff6
LAB_505B4:
	MOVEQ	#0,D0			;505b4: 7000
	RTS				;505b6: 4e75
LAB_505B8:
	BLS.S	LAB_505BE		;505b8: 6304
	MOVEQ	#1,D0			;505ba: 7001
	RTS				;505bc: 4e75
LAB_505BE:
	MOVEQ	#-1,D0			;505be: 70ff
	RTS				;505c0: 4e75
_int_start:
	MOVEA.L	(A7)+,A0		;505c2: 205f
	MOVEM.L	D2-D3/A4,-(A7)		;505c4: 48e73008
	MOVE.L	A0,-(A7)		;505c8: 2f08
	JMP	_geta4			;505ca: 4ef900050674
_int_end:
	MOVEA.L	(A7)+,A0		;505d0: 205f
	MOVEM.L	(A7)+,D2-D3/A4		;505d2: 4cdf100c
	JMP	(A0)			;505d6: 4ed0
; ------------------------------------------------------------------------------
; new code for IFF routine
; ------------------------------------------------------------------------------
_movmem:
	MOVEM.L	(4,A7),A0-A1		;505d8: 4cef03000004
	MOVEQ	#0,D0			;505de: 7000
	MOVE.W	($C,A7),D0		;505e0: 302f000c
	CMPA.L	A0,A1			;505e4: b3c8
	BNE.S	LAB_505EA		;505e6: 6602
	RTS				;505e8: 4e75
LAB_505EA:
	BLS.S	LAB_505FC		;505ea: 6310
	ADDA.W	D0,A0			;505ec: d0c0
	ADDA.W	D0,A1			;505ee: d2c0
	BRA.S	LAB_505F4		;505f0: 6002
LAB_505F2:
	MOVE.B	-(A0),-(A1)		;505f2: 1320
LAB_505F4:
	DBF	D0,LAB_505F2		;505f4: 51c8fffc
	RTS				;505f8: 4e75
for_505FA:
	MOVE.B	(A0)+,(A1)+		;505fa: 12d8
LAB_505FC:
	DBF	D0,for_505FA		;505fc: 51c8fffc
	RTS				;50600: 4e75
; ------------------------------------------------------------------------------
; end new code
; ------------------------------------------------------------------------------
_begin:
	BSR.S	_geta4			;50602: 6170
	LEA	(__H1_end,A4),A1	;50604: 43ec9846
	LEA	(__H1_end,A4),A2	;50608: 45ec9846
	CMPA.L	A1,A2			;5060c: b5c9
	BNE.S	LAB_5061E		;5060e: 660e
	MOVE.W	#$2759,D1		;50610: 323c2759
	BMI.S	LAB_5061E		;50614: 6b08
	MOVEQ	#0,D2			;50616: 7400
LAB_50618:
	MOVE.L	D2,(A1)+		;50618: 22c2
	DBF	D1,LAB_50618		;5061a: 51c9fffc
LAB_5061E:
	MOVE.L	A7,(__savsp,A4)		;5061e: 294f3560
	MOVEA.L	ABSEXECBASE.W,A6	;50622: 2c780004
	MOVE.L	A6,(_SysBase,A4)	;50626: 294e3564
	MOVEM.L	D0/A0,-(A7)		;5062a: 48e78080
	BTST	#4,($129,A6)		;5062e: 082e00040129
	BEQ.S	LAB_50646		;50634: 6710
	LEA	(LAB_50640,PC),A5	;50636: 4bfa0008
	JSR	(-30,A6)		;5063a: 4eaeffe2
	BRA.S	LAB_50646		;5063e: 6006
LAB_50640:
	CLR.L	-(A7)			;50640: 42a7
	DC.L	$f35f4e73		;50642
LAB_50646:
	LEA	(DosLibName,PC),A1	;50646: 43fa0020
; OldOpenLibrary
	JSR	(-408,A6)		;5064a: 4eaefe68
	MOVE.L	D0,(_DOSBase,A4)	;5064e: 29403568
	BNE.S	LAB_50660		;50652: 660c
	MOVE.L	#$00038007,D7		;50654: 2e3c00038007
; guru meditation
	JSR	(-108,A6)		;5065a: 4eaeff94
	BRA.S	LAB_50664		;5065e: 6004
LAB_50660:
	JSR	(__main,PC)		;50660: 4eba001a
LAB_50664:
	ADDQ.W	#8,A7			;50664: 504f
	RTS				;50666: 4e75
DosLibName:
	;50668
	;DC.B	$64,$6f,$73,$2e,$6c,$69,$62,$72,$61,$72,$79,$00
	DC.B	"dos.library",0
_geta4:
	LEA	_A4,A4			;50674: 49f9000593ee
	RTS				;5067a: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
__main:
	LINK.W	A5,#0			;5067c: 4e550000
	MOVE.L	A2,-(A7)		;50680: 2f0a
	PEA	$00010000		;50682: 487900010000
	MOVE.W	(__numdev,A4),D0	;50688: 302c983a
	MULS	#$0006,D0		;5068c: c1fc0006
	MOVE.L	D0,-(A7)		;50690: 2f00
	JSR	(__AllocMem,PC)		;50692: 4eba0c5e
	MOVE.L	D0,(__devtab,A4)	;50696: 2940356c
	ADDQ.W	#8,A7			;5069a: 504f
	BNE.S	LAB_506B2		;5069c: 6614
	CLR.L	-(A7)			;5069e: 42a7
	PEA	$00010000		;506a0: 487900010000
	JSR	(_Alert,PC)		;506a6: 4eba0b04
	ADDQ.W	#8,A7			;506aa: 504f
	MOVEA.L	(__savsp,A4),A7		;506ac: 2e6c3560
	RTS				;506b0: 4e75
LAB_506B2:
	MOVEA.L	(__devtab,A4),A0	;506b2: 206c356c
	CLR.W	(4,A0)			;506b6: 42680004
	MOVEA.L	(__devtab,A4),A0	;506ba: 206c356c
	MOVE.W	#$0001,($10,A0)		;506be: 317c00010010
	MOVEA.L	(__devtab,A4),A0	;506c4: 206c356c
	MOVE.W	#$0001,($A,A0)		;506c8: 317c0001000a
	MOVEA.L	(__savsp,A4),A0		;506ce: 206c3560
	MOVE.L	(__savsp,A4),D0		;506d2: 202c3560
	SUB.L	(4,A0),D0		;506d6: 90a80004
	ADDQ.L	#8,D0			;506da: 5080
	MOVE.L	D0,(__stkbase,A4)	;506dc: 29403570
	MOVEA.L	(__stkbase,A4),A0	;506e0: 206c3570
	MOVE.L	#$4d414e58,(A0)		;506e4: 20bc4d414e58
	CLR.L	-(A7)			;506ea: 42a7
	JSR	(__FindTask,PC)		;506ec: 4eba0c16
	MOVEA.L	D0,A2			;506f0: 2440
	TST.L	($AC,A2)		;506f2: 4aaa00ac
	ADDQ.W	#4,A7			;506f6: 584f
	BEQ.S	LAB_50728		;506f8: 672e
	MOVE.L	($C,A5),-(A7)		;506fa: 2f2d000c
	MOVE.L	(8,A5),-(A7)		;506fe: 2f2d0008
	MOVE.L	A2,-(A7)		;50702: 2f0a
	JSR	(__cli_parse,PC)	;50704: 4eba00ae
	MOVE.W	#$0001,(_Enable_Abort,A4) ;50708: 397c00013574
	MOVEA.L	(__devtab,A4),A0	;5070e: 206c356c
	ORI.W	#$8000,(4,A0)		;50712: 006880000004
	MOVEA.L	(__devtab,A4),A0	;50718: 206c356c
	ORI.W	#$8000,($A,A0)		;5071c: 00688000000a
	LEA	($C,A7),A7		;50722: 4fef000c
	BRA.S	LAB_5076A		;50726: 6042
LAB_50728:
	PEA	($5C,A2)		;50728: 486a005c
	JSR	(__WaitPort,PC)		;5072c: 4eba0c86
	PEA	($5C,A2)		;50730: 486a005c
	JSR	(__GetMsg,PC)		;50734: 4eba0c02
	MOVE.L	D0,(_WBenchMsg,A4)	;50738: 29403576
	MOVEA.L	(_WBenchMsg,A4),A0	;5073c: 206c3576
	TST.L	($24,A0)		;50740: 4aa80024
	ADDQ.W	#8,A7			;50744: 504f
	BEQ.S	LAB_50758		;50746: 6710
	MOVEA.L	(_WBenchMsg,A4),A0	;50748: 206c3576
	MOVEA.L	($24,A0),A1		;5074c: 22680024
	MOVE.L	(A1),-(A7)		;50750: 2f11
	JSR	(__CurrentDir,PC)	;50752: 4eba0980
	ADDQ.W	#4,A7			;50756: 584f
LAB_50758:
	MOVE.L	(_WBenchMsg,A4),-(A7)	;50758: 2f2c3576
	MOVE.L	A2,-(A7)		;5075c: 2f0a
	JSR	(__wb_parse,PC)		;5075e: 4eba028c
	MOVE.L	(_WBenchMsg,A4),(__argv,A4) ;50762: 296c3576357a
	ADDQ.W	#8,A7			;50768: 504f
LAB_5076A:
	JSR	(__Input,PC)		;5076a: 4eba09a0
	MOVEA.L	(__devtab,A4),A0	;5076e: 206c356c
	MOVE.L	D0,(A0)			;50772: 2080
	JSR	(__Output,PC)		;50774: 4eba09ce
	MOVEA.L	(__devtab,A4),A0	;50778: 206c356c
	MOVE.L	D0,(6,A0)		;5077c: 21400006
	BEQ.S	LAB_50798		;50780: 6716
	PEA	$3ED.W			;50782: 487803ed
	PEA	(LAB_507B2,PC)		;50786: 487a002a
	JSR	(__Open,PC)		;5078a: 4eba09aa
	MOVEA.L	(__devtab,A4),A0	;5078e: 206c356c
	MOVE.L	D0,($C,A0)		;50792: 2140000c
	ADDQ.W	#8,A7			;50796: 504f
LAB_50798:
	MOVE.L	(__argv,A4),-(A7)	;50798: 2f2c357a
	MOVE.W	(__argc,A4),-(A7)	;5079c: 3f2c357e
	JSR	(___main,A4)		;507a0: 4eac8008
	CLR.W	-(A7)			;507a4: 4267
	JSR	(___exit,A4)		;507a6: 4eac81d0
	ADDQ.W	#8,A7			;507aa: 504f
	MOVEA.L	(A7)+,A2		;507ac: 245f
	UNLK	A5			;507ae: 4e5d
	RTS				;507b0: 4e75
LAB_507B2:
	MOVE.L	D0,D5			;507b2: 2a00
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
__cli_parse:
	LINK.W	A5,#0			;507b4: 4e550000
	MOVEM.L	D4-D5/A2-A3,-(A7)	;507b8: 48e70c30
	MOVEA.L	($10,A5),A2		;507bc: 246d0010
	MOVEA.L	(8,A5),A0		;507c0: 206d0008
	TST.L	($AC,A0)		;507c4: 4aa800ac
	BEQ.S	LAB_507E2		;507c8: 6718
	MOVEA.L	(8,A5),A0		;507ca: 206d0008
	MOVE.L	($AC,A0),D0		;507ce: 202800ac
	ASL.L	#2,D0			;507d2: e580
	MOVE.L	D0,D4			;507d4: 2800
	MOVEA.L	D4,A0			;507d6: 2044
	MOVE.L	($10,A0),D0		;507d8: 20280010
	ASL.L	#2,D0			;507dc: e580
	MOVEA.L	D0,A3			;507de: 2640
	BRA.S	LAB_507E6		;507e0: 6004
LAB_507E2:
	MOVEA.L	(__detach_name,A4),A3	;507e2: 266c983c
LAB_507E6:
	MOVE.B	(A3),D0			;507e6: 1013
	EXT.W	D0			;507e8: 4880
	EXT.L	D0			;507ea: 48c0
	ADD.L	($C,A5),D0		;507ec: d0ad000c
	ADDQ.L	#2,D0			;507f0: 5480
	MOVE.W	D0,(__arg_len,A4)	;507f2: 39403580
	CLR.L	-(A7)			;507f6: 42a7
	MOVE.W	(__arg_len,A4),D0	;507f8: 302c3580
	EXT.L	D0			;507fc: 48c0
	MOVE.L	D0,-(A7)		;507fe: 2f00
	JSR	(__AllocMem,PC)		;50800: 4eba0af0
	MOVE.L	D0,(__arg_lin,A4)	;50804: 29403582
	ADDQ.W	#8,A7			;50808: 504f
	BNE.S	LAB_50814		;5080a: 6608
LAB_5080C:
	MOVEM.L	(A7)+,D4-D5/A2-A3	;5080c: 4cdf0c30
	UNLK	A5			;50810: 4e5d
	RTS				;50812: 4e75
LAB_50814:
	MOVE.B	(A3),D0			;50814: 1013
	EXT.W	D0			;50816: 4880
	MOVE.W	D0,D5			;50818: 3a00
	MOVE.W	D5,-(A7)		;5081a: 3f05
	MOVEA.L	A3,A0			;5081c: 204b
	ADDQ.L	#1,A0			;5081e: 5288
	MOVE.L	A0,-(A7)		;50820: 2f08
	MOVE.L	(__arg_lin,A4),-(A7)	;50822: 2f2c3582
	JSR	(_strncpy,PC)		;50826: 4eba017e
	MOVE.W	D5,D0			;5082a: 3005
	EXT.L	D0			;5082c: 48c0
	MOVEA.L	D0,A0			;5082e: 2040
	ADDA.L	(__arg_lin,A4),A0	;50830: d1ec3582
	LEA	(LAB_5097A,PC),A1	;50834: 43fa0144
LAB_50838:
	MOVE.B	(A1)+,(A0)+		;50838: 10d9
	BNE.S	LAB_50838		;5083a: 66fc
	MOVE.W	($E,A5),-(A7)		;5083c: 3f2d000e
	MOVE.L	A2,-(A7)		;50840: 2f0a
	MOVE.L	(__arg_lin,A4),-(A7)	;50842: 2f2c3582
	JSR	(_strncat,PC)		;50846: 4eba013a
	MOVEA.L	(__arg_lin,A4),A0	;5084a: 206c3582
	CLR.B	(0,A0,D5.W)		;5084e: 42305000
	MOVE.W	#$0001,(__argc,A4)	;50852: 397c0001357e
	MOVE.W	D5,D0			;50858: 3005
	EXT.L	D0			;5085a: 48c0
	ADD.L	(__arg_lin,A4),D0	;5085c: d0ac3582
	MOVEA.L	D0,A3			;50860: 2640
	ADDQ.L	#1,A3			;50862: 528b
	MOVEA.L	A3,A2			;50864: 244b
	LEA	($14,A7),A7		;50866: 4fef0014
LAB_5086A:
	MOVE.B	(A3),D0			;5086a: 1013
	EXT.W	D0			;5086c: 4880
	MOVE.W	D0,D5			;5086e: 3a00
	CMP.W	#$0020,D0		;50870: b07c0020
	BEQ.S	LAB_5088E		;50874: 6718
	CMP.W	#$0009,D5		;50876: ba7c0009
	BEQ.S	LAB_5088E		;5087a: 6712
	CMP.W	#$000c,D5		;5087c: ba7c000c
	BEQ.S	LAB_5088E		;50880: 670c
	CMP.W	#$000d,D5		;50882: ba7c000d
	BEQ.S	LAB_5088E		;50886: 6706
	CMP.W	#$000a,D5		;50888: ba7c000a
	BNE.S	LAB_50892		;5088c: 6604
LAB_5088E:
	ADDQ.L	#1,A3			;5088e: 528b
	BRA.S	LAB_5086A		;50890: 60d8
LAB_50892:
	CMPI.B	#$20,(A3)		;50892: 0c130020
	BLT.S	LAB_50912		;50896: 6d7a
	CMPI.B	#$22,(A3)		;50898: 0c130022
	BNE.S	LAB_508CC		;5089c: 662e
	ADDQ.L	#1,A3			;5089e: 528b
LAB_508A0:
	MOVEA.L	A3,A0			;508a0: 204b
	ADDQ.L	#1,A3			;508a2: 528b
	MOVE.B	(A0),D0			;508a4: 1010
	EXT.W	D0			;508a6: 4880
	MOVE.W	D0,D5			;508a8: 3a00
	BEQ.S	LAB_508CA		;508aa: 671e
	MOVEA.L	A2,A0			;508ac: 204a
	ADDQ.L	#1,A2			;508ae: 528a
	MOVE.B	D5,(A0)			;508b0: 1085
	CMP.W	#$0022,D5		;508b2: ba7c0022
	BNE.S	LAB_508C8		;508b6: 6610
	CMPI.B	#$22,(A3)		;508b8: 0c130022
	BNE.S	LAB_508C2		;508bc: 6604
	ADDQ.L	#1,A3			;508be: 528b
	BRA.S	LAB_508C8		;508c0: 6006
LAB_508C2:
	CLR.B	(-1,A2)			;508c2: 422affff
	BRA.S	LAB_508CA		;508c6: 6002
LAB_508C8:
	BRA.S	LAB_508A0		;508c8: 60d6
LAB_508CA:
	BRA.S	LAB_50904		;508ca: 6038
LAB_508CC:
	MOVEA.L	A3,A0			;508cc: 204b
	ADDQ.L	#1,A3			;508ce: 528b
	MOVE.B	(A0),D0			;508d0: 1010
	EXT.W	D0			;508d2: 4880
	MOVE.W	D0,D5			;508d4: 3a00
	BEQ.S	LAB_508FE		;508d6: 6726
	CMP.W	#$0020,D5		;508d8: ba7c0020
	BEQ.S	LAB_508FE		;508dc: 6720
	CMP.W	#$0009,D5		;508de: ba7c0009
	BEQ.S	LAB_508FE		;508e2: 671a
	CMP.W	#$000c,D5		;508e4: ba7c000c
	BEQ.S	LAB_508FE		;508e8: 6714
	CMP.W	#$000d,D5		;508ea: ba7c000d
	BEQ.S	LAB_508FE		;508ee: 670e
	CMP.W	#$000a,D5		;508f0: ba7c000a
	BEQ.S	LAB_508FE		;508f4: 6708
	MOVEA.L	A2,A0			;508f6: 204a
	ADDQ.L	#1,A2			;508f8: 528a
	MOVE.B	D5,(A0)			;508fa: 1085
	BRA.S	LAB_508CC		;508fc: 60ce
LAB_508FE:
	MOVEA.L	A2,A0			;508fe: 204a
	ADDQ.L	#1,A2			;50900: 528a
	CLR.B	(A0)			;50902: 4210
LAB_50904:
	TST.W	D5			;50904: 4a45
	BNE.S	LAB_5090A		;50906: 6602
	SUBQ.L	#1,A3			;50908: 538b
LAB_5090A:
	ADDQ.W	#1,(__argc,A4)		;5090a: 526c357e
	BRA.W	LAB_5086A		;5090e: 6000ff5a
LAB_50912:
	CLR.B	(A2)			;50912: 4212
	CLR.L	-(A7)			;50914: 42a7
	MOVE.W	(__argc,A4),D0		;50916: 302c357e
	ADDQ.W	#1,D0			;5091a: 5240
	EXT.L	D0			;5091c: 48c0
	ASL.L	#2,D0			;5091e: e580
	MOVE.L	D0,-(A7)		;50920: 2f00
	JSR	(__AllocMem,PC)		;50922: 4eba09ce
	MOVE.L	D0,(__argv,A4)		;50926: 2940357a
	ADDQ.W	#8,A7			;5092a: 504f
	BNE.S	LAB_50936		;5092c: 6608
	CLR.W	(__argc,A4)		;5092e: 426c357e
	BRA.W	LAB_5080C		;50932: 6000fed8
LAB_50936:
	MOVEQ	#0,D5			;50936: 7a00
	MOVEA.L	(__arg_lin,A4),A3	;50938: 266c3582
	BRA.S	LAB_50962		;5093c: 6024
LAB_5093E:
	MOVE.W	D5,D0			;5093e: 3005
	EXT.L	D0			;50940: 48c0
	ASL.L	#2,D0			;50942: e580
	MOVEA.L	(__argv,A4),A0		;50944: 206c357a
	MOVE.L	A3,(0,A0,D0.L)		;50948: 218b0800
	MOVEA.L	A3,A0			;5094c: 204b
	MOVE.L	A0,D0			;5094e: 2008
LAB_50950:
	TST.B	(A0)+			;50950: 4a18
	BNE.S	LAB_50950		;50952: 66fc
	SUBA.L	D0,A0			;50954: 91c0
	SUBQ.L	#1,A0			;50956: 5388
	MOVE.W	A0,D0			;50958: 3008
	ADDQ.W	#1,D0			;5095a: 5240
	EXT.L	D0			;5095c: 48c0
	ADDA.L	D0,A3			;5095e: d7c0
	ADDQ.W	#1,D5			;50960: 5245
LAB_50962:
	CMP.W	(__argc,A4),D5		;50962: ba6c357e
	BLT.S	LAB_5093E		;50966: 6dd6
	MOVE.W	D5,D0			;50968: 3005
	EXT.L	D0			;5096a: 48c0
	ASL.L	#2,D0			;5096c: e580
	MOVEA.L	(__argv,A4),A0		;5096e: 206c357a
	CLR.L	(0,A0,D0.L)		;50972: 42b00800
	BRA.W	LAB_5080C		;50976: 6000fe94
LAB_5097A:
	MOVE.L	D0,D0			;5097a: 2000
_strcat:
	MOVE.W	#$7fff,D0		;5097c: 303c7fff
	BRA.S	LAB_50986		;50980: 6004
_strncat:
	MOVE.W	($C,A7),D0		;50982: 302f000c
LAB_50986:
	MOVEA.L	(4,A7),A0		;50986: 206f0004
LAB_5098A:
	TST.B	(A0)+			;5098a: 4a18
	BNE.S	LAB_5098A		;5098c: 66fc
	SUBQ.W	#1,A0			;5098e: 5348
	MOVEA.L	(8,A7),A1		;50990: 226f0008
	SUBQ.W	#1,D0			;50994: 5340
LAB_50996:
	MOVE.B	(A1)+,(A0)+		;50996: 10d9
	DBEQ	D0,LAB_50996		;50998: 57c8fffc
	BEQ.S	LAB_509A0		;5099c: 6702
	CLR.B	(A0)			;5099e: 4210
LAB_509A0:
	MOVE.L	(4,A7),D0		;509a0: 202f0004
	RTS				;509a4: 4e75
_strncpy:
	MOVEM.L	(4,A7),A0-A1		;509a6: 4cef03000004
	MOVE.L	A0,D0			;509ac: 2008
	MOVE.W	($C,A7),D1		;509ae: 322f000c
	BRA.S	LAB_509B6		;509b2: 6002
LAB_509B4:
	MOVE.B	(A1)+,(A0)+		;509b4: 10d9
LAB_509B6:
	DBEQ	D1,LAB_509B4		;509b6: 57c9fffc
	BEQ.S	LAB_509C2		;509ba: 6706
	ADDQ.W	#1,D1			;509bc: 5241
	BRA.S	LAB_509C2		;509be: 6002
LAB_509C0:
	CLR.B	(A0)+			;509c0: 4218
LAB_509C2:
	DBF	D1,LAB_509C0		;509c2: 51c9fffc
	RTS				;509c6: 4e75
_mulu:
	MOVEM.L	D1-D3,-(A7)		;509c8: 48e77000
	MOVE.W	D1,D2			;509cc: 3401
	MULU	D0,D2			;509ce: c4c0
	MOVE.L	D1,D3			;509d0: 2601
	SWAP	D3			;509d2: 4843
	MULU	D0,D3			;509d4: c6c0
	SWAP	D3			;509d6: 4843
	CLR.W	D3			;509d8: 4243
	ADD.L	D3,D2			;509da: d483
	SWAP	D0			;509dc: 4840
	MULU	D1,D0			;509de: c0c1
	SWAP	D0			;509e0: 4840
	CLR.W	D0			;509e2: 4240
	ADD.L	D2,D0			;509e4: d082
	MOVEM.L	(A7)+,D1-D3		;509e6: 4cdf000e
	RTS				;509ea: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
__wb_parse:
	LINK.W	A5,#0			;509ec: 4e550000
	MOVEM.L	D4-D6/A2-A3,-(A7)	;509f0: 48e70e30
	MOVEA.L	(8,A5),A2		;509f4: 246d0008
	CLR.L	-(A7)			;509f8: 42a7
	PEA	(IconLibName,PC)	;509fa: 487a008e
	JSR	(__OpenLibrary,PC)	;509fe: 4eba0970
	MOVE.L	D0,(_IconBase,A4)	;50a02: 29403586
	ADDQ.W	#8,A7			;50a06: 504f
	BNE.S	LAB_50A12		;50a08: 6608
LAB_50A0A:
	MOVEM.L	(A7)+,D4-D6/A2-A3	;50a0a: 4cdf0c70
	UNLK	A5			;50a0e: 4e5d
	RTS				;50a10: 4e75
LAB_50A12:
	MOVEA.L	($C,A5),A0		;50a12: 206d000c
	MOVEA.L	($24,A0),A1		;50a16: 22680024
	MOVE.L	(4,A1),-(A7)		;50a1a: 2f290004
	JSR	(_GetDiskObject,PC)	;50a1e: 4eba09ba
	MOVE.L	D0,D4			;50a22: 2800
	ADDQ.W	#4,A7			;50a24: 584f
	BEQ.S	LAB_50A7A		;50a26: 6752
	PEA	(strWINDOW,PC)		;50a28: 487a006d
	MOVEA.L	D4,A0			;50a2c: 2044
	MOVE.L	($36,A0),-(A7)		;50a2e: 2f280036
	JSR	(_FindToolType,PC)	;50a32: 4eba098c
	MOVEA.L	D0,A3			;50a36: 2640
	TST.L	D0			;50a38: 4a80
	ADDQ.W	#8,A7			;50a3a: 504f
	BEQ.S	LAB_50A72		;50a3c: 6734
	PEA	$3ED.W			;50a3e: 487803ed
	MOVE.L	A3,-(A7)		;50a42: 2f0b
	JSR	(__Open,PC)		;50a44: 4eba06f0
	MOVE.L	D0,D6			;50a48: 2c00
	ADDQ.W	#8,A7			;50a4a: 504f
	BEQ.S	LAB_50A72		;50a4c: 6724
	MOVE.L	D6,D0			;50a4e: 2006
	ASL.L	#2,D0			;50a50: e580
	MOVE.L	D0,D5			;50a52: 2a00
	MOVEA.L	D5,A0			;50a54: 2045
	MOVE.L	(8,A0),($A4,A2)		;50a56: 2568000800a4
	MOVE.L	D6,($9C,A2)		;50a5c: 2546009c
	PEA	$3ED.W			;50a60: 487803ed
	PEA	(strAsterisk,PC)	;50a64: 487a0038
	JSR	(__Open,PC)		;50a68: 4eba06cc
	MOVE.L	D0,($A0,A2)		;50a6c: 254000a0
	ADDQ.W	#8,A7			;50a70: 504f
LAB_50A72:
	MOVE.L	D4,-(A7)		;50a72: 2f04
	JSR	(_FreeDiskObject,PC)	;50a74: 4eba0958
	ADDQ.W	#4,A7			;50a78: 584f
LAB_50A7A:
	MOVE.L	(_IconBase,A4),-(A7)	;50a7a: 2f2c3586
	JSR	(___CloseLibrary,A4)	;50a7e: 4eac81fa
	CLR.L	(_IconBase,A4)		;50a82: 42ac3586
	ADDQ.W	#4,A7			;50a86: 584f
	BRA.S	LAB_50A0A		;50a88: 6080
IconLibName:
	;50a8a
	;DC.B	$69,$63,$6f,$6e,$2e,$6c,$69,$62,$72,$61,$72,$79,$00
	DC.B	"icon.library",0
strWINDOW:
	;50a97
	;DC.B	$57,$49,$4e,$44,$4f,$57,$00
	DC.B	"WINDOW",0
strAsterisk:
	DC.W	$2a00			;50a9e
; ------------------------------------------------------------------------------
; Function
; new code
; ------------------------------------------------------------------------------
_sprintf:
	LINK.W	A5,#0			;50aa0: 4e550000
	MOVE.L	D4,-(A7)		;50aa4: 2f04
	MOVE.L	(8,A5),(__H1_end,A4)	;50aa6: 296d00089846
	PEA	($10,A5)		;50aac: 486d0010
	MOVE.L	($C,A5),-(A7)		;50ab0: 2f2d000c
	PEA	(LAB_50AD0,PC)		;50ab4: 487a001a
	JSR	(_format,PC)		;50ab8: 4eba00c0
	MOVE.W	D0,D4			;50abc: 3800
	MOVEA.L	(__H1_end,A4),A0	;50abe: 206c9846
	CLR.B	(A0)			;50ac2: 4210
	MOVE.W	D4,D0			;50ac4: 3004
	LEA	($C,A7),A7		;50ac6: 4fef000c
	MOVE.L	(A7)+,D4		;50aca: 281f
	UNLK	A5			;50acc: 4e5d
	RTS				;50ace: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
LAB_50AD0:
	LINK.W	A5,#0			;50ad0: 4e550000
	MOVEA.L	(__H1_end,A4),A0	;50ad4: 206c9846
	ADDQ.L	#1,(__H1_end,A4)	;50ad8: 52ac9846
	MOVE.B	(9,A5),D0		;50adc: 102d0009
	MOVE.B	D0,(A0)			;50ae0: 1080
	EXT.W	D0			;50ae2: 4880
	AND.W	#$00ff,D0		;50ae4: c07c00ff
	UNLK	A5			;50ae8: 4e5d
	RTS				;50aea: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
SUB_50AEC:
	LINK.W	A5,#0			;50aec: 4e550000
	MOVEM.L	D4/A2,-(A7)		;50af0: 48e70820
	MOVEA.L	($E,A5),A2		;50af4: 246d000e
	CMPI.W	#$0004,($12,A5)		;50af8: 0c6d00040012
	BNE.S	LAB_50B08		;50afe: 6608
	MOVEA.L	(8,A5),A0		;50b00: 206d0008
	MOVE.L	(A0),D4			;50b04: 2810
	BRA.S	LAB_50B24		;50b06: 601c
LAB_50B08:
	TST.W	($C,A5)			;50b08: 4a6d000c
	BLE.S	LAB_50B1A		;50b0c: 6f0c
	MOVEA.L	(8,A5),A0		;50b0e: 206d0008
	MOVEQ	#0,D0			;50b12: 7000
	MOVE.W	(A0),D0			;50b14: 3010
	MOVE.L	D0,D4			;50b16: 2800
	BRA.S	LAB_50B24		;50b18: 600a
LAB_50B1A:
	MOVEA.L	(8,A5),A0		;50b1a: 206d0008
	MOVE.W	(A0),D0			;50b1e: 3010
	EXT.L	D0			;50b20: 48c0
	MOVE.L	D0,D4			;50b22: 2800
LAB_50B24:
	CLR.W	($12,A5)		;50b24: 426d0012
	TST.W	($C,A5)			;50b28: 4a6d000c
	BGE.S	LAB_50B3E		;50b2c: 6c10
	NEG.W	($C,A5)			;50b2e: 446d000c
	TST.L	D4			;50b32: 4a84
	BGE.S	LAB_50B3E		;50b34: 6c08
	NEG.L	D4			;50b36: 4484
	MOVE.W	#$0001,($12,A5)		;50b38: 3b7c00010012
LAB_50B3E:
	MOVE.W	($C,A5),D1		;50b3e: 322d000c
	EXT.L	D1			;50b42: 48c1
	MOVE.L	D4,D0			;50b44: 2004
	JSR	(_modu,PC)		;50b46: 4eba0390
	LEA	(LAB_52B94,A4),A0	;50b4a: 41ec97a6
	SUBQ.L	#1,A2			;50b4e: 538a
	MOVE.B	(0,A0,D0.W),(A2)	;50b50: 14b00000
	MOVE.W	($C,A5),D1		;50b54: 322d000c
	EXT.L	D1			;50b58: 48c1
	MOVE.L	D4,D0			;50b5a: 2004
	JSR	(_divu,PC)		;50b5c: 4eba0386
	MOVE.L	D0,D4			;50b60: 2800
	BNE.S	LAB_50B3E		;50b62: 66da
	TST.W	($12,A5)		;50b64: 4a6d0012
	BEQ.S	LAB_50B70		;50b68: 6706
	SUBQ.L	#1,A2			;50b6a: 538a
	MOVE.B	#$2d,(A2)		;50b6c: 14bc002d
LAB_50B70:
	MOVE.L	A2,D0			;50b70: 200a
	MOVEM.L	(A7)+,D4/A2		;50b72: 4cdf0410
	UNLK	A5			;50b76: 4e5d
	RTS				;50b78: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_format:
	LINK.W	A5,#-222		;50b7a: 4e55ff22
	MOVEM.L	D4/A2-A3,-(A7)		;50b7e: 48e70830
	MOVEA.L	(8,A5),A2		;50b82: 246d0008
	MOVEA.L	($C,A5),A3		;50b86: 266d000c
	CLR.W	(-6,A5)			;50b8a: 426dfffa
	MOVE.L	($10,A5),(-4,A5)	;50b8e: 2b6d0010fffc
LAB_50B94:
	MOVEA.L	A3,A0			;50b94: 204b
	ADDQ.L	#1,A3			;50b96: 528b
	MOVE.B	(A0),D0			;50b98: 1010
	EXT.W	D0			;50b9a: 4880
	MOVE.W	D0,D4			;50b9c: 3800
	BEQ.W	LAB_50E8E		;50b9e: 670002ee
	CMP.W	#$0025,D4		;50ba2: b87c0025
	BNE.W	LAB_50E74		;50ba6: 660002cc
	CLR.B	(-208,A5)		;50baa: 422dff30
	MOVE.W	#$0001,(-8,A5)		;50bae: 3b7c0001fff8
	MOVE.W	#$0020,(-10,A5)		;50bb4: 3b7c0020fff6
	MOVE.W	#$2710,(-12,A5)		;50bba: 3b7c2710fff4
	MOVEA.L	A3,A0			;50bc0: 204b
	ADDQ.L	#1,A3			;50bc2: 528b
	MOVE.B	(A0),D0			;50bc4: 1010
	EXT.W	D0			;50bc6: 4880
	MOVE.W	D0,D4			;50bc8: 3800
	CMP.W	#$002d,D0		;50bca: b07c002d
	BNE.S	LAB_50BDE		;50bce: 660e
	CLR.W	(-8,A5)			;50bd0: 426dfff8
	MOVEA.L	A3,A0			;50bd4: 204b
	ADDQ.L	#1,A3			;50bd6: 528b
	MOVE.B	(A0),D0			;50bd8: 1010
	EXT.W	D0			;50bda: 4880
	MOVE.W	D0,D4			;50bdc: 3800
LAB_50BDE:
	CMP.W	#$0030,D4		;50bde: b87c0030
	BNE.S	LAB_50BF4		;50be2: 6610
	MOVE.W	#$0030,(-10,A5)		;50be4: 3b7c0030fff6
	MOVEA.L	A3,A0			;50bea: 204b
	ADDQ.L	#1,A3			;50bec: 528b
	MOVE.B	(A0),D0			;50bee: 1010
	EXT.W	D0			;50bf0: 4880
	MOVE.W	D0,D4			;50bf2: 3800
LAB_50BF4:
	CMP.W	#$002a,D4		;50bf4: b87c002a
	BNE.S	LAB_50C12		;50bf8: 6618
	MOVEA.L	(-4,A5),A0		;50bfa: 206dfffc
	ADDQ.L	#2,(-4,A5)		;50bfe: 54adfffc
	MOVE.W	(A0),(-14,A5)		;50c02: 3b50fff2
	MOVEA.L	A3,A0			;50c06: 204b
	ADDQ.L	#1,A3			;50c08: 528b
	MOVE.B	(A0),D0			;50c0a: 1010
	EXT.W	D0			;50c0c: 4880
	MOVE.W	D0,D4			;50c0e: 3800
	BRA.S	LAB_50C44		;50c10: 6032
LAB_50C12:
	CLR.W	(-14,A5)		;50c12: 426dfff2
	BRA.S	LAB_50C34		;50c16: 601c
LAB_50C18:
	MOVE.W	(-14,A5),D0		;50c18: 302dfff2
	MULS	#$000a,D0		;50c1c: c1fc000a
	ADD.W	D4,D0			;50c20: d044
	SUB.W	#$0030,D0		;50c22: 907c0030
	MOVE.W	D0,(-14,A5)		;50c26: 3b40fff2
	MOVEA.L	A3,A0			;50c2a: 204b
	ADDQ.L	#1,A3			;50c2c: 528b
	MOVE.B	(A0),D0			;50c2e: 1010
	EXT.W	D0			;50c30: 4880
	MOVE.W	D0,D4			;50c32: 3800
LAB_50C34:
	MOVE.W	D4,D0			;50c34: 3004
	ADDQ.W	#1,D0			;50c36: 5240
	LEA	(_ctp_,A4),A0		;50c38: 41ec97b8
	BTST	#2,(0,A0,D0.W)		;50c3c: 083000020000
	BNE.S	LAB_50C18		;50c42: 66d4
LAB_50C44:
	CMP.W	#$002e,D4		;50c44: b87c002e
	BNE.S	LAB_50CA4		;50c48: 665a
	MOVEA.L	A3,A0			;50c4a: 204b
	ADDQ.L	#1,A3			;50c4c: 528b
	MOVE.B	(A0),D0			;50c4e: 1010
	EXT.W	D0			;50c50: 4880
	MOVE.W	D0,D4			;50c52: 3800
	CMP.W	#$002a,D0		;50c54: b07c002a
	BNE.S	LAB_50C72		;50c58: 6618
	MOVEA.L	(-4,A5),A0		;50c5a: 206dfffc
	ADDQ.L	#2,(-4,A5)		;50c5e: 54adfffc
	MOVE.W	(A0),(-12,A5)		;50c62: 3b50fff4
	MOVEA.L	A3,A0			;50c66: 204b
	ADDQ.L	#1,A3			;50c68: 528b
	MOVE.B	(A0),D0			;50c6a: 1010
	EXT.W	D0			;50c6c: 4880
	MOVE.W	D0,D4			;50c6e: 3800
	BRA.S	LAB_50CA4		;50c70: 6032
LAB_50C72:
	CLR.W	(-12,A5)		;50c72: 426dfff4
	BRA.S	LAB_50C94		;50c76: 601c
LAB_50C78:
	MOVE.W	(-12,A5),D0		;50c78: 302dfff4
	MULS	#$000a,D0		;50c7c: c1fc000a
	ADD.W	D4,D0			;50c80: d044
	SUB.W	#$0030,D0		;50c82: 907c0030
	MOVE.W	D0,(-12,A5)		;50c86: 3b40fff4
	MOVEA.L	A3,A0			;50c8a: 204b
	ADDQ.L	#1,A3			;50c8c: 528b
	MOVE.B	(A0),D0			;50c8e: 1010
	EXT.W	D0			;50c90: 4880
	MOVE.W	D0,D4			;50c92: 3800
LAB_50C94:
	MOVE.W	D4,D0			;50c94: 3004
	ADDQ.W	#1,D0			;50c96: 5240
	LEA	(_ctp_,A4),A0		;50c98: 41ec97b8
	BTST	#2,(0,A0,D0.W)		;50c9c: 083000020000
	BNE.S	LAB_50C78		;50ca2: 66d4
LAB_50CA4:
	MOVE.W	#$0002,(-16,A5)		;50ca4: 3b7c0002fff0
	CMP.W	#$006c,D4		;50caa: b87c006c
	BNE.S	LAB_50CC2		;50cae: 6612
	MOVEA.L	A3,A0			;50cb0: 204b
	ADDQ.L	#1,A3			;50cb2: 528b
	MOVE.B	(A0),D0			;50cb4: 1010
	EXT.W	D0			;50cb6: 4880
	MOVE.W	D0,D4			;50cb8: 3800
	MOVE.W	#$0004,(-16,A5)		;50cba: 3b7c0004fff0
	BRA.S	LAB_50CD2		;50cc0: 6010
LAB_50CC2:
	CMP.W	#$0068,D4		;50cc2: b87c0068
	BNE.S	LAB_50CD2		;50cc6: 660a
	MOVEA.L	A3,A0			;50cc8: 204b
	ADDQ.L	#1,A3			;50cca: 528b
	MOVE.B	(A0),D0			;50ccc: 1010
	EXT.W	D0			;50cce: 4880
	MOVE.W	D0,D4			;50cd0: 3800
LAB_50CD2:
	MOVE.W	D4,D0			;50cd2: 3004
	EXT.L	D0			;50cd4: 48c0
	BRA.S	LAB_50D52		;50cd6: 607a
LAB_50CD8:
	MOVE.W	#$0008,(-18,A5)		;50cd8: 3b7c0008ffee
	BRA.S	LAB_50CF6		;50cde: 6016
LAB_50CE0:
	MOVE.W	#$000a,(-18,A5)		;50ce0: 3b7c000affee
	BRA.S	LAB_50CF6		;50ce6: 600e
LAB_50CE8:
	MOVE.W	#$0010,(-18,A5)		;50ce8: 3b7c0010ffee
	BRA.S	LAB_50CF6		;50cee: 6006
LAB_50CF0:
	MOVE.W	#$fff6,(-18,A5)		;50cf0: 3b7cfff6ffee
LAB_50CF6:
	MOVE.W	(-16,A5),-(A7)		;50cf6: 3f2dfff0
	PEA	(-208,A5)		;50cfa: 486dff30
	MOVE.W	(-18,A5),-(A7)		;50cfe: 3f2dffee
	MOVE.L	(-4,A5),-(A7)		;50d02: 2f2dfffc
	JSR	(SUB_50AEC,PC)		;50d06: 4ebafde4
	MOVE.L	D0,(-22,A5)		;50d0a: 2b40ffea
	MOVE.W	(-16,A5),D0		;50d0e: 302dfff0
	EXT.L	D0			;50d12: 48c0
	ADD.L	D0,(-4,A5)		;50d14: d1adfffc
	LEA	($C,A7),A7		;50d18: 4fef000c
	BRA.S	LAB_50D7A		;50d1c: 605c
LAB_50D1E:
	MOVEA.L	(-4,A5),A0		;50d1e: 206dfffc
	ADDQ.L	#4,(-4,A5)		;50d22: 58adfffc
	MOVEA.L	(A0),A1			;50d26: 2250
	MOVE.L	A1,(-22,A5)		;50d28: 2b49ffea
	MOVE.L	A1,D0			;50d2c: 2009
LAB_50D2E:
	TST.B	(A1)+			;50d2e: 4a19
	BNE.S	LAB_50D2E		;50d30: 66fc
	SUBA.L	D0,A1			;50d32: 93c0
	SUBQ.L	#1,A1			;50d34: 5389
	MOVE.W	A1,(-16,A5)		;50d36: 3b49fff0
	BRA.S	LAB_50D86		;50d3a: 604a
LAB_50D3C:
	MOVEA.L	(-4,A5),A0		;50d3c: 206dfffc
	ADDQ.L	#2,(-4,A5)		;50d40: 54adfffc
	MOVE.W	(A0),D4			;50d44: 3810
LAB_50D46:
	LEA	(-209,A5),A0		;50d46: 41edff2f
	MOVE.L	A0,(-22,A5)		;50d4a: 2b48ffea
	MOVE.B	D4,(A0)			;50d4e: 1084
	BRA.S	LAB_50D7A		;50d50: 6028
LAB_50D52:
	SUB.L	#$00000063,D0		;50d52: 90bc00000063
	BEQ.S	LAB_50D3C		;50d58: 67e2
	SUBQ.L	#1,D0			;50d5a: 5380
	BEQ.S	LAB_50CF0		;50d5c: 6792
	SUB.L	#$0000000b,D0		;50d5e: 90bc0000000b
	BEQ.W	LAB_50CD8		;50d64: 6700ff72
	SUBQ.L	#4,D0			;50d68: 5980
	BEQ.S	LAB_50D1E		;50d6a: 67b2
	SUBQ.L	#2,D0			;50d6c: 5580
	BEQ.W	LAB_50CE0		;50d6e: 6700ff70
	SUBQ.L	#3,D0			;50d72: 5780
	BEQ.W	LAB_50CE8		;50d74: 6700ff72
	BRA.S	LAB_50D46		;50d78: 60cc
LAB_50D7A:
	LEA	(-208,A5),A0		;50d7a: 41edff30
	SUBA.L	(-22,A5),A0		;50d7e: 91edffea
	MOVE.W	A0,(-16,A5)		;50d82: 3b48fff0
LAB_50D86:
	MOVE.W	(-16,A5),D0		;50d86: 302dfff0
	CMP.W	(-12,A5),D0		;50d8a: b06dfff4
	BLE.S	LAB_50D96		;50d8e: 6f06
	MOVE.W	(-12,A5),(-16,A5)	;50d90: 3b6dfff4fff0
LAB_50D96:
	TST.W	(-8,A5)			;50d96: 4a6dfff8
	BEQ.S	LAB_50E04		;50d9a: 6768
	MOVEA.L	(-22,A5),A0		;50d9c: 206dffea
	CMPI.B	#$2d,(A0)		;50da0: 0c10002d
	BEQ.S	LAB_50DB0		;50da4: 670a
	MOVEA.L	(-22,A5),A0		;50da6: 206dffea
	CMPI.B	#$2b,(A0)		;50daa: 0c10002b
	BNE.S	LAB_50DDE		;50dae: 662e
LAB_50DB0:
	CMPI.W	#$0030,(-10,A5)		;50db0: 0c6d0030fff6
	BNE.S	LAB_50DDE		;50db6: 6626
	SUBQ.W	#1,(-14,A5)		;50db8: 536dfff2
	MOVEA.L	(-22,A5),A0		;50dbc: 206dffea
	ADDQ.L	#1,(-22,A5)		;50dc0: 52adffea
	MOVE.B	(A0),D0			;50dc4: 1010
	EXT.W	D0			;50dc6: 4880
	MOVE.W	D0,-(A7)		;50dc8: 3f00
	JSR	(A2)			;50dca: 4e92
	CMP.W	#$ffff,D0		;50dcc: b07cffff
	ADDQ.W	#2,A7			;50dd0: 544f
	BNE.S	LAB_50DDE		;50dd2: 660a
	MOVEQ	#-1,D0			;50dd4: 70ff
LAB_50DD6:
	MOVEM.L	(A7)+,D4/A2-A3		;50dd6: 4cdf0c10
	UNLK	A5			;50dda: 4e5d
	RTS				;50ddc: 4e75
LAB_50DDE:
	BRA.S	LAB_50DF6		;50dde: 6016
LAB_50DE0:
	MOVE.W	(-10,A5),-(A7)		;50de0: 3f2dfff6
	JSR	(A2)			;50de4: 4e92
	CMP.W	#$ffff,D0		;50de6: b07cffff
	ADDQ.W	#2,A7			;50dea: 544f
	BNE.S	LAB_50DF2		;50dec: 6604
	MOVEQ	#-1,D0			;50dee: 70ff
	BRA.S	LAB_50DD6		;50df0: 60e4
LAB_50DF2:
	ADDQ.W	#1,(-6,A5)		;50df2: 526dfffa
LAB_50DF6:
	MOVE.W	(-14,A5),D0		;50df6: 302dfff2
	SUBQ.W	#1,(-14,A5)		;50dfa: 536dfff2
	CMP.W	(-16,A5),D0		;50dfe: b06dfff0
	BGT.S	LAB_50DE0		;50e02: 6edc
LAB_50E04:
	CLR.W	(-18,A5)		;50e04: 426dffee
	BRA.S	LAB_50E2A		;50e08: 6020
LAB_50E0A:
	MOVEA.L	(-22,A5),A0		;50e0a: 206dffea
	ADDQ.L	#1,(-22,A5)		;50e0e: 52adffea
	MOVE.B	(A0),D0			;50e12: 1010
	EXT.W	D0			;50e14: 4880
	MOVE.W	D0,-(A7)		;50e16: 3f00
	JSR	(A2)			;50e18: 4e92
	CMP.W	#$ffff,D0		;50e1a: b07cffff
	ADDQ.W	#2,A7			;50e1e: 544f
	BNE.S	LAB_50E26		;50e20: 6604
	MOVEQ	#-1,D0			;50e22: 70ff
	BRA.S	LAB_50DD6		;50e24: 60b0
LAB_50E26:
	ADDQ.W	#1,(-18,A5)		;50e26: 526dffee
LAB_50E2A:
	MOVEA.L	(-22,A5),A0		;50e2a: 206dffea
	TST.B	(A0)			;50e2e: 4a10
	BEQ.S	LAB_50E3C		;50e30: 670a
	MOVE.W	(-18,A5),D0		;50e32: 302dffee
	CMP.W	(-12,A5),D0		;50e36: b06dfff4
	BLT.S	LAB_50E0A		;50e3a: 6dce
LAB_50E3C:
	MOVE.W	(-18,A5),D0		;50e3c: 302dffee
	ADD.W	D0,(-6,A5)		;50e40: d16dfffa
	TST.W	(-8,A5)			;50e44: 4a6dfff8
	BNE.S	LAB_50E72		;50e48: 6628
	BRA.S	LAB_50E64		;50e4a: 6018
LAB_50E4C:
	MOVE.W	#$0020,-(A7)		;50e4c: 3f3c0020
	JSR	(A2)			;50e50: 4e92
	CMP.W	#$ffff,D0		;50e52: b07cffff
	ADDQ.W	#2,A7			;50e56: 544f
	BNE.S	LAB_50E60		;50e58: 6606
	MOVEQ	#-1,D0			;50e5a: 70ff
	BRA.W	LAB_50DD6		;50e5c: 6000ff78
LAB_50E60:
	ADDQ.W	#1,(-6,A5)		;50e60: 526dfffa
LAB_50E64:
	MOVE.W	(-14,A5),D0		;50e64: 302dfff2
	SUBQ.W	#1,(-14,A5)		;50e68: 536dfff2
	CMP.W	(-16,A5),D0		;50e6c: b06dfff0
	BGT.S	LAB_50E4C		;50e70: 6eda
LAB_50E72:
	BRA.S	LAB_50E8A		;50e72: 6016
LAB_50E74:
	MOVE.W	D4,-(A7)		;50e74: 3f04
	JSR	(A2)			;50e76: 4e92
	CMP.W	#$ffff,D0		;50e78: b07cffff
	ADDQ.W	#2,A7			;50e7c: 544f
	BNE.S	LAB_50E86		;50e7e: 6606
	MOVEQ	#-1,D0			;50e80: 70ff
	BRA.W	LAB_50DD6		;50e82: 6000ff52
LAB_50E86:
	ADDQ.W	#1,(-6,A5)		;50e86: 526dfffa
LAB_50E8A:
	BRA.W	LAB_50B94		;50e8a: 6000fd08
LAB_50E8E:
	MOVE.W	(-6,A5),D0		;50e8e: 302dfffa
	BRA.W	LAB_50DD6		;50e92: 6000ff42
; ------------------------------------------------------------------------------
; end of new code
; ------------------------------------------------------------------------------
_divs:
	MOVEM.L	D1/D4,-(A7)		;50e96: 48e74800
	CLR.L	D4			;50e9a: 4284
	TST.L	D0			;50e9c: 4a80
	BPL.S	LAB_50EA4		;50e9e: 6a04
	NEG.L	D0			;50ea0: 4480
	ADDQ.W	#1,D4			;50ea2: 5244
LAB_50EA4:
	TST.L	D1			;50ea4: 4a81
	BPL.S	LAB_50EAE		;50ea6: 6a06
	NEG.L	D1			;50ea8: 4481
	EORI.W	#$0001,D4		;50eaa: 0a440001
LAB_50EAE:
	BSR.S	SUB_50EEE		;50eae: 613e
LAB_50EB0:
	TST.W	D4			;50eb0: 4a44
	BEQ.S	LAB_50EB6		;50eb2: 6702
	NEG.L	D0			;50eb4: 4480
LAB_50EB6:
	MOVEM.L	(A7)+,D1/D4		;50eb6: 4cdf0012
	TST.L	D0			;50eba: 4a80
	RTS				;50ebc: 4e75
_mods:
	MOVEM.L	D1/D4,-(A7)		;50ebe: 48e74800
	CLR.L	D4			;50ec2: 4284
	TST.L	D0			;50ec4: 4a80
	BPL.S	LAB_50ECC		;50ec6: 6a04
	NEG.L	D0			;50ec8: 4480
	ADDQ.W	#1,D4			;50eca: 5244
LAB_50ECC:
	TST.L	D1			;50ecc: 4a81
	BPL.S	LAB_50ED2		;50ece: 6a02
	NEG.L	D1			;50ed0: 4481
LAB_50ED2:
	BSR.S	SUB_50EEE		;50ed2: 611a
	MOVE.L	D1,D0			;50ed4: 2001
	BRA.S	LAB_50EB0		;50ed6: 60d8
_modu:
	MOVE.L	D1,-(A7)		;50ed8: 2f01
	BSR.S	SUB_50EEE		;50eda: 6112
	MOVE.L	D1,D0			;50edc: 2001
	MOVE.L	(A7)+,D1		;50ede: 221f
	TST.L	D0			;50ee0: 4a80
	RTS				;50ee2: 4e75
_divu:
	MOVE.L	D1,-(A7)		;50ee4: 2f01
	BSR.S	SUB_50EEE		;50ee6: 6106
	MOVE.L	(A7)+,D1		;50ee8: 221f
	TST.L	D0			;50eea: 4a80
	RTS				;50eec: 4e75
SUB_50EEE:
	MOVEM.L	D2-D3,-(A7)		;50eee: 48e73000
	SWAP	D1			;50ef2: 4841
	TST.W	D1			;50ef4: 4a41
	BNE.S	LAB_50F18		;50ef6: 6620
	SWAP	D1			;50ef8: 4841
	MOVE.W	D1,D3			;50efa: 3601
	MOVE.W	D0,D2			;50efc: 3400
	CLR.W	D0			;50efe: 4240
	SWAP	D0			;50f00: 4840
	DIVU	D3,D0			;50f02: 80c3
	MOVE.L	D0,D1			;50f04: 2200
	SWAP	D0			;50f06: 4840
	MOVE.W	D2,D1			;50f08: 3202
	DIVU	D3,D1			;50f0a: 82c3
	MOVE.W	D1,D0			;50f0c: 3001
	CLR.W	D1			;50f0e: 4241
	SWAP	D1			;50f10: 4841
	MOVEM.L	(A7)+,D2-D3		;50f12: 4cdf000c
	RTS				;50f16: 4e75
LAB_50F18:
	SWAP	D1			;50f18: 4841
	MOVE.L	D1,D3			;50f1a: 2601
	MOVE.L	D0,D1			;50f1c: 2200
	CLR.W	D1			;50f1e: 4241
	SWAP	D1			;50f20: 4841
	SWAP	D0			;50f22: 4840
	CLR.W	D0			;50f24: 4240
	MOVEQ	#$F,D2			;50f26: 740f
LAB_50F28:
	ADD.L	D0,D0			;50f28: d080
	ADDX.L	D1,D1			;50f2a: d381
	CMP.L	D1,D3			;50f2c: b681
	BHI.S	LAB_50F34		;50f2e: 6204
	SUB.L	D3,D1			;50f30: 9283
	ADDQ.W	#1,D0			;50f32: 5240
LAB_50F34:
	DBF	D2,LAB_50F28		;50f34: 51cafff2
	MOVEM.L	(A7)+,D2-D3		;50f38: 4cdf000c
	RTS				;50f3c: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_exit:
	LINK.W	A5,#0			;50f3e: 4e550000
	TST.L	(_cls_,A4)		;50f42: 4aac358a
	BEQ.S	LAB_50F4E		;50f46: 6706
	MOVEA.L	(_cls_,A4),A0		;50f48: 206c358a
	JSR	(A0)			;50f4c: 4e90
LAB_50F4E:
	MOVE.W	(8,A5),-(A7)		;50f4e: 3f2d0008
	JSR	(__exit,PC)		;50f52: 4eba0008
	ADDQ.W	#2,A7			;50f56: 544f
	UNLK	A5			;50f58: 4e5d
	RTS				;50f5a: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
__exit:
	LINK.W	A5,#-4			;50f5c: 4e55fffc
	MOVE.L	D4,-(A7)		;50f60: 2f04
	MOVE.W	(8,A5),D0		;50f62: 302d0008
	EXT.L	D0			;50f66: 48c0
	MOVE.L	D0,(-4,A5)		;50f68: 2b40fffc
	TST.L	(__devtab,A4)		;50f6c: 4aac356c
	BEQ.S	LAB_50F9A		;50f70: 6728
	MOVEQ	#0,D4			;50f72: 7800
	BRA.S	LAB_50F80		;50f74: 600a
LAB_50F76:
	MOVE.W	D4,-(A7)		;50f76: 3f04
	JSR	(_close,PC)		;50f78: 4eba00fe
	ADDQ.W	#2,A7			;50f7c: 544f
	ADDQ.W	#1,D4			;50f7e: 5244
LAB_50F80:
	CMP.W	(__numdev,A4),D4	;50f80: b86c983a
	BLT.S	LAB_50F76		;50f84: 6df0
	MOVE.W	(__numdev,A4),D0	;50f86: 302c983a
	MULS	#$0006,D0		;50f8a: c1fc0006
	MOVE.L	D0,-(A7)		;50f8e: 2f00
	MOVE.L	(__devtab,A4),-(A7)	;50f90: 2f2c356c
	JSR	(__FreeMem,PC)		;50f94: 4eba0386
	ADDQ.W	#8,A7			;50f98: 504f
LAB_50F9A:
	TST.L	(__cln,A4)		;50f9a: 4aac358e
	BEQ.S	LAB_50FA6		;50f9e: 6706
	MOVEA.L	(__cln,A4),A0		;50fa0: 206c358e
	JSR	(A0)			;50fa4: 4e90
LAB_50FA6:
	TST.L	(__detach_curdir,A4)	;50fa6: 4aac9840
	BEQ.S	LAB_50FB6		;50faa: 670a
	MOVE.L	(__detach_curdir,A4),-(A7) ;50fac: 2f2c9840
	JSR	(_UnLock,PC)		;50fb0: 4eba01be
	ADDQ.W	#4,A7			;50fb4: 584f
LAB_50FB6:
	TST.L	(__trapaddr,A4)		;50fb6: 4aac3592
	BEQ.S	LAB_50FC4		;50fba: 6708
	MOVEA.L	(__trapaddr,A4),A0	;50fbc: 206c3592
	MOVE.L	(__oldtrap,A4),(A0)	;50fc0: 20ac3596
LAB_50FC4:
	TST.L	(_MathTransBase,A4)	;50fc4: 4aac359a
	BEQ.S	LAB_50FD4		;50fc8: 670a
	MOVE.L	(_MathTransBase,A4),-(A7) ;50fca: 2f2c359a
	JSR	(__CloseLibrary,PC)	;50fce: 4eba0228
	ADDQ.W	#4,A7			;50fd2: 584f
LAB_50FD4:
	TST.L	(_MathBase,A4)		;50fd4: 4aac359e
	BEQ.S	LAB_50FE4		;50fd8: 670a
	MOVE.L	(_MathBase,A4),-(A7)	;50fda: 2f2c359e
	JSR	(__CloseLibrary,PC)	;50fde: 4eba0218
	ADDQ.W	#4,A7			;50fe2: 584f
LAB_50FE4:
	TST.L	(_MathIeeeDoubBasBase,A4) ;50fe4: 4aac35a2
	BEQ.S	LAB_50FF4		;50fe8: 670a
	MOVE.L	(_MathIeeeDoubBasBase,A4),-(A7) ;50fea: 2f2c35a2
	JSR	(__CloseLibrary,PC)	;50fee: 4eba0208
	ADDQ.W	#4,A7			;50ff2: 584f
LAB_50FF4:
	TST.L	(_MathIeeeDoubTransBase,A4) ;50ff4: 4aac35a6
	BEQ.S	LAB_51004		;50ff8: 670a
	MOVE.L	(_MathIeeeDoubTransBase,A4),-(A7) ;50ffa: 2f2c35a6
	JSR	(__CloseLibrary,PC)	;50ffe: 4eba01f8
	ADDQ.W	#4,A7			;51002: 584f
LAB_51004:
	MOVEA.L	ABSEXECBASE.W,A6	;51004: 2c780004
	BTST	#4,($129,A6)		;51008: 082e00040129
	BEQ.S	LAB_51024		;5100e: 6714
	MOVE.L	A5,-(A7)		;51010: 2f0d
	LEA	(LAB_5101E,PC),A5	;51012: 4bfa000a
	JSR	(-30,A6)		;51016: 4eaeffe2
	MOVEA.L	(A7)+,A5		;5101a: 2a5f
	BRA.S	LAB_51024		;5101c: 6006
LAB_5101E:
	CLR.L	-(A7)			;5101e: 42a7
	DC.L	$f35f4e73		;51020
LAB_51024:
	TST.L	(_WBenchMsg,A4)		;51024: 4aac3576
	BNE.S	LAB_5105A		;51028: 6630
	TST.L	(__arg_lin,A4)		;5102a: 4aac3582
	BEQ.S	LAB_51058		;5102e: 6728
	MOVE.W	(__arg_len,A4),D0	;51030: 302c3580
	EXT.L	D0			;51034: 48c0
	MOVE.L	D0,-(A7)		;51036: 2f00
	MOVE.L	(__arg_lin,A4),-(A7)	;51038: 2f2c3582
	JSR	(__FreeMem,PC)		;5103c: 4eba02de
	MOVE.W	(__argc,A4),D0		;51040: 302c357e
	ADDQ.W	#1,D0			;51044: 5240
	EXT.L	D0			;51046: 48c0
	ASL.L	#2,D0			;51048: e580
	MOVE.L	D0,-(A7)		;5104a: 2f00
	MOVE.L	(__argv,A4),-(A7)	;5104c: 2f2c357a
	JSR	(__FreeMem,PC)		;51050: 4eba02ca
	LEA	($10,A7),A7		;51054: 4fef0010
LAB_51058:
	BRA.S	LAB_51068		;51058: 600e
LAB_5105A:
	JSR	(__Forbid,PC)		;5105a: 4eba02b4
	MOVE.L	(_WBenchMsg,A4),-(A7)	;5105e: 2f2c3576
	JSR	(__ReplyMsg,PC)		;51062: 4eba0336
	ADDQ.W	#4,A7			;51066: 584f
LAB_51068:
	MOVE.L	(-4,A5),D0		;51068: 202dfffc
	MOVEA.L	(__savsp,A4),A7		;5106c: 2e6c3560
	RTS				;51070: 4e75
	MOVE.L	(A7)+,D4		;51072: 281f
	UNLK	A5			;51074: 4e5d
	RTS				;51076: 4e75
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_close:
	LINK.W	A5,#0			;51078: 4e550000
	MOVEM.L	D4-D6/A2,-(A7)		;5107c: 48e70e20
	MOVE.W	(8,A5),D4		;51080: 382d0008
	MOVE.W	D4,D0			;51084: 3004
	MULS	#$0006,D0		;51086: c1fc0006
	MOVEA.L	D0,A2			;5108a: 2440
	ADDA.L	(__devtab,A4),A2	;5108c: d5ec356c
	TST.W	D4			;51090: 4a44
	BLT.S	LAB_5109E		;51092: 6d0a
	CMP.W	(__numdev,A4),D4	;51094: b86c983a
	BGE.S	LAB_5109E		;51098: 6c04
	TST.L	(A2)			;5109a: 4a92
	BNE.S	LAB_510AE		;5109c: 6610
LAB_5109E:
	MOVE.W	#$0002,(_errno,A4)	;5109e: 397c000235aa
	MOVEQ	#-1,D0			;510a4: 70ff
LAB_510A6:
	MOVEM.L	(A7)+,D4-D6/A2		;510a6: 4cdf0470
	UNLK	A5			;510aa: 4e5d
	RTS				;510ac: 4e75
LAB_510AE:
	BTST	#7,(4,A2)		;510ae: 082a00070004
	BNE.S	LAB_510BE		;510b4: 6608
	MOVE.L	(A2),-(A7)		;510b6: 2f12
	JSR	(__Close,PC)		;510b8: 4eba000e
	ADDQ.W	#4,A7			;510bc: 584f
LAB_510BE:
	CLR.L	(A2)			;510be: 4292
	MOVEQ	#0,D0			;510c0: 7000
	BRA.S	LAB_510A6		;510c2: 60e2
_Close:
	JMP	(__Close,PC)		;510c4: 4efa0002
__Close:
	MOVE.L	(4,A7),D1		;510c8: 222f0004
	MOVEA.L	(_DOSBase,A4),A6	;510cc: 2c6c3568
	JMP	(-36,A6)		;510d0: 4eeeffdc
__CurrentDir:
	MOVE.L	(4,A7),D1		;510d4: 222f0004
	MOVEA.L	(_DOSBase,A4),A6	;510d8: 2c6c3568
	JMP	(-126,A6)		;510dc: 4eeeff82
_Delay:
	MOVE.L	(4,A7),D1		;510e0: 222f0004
	MOVEA.L	(_DOSBase,A4),A6	;510e4: 2c6c3568
	JMP	(-198,A6)		;510e8: 4eeeff3a
_Examine:
	JMP	(__Examine,PC)		;510ec: 4efa0002
__Examine:
	MOVEM.L	(4,A7),D1-D2		;510f0: 4cef00060004
	MOVEA.L	(_DOSBase,A4),A6	;510f6: 2c6c3568
	JMP	(-102,A6)		;510fa: 4eeeff9a
_ExNext:
	MOVEM.L	(4,A7),D1-D2		;510fe: 4cef00060004
	MOVEA.L	(_DOSBase,A4),A6	;51104: 2c6c3568
	JMP	(-108,A6)		;51108: 4eeeff94
__Input:
	MOVEA.L	(_DOSBase,A4),A6	;5110c: 2c6c3568
	JMP	(-54,A6)		;51110: 4eeeffca
_IoErr:
	JMP	(__IoErr,PC)		;51114: 4efa0002
__IoErr:
	MOVEA.L	(_DOSBase,A4),A6	;51118: 2c6c3568
	JMP	(-132,A6)		;5111c: 4eeeff7c
_Lock:
	JMP	(__Lock,PC)		;51120: 4efa0002
__Lock:
	MOVEM.L	(4,A7),D1-D2		;51124: 4cef00060004
	MOVEA.L	(_DOSBase,A4),A6	;5112a: 2c6c3568
	JMP	(-84,A6)		;5112e: 4eeeffac
_Open:
	JMP	(__Open,PC)		;51132: 4efa0002
__Open:
	MOVEM.L	(4,A7),D1-D2		;51136: 4cef00060004
	MOVEA.L	(_DOSBase,A4),A6	;5113c: 2c6c3568
	JMP	(-30,A6)		;51140: 4eeeffe2
__Output:
	MOVEA.L	(_DOSBase,A4),A6	;51144: 2c6c3568
	JMP	(-60,A6)		;51148: 4eeeffc4
_Read:
	JMP	(__Read,PC)		;5114c: 4efa0002
__Read:
	MOVEM.L	(4,A7),D1-D3		;51150: 4cef000e0004
	MOVEA.L	(_DOSBase,A4),A6	;51156: 2c6c3568
	JMP	(-42,A6)		;5115a: 4eeeffd6
_Seek:
	JMP	(__Seek,PC)		;5115e: 4efa0002
__Seek:
	MOVEM.L	(4,A7),D1-D3		;51162: 4cef000e0004
	MOVEA.L	(_DOSBase,A4),A6	;51168: 2c6c3568
	JMP	(-66,A6)		;5116c: 4eeeffbe
_UnLock:
	JMP	(__UnLock,PC)		;51170: 4efa0002
__UnLock:
	MOVE.L	(4,A7),D1		;51174: 222f0004
	MOVEA.L	(_DOSBase,A4),A6	;51178: 2c6c3568
	JMP	(-90,A6)		;5117c: 4eeeffa6
_Write:
	JMP	(__Write,PC)		;51180: 4efa0002
__Write:
	MOVEM.L	(4,A7),D1-D3		;51184: 4cef000e0004
	MOVEA.L	(_DOSBase,A4),A6	;5118a: 2c6c3568
	JMP	(-48,A6)		;5118e: 4eeeffd0
_AbortIO:
	MOVEA.L	(4,A7),A1		;51192: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;51196: 2c6c3564
	JMP	(-480,A6)		;5119a: 4eeefe20
_AddIntServer:
	MOVEM.L	(4,A7),D0/A1		;5119e: 4cef02010004
	MOVEA.L	(_SysBase,A4),A6	;511a4: 2c6c3564
	JMP	(-168,A6)		;511a8: 4eeeff58
_Alert:
	MOVEM.L	D7/A5,-(A7)		;511ac: 48e70104
	MOVEM.L	($C,A7),D7/A5		;511b0: 4cef2080000c
	MOVEA.L	(_SysBase,A4),A6	;511b6: 2c6c3564
	JSR	(-108,A6)		;511ba: 4eaeff94
	MOVEM.L	(A7)+,D7/A5		;511be: 4cdf2080
	RTS				;511c2: 4e75
_AvailMem:
; availmem is new
	MOVE.L	(4,A7),D1		;511c4: 222f0004
	MOVEA.L	(_SysBase,A4),A6	;511c8: 2c6c3564
	JMP	(-216,A6)		;511cc: 4eeeff28
_BeginIO:
	MOVEA.L	(4,A7),A1		;511d0: 226f0004
	MOVEA.L	($14,A1),A6		;511d4: 2c690014
	JMP	(-30,A6)		;511d8: 4eeeffe2
_CheckIO:
	MOVEA.L	(4,A7),A1		;511dc: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;511e0: 2c6c3564
	JMP	(-468,A6)		;511e4: 4eeefe2c
_CloseDevice:
	MOVEA.L	(4,A7),A1		;511e8: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;511ec: 2c6c3564
	JMP	(-450,A6)		;511f0: 4eeefe3e
_CloseLibrary:
	JMP	(__CloseLibrary,PC)	;511f4: 4efa0002
__CloseLibrary:
	MOVEA.L	(4,A7),A1		;511f8: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;511fc: 2c6c3564
	JMP	(-414,A6)		;51200: 4eeefe62
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_CreatePort:
	LINK.W	A5,#0			;51204: 4e550000
	MOVEM.L	D4/A2,-(A7)		;51208: 48e70820
	PEA	-1.W			;5120c: 4878ffff
	JSR	(_AllocSignal,PC)	;51210: 4eba00d0
	MOVE.L	D0,D4			;51214: 2800
	CMP.L	#$ffffffff,D0		;51216: b0bcffffffff
	ADDQ.W	#4,A7			;5121c: 584f
	BNE.S	LAB_5122A		;5121e: 660a
	MOVEQ	#0,D0			;51220: 7000
LAB_51222:
	MOVEM.L	(A7)+,D4/A2		;51222: 4cdf0410
	UNLK	A5			;51226: 4e5d
	RTS				;51228: 4e75
LAB_5122A:
	PEA	$00010001		;5122a: 487900010001
	PEA	$22.W			;51230: 48780022
	JSR	(___AllocMem,A4)	;51234: 4eac8200
	MOVEA.L	D0,A2			;51238: 2440
	TST.L	D0			;5123a: 4a80
	ADDQ.W	#8,A7			;5123c: 504f
	BNE.S	LAB_5124C		;5123e: 660c
	MOVE.L	D4,-(A7)		;51240: 2f04
	JSR	(_FreeSignal,PC)	;51242: 4eba00e8
	MOVEQ	#0,D0			;51246: 7000
	ADDQ.W	#4,A7			;51248: 584f
	BRA.S	LAB_51222		;5124a: 60d6
LAB_5124C:
	MOVE.L	(8,A5),($A,A2)		;5124c: 256d0008000a
	MOVE.B	($F,A5),(9,A2)		;51252: 156d000f0009
	MOVE.B	#$04,(8,A2)		;51258: 157c00040008
	CLR.B	($E,A2)			;5125e: 422a000e
	MOVE.B	D4,($F,A2)		;51262: 1544000f
	CLR.L	-(A7)			;51266: 42a7
	JSR	(___FindTask,A4)	;51268: 4eac8206
	MOVE.L	D0,($10,A2)		;5126c: 25400010
	TST.L	(8,A5)			;51270: 4aad0008
	ADDQ.W	#4,A7			;51274: 584f
	BEQ.S	LAB_51282		;51276: 670a
	MOVE.L	A2,-(A7)		;51278: 2f0a
	JSR	(_AddPort,PC)		;5127a: 4eba005a
	ADDQ.W	#4,A7			;5127e: 584f
	BRA.S	LAB_5128C		;51280: 600a
LAB_51282:
	PEA	($14,A2)		;51282: 486a0014
	JSR	(_NewList,PC)		;51286: 4eba00bc
	ADDQ.W	#4,A7			;5128a: 584f
LAB_5128C:
	MOVE.L	A2,D0			;5128c: 200a
	BRA.S	LAB_51222		;5128e: 6092
; ------------------------------------------------------------------------------
; Function
; ------------------------------------------------------------------------------
_DeletePort:
	LINK.W	A5,#0			;51290: 4e550000
	MOVE.L	A2,-(A7)		;51294: 2f0a
	MOVEA.L	(8,A5),A2		;51296: 246d0008
	TST.L	($A,A2)			;5129a: 4aaa000a
	BEQ.S	LAB_512A8		;5129e: 6708
	MOVE.L	A2,-(A7)		;512a0: 2f0a
	JSR	(_RemPort,PC)		;512a2: 4eba00ea
	ADDQ.W	#4,A7			;512a6: 584f
LAB_512A8:
	MOVE.B	#$ff,(8,A2)		;512a8: 157c00ff0008
	MOVE.L	#$ffffffff,($14,A2)	;512ae: 257cffffffff0014
	MOVEQ	#0,D0			;512b6: 7000
	MOVE.B	($F,A2),D0		;512b8: 102a000f
	MOVE.L	D0,-(A7)		;512bc: 2f00
	JSR	(_FreeSignal,PC)	;512be: 4eba006c
	PEA	$22.W			;512c2: 48780022
	MOVE.L	A2,-(A7)		;512c6: 2f0a
	JSR	(___FreeMem,A4)		;512c8: 4eac820c
	LEA	($C,A7),A7		;512cc: 4fef000c
	MOVEA.L	(A7)+,A2		;512d0: 245f
	UNLK	A5			;512d2: 4e5d
	RTS				;512d4: 4e75
_AddPort:
	MOVEA.L	(4,A7),A1		;512d6: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;512da: 2c6c3564
	JMP	(-354,A6)		;512de: 4eeefe9e
_AllocSignal:
	MOVE.L	(4,A7),D0		;512e2: 202f0004
	MOVEA.L	(_SysBase,A4),A6	;512e6: 2c6c3564
	JMP	(-330,A6)		;512ea: 4eeefeb6
_AllocMem:
	JMP	(__AllocMem,PC)		;512ee: 4efa0002
__AllocMem:
	MOVEM.L	(4,A7),D0-D1		;512f2: 4cef00030004
	MOVEA.L	(_SysBase,A4),A6	;512f8: 2c6c3564
	JMP	(-198,A6)		;512fc: 4eeeff3a
_FindTask:
	JMP	(__FindTask,PC)		;51300: 4efa0002
__FindTask:
	MOVEA.L	(4,A7),A1		;51304: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;51308: 2c6c3564
	JMP	(-294,A6)		;5130c: 4eeefeda
__Forbid:
	MOVEA.L	(_SysBase,A4),A6	;51310: 2c6c3564
	JMP	(-132,A6)		;51314: 4eeeff7c
_FreeMem:
	JMP	(__FreeMem,PC)		;51318: 4efa0002
__FreeMem:
	MOVEA.L	(4,A7),A1		;5131c: 226f0004
	MOVE.L	(8,A7),D0		;51320: 202f0008
	MOVEA.L	(_SysBase,A4),A6	;51324: 2c6c3564
	JMP	(-210,A6)		;51328: 4eeeff2e
_FreeSignal:
	MOVE.L	(4,A7),D0		;5132c: 202f0004
	MOVEA.L	(_SysBase,A4),A6	;51330: 2c6c3564
	JMP	(-336,A6)		;51334: 4eeefeb0
__GetMsg:
	MOVEA.L	(4,A7),A0		;51338: 206f0004
	MOVEA.L	(_SysBase,A4),A6	;5133c: 2c6c3564
	JMP	(-372,A6)		;51340: 4eeefe8c
_NewList:
	MOVEA.L	(4,A7),A0		;51344: 206f0004
	MOVE.L	A0,(A0)			;51348: 2088
	ADDQ.L	#4,(A0)			;5134a: 5890
	CLR.L	(4,A0)			;5134c: 42a80004
	MOVE.L	A0,(8,A0)		;51350: 21480008
	RTS				;51354: 4e75
_OpenDevice:
	MOVEA.L	(4,A7),A0		;51356: 206f0004
	MOVEM.L	(8,A7),D0/A1		;5135a: 4cef02010008
	MOVE.L	($10,A7),D1		;51360: 222f0010
	MOVEA.L	(_SysBase,A4),A6	;51364: 2c6c3564
	JMP	(-444,A6)		;51368: 4eeefe44
_OpenLibrary:
	JMP	(__OpenLibrary,PC)	;5136c: 4efa0002
__OpenLibrary:
	MOVEA.L	(_SysBase,A4),A6	;51370: 2c6c3564
	MOVEA.L	(4,A7),A1		;51374: 226f0004
	MOVE.L	(8,A7),D0		;51378: 202f0008
	JMP	(-552,A6)		;5137c: 4eeefdd8
_RemIntServer:
	MOVEM.L	(4,A7),D0/A1		;51380: 4cef02010004
	MOVEA.L	(_SysBase,A4),A6	;51386: 2c6c3564
	JMP	(-174,A6)		;5138a: 4eeeff52
_RemPort:
	MOVEA.L	(4,A7),A1		;5138e: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;51392: 2c6c3564
	JMP	(-360,A6)		;51396: 4eeefe98
__ReplyMsg:
	MOVEA.L	(4,A7),A1		;5139a: 226f0004
	MOVEA.L	(_SysBase,A4),A6	;5139e: 2c6c3564
	JMP	(-378,A6)		;513a2: 4eeefe86
_SetIntVector:
	MOVEM.L	(4,A7),D0/A1		;513a6: 4cef02010004
	MOVEA.L	(_SysBase,A4),A6	;513ac: 2c6c3564
	JMP	(-162,A6)		;513b0: 4eeeff5e
__WaitPort:
	MOVEA.L	(4,A7),A0		;513b4: 206f0004
	MOVEA.L	(_SysBase,A4),A6	;513b8: 2c6c3564
	JMP	(-384,A6)		;513bc: 4eeefe80
_FindToolType:
	MOVEM.L	(4,A7),A0-A1		;513c0: 4cef03000004
	MOVEA.L	(_IconBase,A4),A6	;513c6: 2c6c3586
	JMP	(-96,A6)		;513ca: 4eeeffa0
_FreeDiskObject:
	MOVEA.L	(4,A7),A0		;513ce: 206f0004
	MOVEA.L	(_IconBase,A4),A6	;513d2: 2c6c3586
	JMP	(-90,A6)		;513d6: 4eeeffa6
_GetDiskObject:
	MOVEA.L	(4,A7),A0		;513da: 206f0004
	MOVEA.L	(_IconBase,A4),A6	;513de: 2c6c3586
	JMP	(-78,A6)		;513e2: 4eeeffb2
_CloseWorkBench:
	MOVEA.L	(_IntuitionBase,A4),A6	;513e6: 2c6c99ac
	JMP	(-78,A6)		;513ea: 4eeeffb2
	DS.W	1			;513ee


	SECTION S_1,DATA

__H0_end:
	JMP	__H0_org		;513f0: 4ef90003e1e8
___main:
	JMP	_main			;513f6: 4ef90003e1ee
___create_mouse:
	JMP	_create_mouse		;513fc: 4ef90003e3ae
___set_pri:
	JMP	_set_pri		;51402: 4ef90003e526
___setup_display:
	JMP	_setup_display		;51408: 4ef90003e5ce
___make_map:
	JMP	_make_map		;5140e: 4ef90003f0b2
___draw_map:
	JMP	_draw_map		;51414: 4ef90003f1e0
___set_tend_icons:
	JMP	_set_tend_icons		;5141a: 4ef90003fd02
___set_mode_icons:
	JMP	_set_mode_icons		;51420: 4ef90003fdde
___get_heading:
	JMP	_get_heading		;51426: 4ef900041fea
___zero_population:
	JMP	_zero_population	;5142c: 4ef9000421f4
___do_magnet:
	JMP	_do_magnet		;51432: 4ef900042f34
___rotate_all_map:
	JMP	_rotate_all_map		;51438: 4ef900042fca
___clear_all_map:
	JMP	_clear_all_map		;5143e: 4ef9000430d8
___place_people:
	JMP	_place_people		;51444: 4ef900043164
___do_lower_point:
	JMP	_do_lower_point		;5144a: 4ef9000432d4
___do_raise_point:
	JMP	_do_raise_point		;51450: 4ef9000433ea
___do_flood:
	JMP	_do_flood		;51456: 4ef9000438b6
___do_quake:
	JMP	_do_quake		;5145c: 4ef900043be0
___do_volcano:
	JMP	_do_volcano		;51462: 4ef900043e18
___do_swamp:
	JMP	_do_swamp		;51468: 4ef900044102
___show_world:
	JMP	_show_world		;5146e: 4ef90004702c
___return_to_game:
	JMP	_return_to_game		;51474: 4ef9000485d0
___start_game:
	JMP	_start_game		;5147a: 4ef9000485ec
___end_game:
	JMP	_end_game		;51480: 4ef900048698
___paint_the_map:
	JMP	_paint_the_map		;51486: 4ef9000492ce
___draw_it:
	JMP	_draw_it		;5148c: 4ef9000499b4
___clr_wsc:
	JMP	_clr_wsc		;51492: 4ef90004a020
___copy_screen:
	JMP	_copy_screen		;51498: 4ef90004a046
___open_screen:
	JMP	_open_screen		;5149e: 4ef90004a068
___read_sprites:
	JMP	_read_sprites		;514a4: 4ef90004a176
___load_ground:
	JMP	_load_ground		;514aa: 4ef90004a23e
___Setscreen:
	JMP	_Setscreen		;514b0: 4ef90004a4f4
___swap_screens:
	JMP	_swap_screens		;514b6: 4ef90004a57e
___a_putpixel:
	JMP	_a_putpixel		;514bc: 4ef90004a5ac
___sprite_to_amiga:
	JMP	_sprite_to_amiga	;514c2: 4ef90004a5ee
___free_amiga_sprites:
	JMP	_free_amiga_sprites	;514c8: 4ef90004a802
___display_debug:
; _display_debug is new to this release
	JMP	_display_debug		;514ce: 4ef90004a870
___get_message:
	JMP	_get_message		;514d4: 4ef90004b23a
___clear_send:
	JMP	_clear_send		;514da: 4ef90004b858
___keyboard:
	JMP	_keyboard		;514e0: 4ef90004c1a2
___the_prot1:
; Should be JMP _the_prot1 but can't jump to odd value
	DC.W	$4ef9			;514e6
	DC.L	_the_prot1		;514e8: 0004c21b
___newrand:
	JMP	_newrand		;514ec: 4ef90004c2e6
___pixel:
	JMP	_pixel			;514f2: 4ef90004c302
___draw_icon:
	JMP	_draw_icon		;514f8: 4ef90004c376
___draw_bar:
	JMP	_draw_bar		;514fe: 4ef90004c3ca
___draw_sprite:
	JMP	_draw_sprite		;51504: 4ef90004c49a
___draw_s_32:
	JMP	_draw_s_32		;5150a: 4ef90004c58a
___toggle_icon:
	JMP	_toggle_icon		;51510: 4ef90004c70a
___mouse:
	JMP	_mouse			;51516: 4ef90004c792
___setup_mouse:
	JMP	_setup_mouse		;5151c: 4ef90004ca2c
___reset_screen:
	JMP	_reset_screen		;51522: 4ef90004cb6a
___text:
	JMP	_text			;51528: 4ef90004cdba
___set_serial:
	JMP	_set_serial		;5152e: 4ef90004ce56
___r_ser_buff:
	JMP	_r_ser_buff		;51534: 4ef90004cec4
___w_ser_buff:
	JMP	_w_ser_buff		;5153a: 4ef90004cefa
___PlaySound:
	JMP	_PlaySound		;51540: 4ef90004d5f8
___free_all_sounds:
	JMP	_free_all_sounds	;51546: 4ef90004d854
___open_channels:
	JMP	_open_channels		;5154c: 4ef90004d8d2
___close_channels:
	JMP	_close_channels		;51552: 4ef90004d9c6
___load_sound:
	JMP	_load_sound		;51558: 4ef90004da7a
___kill_effect:
	JMP	_kill_effect		;5155e: 4ef90004dc96
___check_effect:
; these 7 lines are new to the list
	JMP	_check_effect		;51564: 4ef90004dcca
___valid_move:
	JMP	_valid_move		;5156a: 4ef90004dce8
___check_life:
	JMP	_check_life		;51570: 4ef90004dd56
___long_asc:
	JMP	_long_asc		;51576: 4ef90004de56
___word_asc:
	JMP	_word_asc		;5157c: 4ef90004de64
___compress:
	JMP	_compress		;51582: 4ef90004decc
___the_prot5:
	JMP	_the_prot5		;51588: 4ef90004f3c8
___strcpy:
;  
	JMP	_strcpy			;5158e: 4ef9000504fe
___strlen:
	JMP	_strlen			;51594: 4ef90005050e
___atoi:
	JMP	_atoi			;5159a: 4ef900050520
___strcmp:
	JMP	_strcmp			;515a0: 4ef900050592
	JMP	_begin			;515a6: 4ef900050602
___strcat:
	JMP	_strcat			;515ac: 4ef90005097c
___mulu:
	JMP	_mulu			;515b2: 4ef9000509c8
___divs:
	JMP	_divs			;515b8: 4ef900050e96
___exit:
	JMP	_exit			;515be: 4ef900050f3e
___Close:
	JMP	_Close			;515c4: 4ef9000510c4
___Delay:
	JMP	_Delay			;515ca: 4ef9000510e0
___Open:
	JMP	_Open			;515d0: 4ef900051132
___Read:
	JMP	_Read			;515d6: 4ef90005114c
___Seek:
	JMP	_Seek			;515dc: 4ef90005115e
___AddIntServer:
	JMP	_AddIntServer		;515e2: 4ef90005119e
___CloseLibrary:
	JMP	_CloseLibrary		;515e8: 4ef9000511f4
___AllocMem:
	JMP	_AllocMem		;515ee: 4ef9000512ee
___FindTask:
	JMP	_FindTask		;515f4: 4ef900051300
___FreeMem:
	JMP	_FreeMem		;515fa: 4ef900051318
___OpenLibrary:
	JMP	_OpenLibrary		;51600: 4ef90005136c
___RemIntServer:
	JMP	_RemIntServer		;51606: 4ef900051380
___SetIntVector:
	JMP	_SetIntVector		;5160c: 4ef9000513a6
___CloseWorkBench:
	JMP	_CloseWorkBench		;51612: 4ef9000513e6
LAB_51618:
; these 20 bytes are new. used for IFF routine
	DC.W	$0140			;51618
LAB_5161A:
	DC.L	$00dc0000		;5161a
	DS.W	1			;5161e
LAB_51620:
	DC.L	$04020100,$00000a0b	;51620
LAB_51628:
	DC.W	$0140			;51628
LAB_5162A:
	DC.W	$00c8			;5162a
_PortName:
	DC.L	strSoundChannel		;5162c: 0004d5ea
_screen_origin:
	DC.L	$00000a16		;51630
_p_addr:
	DC.L	$00000108		;51634
_prot_num5:
	DC.L	$a1bae12d		;51638
_tempo:
	DC.W	$0032			;5163c
_music_off:
	DC.W	$0001			;5163e
_effect_off:
	DC.W	$0001			;51640
_serial_off:
	DS.B	1			;51642
LAB_51643:
	DC.B	$01			;51643
_mode:
	DS.B	1			;51644
bitfield_51645:
	DC.B	$02			;51645
_surender:
	DC.B	$ff			;51646
LAB_51647:
	DC.B	$ff			;51647
_not_player:
	DC.W	$0001			;51648
_last_tree:
	DC.W	$0032			;5164a
_last_rock:
	DC.W	$002f			;5164c
_b_rates:
	DC.L	$4b002580,$12c00e10,$096007d0,$070804b0 ;5164e
	DC.L	$0258012c,$00c80096,$0086006e,$004b0032 ;5165e
	DC.W	$012c			;5166e
_tend_x:
	DC.L	$00030004,$00050004	;51670
_tend_y:
	DC.L	$00030003,$00030004	;51678
_funny:
	DC.W	$ffc0			;51680
LAB_51682:
	DS.W	1			;51682
LAB_51684:
	DC.W	$0004			;51684
LAB_51686:
	DC.L	$0000ffff,$0001ffbf,$00050008,$0000ffc0 ;51686
	DC.L	$ffff0041,$0009000c,$00000040 ;51696
	DC.W	$0001			;516a2
_stats:
	DC.B	$61			;516a4
LAB_516A5:
	DC.B	$62			;516a5
LAB_516A6:
	DC.L	$63000000		;516a6
LAB_516AA:
	DS.B	1			;516aa
LAB_516AB:
	DS.B	1			;516ab
LAB_516AC:
	DC.L	$00010000		;516ac
LAB_516B0:
	DC.W	$0001			;516b0
LAB_516B2:
	DC.W	$ffff			;516b2
LAB_516B4:
	DC.W	$0001			;516b4
LAB_516B6:
	DS.W	1			;516b6
good_castles:
	DS.W	1			;516b8
good_towns:
	DS.W	1			;516ba
LAB_516BC:
	DS.W	1			;516bc
LAB_516BE:
	DS.W	1			;516be
LAB_516C0:
	DS.W	1			;516c0
LAB_516C2:
	DS.W	1			;516c2
LAB_516C4:
	DC.W	$0005			;516c4
LAB_516C6:
	DS.L	1			;516c6
LAB_516CA:
	DS.L	1			;516ca
LAB_516CE:
	DS.L	1			;516ce
strABC:
	;516d2
	;DC.B	$61,$62,$63,$00,$00,$00
	DC.B	"abc",0,0,0
LAB_516D8:
	DS.B	1			;516d8
LAB_516D9:
	DC.B	$01			;516d9
LAB_516DA:
	DC.L	$00010000		;516da
LAB_516DE:
	DC.W	$0005			;516de
LAB_516E0:
	DC.W	$ffff			;516e0
LAB_516E2:
	DC.L	$00030000		;516e2
bad_castles:
	DS.W	1			;516e6
bad_towns:
	DS.L	2			;516e8
	DC.L	$00000001		;516f0
	DS.L	3			;516f4
_tutorial:
	DC.L	$61626300		;51700
	DS.L	1			;51704
	DC.L	$00010000,$000a003f,$000a0000 ;51708
	DS.L	3			;51714
	DC.L	$00050000		;51720
	DS.L	2			;51724
	DS.W	1			;5172c
LAB_5172E:
	DC.L	$61626300,$00000001,$00010000,$000a0003 ;5172e
	DC.L	$000a0000		;5173e
	DS.L	3			;51742
	DC.L	$00010000		;5174e
	DS.L	2			;51752
	DS.W	1			;5175a
_tutorial_game_mode:
	DC.W	$0001			;5175c
_map_colour:
	DC.L	$0e0c0b0b,$0c0c0b0b,$0d0d0c0c,$0d0d0c0c ;5175e
	DC.L	$0e0c0b0b,$0c0c0b0b,$0d0d0c0c ;5176e
	DC.W	$0d0d			;5177a
	DC.B	$0c			;5177c
LAB_5177D:
	DC.B	$0c			;5177d
	DC.L	$19191919,$19191919,$19191919,$19191902 ;5177e
	DC.L	$02021919,$19191919,$19191919,$19191919 ;5178e
	DC.L	$19191919,$19191919	;5179e
_baud_rate:
	DC.W	$2580			;517a6
_opposite:
	DC.L	$00040005,$00060007,$00000001,$00020003 ;517a8
_palette:
	DC.L	$00000444,$06660888,$0aaa0ccc,$06200840 ;517b8
	DC.L	$0a000a60,$0aa004a0,$02800262,$0248026c ;517c8
	DC.L	$00000444,$06660888,$0aaa0ccc,$06200840 ;517d8
	DC.L	$0a000a60,$0aa004a0,$02800262,$0248026c ;517e8
_to_delta:
	DC.L	$00070006,$00050000,$00000004,$00010002 ;517f8
	DC.W	$0003			;51808
_to_offset:
	DC.L	$ffc0ffc1,$00010041,$0040003f,$ffffffbf ;5180a
_offset_vector:
	DC.L	$0000ffc0,$00010040,$ffffffc1,$0041003f ;5181a
	DC.L	$ffbfff80,$00020080,$fffeff82,$0082007e ;5182a
	DC.L	$ff7eff81,$ffc20042,$0081007f,$003effbe ;5183a
	DC.W	$ff7f			;5184a
_prot_num3:
	DC.L	$afa9ddd5		;5184c
_dir_sprite:
	DC.L	$ffbfffc0,$ffc10001,$00410040,$003fffff ;51850
	DS.W	1			;51860
_big_city:
	DC.L	$002a002c,$002b002c,$002b0029,$00290029 ;51862
	DC.W	$0029			;51872
_mana_values:
	DC.L	$ffffff06		;51874
LAB_51878:
	DC.L	$0000000a		;51878
LAB_5187C:
	DC.L	$000000c8		;5187c
LAB_51880:
	DC.L	$000009c4		;51880
LAB_51884:
	DC.L	$00001388		;51884
LAB_51888:
	DC.L	$00001d4c		;51888
LAB_5188C:
	DC.L	$00002710		;5188c
LAB_51890:
	DC.L	$00009c40		;51890
LAB_51894:
	DC.L	$00013880,$00027100,$001e847f ;51894
_prot_num2:
	DC.L	$e0ed80a7		;518a0
_pointer:
	DC.W	$0001			;518a4
_game_mode:
	DS.B	1			;518a6
LAB_518A7:
	DC.B	$10			;518a7
_in_conquest:
	DC.W	$ffff			;518a8
; ------------------------------------------------------------------------------
; Variables loaded from levels.dat for named maps in Conquest mode
; Valid numbers for each column:
; 0: 01 02 03 04 05 06 07 08 09 0a
; 1: 01 02 03 04 05 06 07 08 09 0a
; 2: 00 01 02 03 04 05 06 07 08 0a 0b 0c 0d 0f 10 12 14 20 22 24 34 38 3a 3e 3f
; 3: 00 01 02 04 08 09 0b 0f 12 19 1b 1e 1f 20 22 24 29 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f
; 4: 00 01 03 04 08 0a 10 11 12
; 5: 00 01 02 03
; 6: 01 02 03 04 05 06 07 0a 0c 14 1e
; 7: 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 14 1e
; 8: 00 01 02 03 04 0a 0b 0d 11 5f 63 6f 75 7c 7e
; 9: 01 02 06 08 0b 17 18 19 1a 1e 26 27 29 2d 35 36 3c 3d 42 44 4b 51 53 54 5a 5f 60 62 63 69 71 72 80 81 82 8e 8f 90 91 97 9e 9f a0 ad ae af b6 b8 bc bd cb cc cd d6 da dc df e8 ea eb f7 f9 fa
; ------------------------------------------------------------------------------
_conquest:
	DC.B	$01			;518aa
conq_01_speed:
	DC.B	$01			;518ab
conq_02_enemypow:
; appears to be bitfield of enemy powers available
	DS.B	1			;518ac
conq_03_yourpow:
	DC.B	$3f			;518ad
conq_04_mode:
	DC.B	$03			;518ae
conq_05_terrain:
; 00 Grass Planes, 01 Desert, 02 Snow and Ice, 03 Rocky
	DS.B	1			;518af
conq_06_yourpop:
	DC.B	$0f			;518b0
conq_07_enemypop:
	DC.B	$03			;518b1
conq_08_seed:
	DS.W	1			;518b2
_end_ok:
	DS.L	1			;518b4
	DS.W	1			;518b8
	;518ba
	;DC.B	$4f,$4b,$00,$00
	DC.B	"OK",0,0
	DS.L	9			;518be
_end_cancel:
	DS.L	1			;518e2
	DS.W	1			;518e6
	;518e8
	;DC.B	$43,$41,$4e,$43,$45,$4c,$00,$00
	DC.B	"CANCEL",0,0
	DS.L	8			;518f0
_option_text:
	DC.W	$0024			;51910
LAB_51912:
	DC.W	$0010			;51912
LAB_51914:
	DC.W	$0080			;51914
LAB_51916:
	;51916
	;DC.B	$4f,$50,$54,$49,$4f,$4e,$53,$20,$46,$4f,$52,$20
	DC.B	"OPTIONS FOR "
LAB_51922:
	DC.L	$4556494c		;51922
	DS.L	6			;51926
	DC.L	$00200020,$00088020	;5193e
	;51946
	;DC.B	$43,$41,$4e,$20,$4d,$4f,$44,$49,$46,$59,$20,$4c,$41,$4e,$44,$00
	DC.B	"CAN MODIFY LAND",0
	DS.L	5			;51956
	DC.L	$00000020,$00290008	;5196a
	DC.W	$8020			;51972
	;51974
	;DC.B	$43,$41,$4e,$20,$41,$54,$54,$41,$43,$4b,$20,$54,$4f,$57,$4e,$53
	;DC.B	$00,$00
	DC.B	"CAN ATTACK TOWNS",0,0
	DS.L	5			;51986
	DC.L	$00200032,$00088020	;5199a
	;519a2
	;DC.B	$43,$41,$4e,$20,$41,$54,$54,$41,$43,$4b,$20,$4c,$45,$41,$44,$45
	;DC.B	$52,$00
	DC.B	"CAN ATTACK LEADER",0
	DS.L	5			;519b4
	DC.L	$0020003b,$00088020	;519c8
	;519d0
	;DC.B	$43,$41,$4e,$20,$55,$53,$45,$20,$45,$41,$52,$54,$48,$51,$55,$41
	;DC.B	$4b,$45,$53,$00
	DC.B	"CAN USE EARTHQUAKES",0
	DS.L	4			;519e4
	DC.L	$00000020,$00430008	;519f4
	DC.W	$8020			;519fc
	;519fe
	;DC.B	$43,$41,$4e,$20,$55,$53,$45,$20,$53,$57,$41,$4d,$50,$00,$00,$00
	DC.B	"CAN USE SWAMP",0,0,0
	DS.L	5			;51a0e
	DC.L	$00000020,$004c0008	;51a22
	DC.W	$8020			;51a2a
	;51a2c
	;DC.B	$43,$41,$4e,$20,$55,$53,$45,$20,$4b,$4e,$49,$47,$48,$54,$00,$00
	DC.B	"CAN USE KNIGHT",0,0
	DS.L	5			;51a3c
	DC.L	$00000020,$00550008	;51a50
	DC.W	$8020			;51a58
	;51a5a
	;DC.B	$43,$41,$4e,$20,$55,$53,$45,$20,$56,$4f,$4c,$43,$41,$4e,$4f,$00
	DC.B	"CAN USE VOLCANO",0
	DS.L	5			;51a6a
	DC.L	$00000020,$005e0008	;51a7e
	DC.W	$8020			;51a86
	;51a88
	;DC.B	$43,$41,$4e,$20,$55,$53,$45,$20,$46,$4c,$4f,$4f,$44,$00
	DC.B	"CAN USE FLOOD",0
	DS.L	6			;51a96
	DC.L	$00200067,$00088020	;51aae
	;51ab6
	;DC.B	$43,$41,$4e,$20,$55,$53,$45,$20,$41,$52,$4d,$41,$47,$45,$44,$44
	;DC.B	$4f,$4e,$00,$00
	DC.B	"CAN USE ARMAGEDDON",0,0
	DS.L	4			;51aca
	DC.L	$00000064,$007a0020	;51ada
	;51ae2
	;DC.B	$41,$47,$47,$52,$45,$53,$53,$49,$4f,$4e,$00,$00
	DC.B	"AGGRESSION",0,0
	DS.L	7			;51aee
	DC.L	$00480083		;51b0a
	DC.W	$0068			;51b0e
	;51b10
	;DC.B	$4c,$4f,$57
	DC.B	"LOW"
	DC.B	$84			;51b13
	DC.L	$85858585,$85858585	;51b14
	DC.B	$86			;51b1c
	;51b1d
	;DC.B	$48,$49,$47,$48,$00
	DC.B	"HIGH",0
	DS.L	5			;51b22
	DC.L	$00000078,$008d0020	;51b36
	;51b3e
	;DC.B	$52,$41,$54,$45,$00
	DC.B	"RATE",0
	DS.B	1			;51b43
	DS.L	8			;51b44
	DC.L	$00000040,$00960070	;51b64
	;51b6c
	;DC.B	$53,$4c,$4f,$57
	DC.B	"SLOW"
	DC.L	$84858585,$85858585	;51b70
	DC.W	$8586			;51b78
	;51b7a
	;DC.B	$46,$41,$53,$54,$00,$00
	DC.B	"FAST",0,0
	DS.L	5			;51b80
_prot_num1:
	DC.L	$ad68a917		;51b94
_g_text:
	DC.L	strsendMessage		;51b98: 0004df3c
	DC.L	strMessageGood		;51b9c: 0004df4b
	DC.L	strMessageEvil		;51ba0: 0004df5d
LAB_51BA4:
	DC.L	strTwoPlayerSer		;51ba4: 0004df6f
LAB_51BA8:
	DC.L	strOnePlayerSave	;51ba8: 0004dfb5
LAB_51BAC:
	DC.L	strOtherChangeOpt	;51bac: 0004dfff
LAB_51BB0:
	DC.L	strOtherPaint		;51bb0: 0004e025
LAB_51BB4:
	DC.L	strOtherSides		;51bb4: 0004e04a
	DC.L	strOtherChangeHisOpts	;51bb8: 0004e069
	DC.L	strOtherChangeYourOpt	;51bbc: 0004e08e
LAB_51BC0:
	DC.L	strOtherAssistOn	;51bc0: 0004e0b4
LAB_51BC4:
	DC.L	strOtherAssistOff	;51bc4: 0004e0e2
LAB_51BC8:
	DC.L	strOtherPlanerGone	;51bc8: 0004e112
LAB_51BCC:
	DC.L	strSerialIOAbort	;51bcc: 0004e144
	DC.L	strSerialChecksumErr	;51bd0: 0004e156
LAB_51BD4:
	DC.L	strIncompatLandscap	;51bd4: 0004e16c
LAB_51BD8:
	DC.L	strInsertDisk		;51bd8: 0004e189
_game_text:
	DC.W	$0070			;51bdc
LAB_51BDE:
	DC.W	$0010			;51bde
LAB_51BE0:
	DC.W	$0048			;51be0
strGameSetup:
	;51be2
	;DC.B	$47,$41,$4d,$45,$20,$53,$45,$54,$55,$50,$00
	DC.B	"GAME SETUP",0
	DS.B	1			;51bed
	DS.L	7			;51bee
	DC.L	$00100024		;51c0a
	DC.W	$0008			;51c0e
strOnePlayer:
	DC.W	$8020			;51c10
	;51c12
	;DC.B	$4f,$4e,$45,$20,$50,$4c,$41,$59,$45,$52,$00,$00
	DC.B	"ONE PLAYER",0,0
	DS.L	6			;51c1e
	DC.L	$00000098,$00240008	;51c36
strTwoplayers:
	DC.W	$8020			;51c3e
	;51c40
	;DC.B	$54,$57,$4f,$20,$50,$4c,$41,$59,$45,$52,$53,$00
	DC.B	"TWO PLAYERS",0
	DS.L	6			;51c4c
	DC.L	$00000010,$002e0008	;51c64
strPlayGame:
	DC.W	$8020			;51c6c
	;51c6e
	;DC.B	$50,$4c,$41,$59,$20,$47,$41,$4d,$45,$00
	DC.B	"PLAY GAME",0
	DS.L	7			;51c78
	DC.L	$0098002e		;51c94
	DC.W	$0008			;51c98
strPaintMap:
	DC.W	$8020			;51c9a
	;51c9c
	;DC.B	$50,$41,$49,$4e,$54,$20,$4d,$41,$50,$00
	DC.B	"PAINT MAP",0
	DS.L	7			;51ca6
	DC.L	$00100038		;51cc2
	DC.W	$0008			;51cc6
strGood:
	DC.W	$8020			;51cc8
	;51cca
	;DC.B	$47,$4f,$4f,$44,$00,$00
	DC.B	"GOOD",0,0
	DS.L	8			;51cd0
	DC.L	$00980038		;51cf0
	DC.W	$0008			;51cf4
strEvil:
	DC.W	$8020			;51cf6
	;51cf8
	;DC.B	$45,$56,$49,$4c,$00
	DC.B	"EVIL",0
	DS.B	1			;51cfd
	DS.L	8			;51cfe
	DC.L	$00100042		;51d1e
	DC.W	$0008			;51d22
strHumanVsAmiga:
	DC.W	$8020			;51d24
	;51d26
	;DC.B	$48,$55,$4d,$41,$4e,$20,$56,$53,$20,$41,$4d,$49,$47,$41,$00,$00
	DC.B	"HUMAN VS AMIGA",0,0
	DS.L	5			;51d36
	DC.L	$00000098,$00420008	;51d4a
strAmigaVsAmiga:
	DC.W	$8020			;51d52
	;51d54
	;DC.B	$41,$4d,$49,$47,$41,$20,$56,$53,$20,$41,$4d,$49,$47,$41,$00,$00
	DC.B	"AMIGA VS AMIGA",0,0
	DS.L	5			;51d64
	DC.L	$00000010,$004c0008	;51d78
strConquest2:
	DC.W	$8020			;51d80
	;51d82
	;DC.B	$43,$4f,$4e,$51,$55,$45,$53,$54,$00,$00
	DC.B	"CONQUEST",0,0
	DS.L	7			;51d8c
	DC.L	$0098004c		;51da8
	DC.W	$0008			;51dac
strCustomGame:
	DC.W	$8020			;51dae
	;51db0
	;DC.B	$43,$55,$53,$54,$4f,$4d,$20,$47,$41,$4d,$45,$00
	DC.B	"CUSTOM GAME",0
	DS.L	6			;51dbc
	DC.L	$00000050,$005f0080	;51dd4
	DC.W	$8020			;51ddc
	;51dde
	;DC.B	$47,$41,$4d,$45,$20,$4f,$50,$54,$49,$4f,$4e,$53,$00,$00
	DC.B	"GAME OPTIONS",0,0
	DS.L	6			;51dec
	DC.L	$00500069,$00808020	;51e04
	;51e0c
	;DC.B	$53,$41,$56,$45,$20,$41,$20,$47,$41,$4d,$45,$00
	DC.B	"SAVE A GAME",0
	DS.L	6			;51e18
	DC.L	$00000050,$00730080	;51e30
	DC.W	$8020			;51e38
	;51e3a
	;DC.B	$4c,$4f,$41,$44,$20,$41,$20,$47,$41,$4d,$45,$00
	DC.B	"LOAD A GAME",0
	DS.L	6			;51e46
	DC.L	$00000050,$007d0080	;51e5e
	DC.W	$8020			;51e66
	;51e68
	;DC.B	$4d,$4f,$56,$45,$20,$54,$4f,$20,$4e,$45,$58,$54,$20,$4d,$41,$50
	;DC.B	$00,$00
	DC.B	"MOVE TO NEXT MAP",0,0
	DS.L	5			;51e7a
	DC.L	$00500087,$00808020	;51e8e
	;51e96
	;DC.B	$52,$45,$53,$54,$41,$52,$54,$20,$54,$48,$49,$53,$20,$4d,$41,$50
	;DC.B	$00
	DC.B	"RESTART THIS MAP",0
	DS.B	1			;51ea7
	DS.L	5			;51ea8
	DC.L	$00500091,$00808020	;51ebc
	;51ec4
	;DC.B	$53,$55,$52,$52,$45,$4e,$44,$45,$52,$20,$54,$48,$49,$53,$20,$47
	;DC.B	$41,$4d,$45,$00
	DC.B	"SURRENDER THIS GAME",0
	DS.L	4			;51ed8
	DS.W	1			;51ee8
_c_text:
	DC.W	$0010			;51eea
LAB_51EEC:
	DC.W	$000a			;51eec
LAB_51EEE:
	DC.W	$0010			;51eee
; ------------------------------------------------------------------------------
; These strings appear to be 46-byte structures
; 40 bytes with six bytes other data, total 46 ($2e)
; ------------------------------------------------------------------------------
strWorldToConquer:
	;51ef0
	;DC.B	$57,$4f,$52,$4c,$44,$20,$54,$4f,$20,$43,$4f,$4e,$51,$55,$45,$52
	;DC.B	$00
	DC.B	"WORLD TO CONQUER",0
	DS.B	1			;51f01
	DS.L	5			;51f02
	DS.W	1			;51f16
text_x:
	DC.W	$0010			;51f18
text_y:
	DC.L	$001e0011		;51f1a
	;51f1e
	;DC.B	$42,$41,$54,$54,$4c,$45,$20,$4e,$55,$4d,$42,$45,$52,$20,$49,$53
	;DC.B	$20,$00
	DC.B	"BATTLE NUMBER IS ",0
	DS.L	5			;51f30
	DC.L	$00000010,$00260014	;51f44
	;51f4c
	;DC.B	$57,$4f,$52,$4c,$44,$53,$20,$4c,$41,$4e,$44,$53,$43,$41,$50,$45
	;DC.B	$20,$49,$53,$20,$00,$00
	DC.B	"WORLDS LANDSCAPE IS ",0,0
	DS.L	4			;51f62
	DC.L	$00000010,$002e0012	;51f72
	;51f7a
	;DC.B	$48,$49,$53,$20,$52,$45,$41,$43,$54,$49,$4f,$4e,$53,$20,$41,$52
	;DC.B	$45,$20,$00
	DC.B	"HIS REACTIONS ARE ",0
	DS.B	1			;51f8d
	DS.L	5			;51f8e
	DC.L	$00100036		;51fa2
	DC.W	$000e			;51fa6
	;51fa8
	;DC.B	$48,$49,$53,$20,$52,$41,$54,$49,$4e,$47,$20,$49,$53,$20,$00,$00
	DC.B	"HIS RATING IS ",0,0
	DS.L	6			;51fb8
	DC.L	$0010003e		;51fd0
	DC.W	$0005			;51fd4
	;51fd6
	;DC.B	$4c,$41,$4e,$44,$20,$00
	DC.B	"LAND ",0
	DS.L	8			;51fdc
	DC.L	$00000010,$0046000f	;51ffc
	;52004
	;DC.B	$54,$48,$45,$20,$53,$57,$41,$4d,$50,$53,$20,$41,$52,$45,$20,$00
	DC.B	"THE SWAMPS ARE ",0
	DS.L	6			;52014
	DC.L	$0010004e		;5202c
	DC.W	$0009			;52030
	;52032
	;DC.B	$57,$41,$54,$45,$52,$20,$49,$53,$20,$00
	DC.B	"WATER IS ",0
	DS.L	7			;5203c
	DC.L	$00000010,$00580048	;52058
	;52060
	;DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$59
	;DC.B	$4f,$55,$20,$20,$20,$20,$48,$49,$4d,$00
	DC.B	"               YOU    HIM",0
	DS.L	3			;5207a
	DC.L	$00000010,$00600078	;52086
	;5208e
	;DC.B	$50,$4f,$50,$55,$4c,$41,$54,$49,$4f,$4e,$00,$00
	DC.B	"POPULATION",0,0
	DS.L	7			;5209a
	DC.L	$00100068		;520b6
	DC.W	$0078			;520ba
	;520bc
	;DC.B	$45,$41,$52,$54,$48,$51,$55,$41,$4b,$45,$53,$00
	DC.B	"EARTHQUAKES",0
	DS.L	7			;520c8
	DC.L	$00100070		;520e4
	DC.W	$0078			;520e8
	;520ea
	;DC.B	$53,$57,$41,$4d,$50,$53,$00,$00
	DC.B	"SWAMPS",0,0
	DS.L	8			;520f2
	DC.L	$00100078		;52112
	DC.W	$0078			;52116
	;52118
	;DC.B	$4b,$4e,$49,$47,$48,$54,$53,$00
	DC.B	"KNIGHTS",0
	DS.L	8			;52120
	DC.L	$00100080		;52140
	DC.W	$0078			;52144
	;52146
	;DC.B	$56,$4f,$4c,$43,$41,$4e,$4f,$53,$00
	DC.B	"VOLCANOS",0
	DS.B	1			;5214f
	DS.L	7			;52150
	DC.L	$00000010,$00880078	;5216c
	;52174
	;DC.B	$46,$4c,$4f,$4f,$44,$53,$00
	DC.B	"FLOODS",0
	DS.B	1			;5217b
	DS.L	8			;5217c
_con_text:
	DC.L	strGrassPlanes		;5219c: 0004e1b4
	DC.L	strDesert		;521a0: 0004e1c1
	DC.L	strSnowAndIce		;521a4: 0004e1c8
	DC.L	strRocky		;521a8: 0004e1d5
	DC.L	strVerySlow		;521ac: 0004e1db
	DC.L	strSlow			;521b0: 0004e1e5
	DC.L	strMedium		;521b4: 0004e1ea
	DC.L	strFast			;521b8: 0004e1f1
	DC.L	strVeryFast		;521bc: 0004e1f6
	DC.L	strVeryPoor		;521c0: 0004e200
	DC.L	strPoor			;521c4: 0004e20a
	DC.L	strAverage		;521c8: 0004e20f
	DC.L	strGood3		;521cc: 0004e217
	DC.L	strVeryGood		;521d0: 0004e21c
LAB_521D4:
	DC.L	strCannotBeBuilt	;521d4: 0004e226
LAB_521D8:
	DC.L	strBuiltOnTowns		;521d8: 0004e236
LAB_521DC:
	DC.L	strOnlyBuiltUp		;521dc: 0004e24a
LAB_521E0:
	DC.L	strBuiltOnPeople	;521e0: 0004e258
LAB_521E4:
	DC.L	strShallow		;521e4: 0004e268
LAB_521E8:
	DC.L	strBottomless		;521e8: 0004e270
LAB_521EC:
	DC.L	strHarmful		;521ec: 0004e27b
LAB_521F0:
	DC.L	strFatal		;521f0: 0004e283
LAB_521F4:
	DC.L	strYes			;521f4: 0004e289
LAB_521F8:
	DC.L	strNo			;521f8: 0004e28d
	DC.L	strMortal		;521fc: 0004e290
	DC.L	strImmortal		;52200: 0004e297
	DC.L	strEternal		;52204: 0004e2a0
	DC.L	strDeva			;52208: 0004e2a8
	DC.L	strGreaterBeing		;5220c: 0004e2ad
	DC.L	strDeity		;52210: 0004e2bb
	DC.L	strGreaterDeity		;52214: 0004e2c1
	DC.L	strMortalGod		;52218: 0004e2cf
	DC.L	strGreaterGod		;5221c: 0004e2da
	DC.L	strEternalGod		;52220: 0004e2e6
LAB_52224:
	DC.L	strWellDone		;52224: 0004e2f2
LAB_52228:
	DC.L	strYouConquered		;52228: 0004e2fd
LAB_5222C:
	DC.L	strNowBattleAt		;5222c: 0004e30d
LAB_52230:
	DC.L	strWellDoneConq		;52230: 0004e31d
LAB_52234:
	DC.L	strBattleOverTry	;52234: 0004e33f
_go_protect:
	DS.W	1			;52238
_end_words:
	DC.L	$00000001,$00030005	;5223a
	DC.W	$0006			;52242
_words:
	DC.L	$0009ffff,$0005ffff,$0003ffff,$0007ffff ;52244
	DC.L	$00010008,$0002ffff,$00010002,$00090006 ;52254
	DC.L	$00010006,$00030006	;52264
_end_text:
	DC.W	$0070			;5226c
LAB_5226E:
	DC.L	$000a0048		;5226e
strGAME_:
	;52272
	;DC.B	$47,$41,$4d,$45,$20
	DC.B	"GAME "
strLOST:
	DC.B	$4c			;52277
	DC.L	$4f535400		;52278
	DS.L	2			;5227c
	DS.B	1			;52284
strScoreboard:
	DS.B	1			;52285
	DS.L	5			;52286
	DC.L	$00100014		;5229a
	DC.W	$0018			;5229e
	;522a0
	;DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	;DC.B	$20,$20,$20,$59,$4f,$55,$20,$20,$48,$49,$4d,$00
	DC.B	"                   YOU  HIM",0
	DS.L	3			;522bc
	DC.L	$00100023		;522c8
	DC.W	$0018			;522cc
	;522ce
	;DC.B	$42,$41,$54,$54,$4c,$45,$53,$20,$57,$4f,$4e,$20,$20,$20,$20,$20
	;DC.B	$20,$20,$20,$30,$30,$30,$30,$20,$30,$30,$30,$30,$00,$00
	DC.B	"BATTLES WON        0000 0000",0,0
	DS.L	2			;522ec
	DC.L	$00000010,$002d0018	;522f4
	;522fc
	;DC.B	$4e,$55,$4d,$42,$45,$52,$20,$4f,$46,$20,$4b,$4e,$49,$47,$48,$54
	;DC.B	$53,$20,$20,$30,$30,$30,$30,$20,$30,$30,$30,$30,$00,$00
	DC.B	"NUMBER OF KNIGHTS  0000 0000",0,0
	DS.L	2			;5231a
	DC.L	$00000010,$00370018	;52322
	;5232a
	;DC.B	$4e,$55,$4d,$42,$45,$52,$20,$4f,$46,$20,$54,$4f,$57,$4e,$53,$20
	;DC.B	$20,$20,$20,$30,$30,$30,$30,$20,$30,$30,$30,$30,$00,$00
	DC.B	"NUMBER OF TOWNS    0000 0000",0,0
	DS.L	2			;52348
	DC.L	$00000010,$00410018	;52350
	;52358
	;DC.B	$4e,$55,$4d,$42,$45,$52,$20,$4f,$46,$20,$43,$41,$53,$54,$4c,$45
	;DC.B	$53,$20,$20,$30,$30,$30,$30,$20,$30,$30,$30,$30,$00,$00
	DC.B	"NUMBER OF CASTLES  0000 0000",0,0
	DS.L	2			;52376
	DC.L	$00000010,$00500018	;5237e
	;52386
	;DC.B	$59,$4f,$55,$52,$20,$53,$43,$4f,$52,$45,$20,$20,$20,$20,$20,$20
	;DC.B	$20,$20,$20,$30,$30,$30,$30,$30,$30,$30,$30,$30,$00,$00
	DC.B	"YOUR SCORE         000000000",0,0
	DS.L	2			;523a4
	DS.W	1			;523ac
_set_text:
	DC.W	$0030			;523ae
LAB_523B0:
	DC.W	$0019			;523b0
LAB_523B2:
	DC.W	$0076			;523b2
strGameOptions:
	;523b4
	;DC.B	$53,$45,$54,$20,$47,$41,$4d,$45,$20,$4f,$50,$54,$49,$4f,$4e,$53
	;DC.B	$00,$00
	DC.B	"SET GAME OPTIONS",0,0
	DS.L	5			;523c6
	DC.L	$00000010,$00280008	;523da
	DC.W	$8020			;523e2
	;523e4
	;DC.B	$57,$41,$54,$45,$52,$20,$49,$53,$20,$48,$41,$52,$4d,$46,$55,$4c
	;DC.B	$00,$00
	DC.B	"WATER IS HARMFUL",0,0
	DS.L	5			;523f6
	DC.L	$00100028,$00088120	;5240a
	;52412
	;DC.B	$57,$41,$54,$45,$52,$20,$49,$53,$20,$46,$41,$54,$41,$4c,$00,$00
	DC.B	"WATER IS FATAL",0,0
	DS.L	5			;52422
	DC.L	$00000010,$00320008	;52436
	DC.W	$8020			;5243e
	;52440
	;DC.B	$53,$57,$41,$4d,$50,$53,$20,$53,$48,$41,$4c,$4c,$4f,$57,$00,$00
	DC.B	"SWAMPS SHALLOW",0,0
	DS.L	5			;52450
	DC.L	$00000010,$00320008	;52464
	DC.W	$8120			;5246c
	;5246e
	;DC.B	$53,$57,$41,$4d,$50,$53,$20,$42,$4f,$54,$54,$4f,$4d,$4c,$45,$53
	;DC.B	$53,$00
	DC.B	"SWAMPS BOTTOMLESS",0
	DS.L	5			;52480
	DC.L	$0010003c,$00088020	;52494
	;5249c
	;DC.B	$43,$41,$4e,$20,$42,$55,$49,$4c,$44,$00
	DC.B	"CAN BUILD",0
	DS.L	7			;524a6
	DC.L	$0010003c,$00088120	;524c2
	;524ca
	;DC.B	$43,$41,$4e,$4e,$4f,$54,$20,$42,$55,$49,$4c,$44,$00,$00
	DC.B	"CANNOT BUILD",0,0
	DS.L	6			;524d8
	DC.L	$00100046,$00088020	;524f0
	;524f8
	;DC.B	$42,$55,$49,$4c,$44,$20,$55,$50,$20,$41,$4e,$44,$20,$44,$4f,$57
	;DC.B	$4e,$00
	DC.B	"BUILD UP AND DOWN",0
	DS.L	5			;5250a
	DC.L	$00100046,$00088120	;5251e
	;52526
	;DC.B	$4f,$4e,$4c,$59,$20,$42,$55,$49,$4c,$44,$20,$55,$50,$00
	DC.B	"ONLY BUILD UP",0
	DS.L	6			;52534
	DC.L	$00100050,$00088020	;5254c
	;52554
	;DC.B	$42,$55,$49,$4c,$44,$20,$4e,$45,$41,$52,$20,$50,$45,$4f,$50,$4c
	;DC.B	$45,$00
	DC.B	"BUILD NEAR PEOPLE",0
	DS.L	5			;52566
	DC.L	$00100050,$00088120	;5257a
	;52582
	;DC.B	$42,$55,$49,$4c,$44,$20,$4e,$45,$41,$52,$20,$54,$4f,$57,$4e,$53
	;DC.B	$00,$00
	DC.B	"BUILD NEAR TOWNS",0,0
	DS.L	5			;52594
_blank:
	;525a8
	;DC.B	$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e
	DC.B	"^^^^^^^^^^^"
LAB_525B3:
	;525b3
	;DC.B	$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e
	;DC.B	$5e,$00
	DC.B	"^^^^^^^^^^^^^^^^^",0
_blank_box:
	DC.B	$82			;525c5
	DC.W	$8282			;525c6
LAB_525C8:
	DC.L	$82828282,$82828282,$82828282,$82828282 ;525c8
	DS.W	1			;525d8
_serial_text:
	DC.W	$0010			;525da
LAB_525DC:
	DC.W	$0010			;525dc
LAB_525DE:
	DS.W	1			;525de
LAB_525E0:
	;525e0
	;DC.B	$53,$54,$41,$52,$54,$55,$50,$20,$53,$45,$52,$49,$41,$4c,$00
	DC.B	"STARTUP SERIAL",0
	DS.B	1			;525ef
	DS.L	6			;525f0
LAB_52608:
	DC.W	$0010			;52608
LAB_5260A:
	DC.L	$001f00d0		;5260a
	;5260e
	;DC.B	$53,$45,$4e,$44,$20,$4c,$4f,$47,$49,$4e,$00
	DC.B	"SEND LOGIN",0
	DS.B	1			;52619
	DS.L	7			;5261a
	DC.W	$0010			;52636
LAB_52638:
	DC.L	$002900d0		;52638
	;5263c
	;DC.B	$42,$41,$55,$44,$20,$52,$41,$54,$45,$00
	DC.B	"BAUD RATE",0
	DS.L	7			;52646
	DC.L	$00000010,$00330050	;52662
	DC.W	$8020			;5266a
	;5266c
	;DC.B	$44,$41,$54,$41,$4c,$49,$4e,$4b,$00
	DC.B	"DATALINK",0
	DS.B	1			;52675
	DS.L	7			;52676
	DC.L	$0010003d,$00608020	;52692
	;5269a
	;DC.B	$46,$55,$4c,$4c,$20,$53,$45,$52,$49,$41,$4c,$20,$43,$48,$45,$43
	;DC.B	$4b,$49,$4e,$47,$00,$00
	DC.B	"FULL SERIAL CHECKING",0,0
	DS.L	4			;526b0
	DC.L	$00100047,$00588020	;526c0
	;526c8
	;DC.B	$49,$20,$41,$4d,$20,$47,$4f,$4f,$44,$00
	DC.B	"I AM GOOD",0
	DS.L	7			;526d2
	DC.L	$00100051,$00a88120,$55534520 ;526ee
	;526fa
	;DC.B	$54,$48,$49,$53,$20,$4c,$41,$4e,$44,$53,$43,$41,$50,$45,$00
	DC.B	"THIS LANDSCAPE",0
	DS.B	1			;52709
	DS.L	4			;5270a
	DC.L	$00000010,$005b0060	;5271a
	DC.W	$8020			;52722
	;52724
	;DC.B	$43,$4f,$4e,$4e,$45,$43,$54,$20,$4d,$45,$00
	DC.B	"CONNECT ME",0
	DS.B	1			;5272f
	DS.L	6			;52730
	DC.L	$00000010,$00330038	;52748
	DC.W	$8120			;52750
	;52752
	;DC.B	$4d,$4f,$44,$45,$4d,$00
	DC.B	"MODEM",0
	DS.L	8			;52758
	DC.L	$0010003d,$00588120	;52778
	;52780
	;DC.B	$4e,$4f,$20,$53,$45,$52,$49,$41,$4c,$20,$43,$48,$45,$43,$4b,$49
	;DC.B	$4e,$47,$00,$00
	DC.B	"NO SERIAL CHECKING",0,0
	DS.L	4			;52794
	DC.L	$00000010,$00470058	;527a4
	DC.W	$8120			;527ac
	;527ae
	;DC.B	$49,$20,$41,$4d,$20,$45,$56,$49,$4c,$00
	DC.B	"I AM EVIL",0
	DS.L	7			;527b8
	DC.L	$00100051,$00b08120	;527d4
	;527dc
	;DC.B	$55,$53,$45,$20,$53,$41,$56,$45,$44,$20,$4c,$41,$4e,$44,$53,$43
	;DC.B	$41,$50,$45,$00
	DC.B	"USE SAVED LANDSCAPE",0
	DS.L	4			;527f0
	DC.L	$00000010,$0065000b	;52800
	;52808
	;DC.B	$48,$45,$27,$53,$20,$54,$52,$59,$49,$4e,$47,$20,$54,$4f,$20,$42
	;DC.B	$45,$20,$47,$4f,$4f,$44,$00,$00
	DC.B	"HE'S TRYING TO BE GOOD",0,0
	DS.L	4			;52820
	DC.L	$00100065		;52830
	DC.W	$000b			;52834
	;52836
	;DC.B	$48,$45,$27,$53,$20,$54,$52,$59,$49,$4e,$47,$20,$54,$4f,$20,$42
	;DC.B	$45,$20,$45,$56,$49,$4c,$00
	DC.B	"HE'S TRYING TO BE EVIL",0
	DS.B	1			;5284d
	DS.L	4			;5284e
	DC.L	$00100065		;5285e
	DC.W	$000b			;52862
	;52864
	;DC.B	$48,$45,$27,$53,$20,$4e,$4f,$54,$20,$55,$53,$49,$4e,$47,$20,$41
	;DC.B	$20,$53,$41,$56,$45,$44,$20,$47,$41,$4d,$45,$00
	DC.B	"HE'S NOT USING A SAVED GAME",0
	DS.L	3			;52880
	DC.L	$00100065		;5288c
	DC.W	$000b			;52890
	;52892
	;DC.B	$48,$45,$27,$53,$20,$55,$53,$49,$4e,$47,$20,$41,$20,$53,$41,$56
	;DC.B	$45,$44,$20,$47,$41,$4d,$45,$00
	DC.B	"HE'S USING A SAVED GAME",0
	DS.L	4			;528aa
LAB_528BA:
	DC.W	$0010			;528ba
LAB_528BC:
	DC.L	$0065000b		;528bc
LAB_528C0:
	;528c0
	;DC.B	$53,$45,$52,$49,$41,$4c,$20,$45,$52,$52,$4f,$52,$21,$00
	DC.B	"SERIAL ERROR!",0
	DS.L	6			;528ce
	DC.L	$00000010,$0065000b	;528e6
	;528ee
	;DC.B	$48,$45,$20,$49,$53,$20,$55,$53,$49,$4e,$47,$20,$4e,$4f,$20,$43
	;DC.B	$48,$45,$43,$4b,$49,$4e,$47,$00
	DC.B	"HE IS USING NO CHECKING",0
	DS.L	4			;52906
	DC.L	$00100065		;52916
	DC.W	$000b			;5291a
	;5291c
	;DC.B	$48,$45,$20,$49,$53,$20,$55,$53,$49,$4e,$47,$20,$46,$55,$4c,$4c
	;DC.B	$20,$43,$48,$45,$43,$4b,$49,$4e,$47,$00
	DC.B	"HE IS USING FULL CHECKING",0
	DS.L	3			;52936
	DS.W	1			;52942
LAB_52944:
	DC.W	$0010			;52944
LAB_52946:
	DC.L	$0065000b		;52946
LAB_5294A:
	;5294a
	;DC.B	$49,$4e,$43,$4f,$4d,$50,$41,$54,$41,$42,$4c,$45,$20,$53,$41,$56
	;DC.B	$45,$44,$20,$47,$41,$4d,$45,$53,$00,$00
	DC.B	"INCOMPATABLE SAVED GAMES",0,0
	DS.L	3			;52964
	DS.W	1			;52970
_start:
	DC.L	strRING			;52972: 0004e35c
	DC.L	strVERY			;52976: 0004e361
	DC.L	strKILL			;5297a: 0004e366
	DC.L	strSHAD			;5297e: 0004e36b
	DC.L	strHURT			;52982: 0004e370
	DC.L	strWEAV			;52986: 0004e375
	DC.L	strMIN			;5298a: 0004e37a
	DC.L	strEOA			;5298e: 0004e37e
	DC.L	strCOR			;52992: 0004e382
	DC.L	strJOS			;52996: 0004e386
	DC.L	strALP			;5299a: 0004e38a
	DC.L	strHAM2			;5299e: 0004e38e
	DC.L	strBUR			;529a2: 0004e392
	DC.L	strBIN			;529a6: 0004e396
	DC.L	strTIM			;529aa: 0004e39a
	DC.L	strBAD			;529ae: 0004e39e
	DC.L	strFUT			;529b2: 0004e3a2
	DC.L	strMOR			;529b6: 0004e3a6
	DC.L	strSAD			;529ba: 0004e3aa
	DC.L	strCAL			;529be: 0004e3ae
	DC.L	strIMM			;529c2: 0004e3b2
	DC.L	strSUZ			;529c6: 0004e3b6
	DC.L	strNIM			;529ca: 0004e3ba
	DC.L	strLOW			;529ce: 0004e3be
	DC.L	strSCO			;529d2: 0004e3c2
	DC.L	strHOB			;529d6: 0004e3c6
	DC.L	strDOU			;529da: 0004e3ca
	DC.L	strBIL			;529de: 0004e3ce
	DC.L	strQAZ2			;529e2: 0004e3d2
	DC.L	strSWA			;529e6: 0004e3d6
	DC.L	strBUG			;529ea: 0004e3da
	DC.L	strSHI			;529ee: 0004e3de
_end:
	DC.L	strHILL			;529f2: 0004e3e2
	DC.L	strTORY			;529f6: 0004e3e7
	DC.L	strHOLE			;529fa: 0004e3ec
	DC.L	strPERT			;529fe: 0004e3f1
	DC.L	strMAR			;52a02: 0004e3f6
	DC.L	strCON			;52a06: 0004e3fa
	DC.L	strLOW2			;52a0a: 0004e3fe
	DC.L	strDOR			;52a0e: 0004e402
	DC.L	strLIN			;52a12: 0004e406
	DC.L	strING			;52a16: 0004e40a
	DC.L	strHAM			;52a1a: 0004e40e
	DC.L	strOLD			;52a1e: 0004e412
	DC.L	strPIL			;52a22: 0004e416
	DC.L	strBAR			;52a26: 0004e41a
	DC.L	strMET			;52a2a: 0004e41e
	DC.L	strEND			;52a2e: 0004e422
	DC.L	strLAS			;52a32: 0004e426
	DC.L	strOUT			;52a36: 0004e42a
	DC.L	strLUG			;52a3a: 0004e42e
	DC.L	strILL			;52a3e: 0004e432
	DC.L	strICK			;52a42: 0004e436
	DC.L	strPAL			;52a46: 0004e43a
	DC.L	strDON			;52a4a: 0004e43e
	DC.L	strORD			;52a4e: 0004e442
	DC.L	strOND			;52a52: 0004e446
	DC.L	strBOY			;52a56: 0004e44a
	DC.L	strJOB			;52a5a: 0004e44e
	DC.L	strER			;52a5e: 0004e452
	DC.L	strED			;52a62: 0004e455
	DC.L	strME			;52a66: 0004e458
	DC.L	strAL			;52a6a: 0004e45b
	DC.L	strT			;52a6e: 0004e45e
_mid:
	DC.L	strOUT2			;52a72: 0004e460
	DC.L	strQAZ			;52a76: 0004e464
	DC.L	strING2			;52a7a: 0004e468
	DC.L	strOGO			;52a7e: 0004e46c
	DC.L	strQUE			;52a82: 0004e470
	DC.L	strLOP			;52a86: 0004e474
	DC.L	strSOD			;52a8a: 0004e478
	DC.L	strHIP			;52a8e: 0004e47c
	DC.L	strKOP			;52a92: 0004e480
	DC.L	strWIL			;52a96: 0004e484
	DC.L	strIKE			;52a9a: 0004e488
	DC.L	strDIE			;52a9e: 0004e48c
	DC.L	strIN			;52aa2: 0004e490
	DC.L	strAS			;52aa6: 0004e493
	DC.L	strMP			;52aaa: 0004e496
	DC.L	strDI			;52aae: 0004e499
	DC.L	strOZ			;52ab2: 0004e49c
	DC.L	strEA			;52ab6: 0004e49f
	DC.L	strUS			;52aba: 0004e4a2
	DC.L	strGB			;52abe: 0004e4a5
	DC.L	strCE			;52ac2: 0004e4a8
	DC.L	strME2			;52ac6: 0004e4ab
	DC.L	strDE			;52aca: 0004e4ae
	DC.L	strPE			;52ace: 0004e4b1
	DC.L	strOX			;52ad2: 0004e4b4
	DC.L	strA			;52ad6: 0004e4b7
	DC.L	strE			;52ada: 0004e4b9
	DC.L	strI			;52ade: 0004e4bb
	DC.L	strO			;52ae2: 0004e4bd
	DC.L	strU			;52ae6: 0004e4bf
	DC.L	strT2			;52aea: 0004e4c1
	DC.L	strY			;52aee: 0004e4c3
_a_flat:
	DC.L	$fcfcfcfd,$fcfefcff,$fc00fc01,$fc02fc03 ;52af2
	DC.L	$fc04fdfc,$fdfdfdfe,$fdfffd00,$fd01fd02 ;52b02
	DC.L	$fd03fd04,$04fc04fd,$04fe04ff,$04000401 ;52b12
	DC.L	$04020403,$040403fc,$03fd03fe,$03ff0300 ;52b22
	DC.L	$03010302,$03030304,$fefcfefd,$fefefeff ;52b32
	DC.L	$fe00fe01,$fe02fe03,$fe0402fc,$02fd02fe ;52b42
	DC.L	$02ff0200,$02010202,$02030204,$fffcfffd ;52b52
	DC.L	$fffeffff,$ff00ff01,$ff02ff03,$ff0401fc ;52b62
	DC.L	$01fd01fe,$01ff0100,$01010102,$01030104 ;52b72
	DC.L	$00fc00fd,$00fe00ff,$00000001,$00020003 ;52b82
	DC.W	$0004			;52b92
LAB_52B94:
; new
	;52b94
	;DC.B	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$61,$62,$63,$64,$65,$66
	;DC.B	$00,$00
	DC.B	"0123456789abcdef",0,0
_ctp_:
	DC.L	$00202020,$20202020,$20203030,$30303020 ;52ba6
	DC.L	$20202020,$20202020,$20202020,$20202020 ;52bb6
	DC.L	$20904040,$40404040,$40404040,$40404040 ;52bc6
	DC.L	$400c0c0c,$0c0c0c0c,$0c0c0c40,$40404040 ;52bd6
	DC.L	$40400909,$09090909,$01010101,$01010101 ;52be6
	DC.L	$01010101,$01010101,$01010101,$40404040 ;52bf6
	DC.L	$40400a0a,$0a0a0a0a,$02020202,$02020202 ;52c06
	DC.L	$02020202,$02020202,$02020202,$40404040 ;52c16
	DC.W	$2000			;52c26
__numdev:
	DC.W	$0014			;52c28
__detach_name:
	DS.L	1			;52c2a
__detach_curdir:
; seems to be new
	DS.L	1			;52c2e
	DS.W	1			;52c32
__H1_end:
	DS.L	1			;52c34
_dint:
	DS.L	2			;52c38
LAB_52C40:
	DS.B	1			;52c40
LAB_52C41:
	DS.B	1			;52c41
LAB_52C42:
	DS.L	1			;52c42
LAB_52C46:
	DS.L	1			;52c46
LAB_52C4A:
	DS.L	1			;52c4a
_my_task:
	DS.L	1			;52c4e
_the_prot2:
	DS.L	1			;52c52
_sprite_data:
	DS.L	1			;52c56
_sprite_data_32:
	DS.L	1			;52c5a
_blk_data:
	DS.L	1			;52c5e
_back_scr:
	DS.L	1			;52c62
_screen_pointer:
	DS.L	1			;52c66
LAB_52C6A:
	DS.L	1			;52c6a
LAB_52C6E:
	DS.L	1			;52c6e
_copper_list:
	DS.L	2			;52c72
LAB_52C7A:
	DS.L	1			;52c7a
_spare_cl:
	DS.L	1			;52c7e
_fb:
	DS.L	1			;52c82
_start_of_game:
	DS.W	1			;52c86
_sprites_in:
	DS.W	1			;52c88
_serial:
	DS.W	1			;52c8a
LAB_52C8C:
	DS.L	1			;52c8c
LAB_52C90:
	DS.L	$40			;52c90
	DS.W	1			;52d90
_GfxBase:
	DS.L	1			;52d92
_mouse_limit:
	DS.W	1			;52d96
_mousex:
	DS.W	1			;52d98
_IntuitionBase:
	DS.L	1			;52d9a
_big_mousex:
	DS.W	1			;52d9e
_big_mousey:
	DS.W	1			;52da0
_serial_inter_1:
	DS.L	2			;52da2
LAB_52DAA:
	DS.B	1			;52daa
LAB_52DAB:
	DS.B	1			;52dab
LAB_52DAC:
	DS.L	1			;52dac
LAB_52DB0:
	DS.L	1			;52db0
LAB_52DB4:
	DS.L	1			;52db4
_serial_inter_2:
	DS.L	2			;52db8
LAB_52DC0:
	DS.B	1			;52dc0
LAB_52DC1:
	DS.B	1			;52dc1
LAB_52DC2:
	DS.L	1			;52dc2
LAB_52DC6:
	DS.L	1			;52dc6
LAB_52DCA:
	DS.L	1			;52dca
_pal:
	DS.W	1			;52dce
_seed:
	DS.B	1			;52dd0
LAB_52DD1:
	DS.B	1			;52dd1
_start_seed:
	DS.W	1			;52dd2
_ground_in:
	DS.W	1			;52dd4
_w_screen:
	DS.L	1			;52dd6
_d_screen:
	DS.L	1			;52dda
_xoff:
	DS.B	1			;52dde
LAB_52DDF:
	DS.B	1			;52ddf
_yoff:
	DS.B	1			;52de0
LAB_52DE1:
	DS.B	1			;52de1
_player:
	DS.B	1			;52de2
LAB_52DE3:
	DS.B	1			;52de3
_magnet:
	DS.W	1			;52de4
LAB_52DE6:
	DS.W	1			;52de6
LAB_52DE8:
	DS.W	1			;52de8
LAB_52DEA:
	DS.W	1			;52dea
good_pop:
	DS.L	1			;52dec
LAB_52DF0:
	DS.L	1			;52df0
	DS.W	1			;52df4
LAB_52DF6:
	DS.L	1			;52df6
	DS.W	1			;52dfa
bad_pop:
	DS.L	1			;52dfc
LAB_52E00:
	DS.L	1			;52e00
_beat_two:
	DS.W	1			;52e04
_tempo_now:
	DS.W	1			;52e06
_toggle:
	DS.W	1			;52e08
_no_sprites:
	DS.W	1			;52e0a
_ok_to_build:
	DS.B	1			;52e0c
LAB_52E0D:
	DS.B	1			;52e0d
_sound_effect:
	DS.W	1			;52e0e
_sprite:
	DS.L	$80			;52e10
_pause:
	DS.W	1			;53010
_paint_map:
	DS.B	1			;53012
LAB_53013:
	DS.B	1			;53013
_peeps:
	DS.B	1			;53014
LAB_53015:
	DS.B	1			;53015
LAB_53016:
	DS.B	1			;53016
LAB_53017:
	DS.B	1			;53017
LAB_53018:
	DS.W	1			;53018
LAB_5301A:
	DS.W	1			;5301a
LAB_5301C:
	DS.W	1			;5301c
LAB_5301E:
	DS.W	1			;5301e
LAB_53020:
	DS.W	1			;53020
LAB_53022:
	DS.L	1			;53022
	DS.W	1			;53026
LAB_53028:
	DS.L	$478			;53028
	DS.W	1			;54208
LAB_5420A:
	DS.L	$10			;5420a
	DS.W	1			;5424a
_no_peeps:
	DS.W	1			;5424c
_view_timer:
	DS.W	1			;5424e
_left_button:
	DS.W	1			;54250
_right_button:
	DS.W	1			;54252
_old_view_who:
	DS.W	1			;54254
_view_who:
	DS.W	1			;54256
_game_turn:
	DS.W	1			;54258
_inkey:
	DS.W	1			;5425a
_mousey:
	DS.W	1			;5425c
_funny_done:
	DS.W	1			;5425e
_score:
	DS.L	1			;54260
_devil_magnet:
	DS.W	1			;54264
_god_magnet:
	DS.W	1			;54266
_battle_won:
	DS.W	1			;54268
_battle_1:
	DS.W	1			;5426a
_level_number:
	DS.W	1			;5426c
_war:
	DS.W	1			;5426e
_the_prot3:
	DS.L	1			;54270
_alt:
	DS.L	$840			;54274
	DS.W	1			;56374
_map_blk:
	DS.L	$400			;56376
_map_alt:
	DS.L	$400			;57376
_map_bk2:
	DS.L	$400			;58376
_map_steps:
	DS.L	$1E			;59376
; ------------------------------------------------------------------------------
; A4 is a pointer to this
; ------------------------------------------------------------------------------
_A4:
	DS.L	$7E2			;593ee
_map_who:
	DS.L	$400			;5b376
_build_count:
	DS.W	1			;5c376
_xmin:
	DS.W	1			;5c378
_xmax:
	DS.W	1			;5c37a
_ymin:
	DS.W	1			;5c37c
_ymax:
	DS.W	1			;5c37e
_view_fight:
	DS.W	1			;5c380
_view_people:
	DS.W	1			;5c382
_weapons_order:
	DS.L	5			;5c384
	DS.W	1			;5c398
_effect:
	DS.W	1			;5c39a
_last_fire:
	DS.W	1			;5c39c
_walk_death:
	DS.W	1			;5c39e
_a_flat_block:
	DS.W	1			;5c3a0
_cheat:
	DS.W	1			;5c3a2
_mana_add:
	DS.L	5			;5c3a4
	DS.W	1			;5c3b8
_weapons_add:
	DS.L	5			;5c3ba
	DS.W	1			;5c3ce
_population_add:
	DS.L	5			;5c3d0
	DS.W	1			;5c3e4
_all_of_city:
	DS.W	1			;5c3e6
_battle_add1:
	DS.L	5			;5c3e8
	DS.W	1			;5c3fc
_battle_add2:
	DS.W	1			;5c3fe
LAB_5C400:
	DS.W	1			;5c400
LAB_5C402:
	DS.L	4			;5c402
	DS.W	1			;5c412
_cur_y:
	DS.B	1			;5c414
LAB_5C415:
	DS.B	1			;5c415
_cur_x:
	DS.B	1			;5c416
LAB_5C417:
	DS.B	1			;5c417
_asckey:
	DS.W	1			;5c418
_drawer:
	DS.L	5			;5c41a
_filename:
	DS.L	5			;5c42e
_saved:
	DS.B	1			;5c442
LAB_5C443:
	DS.B	1			;5c443
_quick_io:
	DS.W	1			;5c444
_message:
	DS.W	1			;5c446
LAB_5C448:
	DS.B	1			;5c448
LAB_5C449:
	DS.B	1			;5c449
LAB_5C44A:
	DS.B	1			;5c44a
LAB_5C44B:
	DS.B	1			;5c44b
LAB_5C44C:
	DS.B	1			;5c44c
LAB_5C44D:
	DS.B	1			;5c44d
LAB_5C44E:
	DS.B	1			;5c44e
LAB_5C44F:
	DS.B	1			;5c44f
LAB_5C450:
	DS.B	1			;5c450
LAB_5C451:
	DS.B	1			;5c451
	DS.L	7			;5c452
_bring_up_two:
	DS.B	1			;5c46e
LAB_5C46F:
	DS.B	1			;5c46f
_land_checksum:
	DS.W	1			;5c470
_use_modem:
	DS.W	1			;5c472
_login:
	DS.L	5			;5c474
_new_map:
	DS.B	1			;5c488
LAB_5C489:
	DS.B	1			;5c489
_the_prot4:
	DS.L	1			;5c48a
_tcmap:
	DS.L	$10			;5c48e
_sprite_list:
	DS.L	1			;5c4ce
LAB_5C4D2:
	DS.L	7			;5c4d2
_shift:
	DS.B	1			;5c4ee
LAB_5C4EF:
	DS.B	1			;5c4ef
_dummy_bitmap:
	DS.L	$A			;5c4f0
_work_screen:
	DS.L	1			;5c518
_a_sprite:
	DS.L	1			;5c51c
LAB_5C520:
	DS.L	1			;5c520
LAB_5C524:
	DS.L	1			;5c524
LAB_5C528:
	DS.L	1			;5c528
LAB_5C52C:
	DS.L	1			;5c52c
LAB_5C530:
	DS.L	1			;5c530
LAB_5C534:
	DS.L	1			;5c534
LAB_5C538:
	DS.L	1			;5c538
_mmousex:
	DS.W	1			;5c53c
_mmousey:
	DS.W	1			;5c53e
_music_now:
	DS.W	1			;5c540
_music:
	DS.W	1			;5c542
_sound_in:
	DS.W	1			;5c544
_p_done:
	DS.W	1			;5c546
_all_sample_length:
	DS.L	1			;5c548
_all_sample:
	DS.L	1			;5c54c
_ioas:
	DS.L	4			;5c550
_allocationMap:
	DS.W	1			;5c560
_measures:
	DS.L	1			;5c562
_sequn:
	DS.W	1			;5c566
LAB_5C568:
	DS.L	$7F			;5c568
	DS.W	1			;5c764
_seqlen:
	DS.W	1			;5c766
_measln:
	DS.L	$20			;5c768
_sams:
	DS.W	1			;5c7e8
LAB_5C7EA:
	DS.W	1			;5c7ea
LAB_5C7EC:
	DS.L	$4F			;5c7ec
_drumkit:
	DS.L	1			;5c928
_measure_length:
	DS.L	1			;5c92c
_no_sounds:
	DS.W	1			;5c930
_curseq:
	DS.W	1			;5c932
_curbeat:
	DS.W	1			;5c934
_curtime:
	DS.W	1			;5c936
_curmeas:
	DS.L	1			;5c938
_Soundpri:
	DS.W	1			;5c93c
LAB_5C93E:
	DS.W	1			;5c93e
LAB_5C940:
	DS.W	1			;5c940
LAB_5C942:
	DS.W	1			;5c942
_dinter:
	DS.L	1			;5c944
_done_prot:
	DS.W	1			;5c948
_dump_screen_number:
	DS.W	1			;5c94a
_quake_count:
	DS.W	1			;5c94c
__savsp:
	DS.L	1			;5c94e
_SysBase:
	DS.L	1			;5c952
_DOSBase:
	DS.L	1			;5c956
__devtab:
	DS.L	1			;5c95a
__stkbase:
	DS.L	1			;5c95e
_Enable_Abort:
	DS.W	1			;5c962
_WBenchMsg:
	DS.L	1			;5c964
__argv:
	DS.L	1			;5c968
__argc:
	DS.W	1			;5c96c
__arg_len:
	DS.W	1			;5c96e
__arg_lin:
	DS.L	1			;5c970
_IconBase:
	DS.L	1			;5c974
_cls_:
	DS.L	1			;5c978
__cln:
	DS.L	1			;5c97c
__trapaddr:
	DS.L	1			;5c980
__oldtrap:
	DS.L	1			;5c984
_MathTransBase:
	DS.L	1			;5c988
_MathBase:
	DS.L	1			;5c98c
_MathIeeeDoubBasBase:
	DS.L	1			;5c990
_MathIeeeDoubTransBase:
	DS.L	1			;5c994
_errno:
	DS.L	1			;5c998


	SECTION S_2,BSS

__H2_end:
	DS.L	1			;5c99c
	END