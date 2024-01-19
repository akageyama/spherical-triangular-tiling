/*

 spherical_triangular_tiling.pde


 Developed
 - by Akira Kageyama (kage@port.kobe-u.ac.jp)
 - on 2024.01.19


 */


import peasy.PeasyCam;

PeasyCam cam;


final float PHI = ( 1 + sqrt(5.0) ) / 2;
final float RADIUS_TO_VERTS = sqrt( 1 + PHI*PHI );


// We alloate integer index from 0 to 20 to each vertex
// of a regular icosahedron.
//
//           3     3     3     3     3     
//          / \   / \   / \   / \   / \    
//         /   \ /   \ /   \ /   \ /   \    
//        1-----2-----4-----5-----11----1
//         \   / \   / \   / \   / \   / \
//          \ /   \ /   \ /   \ /   \ /   \
//           0----10-----6-----7-----9-----0
//            \   / \   / \   / \   / \   / 
//             \ /   \ /   \ /   \ /   \ /   
//              8     8     8     8     8          

final int TRIANGLE_0_1_2  = 0; 
final int TRIANGLE_1_2_3  = 1; 
final int TRIANGLE_2_3_4  = 2; 
final int TRIANGLE_2_4_10 = 3; 
final int TRIANGLE_0_2_10 = 4; 
final int TRIANGLE_1_9_11 = 5; 
final int TRIANGLE_1_3_11 = 6; 
final int TRIANGLE_3_5_11 = 7; 
final int TRIANGLE_3_4_5  = 8; 
final int TRIANGLE_4_5_6  = 9; 
final int TRIANGLE_4_6_10 = 10;
final int TRIANGLE_6_8_10 = 11;
final int TRIANGLE_0_8_10 = 12;
final int TRIANGLE_0_8_9  = 13;
final int TRIANGLE_0_1_9  = 14;
final int TRIANGLE_7_9_11 = 15;
final int TRIANGLE_5_7_11 = 16;
final int TRIANGLE_5_6_7  = 17;
final int TRIANGLE_6_7_8  = 18;
final int TRIANGLE_7_8_9  = 19;

final int EDGE_0_1  = 0;                                                                                       
final int EDGE_0_2  = 1;                                                                                       
final int EDGE_0_10 = 2;                                                                                       
final int EDGE_0_8  = 3;                                                                                       
final int EDGE_0_9  = 4;                                                                                       
final int EDGE_1_2  = 5;                                                                                       
final int EDGE_2_10 = 6;                                                                                       
final int EDGE_8_10 = 7;                                                                                       
final int EDGE_8_9  = 8;                                                                                       
final int EDGE_1_9  = 9;                                                                                       
                                                                                                               
final int EDGE_3_5  = 10;                                                                                      
final int EDGE_4_5  = 11;                                                                                      
final int EDGE_5_6  = 12;                                                                                      
final int EDGE_5_7  = 13;                                                                                      
final int EDGE_5_11 = 14;                                                                                      
final int EDGE_6_7  = 15;                                                                                      
final int EDGE_4_6  = 16;                                                                                      
final int EDGE_3_4  = 17;                                                                                      
final int EDGE_3_11 = 18;                                                                                      
final int EDGE_7_11 = 19;                                                                                      
                                                                                                               
final int EDGE_1_11 = 20;                                                                                      
final int EDGE_1_3  = 21;                                                                                      
final int EDGE_2_3  = 22;                                                                                      
final int EDGE_2_4  = 23;                                                                                      
final int EDGE_4_10 = 24;                                                                                      
final int EDGE_6_10 = 25;                                                                                      
final int EDGE_6_8  = 26;                                                                                      
final int EDGE_7_8  = 27;                                                                                      
final int EDGE_7_9  = 28;                                                                                      
final int EDGE_9_11 = 29;    
  
  
//GreatCircle gc  = new GreatCircle( 0.0,  1.0,  PHI );


GreatCircle[] gcs;

RegularIcosahedron icos;

