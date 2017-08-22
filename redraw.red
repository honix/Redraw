Red [
	Title: "Redraw -- Painting app in Red language"
	Needs: 'View
	Tabs: 4
]

system/view/auto-sync?: no

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
	preview-buffer: make image! 150x150

	main-buffer: make image! size
]

initiate 512x512

#include %utils.red
#include %tool.red
#include %tools.red
#include %misc.red
#include %canvas.red

new-session

system/view/auto-sync?: yes

