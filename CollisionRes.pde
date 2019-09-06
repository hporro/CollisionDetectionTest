class CollisionRes{
  CollisionRes(){}
  void resolveCollisions(Particle[][] collisions){
    for(Particle[] collision: collisions){
      Particle p0 = collision[0];
      Particle p1 = collision[1];
      if(p0==null || p1==null) continue;
      if(!p0.collidesWith(p1))continue;
      PVector contactNormal = new PVector(p0.pos.x-p1.pos.x,p0.pos.y-p1.pos.y).normalize();
      float separationVelocity = (p0.v.x-p1.v.x)*contactNormal.x + (p0.v.y-p1.v.y)*contactNormal.y;
      float delta_velocity = -0.49*separationVelocity;
      float impulse = delta_velocity*(p0.m+p1.m);
      PVector imp_per_mass = new PVector(contactNormal.x*impulse,contactNormal.y*impulse);
      p0.v = new PVector(p0.v.x+imp_per_mass.x/p1.m,p0.v.y+imp_per_mass.y/p1.m);
      p1.v = new PVector(p1.v.x-imp_per_mass.x/p0.m,p1.v.y-imp_per_mass.y/p0.m);
      p0.pos.add(contactNormal);
      p1.pos.sub(contactNormal);
    }
  }
}
