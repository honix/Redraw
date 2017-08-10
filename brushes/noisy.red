context [
	drag: [
		line-array: copy []
		repeat i 5 [
			append line-array 
				(event/offset + as-pair (random 50) - 25 (random 50) - 25)
		]
	]
	draw: [
		pen	       (tool/color)
		fill-pen   off
		line-join  round
		line-cap   round
		line-width (tool/size) 
		line       (line-array) (event/offset)
	]
	clear: no
]

