include <gridfinity-rebuilt-utility.scad>
include <standard.scad>

// ===== INFORMATION ===== //
/*
 IMPORTANT: rendering will be better for analyzing the model if fast-csg is enabled. As of writing, this feature is only available in the development builds and not the official release of OpenSCAD, but it makes rendering only take a couple seconds, even for comically large bins. Enable it in Edit > Preferences > Features > fast-csg

https://github.com/kennetek/gridfinity-rebuilt-openscad

*/

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [General Settings] */
// number of bases along x-axis
gridx = 3;  
// number of bases along y-axis   
gridy = 4; 

/* [Screw Together Settings - Defaults work for M3 and 4-40] */
// screw diameter
d_screw = 3.35;
// screw head diameter
d_screw_head = 5;
// screw spacing distance
screw_spacing = .5;
// number of screws per grid block
n_screws = 1; // [1:3]


/* [Fit to Drawer] */
// minimum length of baseplate along x (leave zero to ignore, will automatically fill area if gridx is zero)
distancex = 0;
// minimum length of baseplate along y (leave zero to ignore, will automatically fill area if gridy is zero)
distancey = 0;

// where to align extra space along x
fitx = 0; // [-1:0.1:1]
// where to align extra space along y
fity = 0; // [-1:0.1:1]


/* [Styles] */

// baseplate styles
style_plate = 0; // [0: thin, 1:weighted, 2:skeletonized, 3: screw together, 4: screw together minimal]

// enable magnet hole
enable_magnet = true; 

// hole styles
style_hole = 1; // [0:none, 1:contersink, 2:counterbore]


// ===== IMPLEMENTATION ===== //
screw_together = (style_plate == 3 || style_plate == 4);

//color("tomato") 
//gridfinityBaseplate(gridx, gridy, l_grid, distancex, distancey, style_plate, enable_magnet, style_hole, fitx, fity);
        
difference() {
    height = 4.4;
    radius = 3.6;
    grid_size_y = 41.8-radius/2;
    grid_size_x = 41.15-radius/2;
    
    union() {
        color("tomato") 
        gridfinityBaseplate(gridx, gridy, l_grid, distancex, distancey, style_plate, enable_magnet, style_hole, fitx, fity);
      

        points = [ [-grid_size_x*gridx/2,-grid_size_y*gridy/2,0], [-grid_size_x*gridx/2,grid_size_y*gridy/2,0], [grid_size_x*gridx/2,grid_size_y*gridy/2,0], [grid_size_x*gridx/2,-grid_size_y*gridy/2,0] ];
 
        rounded_box(points, radius, height);
    }
    
    union() {
        m = 1.5; // margin
        bt = 1; // bottom thickness
        // Row 1
        translate([39,-60,bt])
        cylinder(height, d=42+m);
        
        translate([39.5,-16,bt])
        cylinder(height, d=40+m);
        
        translate([40,25,bt])
        cylinder(height, d=36.4+m);
        
        translate([41,63.5,bt])
        cylinder(height, d=33.2+m);
        
        // Row 2
        translate([5,64,bt])
        cylinder(height, d=31.3+m);
        
        translate([4,29.5,bt])
        cylinder(height, d=30.6+m);
        
        translate([3,-4.5,bt])
        cylinder(height, d=29+m);
        
        translate([4,-36.8,bt])
        cylinder(height, d=28.2+m);
        
        translate([3,-68,bt])
        cylinder(height, d=26+m);
        
        // Row 3
        translate([-26,-68,bt])
        cylinder(height, d=26+m);
        
        translate([-25,-38.8,bt])
        cylinder(height, d=24+m);
        
        translate([-26,-11,bt])
        cylinder(height, d=23+m);
        
        translate([-25.5,16,bt])
        cylinder(height, d=23+m);
        
        translate([-25,42.5,bt])
        cylinder(height, d=22+m);
        
        translate([-25,69.5,bt])
        cylinder(height, d=23+m);
        
        // Row 4
        translate([-48,55,bt])
        cylinder(height, d=23+m);
        
        translate([-48,29,bt])
        cylinder(height, d=22+m);
        
        translate([-48,3.5,bt])
        cylinder(height, d=23+m);
        
        translate([-48,-24,bt])
        cylinder(height, d=23+m);
        
        translate([-48,-51.5,bt])
        cylinder(height, d=23+m);
    }
}

// ===== CONSTRUCTION ===== //

module gridfinityBaseplate(gridx, gridy, length, dix, diy, sp, sm, sh, fitx, fity) {
    
    assert(gridx > 0 || dix > 0, "Must have positive x grid amount!");
    assert(gridy > 0 || diy > 0, "Must have positive y grid amount!");

