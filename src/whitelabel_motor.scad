include <parameters.scad>
use <donkey_bracket.scad>
use <util.scad>
use <belt_roller.scad>

base_ywidth = 84;

//stationary_part();
module stationary_part(){
  difference(){
    scale([61.1/60.8,61.1/60.8,1])
      linear_extrude(height=7, convexity=6)
        scale(0.1550)
          for(i=[-1,0,1]){
        extra_wiggle_room = 0.2;
        wiggle_degs = i*extra_wiggle_room/(60.8/2)*(180/PI);
            rotate([0,0,-32-180+wiggle_degs])
              translate([-102,-151.5])
                import("./whitelabel_motor.svg");
      }
  for(ang=[0:90:359])
    rotate([0,0,ang+45])
      translate([29.6/2,0,-1])
        cylinder(d=3, h=10);
  }
}

module shaft(){
  translate([0,0,-20.2])
    cylinder(d=5, h=20.2 + 42);
}

module rotating_part(){
  difference() {
    translate([0,0,7.1])
      cylinder(d=60.8, h=28.7-7.1, $fn=100);
    translate([0,0,32]){
      rotate_extrude() {
        translate([22,0])
          rotate([0,0,-12])
            square([20, 10], center=true);
      }
    }
  }
}

//whitelabel_motor();
module whitelabel_motor(){
  color([0.4,0.4,1.0]) stationary_part();
  color("grey") shaft();
  color([0.6,0.6,1.0]) rotating_part();
}

//encoder();
module encoder(){
  difference(){
    union(){
      translate([-(33.8-27.6),-28.5/2,0])
      cube([34, 28.5, 8.9]);
      intersection(){
        cylinder(r=43.13-27.6, h=8.9,$fn=100);
        translate([-50,-28.5/2,-1])
          cube([100, 28.5, 10]);
      }
    }
  translate([0,0,-1])
    cylinder(d=13, h=10);
  }

  for(k=[0,1]){
    mirror([0,k,0]){
      difference(){
        hull(){
          translate([0,-52.4/2+3,0])
            cylinder(d=6, h=2.4, $fn=20);
          translate([-(33.8-27.6), -28.5/2, 0])
            cube([2*(33.8-27.6), 1, 2.4]);
        }
        translate([0,-45.5/2,-1])
          cylinder(d=3, h=5, $fn=10);
        translate([0,-32.5/2,-1])
          cylinder(d=3, h=5, $fn=10);
        translate([0,-32.5/2,0.5])
          cylinder(d=5, h=5, $fn=12);
      }
  }
  }
}


module erasor_cubes(cubesize_x, yextra) {
  // Erasor cubes
  translate([-51,-20,-1])
    cube([30,40,50]);
  for(k=[0,1]) mirror([0,k,0]) {
    translate([-50+6, -cubesize_x-1,-1])
      cube([50,50,50]);
    translate([6,-cubesize_x/2+6,-1])
      rotate([0,0,-90])
        inner_round_corner(r=2, h=11, $fn=24);
    translate([4,-cubesize_x/2-k*yextra,0])
      rotate([0,90,0])
        rotate([0,0,90])
          inner_round_corner(r=2, h=27, $fn=24);
    translate([31,-cubesize_x/2-k*yextra+2,2])
      rotate([0,90,0])
        rotate([0,0,-90])
          rotate_extrude(angle=90, $fn=24) translate([4,0]) circle(r=2, $fn=24);
  }
  translate([5,-cubesize_x/2,8])
    rotate([0,90,0])
      rotate([0,0,0])
        inner_round_corner(r=2, h=26, $fn=24);
  translate([31,-cubesize_x/2+2,6])
    rotate([0,90,0])
      rotate([0,0,180])
        rotate_extrude(angle=90, $fn=24) translate([4,0]) circle(r=2, $fn=24);

}

//!whitelabel_motor_render();
module whitelabel_motor_render(){
  rotate([0,-90,0])
    whitelabel_motor();
  translate([-33.7,0,0])
    rotate([90,0,-90])
      encoder();
}


//translate([-2.5,0,0])
//rotate([0,90,0])
//motor_bracket();
module motor_bracket(leftHanded=false){
  cubesize_x = 60.8+6;
  yextra=8.6;
  cubesize_y = cubesize_x+yextra;

