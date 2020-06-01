
;---------------------PLUCK TRIGGER---------------------
instr pluck_listener
    kPluckButton zkr 3  ; Read the value of the first button from zak space
    kPluckTrig trigger kPluckButton, 0, 0    ; Create a trigger when we press this
    kPluckTime init 0      
    printk2 kPluckTrig
    if (kPluckTrig == 1) then  ; When we press a button...
        kPluckLength random 0.5, 2  ; Decide a random length for our glissando
        kPluckTable randomOther 0, 4     ; Decide a random source for Karpluss-Strong synthesis
        while (kPluckTime <= kPluckLength) do    ; For our decided duration
            kPluckRand randomOther 0, 7 
            kPluckOct randomOther 1, 4
            kPluckPan random 0, 1   ; Randomly pan each note             
            if (kPluckOct == 1) then    ; Pick a random octave for each note
                kadd = 0                
                elseif (kPluckOct == 2) then
                kadd = 12               ; 12 MIDI notes is an octave
                elseif (kPluckOct == 3) then
                kadd = 24
            endif             
            kPluckNote table kPluckRand, 4  ; Pick a random MIDI note from a table
            event "i", "plucky", kPluckTime, 0.5, (kPluckNote+kadd), kPluckTable, kPluckPan ; Schedule the event with this information
            kPluckTime += 0.1   ; Increment our time
            od    
        kPluckTime = 0        ; Reset the timer
    endif         
endin

;---------------------SAMPLE TRIGGER---------------------
instr sample_listener
    kSampleButton zkr 4
    kSampleTrig trigger kSampleButton, 0, 0
    if (kSampleTrig == 1) then         ; When we get a button press...
        kSample randomOther 1, 9  ; Pick a random sample, not the same as the last one!
        event "i", "sampleTrigger", 0, 0.1, kSample    ; Schedule the event
    endif 
endin

instr sampleTrigger
 ; This is weird but I was getting unwanted MIDI notes sent into Pd for some reason. 
 ; This instrument schedules and event for the sample player, sends over the number of the sample to Pd 
 ; then immediately turns off to prevent the problem
    event "i", "samples", 0, 18, p4 
    midion 2, p4, 127
    turnoff
endin

;---------------------ARP TRIGGER---------------------
instr arp_listener
    kArpToggle zkr 5    ; Read the value of the toggle from zak space
    kMax = 0
    iNdx = 0     
    kTablepos init 0
    kTime init 0
    if (kArpToggle == 1) then    ; If the toggle is on...
        loopstart:            
            kPan random 0, 1     ; Random panning
            kTablepos = kTablepos % 7   ; Go back to the start of the table of MIDI notes if we reach the end
            kNote table kTablepos, 6
            event "i", 123, kTime, 0.01, kNote+24, kPan ; Schedule an event
            kTime += 0.15   ; Incrememnt the time and the table position
            kTablepos += 1    
            midion 8, kNote, 127         
            loop_lt iNdx, 1, kMax, loopstart    
    else    
        turnoff2 123, 0, 1     ; Turn the instrument off when the toggle gets turned off but let the last note release   
    endif    
endin

;---------------------FM TRIGGER---------------------
instr fm_start  ; Written by Rhys
    kOn zkr 7     ; Read our On/Off variable from Zak space
    kFmCnt init 0   ; Initialise a counter
	if (kFmCnt>11) then ; Go back to 0 when we reach the max
		kFmCnt = 0
	endif	
	kRate rspline 0, 5, 2, 100	;spline for time
	kTrig metro	(kRate*.2), 0.00001	;metronome modulated by spline

	kFmOct random 1, 4  ; Random table position for table of octaves 
	kPan rspline 0, 1, 0.1, 2   ; Random panning
					;pgs 264, 265
	kFreq table	kFmCnt, 5
	kFreq = cpspch(kFmOct+kFreq)

	if (kOn == 1) then ; If our LDR based variable is on...
		schedkwhennamed	kTrig, 0, 0, "fm", 0, 3, kFreq,	kPan ; Schedule the event when the metro sends a bang
        kFmCnt += 1 ; Increment the counter
	endif
