
instr samples

    ksample = p4
    
    if(ksample = 1) then
        asigl, asigr diskin "Samples/Sample1.wav"
    elseif(ksample = 2) then
        asigl, asigr diskin "Samples/Sample2.wav"
    elseif(ksample = 3) then
        asigl, asigr diskin "Samples/Sample3.wav"
    elseif(ksample = 4) then
        asigl, asigr diskin "Samples/Sample4.wav"
    elseif(ksample = 5) then
        asigl, asigr diskin "Samples/Sample5.wav"
    elseif(ksample = 6) then
        asigl, asigr diskin "Samples/Sample6.wav"        
    endif
    
    arevl, arevr reverbsc asigl, asigr, 0.5, 10000
    outs arevl*0.9, arevr*0.9
    
endin

