class Delaunay
  constructor: (canvas) ->

    @show_circles = false

    # create supertriangle
    inside = new Triangle()
    @points = [new Point(canvas.width/2,-1500),  new Point(-1000, canvas.height + 1000), new Point(canvas.width+1000, canvas.height + 1000)]
    #@points = [new Point(canvas.width/2, 10), new Point(canvas.width - 10, canvas.height - 10), new Point(10, canvas.height - 10)]
    @faces = [inside]
    @edges = (new HalfEdge(p, inside) for p in @points)
    inside.edge = @edges[0]

    @needs_checking = []

    #link the edges
    for i in [0...@points.length]
      @edges[i].next = @edges[(i+1)%3]

  new_point: (point) ->
    point.draw(ctx)
    @points.push(point)

    face = (f for f in @faces when f.contains(point))
    face = face[0]
    @retriangulate(face, point)
    e.assert_edge() for e in @edges
    @flip_edge(@needs_checking.pop()) while @needs_checking.length
    return

  # reimplement this
  retriangulate: (face, point) ->
    edges = face.edges()
    points = face.points()
    pending_edges = []
    good_edges = []
    faces = [face, new Triangle(), new Triangle()]
    @faces.push faces[1]
    @faces.push faces[2]
    for i in [0...3]
      e0 = new HalfEdge point, faces[i]
      e1 = new HalfEdge points[i], faces[(i+2) % 3]
      edges[i].face = faces[i]
      e0.next = edges[i]
      e0.opposite = e1
      e1.opposite = e0

      @edges.push e0
      @edges.push e1
      pending_edges.push e1
      good_edges.push e0

    for i in [0...3]
      faces[i].edge = good_edges[i]
      edges[i].next = pending_edges[(i+1) % 3]
      pending_edges[i].next = good_edges[(i+2) % 3]
      @needs_checking. push edges[i] if edges[i].opposite isnt null
    return

  flip_edge: (edge) ->
    oppo = edge.opposite
    p0 = edge.next.next.origin
    p1 = oppo.next.next.origin
    unless edge.face.getCircle().contains(p1) or oppo.face.getCircle().contains(p0)
      return

    new0 = new HalfEdge(p0)
    new1 = new HalfEdge(p1)
    new0.opposite = new1
    new1.opposite = new0

    new0.next = oppo.next.next
    new1.next = edge.next.next
    new0.next.next = edge.next
    new1.next.next = oppo.next
    new0.next.next.next = new0
    new1.next.next.next = new1
    edge.face.edge = new0
    oppo.face.edge = new1
    new0.face = edge.face
    new1.face = oppo.face
    new0.next.face = new0.face
    new1.next.face = new1.face
    new0.next.next.face = new0.face
    new1.next.next.face = new1.face
    @edges[@edges.indexOf(edge)] = new0
    @edges[@edges.indexOf(oppo)] = new1
    return

  draw: (ctx) ->
    t.getCircle().draw(ctx) for t in @faces if @show_circles
    e.draw(ctx) for e in @edges
    p.draw(ctx) for p in @points
    return
