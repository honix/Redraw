context [
	blk: none
	dist: none

	drag: [
		append line-array event/offset
	]
	draw: [
		pen	       (tool/color)
		fill-pen   off
		line-join  round
		line-cap   round
		line-width (tool/size) 
		(
			blk: copy []
			foreach point line-array [
				dist: sqrt add power (event/offset/x - point/x) 2 
							   power (event/offset/y - point/y) 2 
				append blk compose [arc (event/offset) (as-pair dist dist) 0 360]
			]
			blk
		)
	]
	clear: no
]

