class Mesh{
  ArrayList<Face> faces;
  void draw(){
    for(Face face: faces){
      face.draw();
    }
  }
  Mesh(Particle[] particles){
    initMesh();
    for(Particle p: particles){
      addParticle(p);
    }
  }
  void initMesh(){
    //initial still particles
    Particle p1 = new StillParticle(0,0);
    Particle p2 = new StillParticle(0,height);
    Particle p3 = new StillParticle(width,height);
    Particle p4 = new StillParticle(width,0);
    
    //initial half edges
    //first triangle
    Half_Edge he1 = new Half_Edge();
    Half_Edge he2 = new Half_Edge();
    Half_Edge he3 = new Half_Edge();
    //second triangle
    Half_Edge he4 = new Half_Edge();
    Half_Edge he5 = new Half_Edge();
    Half_Edge he6 = new Half_Edge();
    
    //both initial faces
    Face f1 = new Face(he1); //first triangle
    Face f2 = new Face(he4); //second triangle
    
    //initial vertices
    //first face
    Vertex v1 = new Vertex(p1,he1);
    Vertex v2 = new Vertex(p2,he2);
    Vertex v3 = new Vertex(p4,he3);
    //second face
    Vertex v4 = new Vertex(p2,he4);
    Vertex v5 = new Vertex(p3,he5);
    Vertex v6 = new Vertex(p4,he6);
    
    //initial edges
    //first face
    Edge ed1 = new Edge(p1,p2);
    Edge ed2 = new Edge(p2,p4);
    Edge ed3 = new Edge(p4,p1);
    //second face
    Edge ed4 = new Edge(p2,p3);
    Edge ed5 = new Edge(p3,p4);
    Edge ed6 = new Edge(p4,p2);
    
    //conect half edges to faces
    //first face
    he1.face = f1;
    he2.face = f1;
    he3.face = f1;
    //second face
    he4.face = f2;
    he5.face = f2;
    he6.face = f2;
    
    //connect half edges to vertices
    //first triangle
    he1.v1 = v1; he1.v2 = v2;
    he2.v1 = v2; he2.v2 = v3;
    he3.v1 = v3; he3.v2 = v1; 
    //second triangle
    he4.v1 = v4; he4.v2 = v5;
    he5.v1 = v5; he5.v2 = v6;
    he6.v1 = v6; he6.v2 = v4;
    
    //connect half edges to edges
    //first triangle
    he1.ed = ed1;
    he2.ed = ed2;
    he3.ed = ed3;
    //second triangle
    he4.ed = ed4;
    he5.ed = ed5;
    he6.ed = ed6;
    
    //connect neighbourd half edges
    //first triangle
    he1.next = he2; he1.prev = he3;
    he2.next = he3; he2.prev = he1;
    he3.next = he1; he3.prev = he2;
    //second triangle
    he4.next = he5; he4.prev = he6;
    he5.next = he6; he5.prev = he4;
    he6.next = he4; he6.prev = he5;
    
    //connect twin half edges
    he2.twin = he6; he6.twin = he2;
    
    faces = new ArrayList();
    
    faces.add(f1);faces.add(f2);
    
  }
  void addParticle(Particle np){
    Face inFace = findFace(np);
    
    //old half edges
    Half_Edge ohe1 = inFace.edge; //<>//
    Half_Edge ohe2 = inFace.edge.next;
    Half_Edge ohe3 = inFace.edge.prev;
    
    //old vertices
    Vertex ov1 = ohe1.v1;
    Vertex ov2 = ohe2.v1;
    Vertex ov3 = ohe3.v1;
    
    //old particles
    Particle p1 = ov1.p;
    Particle p2 = ov2.p;
    Particle p3 = ov3.p;
    
    //new faces
    Face f1 = new Face(ohe1);
    Face f2 = new Face(ohe2);
    Face f3 = new Face(ohe3);
    
    //new half edges
    Half_Edge nhe1 = new Half_Edge();
    Half_Edge nhe2 = new Half_Edge();
    Half_Edge nhe3 = new Half_Edge();
    Half_Edge nhe4 = new Half_Edge();
    Half_Edge nhe5 = new Half_Edge();
    Half_Edge nhe6 = new Half_Edge();
    
    //new edges
    Edge ed1 = new Edge(p2,np);
    Edge ed2 = new Edge(np,p1);
    Edge ed3 = new Edge(p3,np);
    Edge ed4 = new Edge(np,p2);
    Edge ed5 = new Edge(p1,np);
    Edge ed6 = new Edge(np,p3);
    
    //new vertices
    Vertex nv1 = new Vertex(p2,nhe1);
    Vertex nv2 = new Vertex(np,nhe2);
    Vertex nv3 = new Vertex(p3,nhe3);
    Vertex nv4 = new Vertex(np,nhe4);
    Vertex nv5 = new Vertex(p1,nhe5);
    Vertex nv6 = new Vertex(np,nhe6);
    
    //connect edges to half edges
    nhe1.ed = ed1;
    nhe2.ed = ed2;
    nhe3.ed = ed3;
    nhe4.ed = ed4;
    nhe5.ed = ed5;
    nhe6.ed = ed6;
    
    //connect vertices to half edges
    nhe1.v1 = nv1; nhe1.v2 = nv2;
    nhe2.v1 = nv2; nhe2.v2 = ov1;
    ohe1.v2 = nv1;
    
    nhe3.v1 = nv3; nhe3.v2 = nv4;
    nhe4.v1 = nv4; nhe4.v2 = ov2;
    ohe2.v2 = nv3;
    
    nhe5.v1 = nv5; nhe5.v2 = nv6;
    nhe6.v1 = nv6; nhe6.v2 = ov3;
    ohe3.v2 = nv5;
    
    //connect neighbour/twins half edges
    //old half edges
    ohe1.next = nhe1; ohe1.prev = nhe2;
    ohe2.next = nhe3; ohe2.prev = nhe4;
    ohe3.next = nhe5; ohe3.prev = nhe6;
    //new half edges
    nhe1.next = nhe2; nhe1.prev = ohe1; nhe1.twin = nhe4;
    nhe2.next = ohe1; nhe2.prev = nhe1; nhe2.twin = nhe5;
    nhe3.next = nhe4; nhe3.prev = ohe2; nhe3.twin = nhe6;
    nhe4.next = ohe2; nhe4.prev = nhe3; nhe4.twin = nhe1;
    nhe5.next = nhe6; nhe5.prev = ohe3; nhe5.twin = nhe2;
    nhe6.next = ohe3; nhe6.prev = nhe5; nhe6.twin = nhe3;
    
    //update half edge faces
    ohe1.face = f1;
    ohe2.face = f2;
    ohe3.face = f3;
    
    nhe1.face = f1;
    nhe2.face = f1;
    
    nhe3.face = f2;
    nhe4.face = f2;
    
    nhe5.face = f3;
    nhe6.face = f3;
    
    faces.remove(inFace);
    //add faces to the faces list
    faces.add(f1);
    faces.add(f2);
    faces.add(f3);
  }
  Face findFace(Particle p){
    for(Face f : faces){
      if(f.contains(p)) return f;
    }
    return faces.get(0);
  }
  void update(){}
}

