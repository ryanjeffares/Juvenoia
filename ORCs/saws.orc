;					Ryan Jeffares - 2020

instr saw1

    kfreq = gkpot*4 ;/4

    kcents lfo 10, 0.5
;kfreq init 45
    kfreq = gkpot*4 ;/4
/*
ktrig metro 0.1

if (ktrig == 1) then
kfreq	random	20, 100
endif
*/
   ; kcutoff = gkcutoff
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

