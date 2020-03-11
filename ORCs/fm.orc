instr start_notes

    kcnt	init	0
    
	if(kcnt>11)	then

		kcnt	=	0
	
	endif	

	krate	rspline	0,	5,	2,	100	;spline for time
	krate	scale	krate/4,	10,	0.3	;scaling spline
	ktrig	metro	(krate*.2)				;metronome modulated by spline

;	koct	random	-2,	2	;generates random octave - 0 is middle
	;koct	int	koct		;makes random number an integer
	koct	random	1,	4

	kpan	rspline	0,	1,	0.1,	2
					;pgs 264, 265

	kfreq	table	kcnt,	5

	kfreq	=	cpspch(koct+kfreq)

	

	;---------------MULTIPLICATION---------------


	;kfreqmult	=	gkmultiply-kfreq
	;kfreq		=	kfreqmult
	;kfreq		=	gkmultiply
	;kfreq		round	kfreq

	;--------------------END---------------------
	

	if(kcnt>=0)	then

		;printk2	kmidi,	10
		kcnt	=	kcnt+1
		schedkwhen	ktrig,	0,	0,	"fm",	0,	4,	kfreq,	kpan

	endif

endin



instr fm

	idur	=	p3
	ifreq	=	p4
	;ifreq	=	440
	ipan	=	p5

	kenv	madsr	0.01,	1,	0.01,	idur
	asig1	vco2	kenv,	ifreq*2,	12
	asig2	vco2	kenv,	ifreq*1.34,	12

	asig	=	asig1	*	asig2


	afilt	lpf18	asig,	4000*kenv,	.2,	.8

	afilt2	atone	afilt,	100

	gafmL,	gafmR   pan2	afilt2,	ipan
	
	gafmL *= 0.25
	gafmR *= 0.25

			;outs	apanL*0.25,	apanR*0.25


	gaverbL	=	gafmL
	gaverbR	=	gafmR

endin

