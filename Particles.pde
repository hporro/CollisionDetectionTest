class RandomParticle extends Particle{
  void move(){
    v.x += randomGaussian()/2;
    v.y += randomGaussian()/2;
    super.move();
    v.x*=dampling;
    v.y*=dampling;
  }
  RandomParticle(){
    super();
    dampling = 0.9;
  }
}

class StillParticle extends Particle{
  void move(){}
  boolean collidesWith(Particle p){return false;}
  StillParticle(){
    super();
    this.r = 0;
  }
  StillParticle(float x, float y){
    super(x,y);
    this.v = new PVector(0,0);
    this.r = 0;
    this.m = 1;
  }
  void draw(){}
}

class Particle{
  PVector pos = new PVector(0,0);
  PVector v = new PVector(0,0);
  float r;
  float dampling;
  float m;
  void move(){
    if((pos.x-r<0) || (pos.x+r>width)){
      v.x *= -1;
      if(pos.x-r<0){
        pos.x = r-v.x;
      }
      if(pos.x+r>width){
        pos.x = width-r-v.x;
      }
    }
    if((pos.y-r<0) || (pos.y+r>height)){
      v.y *= -1;
      if(pos.y-r<0){
        pos.y = r-v.y;
      }
      if(pos.y+r>height){
        pos.y = height-r-v.y;
      }
    }
    pos.x+=v.x;
    pos.y+=v.y;
  }
  void draw(){
    fill(231,45,54);
    stroke(221,35,44);
    circle(pos.x,pos.y,2*r);
  }
  Particle(){
    r = 10;
    pos.x = random(r,width-r);
    pos.y = random(r,height-r);
    v.x = random(1);
    v.y = random(1);
    m = 1;
  }
  Particle(float x, float y){
    pos.x = x;
    pos.y = y;
    r = 10;
    v.x = random(5);
    v.y = random(5);
    m = 1;
  }
  Particle(float x, float y, float rad){
    pos.x = x;
    pos.y = y;
    r = rad;
    v.x = random(5);
    v.y = random(5);
    m = 1;
  }
  boolean collidesWith(Particle p){
    if(pos.dist(p.pos) < (r+p.r)){
      return true;
    }
    return false;
  }
  float getX(){return pos.x;}
  float getY(){return pos.y;}
}
