class ParticleRandom extends Particle{
  void move(){
    v.x += randomGaussian()/2;
    v.y += randomGaussian()/2;
    super.move();
    v.x*=dampling;
    v.y*=dampling;
  }
  ParticleRandom(){
    super();
    dampling = 0.9;
  }
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
    circle(pos.x,pos.y,2*r);
  }
  Particle(){
    pos.x = 100;
    pos.y = 10;
    r = 5;
    v.x = random(4);
    v.y = random(4);
    m = 1;
  }
  boolean collidesWith(Particle p){
    if(pos.dist(p.pos) < (r+p.r)){
      return true;
    }
    return false;
  }
}
