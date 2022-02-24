class DelaunayMesh{
  ArrayList<Face> faces;
  ArrayList<Half_Edge> half_edges;
  void draw(){
    for(Half_Edge half_edge: half_edges){
      if(half_edge.ed.a.r == 0)continue;
      if(half_edge.ed.b.r == 0)continue;      
      stroke(100,100,100,100);
      if((half_edge.length()<26))stroke(0);
      half_edge.draw();
    }
  }
  DelaunayMesh(Particle[] particles){
    initMesh();
    for(Particle p: particles){
      addParticle(p);
    }
    delonizate();
  }
  Particle[][] detectCollisions(){
    int numberOfCollisions = 0;
    for(Half_Edge half_edge: half_edges){
      Particle p1 = half_edge.ed.a;
      Particle p2 = half_edge.ed.b;
      if(p1.collidesWith(p2)) numberOfCollisions++;
    }
    Particle[][] collisions = new Particle[numberOfCollisions][2];
    int count = 0;
    for(Half_Edge half_edge: half_edges){
      Particle p1 = half_edge.ed.a;
      Particle p2 = half_edge.ed.b;
      if(p1.collidesWith(p2)){
        collisions[count][0] = p1;
        collisions[count][1] = p2;
      }
    }
    return collisions;
  }
  void delonizate(){
    if(faces.size()<=2)return;
    boolean someChanged = true;
    int count = 0;
    while(someChanged && count<30*faces.size()){
      someChanged = false;
      for(Half_Edge half_edge: half_edges){
        if(half_edge.twin == null) continue;
        if((half_edge.opAngle() + half_edge.twin.opAngle()) < PI-0.0001) continue;
        half_edge.flip();
        count++;
        someChanged = true;
      }
    }
  }
  void initMesh(){    
    faces = new ArrayList();
    half_edges = new ArrayList();
    
    //init particles
    Particle[] p = new Particle[5];
    p[1] = new StillParticle(0,0);
    p[2] = new StillParticle(0,height);
    p[3] = new StillParticle(width,height);
    p[4] = new StillParticle(width,0);
    
    //init half edges
    Half_Edge[] he = new Half_Edge[7];
    for(int i=1;i<7;i++){
      he[i] = new Half_Edge();
    }
    
    //init faces
    Face f1 = new Face();
    Face f2 = new Face();
    
    //set faces to half edges
    he[1].face = f1;
    he[5].face = f1;
    he[4].face = f1;
    
    he[2].face = f2;
    he[3].face = f2;
    he[6].face = f2;
    
    //set face's first half edge
    f1.edge = he[1];
    f2.edge = he[2];
    
    //set half edges neighbourhood
    he[1].next = he[5]; he[1].prev = he[4]; he[1].twin = null;
    he[2].next = he[3]; he[2].prev = he[6]; he[2].twin = null;
    he[3].next = he[6]; he[3].prev = he[2]; he[3].twin = null;
    he[4].next = he[1]; he[4].prev = he[5]; he[4].twin = null;
    he[5].next = he[4]; he[5].prev = he[1]; he[5].twin = he[6];
    he[6].next = he[2]; he[6].prev = he[3]; he[6].twin = he[5]; 
    
    //init half edge edges
    Edge[] ed = new Edge[7];
    ed[1] = new Edge(p[1],p[2]);
    ed[2] = new Edge(p[2],p[3]);
    ed[3] = new Edge(p[3],p[4]);
    ed[4] = new Edge(p[4],p[1]);
    ed[5] = new Edge(p[2],p[4]);
    ed[6] = new Edge(p[4],p[2]);
    
    //set half edge edges
    for(int i=1;i<7;i++){
      he[i].ed = ed[i];
    }
    
    //add half_edges to the list
    for(int i=1;i<7;i++){
      half_edges.add(he[i]);
    }
    
    faces.add(f1);faces.add(f2);
  }
  void addParticle(Particle np){
    Face inFace = findFace(np);
    if(inFace == null) return;
    
    //new faces
    Face f1 = new Face();
    Face f2 = new Face();
    Face f3 = new Face();
    
    //old half edges
    Half_Edge[] ohe = new Half_Edge[4];
    ohe[1] = inFace.edge;
    ohe[2] = inFace.edge.next;
    ohe[3] = inFace.edge.prev;
    
    //old particles
    Particle[] p = new Particle[4];
    p[1] = ohe[1].ed.a;
    p[2] = ohe[2].ed.a;
    p[3] = ohe[3].ed.a;
    
    //init new edges
    Edge[] ed = new Edge[7];
    ed[1] = new Edge(p[2],np);
    ed[2] = new Edge(np,p[1]);
    ed[3] = new Edge(p[3],np);
    ed[4] = new Edge(np,p[2]);
    ed[5] = new Edge(p[1],np);
    ed[6] = new Edge(np,p[3]);
    
    //init new half edges
    Half_Edge[] he = new Half_Edge[7];
    for(int i=1;i<7;i++) he[i] = new Half_Edge();
    
    //set edges to new half edges
    he[1].ed = ed[1];
    he[2].ed = ed[2];
    he[3].ed = ed[3];
    he[4].ed = ed[4];
    he[5].ed = ed[5];
    he[6].ed = ed[6];
    
    //update new half edges neighbourhouds
    he[1].next = he[2]; he[1].prev = ohe[1]; he[1].twin = he[4]; 
    he[2].next = ohe[1]; he[2].prev = he[1]; he[2].twin = he[5]; 
    he[3].next = he[4]; he[3].prev = ohe[2]; he[3].twin = he[6]; 
    he[4].next = ohe[2]; he[4].prev = he[3]; he[4].twin = he[1]; 
    he[5].next = he[6]; he[5].prev = ohe[3]; he[5].twin = he[2]; 
    he[6].next = ohe[3]; he[6].prev = he[5]; he[6].twin = he[3]; 
    
    //set new half edge faces
    he[1].face = f1;
    he[2].face = f1;
    he[3].face = f2;
    he[4].face = f2;
    he[5].face = f3;
    he[6].face = f3;
    
    //update old half edge neighbourhoud
    ohe[1].next = he[1]; ohe[1].prev = he[2];
    ohe[2].next = he[3]; ohe[2].prev = he[4];
    ohe[3].next = he[5]; ohe[3].prev = he[6];
    
    //set faces half edges
    f1.edge = ohe[1];
    f2.edge = ohe[2];
    f3.edge = ohe[3];
    
    faces.add(f1);
    faces.add(f2);
    faces.add(f3);
    
    for(int i=1;i<7;i++) half_edges.add(he[i]);
    
    faces.remove(inFace);
  }
  Face findFace(Particle p){
    for(Face f : faces){
      if(f.contains(p)) return f;
    }
    return null;
  }
  void update(){
    delonizate();
  }
}

