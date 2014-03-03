class HalfEdge

  # origin: Point of origin
  # face: Triangle to the LEFT of the vector
  # opposite: Edge representing the other direction
  # next: next Edge of this face

  constructor: (@origin, @face, @opposite = null, @next = null, @color = green) ->
    @id = Math.random()

  draw: (ctx) ->
    ctx.beginPath()
    ctx.moveTo(@origin.x, @origin.y)
    ctx.lineTo(@next.origin.x, @next.origin.y)
    ctx.strokeStyle = @color.asHex()
    ctx.stroke()

  assert_edge: =>
    if @opposite isnt null
      assert(this, @opposite.opposite == this, "opposite's opposite isn't me")
      assert(this, @next.origin == @opposite.origin, "next and opposite don't start at the same point")
      assert(this, @opposite.next.origin == @origin, "opposite's next doesn't start where i do")
      assert(this, @face == @next.face, "next's face isn't my face")
