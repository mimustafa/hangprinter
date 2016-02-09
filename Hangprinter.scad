include <measured_numbers.scad>
include <design_numbers.scad>
include <rendering_control.scad>
use <Nema17_and_Ramps_and_bearings.scad>
use <Gears.scad>
use <parts.scad>
use <placed_parts.scad>
use <render_parts.scad>

// Style:
//  - Global parameters starts with capital letter, others don't

// TODO:
//  - Improve extruder drive and hotend mount.
//    Complete rewrite of those
//    (assembling along z-direction from the beginning)
//    might be worth it...


module full_render(){
  if(Render_bottom_plate){
    bottom_plate();
    // For better rendering performance, precompile bottom_plate
    //precompiled("stl/bottom_plate_for_render.stl");
  }
  if(Render_sandwich){
    placed_sandwich();
    // For better rendering performance, precompile placed sandwich
    //precompiled("stl/complete_sandwich_for_render.stl");
  }
  if(Render_abc_motors){
    placed_abc_motors();
  }
  if(Render_fish_rings){
    placed_fish_rings();
  }
  if(Render_lines){
    //translate([0,0,20])
    //mirror([0,0,1])
    placed_lines();
  }
  if(Render_extruder){
    placed_extruder();
  }
  if(Render_ramps){
    placed_ramps();
  }
  if(Render_plates){
    //translate([0,0,20])
    //mirror([0,0,1])
    placed_plates();
  }
  if(Render_filament){
    filament();
  }
}
full_render();

// *** Cubes and text to illustrate ANCHOR_A_Y measurment *** //
//translate([-7.5,
//           -abs(Wall_action_point_a[1])+abs(Line_contact_abc_xy[0]),
//           0]
//          + Line_contact_abc_xy
//          + [0,0,Line_contacts_abcd_z[0]]){
//    cube([15,
//          abs(Wall_action_point_a[1])-abs(Line_contact_abc_xy[0]),1]);
//    translate([0,0,-abs(Wall_action_point_a[2])-abs(Line_contacts_abcd_z[0])])
//    cube([15, 1,
//          abs(Wall_action_point_a[2])+abs(Line_contacts_abcd_z[0])]);
//    color("black")
//      rotate([0,0,-90])
//      translate([-200,0,4])
//      text("ANCHOR_A_Y");
//  }

// Use for better rendering performance while working on other part.
module precompiled(s){
    echo("Warning: using precompiled file", s);
    import(s);
}

module sandwich_exploded_view(){
  translate([0,0,0]){
    rotate([180,0,0])
    precompiled("./stl/Complete_printer_17_Dec_2015/Sandwich_gear_4.stl");
    precompiled("./stl/Complete_printer_17_Dec_2015/Spool_4.stl");
  }
  color("lime")
    // screws
    for(i = [1:120:360]){
      rotate([0,0,i]){
      translate([0,Snelle_radius - 4, 10])
        M3_screw(Sandwich_height+2, updown=true);
      translate([0,Snelle_radius - 4, -4])
        M3_screw(2);
      }
    }
}
//sandwich_exploded_view();

module teardrop(){
  difference(){
    union(){
      cylinder(r=2.5, h=0.5);
      cube([2.5,2.5,0.5]);
    }
    translate([0,0,-1]){
      cylinder(r=2, h=2.5);
      cube([2,2,2.5]);
    }
  }
}
//teardrop();

module spool_view(){
  color(Printed_color_2)
    precompiled("./stl/Complete_printer_17_Dec_2015/Spool_4.stl");
  color("lime"){
    translate([17.5,-29.9,2.2])
    rotate([90,0,30])
    cylinder(h=47, r=0.5);
    translate([16,-27,2])
    rotate([0,0,-109])
    teardrop();
  }
}
//spool_view();

module exploded_stack(){
  letters = ["A", "B", "C", "D"];
  for(i = [0,1,2,3]){
    translate([0,0,(Line_contacts_abcd_z[i] - Snelle_height/2)*2.3]){
      bearing_filled_sandwich();
      rotate([0,0,82])
        translate([50,0,-2])
        rotate([90,0,0]){
          cube([20,20,1], center=false);
          color("black")
            translate([2,1,1])
            text(letters[i], size=17);

        }
    }
  }
}
//exploded_stack();
//color(Printed_color_1)
//precompiled("./stl/Complete_printer_17_Dec_2015/Bottom_plate_1.stl");
//bottom_plate();

module extruder_drive_render(){
  drive_support(2);
  translate([Bearing_623_outer_diameter,
      Hobb_from_edge,
      -Big_extruder_gear_height-1]){
    translate([0,0,7])
      Bearing_623();
    translate([0,0,19])
      Bearing_623();
    translate([0,0,11])
      hobbed_insert();
    big_extruder_gear();
  }
}

// Letter signs at anchor points for explaining which is which
module anchor_point_explanation(){
  translate(Wall_action_point_a + [-25,19,10])
    rotate([90,0,-20]){
      cube([44,44,1], center=false);
      color("black")
        translate([4,2,1])
        text("A", size=39);
    }
  translate(Wall_action_point_b + [0,0,0])
    rotate([90,0,-20]){
      cube([44,44,1], center=false);
      color("black")
        translate([4,2,1])
        text("B", size=39);
    }
  translate(Wall_action_point_c + [0,0,0])
    rotate([90,0,-20]){
      cube([44,44,1], center=false);
      color("black")
        translate([4,2,1])
        text("C", size=39);
    }
  translate(Ceiling_action_point + [0,0,0])
    rotate([90,0,-20]){
      cube([44,44,1], center=false);
      color("black")
        translate([4,2,1])
        text("D", size=39);
    }
}

module placed_extruder_motor_with_gear(){
  extruder_motor_translate(Extruder_motor_twist){
    // For render "mount extruder motor step" in build manual
      Nema17();
    translate([0,0,55.5])
      small_extruder_gear();
    color(Screw_color_1){
      for (i=[0,90]){
        rotate([0,0,i+45]) translate([Nema17_screw_hole_width/2,0,0])
          M3_screw(51, updown=true);
        rotate([0,0,i+45]) translate([Nema17_screw_hole_width/2,0,-31])
          M3_screw(56);
      }
    }
  }
}
//placed_extruder_motor_with_gear();
//full_render();
