Drawing app
Work in progress!

Red [
	Needs: 'View
	Tabs:  4
]

system/view/auto-sync?: no


tool: context [
	color: 50.0.50.100
	saturation: 255
	size: 25

	brushes: #()
	current-brush: none
]

reload-brushes: does [
	foreach brush read %brushes/ [
		if parse brush [to [dot "red"] remove to end] [
			put tool/brushes
				to-string brush
				do read rejoin [%brushes/ brush ".red"]
		]
	]
]

reload-brushes

set-brush: func [name] [
	tool/current-brush: select tool/brushes name
]

set-brush "normal"

line-array: []

preview: none                        ; for successful compilation
pallete: none
canvas-buffer: none

initiate: func [size] [
	buffer:     make image! reduce [size 100.100.100]

	pen-buffer: make image! reduce [size transparent]

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

	pallete-buffer: make image! 150x150

	main-buffer: make image! size
]

initiate 512x512

redraw: does [
	draw main-buffer [               ; this technique allows us do a layers
		image back-pattern
		image buffer
		image pen-buffer
	]
	show canvas-buffer
]

update-pallete: does [
	comment [Recode it when 0.6.4 out]
	draw pallete-buffer compose [
		pen off
		fill-pen linear red orange yellow green cyan blue magenta red
		box 0x0 150x150 
	]
	draw pallete-buffer compose [
		pen off
		fill-pen (gray + make tuple! reduce [0 0 0 tool/saturation])
		box 0x0 150x150
	]
	draw pallete-buffer compose [
		pen off
		fill-pen linear white transparent black 0x0 0x150
		box 0x0 150x150
	]
	pallete/image: pallete-buffer
	show pallete
]

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

pick-color: func [buffer offset] [
	alpha: tool/color/4
	tool/color: pick buffer offset
	tool/color/4: alpha
	update-preview
]

tool-bar: layout [
	title "Tool-bar"

	below center
	pallete: image pallete-buffer on-created [update-pallete]
		
		on-down [pick-color pallete-buffer event/offset]

		all-over
		on-over [switch first event/flags [
				down [pick-color pallete-buffer event/offset]
			]
		]

	style label: text 60x14 center
	style c-slider: slider all-over on-over [
		if find event/flags 'down [update-preview]
	]

	slider data 1.0 all-over on-over [update-pallete] react [
		tool/saturation: to-integer face/data * 255
	]
	label "Saturation"

	base 150x1

	preview: base 150x60 on-created [update-preview]

	c-slider data 0.2 react [tool/color/4: to-integer face/data * 255]
	label "Alpha"

	c-slider data 0.2 react [tool/size: to-integer face/data * 100]
	label "Size"

	base 150x1
	
	label "Brushes"
	text-list data keys-of tool/brushes on-change [set-brush pick face/data face/selected]

	button "Reload brushes" [reload-brushes]
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

new-session: does [
	comment [Here we need to recreate canvas layout for new size]
	canvas: layout [
		title "Redraw"
	
		canvas-buffer: image main-buffer

			on-down [compose bind tool/current-brush/drag 'event]
	
			on-alt-down [pick-color buffer event/offset]
	
			on-up [
				clear line-array
				draw buffer [image pen-buffer]
				pen-buffer/argb: transparent
				redraw
			]
	
			all-over
			on-over [
				switch first event/flags [
					down [
						unless find event/flags 'shift [do compose bind tool/current-brush/drag 'event]

						if do tool/current-brush/clear [pen-buffer/argb: transparent]
						draw pen-buffer compose bind tool/current-brush/draw 'event
						redraw
					]
					alt-down [pick-color buffer event/offset]
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

		on-key: func [face [object!] event [event!]] [
			switch event/key [
				#"q" [unview/all]
			]
		]
	]

	canvas-window: view/no-wait canvas
	view/options tool-bar [offset: canvas-window/offset - 200x0]
	redraw
]

new-session

; system/view/auto-sync?: yes

