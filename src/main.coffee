window.onload = ->
  
  # Can't touch this
  fps = 30
  canvas = document.getElementById('delaunay')
  ctx = canvas.getContext('2d')
  mouse = new Point(0,0)
  ctx.translate(0.5, 0.5)
  window.setInterval(mainloop, 1000/ fps)
  newButton = (name, text, action) -> 
    b = document.createElement("input")
    b.type      = "submit"
    b.className = "btn active"
    b.value     = text
    b.id        = name
    b.onclick   = action
    document.getElementById('buttons').appendChild(b)
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
      c.draw(ctx) if show_circles

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
  clear = ->
    points = []

  toggle_circles = ->
    show_circles = !show_circles
  newButton('clear', 'Clear', clear)
  newButton('toggle-circles', 'Toggle Circles', toggle_circles)
  # maybe onkeydown is more appropiate, we need to read about js
  # best practices... All browsers are broken
  window.onkeypress = (e) ->
  
  key = String.fromCharCode e.which
    if key is 'q' 
      toggle_circles() 
    if key is 'r'
      reset()
  
# REQUIREMENTS

# Remove the base trinagle at the end 
# Change the color of the next candidate
# A key for restart it. 

