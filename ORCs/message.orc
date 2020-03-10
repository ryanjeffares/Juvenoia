instr message
    ktrig = gkbutton1
    ktrig2 = gkbutton2
    kcabbagebutton chnget "trigger"
    kcabbagebutton2 chnget "trigger2"
    ktrig trigger kcabbagebutton, 0, 0
    ktrig2 trigger kcabbagebutton2, 0, 0
    
    kkicklength = 32
    kelapsed init 0
    kbeat init 0
    klength random 0.5, 2  
    ktime init 0  
    ktable random 0, 3
    ktable = int(ktable)
    
    if ktrig == 1 then
    
    while (ktime <= klength) do
        krand random 0, 6
        
        koct random 1, 3        
        koct = round(koct)        
        
        if (koct == 1) then
            kadd = 0
            elseif (koct == 2) then
            kadd = 12
            elseif (koct == 3) then
            kadd = 24
        endif 
            
        knote table krand, 4
        event "i", "plucky", ktime, 0.5, (knote+kadd), ktable
        event "i", "plucky2", ktime, 0.5, (knote+kadd+5), ktable
        ktime += 0.1
        od
    
    ktime = 0    
    
    endif 
        
    koldsample init 0
        
    if ktrig2 == 1 then
        randomise:
        ksample random 1, 6.9999
        ksample = int(ksample)
        if(ksample != koldsample) then
            event "i", "samples", 0, 9, ksample
        else
            kgoto randomise
        endif
        
        koldsample = ksample
    
    endif 
    
endin

instr plucky

    inote = p4    
    kfreq = p4 
    ifn = p5
    inote = cpsmidinn(inote)
    kfreq = cpsmidinn(kfreq) 
    kamp madsr 0.01, 0.1, 1, 2    
    asig pluck 0.2*kamp, kfreq, inote, ifn, 6   
    ahipass atone asig, 250 
    arev, arev reverbsc ahipass, ahipass, 0.8, 2000
    afilt atone arev, 250
    outs afilt, afilt

endin

instr plucky2

    inote = p4    
    kfreq = p4  
    ifn = p5
    inote = cpsmidinn(inote)
    kfreq = cpsmidinn(kfreq) 
    kamp madsr 0.01, 0.1, 1, 2    
    asig pluck 0.2*kamp, kfreq, inote, ifn, 1
    ahipass atone asig, 250 
    arev, arev reverbsc ahipass, ahipass, 0.8, 2000
    afilt atone arev, 250
    outs afilt, afilt

endin

