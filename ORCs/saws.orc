instr saw1

    kfreq = gkpot1/4
    kcutoff = gkcutoff

    kcents lfo 30, 0.5
    kcents = cent(kcents)
    kfreq *= kcents

    if(kfreq < 20) then
        kfreq = 20
    endif 
        
    asig vco2 0.1, kfreq
    gasaw1 lpf18 asig, kcutoff, 0.5, 0.9

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

