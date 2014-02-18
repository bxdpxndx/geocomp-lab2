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

  delaunay = new Delaunay(canvas)

  # edit this, it should be pretty straightforward
  mainloop = ->

    ctx.clearRect(0,0, canvas.width, canvas.height)
    ctx.fillText("Mouse:" + mouse.x + ', ' + mouse.y, 750, 470)
    delaunay.draw(ctx)
  # handlers and thingies that can't be initialized earlier.

  
  window.setInterval(mainloop, 1000/ fps)
  
  canvas.onclick = (e) ->
    delaunay.new_point(new Point(e.offsetX, e.offsetY))

  canvas.onmousemove = (e) -> 
    mouse = new Point(e.offsetX, e.offsetY)

  # define new behaviours here.
  newButton('r', 'Clear', -> delaunay = new Delaunay(canvas))
  newButton('q', 'Toggle Circles', -> delaunay.show_circles = !delaunay.show_circles)

# REQUIREMENTS

# Remove the base trinagle at the end 
# Change the color of the next candidate
# A key for restart it. 

