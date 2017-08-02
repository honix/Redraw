Drawing app
Work in progress!

Red [
	Needs: 'View
]

replaces: func [block reps] [
	until [
		block: replace/all block first reps do first reps: next reps
		empty? reps: next reps
	]
	block
]

system/view/auto-sync?: no

pen-buffer-settings: reduce [500x500 transparent]
pen-buffer: make image! pen-buffer-settings
buffer:	 make image! [500x500 100.100.100]
line-array: []

tool: context [
	type: 'pen						 ; only pen for now
	color: 50.0.50.100
	size: 25
]

canvas: layout [
	title "Redraw"

	at 10x10 
	ib: image buffer

		on-down [append line-array event/offset]

		on-up [
			line-array: copy []
			draw buffer [image pen-buffer]
			pen-buffer/argb: transparent
			show [ib pb]
		]
	
		all-over
		on-over [switch first event/flags [
				down [
					append line-array event/offset
					pen-buffer/argb: transparent
					draw pen-buffer replaces copy [
						pen	       a1
						fill-pen   off
						line-join  round
						line-cap   round
						line-width a2 
						line	   a3
					] [a1 (tool/color) a2 (tool/size) a3 (line-array)]
					show pb
				]
				alt-down [
					tool/color: pick buffer event/offset
					update-pallet
				]
			]
		]

	pb: image pen-buffer

	below center
	pallet: base 150x60 

	style label: text 60x12 center 
	style c-slider: slider all-over on-over [
		if find event/flags 'down [update-pallet]
	]

	label "RED" red
	c-slider data 0.4
		react [tool/color/1: to-integer face/data * 255]
	label "GREEN" green
	c-slider data 0.2
		react [tool/color/2: to-integer face/data * 255]
	label "BLUE" blue
	c-slider data 0.2
		react [tool/color/3: to-integer face/data * 255]
	label "ALPHA" gray
	c-slider data 0.2
		react [tool/color/4: to-integer face/data * 255]

	base 120x1

	label "SIZE" gray
	c-slider data 0.2 react [tool/size: to-integer face/data * 100]

	button "HELP" [view help]

	do [update-pallet]
]

help: layout [
	title "Help"
	below center
	panel 200.200.200 [
		text "Draw with current tool"    text "left mouse button" bold return
		text "Pick a color under cursor" text "right mouse button" bold
	]

	button "Close" [unview self]
]


update-pallet: does [
	pallet/draw: replaces copy [
		pen	       a1
		fill-pen   off 
		line-join  round
		line-cap   round
		line-width a2 
		spline 30x30 50x20 100x40 120x30
	] [a1 (tool/color) a2 (tool/size)]
	
	show pallet
	print tool/color
]

view canvas

