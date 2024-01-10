include <gridfinity-rebuilt-utility.scad>

// ===== INFORMATION ===== //
/*
 IMPORTANT: rendering will be better for analyzing the model if fast-csg is enabled. As of writing, this feature is only available in the development builds and not the official release of OpenSCAD, but it makes rendering only take a couple seconds, even for comically large bins. Enable it in Edit > Preferences > Features > fast-csg
 the magnet holes can have an extra cut in them to make it easier to print without supports
 tabs will automatically be disabled when gridz is less than 3, as the tabs take up too much space
 base functions can be found in "gridfinity-rebuilt-utility.scad"
 examples at end of file

 BIN HEIGHT
 the original gridfinity bins had the overall height defined by 7mm increments
 a bin would be 7*u millimeters tall
 the lip at the top of the bin (3.8mm) added onto this height
 The stock bins have unit heights of 2, 3, and 6:
 Z unit 2 -> 7*2 + 3.8 -> 17.8mm
 Z unit 3 -> 7*3 + 3.8 -> 24.8mm
 Z unit 6 -> 7*6 + 3.8 -> 45.8mm

https://github.com/kennetek/gridfinity-rebuilt-openscad

*/

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [General Settings] */
// number of bases along x-axis
gridx = 1;  
// number of bases along y-axis   
gridy = 4;
// bin height. See bin height information and "gridz_define" below.  
gridz = 4;

/* [Compartments] */
// number of X Divisions (set to zero to have solid bin)
divx = 0;
// number of y Divisions (set to zero to have solid bin)
divy = 0;

/* [Height] */
// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 0; 
// snap gridz height to nearest 7mm increment
enable_zsnap = false;

/* [Features] */
// the type of tabs
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
// how should the top lip act
style_lip = 0; //[0: Regular lip, 1:remove lip subtractively, 2: remove lip and retain height]
// scoop weight percentage. 0 disables scoop, 1 is regular scoop. Any real number will scale the scoop. 
scoop = 0; //[0:0.1:1]
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = true;
// Midle devider 
devider = true;

/* [Base] */
style_hole = 3; // [0:no holes, 1:magnet holes only, 2: magnet and screw holes - no printable slit, 3: magnet and screw holes - printable slit]
// number of divisions per 1 unit of base along the X axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_x = 0;
// number of divisions per 1 unit of base along the Y axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_y = 0; 


// ===== IMPLEMENTATION ===== //

module blade_cylinder_storage(height) {
    diameter = 14.1;
    lenght = 53;

    rotate([90,0,0])
    cylinder(d=diameter, h=lenght, center=true);

    translate([0,0,height/2])
    cube([diameter,lenght,height], center=true);
}

module blade_protector(height) {
    diameter_blade = 14.5;
    thickness_protector = 5.6;
    lenght_thin_protector = 25.5;
    lenght_blade = 51.5;

    translate([0,lenght_thin_protector/2,0])
    rotate([90,0,0])
    cylinder(d=diameter_blade, h=lenght_blade-lenght_thin_protector, center=true);

    translate([0,0,height/2-thickness_protector/2])
    cube([diameter_blade,lenght_blade,height], center=true);
}


module scalpel(height) {
    diameter_handle = 8.4;
    lenght_handle = 103.4;
    lenght_blade = 51.5;

    // Handle
    translate([0,lenght_handle/2,0])
    union() {
        rotate([90,0,0])
        cylinder(d=diameter_handle, h=lenght_handle+0.05, center=true);

        translate([0,0,height/2])
        cube([diameter_handle,lenght_handle+0.05,height], center=true);
    }

    // blade
    translate([0,-lenght_blade/2,0])
    blade_protector(height);
}


difference() {
    union() {
        color("tomato") {
        gridfinityInit(gridx, gridy, height(gridz, gridz_define, style_lip, enable_zsnap), height_internal) {

        if (divx > 0 && divy > 0)
        cutEqual(n_divx = divx, n_divy = divy, style_tab = style_tab, scoop_weight = scoop);
        }

        gridfinityBase(gridx, gridy, l_grid, div_base_x, div_base_y, style_hole, only_corners=only_corners);
        }
        
    }

    union() {
        translate([-8,45,14])
        blade_cylinder_storage(20);

        translate([8,-25,18])
        scalpel(20);

        translate([-9,-50,18])
        blade_protector(20);

        translate([-22,-10,14])
        cube([45,30,25]);
        translate([-14.4,-30,14])
        cube([11,20,25]);
    }
}

