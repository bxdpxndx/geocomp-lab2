window.onload = ->
  
  # Can't touch this
  fps = 30
  canvas = document.getElementById('delaunay')
  ctx = canvas.getContext('2d')
  mouse = new Point(0,0)
  ctx.translate(0.5, 0.5)
  window.setInterval(mainloop, 1000/ fps)

  #add arrow keys maybe? or anything that doesn't have a button
  keymap = {}

  # maybe onkeydown is more appropiate, we need to read about js
  # best practices... All browsers are broken
  
  window.onkeypress = (e) ->
    key = String.fromCharCode e.which
    action = keymap[key]
    action() if action isnt undefined

  newButton = (key, text, action) -> 
    b = document.createElement("input")
    b.type      = "submit"
    b.className = "btn"
    b.value     = text
    b.id        = key
    b.onclick   = action
    keymap[key] = action
    document.getElementById('buttons').appendChild(b)

  # end of private part
  # set global variables here (processing 'setup')
  points    = []
  
  supertriangle = new Triangle(new Point(420,-1000),
                               new Point(-1000, 2000),
                               new Point(1840, 2001))
  triangles = [supertriangle]
  circles   = []
  show_circles = false

  # edit this, it should be pretty straightforward
  mainloop = ->
    ctx.clearRect(0,0, canvas.width, canvas.height)
    p.draw(ctx) for p in points
    for i in [0..points.length-2] by 3
      if points.length > i+2
        t = new Triangle(points[i], points[i+1], points[i+2])
      else
        t = new Triangle(points[i], points[i+1], mouse)
      t.draw(ctx)
      t.getCircle().draw(ctx) if show_circles

  # handlers and thingies that can't be initialized earlier.
  
  window.setInterval(mainloop, 1000/ fps)
  
  canvas.onclick = (e) ->
    points.push mouse
    tri = [t for t in triangles when t.contains(mouse)]
    tri = tri[0]
    triangles.push(new Triangle(tri.p0, tri.p1, mouse))
    triangles.push(new Triangle(tri.p1, tri.p2, mouse))
    triangles.push(new Triangle(tri.p2, tri.p0, mouse))

  canvas.onmousemove = (e) -> 
    mouse = new Point(e.offsetX, e.offsetY)

  # define new behaviours here.
  newButton('r', 'Clear', -> points = [])
  newButton('q', 'Toggle Circles', -> show_circles = !show_circles)

# REQUIREMENTS

# Remove the base trinagle at the end 
# Change the color of the next candidate
# A key for restart it. 

