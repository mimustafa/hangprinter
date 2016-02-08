include <measured_numbers.scad>
include <util.scad>
include <design_numbers.scad>
include <rendering_control.scad>
use <Nema17_and_Ramps_and_bearings.scad>
use <Gears.scad>
use <render_parts.scad>

module fish_ring(screw_offset = 10){
  $fn = 15;
  // Measured numbers
  hol_h  = 1.57;
  ins_ro = 4.90/2;
  edg_r  = 6.50/2;
  lar_ri = 3.00/2;
  hol_r1 = 5.86/2;
  hol_r2 = 5.42/2;
  trdist = cdist + lar_ro;
  // Bring action point to origo
  translate([0,-ins_ri,0])
  difference(){
    union(){
      color("black")
        cylinder(r=ins_ro, h=ins_h, center=true);  // Inside ring (cheramic)
      color("grey")
        cylinder(r=edg_r, h=edg_h, center=true);
      translate([0,0,-edg_h/2])
      color("grey")
      linear_extrude(height=edg_h, slices=1)
        polygon(points = [tangent_point(edg_r, [0,-trdist]),
                          tangent_point_3(edg_r, [0,-trdist]),
                          [0,-trdist]],
                paths = [[0,1,2]]);
      translate([0,-cdist,0]){
        color("black")
          translate([0,0,lar_h/4])
          cylinder(r=lar_ro, h=lar_h, center=true);
        color("grey")
          cylinder(r=hol_r1, h=edg_h, center=true);
        color("grey")
          cylinder(r=hol_r2, h=hol_h-edg_h/2);
      }
    }
    // The two holes (ceramic and lar ring)
    cylinder(r=ins_ri, h=ins_h+2, center=true);
    translate([0,-cdist,0])
      cylinder(r=lar_ri, h=lar_h*2, center=true);
  }
  if(Render_screws){
    color(Screw_color_2)
    translate([0,-cdist-1.5,-screw_offset]){
      M3_screw(10+screw_offset, center=true);
      translate([0,0,screw_offset+5])
      M3_screw(2);
    }
  }
}
//fish_ring();

module placed_fish_rings(){
  for(i=[0,1,2]){
    rotate([0,0,120*i]){
      for(k=[0,1])
        mirror([k,0,0])
          translate(Line_contact_abc_xy
            + [0,0, Line_contacts_abcd_z[i] + ins_ri + ins_ri/sqrt(2)])
          rotate([90,0,fish_ring_abc_rotation])
          translate([-ins_ri/sqrt(2),0,0])
          mirror([0,0,1])
          fish_ring(6);
    }
  }
  // D-lines' fish rings
  for(i=[0,1,2]){
    rotate([0,0,120*i])
      translate(Line_contact_d_xy + [0, 0, Line_contacts_abcd_z[D]])
      rotate([fish_ring_d_rotation,0,0])
      fish_ring(11);
  }
}
//placed_fish_rings();


//** bottom_plate start **//

// TODO: reason for using children(0) instead of just children() here?
// Assumes children(0) is centered in xy-plane
// A little odd that reference translation is along y...
// Used for XY and Z motors
// Needed here to get screw holes right
module four_point_translate(){
  radius = Four_point_five_point_radius;
  for(i=[72:72:359]){
    rotate([0,0,i]) translate([0,radius,0]) children(0);
  }
}

// Needed here to get screw holes right
module extruder_motor_translate(extruder_twist = 12){
  radius = Four_point_five_point_radius + 5;
  translate([0, radius, -Nema17_screw_hole_dist/2 // z-center screwhole
                        +Bottom_plate_thickness/2
                        +E_motor_z_offset])
    rotate([0, 0, extruder_twist])
      translate([0, -Nema17_cube_height, 0])
        rotate([90,0,0])
          translate([0, 0, -3*Nema17_cube_height/2 - 2]) children();
}

// The thing separating bearings on center axis of bottom plate
module lock(r1, r2, height){
  difference(){
    cylinder(r=r2, h=height);
    translate([0,0,-1])
      cylinder(r=r1, h=height+2);
  }
}
//lock(Lock_radius_1, Lock_radius_2, Lock_height);

module bottom_plate(){
  // Global variables renamed short
  cw  = Nema17_cube_width;
  th  = Bottom_plate_thickness;
  bpr = Bottom_plate_radius;
  bd  = Bearing_608_bore_diameter;
  bw  = Bearing_608_width;
  swh = Sandwich_height;
  gap = Sandwich_gap;
  sandwich_stick_height = Line_contacts_abcd_z[A]+swh-Snelle_height/2
    + 5; // for putting some kind of top lock mechanism

