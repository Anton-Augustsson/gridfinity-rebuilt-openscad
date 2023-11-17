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

/*
color("tomato") {
gridfinityInit(gridx, gridy, height(gridz, gridz_define, style_lip, enable_zsnap), height_internal) {

    if (divx > 0 && divy > 0)
    cutEqual(n_divx = divx, n_divy = divy, style_tab = style_tab, scoop_weight = scoop);
}
gridfinityBase(gridx, gridy, l_grid, div_base_x, div_base_y, style_hole, only_corners=only_corners);

}
*/


// ===== EXAMPLES ===== //

// 3x3 even spaced grid
/*
gridfinityInit(3, 3, height(6), 0, 42) {
	cutEqual(n_divx = 3, n_divy = 3, style_tab = 0, scoop_weight = 0);
}
gridfinityBase(3, 3, 42, 0, 0, 1);
*/

// Compartments can be placed anywhere (this includes non-integer positions like 1/2 or 1/3). The grid is defined as (0,0) being the bottom left corner of the bin, with each unit being 1 base long. Each cut() module is a compartment, with the first four values defining the area that should be made into a compartment (X coord, Y coord, width, and height). These values should all be positive. t is the tab style of the compartment (0:full, 1:auto, 2:left, 3:center, 4:right, 5:none). s is a toggle for the bottom scoop. 

//gridfinityInit(3, 3, height(6), 0, 42) {
//    cut(x=0, y=0, w=1.5, h=0.5, t=5, s=0);
//    cut(0, 0.5, 1.5, 0.5, 5, 0);
//    cut(0, 1, 1.5, 0.5, 5, 0);
//    
//    cut(0,1.5,0.5,1.5,5,0);
//    cut(0.5,1.5,0.5,1.5,5,0);
//    cut(1,1.5,0.5,1.5,5,0);
//    
//    cut(1.5, 0, 1.5, 5/3, 2);
//    cut(1.5, 5/3, 1.5, 4/3, 4);
//}

module smdComponentMagazinesRail() {
    width = 70; // magazine
    lenght = 83.5; // 2 units
    t_foam = 4.5; // foam thicknesss

    t_front = 8; // thickness front
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
translate([-29,0,t_base])
smdComponentMagazinesRail();
gridfinityBase(2, 2, 42, 0, 0, 1);



// Compartments can overlap! This allows for weirdly shaped compartments, such as this "2" bin. 
/*
gridfinityInit(3, 3, height(6), 0, 42)  {
    cut(0,2,2,1,5,0);
    cut(1,0,1,3,5);
    cut(1,0,2,1,5);
    cut(0,0,1,2);
    cut(2,1,1,2);
}
gridfinityBase(3, 3, 42, 0, 0, 1);
*/

// Areas without a compartment are solid material, where you can put your own cutout shapes. using the cut_move() function, you can select an area, and any child shapes will be moved from the origin to the center of that area, and subtracted from the block. For example, a pattern of three cylinderical holes.
/*
gridfinityInit(3, 3, height(6), 0, 42) {
    cut(x=0, y=0, w=2, h=3);
    cut(x=0, y=0, w=3, h=1, t=5);
    cut_move(x=2, y=1, w=1, h=2) 
        pattern_linear(x=1, y=3, sx=42/2) 
            cylinder(r=5, h=1000, center=true);
}
gridfinityBase(3, 3, 42, 0, 0, 1);
*/

// You can use loops as well as the bin dimensions to make different parametric functions, such as this one, which divides the box into columns, with a small 1x1 top compartment and a long vertical compartment below
/*
gx = 3;
gy = 3;
gridfinityInit(gx, gy, height(6), 0, 42) {
    for(i=[0:gx-1]) {
        cut(i,0,1,gx-1);
        cut(i,gx-1,1,1);
    }
}
gridfinityBase(gx, gy, 42, 0, 0, 1);
*/

// Pyramid scheme bin
/*
gx = 4.5;
gy = 4;
gridfinityInit(gx, gy, height(6), 0, 42) {
    for (i = [0:gx-1]) 
    for (j = [0:i])
    cut(j*gx/(i+1),gy-i-1,gx/(i+1),1,0);
}
gridfinityBase(gx, gy, 42, 0, 0, 1);
*/