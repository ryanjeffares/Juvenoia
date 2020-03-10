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

instr arduino_serial

    ; Initialize the three variables read
    kpot1       init 0
    kpot2       init 0
    kbutton1    init 0
    kbutton2    init 0
    ksoftpot    init 0

    iPort	    serialBegin "/dev/cu.usbmodem14301", 9600	;connect to the arduino with baudrate = 9600
                serialWrite iPort, 1		;Triggering the Arduino (k-rate)

    kValue 	    = 0
    kType 	    serialRead iPort		; Read type of data (pot, light, button)

    if (kType >= 128) then

        kIndex = 0
        kSize  serialRead iPort
	    
        loopStart:
            kValue 	= kValue << 7          
            kByte	serialRead iPort
            kValue 	= kValue + kByte
            loop_lt kIndex, 1, kSize, loopStart
	
    endif

    if (kValue < 0) kgoto continue      ;ignore if values come in outside of a readable range

        if (kType == 128) then		; This is the first sensor
                kpot1 	= kValue
            elseif (kType == 129) then	; This is the second sensor	
                kpot2	= kValue
            elseif (kType == 130) then
                kbutton1 = kValue
            elseif (kType == 131) then
                kbutton2 = kValue
            elseif (kType == 132) then
                ksoftpot = kValue
        endif

    kpot1  port kpot1, 0.01
    kpot2 port kpot2, 0.01 
    ksoftpot port ksoftpot, 0.01   

    gkpot1 = kpot1
    gkpot2 = kpot2
    gkbutton1 = kbutton1
    gkbutton2 = kbutton2
    gksoftpot = ksoftpot

    printk2 ksoftpot

    continue:

endin


instr sub

    kdepth = gkpot2/100
    klfo lfo kdepth, 0.5

    kfreq = gkpot1*0.75
    kfreq += klfo
    kfreq += gksoftpot

    kpw lfo 0.4, 0.4
    kpw += 0.5
    asig vco2 (0.5 - gkkickrms), kfreq, 2, kpw
    adel oscil 0.1, 0.1
    aflange flanger asig, adel, 0.4
    gasub lpf18 aflange, gkcutoff, 0.5, 0.5

endin

instr saw1

    kfreq = gkpot1/4
    kcutoff = gkcutoff

    kcents lfo 30, 0.5
    kcents = cent(kcents)
    kfreq *= kcents

    asig vco2 (0.5 - gkkickrms), kfreq
    gasaw1 lpf18 asig, kcutoff, 0.5, 0.9

endin

instr saw2

    kfreq = gkpot1/4
    kcutoff = gkcutoff

    kcents lfo 30, 1
    kcents = cent(kcents)
    kfreq *= kcents

    asig vco2 (0.5 - gkkickrms), kfreq 
    gasaw2 lpf18 asig, kcutoff, 0.5, 0.9

endin

instr message

    ktrig = gkbutton1
    ktrig2 = gkbutton2
    kcabbagebutton chnget "trigger"
    kcabbagebutton2 chnget "trigger2"
    ktrig trigger kcabbagebutton, 0, 0
    ktrig2 trigger kcabbagebutton2, 0, 0
    
    kkicklength = 32
    kelapsed init 0
    kbeat init 0

    klength random 0.5, 2  
    ktime init 0  
    ktable random 0, 3
    ktable = int(ktable)
    
    if ktrig == 1 then
    
    while (ktime <= klength) do

        krand random 0, 6
        
        koct random 1, 3        
        koct = round(koct)        
        
        if (koct == 1) then
            kadd = 0
            elseif (koct == 2) then
            kadd = 12
            elseif (koct == 3) then
            kadd = 24
        endif 
            
        knote table krand, 4
        event "i", "plucky", ktime, 0.5, (knote+kadd), ktable
        event "i", "plucky2", ktime, 0.5, (knote+kadd+5), ktable
        ktime += 0.1
        od
    
    ktime = 0    
    
    endif 
        
    koldsample init 0
        
    if ktrig2 == 1 then
        randomise:
        ksample random 1, 6.9999
        ksample = int(ksample)
        if(ksample != koldsample) then
            event "i", "samples", 0, 9, ksample
        else
            kgoto randomise
        endif
        
        koldsample = ksample
    
    endif 
    
endin

instr plucky

    inote = p4    
    kfreq = p4 
    ifn = p5
    inote = cpsmidinn(inote)
    kfreq = cpsmidinn(kfreq) 
    kamp madsr 0.01, 0.1, 1, 2    
    asig pluck 0.2*kamp, kfreq, inote, ifn, 6   
    ahipass atone asig, 250 
    arev, arev reverbsc ahipass, ahipass, 0.8, 2000
    afilt atone arev, 250
    outs afilt, afilt

endin

instr plucky2

    inote = p4    
    kfreq = p4  
    ifn = p5
    inote = cpsmidinn(inote)
    kfreq = cpsmidinn(kfreq) 
    kamp madsr 0.01, 0.1, 1, 2    
    asig pluck 0.2*kamp, kfreq, inote, ifn, 1
    ahipass atone asig, 250 
    arev, arev reverbsc ahipass, ahipass, 0.8, 2000
    afilt atone arev, 250
    outs afilt, afilt

endin

