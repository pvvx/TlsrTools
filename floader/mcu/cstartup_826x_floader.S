
	.code	16
@********************************************************************************************************
@                                           MACROS AND DEFINIITIONS
@********************************************************************************************************
@.include "version.in"

					@ Mode, correspords to bits 0-5 in CPSR
	.equ MODE_BITS,		0x1F	@ Bit mask for mode bits in CPSR
	.equ IRQ_MODE, 		0x12	@ Interrupt Request mode
	.equ SVC_MODE, 		0x13	@ Supervisor mode 

	.equ IRQ_STK_SIZE,	0x100
	.equ __LOAD_RAM, 	0xf
	
@********************************************************************************************************
@                                            TC32 EXCEPTION VECTORS
@********************************************************************************************************

	.section	.vectors,"ax"
	.global		__reset
@	.global	 	__irq
	.global 	__start
	.global		__LOAD_RAM

__start:					@ MUST,  referenced by boot.link

	.extern ext

	.org 0x0
	tj	__reset
	.short (0x1234)
	
	.org 0x4
	.word	(ext)
	.word	(0x544c4e4b)
	.word	(0x00880100)

	.org 0x10
	tj __reset
	.org 0x18
@********************************************************************************************************
@                                   LOW-LEVEL INITIALIZATION
@********************************************************************************************************
	.extern  main

	.org 0x20
__reset:
@	tloadr     	r0, DAT0 + 36
@	tmov		r1, #1024		@ set sws to GPIO
@	tstorer 	r1, [r0, #0]

@	tloadr     	r0, DAT0 + 40		@**** enable watchdog at the very first time
@	tloadr     	r1, DAT0 + 44
@	tstorer		r1, [r0, #0]

@ ************  initial the stack **********************
	tloadr	r0, DAT0
	tmcsr	r0			
	tloadr	r0, DAT0 + 8
	tmov	r13, r0  

	tloadr	r0, DAT0 + 4
	tmcsr	r0	
	tloadr	r0, DAT0 + 12
	tmov	r13, r0  


	tloadr	r0, FLL_D
	tloadr	r1, FLL_D+4
	tloadr	r2, FLL_D+8

FLL_STK:
	tcmp	r1, r2
	tjge	FLL_STK_END
	tstorer r0, [r1, #0]
	tadd    r1, #4
	tj		FLL_STK
FLL_STK_END:

	tloadr	r0, DAT0
	tmcsr	r0			
	tloadr	r0, DAT0 + 8
	tmov	r13, r0  

	tloadr	r0, DAT0 + 4
	tmcsr	r0	
	tloadr	r0, DAT0 + 12
	tmov	r13, r0  

	tmov	r0, #0
	tloadr	r1, DAT0 + 16
	tloadr	r2, DAT0 + 20

ZERO:
	tcmp	r1, r2
	tjge	ZERO_END
	tstorer	r0, [r1, #0]
	tadd    r1, #4
	tj		ZERO
ZERO_END:

	tloadr	r1, DAT0 + 28
	tloadr	r2, DAT0 + 32

ZERO_TAG:
	tcmp	r1, r2
	tjge	ZERO_TAG_END
	tstorer	r0, [r1, #0]
	tadd    r1, #4
	tj		ZERO_TAG
ZERO_TAG_END:
	
SETIC:
	tloadr     	r1, DAT0 + 24
	tmov		r0, #__LOAD_RAM;				@ IC tag start
	tstorerb	r0, [r1, #0]
	tmov		r0, #(__LOAD_RAM + 1);			@ IC tag end
	tstorerb	r0, [r1, #1]
	@tmov		r0, #0;
	@tstorerb	r0, [r1, #2]


	tloadr		r1, DATA_I
	tloadr		r2, DATA_I+4
	tloadr		r3, DATA_I+8
	
COPY_DATA:
	tcmp		r2, r3
	tjge		COPY_DATA_END
	tloadr		r0, [r1, #0]
	tstorer 	r0, [r2, #0]
	tadd    	r1, #4
	tadd		r2, #4
	tj			COPY_DATA
COPY_DATA_END:

	tjl	main
END:	tj	END


	
.balign	4
DAT0:
	.word	0x12			    @IRQ    @0
	.word	0x13			    @SVC    @4
	.word	(irq_stk + IRQ_STK_SIZE)
	.word	(0x80c000)		    @12  stack end
	.word	(_start_bss_)               @16
	.word	(_end_bss_)                 @20
	.word	(0x80060c)                  @24
	.word	(0x808000 + __LOAD_RAM * 0x100)                  @28		@ IC tag start
	.word	(0x808000 + (__LOAD_RAM + 1) * 0x100)                  @32		@ IC tag end
	.word   (0x800643)		           @ 36
	
@	.word	(0x80058c)                  @36		gpio
@	.word	(0x800620)                  @40		watchdog
@	.word	(0x802c01)                  @44		watchdog

DAT1:
	.word   (0x800643)		           @ 0

DATA_I:	
	.word	_dstored_
	.word	_start_data_
	.word	_end_data_

	
	
FLL_D:
	.word	0xffffffff
	.word	(_start_data_)
	.word	(0x80c000)

ASMEND:
	
.section .bss
	.align 4
	.lcomm irq_stk, IRQ_STK_SIZE
	.end
