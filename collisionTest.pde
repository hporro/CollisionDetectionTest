Particle c[];
int numParticles = 10;
CollisionDetector cd;
CollisionRes cr;
boolean pause = false;

void draw(){
  background(0);
  
  //collision handling
  if(!pause){
    cr.resolveCollisions(cd.detectCollisions());
    for(Particle p: c){
      p.move();
    }
    cd.update();
  }
  
  //drawing
  cd.draw();
  for(Particle p: c){
    p.draw();
  }
  
  if(keyPressed){
    if(key=='g'){
      cd = new GridCollisionDetector(c,20);
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
    ps[c.length] = new Particle();
    c = ps;
    cd.reset(c);
  }
  if(key == 'p'){
    pause=!pause;
  }
  if(key == 'r'){
    for(Particle p: c){
      p.v.x = -p.v.x;
      p.v.y = -p.v.y;
    }
  }
  if(key == 'c'){
    System.out.println(c.length);
  }
}

void setup(){
  size(600,600);
  c = new Particle[numParticles];
  for(int i=0;i<numParticles;i++){
    c[i] = new Particle();
  }
  // change here the type of cd to use a different collision detect algorithm
  cd = new GridCollisionDetector(c,20);
  //cd = new DelanuayCollisionDetector(c);
  // change here the type of cr to use a different collision resolution algorithm
  // for now there's only one algorithm implemented for collision resolution
  cr = new CollisionRes();
}
