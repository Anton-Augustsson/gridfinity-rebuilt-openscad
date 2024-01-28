module mounting_screw(length) {
    screw_diameter = 3.2;
    head_diameter = 5.2;
    head_length = 2.5;

    cylinder(d=screw_diameter, h=length);
    cylinder(d=head_diameter, h=head_length);
}

module plier_divider_screws(height) {
    distance_between_holes = 40;

    translate([0,distance_between_holes/2,0])
    mounting_screw(height);

    translate([0,-distance_between_holes/2,0])
    mounting_screw(height);
}

module plier_divider() {
    mount_thickness = 3;
    mount_width = 8;
    mount_length = 50;
    divider_thickness = 8;
    divider_height = 100; // from bottom not from mount
    divider_length = 27;

    difference() {
        union() {
            // Mount
            translate([0,0,mount_thickness/2])
            cube([mount_width,mount_length,mount_thickness], center=true);

            // Divider rectangle
            translate([0,0,(divider_height-divider_length/2)/2])
            cube([divider_thickness,divider_length,divider_height-divider_length/2], center=true);

            // Divider top circle
            translate([-divider_thickness/2,0,divider_height-divider_length/2])
            rotate([0,90,0])
            #cylinder(d=divider_length, h=divider_thickness);
        }

        translate([0,0,-12/2])
        #plier_divider_screws(12);
    }
}

module plier_stand_screws(height) {
    distance_between_holes = 20;

    translate([0,distance_between_holes/2,0])
    mounting_screw(height);

    translate([0,-distance_between_holes/2,0])
    mounting_screw(height);
}

module plier_stand() {
    width = 20;

    mount_thickness = 3;
    mount_length = 34;
    stand_height = 50; // from bottom not from mount
    stand_length = 30;

    difference() {
        union() {
            translate([0,0,mount_thickness/2])
            #cube([width,mount_length,mount_thickness], center=true);

            translate([0,stand_length+(mount_length-stand_length)/2,stand_height/2])
            cube([width,stand_length,stand_height], center=true);
        }

        translate([0,0,-12/2])
        plier_stand_screws(12);
    }
}

