context [
	blk: none
	dist: none

	drag: [
		line-array: copy []
		append tool/line-array event/offset
	]
	draw: [
		pen	       (tool/color)
		fill-pen   off
		line-join  round
		line-cap   round
		line-width (tool/size) 
		(
			dist: sqrt add power (event/offset/x - tool/old-pos/x) 2 
						   power (event/offset/y - tool/old-pos/y) 2 
			either dist > (tool/size * 2) [
				tool/old-pos: event/offset
				compose [
					arc (event/offset) 
						(as-pair tool/size tool/size) 
						0 360
				]
			] []
		)
	]
	clear: no
]

