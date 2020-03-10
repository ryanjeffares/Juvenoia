
instr sub

    kdepth = gkpot2/100
    klfo lfo kdepth, 0.5

    kfreq = gkpot1*0.75
    kfreq += klfo
    kfreq += gksoftpot

    kpw lfo 0.4, 0.4
    kpw += 0.5
    asig vco2 (0.5 - gkkickrms), kfreq, 2, kpw
    adel oscil 0.1, 0.1
    aflange flanger asig, adel, 0.4
    gasub lpf18 aflange, gkcutoff, 0.5, 0.5

endin

