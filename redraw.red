Drawing app
Work in progress!

Red [
	Needs: 'View
	Tabs:  4
]

system/view/auto-sync?: no


tool: context [
	type: 'pen						 ; only pen for now
	color: 50.0.50.100
	size: 25
]

line-array: []

initiate: func [size] [
	buffer:     make image! reduce [size 100.100.100]
	pen-buffer: make image! reduce [size transparent]
	pallete-buffer: make image! 150x150
	draw pallete-buffer [
		pen off
		fill-pen linear red orange yellow green cyan blue magenta red
		box 0x0 150x150 
		fill-pen linear white transparent black 0x0 0x150
		box 0x0 150x150
	]
	back-pattern: make image! reduce [size 160.160.160]
	draw back-pattern compose [
		pen off
		fill-pen pattern 20x20 [
			pen off
			fill-pen 200.200.200 
			box 0x0   10x10
			box 10x10 20x20
		]
		box 0x0 (size)
	]
	main-buffer: make image! size
]

redraw: does [
	draw main-buffer [
		image back-pattern
		image buffer
		image pen-buffer
	]
]

initiate 512x512

update-preview: does [
	preview/draw: compose [
		pen        (tool/color)
		fill-pen   off 
		line-join  round
		line-cap   round
		line-width (tool/size) 
		spline 30x30 50x20 100x40 120x30
	]
	
	show preview
]

tool-bar: layout [
	title "Tool-bar"

	below center
	preview: base 150x60 on-created [update-preview]
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
]

help: layout [
	title "Help"

	below center
	panel 200.200.200 [
		text "Draw with current tool"
		text "left mouse button" bold return
		
		text "Draw a straight line"
		text "hold shift and left mouse button" bold return
		
		text "Pick a color under cursor"
		text "right mouse button" bold
	]

	button "Close" [unview self]
]

new-file: layout [
	title "New file"
	
	text "New file size:"
	f: field "512x512" return
	button "Create" [
		either pair? do f/data [
			unview/all
			initiate do f/data
			new-session
		] [
			f/text: "512x512"
			show f
		]
	]
	button "Cancel" [unview]
]

pick-color: func [offset][
	tool/color: pick buffer offset
	update-preview
]

new-session: does [
	comment [Here we need to recreate canvas layout for new size]
	canvas: layout [
		title "Redraw"
	
		canvas-buffer: image main-buffer

		on-create [redraw]
				
		on-down [append line-array event/offset]
	
		on-alt-down [pick-color event/offset]
	
		on-up [
			line-array: copy []
			draw buffer [image pen-buffer]
			pen-buffer/argb: transparent
			redraw
			show face 
		]
	
		all-over
		on-over [switch first event/flags [
				down [
					unless find event/flags 'shift [
						append line-array event/offset
					]
					pen-buffer/argb: transparent
					draw pen-buffer compose [
						pen	       (tool/color)
						fill-pen   off
						line-join  round
						line-cap   round
						line-width (tool/size) 
						spline     (line-array) (event/offset)
					]
					redraw
					show face
				]
				alt-down [pick-color event/offset]
			]
		]
	
	]

	canvas/menu: [
		"File"
		["New" new "* Save" save "* Load" load "Quit" quit]
		"Image"
		["Fill with color" fill]
		"Help"
		["Usage" usage "* About" about]
	]
	
	canvas/actors: context [
		on-menu: func [face [object!] event [event!]] [
			switch event/picked [
				new  [view new-file]
				save [print "Save not implemented yet!"]
				load [print "Load not implemented yet!"]
				quit [unview/all]

				fill [buffer/argb: tool/color redraw show canvas-buffer]
				usage [view help]
				about [print "About not implemented yet!"]
			]
		]
	]

	canvas-window: view/no-wait canvas
	view/options tool-bar [offset: canvas-window/offset - 200x0]
]

new-session

system/view/auto-sync?: yes

