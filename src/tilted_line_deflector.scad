include <parameters.scad>
use <util.scad>


// Investigate layers
//difference(){
//  horizontal_line_deflector();
//  translate([0,0,72.0])
//  cube(100,center=true);
//}

module slanted_lines_for_aiming(liney=0){
  line_from_to([103, liney, 9.5], [0, liney, 9.5], r=1.1);
  line_from_to([-b623_vgroove_small_r*sin(30), -(liney+b623_vgroove_small_r*(1-cos(30))), 9.5],
               [0, -liney, 9.5] + [cos(120)*100, -sin(120)*100, 130],
               r=1.1);
}

tilted_line_deflector(rot=-atan(sqrt(2))); // Angle atan(sqrt(2)) works if ABCD anchors form like sided tetrahedron
//tilted_line_deflector(rot=0);
module tilted_line_deflector(twod=false, rot=0){
  cx = b623_vgroove_big_r*2 + 7;
  cy = Horizontal_deflector_cube_y_size;
  bz = Gap_between_sandwich_and_plate + Sep_disc_radius - Spool_r;
  bit_y = cy;

  pl = 5.5;
  ybit = -cy+5+bit_y/2;
  ybit_hole = ybit + 4;
  module bit(){
    rotate([0,0,90])
      translate([-Bit_width/2, -bit_y/2, 0])
      difference(){
        one_rounded_cube2([Bit_width+4,bit_y,Base_th], 5.5, $fn=28);
      }
  }

  if(!twod){
    extra_b_height = 1.3; // half of this above, half below
    extra_b_width = 1.5; // half of this to the left of bearing
    full_h = bz+8-b623_vgroove_big_r*sin(rot);
    take_away_angle = 90;

    // something to aim for
    %translate([0, 0 ,bz])
      rotate([rot,0,0])
        translate([0,-b623_vgroove_small_r,0])
          b623_vgroove();
    difference(){
      union(){
        translate([-cx/2, -cy+5, 0])
          ydir_rounded_cube2([cx, cy, full_h], 3, $fn=4*6);
        for(k=[0,1])
          mirror([k,0,0]){
            difference(){
              union(){
                translate([6,3,0])
                  cube([2, 2, Base_th*2]);
                translate([cx/2,-cy+5,Base_th])
                  rotate([0,-90,-90])
                  inner_round_corner(r=2, h=cy, $fn=4*5, back=Base_th-0.1);
                translate([cx/2+pl,ybit,0])
                  rotate([0,0,90])
                  bit();
              }
              translate([cx/2,5,Base_th])
                corner_rounder();
              translate([cx/2+pl,ybit_hole,0.5])
                Mounting_screw_countersink();
            }
          }

      }
      translate([0,0,bz]){
        rotate([rot,0,0])
          translate([0,-b623_vgroove_small_r-1,0])
            scale([(b623_vgroove_big_r+extra_b_width/2)/b623_vgroove_big_r,
                (b623_vgroove_big_r+extra_b_width/2)/b623_vgroove_big_r,
                (b623_width + extra_b_height)/b623_width]){
              elong_b623_vgroove(20);
            }
      }
      translate([0,0,bz]){
        rotate([rot,0,0]){
          translate([0,-b623_vgroove_small_r,-1-bz]){
            cylinder(d=3.3, h=100, center=true, $fn=12); // The M3 screw
            translate([0,0,-10])
              nut(h=bz+1-b623_width/2-extra_b_height/2 + 5);
            translate([0,0,full_h - 1.5 + 3*sin(rot)])
              nut(h=10);
          }
        }
      }
      sly = 40;
      for(k=[0,1]) mirror([k,0,0])
      translate([b623_vgroove_small_r,0,bz])
      hull(){
        rotate([rot,0,0])
          translate([0,-sly,-2.5/2])
            cube([100,sly, 2.5]);
        rotate([rot+rot*0.05,0,0])
          translate([0,-sly,-2.5/2])
            cube([100,sly, 2.5]);
        rotate([rot-rot*0.05,0,0])
          translate([0,-sly,-2.5/2])
            cube([100,sly, 2.5]);
      }
    }

    shoulder_height = extra_b_height/2;
    for(hl=[-(b623_width+extra_b_height)/2-2+shoulder_height,
        (b623_width+extra_b_height)/2 - shoulder_height])
      translate([0, 0, bz])
        rotate([rot,0,0])
          translate([0,-b623_vgroove_small_r,hl])
            difference(){
              cylinder(d=5, h=2, $fn=12);
                translate([0,0,-1])
                  cylinder(d=3.3, h=4, $fn=12); // The ring to rest b623_vgroove bore on
            }

  } else { //twod
    difference(){
      translate([-cx/2-Bit_width+0.5, -cy+5])
        ydir_rounded_cube2_2d([cx+2*Bit_width-1, cy], 5.5, $fn=28);
      for(k=[0,1])
        mirror([k,0])
          translate([cx/2+pl,ybit_hole])
            Mounting_screw_countersink(twod=true);
    }
  }
}

