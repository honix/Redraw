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

pallete-buffer: make image! 150x150
draw pallete-buffer [
	pen off
	fill-pen linear red orange yellow green aqua blue purple
	box 0x0 150x150 
	fill-pen linear white transparent black 0x0 0x150
	box 0x0 150x150
]

pen-buffer-settings: reduce [500x500 transparent]
pen-buffer: make image! pen-buffer-settings
buffer:	 make image! [500x500 100.100.100]
line-array: []

tool: context [
	type: 'pen						 ; only pen for now
	color: 50.0.50.100
	size: 25
]

update-preview: does [
	preview/draw: replaces copy [
		pen        a1
		fill-pen   off 
		line-join  round
		line-cap   round
		line-width a2 
		spline 30x30 50x20 100x40 120x30
	] [a1 (tool/color) a2 (tool/size)]
	
	show preview
	print tool/color
]

canvas: layout [
	title "Redraw"

	at 10x10 
	ib: image buffer

		on-down [append line-array event/offset]

		on-alt-down [
			tool/color: pick buffer event/offset
			update-preview
		]

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
					update-preview
				]
			]
		]

	pb: image pen-buffer

	below center
	preview: base 150x60
	pallete: image pallete-buffer 
		
		on-down [
			tool/color: pick pallete-buffer event/offset
			update-preview
		]


		all-over
		on-over [switch first event/flags [
				down [
					tool/color: pick pallete-buffer event/offset
					update-preview
				]
			]
		]

	style label: text 60x14 center 
	style c-slider: slider all-over on-over [
		if find event/flags 'down [update-preview]
	]

	label "ALPHA"
	c-slider data 0.2
		react [tool/color/4: to-integer face/data * 255]

	base 120x1

	label "SIZE"
	c-slider data 0.2 react [tool/size: to-integer face/data * 100]

	button "HELP" [view help]

	do [update-preview]
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

view canvas

