class Mesh{
  Triangle[] soup;
  Mesh(Triangle[] soup){
    this.soup = soup;
  }
}

class Half_Edge{
  Half_Edge next;
  Half_Edge twin;
  Triangle face;
  Edge ed;
}

class Triangle{
  Half_Edge feh;
  Particle[] p;
  Triangle(Particle p, Particle q, Particle s){
    this.p = new Particle[3];
    this.p[0] = p;
    this.p[1] = q;
    this.p[2] = s;
  }
}

//Edge between particles
class Edge{
  //from a to b
  Particle a,b;
  PVector c;
  Edge(Particle a, Particle b){
    this.a = a;
    this.b = b;
    this.c = new PVector(a.pos.x-b.pos.x,a.pos.y-b.pos.y);
  }
  boolean improperIntersects(Edge ed){
    if((this.isRight(ed.a) || this.isOn(ed.a)) && (this.isLeft(ed.b) || this.isOn(ed.b)) && (ed.isRight(a) || ed.isOn(a)) && (ed.isLeft(b) || ed.isOn(b))) return true;
    if((this.isRight(ed.a) || this.isOn(ed.a)) && (this.isLeft(ed.b) || this.isOn(ed.b)) && (ed.isRight(b) || ed.isOn(b)) && (ed.isLeft(a) || ed.isOn(a))) return true;
    if((this.isRight(ed.b) || this.isOn(ed.b)) && (this.isLeft(ed.a) || this.isOn(ed.a)) && (ed.isRight(a) || ed.isOn(a)) && (ed.isLeft(b) || ed.isOn(b))) return true;
    if((this.isRight(ed.b) || this.isOn(ed.b)) && (this.isLeft(ed.a) || this.isOn(ed.a)) && (ed.isRight(b) || ed.isOn(b)) && (ed.isLeft(a) || ed.isOn(a))) return true;
    return false;
  }
  boolean properIntersects(Edge ed){
    if(this.isRight(ed.a) && this.isLeft(ed.b) && ed.isRight(a) && ed.isLeft(b)) return true;
    if(this.isRight(ed.a) && this.isLeft(ed.b) && ed.isRight(b) && ed.isLeft(a)) return true;
    if(this.isRight(ed.b) && this.isLeft(ed.a) && ed.isRight(a) && ed.isLeft(b)) return true;
    if(this.isRight(ed.b) && this.isLeft(ed.a) && ed.isRight(b) && ed.isLeft(a)) return true;
    return false;
  }
  boolean isRight(Particle p){
    if(c.cross(p.pos).mag()>0) return true;
    return false;
  }
  boolean isLeft(Particle p){
    if(c.cross(p.pos).mag()<0) return true;
    return false;
  }
  boolean isOn(Particle p){
    if(c.cross(p.pos).mag()==0) return true;
    return false;
  }
}
