;					Ryan Jeffares - 2020

instr saw1

    kfreq = gkpitchcps ;/4

	kfreq portk kfreq, 2

    kcents lfo 10, 0.5
    kfreq = gkpot*4 ;/4
	kcutoff	= 900
	
    kcents lfo 0.8, 0.5
    kcents = cent(kcents)
    kfreq *= kcents

    if(kfreq < 20) then
        kfreq = 20
    endif 
        
    asig vco2 0.1, kfreq
    asig lpf18 asig, kcutoff, 0.5, 0.9
	asig	=	asig*0.1
	outs	asig,	asig

endin

