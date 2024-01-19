class GreatCircle
{    
  
  //
  // This class is not used at the moment.
  //

  final int NDIV = 100;
  final int NDIVP1 = NDIV + 1;
  
  PVector[] points;

    
  GreatCircle( float normal_vect_x, float normal_vect_y, float normal_vect_z ) {
    
    float reference_vect_x = 1.23;  // any vector is OK.
    float reference_vect_y = 2.34;
    float reference_vect_z = 3.45;
        
    float cross_product_x = reference_vect_y * normal_vect_z 
                          - reference_vect_z * normal_vect_y;
    float cross_product_y = reference_vect_z * normal_vect_x 
                          - reference_vect_x * normal_vect_z;
    float cross_product_z = reference_vect_x * normal_vect_y 
                          - reference_vect_y * normal_vect_x;

    float cross_product_amp = vector_amplitude( cross_product_x, 
                                                cross_product_y, 
                                                cross_product_z );

    final float TOO_SMALL = 1.e-10;
    
    if ( cross_product_amp < TOO_SMALL ) {
      println( "Normal vector and reference vector are parallel?" );
      // Do nothing.
      return;         
    }

    //                  z
    //                  |
    //                  |             
    //   reference_vect |    y           vect_v
    //              .   |   /           .
    //               .  |  /        .
    //                . | /     .
    //                 .|/  .
    //                  o-------------->x
    //                 .  
    //                .     
    //               .        
    //            vect_u
    
                       
    float unit_vect_u_x = cross_product_x / cross_product_amp;          
    float unit_vect_u_y = cross_product_y / cross_product_amp;          
    float unit_vect_u_z = cross_product_z / cross_product_amp;          

        
    cross_product_x = normal_vect_y * unit_vect_u_z 
                    - normal_vect_z * unit_vect_u_y;
    cross_product_y = normal_vect_z * unit_vect_u_x 
                    - normal_vect_x * unit_vect_u_z;
    cross_product_z = normal_vect_x * unit_vect_u_y 
                    - normal_vect_y * unit_vect_u_x;

    cross_product_amp = vector_amplitude( cross_product_x, 
                                          cross_product_y, 
                                          cross_product_z );
                       
    float unit_vect_v_x = cross_product_x / cross_product_amp;          
    float unit_vect_v_y = cross_product_y / cross_product_amp;          
    float unit_vect_v_z = cross_product_z / cross_product_amp;          

    points = new PVector[NDIVP1];
        
    for (int i=0; i<NDIVP1; i++) {
             
         //  o------------------ unit_vector_v 
         //  | ..
         //  |  . .
         //  |   .  .
         //  |    .   angle1
         //  |     .
         //  |     angle0
         //  |
         // unit_vector_u
      
      float angle = TWO_PI / NDIV * i;
      float point_x = cos(angle)*unit_vect_u_x + sin(angle)*unit_vect_v_x; 
      float point_y = cos(angle)*unit_vect_u_y + sin(angle)*unit_vect_v_y; 
      float point_z = cos(angle)*unit_vect_u_z + sin(angle)*unit_vect_v_z;
      
      points[i] = new PVector( point_x, point_y, point_z);
    }  
  }
  
  void draw() {      
    for ( int i=0; i<NDIV; i++ ) {
      draw_cylinder( 0.01, points[i], points[i+1] );      
    }
  }
}
