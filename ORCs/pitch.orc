;					Rhys Mayes - 2019

gkpchcps init 0 ;Global pitch cps

instr 1 ;pitch tracking

	ifftsize = 2048 ;essentially buffer size
	iwtype = 1
	
	a1 inch 1 ;input from mic
	
	fsig pvsanal a1, ifftsize, ifftsize/4, ifftsize, iwtype ;pvs analysis of input
	kfreq, kamp pvspitch fsig, 0.01 ;outputs pitch and amplitude to seperate variables
	
		gkpchcps = kfreq
	
endin

