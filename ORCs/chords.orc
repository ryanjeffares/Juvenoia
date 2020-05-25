;				Rhys Mayes - 2020

instr chord_start

	kcnt	init	1
	icnt	init	0
	
	krate	rspline	5,	26,	0.1,	47	;spline for time
	krate	scale	krate,	10,	0.3	;scaling spline
	ktrig	metro	krate				;metronome modulated by spline

	kpan	rspline	0,	1,	0.1,	2
	kamp	random	0,	1
	kpres	random	1,	5

	koct	random	0,	3	;generates random octave - 0 is middle
	koct	int	koct		;makes random number an integer

	kmidi1	random	0,	11
	kmidi1	table	kmidi1,	1

	kmidi2	random	0,	11
	kmidi2	table	kmidi2,	1

	kmidi3	random	0,	11
	kmidi3	table	kmidi3,	1

	kpch1	=	pchmidinn(kmidi1)
	kpch2	=	pchmidinn(kmidi2)
	kpch3	=	pchmidinn(kmidi3)

	kfreq1	=	cpspch(koct+kpch1)
	kfreq2	=	cpspch(koct+kpch2)
	kfreq3	=	cpspch(koct+kpch3)

	kc1	rspline	0,	10,	1,	20
	kc2	rspline	0,	10,	10,	30
	kvdepth	rspline	0,	0.5,	0.01,	50
	kvrate	rspline	0,	0.7,	0.01,	50

	
	schedkwhennamed	ktrig,	0,	4,	"glass",	4,	10,	kfreq1,	kamp,	kpan,	kc1,	kc2,	kvdepth,	kvrate
	schedkwhennamed	ktrig,	0,	4,	"glass",	4+kvdepth,	10,	kfreq2,	kamp,	kpan,	kc1,	kc2,	kvdepth,	kvrate
	schedkwhennamed	ktrig,	0,	4,	"glass",	4+kvrate,	10,	kfreq3,	kamp,	kpan,	kc1,	kc2,	kvdepth,	kvrate

endin

instr glass

	iamp	=	p5
    	ifreq	=	p4
    	ipan	=	p6
	kc1	=	p7
	kc2	=	p8
	kvdepth	=	p9
	kvrate	=	p10

;    	asig fmbell iamp, ifreq*6, kc1, kc2, kvdepth, kvrate
;asig fmbell iamp, ifreq, 3, 6, 0.2, 10


	asig oscil 0.3,	ifreq

	asig	atone	asig,	200

	asig	*=	.1

	apanL,	apanR	pan2	asig,	ipan


		outs	apanL,	apanR


	gaverbL	=	apanL*2
	gaverbR	=	apanR*2
         
endin

