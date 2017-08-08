context [
	drag: [
		append line-array 
		(event/offset + as-pair (random 50)- 25 (random 50) - 25)
	]
	draw: [
		pen	       (tool/color)
		fill-pen   off
		line-join  round
		line-cap   round
		line-width (tool/size) 
		line       (line-array) (event/offset)
	]
]

