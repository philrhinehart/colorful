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
	xzone = Math.floor(xp*6)
	xzp = (xp*6)-xzone
	
	if yp<=0.5
		# Top Half
		ypt=2*yp
		a=Math.round(255*ypt) 		# (0,255)
		bu=Math.round(a*xzp)			# (0,base)
		bd=Math.round(a*(1-xzp))	# (base,0)
		c=0						# (0)
	else
		# Bottom Half
		ypb=(2*yp)-1
		a=255					# (255)
		c=Math.round(255*ypb)			# (0,255)
		# BaseUp(ypd) -> 255
		bu=Math.round((255-c)*(xzp)) + c	# (c->255)
		# 255 -> BaseDown(ypd)
		based=Math.round(255*(1-ypb))
		bd=Math.round((255-based)*xzp+based) # (255->c)
	
	switch xzone
		when 0
			rgb_to_hex [a,bu,c]
		when 1
			rgb_to_hex [bd,a,c]
		when 2
			rgb_to_hex [c,a,bu]
		when 3
			rgb_to_hex [c,bd,a]
		when 4
			rgb_to_hex [bu,c,a]
		when 5
			rgb_to_hex [a,c,bd]
		else
			console.log "X Zone not in range"
	
rgb_to_hex = (rgb) ->
	console.log "("+rgb[0]+","+rgb[1]+","+rgb[2]+")"
	hex=""
	hex+= ('0' + i.toString(16)).slice(-2) for i in rgb
	"#".concat(hex)

#Input total
per_to_hex = (per, mult, dig) ->
	pad = Array(dig).join '0'
	(pad+Math.round(per*mult).toString(16)).slice(-1*dig)