  difference(){
    union(){
      translate([-cubesize_x/2,-cubesize_x/2,0])
        cube([cubesize_x, cubesize_y,8]);
      translate([15,24,8])
        rotate([0,90,0])
          rotate([0,0,2*90])
            inner_round_corner(r=3, h=20, $fn=4*5);
    }
    difference(){
      translate([0,0,-1])
        cylinder(d=60.8-3,h=50, $fn=100);
      difference(){
        union(){
          for(k=[0,1]) {
            mirror([0,k,0]) {
              translate([-13,-4-29.6/(2*sqrt(2)),0])
                cube([cubesize_x-2, 8, 20]);
              translate([23.6,-29.6/(sqrt(8))-4.6,-1])
                  rotate([0,0,166])
                  inner_round_corner(r=2, h=10, ang=131, back=2, $fn=10*4);
              translate([28.49,-29.6/(sqrt(8))+3.95,-1])
                  rotate([0,0,90])
                  inner_round_corner(r=2, h=10, ang=74, back=2, $fn=10*4);
              rotate([0,0,57])
                rotate_extrude(angle=68, $fn=100)
                  translate([GT2_motor_gear_outer_dia/2+1,0])
                    square([8,9]);
            }
          }
        }
        cylinder(d=GT2_motor_gear_outer_dia+2, h=52, $fn=100);
      }

      for(ang=[0:90:359])
        rotate([0,0,ang+45]) {
          translate([29.6/2,0,2.5])
            cylinder(d=M3_screw_head_d+6, h=11,$fn=20);
          }
    }
    if (leftHanded) {
      rotate([0,0,180])
        mirror([1,0,0])
          translate([0,0,-7+2.5])
            stationary_part();
    } else {
      mirror([1,0,0])
        translate([0,0,-7+2.5])
          stationary_part();
    }
    translate([0,0,-7+2.5])
      cylinder(d=55, h=7);


    if (leftHanded) {
      mirror([0,1,0])
      erasor_cubes(cubesize_x, yextra);
    } else {
      erasor_cubes(cubesize_x, yextra);
    }

    // Remove overhang for ease of printing upright
    if (leftHanded) {
      translate([7.075,-29.720,-0.5])
        rotate([0,0,45])
            cube(3);
    } else {
      translate([8.555,29.285,-0.5])
        rotate([0,0,45])
          translate([-3, -3, 0])
            cube(3);
    }


    // Screw holes
    for(ang=[0:90:359])
      rotate([0,0,ang+45]) {
        translate([29.6/2,0,-1])
          cylinder(d=3.24, h=10, $fn=8);
        translate([29.6/2,0,2.5+3])
          cylinder(d=M3_screw_head_d, h=10,$fn=20);
      }
  }
  difference(){
    union(){
      difference(){
        translate([33,0,0])
          rotate([0,180,0])
            rotate([90,0,0])
              translate([0,0,-(cubesize_y+13)/2])
                inner_round_corner(r=2, h=cubesize_y+10, $fn=10*4);
        mirror([0,1,0])
          translate([0,24.4,9])
            rotate([45,0,0])
              translate([0,0,-50])
                cube(50);
        translate([0,42,9])
          translate([0,0,-50])
            cube(50);
      }

      mirror([0,1,0])
        intersection() {
        translate([ 33, cubesize_x / 2, -3 ])
          rotate([ 0, 0, 90 ])
           inner_round_corner(r=2, h=11, ang=90, $fn=10*4);
        translate([0,24.4,9])
          rotate([45,0,0])
            translate([0,0,-50])
              cube(50);
        }
    }
    for(k=[0,1]) mirror([0,k,0])
      translate([31,-cubesize_x/2-k*yextra+2,2])
        rotate([0,90,0])
          rotate([0,0,-90])
            rotate_extrude(angle=90, $fn=24) translate([4,0]) circle(r=2, $fn=24);

    translate([31,-cubesize_x/2+2,6])
      rotate([0,90,0])
        rotate([0,0,180])
          rotate_extrude(angle=90, $fn=24) translate([4,0]) circle(r=2, $fn=24);
  }
}


