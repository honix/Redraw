Red [
	Title: "Misc layouts for Redraw"
	Tabs: 4
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

