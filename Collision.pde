interface CollisionDetector{
  Particle[][] detectCollisions();
  void draw();
  void update();
}

class SimpleCollisionDetector implements CollisionDetector{
  Particle p[];
  SimpleCollisionDetector(Particle p[]){this.p = p;}
  Particle[][] detectCollisions(){
    int numCollisions = 0;
    for(int i=0;i<p.length;i++){
      for(int j=i;j<p.length;j++){
        if(p[i].collidesWith(p[j]))numCollisions++;
      }
    }
    Particle[][] res = new Particle[numCollisions][2];
    int colCounter = 0;
    for(int i=0;i<p.length;i++){
      for(int j=i;j<p.length;j++){
        if(p[i].collidesWith(p[j])){
          res[colCounter][0] = p[i];
          res[colCounter][1] = p[j];
          colCounter++;
        }
      }
    }
    return res;
  }
  void update(){};
  void draw(){};
}

class NullCollisionDetector implements CollisionDetector{
  NullCollisionDetector(){}
  Particle[][] detectCollisions(){
    return new Particle[0][2];
  }
  void update(){};
  void draw(){};
}

class GridCell{
  ArrayList<Particle> p;
  int x,y;
  int gridCellSize;
  GridCell(int x, int y, int gridCellSize){
    this.p = new ArrayList<Particle>();
    this.x = x;
    this.y = y;
    this.gridCellSize = gridCellSize;
  }
  void clear(){
    p.clear();
  }
  void add(Particle a){
    if(!p.contains(a))p.add(a);
  }
  void update(){
    ArrayList<Particle> toDel = new ArrayList<Particle>();
    for(Particle a: p){
      if(a.pos.x < x*gridCellSize || a.pos.x > (x+1)*gridCellSize){
        toDel.add(a);
      }
      if(a.pos.y < y*gridCellSize || a.pos.y > (y+1)*gridCellSize){
        toDel.add(a);
      }
    }
    for(Particle a: toDel){
      p.remove(a);
    }
  }
}

class GridCollisionDetector implements CollisionDetector {
  Particle p[];
  int gridCellSize;
  GridCell gcs[][];
  GridCollisionDetector(Particle p[], int gridCellSize){
    this.p = p;
    this.gridCellSize = gridCellSize;
    gcs = new GridCell[height/gridCellSize][width/gridCellSize];
    for(int i=0;i*gridCellSize<height;i++){
      for(int j=0;j*gridCellSize<width;j++){
        gcs[i][j] = new GridCell(i,j,gridCellSize);
      }
    }
  }
  Particle[][] detectCollisions(){
    for(int i=0;i*gridCellSize<height;i++){
      for(int j=0;j*gridCellSize<width;j++){
        gcs[i][j].update();
      }
    }
    for(Particle a: p){
      if(a.pos.x < width && a.pos.x >0 && a.pos.y<height && a.pos.y>0)
        gcs[int(a.pos.y/gridCellSize)][int(a.pos.x/gridCellSize)].add(a);
    }
    int[] dx = {-1,0,1,1,1,0,-1,-1};
    int[] dy = {1,1,1,0,-1,-1,-1,0};
    
    ArrayList<Particle[]> res = new ArrayList<Particle[]>();
    
    for(int i=0;i*gridCellSize<height;i+=2){
      for(int j=0;j*gridCellSize<width;j+=2){
        ArrayList<Particle> toCollide = gcs[i][j].p;
        for(int k=0;k<8;k++){
          if(i+dx[k]>=0 && (i+dx[k])*gridCellSize<width && j+dy[k]>=0 && (j+dy[k])*gridCellSize<height){
            toCollide.addAll(gcs[i+dx[k]][j+dy[k]].p);
          }
        }
        for(int ii=0;ii<toCollide.size();ii++){
          for(int jj=ii+1;jj<toCollide.size();jj++){
            if(toCollide.get(ii).collidesWith(toCollide.get(jj))){
              Particle[] a = {toCollide.get(ii),toCollide.get(jj)};
              res.add(a);
            }
          }
        }
      }
    }
    
    Particle[][] a = new Particle[res.size()][2];
    for(int i=0;i<res.size();i++){
      a[i][0] = res.get(i)[0];
      a[i][1] = res.get(i)[1];
    }
    return a;
    //return super.detectCollisions();
    }
  void update(){};
  void draw(){
    stroke(40);
    for(int i=0;i*gridCellSize<height;i++){
      line(0,i*gridCellSize,width,i*gridCellSize);
    }
    for(int i=0;i*gridCellSize<width;i++){
      line(i*gridCellSize,0,i*gridCellSize,height);
    }
  }
}
