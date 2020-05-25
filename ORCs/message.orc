;					Ryan Jeffares - 2019

instr message

 	ktrig2	init	0	

    klength random 0.5, 2  
    ktime init 0  
    ktable random 0, 3.9999
    ktable = int(ktable)
	kbut1	metro	0.1    

    if kbut1 == 1 then
    
	schedule	"chord_start",	0.2,	4
    
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

	ahipass	=	asig  
    arev, arev reverbsc ahipass, ahipass, 0.8, 2000
    afilt atone arev, 250
    outs (afilt*kpan)*0.8, (afilt*(1-kpan))*0.8
    
endin

