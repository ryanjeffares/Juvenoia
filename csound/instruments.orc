
;---------------------SAWS---------------------
instr saws
    kCents1 lfo 30, 0.1     ; Detune the saw waves against eachother slowly
    kCents2 lfo 30, 0.05
    kCents1 = cent(kCents1)
    kCents2 = cent(kCents2)
    kPot1 zkr 0             ; Get the pitch and filter freq from sensor values in Zak space
    kPot2 zkr 1
    kCutoff abletonLimiter kPot2, 20, 0      ; Bad things happen when frequencies go below 20s
    kFreq1 abletonLimiter (kPot1 * kCents1) / 6, 20, 0 
    kFreq2 abletonLimiter ((kPot1 * kCents2)) / 4, 20, 0
    kPres lfo 1, 0.02
    kPres += 3
    kRat lfo 0.18, 0.01
    kRat += 0.205

    aSaw oscili 0.05, kFreq1, giSaw     ; Saw waves made from table, faster than vco2
    aSaw lpf18 aSaw, kCutoff*4, 0.5, 0.9
    aSaw reverb aSaw, 1
    aSaw distort aSaw, 0.5 * (kPot1 * 0.000977), 1
    aSawDel delay aSaw, 0.02
    aBow wgbow 0.1, kFreq2, kPres, 0.127236, 3 * (kPot1 * 0.000977), 0.01
    aBow reverb aBow, 1
    aBow distort aBow, 0.5 * (kPot1 * 0.000977), 1
    aBowDel delay aBow, 0.02
    zaw aSaw + (aBowDel * 0.3), 0    ; Write the audio to Zak space
    zaw aSawDel + (aBow * 0.3), 1
endin

;---------------------SUB---------------------
instr sub
    ; LFO to modulate the sub's pitch, get the pitch from sensor value in Zak space and limit it
    kLfo lfo 5, 0.02    
    kFreq zkr 0
    kFreq abletonLimiter (kFreq/8 + kLfo), 20, 0
    ; Modulate the pulse width, flange and filter, then write to Zak space
    kPw lfo 0.4, 0.4
    kPw += 0.5
    aSig vco2 0.5, kFreq, 2, kPw
    aDel oscil 0.1, 0.1
    aSig flanger aSig, aDel, 0.4
    aSig lpf18 aSig, 200, 0.5, 0.5
    zaw aSig*0.5, 2
endin

;---------------------PLUCKS---------------------
instr plucky
    iNote = cpsmidinn(p4)
    kFreq = cpsmidinn(p4) 
    kAmp madsr 0.01, 0.1, 1, 2    
    aSig1 pluck 0.5*kAmp, kFreq, iNote, p5, 6  
    aSig2 pluck 0.5*kAmp, kFreq*1.5, iNote*1.5, p5, 1 ; Perfect fifth harmony
    aHipass atone (aSig1 + aSig2), 250 
    aRevL, aRevR reverbsc aHipass, aHipass, 0.8, 2000
    aRevL, aRevR stereoFilter aRevL, aRevR, 20000, 250
    ;outs (aRevL *p6) * 0.8, (aRevR * (1 - p6)) * 0.8
    zawm (aRevL *p6) * 0.8, 3
    zawm (aRevR * (1 - p6)) * 0.8, 4
    midion 1, p4, 100
endin

;---------------------SAMPLES---------------------
instr samples
    kPot3 zkr 2
    kPot3 *= 0.000977
    kPitch scale kPot3, 2, 0.5
    Spath = "../Samples/Sample"
    Sextension = ".wav"
    Sno sprintfk "%d", p4
    Spath strcat Spath, Sno
    Sfile strcat Spath, Sextension
    aSigl, aSigr diskin Sfile, kPitch   
    aSigl, aSigr reverbsc aSigl, aSigr, 0.5, 10000    
    zaw aSigl, 5
    zaw aSigr, 6
    vincr gaDelL, aSigl * 0.3
    vincr gaDelR, aSigr * 0.3
    midion 2, p4, kPot3 * 127
endin

;---------------------ARP---------------------
instr 123
    iNote = p4
    kTranspose zkr 2
    kTranspose *= 0.02346
    kTranspose = int(kTranspose)
    iTranspose = i(kTranspose)
    iNote += iTranspose
    kFreq = cpsmidinn(iNote)
    
    kCutoff zkr 0
    kCutoff *=  10
    kCents = 10
    kCents = cent(kCents)

    kEnv madsr 0.01, 0.01, 1, 0.28  
    aSaw oscili 0.6*kEnv, (kFreq + kCents), giSaw
    aPulse vco2 0.6*kEnv, (kFreq - kCents), 10
    aFilt lpf18 (aSaw + aPulse), kCutoff*kEnv, 0.5, 0.5
    aRevL, aRevR reverbsc aFilt, aFilt, 0.8, 2000
    ;outs aRevL * 0.5 * p5, aRevR * 0.5 * (1 - p5)
    zawm aRevL * 0.5 * p5, 7
    zawm aRevR * 0.5 * (1 - p5), 8
endin

;---------------------FM---------------------
instr fm

	idur	=	p3
	ifreq	=	p4
	;ifreq	=	440
	ipan	=	p5
    kFmFreq zkr 2
	kenv	madsr	0.01,	0.01,	1,	idur/2
	asig1	vco2	kenv,	ifreq/2,	12
	asig2	vco2	kenv,	(kFmFreq + 20) / 2,	12

	asig	=	asig1	*	asig2


	afilt	lpf18	asig,	4000*kenv,	.2,	.8

	afilt2	atone	afilt,	100

	afmL,	afmR   pan2	afilt2,	ipan
	
	afmL *= 0.25
	afmR *= 0.25
    zawm afmL, 9
    zawm afmR, 10
	gaverbL	=	afmL
	gaverbR	=	afmR
    vincr gaDelL, afmL * 0.02
    vincr gaDelR, afmR * 0.02

endin

;---------------------BELLS---------------------
instr bell

	iamp	=	p5
    	ifreq	=	p4
    	ipan	=	p6
	kc1	=	p7
	kc2	=	p8
	kvdepth	=	p9
	kvrate	=	p10

    	asig fmbell iamp, ifreq*6, kc1, kc2, kvdepth, kvrate
;asig fmbell iamp, ifreq, 3, 6, 0.2, 10


	asig	atone	asig,	200

	asig	*=	.1

	apanL,	apanR	pan2	asig,	ipan
    zawm apanL, 11
    zawm apanR, 12

	gaverbL	=	apanL*2
	gaverbR	=	apanR*2
         
endin

;---------------------NOISE---------------------
instr noisey

	idur	=	p3
	ifreq	=	p4
	ipan	=	p5
	iamp	=	p6
	ibeta	=	0.8
	iband	=	p7

	kenv	madsr	0.01,	idur,	0.35,	6	
	asig	noise	0.6*kenv,	ibeta

	asig	butbp	asig,	ifreq,	iband

	asig	atone	asig,	80

	anoiseL,	anoiseR    pan2	asig,	ipan
    zawm anoiseL, 13
    zawm anoiseR, 14
	gaverbL	=	anoiseL*2
	gaverbR	=	anoiseR*2
    vincr gaDelL, anoiseL
    vincr gaDelR, anoiseR
	
endin



