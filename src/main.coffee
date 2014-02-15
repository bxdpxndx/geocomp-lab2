window.onload = ->
  
  # Can't touch this
  fps = 10
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
    b.value     = text + ' (' + key + ')'
    b.id        = key
    b.onclick   = action
    keymap[key] = action
    document.getElementById('buttons').appendChild(b)

  # end of private part
  # set global variables here (processing 'setup')
  
  supertriangle = new Triangle(new Point(canvas.width/2,-1000),
                               new Point(-1000, canvas.height + 1000),
                               new Point(canvas.width+1000, canvas.height + 1000))
  triangles = [supertriangle]
  points    = []
  show_circles = false

  # edit this, it should be pretty straightforward
  mainloop = ->

    ctx.clearRect(0,0, canvas.width, canvas.height)
    ctx.fillText("Mouse:" + mouse.x + ', ' + mouse.y, 750, 470)
    p.draw(ctx) for p in points
    t.draw(ctx) for t in triangles
    t.getCircle().draw(ctx) for t in triangles when show_circles
    return
  # handlers and thingies that can't be initialized earlier.
  
  window.setInterval(mainloop, 1000/ fps)
  
  canvas.onclick = (e) ->
    points.push mouse
    tri = (t for t in triangles when t.contains(mouse))
    tri = tri[0]
    t0 = new Triangle(tri.p0, tri.p1, mouse)
    triangles.push(new Triangle(tri.p0, tri.p1, mouse))
    triangles.push(new Triangle(tri.p1, tri.p2, mouse))
    triangles.push(new Triangle(tri.p2, tri.p0, mouse))
    triangles.splice(triangles.indexOf(tri),1)

  canvas.onmousemove = (e) -> 
    mouse = new Point(e.offsetX, e.offsetY)

  # define new behaviours here.
  newButton('r', 'Clear', -> points = []; triangles = [supertriangle])
  newButton('q', 'Toggle Circles', -> show_circles = !show_circles)

# REQUIREMENTS

# Remove the base trinagle at the end 
# Change the color of the next candidate
# A key for restart it. 

