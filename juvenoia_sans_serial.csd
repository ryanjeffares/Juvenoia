;				Rhys Mayes & Ryan Jeffares - 2019/20
<CsoundSynthesizer>
<CsOptions>
-odac:sysdefault:CARD=USB ;-j2
-M hw:1,1
</CsOptions>
<CsInstruments>

sr	=	48000
ksmps =  1024   ;arduino needs a high k rate to send over all sensor values
nchnls = 2
0dbfs = 1

seed	0	;ensures random values are different each time by getting a seed from CPU

insremot	"192.168.1.64",	"192.168.1.65",	10,	14,	4,	6,	7

icnt init 0

instr globals    ;initialising global variables

gkpot1	init	0
gkpot2 init 0
    gkpot  init 0
    gkpres init 0
    gkbut1 init 0
    gkbut2 init 0
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
	
	gkpitchcps init 0

    gaverbL	init	0
    gaverbR	init	0    
/*    
    gachordsL init 0
    gachordsR init 0
    gafmL init 0
    gafmR init 0
    ganoiseL init 0
    ganoiseR init 0
    
    gasamplesL init 0
    gasamplesR init 0
*/    
endin 

#include "ORCs/midiin.orc"

#include "ORCs/pitch.orc"

#include "ORCs/sub.orc"

#include "ORCs/saws.orc"

#include "ORCs/message.orc"

#include "ORCs/samples.orc"

#include "ORCs/mandol.orc"

#include "ORCs/chords.orc"

#include "ORCs/noise.orc"

schedule("globals",0,2)

alwayson "pitch"
alwayson "saw1"
alwayson "message"
alwayson "start_notes"
alwayson "reverb"
;alwayson "noise_start"

instr reverb

	gaverboutL	init	0
	gaverboutR	init	0

	gaverboutL, gaverboutR	reverbsc	gaverbL,	gaverbR,	0.75,	800

;			outs	averbL*2,	averbR*2
	gaverbL	=	0
	gaverbR	=	0

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
</CsScore>
</CsoundSynthesizer>
