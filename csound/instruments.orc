
;---------------------SAWS---------------------
instr drones
    kOn zkr 7   ; Read the LDR on/off from Zak space
    kOn port kOn, 1 ; Use the on/off as a multiplier for the volume - portamento creates a fade in or out
    kCents1 lfo 30, 0.1     ; Detune the saw waves against eachother slowly
    kCents2 lfo 30, 0.05
    kCents1 = cent(kCents1)
    kCents2 = cent(kCents2)
    kPot1 zkr 0             ; Get the pitch and filter freq from sensor values in Zak space
    kPot2 zkr 1
    kProx zkr 6
    kCutoff abletonLimiter kPot2, 20, 0      ; Bad things happen when frequencies go below 20s
    kFreq1 abletonLimiter (kPot1 * kCents1) / 6, 50, 0 
    kFreq2 abletonLimiter ((kPot1 * kCents2)) / 4, 50, 0
    kFreq1 += (kProx / 4)
    kFreq2 += (kProx / 4)
    kPres lfo 1, 0.02
    kPres += 3
    kRat lfo 0.18, 0.01
    kRat += 0.205

    aSaw oscili 0.05, kFreq1, giSaw     ; Saw waves made from table, faster than vco2
    aSaw lpf18 aSaw, (kCutoff*4) + (kProx * 2), 0.5, 0.9
    aSaw reverb aSaw, 1 + (kProx / 500)
    aSaw distort aSaw, 0.5 * (kPot1 * 0.000977), 1
    aSawDel delay aSaw, 0.02
    aBow wgbow 0.1, kFreq2, kPres, 0.127236, 3 * (kPot1 * 0.000977), 0.01
    aBow reverb aBow, 1 + (kProx / 500)
    aBow distort aBow, 0.5 * (kPot1 * 0.000977), 1
    aBowDel delay aBow, 0.02
    zaw (aSaw + (aBowDel * 0.3)) * kOn, 0    ; Write the audio to Zak space
    zaw (aSawDel + (aBow * 0.3)) * kOn, 1
endin

;---------------------SUB---------------------
instr sub
    kOn zkr 7   ; Read the LDR on/off from Zak space
    kOn port kOn, 1 ; Use the on/off as a multiplier for the volume - portamento creates a fade in or out
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
    zaw aSig*0.5*kOn, 2
endin

;---------------------PLUCKS---------------------
instr plucky
    iNote = cpsmidinn(p4)
    kFreq = cpsmidinn(p4) 
    kAmp madsr 0.01, 0.1, 1, 2      ; Volume envelope  
    aSig1 pluck 0.3*kAmp, kFreq, iNote, p5, 1  
    aSig2 pluck 0.3*kAmp, kFreq*1.5, iNote*1.5, p5, 1 ; Perfect fifth harmony
    if(p5 == 0) then    ; Random (noise) seed was turning out to be quieter...
        aSig1 *= 2
        aSig2 *= 2
    endif   
    aHipass atone (aSig1 + aSig2), 250 ; Filter out unnecessary frequencies and add reverb effect
    aRevL, aRevR reverbsc aHipass, aHipass, 0.8, 2000
    aRevL, aRevR stereoFilter aRevL, aRevR, 20000, 250
    zawm (aRevL * p6) * 0.8, 3
    zawm (aRevR * (1 - p6)) * 0.8, 4
    midion 1, p4, 100 ; Send the note to Pd to control visuals
endin

;---------------------SAMPLES---------------------
instr samples
    kPot3 zkr 2 ; Read the value of Pot 3 from Zak space, turn it to a number between 1 and 0
    kPot3 = kPot3 / 1023
    kPitch scale kPot3, 2, 0.5  ; So we can scale it to control pitch - 0.5 is an octave lower, 2 is octave higher
    Sno sprintfk "%d", p4 ; This code concatenates a string that will be the sample and its path
    Spath strcat "../Samples/Sample", Sno
    Sfile strcat Spath, ".wav"
    aSigl, aSigr diskin Sfile, kPitch   
    aSigl, aSigr reverbsc aSigl, aSigr, 0.5, 10000    
    zaw aSigl * 1.5, 5
    zaw aSigr * 1.5, 6
    vincr gaDelL, aSigl * 0.3
    vincr gaDelR, aSigr * 0.3
