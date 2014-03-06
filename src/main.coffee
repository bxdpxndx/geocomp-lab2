window.onload = ->

  # Can't touch this
  fps    = 10
  canvas = document.getElementById("delaunay")
  ctx    = canvas.getContext('2d')
  window.ctx = ctx
  mouse  = new Point(0,0)
  ctx.translate(0.5, 0.5)
  window.assert = (object, cond, message) ->
    if not cond
      console.log message || "Assertion failed"
      throw new Error

  #add arrow keys maybe? or anything that doesn't have a button
  keymap = {}

  # maybe onkeydown is more appropiate, we need to read about js
  # best practices... All browsers are broken

  window.onkeypress = (e) ->
    key    = String.fromCharCode e.which
    action = keymap[key]
    action() if action isnt undefined

  newButton = (key, text, action) ->
    b           = document.createElement("input")
    b.type      = "submit"
    b.className = "btn"
    b.value     = text + ' (' + key + ')'
    b.id        = key
    b.onclick   = action
    keymap[key] = action
    document.getElementById('buttons').appendChild(b)

  # end of private part
  # set global variables here (processing 'setup')

  delaunay = new Delaunay(canvas)

  # edit this, it should be pretty straightforward
  mainloop = ->

    ctx.clearRect(0,0, canvas.width, canvas.height)
    ctx.fillText("Mouse:" + mouse.x + ', ' + mouse.y, 750, 470)
    delaunay.draw(ctx)
  # handlers and thingies that can't be initialized earlier.

  canvas.addEventListener "mouseup", (e) -> delaunay.new_point(new Point(e.offsetX, e.offsetY))

  canvas.addEventListener "mousemove", (e) -> mouse = new Point(e.offsetX, e.offsetY)

  # define new behaviours here.
  window.setInterval(mainloop, 1000/ fps)

  newButton('r', 'Clear', -> delaunay = new Delaunay(canvas))
  newButton('q', 'Toggle Circles', -> delaunay.show_circles = !delaunay.show_circles)
  newButton('w', 'Add random point', -> delaunay.new_point(new Point(Math.random()*canvas.width, Math.random()*canvas.height)))
  newButton('e', 'Add 50 points', -> delaunay.new_point(new Point(Math.random()*canvas.width, Math.random()*canvas.height)) for i in [0...50])
  newButton('a', 'Preset: Grid', ->
    delaunay = new Delaunay(canvas)
    for i in [15..canvas.width-15] by 90
      for j in [15..canvas.height-15] by 90
        delaunay.new_point(new Point(i,j+i/90))
  )  # ...



# REQUIREMENTS

# Remove the base trinagle at the end
# Change the color of the next candidate
# A key for restart it.

