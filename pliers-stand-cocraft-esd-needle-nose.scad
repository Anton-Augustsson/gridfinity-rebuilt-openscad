include <pliers-lib.scad>

// TODO:
difference() {
  plier_stand();

  union() {
    width = 30;
    height_to_plier = 27;
    height = 50-height_to_plier;
    translate([0, 47-width/2, height_to_plier + height/2])
    #cube([8, width, height], center=true);
  }
}