endin

;---------------------ARP---------------------
instr 123
    iNote = p4  ; Use pot 3 for transposing - note is i rate so we do not bend notes while they are playing
    kTranspose zkr 2
    kTranspose *= 0.02346   ; Scaling to get +24 midi notes, or 2 octaves
    kTranspose = int(kTranspose)
    iTranspose = i(kTranspose)
    iNote += iTranspose
    kFreq = cpsmidinn(iNote)
    
    kCutoff zkr 0
    kCutoff = kCutoff / 1023
    kCutoff scale kCutoff, 10000, 600   ; Filter
    kCents = 10
    kCents = cent(kCents)
    kEnv madsr 0.01, 0.01, 1, 0.28  ; Envelope for volume and filter
    aSaw oscili 0.6*kEnv, (kFreq + kCents), giSaw   ; Saw and pulse waves, slightly detuned against eachother
    aPulse vco2 0.6*kEnv, (kFreq - kCents), 10
    aFilt lpf18 (aSaw + aPulse), kCutoff*kEnv, 0.5, 0.5
    aRevL, aRevR reverbsc aFilt, aFilt, 0.8, 2000
    ;outs aRevL * 0.5 * p5, aRevR * 0.5 * (1 - p5)
    zawm aRevL * 0.5 * p5, 7
    zawm aRevR * 0.5 * (1 - p5), 8
    vincr gaDelL, aRevL * 0.1
    vincr gaDelR, aRevR * 0.1
endin

;---------------------FM---------------------
instr fm    ; Written by Rhys
    kFmFreq zkr 2
	kEnv madsr 0.01, 0.01, 1, p3/2 ; An envelope for filter and amp
	aSig1 oscil kEnv, p4 ; Sine wave
	aSig2 vco2 kEnv, (kFmFreq + 20), 10 ; Pulse wave
	aSig = aSig1 * aSig2        ; Multiple the two audio signals for FM synthesis
	aSig lpf18 aSig, 4000*kEnv, .2, .8  ; Filtering
	aSig atone aSig, 100
	aFmL, aFmR pan2 aSig, p5    ; Panning
    aFmL, aFmR reverbsc aFmL, aFmR, 0.8, 2000
	aFmL *= 0.15    ; Attenuation
	aFmR *= 0.15
    zawm aFmL, 9    ; Write audio to Zak space
    zawm aFmR, 10
	gaverbL	= aFmL  ; Reverb and delay sends
	gaverbR	= aFmR
    vincr gaDelL, aFmL * 0.02
    vincr gaDelR, aFmR * 0.02
endin

;---------------------CHORDS---------------------
instr bell  ; Written by Rhys
    aSig fmbell p5, p4*6, p7, p8, p9, p10   ; Opcode makes an FM bell sound
	aSig atone aSig, 200    ; Filter low end out
	aSig *= .1
	aPanL, aPanR pan2 aSig, p6
    zawm aPanL, 11
    zawm aPanR, 12
	gaverbL	= aPanL*2
	gaverbR	= aPanR*2        
endin

;---------------------NOISE---------------------
instr noisey    ; Written by Rhys
	kEnv madsr 0.01, p3, 0.35, 6    ; Volume envelope	
	aSig noise 0.6*kEnv, 0.8    ; Burst of noise, sent through band pass filtering with random centre frequencies
	aSig butbp aSig, p4, p7
	aSig atone aSig, 80
	aNoiseL, aNoiseR pan2 aSig, p5
    zawm aNoiseL, 13
    zawm aNoiseR, 14
	gaverbL	= aNoiseL*2
	gaverbR	= aNoiseR*2
    vincr gaDelL, aNoiseL
    vincr gaDelR, aNoiseR	
endin