final int NARCS_ICOS_EDGE = 30;
final int NARCS_ICOS_SURFACE_CENTER_TO_EDGE_CENTER = 6*20;
final int NARCS_TOTAL = NARCS_ICOS_EDGE + NARCS_ICOS_SURFACE_CENTER_TO_EDGE_CENTER;
Arc[] arcs;

float norma(float x) {
  float diameter_and_buffer = 2*PHI;
  float s = width / diameter_and_buffer;
  return s*x;
}

float mapx(float x) {
  return norma(x);
}

float mapy(float y) {
  return norma(y);
}

float mapz(float z) {
  return norma(-z); //<>//
}

  
float vector_amplitude( float vx, float vy, float vz ) {
  return sqrt( vx*vx + vy*vy + vz*vz );
}

  
float vector_amplitude( PVector v ) {
  return vector_amplitude( v.x, v.y, v.z );
}

PVector vector_cross_product( PVector a, PVector b ) {  
  PVector a_cross_b = new PVector( a.y * b.z - a.z * b.y,  
                                   a.z * b.x - a.x * b.z,
                                   a.x * b.y - a.y * b.x );
  return a_cross_b;                                   
}


void draw_cylinder( float cylinder_radius, PVector p0, PVector p1 )
{
    PVector origin = new PVector( 0, 0, 0 );
    
    PVector vec01 = new PVector( p1.x-p0.x, p1.y-p0.y, p1.z-p0.z );
    float length_vec01 = p0.dist( p1 );
    PVector vec01_normed = new PVector ( vec01.x / length_vec01, 
                                         vec01.y / length_vec01, 
                                         vec01.z / length_vec01 );
    PVector any_vector_that_is_not_parallel_to_xyz_axis = new PVector( 1/sqrt(3.0),
                                                                       1/sqrt(3.0),
                                                                       1/sqrt(3.0) );

    PVector vec_perp_to_vec01 = vector_cross_product( vec01_normed, any_vector_that_is_not_parallel_to_xyz_axis );
    float length_vec_perp_to_vec01 = origin.dist( vec_perp_to_vec01 );
    PVector vec_perp_to_vec01_normed = new PVector( vec_perp_to_vec01.x / length_vec_perp_to_vec01,
                                                    vec_perp_to_vec01.y / length_vec_perp_to_vec01,
                                                    vec_perp_to_vec01.z / length_vec_perp_to_vec01 );
    
    
    PVector another_perp_vector = new PVector( vec01_normed.y * vec_perp_to_vec01_normed.z
                                             - vec01_normed.z * vec_perp_to_vec01_normed.y,
                                               vec01_normed.z * vec_perp_to_vec01_normed.x
                                             - vec01_normed.x * vec_perp_to_vec01_normed.z,
                                               vec01_normed.x * vec_perp_to_vec01_normed.y
                                             - vec01_normed.y * vec_perp_to_vec01_normed.x );    
  
    // draw sides
    noStroke();
    //fill(150);
    
    // cylinder
    beginShape(TRIANGLE_STRIP);
    int sides = 12;
    for (int i = 0; i <= sides; i++) {
        float dx = vec_perp_to_vec01_normed.x * cos( ( TWO_PI / sides ) * i ) * cylinder_radius
                      + another_perp_vector.x * sin( ( TWO_PI / sides ) * i ) * cylinder_radius;
        float dy = vec_perp_to_vec01_normed.y * cos( ( TWO_PI / sides ) * i ) * cylinder_radius
                      + another_perp_vector.y * sin( ( TWO_PI / sides ) * i ) * cylinder_radius;
        float dz = vec_perp_to_vec01_normed.z * cos( ( TWO_PI / sides ) * i ) * cylinder_radius
                      + another_perp_vector.z * sin( ( TWO_PI / sides ) * i ) * cylinder_radius;
        vertex( mapx(p0.x+dx), mapy(p0.y+dy), mapz(p0.z+dz) );
        vertex( mapx(p1.x+dx), mapy(p1.y+dy), mapz(p1.z+dz) );    
    }
    endShape(CLOSE);
        
}


