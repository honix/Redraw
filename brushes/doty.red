context [
	blk: none
	dist: none
	old-pos: none

	drag: [
		line-array: copy []
		append line-array event/offset
	]
	draw: [
		pen	       (tool/color)
		fill-pen   off
		line-join  round
		line-cap   round
		line-width (tool/size) 
		(
			unless old-pos [old-pos: event/offset]
			dist: sqrt add power (event/offset/x - old-pos/x) 2 
						   power (event/offset/y - old-pos/y) 2 
			either dist > (tool/size * 2) [
				old-pos: event/offset
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

