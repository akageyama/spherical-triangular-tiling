class RegularIcosahedron 
{
  PVector[] verts = new PVector[12];
  PVector[] surfaceCenters = new PVector[20];
  PVector[] edgeCenters = new PVector[30];

  
  PVector average( PVector v1, PVector v2, PVector v3 ) {
    PVector answer = new PVector( (v1.x+v2.x+v3.x)/3,
                                  (v1.y+v2.y+v3.y)/3,
                                  (v1.z+v2.z+v3.z)/3 );
    return answer;                                  
  }

    
  PVector average( PVector v1, PVector v2 ) {
    PVector answer = new PVector( (v1.x+v2.x)/2,
                                  (v1.y+v2.y)/2,
                                  (v1.z+v2.z)/2 );
    return answer;                                  
  }

  
  void setVerts() {    
    // 木工模型にペンで書いた番号
    //vert01: {  0.0, -PHI, +1.0 }
    //vert02: { -1.0,  0.0, +PHI }
    //vert03: { +1.0,  0.0, +PHI }
    //vert04: {  0.0, +PHI, +1.0 }
    //vert05: { +PHI, +1.0,  0.0 }
    //vert06: {  0.0, +PHI, -1.0 } 
    //vert07: { +1.0,  0.0, -PHI } 
    //vert08: { -1.0,  0.0, -PHI } 
    //vert09: {  0.0, -PHI, -1.0 } 
    //vert10: { -PHI, -1.0,  0.0 } 
    //vert11: { +PHI, -1.0,  0.0 } 
    //vert12: { -PHI, +1.0,  0.0 } 

    verts[ 0] = new PVector(  0.0, -PHI, +1.0 );
    verts[ 1] = new PVector( -1.0,  0.0, +PHI );
    verts[ 2] = new PVector( +1.0,  0.0, +PHI );
    verts[ 3] = new PVector(  0.0, +PHI, +1.0 );
    verts[ 4] = new PVector( +PHI, +1.0,  0.0 );
    verts[ 5] = new PVector(  0.0, +PHI, -1.0 );
    verts[ 6] = new PVector( +1.0,  0.0, -PHI );
    verts[ 7] = new PVector( -1.0,  0.0, -PHI );
    verts[ 8] = new PVector(  0.0, -PHI, -1.0 );
    verts[ 9] = new PVector( -PHI, -1.0,  0.0 );
    verts[10] = new PVector( +PHI, -1.0,  0.0 );
    verts[11] = new PVector( -PHI, +1.0,  0.0 );
  }
  
  void setSurfaceCenters() {
    surfaceCenters[TRIANGLE_0_1_2]  = average( verts[0], verts[1], verts[2] );
    surfaceCenters[TRIANGLE_1_2_3]  = average( verts[1], verts[2], verts[3] );
    surfaceCenters[TRIANGLE_2_3_4]  = average( verts[2], verts[3], verts[4] );
    surfaceCenters[TRIANGLE_2_4_10] = average( verts[2], verts[4], verts[10] );
    surfaceCenters[TRIANGLE_0_2_10] = average( verts[0], verts[2], verts[10] );
    surfaceCenters[TRIANGLE_1_9_11] = average( verts[1], verts[9], verts[11] );
    surfaceCenters[TRIANGLE_1_3_11] = average( verts[1], verts[3], verts[11] );
    surfaceCenters[TRIANGLE_3_5_11] = average( verts[3], verts[5], verts[11] );
    surfaceCenters[TRIANGLE_3_4_5]  = average( verts[3], verts[4], verts[5] );
    surfaceCenters[TRIANGLE_4_5_6]  = average( verts[4], verts[5], verts[6] );
    surfaceCenters[TRIANGLE_4_6_10] = average( verts[4], verts[6], verts[10] );
    surfaceCenters[TRIANGLE_6_8_10] = average( verts[6], verts[8], verts[10] );
    surfaceCenters[TRIANGLE_0_8_10] = average( verts[0], verts[8], verts[10] );
    surfaceCenters[TRIANGLE_0_8_9]  = average( verts[0], verts[8], verts[9] );
    surfaceCenters[TRIANGLE_0_1_9]  = average( verts[0], verts[1], verts[9] );
    surfaceCenters[TRIANGLE_7_9_11] = average( verts[7], verts[9], verts[11] );
    surfaceCenters[TRIANGLE_5_7_11] = average( verts[5], verts[7], verts[11] );
    surfaceCenters[TRIANGLE_5_6_7]  = average( verts[5], verts[6], verts[7] );
    surfaceCenters[TRIANGLE_6_7_8]  = average( verts[6], verts[7], verts[8] );
    surfaceCenters[TRIANGLE_7_8_9]  = average( verts[7], verts[8], verts[9] );
  }


  void setEdgeCenters() {
    edgeCenters[EDGE_0_1]  = average( verts[ 0], verts[ 1] );
    edgeCenters[EDGE_0_2]  = average( verts[ 0], verts[ 2] );
    edgeCenters[EDGE_0_10] = average( verts[ 0], verts[10] );
    edgeCenters[EDGE_0_8]  = average( verts[ 0], verts[ 8] );
    edgeCenters[EDGE_0_9]  = average( verts[ 0], verts[ 9] );
    edgeCenters[EDGE_1_2]  = average( verts[ 1], verts[ 2] );
    edgeCenters[EDGE_2_10] = average( verts[ 2], verts[10] );
    edgeCenters[EDGE_8_10] = average( verts[ 8], verts[10] );
    edgeCenters[EDGE_8_9]  = average( verts[ 8], verts[ 9] );
    edgeCenters[EDGE_1_9]  = average( verts[ 1], verts[ 9] );
  
    edgeCenters[EDGE_3_5]  = average( verts[ 5], verts[ 3] );
    edgeCenters[EDGE_4_5]  = average( verts[ 5], verts[ 4] );
    edgeCenters[EDGE_5_6]  = average( verts[ 5], verts[ 6] );
    edgeCenters[EDGE_5_7]  = average( verts[ 5], verts[ 7] );
    edgeCenters[EDGE_5_11] = average( verts[ 5], verts[11] );
    edgeCenters[EDGE_6_7]  = average( verts[ 7], verts[ 6] );
    edgeCenters[EDGE_4_6]  = average( verts[ 6], verts[ 4] );
    edgeCenters[EDGE_3_4]  = average( verts[ 4], verts[ 3] );
    edgeCenters[EDGE_3_11] = average( verts[ 3], verts[11] );
    edgeCenters[EDGE_7_11] = average( verts[11], verts[ 7] );
  
    edgeCenters[EDGE_1_11] = average( verts[11], verts[ 1] );
    edgeCenters[EDGE_1_3]  = average( verts[ 1], verts[ 3] );
    edgeCenters[EDGE_2_3]  = average( verts[ 3], verts[ 2] );
    edgeCenters[EDGE_2_4]  = average( verts[ 2], verts[ 4] );
    edgeCenters[EDGE_4_10] = average( verts[ 4], verts[10] );
    edgeCenters[EDGE_6_10] = average( verts[10], verts[ 6] );
    edgeCenters[EDGE_6_8]  = average( verts[ 6], verts[ 8] );
    edgeCenters[EDGE_7_8]  = average( verts[ 8], verts[ 7] );
    edgeCenters[EDGE_7_9]  = average( verts[ 7], verts[ 9] );
    edgeCenters[EDGE_9_11] = average( verts[ 9], verts[11] );
  }
  
  RegularIcosahedron() {
    setVerts();
    setSurfaceCenters();
    setEdgeCenters();
  }
  
  void draw() {
    noStroke();
    fill(200,200,200,200);
    for ( int i=0; i<12; i++ ) {
      pushMatrix();
        float x = verts[i].x;
        float y = verts[i].y;
        float z = verts[i].z;
        translate( mapx(x), mapy(y), mapz(z) );
        sphere(20);        
      popMatrix();
    }
    
    //for ( int i=0; i<20; i++ ) {
    //  pushMatrix();
    //    float x = surfaceCenters[i].x;
    //    float y = surfaceCenters[i].y;
    //    float z = surfaceCenters[i].z;
    //    translate( mapx(x), mapy(y), mapz(z) );
    //    sphere(30);        
    //  popMatrix();
    //}
  }
}
