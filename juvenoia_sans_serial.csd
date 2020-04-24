/*	This CSD is for debugging on the PowerMac due to a lack of serial opcodes and cabbage

will become redundant eventually*/

<CsoundSynthesizer>
<CsOptions>
-j2 ;-odac
</CsOptions>
<CsInstruments>

sr	=	44100
ksmps =  1024   ;arduino needs a high k rate to send over all sensor values
nchnls = 2
0dbfs = 1

seed	0	;ensures random values are different each time by getting a seed from CPU

instr globals    ;initialising global variables

    gkpot1 init 0
    gkpot2 init 0
    gkbutton1 init 0
    gkbutton2 init 0
    gksoftpot init 0

    gasaw1 init 0
    gasaw2 init 0 
    gkpitch  init	100
    gkcutoff =	gkpot2*8

    kfiltlfo lfo 200, 0.1
    gkcutoff += kfiltlfo
    
    if(gkcutoff < 20) then
        gkcutoff = 20
    endif    

    gaverbL	init	0
    gaverbR	init	0    
    
    gachordsL init 0
    gachordsR init 0
    gafmL init 0
    gafmR init 0
    ganoiseL init 0
    ganoiseR init 0
    
    gasamplesL init 0
    gasamplesR init 0
    
endin 

#include "ORCs/ardnocabbage.orc"

#include "ORCs/sub.orc"

#include "ORCs/saws.orc"

#include "ORCs/message.orc"

#include "ORCs/samples.orc"

#include "ORCs/mandol.orc"

#include "ORCs/chords.orc"

#include "ORCs/noise.orc"

alwayson "globals"
alwayson "arduino_serial"
;alwayson "saw1"
;alwayson "saw2"
alwayson "mixer"
;alwayson "sub"
alwayson "message"
alwayson "start_notes"
alwayson	"reverb"
;alwayson	"delay"
alwayson "chord_start"
alwayson "noise_start"



/*
instr delay

	ktime	rspline	0.1,	3,	1,	20

	asig1	deltap	0.75*ktime
	asig2	deltap	(1*ktime)
	asig3	deltap	1.5*ktime

	asig	=	asig1+(asig2*.5)+(asig3*.25)


		outs	asig,	asig

	gadel	=	0
	gaverbL	=	asig
	gaverbR	=	asig

endin
*/

instr reverb

	averbL,	averbR	reverbsc	gaverbL,	gaverbR,	0.99,	800

			outs	averbL*2,	averbR*2
	gaverbL	=	0
	gaverbR	=	0

endin

instr mixer

    ksaw1pan chnget "saw1pan"
    ksaw2pan chnget "saw2pan"

    outs ((gasaw1*(1-ksaw1pan)) + (gasaw2*(1-ksaw2pan)) + ((gasub*0.2))*0.3) + gachordsL + gafmL + gasamplesL + ganoiseL, ((gasaw1*ksaw1pan) + (gasaw2*ksaw2pan) + ((gasub*0.2))*0.3) + gachordsR + gafmR + gasamplesR + ganoiseR

    amasterl = ((gasaw1*(1-ksaw1pan)) + (gasaw2*(1-ksaw2pan)) + ((gasub*0.2))*0.3) + gachordsL + gafmL + gasamplesL + ganoiseL
    amasterr = ((gasaw1*ksaw1pan) + (gasaw2*ksaw2pan) + ((gasub*0.2))*0.3) + gachordsR + gafmR + gasamplesR + ganoiseR
    kmasterlrms rms amasterl
    kmasterrrms rms amasterr
    chnset kmasterlrms, "masterl"
    chnset kmasterrrms, "masterr"

endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
;i "globals" 0 200

f0 z
f1 0 16384 10 1
f2 0 16384 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111
f3 0 16384 10 1 0 0.3 0 0.2 0 0.14 0 .111
f4 0 7 -2 60 62 64 65 67 69 71
f5 0 12	-2 65 61 60	67 70 63 64	66 71 62 69	68
f6 0 8192 1 "Samples/mandpluk.aiff" 0 0 0
</CsScore>
</CsoundSynthesizer>
