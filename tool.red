Red [
	Title: "Tool for Redraw"
	Tabs: 4
]

tool: context [
	color: 50.0.50.100
	saturation: 255
	size: 25

	old-pos: 0x0
	line-array: []

	brushes: #()
	current-brush: none
	
	reload-brushes: does [
		foreach brush read %brushes/ [
			if parse brush [to [dot "red"] remove to end] [
				put tool/brushes
					to-string brush
					do read rejoin [%brushes/ brush ".red"]
			]
		]
	]

	set-brush: func [name] [
		tool/current-brush: select tool/brushes name
	]
]

tool/reload-brushes

tool/set-brush "normal"

