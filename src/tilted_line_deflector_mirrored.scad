use <tilted_line_deflector.scad>

tilted_line_deflector_mirrored();
module tilted_line_deflector_mirrored(){
  mirror([1,0,0])
    tilted_line_deflector(rotx=-atan(sqrt(2))-6, rotz=-30);
}
