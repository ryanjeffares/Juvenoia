instr saw1

    kfreq = gkpot1/4
    kcutoff = gkcutoff

    kcents lfo 30, 0.5
    kcents = cent(kcents)
    kfreq *= kcents

    asig vco2 (0.5 - gkkickrms), kfreq
    gasaw1 lpf18 asig, kcutoff, 0.5, 0.9

endin

instr saw2

    kfreq = gkpot1/4
    kcutoff = gkcutoff

    kcents lfo 30, 1
    kcents = cent(kcents)
    kfreq *= kcents

    asig vco2 (0.5 - gkkickrms), kfreq 
    gasaw2 lpf18 asig, kcutoff, 0.5, 0.9

endin

