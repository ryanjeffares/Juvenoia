instr start_notes

	if(gkcnt>11)	then

		gkcnt	=	0
	
	endif	

	krate	rspline	0,	5,	2,	100	;spline for time
	krate	scale	krate/4,	10,	0.3	;scaling spline
	ktrig	metro	(krate*.2)				;metronome modulated by spline

;	koct	random	-2,	2	;generates random octave - 0 is middle
	;koct	int	koct		;makes random number an integer
	koct	random	1,	4

	kpan	rspline	0,	1,	0.1,	2
					;pgs 264, 265

	kfreq	table	gkcnt,	5

	kfreq	=	cpspch(koct+kfreq)

	

	;---------------MULTIPLICATION---------------


	;kfreqmult	=	gkmultiply-kfreq
	;kfreq		=	kfreqmult
	;kfreq		=	gkmultiply
	;kfreq		round	kfreq

	;--------------------END---------------------
	

	if(gkcnt>=0)	then

		;printk2	kmidi,	10
		gkcnt	=	gkcnt+1
		schedkwhen	ktrig,	0,	0,	"fm",	0,	.5,	kfreq,	kpan

	endif

endin



instr fm

	idur	=	p3
	ifreq	=	p4
	;ifreq	=	440
	ipan	=	p5

	kenv	madsr	0.01,	idur*2,	.5,	4
	asig1	vco2	kenv,	ifreq*2,	12
	asig2	vco2	kenv,	ifreq*1.34,	12

	asig	=	asig1	*	asig2


	afilt	lpf18	asig,	4000*kenv,	.2,	.8

	afilt	atone	afilt,	100

	apanL,	apanR	pan2	afilt,	ipan

			outs	apanL*.1,	apanR*.1


	gaverbL	=	apanL
	gaverbR	=	apanR
endin

