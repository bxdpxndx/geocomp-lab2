class HalfEdge

  # origin: Point of origin
  # face: Triangle to the LEFT of the vector
  # opposite: Edge representing the other direction
  # next: next Edge of this face

  constructor: (@origin, @face, @opposite = null, @next = null) ->
    @id = Math.random()

  toString: ->
    "edge #{@id} from #{@origin.x},#{@origin.y} to #{@next.origin.x},#{@next.origin.y}"
