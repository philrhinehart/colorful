$(document).ready ->
	page = [$(window).width(), $(window).height()]
	$(window).scrollTop(page[1])
	$(window).resize (event) ->
		#Adjust on page resize
		page = [$(window).width(), $(window).height()]
	
	$('.container').mousemove (event) ->
		update_color(event.pageX, event.pageY, $(window).scrollTop(), page)

	$('.container').click (event) ->
		#Save to Clipboard? Sent to bar at bottom/top.
		$('.bar').show()
		add_color( $('.hex').html() )
		adjust_saved()
	
	$(window).scroll (event) ->
		update_color(event.pageX, event.pageY, $(window).scrollTop(), page)
		
update_color = (x, y, scroll, page) ->
	cords=[x,y]
	cordp=scale_cords cords, page
	hex = tohex cordp, scroll
	print_hex hex
	paint_bg hex
	paint_text_bg rgb_to_hex flip_color hex_str_to_rgb hex
	paint_text hex


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

paint_text_bg = (color) ->
	$('.hex').css('background-color', color)
	$('.sub').html(color)
	$('.sub').css('color', color)

paint_text = (color) ->
	$('.hex').css('color', color)

tohex = (cordp) ->
	xp=cordp[0] # x % from left side of page
	yp=cordp[1] # y % from top of page
	xzone = Math.floor(xp*6) # Zone 0-5 from left to right
	xzp = (xp*6)-xzone # x % from left side of zone
	
	
	if yp<=0.5 #Top Half 
		ypt=2*yp	# y % from top (for top half)
		a=Math.round(255*ypt) 		# (0,255)
		bu=Math.round(a*xzp)			# (0,base)
		bd=Math.round(a*(1-xzp))	# (base,0)
		c=0						# (0)
	
	else # Bottom Half
		ypb=(2*yp)-1 # y % from top (for bot. half)
		a=255					# (255)
		c=Math.round(255*ypb)			# (0,255)
		# BaseUp(ypd) -> 255
		bu=Math.round((255-c)*(xzp)) + c	# (c->255)
		# 255 -> BaseDown(ypd)
		bd=Math.round(255-((255-c)*xzp))
	
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
	hex=""
	hex+= ('0' + i.toString(16)).slice(-2) for i in rgb
	"#".concat(hex)

#Input total
per_to_hex = (per, mult, dig) ->
	pad = Array(dig).join '0'
	(pad+Math.round(per*mult).toString(16)).slice(-1*dig)

flip_color = (color) ->
	for i in color
		255-i

hex_str_to_rgb = (hex) ->
	r=parseInt(hex[1..2],16)
	g=parseInt(hex[3..4],16)
	b=parseInt(hex[5..6],16)
	[r,g,b]

add_color = (color) ->

adjust_saved = () ->
	count = $('.saved').length
	height = $(window).height/count
	$('.saved').css('height',height)

unsaturated = (cordp) ->
	cordp[1]*255
