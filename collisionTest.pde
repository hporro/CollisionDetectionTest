Particle c[];
int numParticles = 0;
CollisionDetector cd;
CollisionRes cr;

void draw(){
  background(0);
  cr.resolveCollisions(cd.detectCollisions());
  for(Particle p: c){
    p.move();
  }
  cd.update();
  cd.draw();
  for(Particle p: c){
      p.draw();
  }
  if(keyPressed){
    if(key=='g'){
      cd = new GridCollisionDetector(c,40);
    }
    if(key=='s'){
      cd = new SimpleCollisionDetector(c);
    }
    if(key == 'd'){
      cd = new DelanuayCollisionDetector(c);
    }
    if(key == 'n'){
      cd = new NullCollisionDetector();
    }
  }
}

void keyPressed(){
  if(key == 'a'){
    Particle[] ps = new Particle[c.length+1];
    for(int i=0;i<c.length;i++)ps[i]=c[i];
    ps[c.length] = new StillParticle();
    c = ps;
  }
}

void setup(){
  size(600,600);
  c = new Particle[numParticles];
  for(int i=0;i<numParticles;i++){
    c[i] = new StillParticle();
  }
  // change here the type of cd to use a different collision detect algorithm
  cd = new GridCollisionDetector(c,40);
  //cd = new DelanuayCollisionDetector(c);
  // change here the type of cr to use a different collision resolution algorithm
  // for now there's only one algorithm implemented for collision resolution
  cr = new CollisionRes();
}
