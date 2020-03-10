
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

