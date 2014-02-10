class Triangle

  constructor: (p0, p1, p2, color=green) ->
    @p0 = p0
    @p1 = p1
    @p2 = p2
    @color = color

  getCircle: ->
    center = new Point(0,0);

    yDelta_p0 = @p1.y - @p0.y;
    xDelta_p0 = @p1.x - @p0.x;
    yDelta_p1 = @p2.y - @p1.y;
    xDelta_p1 = @p2.x - @p1.x;

    #if xDelta_p0 is 0 

    #if xDelta_p1 is 0


    
    p0Slope  = yDelta_p0/xDelta_p0;
    p1Slope  = yDelta_p1/xDelta_p1;  
    center.x = (p0Slope*p1Slope*(@p0.y - @p2.y) + p1Slope*(@p0.x + @p1.x) - p0Slope*(@p1.x+@p2.x) )/(2*(p1Slope-p0Slope) );
    center.y = -1*(center.x - (@p0.x+@p1.x)/2)/p0Slope + (@p0.y+@p1.y)/2;
    r = center.sub @p0
    r = r.norm()

    return new Circle(center, r)

  contains: (point)  ->
    @getCircle().contains(point)

  draw: (ctx) ->
    ctx.beginPath()
    ctx.moveTo(@p0.x, @p0.y)
    ctx.lineTo(@p1.x, @p1.y)
    ctx.lineTo(@p2.x, @p2.y)
    ctx.lineTo(@p0.x, @p0.y)
    ctx.strokeStyle = @color.asHex()
    ctx.stroke()