motor_bracket_xpos = -46.5;
belt_roller_ypos = 33;
union(){
  translate([motor_bracket_xpos,0,0])
  difference(){
    union(){
      hull(){
        translate([-12,0,0])
          cylinder(r=4, h=Base_th, $fn=4*6);
        translate([-12,0,0])
          cylinder(r=4, h=Base_th, $fn=4*6);
        translate([36-1.5,38,0])
          cylinder(r=4, h=Base_th, $fn=4*6);
        translate([36-1.5-15+3,38,0])
          cylinder(r=4, h=Base_th, $fn=4*6);
        translate([36-1.5,-38,0])
          cylinder(r=4, h=Base_th, $fn=4*6);
        translate([36-1.5-15+3,-38,0])
          cylinder(r=4, h=Base_th, $fn=4*6);
      }
      translate([36-1.5, 36, 0])
        cube([6, 6, Base_th]);
      translate([0,0,35]){
        translate([-2.5+33,0,0])
          rotate([0,90,0])
            motor_bracket();
        %translate([33,0,0])
          import("../stl/whitelabel_motor.stl");
          //whitelabel_motor_render();
        translate([4.5-0.7,0,0])
          rotate([0,0,2*90])
            encoder_bracket();
      }
    }
    translate([-12,0,0.5])
      Mounting_screw_countersink();
    translate([36-1.5-15+3,38,0.5])
      Mounting_screw_countersink();
    translate([36-1.5,-38,0.5])
      Mounting_screw_countersink();
    translate([36-1.5-15+3,-38,0.5])
      Mounting_screw_countersink();
  }
  translate([0, belt_roller_ypos, -0.01])
    rotate([0,0,-90])
      belt_roller(outline=false);
}
module encoder_bracket() {
  difference() {
    rotate([0,90,0]) {
      difference(){
        union(){
          translate([16,-20/2,-2.5])
            difference(){
              left_rounded_cube2([18, 20, 7+4], 3, $fn=5*4);
              translate([-1,-1,4])
                rotate([0,11,0])
                  translate([0,0,-50])
                    cube(50);
              translate([-1,-1,4.8])
                rotate([0,-11,0])
                  translate([0,0,2])
                    cube(50);
              translate([-0.1,3,7])
              hull(){
                cube([0.1, 20-2*3, 4]);
                translate([13, (20-2*3)/2, 0])
                  cylinder(d=4.5, h=4, $fn=5*4);
              }

            }
          intersection(){
            translate([33,0,0])
              rotate([90,-180,0])
                translate([0,1.66,-25/2])
                  inner_round_corner(r=2, h=25, $fn=10*4, ang=90-11, center=false);
            translate([0,0,-50*sqrt(2)+8.4])
              rotate([45,0,0])
                cube(50);
          }
          intersection(){
            translate([33,0,0])
              rotate([-90,180,0])
                translate([0,7.5,-25/2])
                  inner_round_corner(r=2, h=25, $fn=10*4, ang=90-11, center=false);
            translate([0,0,-2.5])
              rotate([45,0,0])
                cube(50);
          }

          difference(){
            for(k=[0,1])
              mirror([0,k,0])
                translate([33,20/2,0])
                    rotate([0,0,90])
                    translate([0,0,-6.5])
                      inner_round_corner(r=2, h=9+7, $fn=10*4, center=false);
            translate([0,0,-50*sqrt(2)+8.4])
              rotate([45,0,0])
                cube(50);
            translate([0,0,-2.5])
              rotate([45,0,0])
                cube(50);
          }
        }
      }
    }
    translate([0.1,0,0])
      rotate([90,0,-90]) {
        translate([0,-45.5/2,-5])
          hull(){
            translate([0,3,0])
              cylinder(d=3.1, h=16, $fn=10);
            translate([0,-1,0])
              cylinder(d=3.1, h=16, $fn=10);
          }
        translate([0,-45.5/2,-0.4-2])
          hull(){
            translate([0,3,0])
              rotate([0,0,30])
                cylinder(d=6.2, h=5, $fn=6);
            translate([0,-1,0])
              rotate([0,0,30])
                cylinder(d=6.2, h=5, $fn=6);
          }
    }
  }
}
