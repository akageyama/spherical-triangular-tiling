class Arc
{   
  //
  // Spherical arc, a part of great circle.
  //
  final int NDIV = 100;
  final int NDIVP1 = NDIV + 1;

  PVector[] verts = new PVector[NDIVP1];
    
  Arc( PVector p1_, PVector p2_ ) {
    
    PVector p1 = p1_.copy();
    PVector p2 = p2_.copy();

    p1.normalize();
    p2.normalize();
    
    for (int i=0; i<=NDIV; i++) {
      float alpha = float(i) / NDIV; // interpoation_ratio; 0 to 1. 
      float beta  = 1.0 - alpha;
      PVector interpol = new PVector( alpha*p1.x + beta*p2.x,
                                      alpha*p1.y + beta*p2.y,
                                      alpha*p1.z + beta*p2.z );
      verts[i] = interpol.normalize().mult( RADIUS_TO_VERTS );
    }
                                   
  }
  
  void draw() {
    fill( 0, 100, 200 );
    for (int i=0; i<NDIV; i++) {
      draw_cylinder( 0.02, verts[i], verts[i+1] );
    }
  }
    

}