void draw_cylinder_and_cone( float cylinder_radius, PVector p0, PVector p1 )
{
    PVector vec01 = new PVector( p1.x-p0.x, p1.y-p0.y, p1.z-p0.z );
    float length_vec01 = p0.dist( p1 );
    PVector vec01_norm = new PVector ( vec01.x / length_vec01, vec01.y / length_vec01, vec01.z / length_vec01 );
    PVector some_vector_that_is_not_parallel_to_xyz_axis = new PVector( 1/sqrt(3.0),1/sqrt(3.0),1/sqrt(3.0) );
    PVector perp_to_vector_0_to_1 = new PVector( vec01_norm.y * some_vector_that_is_not_parallel_to_xyz_axis.z
                                               - vec01_norm.z * some_vector_that_is_not_parallel_to_xyz_axis.y,
                                                 vec01_norm.z * some_vector_that_is_not_parallel_to_xyz_axis.x
                                               - vec01_norm.x * some_vector_that_is_not_parallel_to_xyz_axis.z,
                                                 vec01_norm.x * some_vector_that_is_not_parallel_to_xyz_axis.y
                                               - vec01_norm.y * some_vector_that_is_not_parallel_to_xyz_axis.x );
    PVector another_perp_vector = new PVector( vec01_norm.y * perp_to_vector_0_to_1.z
                                             - vec01_norm.z * perp_to_vector_0_to_1.y,
                                               vec01_norm.z * perp_to_vector_0_to_1.x
                                             - vec01_norm.x * perp_to_vector_0_to_1.z,
                                               vec01_norm.x * perp_to_vector_0_to_1.y
                                             - vec01_norm.y * perp_to_vector_0_to_1.x );    
  
    
    //// cylinder    
    fill(150);
    draw_cylinder( cylinder_radius, p0, p1 );

    
    // cone
    float cone_height = length_vec01*0.1;
    float cone_radius = cylinder_radius*3.0;
    PVector center_of_cone_bottom = new PVector(p1.x - cone_height*0.5*vec01_norm.x,
                                                p1.y - cone_height*0.5*vec01_norm.y,
                                                p1.z - cone_height*0.5*vec01_norm.z );
    PVector cone_tip = new PVector( p1.x + cone_height*0.5*vec01_norm.x,
                                    p1.y + cone_height*0.5*vec01_norm.y,
                                    p1.z + cone_height*0.5*vec01_norm.z );
    
    beginShape(TRIANGLE_STRIP);
    int sides = 12;
    for (int i = 0; i <= sides; i++) {
        float dx = perp_to_vector_0_to_1.x * cos( ( TWO_PI / sides ) * i ) * cone_radius
                   + another_perp_vector.x * sin( ( TWO_PI / sides ) * i ) * cone_radius;
        float dy = perp_to_vector_0_to_1.y * cos( ( TWO_PI / sides ) * i ) * cone_radius
                   + another_perp_vector.y * sin( ( TWO_PI / sides ) * i ) * cone_radius;
        float dz = perp_to_vector_0_to_1.z * cos( ( TWO_PI / sides ) * i ) * cone_radius
                   + another_perp_vector.z * sin( ( TWO_PI / sides ) * i ) * cone_radius;
        vertex( mapx(center_of_cone_bottom.x+dx), 
                mapy(center_of_cone_bottom.y+dy), 
                mapz(center_of_cone_bottom.z+dz) );
        vertex( mapx(cone_tip.x), 
                mapy(cone_tip.y), 
                mapz(cone_tip.z) );    
    }
    endShape(CLOSE);
    
}


void draw_arrow(float x0, float y0, float z0, float x1, float y1, float z1) {
  pushMatrix();
    PVector p0 = new PVector ( x0, y0, z0 );
    PVector p1 = new PVector ( x1, y1, z1 );
    draw_cylinder_and_cone( 0.02, p0, p1 );
  popMatrix();    
  
}

