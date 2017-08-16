context [
	drag: [
		append tool/line-array event/offset
	]
	draw: [
		pen	       off
		fill-pen   (tool/color)
		line-join  round
		line-cap   round
		line-width (tool/size) 
		spline     (tool/line-array) (event/offset)
	]
	clear: yes
]

