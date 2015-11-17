/* Copyright (c) 2002  Michael Stumpf  <mistumpf@de.pepperl-fuchs.com>
   Copyright (c) 2006  Dmitry Xmelkov
   Copyright (c) 2008  Ruud v Gessel
   
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.
   * Neither the name of the copyright holders nor the names of
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE. */

/* $Id: sqrt.S,v 1.8 2007/01/14 15:13:10 dmix Exp $ */

#include "fp32def.h"
#include "asmdef.h"

/*  double sqrt (double);
    Square root function.
 */

FUNCTION sqrt

.L_nf:	brne	.L_pk		; NaN, return as is
	brtc	.L_pk		; sqrt(+Inf) --> +Inf
.L_nan:	rjmp	_U(__fp_nan)
.L_pk:	rjmp	_U(__fp_mpack)

ENTRY sqrt
  ; split and check arg.
	rcall	_U(__fp_splitA)
	brcs	.L_nf		; !isfinite(A)
	tst	rA3
	breq	.L_pk		; return 0 with original sign
	brts	.L_nan		; sqrt(negative) --> NaN
  ; exponent bias
	subi	rA3, 127
	sbc	rB3, rB3	; exponent high byte
  ; normalize, if A is subnormal
	sbrs	rA2, 7
	rcall	_U(__fp_norm2)
	
#define	msk0	ZL
#define msk1	ZH
#define msk2	rBE

	clr	R0		; R0=0
	ldi	msk2,0x60
	X_movw	msk0,R0		; Initial rotation mask   = 011000000000000000000000 
	ldi	rB2,0xa0
	X_movw	rB0,R0		; Initial developing root = 101000000000000000000000
	subi	rA2,0x40
	sbrc	rA3,0
	rjmp	3f
	subi	rA2,0x40
	
.Loop:	brcs	1f		; C --> Bit is always 1
	cp	msk2,R0
	cpc	rA0,rB0
	cpc	rA1,rB1
	cpc	rA2,rB2		; Does test value fit?
	brcs	2f		; C --> nope, bit is 0

1:	cp	msk2,R0
	sbc	rA0,rB0
	sbc	rA1,rB1
	sbc	rA2,rB2		; Adjust argument for next bit
	or	rB0,msk0
	or	rB1,msk1
	or	rB2,msk2	; Set bit to 1

2:	lsr	msk2
	ror	msk1
	ror	msk0		; Shift right mask, C --> end loop
	eor	rB0,msk0
	eor	rB1,msk1
	eor	rB2,msk2	; Shift right only test bit in result

	rol	R0		; Bit 0 now set if end of loop
3:	lsl	rA0
	rol	rA1
	rol	rA2		; Shift left remaining argument (C used at .Loop)
	
	sbrs	R0,1		; Skip if 24 bits developed
	rjmp	.Loop		; Develop 24 bits of the sqrt

	brcs	4f		; C--> Last bits always 1
	cp	rB0,rA0
	cpc	rB1,rA1
	cpc	rB2,rA2		; Test for last bit 1
4:	adc	rB0,R1
	adc	rB1,R1
	adc	rB2,R1

	X_movw	rA0, rB0
	mov	rA2, rB2

  ; calculate result exponent
	
	lsr	rB3
	ror	rA3
	

	subi	rA3, lo8(-127)		; exponent bias
	lsl	rA2
	lsr	rA3
	ror	rA2
	ret
ENDFUNC