void draw_axes_xyz() { //<>//
  draw_arrow( -1.4*RADIUS_TO_VERTS, 0, 0, 1.4*RADIUS_TO_VERTS, 0, 0);
  draw_arrow( 0, -1.4*RADIUS_TO_VERTS, 0, 0, 1.4*RADIUS_TO_VERTS, 0);
  draw_arrow( 0, 0, -1.4*RADIUS_TO_VERTS, 0, 0, 1.4*RADIUS_TO_VERTS);
}



void setup_arcs_icos_edge() {
  
  arcs = new Arc[NARCS_TOTAL];  
  
  arcs[EDGE_0_1]  = new Arc( icos.verts[ 1], icos.verts[ 1] );                                                   
  arcs[EDGE_0_2]  = new Arc( icos.verts[ 0], icos.verts[ 2] );                                                   
  arcs[EDGE_0_10] = new Arc( icos.verts[ 0], icos.verts[10] );                                                   
  arcs[EDGE_0_8]  = new Arc( icos.verts[ 0], icos.verts[ 8] );                                                   
  arcs[EDGE_0_9]  = new Arc( icos.verts[ 0], icos.verts[ 9] );                                                   
  arcs[EDGE_1_2]  = new Arc( icos.verts[ 1], icos.verts[ 2] );                                                   
  arcs[EDGE_2_10] = new Arc( icos.verts[ 2], icos.verts[10] );                                                   
  arcs[EDGE_8_10] = new Arc( icos.verts[ 8], icos.verts[10] );                                                   
  arcs[EDGE_8_9]  = new Arc( icos.verts[ 8], icos.verts[ 9] );                                                   
  arcs[EDGE_1_9]  = new Arc( icos.verts[ 1], icos.verts[ 9] );                                                   
                                                                                                                 
  arcs[EDGE_3_5]  = new Arc( icos.verts[ 5], icos.verts[ 3] );                                                   
  arcs[EDGE_4_5]  = new Arc( icos.verts[ 5], icos.verts[ 4] );                                                   
  arcs[EDGE_5_6]  = new Arc( icos.verts[ 5], icos.verts[ 6] );                                                   
  arcs[EDGE_5_7]  = new Arc( icos.verts[ 5], icos.verts[ 7] );                                                   
  arcs[EDGE_5_11] = new Arc( icos.verts[ 5], icos.verts[11] );                                                   
  arcs[EDGE_6_7]  = new Arc( icos.verts[ 7], icos.verts[ 6] );
  arcs[EDGE_4_6]  = new Arc( icos.verts[ 6], icos.verts[ 4] );
  arcs[EDGE_3_4]  = new Arc( icos.verts[ 4], icos.verts[ 3] );
  arcs[EDGE_3_11] = new Arc( icos.verts[ 3], icos.verts[11] );
  arcs[EDGE_7_11] = new Arc( icos.verts[11], icos.verts[ 7] );

  arcs[EDGE_1_11] = new Arc( icos.verts[11], icos.verts[ 1] );
  arcs[EDGE_1_3]  = new Arc( icos.verts[ 1], icos.verts[ 3] );
  arcs[EDGE_2_3]  = new Arc( icos.verts[ 3], icos.verts[ 2] );
  arcs[EDGE_2_4]  = new Arc( icos.verts[ 2], icos.verts[ 4] );
  arcs[EDGE_4_10] = new Arc( icos.verts[ 4], icos.verts[10] );
  arcs[EDGE_6_10] = new Arc( icos.verts[10], icos.verts[ 6] );
  arcs[EDGE_6_8]  = new Arc( icos.verts[ 6], icos.verts[ 8] );
  arcs[EDGE_7_8]  = new Arc( icos.verts[ 8], icos.verts[ 7] );
  arcs[EDGE_7_9]  = new Arc( icos.verts[ 7], icos.verts[ 9] );
  arcs[EDGE_9_11] = new Arc( icos.verts[ 9], icos.verts[11] );
}

