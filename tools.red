Red [
	Title: "Tools for Redraw"
	Tabs: 4
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
	preview-buffer/argb: 200.200.200
	foreach point preview-path [
		event: compose [offset: (point)]
		do compose bind tool/current-brush/drag 'event
		if do tool/current-brush/clear [preview-buffer/argb: 200.200.200]
		draw preview-buffer compose bind tool/current-brush/draw 'tool
	]
	unset 'event
	clear tool/line-array

	preview/image: preview-buffer
	show preview
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

	preview: image preview-buffer on-created [update-preview]

	c-slider data 0.2 react [tool/color/4: to-integer face/data * 255]
	label "Alpha"

	c-slider data 0.2 react [tool/size: to-integer face/data * 100]
	label "Size"
]

tool-brushes: layout [
	title "Brushes"

	below center

	style label: text 60x14 center

	label "Brushes"
	text-list data keys-of tool/brushes on-change [
		tool/set-brush pick face/data face/selected
		update-preview
	]

	button "Reload brushes" [tool/reload-brushes]
]

