Particle c[];
int numParticles = 26*4;
CollisionDetector cd;
CollisionRes cr;
boolean pause = true;


void draw(){
  background(255);
  
  //collision handling
  if(!pause){
    cr.resolveCollisions(cd.detectCollisions());
    for(Particle p: c){
      p.move();
    }
    cd.update();
  }

  fill(20,20,250,125);
  stroke(20,20,250,125);
  circle(c[60].pos.x,c[60].pos.y,100);
  
  //drawing
  cd.draw();
  for(Particle p: c){
    p.draw();
  }
  
  if(keyPressed){
    if(key=='g'){
      cd = new GridCollisionDetector(c,100);
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
  
  fill(20,20,250);
  stroke(0);
  circle(c[60].pos.x,c[60].pos.y,2*c[60].r);
  
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
  c = new Particle[108];
  int particleCount = 0;
  
  float rad = 4;
  
  float x_init = 130;
  float y_init = 170;
  
  float dx = 16;
  float dy = 16;
  
  // E
  for(int i=0;i<10;i++){
    c[particleCount] = new Particle(x_init + random(1),y_init + (rad+dy)*i, rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + rad + dx, y_init + (rad+dy)*i, rad); particleCount++;
  }
  for(int i=0;i<6;i++){
    c[particleCount] = new Particle(x_init + random(1) + (i+2)*(rad + dx),y_init, rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+2)*(rad + dx),y_init + rad+ dy, rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+2)*(rad + dx),y_init + 8*(rad+dy), rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+2)*(rad + dx),y_init + 9*(rad+dy), rad); particleCount++;
  }
  for(int i=0;i<4;i++){
    c[particleCount] = new Particle(x_init + random(1) + (i+2)*(rad + dx),y_init + 4*(rad+dy), rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+2)*(rad + dx),y_init + 5*(rad+dy), rad); particleCount++;
  }
  
  // G
  for(int i=0;i<10;i++){
    c[particleCount] = new Particle(x_init + random(1) + 10*(rad + dx),y_init + (rad+dy)*i, rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + 11*(rad + dx),y_init + (rad+dy)*i, rad); particleCount++;
  }  
  for(int i=0;i<6;i++){
    c[particleCount] = new Particle(x_init + random(1) + (i+12)*(rad + dx),y_init, rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+12)*(rad + dx),y_init + rad+ dy, rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+12)*(rad + dx),y_init + 8*(rad+dy), rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+12)*(rad + dx),y_init + 9*(rad+dy), rad); particleCount++;
  }
  for(int i=0;i<4;i++){
    c[particleCount] = new Particle(x_init + random(1) + (i+14)*(rad + dx),y_init + 4*(rad+dy), rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+14)*(rad + dx),y_init + 5*(rad+dy), rad); particleCount++;
  }
  for(int i=0;i<2;i++){
    c[particleCount] = new Particle(x_init + random(1) + (i+16)*(rad + dx),y_init + 6*(rad+dy), rad); particleCount++;
    c[particleCount] = new Particle(x_init + random(1) + (i+16)*(rad + dx),y_init + 7*(rad+dy), rad); particleCount++;
  }
  
  // change here the type of cd to use a different collision detect algorithm
  cd = new DelanuayCollisionDetector(c);
  //cd = new DelanuayCollisionDetector(c);
  // change here the type of cr to use a different collision resolution algorithm
  // for now there's only one algorithm implemented for collision resolution
  cr = new CollisionRes();
}
