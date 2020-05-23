massign	66,	1
massign	67,	2
massign	68,	3
massign	69,	4

instr 66

	kstatus,	kchan,	kdata1,	kdata2	midiin
	gkbut1	=	kdata1

endin

instr 67

	kstatus,	kchan,	kdata1,	kdata2	midiin
	gkbut2	=	kdata1

endin

instr 68

	kstatus,	kchan,	kdata1,	kdata2	midiin
	gkpres	=	kdata1

endin

instr 69

	kstatus,	kchan,	kdata1,	kdata2	midiin
	gkpot	=	kdata1
endin

