// Generated by CoffeeScript 1.4.0
(function() {
  var Circle, Color, Delaunay, HalfEdge, Point, Triangle, black, blue, gray, green, red, white,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.onload = function() {
    var canvas, ctx, delaunay, fps, keymap, mainloop, mouse, newButton;
    fps = 10;
    canvas = document.getElementById('delaunay');
    ctx = canvas.getContext('2d');
    window.ctx = ctx;
    mouse = new Point(0, 0);
    ctx.translate(0.5, 0.5);
    window.assert = function(object, cond, message) {
      if (!cond) {
        console.log(message || "Assertion failed");
        throw new Error;
      }
    };
    keymap = {};
    window.onkeypress = function(e) {
      var action, key;
      key = String.fromCharCode(e.which);
      action = keymap[key];
      if (action !== void 0) {
        return action();
      }
    };
    newButton = function(key, text, action) {
      var b;
      b = document.createElement("input");
      b.type = "submit";
      b.className = "btn";
      b.value = text + ' (' + key + ')';
      b.id = key;
      b.onclick = action;
      keymap[key] = action;
      return document.getElementById('buttons').appendChild(b);
    };
    delaunay = new Delaunay(canvas);
    mainloop = function() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.fillText("Mouse:" + mouse.x + ', ' + mouse.y, 750, 470);
      return delaunay.draw(ctx);
    };
    canvas.onclick = function(e) {
      return delaunay.new_point(new Point(e.offsetX, e.offsetY));
    };
    canvas.onmousemove = function(e) {
      return mouse = new Point(e.offsetX, e.offsetY);
    };
    window.setInterval(mainloop, 1000 / fps);
    newButton('r', 'Clear', function() {
      return delaunay = new Delaunay(canvas);
    });
    return newButton('q', 'Toggle Circles', function() {
      return delaunay.show_circles = !delaunay.show_circles;
    });
  };

  Circle = (function() {

    function Circle(c, r, color) {
      this.c = c;
      this.r = r;
      this.color = color != null ? color : blue;
    }

    Circle.prototype.contains = function(point) {
      return this.r * this.r > (this.c.x - point.x) * (this.c.x - point.x) + (this.c.y - point.y) * (this.c.y - point.y);
    };

    Circle.prototype.draw = function(ctx, hl) {
      if (hl == null) {
        hl = false;
      }
      ctx.beginPath();
      ctx.arc(this.c.x, this.c.y, this.r, 0, 2 * Math.PI);
      ctx.strokeStyle = this.color.asHex();
      return ctx.stroke();
    };

    return Circle;

  })();

  Color = (function() {

    Color.prototype.r = null;

    Color.prototype.g = null;

    Color.prototype.b = null;

    function Color(r, g, b) {
      this.r = r;
      this.g = g;
      this.b = b;
    }

    Color.prototype.asHex = function() {
      return '#' + ("0" + this.r.toString(16)).slice(-2) + ("0" + this.g.toString(16)).slice(-2) + ("0" + this.b.toString(16)).slice(-2);
    };

    return Color;

  })();

  black = new Color(0, 0, 0);

  gray = new Color(128, 128, 128);

  white = new Color(255, 255, 255);

  red = new Color(255, 0, 0);

  blue = new Color(0, 0, 255);

  green = new Color(0, 255, 0);

  Delaunay = (function() {

    function Delaunay(canvas) {
      var i, inside, p, _i, _ref;
      this.show_circles = false;
      inside = new Triangle();
      this.points = [new Point(canvas.width / 2, -1500), new Point(-1000, canvas.height + 1000), new Point(canvas.width + 1000, canvas.height + 1000)];
      this.faces = [inside];
      this.edges = (function() {
        var _i, _len, _ref, _results;
        _ref = this.points;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          p = _ref[_i];
          _results.push(new HalfEdge(p, inside));
        }
        return _results;
      }).call(this);
      inside.edge = this.edges[0];
      this.needs_checking = [];
      for (i = _i = 0, _ref = this.points.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.edges[i].next = this.edges[(i + 1) % 3];
      }
    }

    Delaunay.prototype.new_point = function(point) {
      var e, f, face, _i, _len, _ref;
      point.draw(ctx);
      this.points.push(point);
      face = (function() {
        var _i, _len, _ref, _results;
        _ref = this.faces;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          f = _ref[_i];
          if (f.contains(point)) {
            _results.push(f);
          }
        }
        return _results;
      }).call(this);
      face = face[0];
      this.retriangulate(face, point);
      _ref = this.edges;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        e.assert_edge();
      }
      while (this.needs_checking.length) {
        this.flip_edge(this.needs_checking.pop());
      }
    };

    Delaunay.prototype.retriangulate = function(face, point) {
      var e0, e1, edges, faces, good_edges, i, pending_edges, points, _i, _j;
      edges = face.edges();
      points = face.points();
      pending_edges = [];
      good_edges = [];
      faces = [face, new Triangle(), new Triangle()];
      this.faces.push(faces[1]);
      this.faces.push(faces[2]);
      for (i = _i = 0; _i < 3; i = ++_i) {
        e0 = new HalfEdge(point, faces[i]);
        e1 = new HalfEdge(points[i], faces[(i + 2) % 3]);
        edges[i].face = faces[i];
        e0.next = edges[i];
        e0.opposite = e1;
        e1.opposite = e0;
        this.edges.push(e0);
        this.edges.push(e1);
        pending_edges.push(e1);
        good_edges.push(e0);
      }
      for (i = _j = 0; _j < 3; i = ++_j) {
        faces[i].edge = good_edges[i];
        edges[i].next = pending_edges[(i + 1) % 3];
        pending_edges[i].next = good_edges[(i + 2) % 3];
        if (edges[i].opposite !== null) {
          this.needs_checking.push(edges[i]);
        }
      }
    };

    Delaunay.prototype.flip_triangles = function(t1, t2) {
      var all_t, c1, c2, free_t1, free_t2, n, n_t1, n_t2, nbs_t1, nbs_t2, t, union, union_t1, v, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _len6, _m, _n, _o, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _results;
      union = [];
      free_t1 = [];
      free_t2 = [];
      _ref = t1.vertexs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        if (__indexOf.call(t2.vertexs, t) < 0) {
          free_t1.push(t);
        }
      }
      _ref1 = t2.vertexs;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        t = _ref1[_j];
        if (__indexOf.call(t1.vertexs, t) < 0) {
          free_t2.push(t);
        }
      }
      _ref2 = t1.vertexs;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        t = _ref2[_k];
        if (__indexOf.call(t2.vertexs, t) >= 0) {
          union.push(t);
        }
      }
      c1 = t1.getCircle();
      c2 = t2.getCircle();
      if (c1.contains(free_t2) || c2.contains(free_t1)) {
        n_t1 = new Triangle(free_t1, free_t2, union[0]);
        n_t2 = new Triangle(free_t1, free_t2, union[1]);
        _ref3 = t1.nbs;
        for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
          t = _ref3[_l];
          if (t === !t2) {
            nbs_t1 = t;
          }
        }
        _ref4 = t2.nbs;
        for (_m = 0, _len4 = _ref4.length; _m < _len4; _m++) {
          t = _ref4[_m];
          if (t === !t1) {
            nbs_t2 = t;
          }
        }
        all_t = [nbs_t1, nbs_t2];
        _results = [];
        for (_n = 0, _len5 = all_t.length; _n < _len5; _n++) {
          t = all_t[_n];
          _ref5 = n_t1.vertexs;
          for (_o = 0, _len6 = _ref5.length; _o < _len6; _o++) {
            v = _ref5[_o];
            if (__indexOf.call(t.vertexs, v) >= 0) {
              union_t1 = v;
            }
          }
          if (union_t1.length > 1) {
            n_t1.nbs.push(t);
            _results.push((function() {
              var _len7, _p, _ref6, _results1;
              _ref6 = this.triangles;
              _results1 = [];
              for (_p = 0, _len7 = _ref6.length; _p < _len7; _p++) {
                n = _ref6[_p];
                if (n === t) {
                  _results1.push(n = t);
                }
              }
              return _results1;
            }).call(this));
          } else {
            _results.push(n_t2.nbs.push(t));
          }
        }
        return _results;
      }
    };

    Delaunay.prototype.flip_edge = function(edge) {
      var new0, new1, oppo, p0, p1;
      oppo = edge.opposite;
      p0 = edge.next.next.origin;
      p1 = oppo.next.next.origin;
      if (!(edge.face.getCircle().contains(p1) || oppo.face.getCircle().contains(p0))) {
        return;
      }
      new0 = new HalfEdge(p0);
      new1 = new HalfEdge(p1);
      new0.opposite = new1;
      new1.opposite = new0;
      new0.next = oppo.next.next;
      new1.next = edge.next.next;
      new0.next.next = edge.next;
      new1.next.next = oppo.next;
      new0.next.next.next = new0;
      new1.next.next.next = new1;
      edge.face.edge = new0;
      oppo.face.edge = new1;
      new0.face = edge.face;
      new1.face = oppo.face;
      new0.next.face = new0.face;
      new1.next.face = new1.face;
      new0.next.next.face = new0.face;
      new1.next.next.face = new1.face;
      this.edges[this.edges.indexOf(edge)] = new0;
      this.edges[this.edges.indexOf(oppo)] = new1;
    };

    Delaunay.prototype.draw = function(ctx) {
      var e, p, t, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      _ref = this.points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        p.draw(ctx);
      }
      _ref1 = this.edges;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        e = _ref1[_j];
        e.draw(ctx);
      }
      if (this.show_circles) {
        _ref2 = this.faces;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          t = _ref2[_k];
          t.getCircle().draw(ctx);
        }
      }
    };

    return Delaunay;

  })();

  Point = (function() {

    function Point(x, y, color) {
      if (color == null) {
        color = black;
      }
      this.x = x;
      this.y = y;
      this.color = color;
    }

    Point.prototype.add = function(other) {
      return new Point(this.x + other.x, this.y + other.y);
    };

    Point.prototype.sub = function(other) {
      return new Point(this.x - other.x, this.y - other.y);
    };

    Point.prototype.dot = function(other) {
      return this.x * other.x + this.y * other.y;
    };

    Point.prototype.norm = function() {
      return Math.sqrt(this.x * this.x + this.y * this.y);
    };

    Point.prototype.draw = function(ctx) {
      var sz;
      sz = 2;
      ctx.beginPath();
      ctx.moveTo(this.x - sz, this.y - sz);
      ctx.lineTo(this.x + sz, this.y + sz);
      ctx.moveTo(this.x + sz, this.y - sz);
      ctx.lineTo(this.x - sz, this.y + sz);
      ctx.strokeStyle = this.color.asHex();
      return ctx.stroke();
    };

    return Point;

  })();

  HalfEdge = (function() {

    function HalfEdge(origin, face, opposite, next, color) {
      this.origin = origin;
      this.face = face;
      this.opposite = opposite != null ? opposite : null;
      this.next = next != null ? next : null;
      this.color = color != null ? color : green;
      this.assert_edge = __bind(this.assert_edge, this);

      this.id = Math.random();
    }

    HalfEdge.prototype.draw = function(ctx) {
      ctx.beginPath();
      ctx.moveTo(this.origin.x, this.origin.y);
      ctx.lineTo(this.next.origin.x, this.next.origin.y);
      ctx.strokeStyle = this.color.asHex();
      return ctx.stroke();
    };

    HalfEdge.prototype.assert_edge = function() {
      if (this.opposite !== null) {
        assert(this, this.opposite.opposite === this, "opposite's opposite isn't me");
        assert(this, this.next.origin === this.opposite.origin, "next and opposite don't start at the same point");
        assert(this, this.opposite.next.origin === this.origin, "opposite's next doesn't start where i do");
        return assert(this, this.face === this.next.face, "next's face isn't my face");
      }
    };

    return HalfEdge;

  })();

  Triangle = (function() {

    function Triangle(edge) {
      this.edge = edge != null ? edge : null;
    }

    Triangle.prototype.edges = function() {
      return [this.edge, this.edge.next, this.edge.next.next];
    };

    Triangle.prototype.points = function() {
      var e, _i, _len, _ref, _results;
      _ref = this.edges();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        _results.push(e.origin);
      }
      return _results;
    };

    Triangle.prototype.getCircle = function() {
      var center, p0, p0Slope, p1, p1Slope, p2, r, xDelta_p0, xDelta_p1, yDelta_p0, yDelta_p1, _ref;
      center = new Point(0, 0);
      _ref = this.points(), p0 = _ref[0], p1 = _ref[1], p2 = _ref[2];
      yDelta_p0 = p1.y - p0.y;
      xDelta_p0 = p1.x - p0.x;
      yDelta_p1 = p2.y - p1.y;
      xDelta_p1 = p2.x - p1.x;
      p0Slope = yDelta_p0 / xDelta_p0;
      p1Slope = yDelta_p1 / xDelta_p1;
      center.x = (p0Slope * p1Slope * (p0.y - p2.y) + p1Slope * (p0.x + p1.x) - p0Slope * (p1.x + p2.x)) / (2 * (p1Slope - p0Slope));
      center.y = -1 * (center.x - (p0.x + p1.x) / 2) / p0Slope + (p0.y + p1.y) / 2;
      r = center.sub(p0);
      r = r.norm();
      return new Circle(center, r);
    };

    Triangle.prototype.contains = function(point) {
      var dot00, dot01, dot02, dot11, dot12, invDenom, p0, p1, p2, u, v, v0, v1, v2, _ref;
      _ref = this.points(), p0 = _ref[0], p1 = _ref[1], p2 = _ref[2];
      v0 = p2.sub(p0);
      v1 = p1.sub(p0);
      v2 = point.sub(p0);
      dot00 = v0.dot(v0);
      dot01 = v0.dot(v1);
      dot02 = v0.dot(v2);
      dot11 = v1.dot(v1);
      dot12 = v1.dot(v2);
      invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
      u = (dot11 * dot02 - dot01 * dot12) * invDenom;
      v = (dot00 * dot12 - dot01 * dot02) * invDenom;
      return (u >= 0) && (v >= 0) && (u + v < 1);
    };

    return Triangle;

  })();

}).call(this);