endin

;---------------------CHORD TRIGGER---------------------
instr chord_start   ; Written by Rhys
    kOn zkr 7   ; Read our On/Off variable from Zak space
	kRate rspline 5, 26, 0.1, 47	;spline for time
	kRate scale kRate, 10, 0.3	;scaling spline
	kTrig metro kRate, 0.00001	;metronome modulated by spline
    kTrig2 metro kRate/2, 0.00001 ; Slower metronome

	kPan rspline 0, 1, 0.1, 2   ; Random panning and amplitude
	kAmp random 0, 1
	
	kOct1 randomOther 0, 4	;generates random octave
    kOct2 randomOther 0, 4
    kOct3 randomOther 0, 4

	kMidi1 randomOther 0, 11 ; Random MIDI note from table, then converted to pitch and cps
	kMidi1 table kMidi1, 1
    kMidi2 randomOther 0, 11
    kMidi2 table kMidi2, 1
    kMidi3 randomOther 0, 11
    kMidi3 table kMidi3, 1

    kMidi4 randomOther 0, 11
    kMidi4 table kMidi4, 5
    kMidi5 randomOther 0, 11
    kMidi5 table kMidi5, 5
    kMidi6 randomOther 0, 11
    kMidi6 table kMidi6, 5

	kPch1 = pchmidinn(kMidi1)   
	kPch2 = pchmidinn(kMidi2)
	kPch3 = pchmidinn(kMidi3)
    kPch4 = pchmidinn(kMidi4)
    kPch5 = pchmidinn(kMidi5)
    kPch6 = pchmidinn(kMidi6)

	kFreq1 = cpspch(kOct1+kPch1)
	kFreq2 = cpspch(kOct2+kPch2)
	kFreq3 = cpspch(kOct3+kPch3)
    kFreq4 = cpspch(kOct1+kPch4)
    kFreq5 = cpspch(kOct2+kPch5)
    kFreq6 = cpspch(kOct3+kPch6)

	kC1	rspline	0, 10, 1, 20    ; Random value for FM frequencies and vibrato params
	kC2	rspline	0, 10, 10, 30
	kVdepth rspline 0, 0.5, 0.01, 50
	kVrate rspline 0, 0.7, 0.01, 50
    ; Schedule events
    if (kOn == 1) then ; If our LDR based variable is on...
        ; Schedule events at different timings with the above variables
        schedkwhennamed	kTrig, 0, 4, "bell", 0, 10, kFreq1, kAmp, kPan,kC1, kC2, kVdepth, kVrate
        schedkwhennamed	kTrig, 0, 4, "bell", kVrate, 10, kFreq2, kAmp, kPan,kC1, kC2, kVdepth, kVrate
        schedkwhennamed	kTrig, 0, 4, "bell", kVdepth, 10, kFreq3, kAmp, kPan,kC1, kC2, kVdepth, kVrate
        schedkwhennamed	kTrig2, 0, 4, "bell", 0, 10, kFreq4, kAmp*0.1, kPan,kC1, kC2, kVdepth, kVrate
        schedkwhennamed	kTrig2, 0, 4, "bell", 0.1, 10, kFreq5, kAmp*0.1, kPan,kC1, kC2, kVdepth, kVrate
        schedkwhennamed	kTrig2, 0, 4, "bell", 0.2, 10, kFreq6, kAmp*0.1, kPan,kC1, kC2, kVdepth, kVrate
    endif
endin
;---------------------NOISE TRIGGER---------------------
instr noise_start   ; Written by Rhys
	kRate rspline 0, 10, 0.2, 20    ; Randomly controlled metronome rate
	kTrig metro kRate/8
	kFilt random 500, 4000  ; Random frequency for filters, pan value, and amplitude
	kPan random 0, 1 
	kAmp rspline 0, 1, 1, 30
	kBand rspline 30, 200, 1, 30
    ; Schedule the event when the metro sends a bang
    schedkwhennamed	kTrig, 0, 0, "noisey", 0, 0.5, kFilt, kPan, kAmp, kBand
endin
