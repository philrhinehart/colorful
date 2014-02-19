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
		addColor()

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
	hex = currentColor()
	hexFlip = flipHex hex
	paintText hex
	updateText hex, hexFlip
	paintTextBG hexFlip

updateText = (original,invert) ->
	$('.hex').html(original)
	$('.sub').html(invert)

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
	r=parseInt("0x"+hex[1..2],16)
	g=parseInt("0x"+hex[3..4],16)
	b=parseInt("0x"+hex[5..6],16)
	[r,g,b]

flipRGB = (rgb) ->
	for i in rgb
		255-i

flipHex = (hex) ->
	toHex flipRGB toRGB hex

addColor = () ->
	color = currentColor()
	flipped = flipHex(color)
	newhtml = '<div style="background-color:'+color+'" class="saved"><div style="background-color:'+flipped+'; color: '+color+'" class="savedhex">'+color+'</div></div>'
	# Insert ajax call to controller to add the above code via helper
	$('#bar').append(newhtml)

	colors=$('.saved').length
	# Adjust height of saved blocks
	maxColors=5
	if colors <= maxColors
		$('.saved').animate({height: 100/colors+'%'}, 'slow')
	else
		$('#bar').scrollTop(1000000000)
		$('.saved').css({height: 100/maxColors+'%'})
