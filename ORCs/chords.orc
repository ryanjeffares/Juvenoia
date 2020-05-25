;				Rhys Mayes - 2020

instr chord_start

	ipan	random	0,	1
	iamp	random	0,	1
	ipres	random	1,	5

	ioct	random	0,	3	;generates random octave - 0 is middle
	ioct	int	koct		;makes random number an integer

	imidi1	random	0,	11
	imidi1	table	kmidi1,	1

	imidi2	random	0,	11
	imidi2	table	kmidi2,	1

	imidi3	random	0,	11
	imidi3	table	kmidi3,	1

	ipch1	=	pchmidinn(kmidi1)
	ipch2	=	pchmidinn(kmidi2)
	ipch3	=	pchmidinn(kmidi3)

	ifreq1	=	cpspch(koct+kpch1)
	ifreq2	=	cpspch(koct+kpch2)
	ifreq3	=	cpspch(koct+kpch3)

	ic1	random	0,	10
	ic2	random	0,1	10
	ivdepth	random	0,	0.5
	ivrate	random	0,	0.7
	
	schedkwhennamed	itrig,	0,	4,	"glass",	4,	10,	ifreq1,	iamp,	ipan,	ic1,	ic2,	ivdepth,	ivrate
	schedkwhennamed	itrig,	0,	4,	"glass",	4+ivdepth,	10,	ifreq2,	iamp,	ipan,	ic1,	ic2,	ivdepth,	ivrate
	schedkwhennamed	itrig,	0,	4,	"glass",	4=ivrate,	10,	ifreq3,	iamp,	ipan,	ic1,	ic2,	ivdepth,	ivrate

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

