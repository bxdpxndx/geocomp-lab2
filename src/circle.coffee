class Circle
  # Small utility class.
  constructor: (@c, @r, @color=blue) ->


  contains: (point) ->
  	@r*@r < (@c.x - point.x)*(@c.x - point.x) + (@c.y - point.y) * (@c.y - point.y)

  draw: (ctx, hl = false) ->

    ctx.beginPath()
    ctx.arc(@c.x,@c.y,@r,0,2*Math.PI)
    ctx.strokeStyle = @color.asHex()
    ctx.stroke()
