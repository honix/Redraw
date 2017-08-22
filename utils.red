Red [
	Title: "Utils for Redraw"
	Tabs: 4
]

let: func [
	binds 
	block 
	/local 
		ctx
][
	ctx: context append/only append binds copy [result: do] block
	; probe ctx
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
	t: 0.0
][ 
	collect [
		until [
			keep bezier points t
			t: t + 0.07
			t > 1.01
		]
	]
]

pick-color: func [buffer offset] [
	alpha: tool/color/4
	tool/color: pick buffer offset
	tool/color/4: alpha
	update-preview
]

