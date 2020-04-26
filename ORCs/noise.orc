instr noise_start

	krate	rspline	0,	30,	0.2,	20
	ktrig	metro	krate

	kfilt	random	500,	4000

	kpan	random	0,	1

	kamp	rspline	0,	1,	1,	30

	kband	rspline	30,	100,	1,	30

	schedkwhennamed	ktrig,	0,	0,	"noisey",	0,	0.5,	kfilt,	kpan,	kamp,	kband

endin

instr noisey

	idur	=	p3
	ifreq	=	p4
	ipan	=	p5
	iamp	=	p6
	ibeta	=	0.8
	iband	=	p7

	kenv	madsr	0.01,	idur*0.4,	0.35,	6	
	asig	noise	0.6*kenv,	ibeta

	asig	butbp	asig,	ifreq,	iband

	asig	atone	asig,	80

	ganoiseL,	ganoiseR    pan2	asig,	ipan

	gaverbL	=	ganoiseL*2
	gaverbR	=	ganoiseR*2
	
endin

