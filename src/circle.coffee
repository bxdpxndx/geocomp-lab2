class Circle
  constructor: (c, r, color=blue) ->
    @c = c
    @r = r
    @color = color

  contains: (point) ->
  	@r*@r > (@c.x - point.x)*(@c.x - point.x) + (@c.y - point.y) * (@c.y - point.y)

  #intersecs: (circle) ->
    # still missing!

  draw: (ctx) ->
    ctx.beginPath()
    ctx.arc(@c.x,@c.y,@r,0,2*Math.PI)
    ctx.strokeStyle = @color.asHex()
    ctx.stroke()