void setup_arcs_icos_surface_center_to_edge_center() {
  int i = NARCS_ICOS_EDGE;
  
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_2], icos.verts[0] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_2], icos.verts[1] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_2], icos.verts[2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_2], icos.edgeCenters[EDGE_0_1] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_2], icos.edgeCenters[EDGE_1_2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_2], icos.edgeCenters[EDGE_0_2] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_2_10], icos.verts[0] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_2_10], icos.verts[2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_2_10], icos.verts[10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_2_10], icos.edgeCenters[EDGE_0_2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_2_10], icos.edgeCenters[EDGE_2_10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_2_10], icos.edgeCenters[EDGE_0_10] );
  

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_4_10], icos.verts[2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_4_10], icos.verts[4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_4_10], icos.verts[10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_4_10], icos.edgeCenters[EDGE_2_4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_4_10], icos.edgeCenters[EDGE_4_10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_4_10], icos.edgeCenters[EDGE_2_10] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_6_10], icos.verts[4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_6_10], icos.verts[6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_6_10], icos.verts[10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_6_10], icos.edgeCenters[EDGE_4_6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_6_10], icos.edgeCenters[EDGE_6_10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_6_10], icos.edgeCenters[EDGE_4_10] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_5_6], icos.verts[4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_5_6], icos.verts[5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_5_6], icos.verts[6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_5_6], icos.edgeCenters[EDGE_4_5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_5_6], icos.edgeCenters[EDGE_5_6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_4_5_6], icos.edgeCenters[EDGE_4_6] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_6_7], icos.verts[5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_6_7], icos.verts[6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_6_7], icos.verts[7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_6_7], icos.edgeCenters[EDGE_5_6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_6_7], icos.edgeCenters[EDGE_6_7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_6_7], icos.edgeCenters[EDGE_5_7] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_7_11], icos.verts[5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_7_11], icos.verts[7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_7_11], icos.verts[11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_7_11], icos.edgeCenters[EDGE_5_7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_7_11], icos.edgeCenters[EDGE_7_11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_5_7_11], icos.edgeCenters[EDGE_5_11] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_9_11], icos.verts[7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_9_11], icos.verts[9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_9_11], icos.verts[11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_9_11], icos.edgeCenters[EDGE_7_9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_9_11], icos.edgeCenters[EDGE_9_11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_9_11], icos.edgeCenters[EDGE_7_11] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_9_11], icos.verts[1] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_9_11], icos.verts[9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_9_11], icos.verts[11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_9_11], icos.edgeCenters[EDGE_1_9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_9_11], icos.edgeCenters[EDGE_9_11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_9_11], icos.edgeCenters[EDGE_1_11] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_9], icos.verts[0] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_9], icos.verts[1] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_9], icos.verts[9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_9], icos.edgeCenters[EDGE_0_1] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_9], icos.edgeCenters[EDGE_1_9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_1_9], icos.edgeCenters[EDGE_0_9] );

  // ---

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_2_3], icos.verts[1] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_2_3], icos.verts[2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_2_3], icos.verts[3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_2_3], icos.edgeCenters[EDGE_1_2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_2_3], icos.edgeCenters[EDGE_2_3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_2_3], icos.edgeCenters[EDGE_1_3] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_3_4], icos.verts[2] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_3_4], icos.verts[3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_3_4], icos.verts[4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_3_4], icos.edgeCenters[EDGE_2_3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_3_4], icos.edgeCenters[EDGE_3_4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_2_3_4], icos.edgeCenters[EDGE_2_4] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_4_5], icos.verts[3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_4_5], icos.verts[4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_4_5], icos.verts[5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_4_5], icos.edgeCenters[EDGE_3_4] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_4_5], icos.edgeCenters[EDGE_4_5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_4_5], icos.edgeCenters[EDGE_3_5] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_5_11], icos.verts[3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_5_11], icos.verts[5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_5_11], icos.verts[11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_5_11], icos.edgeCenters[EDGE_3_5] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_5_11], icos.edgeCenters[EDGE_5_11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_3_5_11], icos.edgeCenters[EDGE_3_11] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_3_11], icos.verts[1] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_3_11], icos.verts[3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_3_11], icos.verts[11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_3_11], icos.edgeCenters[EDGE_1_3] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_3_11], icos.edgeCenters[EDGE_3_11] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_1_3_11], icos.edgeCenters[EDGE_1_11] );

  // ---

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_9], icos.verts[0] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_9], icos.verts[8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_9], icos.verts[9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_9], icos.edgeCenters[EDGE_0_8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_9], icos.edgeCenters[EDGE_8_9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_9], icos.edgeCenters[EDGE_0_9] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_8_9], icos.verts[7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_8_9], icos.verts[8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_8_9], icos.verts[9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_8_9], icos.edgeCenters[EDGE_7_8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_8_9], icos.edgeCenters[EDGE_8_9] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_7_8_9], icos.edgeCenters[EDGE_7_9] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_7_8], icos.verts[6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_7_8], icos.verts[7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_7_8], icos.verts[8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_7_8], icos.edgeCenters[EDGE_6_7] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_7_8], icos.edgeCenters[EDGE_7_8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_7_8], icos.edgeCenters[EDGE_6_8] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_8_10], icos.verts[6] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_8_10], icos.verts[8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_8_10], icos.verts[10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_8_10], icos.edgeCenters[EDGE_6_8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_8_10], icos.edgeCenters[EDGE_8_10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_6_8_10], icos.edgeCenters[EDGE_6_10] );

  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_10], icos.verts[0] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_10], icos.verts[8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_10], icos.verts[10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_10], icos.edgeCenters[EDGE_0_8] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_10], icos.edgeCenters[EDGE_8_10] );
  arcs[i++] = new Arc( icos.surfaceCenters[TRIANGLE_0_8_10], icos.edgeCenters[EDGE_0_10] );  

}


