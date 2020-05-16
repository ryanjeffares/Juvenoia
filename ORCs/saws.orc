instr saw1

    kfreq = gkpot1;/4
    kcutoff = gkcutoff

    kcents lfo 10, 0.5
    kcents = cent(kcents)
    kfreq *= kcents

    if(kfreq < 20) then
        kfreq = 20
    endif 
        
    asig vco2 0.1, kfreq
    asig lpf18 asig, kcutoff, 0.5, 0.9
	asig	=	asig*0.3
	outs	asig,	asig

endin

instr saw2

    kfreq = gkpot1/4
    kcutoff = gkcutoff

    kcents lfo 30, 1
    kcents = cent(kcents)
    kfreq *= kcents

    if(kfreq < 20) then
        kfreq = 20
    endif 
    
    asig vco2 0.1, kfreq 
    gasaw2 lpf18 asig, kcutoff, 0.5, 0.9

endin

