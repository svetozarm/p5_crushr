class Quadtree {
  boolean keep;

  int x;
  int y;
  int w;
  int h;

  Quadtree tl, tr, bl, br, parent;

  Quadtree(Quadtree parent, int x, int y, int w, int h) {
    this.tl = null;
    this.tr = null;
    this.bl = null;
    this.br = null;
    this.parent = parent;

    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    keep = false;
  }

  boolean check_pixel(int x, int y) {
    if  ((x > this.x) &&
      (y > this.y) &&
      (x < this.x + this.w ) &&
      (y < this.y + this.h)) {
      return true;
    }
    return false;
  }

  boolean has_children() {
    return (this.tl != null);
  }

  void subdivide(int x, int y) {
    if (!this.check_pixel(x, y)) {
      return;
    }
    if (this.tl == null) {
      if (this.keep) {
        this.keep = false;
        return;
      }
      this.tl = new Quadtree(this, this.x, this.y, this.w/2, this.h/2);
      this.tr = new Quadtree(this, this.x + this.w/2 + 1, this.y, this.w/2, this.h/2);
      this.bl = new Quadtree(this, this.x, this.y + this.h/2 + 1, this.w/2, this.h/2);
      this.br = new Quadtree(this, this.x + this.w/2 + 1, this.y + this.h/2 + 1, this.w/2, this.h/2);
    } 
    else {
      if (this.tl.check_pixel(x, y)) {
        this.tl.subdivide(x, y);
        return;
      }    
      if (this.tr.check_pixel(x, y)) {
        this.tr.subdivide(x, y);
        return;
      } 
      if (this.bl.check_pixel(x, y)) {
        this.bl.subdivide(x, y);
        return;
      } 
      if (this.br.check_pixel(x, y)) {
        this.br.subdivide(x, y);
        return;
      }
    }
  }

  void keep(int x, int y) {
    if (!this.check_pixel(x, y)) {
      return;
    }
    if (this.tl == null) {      
      this.keep = true;
    } 
    else {
      if (this.tl.check_pixel(x, y)) {
        this.tl.keep(x, y);
        return;
      }    
      if (this.tr.check_pixel(x, y)) {
        this.tr.keep(x, y);
        return;
      } 
      if (this.bl.check_pixel(x, y)) {
        this.bl.keep(x, y);
        return;
      } 
      if (this.br.check_pixel(x, y)) {
        this.br.keep(x, y);
        return;
      }
    }
  }

  void process_image(PImage input, PImage output) {
    if (this.tl == null) {
      if (!this.keep) {

        color c;
        long r = 0;
        long g = 0;
        long b = 0;
        for (int i = this.x; i <= this.x + this.w; i++) {
          for (int j = this.y; j <= this.y + this.h; j++) {
            c = input.get(i, j);
            r += red(c);
            g += green(c);
            b += blue(c);
          }
        }
        int npix = (this.w * this.h);
        r /= npix;
        g /= npix;
        b /= npix;
        c = color(r, g, b);
        for (int i = this.x; i <= this.x + this.w; i++) {
          for (int j = this.y; j <= this.y + this.h; j++) {
            output.set(i, j, c);
          }
        }
      } 
      else {  // keeping the input pixels
        for (int i = this.x; i <= this.x + this.w; i++) {
          for (int j = this.y; j <= this.y + this.h; j++) {
            output.set(i, j, input.get(i, j));
          }
        }
      }
    }
    else {
      this.tl.process_image(input, output); 
      this.tr.process_image(input, output);
      this.bl.process_image(input, output);
      this.br.process_image(input, output);
    }
  }

  void merge(int x, int y) {
    if (!check_pixel(x, y)) {
      return;
    }
    if (!this.has_children()) {
      if (this.parent != null) {
        this.parent.reset_children();
      }
      return;
    } else {
      if (this.tl.check_pixel(x, y)) {
        this.tl.merge(x, y);
        return;
      }    
      if (this.tr.check_pixel(x, y)) {
        this.tr.merge(x, y);
        return;
      } 
      if (this.bl.check_pixel(x, y)) {
        this.bl.merge(x, y);
        return;
      } 
      if (this.br.check_pixel(x, y)) {
        this.br.merge(x, y);
        return;
      }
    }
  }

  void reset_children() {
    this.tl = null;
    this.tr = null;
    this.bl = null;
    this.br = null;
  }
}

