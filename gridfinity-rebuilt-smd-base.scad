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
gridy = 2;  
// bin height. See bin height information and "gridz_define" below.  
gridz = 6;

/* [Compartments] */
// number of X Divisions (set to zero to have solid bin)
divx = 1;
// number of y Divisions (set to zero to have solid bin)
divy = 1;

/* [Height] */
// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 0; 
// snap gridz height to nearest 7mm increment
enable_zsnap = false;

/* [Features] */
// the type of tabs
style_tab = 1; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
// how should the top lip act
style_lip = 0; //[0: Regular lip, 1:remove lip subtractively, 2: remove lip and retain height]
// scoop weight percentage. 0 disables scoop, 1 is regular scoop. Any real number will scale the scoop. 
scoop = 1; //[0:0.1:1]
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = false;

/* [Base] */
style_hole = 3; // [0:no holes, 1:magnet holes only, 2: magnet and screw holes - no printable slit, 3: magnet and screw holes - printable slit]
// number of divisions per 1 unit of base along the X axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_x = 0;
// number of divisions per 1 unit of base along the Y axis. (default 1, only use integers. 0 means automatically guess the right division)
div_base_y = 0; 



// ===== IMPLEMENTATION ===== //

module smdComponentMagazinesRail() {
    width = 70; // magazine
    lenght = 83.5; // 2 units
    t_foam = 4.5; // foam thicknesss

    t_front = 5; // thickness front
    h_front = 4.5+t_foam;
    angle_front = 10; // degrees

    front_hangover = 5;
    angle_back = 45; // degrees
    t_back = 4;
    h_back = 11+t_foam;
    t_back_hangover = 6.5;
    h_back_hangover = 4; 

    d_between_front_back = 58.5; // distance bweteen front and back

    // front rail part
    difference() {
        union() {
            translate([-t_front,-lenght/2,0])
            cube([t_front,lenght,h_front]);

            translate([-t_front,-lenght/2,h_front])
            cube([t_front+front_hangover,lenght,4]);
        }
        union() {
            translate([0,lenght/2,h_front])
            rotate([180,-angle_front,0])
            cube([t_front+front_hangover,lenght,h_front]);
        }
    }

    // back rail part
    translate([d_between_front_back,0,0])
    union() {
        translate([0,-lenght/2,0])
        cube([t_front,lenght,t_foam/2]);

        translate([0,-lenght/2,0])
        cube([t_back,lenght,h_back-h_back_hangover]);

        translate([0,-lenght/2,h_back-h_back_hangover])
        difference() {
            cube([t_back_hangover,lenght,h_back_hangover]);
        
            union() {
                translate([t_back,0,h_back_hangover])
                rotate([0,angle_back,0])
                cube([t_back_hangover,lenght,h_back_hangover]);

                translate([0,0,3*h_back_hangover/4])
                rotate([0,-angle_back,0])
                cube([t_back_hangover,lenght,h_back_hangover]);
            }
        }
    }   
}

t_base = 6.47; // base thickness
translate([-33,0,t_base])
smdComponentMagazinesRail();
gridfinityBase(2, 2, 42, 0, 0, 1);

