class Color
  r: null
  g: null
  b: null

  constructor: (r, g, b) ->
    @r = r
    @g = g
    @b = b

  asHex: ->
    '#' + 
    ("0" + @r.toString(16)).slice(-2) +
    ("0" + @g.toString(16)).slice(-2) +
    ("0" + @b.toString(16)).slice(-2)

black = new Color(0, 0, 0)
gray  = new Color(128, 128, 128)
white = new Color(255, 255, 255)
red   = new Color(255, 0, 0)
blue  = new Color(0,0,255)
green = new Color(0, 255, 0)