void setup_arcs() {
  setup_arcs_icos_edge();
  setup_arcs_icos_surface_center_to_edge_center();
}

void setup() {
  size(800,800,P3D);
  background(255);
  frameRate(60);
  cam = new PeasyCam(this, 1850.0);
  
  icos = new RegularIcosahedron();

  gcs = new GreatCircle[12];

  setup_arcs();
  
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

  gcs[ 0] = new GreatCircle(  0.0, -PHI, +1.0 );
  gcs[ 1] = new GreatCircle( -1.0,  0.0, +PHI );
  gcs[ 2] = new GreatCircle( +1.0,  0.0, +PHI );
  gcs[ 3] = new GreatCircle(  0.0, +PHI, +1.0 );
  gcs[ 4] = new GreatCircle( +PHI, +1.0,  0.0 );
  gcs[ 5] = new GreatCircle(  0.0, +PHI, -1.0 );
  gcs[ 6] = new GreatCircle( +1.0,  0.0, -PHI );
  gcs[ 7] = new GreatCircle( -1.0,  0.0, -PHI );
  gcs[ 8] = new GreatCircle(  0.0, -PHI, -1.0 );
  gcs[ 9] = new GreatCircle( -PHI, -1.0,  0.0 );
  gcs[10] = new GreatCircle( +PHI, -1.0,  0.0 );
  gcs[11] = new GreatCircle( -PHI, +1.0,  0.0 );
  
  arcs[0] = new Arc( icos.verts[0], icos.verts[1] );
}


void draw() {
    background(255);
    lights();
    pointLight(200, 200, 200, 100, 100, 1000);
    pushMatrix();
      rotateX(PI);
      fill(255);
      sphere(mapx(RADIUS_TO_VERTS));
      //draw_axes_xyz();
      //icos.draw();
      for ( int i=0; i<NARCS_TOTAL; i++ ) {
        arcs[i].draw();
      }
    popMatrix();
}



void keyPressed() {
  switch (key) {
  case 's':
    save("snapshot.tif");
    break;
  }
}


//void keyReleased() {
//  switch (key) {
//  }
//}
