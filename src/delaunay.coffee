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
      if t0.nbs.some((x) -> x == null) or t1.nbs.some((x) -> x == null)
        continue
      else
        @flip_triangles(t0, t1)

    return

  retriangulate: (tri, point) ->
    [p0,p1,p2] = tri.vertexs
    t0 = new Triangle(p0, p1, point)
    t1 = new Triangle(point, p1, p2)
    t2 = new Triangle(p0, point, p2)

    # triangles do a little happy dance
    t0.nbs = [tri.nbs[0], t1, t2]
    t1.nbs = [t0, tri.nbs[1], t2]
    t2.nbs = [t0, t1, tri.nbs[2]]

     # TODO: relink old triangles.
     # code here...

    # i'm not sure this is 100% correct... don't know how to test.
    
    @triangles.push x for x in [t0,t1,t2]

    #remove the old triangle
    @triangles.splice(@triangles.indexOf(tri),1)

    #recheck new triangles
    @needs_checking.push [t0, t1]
    @needs_checking.push [t1, t2]
    @needs_checking.push [t2, t0]

  flip_triangles: (t1, t2) ->

    # two triangles and 4 points. find the points unique to each triangle
    # check if any point is inside the other triangles' circle.
    # if so, then flip the triangles and do the triangle dance.
    union = []
    free_t1 = []
    free_t2 = []
    free_t1.push t for t in t1.vertexs when t not in t2.vertexs
    free_t2.push t for t in t2.vertexs when t not in t1.vertexs
    union.push t for t in t1.vertexs when t in t2.vertexs
    c1 = t1.getCircle()
    c2 = t2.getCircle()

    console.log c1.contains(free_t2[0]), c2.contains(free_t1[0])
    if c1.contains(free_t2[0]) or c2.contains(free_t1[0])
      # Create the news triangles 
      n_t1 = new Triangle(free_t1, free_t2, union[0])
      n_t2 = new Triangle(free_t1, free_t2, union[1])

      nbs_t  = []

      # get the nbs of the olds triangles 
      for t in t1.nbs
        free_p = []
        free_p.push p for p in t.vertexs when p not in t2.vertexs
        if free_p.length 
          nbs_t.push t

      for t in t2.nbs
        free_p = []
        free_p.push p for p in t.vertexs when p not in t1.vertexs
        if free_p.length 
          nbs_t.push t

      console.log t1.nbs, t2.nbs, nbs_t

      #console.log 'This is the t1 nbs'
      #for t in nbs_t1
      #  console.log t.vertexs[0],t.vertexs[1],t.vertexs[2]
      #console.log 'And t1 is'
      #console.log t1.vertexs[0],t1.vertexs[1],t1.vertexs[2]
      #console.log 'And t2 is'
      #console.log t2.vertexs[0],t2.vertexs[1],t2.vertexs[2]
      #console.log 'And it must be the same as this'
      #console.log nbs_t1c.vertexs[0],nbs_t1c.vertexs[1],nbs_t1c.vertexs[2]

      #console.log 'This is the t2 nbs'
      #for t in nbs_t2
      #  console.log t.vertexs[0],t.vertexs[1],t.vertexs[2]
      #console.log 'And it must be the same as this'
      #console.log nbs_t2c.vertexs[0],nbs_t2c.vertexs[1],nbs_t2c.vertexs[2]

      for t in all_t
        union_t1 = v for v in n_t1.vertexs when v in t.vertexs   
        #if union_t1.length > 1 then n_t1.nbs.push t else n_t2.nbs. push t 
        if union_t1.length > 1 
          n_t1.nbs.push t 
          for n in @triangles when n is t
            n = t
          # for t.nbs in n is t1  
        else 
          n_t2.nbs.push t 

  draw: (ctx) ->
    p.draw(ctx) for p in @points
    for t in @triangles
      t.draw(ctx)
      t.getCircle().draw(ctx) if @show_circles
    for [t0, t1] in @needs_checking
      ctx.beginPath()
      ctx.moveTo(t0.center().x, t0.center().y)
      ctx.lineTo(t1.center().x, t1.center().y)
      ctx.stroke()
      return
    return