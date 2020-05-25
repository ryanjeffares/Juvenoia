instr message

    ktrig trigger gkbut1, 0, 0
    ktrig2 trigger gkbut2, 0, 0

    klength random 0.5, 2  
    ktime init 0  
    ktable random 0, 3.9999
    ktable = int(ktable)
    
    if ktrig == 1 then
    
        while (ktime <= klength) do
            krand random 0, 6.9999
        
            koct random 1, 3.9999        
            koct = int(koct)        
        
            kpan random 0, 1            
            
            if (koct == 1) then
                kadd = 0
                elseif (koct == 2) then
                kadd = 12
                elseif (koct == 3) then
                kadd = 24
            endif 
            
            knote table krand, 4
            event "i", "plucky", ktime, 3, (knote+kadd), ktable, kpan
 ;           event "i", "plucky2", ktime, 0.5, (knote+kadd+5), ktable, kpan
            ktime += 0.75
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
    kpan = p6
    ifn = p5
    inote = cpsmidinn(inote)
    kfreq = cpsmidinn(kfreq) 
    kamp madsr 0.01, 0.1, 1, 2    
    asig pluck 0.5*kamp, kfreq, inote, ifn, 6   
<<<<<<< HEAD
	ahipass	=	asig
;    ahipass atone asig, 250 
=======
	ahipass	=	asig  
;  ahipass atone asig, 250 
>>>>>>> 8b81150ca6382dca49ca0934ad345b68f19cd71a
    arev, arev reverbsc ahipass, ahipass, 0.8, 2000
    afilt atone arev, 250
    outs (afilt*kpan)*0.8, (afilt*(1-kpan))*0.8
    
endin

instr plucky2

    inote = p4    
    kfreq = p4 
    kpan = p6
    ifn = p5
    inote = cpsmidinn(inote)
    kfreq = cpsmidinn(kfreq) 
    kamp madsr 0.01, 0.1, 1, 2    
    asig pluck 0.5*kamp, kfreq, inote, ifn, 1
    ahipass atone asig, 250 
    arev, arev reverbsc ahipass, ahipass, 0.8, 2000
    afilt atone arev, 250
    outs (afilt*kpan)*0.8, (afilt*(1-kpan))*0.8
    
endin

