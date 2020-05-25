
opcode abletonLimiter, k, kkk
    ; kOut abletonLimiter kIn, kThresh, kType
    ; Limits a signal to a set threshold. kType is either a 0 or a 1
    ; 0 for downwards limiting (don't let a variable drop below a certain point)
    ; 1 for upwards limiting (don't let a variable rise above a certain point)
    ; So called abletonLimiter because I am convinced the stock Ableton limiter is just 
    ; if (RMS > threshold){
    ;   RMS = threshold;
    ; }
    ; because it sounds so bad
    kVal, kThresh, kType xin
    if(kType == 0) then
        if(kVal < kThresh) then
            kVal = kThresh
        endif
    elseif(kType == 1) then
        if(kVal > kThresh) then
            kVal = kThresh
        endif
    endif
    xout kVal
endop

opcode randomOther, k, kk
    ; "God does not play dice with the universe" - Albert Einstein
    ; kres randomOther kmin, kmax
    ; Outputs a different random integer on every successive use
    ; Thanks to Joachim Heintz on the Csound mailing list for the kgoto method
    seed 0 ; Seeds from system clock for a different random sequence every time we use this score
    kMin, kMax xin
    kOldValue init 0    ; Create a variable to store the previous random numnber
    randomise:
    kValue random kMin, kMax    ; Generate a random number
    kValue = int(kValue)
    if(kValue == kOldValue) kgoto randomise  ; If we generate the same random number twice in a row, try again
    kOldValue = kValue  ; Store the value to check in the next pass
    xout kValue
endop

opcode stereoFilter, aa, aakk
    ; aLeftOut, aLeftRight stereoFilter aLeftIn, aLeftOut, kLPCut, kHPCut
    ; Adjustable high and low pass filtering on a stereo source
    aLeft, aRight, kLPCut, kHPCut xin
    aLeftFiltered clfilt aLeft, kLPCut, 0, 20
    aRightFiltered clfilt aRight, kLPCut, 0, 20
    aLeftFiltered clfilt aLeftFiltered, kHPCut, 1, 20
    aRightFiltered clfilt aRightFiltered, kHPCut, 1, 20
    xout aLeftFiltered, aRightFiltered
endop
