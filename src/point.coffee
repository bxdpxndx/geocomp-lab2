class Point

  constructor: (x, y, color = black) ->
    @x = x
    @y = y
    @color = color

  add: (other) ->
    return new Point(@x + other.x, @y + other.y)

  sub: (other) -> 
    return new Point(@x - other.x, @y - other.y)

  dot: (other) -> 
    return new Point(@x * other.x, @y * other.y)

  mult: (other) -> 
    return new Point(@x * other, @y * other)

  norm: ->
    return Math.sqrt(@x*@x + @y*@y) 


  draw: (ctx) ->
    sz = 2
    ctx.beginPath()
    ctx.moveTo(@x-sz, @y-sz)
    ctx.lineTo(@x+sz, @y+sz)
    ctx.moveTo(@x+sz, @y-sz)
    ctx.lineTo(@x-sz, @y+sz)
    ctx.strokeStyle = @color.asHex()
    ctx.stroke()
  