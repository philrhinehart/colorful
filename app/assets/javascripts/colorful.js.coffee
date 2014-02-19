#Set the width for the left bar
barWidth = 20
yp = 0

$(document).ready ->
	$(document).scrollTop($(window).height())
	$(window).resize (event) ->

	$('#canvas').mousemove (e) ->
		updateScreen(e)
		#$('#canvas').css("background-color", "hsl("+xPer(e)+","+scrollPer()+"%,"+yPer(e)+"%)")

	$(window).scroll (event) ->

	$('#canvas').click (event) ->
		unless $('#bar:visible') > 0
			barWidthP = barWidth + "%"
			cWidth = (100-barWidth) + "%"
			numX = (100+barWidth)/2 + "%"
			$('#bar:hidden').show()
			$('#bar').animate({width: barWidthP})
			$('#canvas.full').animate({left: barWidthP, width: cWidth}, 'slow')
			$('.color').animate({left: numX}, 'slow')
	
scrollPer = () ->
	Math.round($(document).scrollTop()/($(document).height()-$(window).height())*100)

xPer = (e) ->
	Math.round((e.pageX-$('#bar').width())/$('#canvas').width()*360)

yPer = (e) ->
	Math.round((e.pageY-$(window).scrollTop())/$('#canvas').height()*100)


currentColor = () ->
#Pulls RGB color code from background. Converts to array and the to HEX string.
	RGBraw = $('#canvas').css("background-color")
	rgb = RGBraw.split("(")
	rgb = rgb[1].split(")")
	rgb = rgb[0].split(",")
	toHex rgb

updateScreen = (e) ->
	paintBG(xPer(e),scrollPer(),yPer(e))
	hex = currentColor
	paintText hex
	updateText hex
	$('#debug').text(hex)

updateText = (hex) ->
	$('.hex').html(hex)

paintBG = (h,s,l) ->
	$('#canvas').css("background-color", "hsl("+h+","+s+"%,"+l+"%)")

paintTextBG = (color) ->
	$('.hex').css('background-color', color)
	$('.sub').html(color)
	$('.sub').css('color', color)

paintText = (color) ->
	$('.hex').css('color', color)

toHex = (rgb) ->
	#rgb array to hex string
	hex=""
	hex+= ('0' + parseInt(i).toString(16)).slice(-2) for i in rgb
	"#".concat(hex)

toRGB = (hex) ->
	#hex string to rgb array
	r=parseInt(hex[1..2],16)
	g=parseInt(hex[3..4],16)
	b=parseInt(hex[5..6],16)
	[r,g,b]

color_str_to_rgb = (str) ->
	s=str.slice(1)
	[s[0..1],s[2..3],s[4..5]]

flipColor = (hex) ->
	rgb = hexToRGB(hex)
	for i in rgb
		255-i

add_color = (color) ->
	flipped = flip_color hex_str_to_rgb color
	# Insert new color html
	newhtml = '<div style="background-color:'+color+'" class="saved"><div style="background-color: rgb('+flipped+'); color: '+color+'" class="savedhex">'+color+'</div></div>'
	# Insert ajax call to controller to add the above code via helper
	$('#bar').append(newhtml)

	colors=$('.saved').length
	# Adjust height of saved blocks
	maxColors=5
	if colors <= maxColors
		$('.saved').animate({height: 100/colors+'%'}, 'slow')
	else
		$('#bar').scrollTop(1000000000)
		#$('#bar').animate({scrollTop: 1000000000, 'slow'})
		#$('.saved').animate({height: 100/maxColors+'%'}, 'slow')
		$('.saved').css({height: 100/maxColors+'%'})

adjust_saved = () ->
	count = $('.saved').length
	height = $(window).height/count
	$('.saved').css('height',height)

unsaturated = (cordp) ->
	cordp[1]*255

(cordp, scroll) ->
	unsaturated = unsaturated(cordp)
	saturated = to_hex(cordp)
