#Set the width for the left bar
barWidth = 20
yp = 0

$(document).ready ->
	page = element_size $(window)
	doc = element_size $(document)
	$(window).scrollTop(doc[1])
	
	# ON WINDOW RESIZE
	$(window).resize (event) ->
		#Adjust on page resize
		page = element_size $(window)
		canvas = element_size $('#canvas')

	# ON MOUSE MOVE
	$('#canvas').mousemove (event) ->
		update_color(event.pageX, event.pageY, $(window).scrollTop(), page)

	# ON CLICK
	$('#canvas').click (event) ->
		unless $('#bar:visible') > 0
			barWidthP = barWidth + "%"
			cWidth = (100-barWidth) + "%"
			numX = (100+barWidth)/2 + "%"
			$('#bar:hidden').show()
			$('#bar').animate({width: barWidthP})
			$('#canvas.full').animate({left: barWidthP, width: cWidth}, 'slow')
			$('.color').animate({left: numX}, 'slow')
		add_color( $('.color .hex').html() )
	
	# ON SCROLL
	$(window).scroll (event) ->
		update_color(x, y, $(window).scrollTop(), page)


# Calls methods to calculate and print color based on mouse position
update_color = (x, y, scroll, page) ->
	
	cords=[x,y]
	
	# Converts mouse coordinates to percentage across canvas
	cordp=scale_cords cords, page
	
	# Converts percentage and scroll to hex color codes
	hex = tohex cordp, scroll

	# Print value and format screen/colors
	print_hex hex
	paint_bg hex
	paint_text_bg rgb_to_hex flip_color hex_str_to_rgb hex
	paint_text hex

# Prints valus of color to screen
print_hex = (hex) ->
	$('.hex').html(hex)

# Takes page size and mouse position. Returns array of percentage
scale_cords = (cords, page) ->
	if $('#bar:visible').length > 0
		bw = $('#bar').width()
		cw = $('#canvas').width()
		xp = (cords[0]-bw)/cw
	else
		xp = cords[0]/page[0]
	yp = cords[1]/page[1]
	[xp,yp]

element_size = (e) ->
	[e.width(), e.height()]

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

color_str_to_rgb = (str) ->
	s=str.slice(1)
	[s[0..1],s[2..3],s[4..5]]

flip_color = (color) ->
	for i in color
		255-i

hex_str_to_rgb = (hex) ->
	r=parseInt(hex[1..2],16)
	g=parseInt(hex[3..4],16)
	b=parseInt(hex[5..6],16)
	[r,g,b]

add_color = (color) ->
	flipped = flip_color hex_str_to_rgb color
	# Insert new color html
	newhtml = '<div style="background-color:'+color+'" class="saved"><div style="background-color: rgb('+flipped+'); color: '+color+'" class="savedhex">'+color+'</div></div>'
	# Insert ajax call to controller to add the above code via helper
	$('#bar').append(newhtml)

	colors=$('.saved').length
	# Adjust height of saved blocks
	if colors <= 5
		$('.saved').animate({height: 100/colors+'%'}, 'slow')
	else
		$('.saved').css({height: '20%'})
		$('#bar').scrollTop(1000000000)
		#$('#bar').animate({scrollTop: $(this).height()}, 'fast')

adjust_saved = () ->
	count = $('.saved').length
	height = $(window).height/count
	$('.saved').css('height',height)

unsaturated = (cordp) ->
	cordp[1]*255

(cordp, scroll) ->
	unsaturated = unsaturated(cordp)
	saturated = to_hex(cordp)
	
