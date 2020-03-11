
instr sub

    ;kdepth = gkpot2/100
    klfo lfo 10, 0.5

    kfreq = gkpot1/4
    kfreq += klfo
    kfreq += gksoftpot

    if(kfreq < 20) then
        kfreq = 20
    endif
    
    kpw lfo 0.4, 0.4
    kpw += 0.5
    asig vco2 0.5, kfreq, 2, kpw
    adel oscil 0.1, 0.1
    aflange flanger asig, adel, 0.4
    gasub lpf18 aflange, gkcutoff, 0.5, 0.5

endin