    gx = gridx == 0 ? floor(dix/length) : gridx; 
    gy = gridy == 0 ? floor(diy/length) : gridy; 
    dx = max(gx*length-0.5, dix);
    dy = max(gy*length-0.5, diy);

    off = calculate_off(sp, sm, sh);

    offsetx = dix < dx ? 0 : (gx*length-0.5-dix)/2*fitx*-1;
    offsety = diy < dy ? 0 : (gy*length-0.5-diy)/2*fity*-1;
    
    difference() {
        translate([offsetx,offsety,h_base])
        mirror([0,0,1])
        rounded_rectangle(dx, dy, h_base+off, r_base);
        
        gridfinityBase(gx, gy, length, 1, 1, 0, 0.5, false);
        
        translate([offsetx,offsety,h_base-0.6])
        rounded_rectangle(dx*2, dy*2, h_base*2, r_base);
        
        pattern_linear(gx, gy, length) {
            render(convexity = 6) {

                if (sp == 1)
                    translate([0,0,-off])
                    cutter_weight();
                else if (sp == 2 || sp == 3) 
                    linear_extrude(10*(h_base+off), center = true)
                    profile_skeleton();
                else if (sp == 4) 
                    translate([0,0,-5*(h_base+off)])
                    rounded_square(length-2*r_c2-2*r_c1, 10*(h_base+off), r_fo3);


                hole_pattern(){
                    if (sm) block_base_hole(1);

                    translate([0,0,-off])
                    if (sh == 1) cutter_countersink();
                    else if (sh == 2) cutter_counterbore();
                }
            }
        }
        if (sp == 3 || sp ==4) cutter_screw_together(gx, gy, off);    
    }

}

function calculate_off(sp, sm, sh) = 
    screw_together
        ? 6.75
        :sp==0
            ?0
            : sp==1
                ?bp_h_bot
                :h_skel + (sm
                    ?h_hole
                    : 0)+(sh==0
                        ? d_screw
                        : sh==1
                            ?d_cs
                            :h_cb);

module cutter_weight() {
    union() {
        linear_extrude(bp_cut_depth*2,center=true)
        square(bp_cut_size, center=true);
        pattern_circular(4)
        translate([0,10,0])
        linear_extrude(bp_rcut_depth*2,center=true)
        union() {
            square([bp_rcut_width, bp_rcut_length], center=true);
            translate([0,bp_rcut_length/2,0])
            circle(d=bp_rcut_width);
        }
    }
}
module hole_pattern(){
    pattern_circular(4)
    translate([l_grid/2-d_hole_from_side, l_grid/2-d_hole_from_side, 0]) {
        render();
        children();
    }
}

module cutter_countersink(){
    cylinder(r = r_hole1+d_clear, h = 100*h_base, center = true);     
    translate([0,0,d_cs])
    mirror([0,0,1])
    hull() { 
        cylinder(h = d_cs+10, r=r_hole1+d_clear);
        translate([0,0,d_cs])
        cylinder(h=d_cs+10, r=r_hole1+d_clear+d_cs);
    }
}

module cutter_counterbore(){
    cylinder(h=100*h_base, r=r_hole1+d_clear, center=true);
    difference() {
        cylinder(h = 2*(h_cb+0.2), r=r_cb, center=true);
        copy_mirror([0,1,0])
        translate([-1.5*r_cb,r_hole1+d_clear+0.1,h_cb-h_slit]) 
        cube([r_cb*3,r_cb*3, 10]);
    }
}

module profile_skeleton() {
    l = l_grid-2*r_c2-2*r_c1; 
    minkowski() { 
        difference() {
            square([l-2*r_skel+2*d_clear,l-2*r_skel+2*d_clear], center = true);
            pattern_circular(4)
            translate([l_grid/2-d_hole_from_side,l_grid/2-d_hole_from_side,0])
            minkowski() {
                square([l,l]);
                circle(r_hole2+r_skel+2);
           } 
        }
        circle(r_skel);
    }
}

module cutter_screw_together(gx, gy, off) {

    screw(gx, gy);
    rotate([0,0,90])
    screw(gy, gx);
    
    module screw(a, b) {
        copy_mirror([1,0,0])
        translate([a*l_grid/2, 0, -off/2])
        pattern_linear(1, b, 1, l_grid)
        pattern_linear(1, n_screws, 1, d_screw_head + screw_spacing)
        rotate([0,90,0])
        cylinder(h=l_grid/2, d=d_screw, center = true);
    }
}


 
module rounded_box(points, radius, height){
    hull(){
        for (p = points){
            translate(p) cylinder(r=radius, h=height);
        }
    }
}