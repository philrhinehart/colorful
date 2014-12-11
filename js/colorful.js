// Generated by CoffeeScript 1.8.0
(function() {
  var addColor, barWidth, currentColor, flipHex, flipRGB, paintBG, paintText, paintTextBG, scrollPer, toHex, toRGB, updateScreen, updateText, xPer, yPer, yp;

  barWidth = 20;

  yp = 0;

  $(document).ready(function() {
    $(document).scrollTop($(window).height());
    $(window).resize(function(event) {});
    $('#canvas').mousemove(function(e) {
      return updateScreen(e);
    });
    $(window).scroll(function(event) {});
    return $('#canvas').click(function(event) {
      var barWidthP, cWidth, numX;
      if (!($('#bar:visible') > 0)) {
        barWidthP = barWidth + "%";
        cWidth = (100 - barWidth) + "%";
        numX = (100 + barWidth) / 2 + "%";
        $('#bar:hidden').show();
        $('#bar').animate({
          width: barWidthP
        });
        $('#canvas.full').animate({
          left: barWidthP,
          width: cWidth
        }, 'slow');
        $('.color').animate({
          left: numX
        }, 'slow');
      }
      return addColor();
    });
  });

  scrollPer = function() {
    return Math.round($(document).scrollTop() / ($(document).height() - $(window).height()) * 100);
  };

  xPer = function(e) {
    return Math.round((e.pageX - $('#bar').width()) / $('#canvas').width() * 360);
  };

  yPer = function(e) {
    return Math.round((e.pageY - $(window).scrollTop()) / $('#canvas').height() * 100);
  };

  currentColor = function() {
    var RGBraw, rgb;
    RGBraw = $('#canvas').css("background-color");
    rgb = RGBraw.split("(");
    rgb = rgb[1].split(")");
    rgb = rgb[0].split(",");
    return toHex(rgb);
  };

  updateScreen = function(e) {
    var hex, hexFlip;
    paintBG(xPer(e), scrollPer(), yPer(e));
    hex = currentColor();
    hexFlip = flipHex(hex);
    paintText(hex);
    updateText(hex, hexFlip);
    return paintTextBG(hexFlip);
  };

  updateText = function(original, invert) {
    $('.hex').html(original);
    return $('.sub').html(invert);
  };

  paintBG = function(h, s, l) {
    return $('#canvas').css("background-color", "hsl(" + h + "," + s + "%," + l + "%)");
  };

  paintTextBG = function(color) {
    $('.hex').css('background-color', color);
    $('.sub').html(color);
    return $('.sub').css('color', color);
  };

  paintText = function(color) {
    return $('.hex').css('color', color);
  };

  toHex = function(rgb) {
    var hex, i, _i, _len;
    hex = "";
    for (_i = 0, _len = rgb.length; _i < _len; _i++) {
      i = rgb[_i];
      hex += ('0' + parseInt(i).toString(16)).slice(-2);
    }
    return "#".concat(hex);
  };

  toRGB = function(hex) {
    var b, g, r;
    r = parseInt("0x" + hex.slice(1, 3), 16);
    g = parseInt("0x" + hex.slice(3, 5), 16);
    b = parseInt("0x" + hex.slice(5, 7), 16);
    return [r, g, b];
  };

  flipRGB = function(rgb) {
    var i, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = rgb.length; _i < _len; _i++) {
      i = rgb[_i];
      _results.push(255 - i);
    }
    return _results;
  };

  flipHex = function(hex) {
    return toHex(flipRGB(toRGB(hex)));
  };

  addColor = function() {
    var color, colors, flipped, maxColors, newhtml;
    color = currentColor();
    flipped = flipHex(color);
    newhtml = '<div style="background-color:' + color + '" class="saved"><div style="background-color:' + flipped + '; color: ' + color + '" class="savedhex">' + color + '</div><div class="althex" style="color: ' + flipped + '">' + flipped + '</div></div>';
    $('#bar').append(newhtml);
    colors = $('.saved').length;
    maxColors = 5;
    if (colors <= maxColors) {
      return $('.saved').animate({
        height: 100 / colors + '%'
      }, 'slow');
    } else {
      $('#bar').scrollTop(1000000000);
      return $('.saved').css({
        height: 100 / maxColors + '%'
      });
    }
  };

}).call(this);