class Half_Edge{
  Vertex v1,v2;
  Face face;
  Half_Edge prev, next, twin;
  Edge ed;
  void draw(){
    line(v1.getX(),v1.getY(),v2.getX(),v2.getY());
  }
}

class Vertex{
  Particle p;
  Half_Edge edge;
  float getX(){return p.getX();}
  float getY(){return p.getY();}
  Vertex(Particle p, Half_Edge edge){
    this.p = p;
    this.edge = edge;
  }
}

class Face{
  Half_Edge edge;
  void draw(){
    stroke(0,0,256);
    edge.draw();
    stroke(256,0,0);
    edge.next.draw();
    stroke(0,256,0);
    edge.prev.draw();
    stroke(256);
  }
  Face(){}
  Face(Half_Edge edge){
    this.edge = edge;
  }
  boolean contains(Particle p){
    Particle p1 = edge.v1.p;
    Particle p2 = edge.next.v1.p;
    Particle p3 = edge.prev.v1.p;
    
    Edge ed1 = new Edge(p1,p2);
    Edge ed2 = new Edge(p2,p3);
    Edge ed3 = new Edge(p3,p1);

    boolean res = true;
    if(ed1.isRight(p1) || ed2.isRight(p2) || ed3.isRight(p3)) res = false;
    
    return res;
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