class Half_Edge{
  Face face;
  Half_Edge prev, next, twin;
  Edge ed;
  void draw(){
    line(ed.a.getX(),ed.a.getY(),ed.b.getX(),ed.b.getY());
  }
  Half_Edge(){ //null constructor
    face = null;
    prev = null; 
    next = null; 
    twin = null;
    ed = null; 
  }
  float opAngle(){
    PVector v1 = new PVector(-this.next.ed.c.x,-this.next.ed.c.y);
    PVector v2 = new PVector( this.prev.ed.c.x, this.prev.ed.c.y);
    if((v1.mag()*v2.mag())==0)return 0;
    float res = acos(v1.dot(v2)/(v1.mag()*v2.mag()));
    return res;
  }
  void flip(){
    Half_Edge s1 = this.next;
    Half_Edge s2 = s1.next;
    Half_Edge s3 = this.twin.next;
    Half_Edge s4 = s3.next;
    
    Face f1 = this.face;
    Face f2 = this.twin.face;
    
    Particle p3 = s2.ed.a;
    Particle p4 = s4.ed.a;
    
    Edge ed1 = new Edge(p4,p3);
    Edge ed2 = new Edge(p3,p4);
    
    this.ed = ed1;
    this.twin.ed = ed2;
        
    this.next = s2; this.prev = s3; this.face = f1;
    this.twin.next = s4; this.twin.prev = s1; this.twin.face = f2;
    s1.next = this.twin; s1.prev = s4; s1.face = f2;
    s2.next = s3; s2.prev = this; s2.face = f1;
    s3.next = this; s3.prev = s2; s3.face = f1;
    s4.next = s1; s4.prev = this.twin; s4.face = f2;
  }
  float length(){
    return ed.length();
  }
}

class Face{
  Half_Edge edge;
  
  Face(){}
  Face(Half_Edge edge){
    this.edge = edge;
  }
  boolean contains(Particle p){
    Particle p1 = this.edge.ed.a;
    Particle p2 = this.edge.next.ed.a;
    Particle p3 = this.edge.next.next.ed.a;
    
    Edge ed1 = new Edge(p1,p2);
    Edge ed2 = new Edge(p2,p3);
    Edge ed3 = new Edge(p3,p1);

    boolean r1 = ed1.isRight(p);// || ed1.isOn(p);
    boolean r2 = ed2.isRight(p);// || ed2.isOn(p);
    boolean r3 = ed3.isRight(p);// || ed3.isOn(p);

    boolean res = false;
    if(r1 && r2 && r3) res = true;
    
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
    this.c = new PVector(-a.pos.x+b.pos.x,-a.pos.y+b.pos.y);
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
    float f = c.cross(new PVector(p.pos.x-a.pos.x,p.pos.y-a.pos.y)).z;
    if(f<0) return true;
    return false;
  }
  boolean isLeft(Particle p){ //<>//
    float f = c.cross(new PVector(p.pos.x-a.pos.x,p.pos.y-a.pos.y)).z;
    if(f>0) return true;
    return false;
  }
  boolean isOn(Particle p){
    float f = c.cross(new PVector(p.pos.x-a.pos.x,p.pos.y-a.pos.y)).z;
    if(f==0) return true;
    return false;
  }
  float length(){
    return c.mag();
  }
}
