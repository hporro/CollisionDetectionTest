class DelanuayCollisionDetector implements CollisionDetector{
  Particle[] p;
  Mesh ms;
  DelanuayCollisionDetector(Particle[] p){
    this.p = p;
    this.ms = new Mesh(p);
  }
  void update(){
    ms.update();
  }
  Particle[][] detectCollisions(){
    update();
    return new Particle[0][0];
  }
  void draw(){
    ms.draw();
  }
}
