build: dummy
	coffee -j build/delaunay.js -c --compile src/circle.coffee src/color.coffee src/delaunay.coffee src/point.coffee src/triangle.coffee src/main.coffee src/quad_edge.coffee

clean:
	rm build/delaunay.js

dummy:
