context [
	blk: none

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
			foreach point line-array [append blk compose [line (point) (event/offset)]]
			blk
		)
	]
	clear: no
]

