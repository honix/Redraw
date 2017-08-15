Red [
	Tabs: 4
	About: {Utils for Redraw}
]

let: func [
	binds 
	block 
	/local 
		ctx
][
	ctx: context append append binds copy [result: do] reduce [block]
	; print mold ctx
	select ctx 'result
]

vec-mul: func [point m] [as-pair point/x * m point/y * m]

bezier: func [points t] [
	switch length? points [ 
		2 [add first points (vec-mul (subtract second points first points) t)]
		3 [
			bezier reduce [
				bezier reduce [first points second points] t
				bezier reduce [second points third points] t
			] t
		]
		4 [
			bezier reduce [
				bezier reduce [
					bezier reduce [first points second points] t
					bezier reduce [second points third points] t
				] t
				bezier reduce [
					bezier reduce [second points third points] t
					bezier reduce [third points fourth points] t
				] t
			] t
		]
	]
]

preview-path: let [
	points: [30x75 50x-50 100x200 120x75]
	blk: copy []
	t: 0.0
][ 	
	until [
		append blk bezier points t
		t: t + 0.07
		t > 1.01
	]
	blk
]

