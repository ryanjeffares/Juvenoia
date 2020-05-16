instr start_notes

 	kcnt	init	0
    
	if(kcnt>11)	then

		kcnt	=	0
	
	endif	

	krate	rspline	0.1,	9,	.5,	12	;spline for time
	
	ktrig	metro	(krate*.3)				;metronome modulated by spline

	koct	random	-3,	1	;generates random octave - 0 is middle
	koct	int	koct		;makes random number an integer
	
	kpan	rspline	0,	1,	0.1,	2
					;pgs 264, 265

	kfreq	table	kcnt,	5

	kfreq	=	pchmidinn(kfreq)

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
		schedkwhennamed	ktrig,	0,	0,	"mando",	4,	2,	kfreq,	kpan

	endif

endin

;gitable	ftgen	6, 0, 8192, 1, "Samples/mandpluk.aiff", 0, 0, 0


instr mando

	idur	=	p3
	ifreq	=	p4
	;ifreq	=	440
	ipan	=	p5
	iamp	=	0.5

	kenv	madsr	0.01,	idur*0.3,	0.1,	2

	asig	vco2	iamp*kenv,	ifreq,	12

	afilt2	atone	asig,	100

	apanL,	apanR   pan2	afilt2,	ipan
	
			outs	apanL*0.25,	apanR*0.25

	gaverbL	=	apanL
	gaverbR	=	apanR

endin

