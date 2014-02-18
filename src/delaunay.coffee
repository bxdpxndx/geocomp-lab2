class Delaunay
  constructor: (canvas) ->
    @supertriangle = new Triangle(new Point(canvas.width/2,-1500),
                                 new Point(-1000, canvas.height + 1000),
                                 new Point(canvas.width+1000, canvas.height + 1000))
    @triangles = [@supertriangle]
    @points = @supertriangle.vertexs.slice()
    @needs_checking = []
    @show_circles = false

  new_point: (point) ->
    @points.push(point)

    tri = (t for t in @triangles when t.contains(point))
    tri = tri[0]
    @retriangulate(tri, point)
    while @needs_checking.length
      [t0, t1] = @needs_checking.pop()
      flip_triangles(t0, t1)


    console.log @triangles.length
    
  retriangulate: (tri, point) ->
    [p0,p1,p2] = tri.vertexs
    t0 = new Triangle(p0, p1, point)
    t1 = new Triangle(point, p1, p2)
    t2 = new Triangle(p0, point, p2)

    # triangles do a little happy dance
    t0.nbs = [tri.nbs[0], t1, t2]
    t1.nbs = [t0, tri.nbs[1], t2]
    t2.nbs = [t0, t1, tri.nbs[2]]

    # i'm not sure this is 100% correct... don't know how to test.
    
    @triangles.push x for x in [t0,t1,t2]
    @triangles.splice(@triangles.indexOf(tri),1)

  flip_triangles: (t1, t2) ->
    # two triangles and 4 points. find the points unique to each triangle
    # check if any point is inside the other triangles' circle.
    # if so, then flip the triangles and do the triangle dance.

  draw: (ctx) ->
    p.draw(ctx) for p in @points
    t.draw(ctx) for t in @triangles
    t.getCircle().draw(ctx) for t in @triangles when @show_circles
    return