Red [
	Title: "Canvas for Redraw"
	Tabs: 4
]

redraw: does [
	draw main-buffer [               ; this technique allows us do a layers
		image back-pattern
		image buffer
		image pen-buffer
	]
	show canvas-buffer
]

new-session: does [
	comment [Here we need to recreate canvas layout for new size]
	canvas: layout [
		title "Redraw"
	
		canvas-buffer: image main-buffer

			on-down [
				tool/old-pos: event/offset
				compose bind tool/current-brush/drag 'event
			]
	
			on-alt-down [pick-color buffer event/offset]
	
			on-up [
				clear tool/line-array
				draw buffer [image pen-buffer]
				pen-buffer/argb: transparent
				redraw
			]
	
			all-over
			on-over [
				switch first event/flags [
					down [
						unless find event/flags 'shift [
							do compose bind tool/current-brush/drag 'event
						]

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
	redraw
	tool-window: view/options/no-wait tool-bar [offset: canvas-window/offset - 200x0]
	view/options tool-brushes [offset: tool-window/offset - 150x0]
]