instr samples

    ksample = p4
    
    if(ksample = 1) then
        asigl, asigr diskin "/Users/ryanjeffares/Documents/JUVENOIA/Samples/Sample1.wav"
    elseif(ksample = 2) then
        asigl, asigr diskin "/Users/ryanjeffares/Documents/JUVENOIA/Samples/Sample2.wav"
    elseif(ksample = 3) then
        asigl, asigr diskin "/Users/ryanjeffares/Documents/JUVENOIA/Samples/Sample3.wav"
    elseif(ksample = 4) then
        asigl, asigr diskin "/Users/ryanjeffares/Documents/JUVENOIA/Samples/Sample4.wav"
    elseif(ksample = 5) then
        asigl, asigr diskin "/Users/ryanjeffares/Documents/JUVENOIA/Samples/Sample5.wav"
    elseif(ksample = 6) then
        asigl, asigr diskin "/Users/ryanjeffares/Documents/JUVENOIA/Samples/Sample6.wav"        
    endif
    
    arevl, arevr reverbsc asigl, asigr, 0.5, 10000
    outs arevl*0.9  , arevr*0.9
    
endin

instr start_notes

	if(gkcnt>11)	then

		gkcnt	=	0
	
	endif	

	krate	rspline	0,	5,	2,	100	;spline for time
	krate	scale	krate/4,	10,	0.3	;scaling spline
	ktrig	metro	(krate*.2)				;metronome modulated by spline

;	koct	random	-2,	2	;generates random octave - 0 is middle
	;koct	int	koct		;makes random number an integer
	koct	random	1,	4

	kpan	rspline	0,	1,	0.1,	2
					;pgs 264, 265

	kfreq	table	gkcnt,	5

	kfreq	=	cpspch(koct+kfreq)

	

	;---------------MULTIPLICATION---------------


	;kfreqmult	=	gkmultiply-kfreq
	;kfreq		=	kfreqmult
	;kfreq		=	gkmultiply
	;kfreq		round	kfreq

	;--------------------END---------------------
	

	if(gkcnt>=0)	then

		;printk2	kmidi,	10
		gkcnt	=	gkcnt+1
		schedkwhen	ktrig,	0,	0,	"sine",	0,	.5,	kfreq,	kpan

	endif

endin



instr sine

	idur	=	p3
	ifreq	=	p4
	;ifreq	=	440
	ipan	=	p5

	kenv	madsr	0.01,	idur*2,	.5,	4
	asig1	vco2	kenv,	ifreq*2,	12
	asig2	vco2	kenv,	ifreq*1.34,	12

	asig	=	asig1	*	asig2


	afilt	lpf18	asig,	4000*kenv,	.2,	.8

	afilt	atone	afilt,	100

	apanL,	apanR	pan2	afilt,	ipan

			outs	apanL*.1,	apanR*.1


	gaverbL	=	apanL
	gaverbR	=	apanR
endin

instr noise_start

	krate	rspline	0,	10,	0.2,	20
	ktrig	metro	krate/8

	kfilt	random	500,	4000

	kpan	random	0,	1

	kamp	rspline	0,	1,	1,	30

	kband	rspline	30,	200,	1,	30

	schedkwhennamed	ktrig,	0,	0,	"noisey",	0,	0.5,	kfilt,	kpan,	kamp,	kband

endin

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

	apanL,	apanR	pan2	asig,	ipan

		outs	apanL,	apanR

	gaverbL	=	apanL*2
	gaverbR	=	apanR*2
	
endin

instr chord_start

	kcnt	init	1
	
	krate	rspline	5,	26,	0.1,	47	;spline for time
	krate	scale	krate/12,	10,	0.3	;scaling spline
	ktrig	metro	krate				;metronome modulated by spline
	kpan	rspline	0,	1,	0.1,	2
	kamp	random	0,	1
	kpres	random	1,	5

	koct1	random	0,	2	;generates random octave - 0 is middle
	koct1	int	koct1		;makes random number an integer
	
	koct2	random	0,	2
	koct2	int	koct2

	koct3	random	0,	2
	koct3	int	koct3

	kmidi1	random	0,	11
	kmidi1	table	kmidi1,	5

	kmidi2	random	0,	11
	kmidi2	table	kmidi2,	5

	kmidi3	random	0,	11
	kmidi3	table	kmidi3,	5

	kpch1	=	pchmidinn(kmidi1)
	kpch2	=	pchmidinn(kmidi2)
	kpch3	=	pchmidinn(kmidi3)

	kfreq1	=	cpspch(koct1+kpch1)
	kfreq2	=	cpspch(koct2+kpch2)
	kfreq3	=	cpspch(koct3+kpch3)

	
	schedkwhennamed	ktrig,	0,	4,	"glass",	0,	10,	kfreq1,	kamp,	kpan,	kpres
	schedkwhennamed	ktrig,	0,	4,	"glass",	0,	10,	kfreq2,	kamp,	kpan,	kpres
	schedkwhennamed	ktrig,	0,	4,	"glass",	0,	10,	kfreq3,	kamp,	kpan,	kpres

endin

instr glass

	ifreq	=	p4
	iamp	=	p5
	idur	=	p3
	ipan	=	p6
	ipres	=	p7

	;kenv	madsr	0.01,	idur*2,	1,	2
	;kenv	xadsr	0.01,	0.2,	0.7,	2
	asig wgbowedbar iamp, ifreq, iamp, 6, 0.95
	asig	atone	asig,	70

	apanL,	apanR	pan2	asig,	ipan

		outs	apanL*20,	apanR*20		

	gaverbL	=	apanL
	gaverbR	=	apanR
	;delayw	asig

endin


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