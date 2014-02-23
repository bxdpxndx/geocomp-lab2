class Triangle

  constructor: (p0, p1, p2, color=green) ->
    @vertexs = [p0, p1, p2]
    @nbs     = [null,null,null]
    @color   = color
    


  getCircle: ->
    center = new Point(0,0)
    [p0, p1, p2] = @vertexs
    yDelta_p0 = p1.y - p0.y
    xDelta_p0 = p1.x - p0.x
    yDelta_p1 = p2.y - p1.y
    xDelta_p1 = p2.x - p1.x

    #if xDelta_p0 is 0 

    #if xDelta_p1 is 0

    p0Slope  = yDelta_p0/xDelta_p0
    p1Slope  = yDelta_p1/xDelta_p1  
    center.x = (p0Slope*p1Slope*(p0.y - p2.y) + p1Slope*(p0.x + p1.x) - p0Slope*(p1.x+p2.x) )/(2*(p1Slope-p0Slope) )
    center.y = -1*(center.x - (p0.x+p1.x)/2)/p0Slope + (p0.y+p1.y)/2

    r = center.sub p0
    r = r.norm()

    return new Circle(center, r)

  center: ->
    new Point(sum(v.x for v in @vertexs)/3,sum(v.y for v in @vertexs)/3)

  contains: (point)  ->
    [p0, p1, p2] = @vertexs
    v0           = p2.sub p0
    v1           = p1.sub p0
    v2           = point.sub p0

    dot00 = v0.dot(v0)
    dot01 = v0.dot(v1)
    dot02 = v0.dot(v2)
    dot11 = v1.dot(v1)
    dot12 = v1.dot(v2)

    invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
    u = (dot11 * dot02 - dot01 * dot12) * invDenom
    v = (dot00 * dot12 - dot01 * dot02) * invDenom

    return (u >= 0) && (v >= 0) && (u + v < 1)

  draw: (ctx, hl = false) ->
    [p0, p1, p2] = @vertexs
    ctx.beginPath()
    ctx.moveTo(p0.x, p0.y)
    ctx.lineTo(p1.x, p1.y)
    ctx.lineTo(p2.x, p2.y)
    ctx.lineTo(p0.x, p0.y)
    ctx.strokeStyle = @color.asHex()
    ctx.stroke()