  difference(){
    color(Printed_color_1){
      union(){
        // Largest possible triangular plate
        eq_tri(Full_tri_side, th);
        // Circular bottom plate
        cylinder(r=bpr, h = th);

        // Sandwich stick
        cylinder(r=bd/2+0.16,
            h=sandwich_stick_height);

        // The bottom lock
        cylinder(r=Lock_radius_2, h=th + Bottom_plate_sandwich_gap);

        // Mounting towers for abc fish rings
        for(i=[0,1,2]){
          rotate([0,0,120*i]){
            for(k = [0, 1]){
              mirror([k,0,0]){
                translate(Line_contact_abc_xy)
                  rotate([0,0,fish_ring_abc_rotation])
                  translate([-6-ins_ri , -edg_h/2+0.01,0])
                  cube([12,5.5,Line_contacts_abcd_z[i] - ins_ri]);
              }
            }
          }
        }

        // Bluetooth mount (and autocooling while printing tower)
        translate(Line_action_point_abc_xy)
          cube([4,4,sandwich_stick_height]);

        // Block to insert d stopper screw
        translate([Sandwich_radius+2,-20,0])
          rotate([0,0,25])
          translate([0,-0.5,0])
          cube([11,8,th+Sandwich_height+Bottom_plate_sandwich_gap+3]);
      } // End union
    }


    //*** ANTIMATERIA STARTS HERE ***//

    // Nyloc nut lock for d stopper screw
    translate([Sandwich_radius+6,-16.5,th+1.5+Sandwich_edge_thickness+Snelle_height+0.5]){
      rotate([-90,0,25])
        translate([1,0,-10])
        M3_screw(25);
      rotate([0,90,25])
        translate([-5.52/2,0,-5]){
          point_cube([5.52,4.1,12],120);
          translate([3.53/2,0,-1])
            cube([2,4.1,12]);
        }
    }


    // top fastening sandwich stick
    for(k=[1,-1])
      translate([k*2,0,Line_contacts_abcd_z[A]+swh-Snelle_height/2+2.5])
        rotate([90,0,0])
        cylinder(r=1, h=10, center=true);

    // Tracks to put fish rings in
    placed_fish_rings();

    // Mounting space for d fish_rings
    big=5*th;
    for(i=[0,1,2]){
      rotate([0,0,120*i]){
        translate(Line_contact_d_xy + [0, 0, Line_contacts_abcd_z[D]]){
          rotate([fish_ring_d_rotation-90,0,0])
            translate([-3.3,-10 - edg_h/2 + 0.05,-big/2])
            cube([6.6,10,big]); // Block to put fish ring in
          rotate([fish_ring_d_rotation-180,0,0])
            translate([0,ins_ri+cdist,0])
            cylinder(r=M3_diameter/2, h=big, center=true);//Hole for M3
          rotate([fish_ring_d_rotation-180,0,0])
            translate([0,ins_ri+cdist,4])
            cylinder(r=M3_head_diameter/2, h=big);//M3 screw head hole
        }
        // Straight edge towards center of the d fish ring hole
        translate(Line_contact_d_xy)
          translate([-3.3,-9.5,-big+th+1])
          cube([6.6,7,big]); // Block to put fish ring in
      }
    }

    // Mounting holes for abc fish rings
    // rotations and translations synced with placed_fish_rings
    for(i=[0,1,2]){
      rotate([0,0,120*i]){
        for(k=[0,1]){
          mirror([k,0,0]){
            translate(Line_contact_abc_xy
                +[0,0,Line_contacts_abcd_z[i] + ins_ri + ins_ri/sqrt(2)])
              rotate([90,0,fish_ring_abc_rotation]){
                translate([-ins_ri/sqrt(2),0,0])
                  translate([0,-cdist-ins_ri,0]){
                    cylinder(r=M3_diameter/2+0.3, h = 25, center=true);
                  }
              }
          }
        }
      }
    }

    // Middle hole for ABCD-motors
    // Large enough to get motor gears through
    four_point_translate(){
      cylinder(r = Motor_gear_radius
          + 2*(Motor_gear_radius-Motor_gear_pitch - 0.5),
          h=Big, center=true);
    }

    ang = 50;
    // Screw holes for abc Nema
    translate([0, 0, -1]){
      four_point_translate()
        rotate([0,0,ang])
        Nema17_schwung_screw_holes(M3_diameter+0.2, th+2, 18);
      four_point_translate()
        translate([0,0,th-2.5])
        rotate([0,0,ang])
        Nema17_screw_holes(M3_head_diameter+0.1, th+2);
    }

    // Hole for extruder motor
    extruder_motor_translate(Extruder_motor_twist)
      scale(1.015) // Leave 1.5% extra space, don't need tight fit
      Nema17();

    // Screw holes for extruder motor mounting screws
    translate([0,0,E_motor_z_offset]){
      rotate([0,0,Extruder_motor_twist])
        translate([-18.5,77,Bottom_plate_thickness/2])
        rotate([-90,0,0])
        cylinder(h=Big, r=2.0);
      rotate([0,0,Extruder_motor_twist])
        translate([-50,77,Bottom_plate_thickness/2])
        rotate([-90,0,0])
        cylinder(h=Big, r=2.0);
      rotate([0,0,Extruder_motor_twist])
        translate([-18.5,7,Bottom_plate_thickness/2])
        rotate([-90,0,0])
        cylinder(h=Big, r=M3_diameter/2+0.1);
      rotate([0,0,Extruder_motor_twist])
        translate([-50,7,Bottom_plate_thickness/2])
        rotate([-90,0,0])
        cylinder(h=Big, r=M3_diameter/2+0.1);
    }

    rotate([0,0,Extruder_motor_twist])
      translate([-18.5,11,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cube([9,Bottom_plate_thickness+2,30], center=true);

    rotate([0,0,Extruder_motor_twist])
      translate([-50,11,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cube([9,Bottom_plate_thickness+2,30], center=true);

    // Dig out filament hole in sandwich stick and base.
    // Note that bowden tube should fit in this from below
    translate([0, 0, -1]) cylinder(r = 2.3, h = Big);

    // Letters for easier identification
    color("white")
      translate([0,0,-1]){
        rotate([0,0,120*A+7])
          translate(Line_action_point_abc_xy + [0,-8,th])
          scale([1,1,1.5])
          linear_extrude(height=2)
          text("A",halign="center",valign="center");
        rotate([0,0,120*B+7])
          translate(Line_action_point_abc_xy + [8,-9,th])
          scale([1,1,1.5])
          linear_extrude(height=2)
          text("B",halign="center",valign="center");
        rotate([0,0,120*C+7])
          translate(Line_action_point_abc_xy + [-9,-15,th])
          scale([1,1,1.5])
          linear_extrude(height=2)
          text("C",halign="center",valign="center");
      }
    // Funnel shape for easier bowden tube fit
    translate([0,0,-0.1])
      cylinder(h=3, r1=3, r2=2);

  }
  if(Render_screws){
    // D-stop screw
    translate([Sandwich_radius+2,-20,0])
      rotate([0,0,25])
      translate([0,-0.5,10])
      color(Screw_color_2)
      rotate([-90,0,0])
      translate([5.5,-5.5,-4]){
        M3_screw(19);
        translate([0,0,7])
          // nut
          M3_screw(2);
      }
      // Motor screws
    ang = 50;
    // Screw holes for abc Nema
    translate([0, 0, -1]){
      four_point_translate()
        translate([0,0,th-7])
        rotate([0,0,ang])
        color(Screw_color_2)
        Nema17_screw_translate()
          M3_screw(10, updown=true);
    }
  }
}
// The rotate is for easier fitting print bed when printing
// this part on 200 mm square print bed
//rotate([0,0,15])
//bottom_plate();

//** bottom_plate end **//

// Sandwich is defined in Gears.scad
// Motors are defined in Nema17_and_Ramps_and_bearings.scad


//** extruder start **//

// A better way to match holes:
// make bottom_plate take two flags:
//   render_plate?
//   render_drive?
// make diff holes outside the if-statement, so
// holes always align anyway.

module fan(width=30, height=10){
  linear_extrude(height=height, twist=-40)
  for(i=[0:6]){
    rotate([0,0,(360/7)*i])
      translate([0,-0.5])
        square([width/2 - 2, 1]);
  }
  cylinder(h=height, r=width/4.5);

  difference(){
    translate([-width/2, -width/2,0])
      cube([width,width,height]);
    translate([0,0,-1]) cylinder(r=width/2 - 1, h=height+2);
    for(i=[1,-1]){
      for(k=[1,-1]){
        translate([i*width/2-i*2.5,k*width/2-k*2.5,-1])
          cylinder(r=1, h=height+2);
      }
    }
  }
}

module Volcano_block(){
  small_height = 18.5;
  large_height = 20;
  color("silver"){
  translate([-15.0,-11/2,0])
    difference(){
      cube([20,11,large_height]);
      translate([7,0,small_height+3])
        rotate([90,0,0])
        cylinder(h=23, r=3, center=true,$fn=20);
      translate([-(20-7+1.5),-1,small_height]) cube([22,13,2]);
    }
    }
  color("gold"){
    translate([0,0,-3]) cylinder(h=3.1,r=8/2,$fn=6);
    translate([0,0,-3-2]) cylinder(h=2.01, r2=6/2, r1=2.8/2);
  }
}
//Volcano_block();

// Contains a lot of unnamed measured numbers...
module e3d_v6_volcano_hotend(fan=1){
  lpl = 2.1;
  if(fan){
  color("blue") rotate([90,0,0]) import("stl/V6_Duct.stl");
  color("black")
    translate([-15,0,15])
      rotate([0,-90,0])
        fan(width=30, height=10);
  }
  color("LightSteelBlue"){
    cylinder(h=26, r1=13/2, r2=8/2);
    for(i = [0:10]){
      translate([0,0,i*2.5]) cylinder(h=1, r=22.3/2);
    }
    translate([0,0,E3d_heatsink_height-3.7]) cylinder(h=3.7, r=E3d_mount_big_r);
    translate([0,0,E3d_heatsink_height-3.7-6.1]) cylinder(h=6.2, r=E3d_mount_small_r);
    translate([0,0,E3d_heatsink_height-3.7-6-3]) cylinder(h=3, r=E3d_mount_big_r);
    translate([0,0,26-0.1]) cylinder(h=E3d_heatsink_height-(12.7+26)+0.2, r=8/2);
    translate([0,0,26+1.5]) cylinder(h=1, r=E3d_mount_big_r);
    // echo(42.7-(12.7+26));
    translate([0,0,-lpl-0.1]) cylinder(h=lpl+0.2,r=2.8/2);
  }
  translate([0,0,-20-lpl]) Volcano_block();
}
//e3d_v6_volcano_hotend();

// towermove moves materia but not antimateria of drive_support
// height of the tower depends on big extruder gear rotation
// Used in assembled_drive in placed_parts.scad
module drive_support_helper(non_motor_side,towermove=0){
  th = Drive_support_thickness;

  difference(){
    color(Printed_color_1){
      union(){
        // Cube to make hotend mounting possible
        //mount_th = 3;
        //translate([0,-14,-mount_th])
        //  cube([Drive_support_v[0],14,th+mount_th]);
        translate([towermove,-E3d_v6_support_height,0]){
          cube([Drive_support_v[0],
              Drive_support_height + E3d_v6_support_height,
              th]);
        }
      }
    }
    // Hole for bearings supporting hobbed insert screw
    translate([Bearing_623_outer_diameter,Hobb_from_edge,-Big/2])
      M3_screw(Big);
    translate([Bearing_623_outer_diameter/2 + 5,
        Hobb_from_edge,
        +1])
      cylinder(r=Bearing_623_outer_diameter/2, h=Big);
    // Somewhat prolonged hole
    // Put something rubber-like in hole for suspension against
    // filament.
    for(i=[0:0.5:1])
    translate([Bearing_623_outer_diameter/2+5 // Center of hobb x-dir
               + Hobbed_insert_diameter/2
               + Extruder_filament_opening
               + Bearing_623_outer_diameter/2 - i,
        Hobb_from_edge,-1])
      M3_screw(Big, $fn=6);
  }

  // Foot to screw on to bottom_plate
  color(Printed_color_1){
    difference(){
      translate([towermove,Drive_support_height,
          -Drive_support_v[2]+th])
        // TODO
        // Rewrite drive stuff...
        cube([Drive_support_v[0]+8,
            Drive_support_v[1],
            Drive_support_v[2]]);
      // Screw holes...
      // This hole punching should really be done in bottom_plate module
      // Marking all hole punches with "punch" for easier removal later
      translate([Drive_support_v[0]+8-3,0,-Drive_support_v[2]+th+3])
        rotate([-90,0,0]) cylinder(r=3/2 + 0.1, h=Big); // punch
      translate([Drive_support_v[0]+8-3,0,th-3])
        rotate([-90,0,0]) cylinder(r=3/2 + 0.1, h=Big); // punch

      if(!non_motor_side){
        // Make space for big extruder gear
        // 2 inserted here to get alignment with extruder motor
        // screw holes in bottom_plate
        translate([Bearing_623_outer_diameter - 2,
            Hobb_from_edge,
            -Big_extruder_gear_height-4-0.02])
          cylinder(r= Drive_support_height
              -Hobb_from_edge
              +Drive_support_v[1] + 1.4,
              h=Big_extruder_gear_height+4, $fn = 50);
        // Screw hole
        translate([3+towermove,0,-Drive_support_v[2]+th+3])
          rotate([-90,0,0])
          cylinder(r=3/2 + 0.1, h=Big); // punch
      }else{
        translate([Drive_support_v[0]/2,0,-Drive_support_v[2]+th+6])
          rotate([-90,0,0])
          cylinder(r=3/2 + 0.1, h=Big); // punch
      }
    }
  }
  if(Render_screws){
    translate([Drive_support_v[0]+8-3,27,-Drive_support_v[2]+th+3])
      rotate([-90,0,0])
      color(Screw_color_2)
      M3_screw(8); // punch
    translate([Drive_support_v[0]+8-3,27,th-3])
      rotate([-90,0,0])
      color(Screw_color_2)
      M3_screw(8); // punch
    if(!non_motor_side){
    // Screw hole
    translate([3+towermove,27,-Drive_support_v[2]+th+3])
      rotate([-90,0,0])
      color(Screw_color_2)
      M3_screw(8); // punch
    }else{
      translate([Drive_support_v[0]/2,27,-Drive_support_v[2]+th+6])
        rotate([-90,0,0])
        color(Screw_color_2)
        M3_screw(8);
    }
  }
}
//rotate([0,3*90,0])
//drive_support_helper(1,Drive_support_towermove);
//rotate([0,3*90,0])
//  drive_support_helper(0,Drive_support_towermove);

// towermove moves materia but not antimateria of drive_support
module drive_support(towermove=Drive_support_towermove){
  e3d_x_center = Bearing_623_outer_diameter/2 +5 //Center of hobb x-dir
               + Hobbed_insert_diameter/2
               + Extruder_filament_opening/2
               + 0.7; // Add 0.7 because hobb pushes that way

  // This difference makes e3d mount
    difference(){
      for(k = [0,2*Drive_support_thickness // Bring supports to same z
          + 0.2 // 623 |.2mm| Hobb |.2mm| 623
          + Hobbed_insert_height
          + 0.0])
        translate([0,0, k])
          mirror([0,0,k])
          drive_support_helper(k,towermove);

      // Grooves to mount hot end
      translate([e3d_x_center, // Add 0.7 because hobb pushes that way
          - E3d_heatsink_height,
          Drive_support_thickness+(0.2+Hobbed_insert_height)/2])
        rotate([-90,0,0]){
          e3d_v6_volcano_hotend(fan=0);
        }
      // holes to mount hot end
      translate([e3d_x_center-1.6-E3d_mount_small_r+0.2,-7,-Big/2]) cylinder(r=1.6, h=Big);
      translate([e3d_x_center+1.6+E3d_mount_small_r-0.2,-7,-Big/2]) cylinder(r=1.6, h=Big);
  }
  if(Render_hotend){
    translate([e3d_x_center,
        - E3d_heatsink_height,
        Drive_support_thickness+(0.2+Hobbed_insert_height)/2])
      rotate([-90,0,0]){
        e3d_v6_volcano_hotend(fan=0);
        // Render some purple filament
        //color("purple") cylinder(r=1.75/2, h=80);
        color("white") cylinder(r=2, h=50);
      }
  }
  if(Render_screws){
    // Screws holding hotend
    for(i=[1,-1]){
    translate([e3d_x_center+i*1.6+i*E3d_mount_small_r+0.2,-7,0])
      color(Screw_color_2){
        M3_screw(21,updown=true);
        // nut
        translate([0,0,2])
        M3_screw(2);
      }
    }
    translate([Bearing_623_outer_diameter/2+5 // Center of hobb x-dir
        + Hobbed_insert_diameter/2
        + Extruder_filament_opening
        + Bearing_623_outer_diameter/2,
        Hobb_from_edge,0]){
      // adjustable screw
      color(Screw_color_2)
        M3_screw(21, updown=true);
      translate([0,0,-0.6])
        color(Screw_color_2)
        M3_screw(2);
      translate([0,0,8])
        Bearing_623();
    }
    // Screw holding hobbed bolt
    translate([Bearing_623_outer_diameter,Hobb_from_edge,-4]){
      color(Screw_color_2)
        M3_screw(25, updown=true);
      translate([0,0,2])
        color(Screw_color_2)
        M3_screw(26);
    }
  }
}
//rotate([0,-90,0])
//drive_support(2);

// Checking stl file
//translate([20,0,0])
//import("/home/torbjorn/Hangprinter/stl/Complete_printer_17_Dec_2015/Tble_extruder_leftleg_1.stl");

// Some dividing and stuff for printing
// == Extruder gear side (leftleg) ==
//rotate([0,90,0])
//rotate([0,180,0])
//intersection(){
//  drive_support();
//  translate([-1,-16,-23])
//  cube([50,60,30]);
//}

// Checking stl file
//translate([5,0,0])
//import("/home/torbjorn/Hangprinter/stl/Complete_printer_17_Dec_2015/Tble_extruder_rightleg_1.stl");

// == Not extruder gear side (rightleg) ==
//rotate([0,90,0])
//rotate([0,0,180])
//difference(){
//  drive_support();
//  translate([-1,-16,-23])
//  cube([50,60,30]);
//}


//** Plates start **//

// An upside down hook that can be printed without support structure
module hook(height=10){
  line_radius = 0.90;
  big=30;
  difference(){
    // Main cube
    translate([-3,-4,0])
      cube([6,8,height]);
    // Hole
    translate([0,-line_radius/2,height])
      rotate([30,0,0])
        cylinder(r=line_radius, h=15.5, center=true);
    translate([0,4.1,4.7])
    // Bent end of channel
    difference(){
      rotate([0,90,0])
        rotate_extrude(convexity=4, $fn=20)
          translate([1.3,0,0])
            circle(r=line_radius, $fn=25);
      rotate([30,0,0])
        translate([-big/2,-big/2,0])
          cube(big);
    }
    //translate([10,-1,height-4])
    //  rotate([0,-90,0])
    //    M3_screw(20);
  }
}
//hook();

module top_flerp(side_length){
  difference(){
    eq_tri(side_length,Top_plate_thickness);
    translate([0,0,0]) cylinder(r=M3_diameter/2,h=Big,center=true);
  }
}

// Translation, iterating and rotating modules
module z_gatt_translate(back = 0){
  for(i=[0,120,240])
    rotate([0,0,i])
      translate([0,Full_tri_side/Sqrt3 - back,0])
        children(0);
}

// Flip before printing
module top_plate(){
  th = Top_plate_thickness;
  flerp_side=23;
  height = 17;
  melt=0.1;
  color(Printed_color_1)
  translate([0,0,height])
    mirror([0,0,1]){
  // Base plate
  difference(){
    eq_tri(Full_tri_side, th);
    translate([0,0,-1])
      eq_tri(Full_tri_side-15, th+2);
  }
  for(i=[0,120,240])
    // Screw holes
    rotate([0,0,i]){
      translate(Line_contact_d_xy)
        translate([0,-6.5,0])
        top_flerp(flerp_side);
      // Hook holes for line
      translate(Line_contact_d_xy)
        translate([0,0,th-melt])
        hook(height-th+melt);
    }
  // Mark action point d
  cylinder(r=2, h=height);
  rotate([0,0,60])
    for(i=[0,120,240]) rotate([0,0,i])
      difference(){
        translate([-1.5,0,0])
          cube([3,Full_tri_side*Sqrt3/6,height]);
        translate([-2.5,0,height])
          rotate([-10,0,0])
          cube([5,Full_tri_side*Sqrt3/6+3,height]);
      }
    }
  if(Render_lines){
    for(i=[0,120,240]){
      rotate([0,0,i]){
        translate(Line_contact_d_xy){
          translate([0,0,7])
          color(Line_color)
            cylinder(r=5.4,h=3);
          translate([0,0,-12])
            color(Line_color)
            cylinder(r=0.5, h=16);
          translate([0,0,-16]){
            rotate([90,0,90])
              translate([0,-4,-Bearing_623_vgroove_width/2])
              Bearing_623_vgroove();
            rotate([90,-45,0])
              color(Line_color)
              teardrop_line_shape(4);
          }
        }
      }
    }
  }
}
//rotate([180,0,15])
//top_plate();

//%cube([139,139,20]);
module parted_top_plate_piece1(){
  th = Top_plate_thickness;
  flerp_side=21;
  height = 15;
  melt=0.1;
  translate([0,Full_tri_side/(2*Sqrt3),0])
  difference(){
    eq_tri(Full_tri_side/2, th);
    translate([0,-6,-1])
      eq_tri(Full_tri_side/2-15+6*Sqrt3, th+2);
    translate([0,- Full_tri_side/(2*Sqrt3),0])
    // Cut the sharp points
    for(k=[0,-1])
      mirror([k,0,0])
        rotate([0,0,30])
        translate([(Full_tri_side-15)/(2*Sqrt3),0,-1])
        cube([15,5/2,th+2]);
  }
  translate(Line_contact_d_xy)
    translate([0,-5.5,0])
    top_flerp(flerp_side);
  // Hook holes for line
  translate(Line_contact_d_xy)
    translate([0,0,th-melt])
    hook(height-th+melt);
  // Flerp to screw together parts
  for(k=[0,-1])
    mirror([k,0,0])
      rotate([0,0,30])
      translate([(Full_tri_side-15)/(2*Sqrt3),1.5,0])
      difference(){
        cube([14,3,th]);
        translate([10,-1,th/2])
          rotate([-90,0,0])
          cylinder(r=M3_diameter/2, h=5);
      }
}
//parted_top_plate_piece1();
//translate([-139/2,-17,0])
//%cube([139,139,20]);
//parted_top_plate_piece1();
//translate([0,-25,0,])
//parted_top_plate_piece1();
//translate([0,2*-25,0,])
//parted_top_plate_piece1();

// Fits on a Huxley
module parted_top_plate_piece2(){
  th = Top_plate_thickness;
  flerp_side=22;
  height = 15;
  melt=0.1;
  cylinder(r=2, h=height);
  rotate([0,0,60])
    for(i=[0,120,240]) rotate([0,0,i])
      difference(){
        translate([-1.5,0,0])
          cube([3,Full_tri_side*Sqrt3/6,height]);
        translate([-2.5,0,height])
          rotate([-9.7,0,0])
          cube([5,Full_tri_side*Sqrt3/6+3,height]);
      }
  for(k=[[0,0,0],[-1,0,0],[1,Sqrt3,0]])
    mirror(k)
      rotate([0,0,30])
      translate([(Full_tri_side-15)/(2*Sqrt3),-1.5,0])
      difference(){
        cube([14,3,th]);
        translate([10,-1,th/2])
          rotate([-90,0,0])
          cylinder(r=M3_diameter/2, h=5);
      }
}
//parted_top_plate_piece2();

module side_plate2(height=15,th=7){
  s = Abc_xy_split + 2*6;
  color(Printed_color_1)
  translate([0,th,0]){
    difference(){
      translate([-s/2,-th,-height/2])
        cube([s,th,height]);
      // Wall screw holes
      for(k=[1,0])
        mirror([k,0,0])
          translate([Abc_xy_split/2 - 10,-th-1,0])
            rotate([-90,0,0]){
              cylinder(r=M3_diameter/2, h=Big);
              translate([0,0,th/2]) cylinder(r=M3_head_diameter/2,h=Big);
            }
      // Hook holes
      for(k=[1,0])
        mirror([k,0,0]){
          translate([Abc_xy_split/2,-th-1,0])
            rotate([-90,0,0])
              cylinder(r=0.75, h=Big);
          translate([-1 + Abc_xy_split/2, -th - th +2, -height])
            cube([2, th, 2*height]);
          // Holes for adjustment screws. Intentionally narrow
          translate([20,-th/2,-Big/2])
            cylinder(r=1.45,h=Big);
        }
      // Mark wall action point
      rotate([15,0,0]) translate([-1,0,0]) cube([2,5,height]);
      mirror([0,0,1])
        rotate([15,0,0]) translate([-1,0,0]) cube([2,5,height]);
    }
    // Pulleys to wind line around
    for(k=[1,-1])
      translate([k*(Abc_xy_split/2 - 8),0,0]){
        translate([-4.5,-3,height/2-0.1]) cylinder(r=2.5, h=7);
        translate([ 4.5,-3,height/2-0.1]) cylinder(r=2.5, h=7);
      }
  }
  if(Render_wall_vgrooves){
    rotate([14,0,0])
    for(k=[1,0])
      mirror([k,0,0]){
        translate([Abc_xy_split/2,24,0])
          rotate([0,90,0]){
            translate([0,0,-Bearing_623_vgroove_width/2])
              Bearing_623_vgroove();
            translate([0,-4,0])
              rotate([-90-45,0,0])
              rotate([0,90,0])
              color(Line_color)
              teardrop_line_shape(4);
            translate([0,-25,0])
              rotate([-90,0,0])
              color(Line_color)
              cylinder(r=0.5, h=17);
          }
        // Line that wraps around poles and screw
        translate([18,2,10])
          rotate([3,90,0])
          color(Line_color){
            cylinder(r=0.5, h=45);
            translate([0,0,45]){
              rotate([-54,0,0]){
                cylinder(r=0.5, h=12);
                translate([0,0,12])
                  rotate([90,0,0]){
                    cylinder(r=0.5, h=4.1);
                    translate([0,0,4.0])
                      rotate([45,34,0])
                      cylinder(r=0.5, h=5.8);
                  }
              }
            }
          }
      }
  }
  if(Render_screws){
    for(k=[1,0])
      mirror([k,0,0])
        translate([0,0,10])
          rotate([180,0,0])
          translate([20,-th/2,-20/2])
            color(Screw_color_2)
            M3_screw(20);
  }
}
//side_plate2();

module side_plate3(height=15,th=7){
  s = Abc_xy_split + 2*6;
  d = 7;
  a = s/2 - Sqrt3*d/2;
  color(Printed_color_1)
  difference(){
    union(){
      // Main cube (the one where lines enter)
      translate([-s/2,-th,-height/2])
        cube([s,th,height]);
      // Short leg
      translate([-s/2+Sqrt3*d,-1,-height/2])
        cube([th, d+1, height]);
      // Long leg
      translate([s/2 - th - Sqrt3*d,-4,-height/2])
        rotate([0,0,30])
        cube([th, a+0, height]);
      // Foot of short leg
      translate([-s/2+Sqrt3*d+th/2,d-th*Sqrt3/2,-height/2])
        rotate([0,0,30])
        cube([15,th,height]);
      // Foot of long leg
      translate([-s/2+Sqrt3*d+th/2,d-th*Sqrt3/2,-height/2])
        rotate([0,0,30])
        translate([Sqrt3*a-2*d-14-1.5-th,0,0])
        cube([16,th,height]);
      // Pulleys to wind line around
      for(k=[1,-1])
        translate([k*(Abc_xy_split/2 - 8),0,0]){
          translate([-4.5,-3,height/2-0.1]) cylinder(r=2.5, h=7);
          translate([ 4.5,-3,height/2-0.1]) cylinder(r=2.5, h=7);
        }
    }
    // Hook holes (Where lines enter)
    for(k=[1,0])
      mirror([k,0,0]){
        translate([Abc_xy_split/2,-th-1,0])
          rotate([-90,0,0])
            cylinder(r=0.75, h=Big);
        translate([-1 + Abc_xy_split/2, -2, -height])
          cube([2, th, 2*height]);
        // Holes for adjustment screws. Intentionally narrow
        translate([20,-th/2,-Big/2])
          cylinder(r=1.45,h=Big);
      }
    translate([-s/2+27,0,0])
    rotate([-90,0,30]){
      translate([0,0,-11]) cylinder(r=7/2,h=20);
      cylinder(r=M3_diameter/2,h=42,center=true);
    }

    translate([s/2-29,0,0])
      rotate([-90,0,30]){
      translate([0,0,20]) cylinder(r=M3_diameter/2,h=54);
      translate([0,0,20]) cylinder(r=7/2,h=40);
      // A little space for a screwdriver along long leg
      rotate([-7,0,0])
      translate([0,-7,-11]) cylinder(r=7/2,h=44);
    }
    // Mark wall action point
    for(k=[0,1])
      mirror([0,0,k])
      translate([0,-th,0])
      rotate([-15,0,0]) translate([-1,-5,0]) cube([2,5,height]);
  }
  if(Render_wall_vgrooves){
    rotate([-10,0,0])
    mirror([0,1,0])
    for(k=[1,0])
      mirror([k,0,0]){
        translate([Abc_xy_split/2,24,0])
          rotate([0,90,0]){
            translate([0,0,-Bearing_623_vgroove_width/2])
              Bearing_623_vgroove();
            translate([0,-4,0])
              rotate([-90-45,0,0])
              rotate([0,90,0])
              color(Line_color)
              teardrop_line_shape(4);
            translate([0,-25,0])
              rotate([-90,0,0])
              color(Line_color)
              cylinder(r=0.5, h=17);
          }
        // Line that wraps around poles and screw
        translate([18,2,10])
          rotate([3,90,0])
          color(Line_color){
            cylinder(r=0.5, h=45);
            translate([0,0,45]){
              rotate([-54,0,0]){
                cylinder(r=0.5, h=12);
                translate([0,0,12])
                  rotate([90,0,0]){
                    cylinder(r=0.5, h=4.1);
                    translate([0,0,4.0])
                      rotate([45,34,0])
                      cylinder(r=0.5, h=5.8);
                  }
              }
            }
          }
      }
  }
  if(Render_screws){
    for(k=[1,0])
      mirror([k,0,0])
        translate([20,-th/2,2])
          M3_screw(20, updown = true);
  }
}
//mirror([1,0,0])
side_plate3();
