<CsoundSynthesizer>
<CsOptions>
-odac -Q0
</CsOptions>
<CsInstruments>

ksmps = 256     ;arduino needs a high k rate to send over all sensor values
nchnls = 2
0dbfs = 1

zakinit 15, 8    ; Using Zak space for sensor variables and as much audio as possible.
; Zak opcodes are fast and do not write the variable if an error is detected
gaverbL	init 0
gaverbR	init 0   
gaDelL init 0
gaDelR init 0
gkSample init 0 

; Gen table for Saw wave ref: http://iainmccurdy.org/CsoundRealtimeExamples/Cabbage/Instruments/Synths/HardSyncSynth.csd
; Faster than using saw wave mode in vco2
giSaw ftgen 0, 0, 4097, 7, 1, 4096, -1   							
icount = 0
loopSaw:
imaxh = sr / (2 * 440.0 * exp(log(2.0) * (icount - 69) / 12))
ifn	ftgen 6000+icount, 0, 4097, -30, giSaw, 1, imaxh
loop_le	icount, 1, 127, loopSaw

; Include the orc files
#include "opcodes.orc"
#include "listeners.orc"
#include "instruments.orc"

; This instrument is ran as the score begins. Turns other instruments on, then turns itself off...
instr Initialise
    turnon "arduino_serial"
    turnon "drones"
    turnon "mixer"
    turnon "sub"
    turnon "pluck_listener"
    turnon "sample_listener"
    turnon "fm_start"
    turnon "delay"
    turnon "chord_start"
    turnon "noise_start"
    turnon "arp_listener"
    turnoff
endin   

; Instrument used for reading sensor values from Arduino
instr arduino_serial
    ; Ref: http://floss.booktype.pro/csound/b-csound-and-arduino/
    ; Initialize the variables read
    kPot1 init 0
    kPot2 init 0
    kPot3 init 0
    kButton1 init 0
    kButton2 init 0
    kToggle init 0
    kProx init 0
    kLDR init 0
    kOn init 0

    iPort serialBegin "/dev/cu.usbmodem142301", 9600	;connect to the arduino with baudrate = 9600
    serialWrite iPort, 1		;Triggering the Arduino (k-rate)
    kValue = 0 
    kType serialRead iPort		; Read type of ID we assigned to the sensor
    if (kType >= 128) then      ; If it is in that ID range, start the loop...
        kIndex = 0
        kSize  serialRead iPort ; Find out how many times we need to run the loop
        loopStart:
            kValue 	= kValue << 7     ; Shift the value back up to its original size 
            kByte	serialRead iPort   ; Read the remainder...
            kValue 	= kValue + kByte    ; And add it on
            loop_lt kIndex, 1, kSize, loopStart	
    endif

    if (kValue < 0) kgoto continue      ;ignore if values come in outside of a readable range
        if (kType == 128) then		; This is the first sensor
                kPot1 	= kValue
            elseif (kType == 129) then	; This is the second sensor	
                kPot2	= kValue
            elseif (kType == 130) then  ; Etc...
                kButton1 = kValue
            elseif (kType == 131) then
                kButton2 = kValue
            elseif (kType == 132) then
                kPot3 = kValue
            elseif (kType == 133) then
                kToggle = kValue
            elseif (kType == 134) then
                kProx = kValue
            elseif (kType == 135) then
                kLDR = kValue
        endif

    kPot1 port kPot1, 0.01 ; Smooth out the analog sensors
    kPot2 port kPot2, 0.01 
    kPot3 port kPot3, 0.01   
    kProx port kProx, 0.01
    if (kLDR < 600) then    ; LDR gives high/low outputs depending on light level, use this as an on/off switch
        kOn = 1
    else
        kOn = 0
    endif
    
    outkc 3, 0, kPot1, 0, 1023  ; Send control changes as MIDI to Pd
    outkc 4, 0, kPot2, 0, 1023
    outkc 5, 0, kPot3, 0, 1023
    outkc 6, 0, kProx, 0, 1023
    outkc 7, 0, kOn, 0, 1

    zkw kPot1, 0    ; Put these variables in to Zak space for use in other instruments
    zkw kPot2, 1
    zkw kPot3, 2
    zkw kButton1, 3
    zkw kButton2, 4
    zkw kToggle, 5
    zkw kProx, 6
    zkw kOn, 7
    continue:
endin

instr delay
    ; REF: http://www.csounds.com/manual/html/delayw.html
    abuf2 delayr 1
    adelL deltap .4		;first tap (on left channel)
    adelM deltap 1		;second tap (on middle channel)
    delayw gaDelL + (adelL * 0.5)

    abuf3 delayr 1
    adelR deltap .15	;one pitch changing tap (on the right chn.)
    delayw gaDelR + (adelR * 0.5)
    ;make a mix of all deayed signals	
    outs adelL + adelM, adelR + adelM

    clear gaDelL
    clear gaDelR
    endin



instr mixer
    ; Read the audio from Zak space
    aDroneL zar 0
    aDroneR zar 1
    aSub zar 2
    aPluckL zar 3
    aPluckR zar 4
    aSamplesL zar 5
    aSamplesR zar 6
    aArpL zar 7
    aArpR zar 8
    aFml zar 9
    aFmR zar 10
    aBellL zar 11
    aBellR zar 12
    aNoiseL zar 13
    aNoiseR zar 14

    ; Global reverb effect, set up by Rhys
    averbL,	averbR reverbsc gaverbL, gaverbR, 0.99, 800
    ; Sum the audio signals
    aLeft = (aDroneL * 0.2) + aSub + aPluckL + aSamplesL + aArpL + aFml + aBellL + aNoiseL + averbL
    aRight = (aDroneR * 0.2) + aSub + aPluckR + aSamplesR + aArpR + aFmR + aBellR + aNoiseR + averbR
    ; And output them
    outs aLeft, aRight
    zacl 0, 14
    ; Clear the global audio signals for the next pass
    gaverbL	=	0
	gaverbR	=	0
endin

</CsInstruments>
<CsScore>
; F tables for waveforms and notes
f1 0 16384 10 1
f2 0 16384 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111
f3 0 16384 10 1 0 0.3 0 0.2 0 0.14 0 .111
f4 0 7 -2 60 62 64 65 67 69 71
f5 0 12	-2 65 61 60	67 70 63 64	66 71 62 69	68
f6 0 8 -2 36 39 43 46 50 46 43 39
i"Initialise" 0 100 ; Run the initialise instrument - it will turn itself off
</CsScore>
</CsoundSynthesizer>
