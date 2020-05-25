;				Rhys Mayes - 2020

instr chord_start

;	itrig	init	1

	ipan	random	0,	1
	iamp	random	0,	1
	ipres	random	1,	5

	ioct	random	0,	3	;generates random octave - 0 is middle
	ioct	int	ioct		;makes random number an integer

	imidi1	random	0,	11
	imidi1	table	imidi1,	4

	imidi2	random	0,	11
	imidi2	table	imidi2,	4

	imidi3	random	0,	11
	imidi3	table	imidi3,	4

	ipch1	=	pchmidinn(imidi1)
	ipch2	=	pchmidinn(imidi2)
	ipch3	=	pchmidinn(imidi3)

	ifreq1	=	cpspch(ioct+ipch1)
	ifreq2	=	cpspch(ioct+ipch2)
	ifreq3	=	cpspch(ioct+ipch3)

	ic1	random	0,	10
	ic2	random	0.1,	10
	ivdepth	random	0,	0.5
	ivrate	random	0,	0.7
	
	schedule	"glass",	4,	10,	ifreq1,	iamp,	ipan ;,	ic1,	ic2,	ivdepth,	ivrate
	schedule	"glass",	4+ivdepth,	10,	ifreq2,	iamp,	ipan ;,	ic1,	ic2,	ivdepth,	ivrate
	schedule	"glass",	4+ivrate,	10,	ifreq3,	iamp,	ipan ;,	ic1,	ic2,	ivdepth,	ivrate

endin

instr glass

	idur	=	p3
	iamp	=	p5
    	ifreq	=	p4
    	ipan	=	p6/*
	kc1	=	p7
	kc2	=	p8
	kvdepth	=	p9
	kvrate	=	p10
*/
;    	asig fmbell iamp, ifreq*6, kc1, kc2, kvdepth, kvrate
;asig fmbell iamp, ifreq, 3, 6, 0.2, 10

	kenv	madsr	0.01,	idur*0.75,	0.6,	2
	asig oscil iamp*kenv,	ifreq

	asig	atone	asig,	200

;	asig	*=	.1

	apanL,	apanR	pan2	asig,	ipan


		outs	apanL,	apanR


	gaverbL	=	apanL*2
	gaverbR	=	apanR*2
         
endin

