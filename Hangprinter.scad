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
  if(Render_wall_vgrooves){
    placed_wall_vgrooves();
  }

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
//full_render();

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

precompiled("stl//Complete_printer_17_Dec_2015/Bottom_plate_1.stl");

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
 translate([0,0,(Line_contacts_abcd_z[A] - Snelle_height/2)*2.3]) bearing_filled_sandwich();
 translate([0,0,(Line_contacts_abcd_z[B] - Snelle_height/2)*2.3]) bearing_filled_sandwich();
 translate([0,0,(Line_contacts_abcd_z[C] - Snelle_height/2)*2.3]) bearing_filled_sandwich();
 translate([0,0,(Line_contacts_abcd_z[D] - Snelle_height/2)*2.3]) bearing_filled_sandwich();
}
//exploded_stack();
//bottom_plate();

module placed_stack(){
 translate([0,0,(Line_contacts_abcd_z[A] - Snelle_height/2)*1]) bearing_filled_sandwich();
 translate([0,0,(Line_contacts_abcd_z[B] - Snelle_height/2)*1]) bearing_filled_sandwich();
 translate([0,0,(Line_contacts_abcd_z[C] - Snelle_height/2)*1]) bearing_filled_sandwich();
 translate([0,0,(Line_contacts_abcd_z[D] - Snelle_height/2)*1]) bearing_filled_sandwich();
}
//placed_stack();
//bottom_plate();
//placed_fish_rings();


//drive_support(2);
//    translate([Bearing_623_outer_diameter,
//               Hobb_from_edge,
//               -Big_extruder_gear_height-1]){
//    translate([0,0,7])
//      Bearing_623();
//    translate([0,0,19])
//      Bearing_623();
//    translate([0,0,11])
//      hobbed_insert();
//    big_extruder_gear();
//}
