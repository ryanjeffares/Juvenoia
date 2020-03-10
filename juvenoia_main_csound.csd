/*TO DO
Optimise the Sub
Find a way for the second button to play a DIFFERENT sample each time
Re-implement the pvsanal tape player boi
Add in the phone ringing boi
*/
<Cabbage>
form caption("Untitled") size(400, 300), colour("yellow"), pluginid("def1")
rslider channel("pitch") range(20, 500, 100, 1, 1) bounds(100, 0, 50, 50) text("Pitch")
rslider channel("saw1pan") range(0, 1, 0.5, 1, 0.01) text("Saw 1 Pan") bounds(150, 0, 50, 50) 
rslider channel("saw2pan") range(0, 1, 0.5, 1, 0.01) text("Saw 2 Pan") bounds(200, 0, 50, 50) 
rslider channel("cutoff") range(20, 20000, 500, 0.3, 1) text("Cutoff") bounds(250, 0, 50, 50)

button bounds(150, 50, 50, 50) channel("trigger") identchannel("buttonident") 
button bounds(200, 50, 50, 50) channel("trigger2")

vmeter bounds(10, 50, 35, 198) channel("saw1") value(0) overlaycolour(70, 53, 53, 255) metercolour:0(0, 255, 0, 255) metercolour:1(0, 103, 171, 255) metercolour:2(23, 0, 123, 255) outlinethickness(4)
vmeter bounds(60, 50, 35, 198) channel("saw2") value(0) overlaycolour(70, 53, 53, 255) metercolour:0(0, 255, 0, 255) metercolour:1(0, 103, 171, 255) metercolour:2(23, 0, 123, 255) outlinethickness(4)
vmeter bounds(110, 50, 35, 198) channel("master") value(0) overlaycolour(70, 53, 53, 255) metercolour:0(0, 255, 0, 255) metercolour:1(0, 103, 171, 255) metercolour:2(23, 0, 123, 255) outlinethickness(4)

;label bounds(60, 250, 100, 50) identchannel("masterIdent")
</Cabbage>
 <CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5 -j8
</CsOptions>
<CsInstruments>

ksmps = 512     ;arduino needs a high k rate to send over all sensor values
nchnls = 2
0dbfs = 1

alwayson "arduino_serial"
alwayson "saw1"
alwayson "saw2"
alwayson "mixer"
alwayson "sub"
alwayson "message"

alwayson	"reverb"
alwayson	"delay"
alwayson "chord_start"
alwayson "noise_start"


instr globals    ;initialising global variables

    gkpot1 chnget "pitch"
    gkpot2 init 0
    gkbutton1 init 0
    gkbutton2 init 0
    gksoftpot init 0

    gasaw1 init 0
    gasaw2 init 0 
    gkpitch chnget "pitch"
    gkcutoff chnget "cutoff"
    gkkickrms init 0

    kfiltlfo lfo 200, 0.1
    gkcutoff += kfiltlfo

    gaverbL	init	0
    gaverbR	init	0
    gkcnt	init	0
    
endin 


#include "ORCs/arduino.orc"

#include "ORCs/sub.orc"

#include "ORCs/saws.orc"

#include "ORCs/message.orc"

#include "ORCs/samples.orc"

#include "ORCs/fm.orc"

#include "ORCs/chords.orc"

#include "ORCs/noise.orc"

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

instr reverb

	averbL,	averbR	reverbsc	gaverbL,	gaverbR,	0.99,	800

			outs	averbL*2,	averbR*2
	gaverbL	=	0
	gaverbR	=	0

endin

instr mixer

krmssaw1 rms gasaw1
krmssaw2 rms gasaw2

ksaw1pan chnget "saw1pan"
ksaw2pan chnget "saw2pan"

chnset krmssaw1, "saw1"
chnset krmssaw2, "saw2"

outs ((gasaw1*(1-ksaw1pan)) + (gasaw2*(1-ksaw2pan)) + (gasub*0.2))*0.3, ((gasaw1*ksaw1pan) + (gasaw2*ksaw2pan) + (gasub*0.2))*0.3

amaster = gasaw1 + gasaw2
kmasterrms rms amaster
chnset kmasterrms, "master"

endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
i "globals" 0 z
f1 0 16384 10 1
f2 0 16384 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111
f3 0 16384 10 1 0 0.3 0 0.2 0 0.14 0 .111
f4 0 7 -2 60 62 64 65 67 69 71
f5	0	12	-2	65	61	60	67	70	63	64	66	71	62	69	68
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
