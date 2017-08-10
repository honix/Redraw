context [
	drag: [
		append line-array (event/offset)
	]
	draw: [
		pen	       (tool/color)
		fill-pen   off
		line-join  round
		line-cap   round
		line-width (tool/size) 
		spline     (line-array) (event/offset)
	]
	clear: yes
]

