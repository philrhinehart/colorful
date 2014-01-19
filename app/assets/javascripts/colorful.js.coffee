$(document).ready ->
	page = [$(window).width(), $(window).height()]
	$('.container').mousemove (event) ->
		cords=[event.pageX,event.pageY]
		cordp=scale_cords cords,page
		hex = tohex cordp
		print_hex hex
		paint_bg hex

print_cords = (cords) ->
	$('span.x').html(cords[0])
	$('span.y').html(cords[1])

print_hex = (hex) ->
	$('.hex').html(hex)

scale_cords = (cords, page) ->
		xp = cords[0]/page[0]
		yp = cords[1]/page[1]
		[xp,yp]

paint_bg = (color) ->
	$('.container').css('background-color', color)

tohex = (cordp) ->
	xp=cordp[0]
	yp=cordp[1]
	hex=""
	xz = Math.floor(xp*6)
	xzp = (xp*6)-xz
	switch xz
		when 0
			r=255
			g=Math.round xzp*255
			b=0
		when 1
			r=Math.round 255*(1-xzp)
			g=255
			b=0
		when 2
			r=0
			g=255
			b=Math.round xzp*255
		when 3
			r=0
			g=Math.round 255*(1-xzp)
			b=255
		when 4
			r=Math.round xzp*255
			g=0
			b=255
		when 5
			r=255
			g=0
			b=Math.round 255*(1-xzp)
		else
			console.log "X Zone not in range"
	rgb_to_hex [r,g,b]
	
rgb_to_hex = (rgb) ->
	hex=""
	hex+= ('0' + i.toString(16)).slice(-2) for i in rgb
	"#".concat(hex)

#Input total
per_to_hex = (per, mult, dig) ->
	pad = Array(dig).join '0'
	(pad+Math.round(per*mult).toString(16)).slice(-1*dig)
