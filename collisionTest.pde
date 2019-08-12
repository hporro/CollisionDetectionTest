Particle c[];
int numParticles = 20;
CollisionDetector cd;
CollisionRes cr;

void draw(){
  background(0);
  cr.resolveCollisions(cd.detectCollisions());
  for(Particle p: c){
    p.move();
  }
  cd.draw();
  for(Particle p: c){
      p.draw();
  }
}

void setup(){
  size(400,400);
  c = new Particle[numParticles];
  for(int i=0;i<numParticles;i++){
    c[i] = new Particle();
    c[i].pos.x = random(width);
    c[i].pos.y = random(height);
    c[i].r = 20;
    c[i].v.x = random(2);
    c[i].v.y = random(2);
  }
  cd = new GridCollisionDetector(c,40);
  cr = new CollisionRes();
}
