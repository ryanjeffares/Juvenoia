
instr samples

    ksample = p4
    
    if(ksample = 1) then
        asigl, asigr diskin "Samples/Sample1.wav"
	prints	"\\n\\n\\n\\n\\n\\n\\n\\n'If you were born in the eighties or nineties,\\n you may not be ready for the real world!'\\n\\n\\n\\n\\n\\n\\n\\n"
    elseif(ksample = 2) then
        asigl, asigr diskin "Samples/Sample2.wav"
	prints	"\\n\\n\\n\\n\\n\\n\\n\\n...And they're accused of being entitled,\\n\\n...and narcissistic,\\n\\n...self interested\\n\\n...unfocussed\\n\\n...lazy...\\n\\n\\n\\n\\n\\n\\n\\n"
    elseif(ksample = 3) then
        asigl, asigr diskin "Samples/Sample3.wav"
    elseif(ksample = 4) then
        asigl, asigr diskin "Samples/Sample4.wav"
    elseif(ksample = 5) then
        asigl, asigr diskin "Samples/Sample5.wav"
	prints	"\\n\\n\\n\\n\\n\\n\\n\\nI don't like the way that\\n\\na stiff upper lip,\\n\\nmanning up and all that kind of thing\\n\\nhas now become something to be offensive\\n\\n\\n\\n\\n\\n\\n\\n"

    elseif(ksample = 6) then
        asigl, asigr diskin "Samples/Sample6.wav"        
	prints "\\n\\n\\n\\n\\n\\n\\n\\nfacts don't care about your feelings."
    endif
    
    gasamplesL, gasamplesR reverbsc asigl, asigr, 0.5, 10000    
    
endin

