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
	hex=""
	hex+=('00'+Math.round(i*4095).toString(16)).slice(-3) for i in cordp
	"#".concat(hex)
