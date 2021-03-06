/*
 * Large eye for 3D printing
 *
 * Copyright 2016-2017 Matthew Bells
 * BSD3 license, see LICENSE.txt for details.
 */

/*
TODO:
lid rod connections on inside
hinge on lids with rods
*/
// ---------- parameters ----------

ball_dia=50;
ball_thick=3;
camera_dia=7+.5;
camera_inset=10;
ball_joint_len=1;

ball_lid_gap=1;
lid_thick=2;
lid_arm_len=10;
lid_arm_thick=4;
axel_dia=5;
axel_len=10;
axel_len_outer=5;

joint_o_thick=4;
joint_arm_thick=5;
joint_arm_len=1.5;
joint_gap=4;
joint_inner_len=1;
joint_axel_dia=6;

knuckle_thickness=4;
knuckle_axel_gap=0.5;

hinge_arm_len=10;
bolt_to_edge=10;
plate_thick=3;

pin_dia=2.8;
bolt_dia=4;
bolt_head_dia=8;
control_rod_dia=2;

// ----------

// Lid opening: range [0, 1]
lids_open=0.5;

// Assemble: 0 for printing, 1 for visualization
assemble=1;

// Mirror R/L eye: 0 or 1
reflect=0;

// ----------

$fn=50;
epsilon=0.001;

// ---------- features
// Major aspects, calculated from parameters

lid_inner_dia=ball_dia+2*ball_lid_gap;
lid_outer_dia=lid_inner_dia+2*lid_thick;

knuckle_width=axel_dia+2*knuckle_thickness;
knuckle_depth=axel_dia;
knuckle_height=axel_dia*2+2*knuckle_thickness;
joint_len=lid_arm_len;

plate_edge=hinge_arm_len;
plate_len=bolt_to_edge+bolt_head_dia+axel_dia;

bolt_outer=-lid_outer_dia/2-knuckle_depth/2+bolt_head_dia/2-knuckle_depth/2;
bolt_inner=lid_outer_dia/2+knuckle_depth/2-bolt_head_dia/2+knuckle_depth/2;

loose_pin_dia=pin_dia+0.5;

// Check bolt pos:
//translate([bolt_inner,0,-hinge_arm_len-bolt_to_edge])
//cube(size=[1,1,1], center = true);

// ---------- build

eyeball();
eyeball_joint_outer();
eyeball_joint_inner();

// These need to be mirrored:
lid_upper();
lid_lower();
hinge_knuckle_outer();
hinge_knuckle_inner_top();
hinge_knuckle_inner_bottom();
//hinge_knuckle_inner();

// ---------- details

module eyeball() {
    ball_inner_dia=ball_dia-2*ball_thick;
    difference() {
            union() {
            difference() {
                sphere(r = ball_dia/2);

                difference() {
                    sphere(r = ball_dia/2-ball_thick);
                    translate([0,0,ball_dia*3/4])
                    cylinder(h = ball_dia, r=ball_dia/2, center = true);
                }

                translate([0,0,ball_dia/2-camera_inset])
                cylinder(h = ball_dia/4, r1=0, r2=ball_dia/2);

                // camera hole
                translate([0,0,-ball_dia]) cylinder(h = 100, r1=camera_dia/2);

                // back
                translate([0,0,-ball_dia*3/5]) cylinder(h = ball_dia, r=ball_dia/2, center = true);
            }

            // joint
            rotate([0,0,90]) {
                placement=ball_inner_dia/2-ball_joint_len/2;
                translate([placement,0,0]) rotate([0,90,0])
                cylinder(h=ball_joint_len, r=joint_axel_dia/2, center = true);
                translate([-placement,0,0]) rotate([0,90,0])
                cylinder(h=ball_joint_len, r=joint_axel_dia/2, center = true);
            }
        }
        // joint
        rotate([0,90,90])
        cylinder(h=ball_dia+epsilon, r=pin_dia/2, center = true);
    }
}

module eyeball_joint_outer() {
    joint_outer_r=ball_dia/2-ball_thick-joint_gap;
    joint_arm_len_tot=joint_o_thick+joint_arm_len;

    difference() {
        union() {
            translate([0,0,joint_o_thick/2-joint_axel_dia/2])
            difference() {
                cylinder(h=joint_o_thick, r=joint_outer_r, center = true);
                cylinder(h=joint_o_thick+epsilon, r=joint_outer_r-joint_o_thick, center = true);
            }
            inner_placement=joint_outer_r-joint_arm_len_tot/2;
            translate([inner_placement,0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_len_tot, r=joint_axel_dia/2, center = true);
            translate([-inner_placement,0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_len_tot, r=joint_axel_dia/2, center = true);

            rotate([0,0,90]) {
                outer_placement=joint_outer_r-joint_o_thick+joint_arm_len_tot/2;
                translate([outer_placement,0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_len_tot, r=joint_axel_dia/2, center = true);
                translate([-outer_placement,0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_len_tot, r=joint_axel_dia/2, center = true);
            }
        }

        // Holes:
        rotate([0,90,0])
        cylinder(h=joint_outer_r*2+joint_arm_thick*2, r=loose_pin_dia/2, center = true);

        rotate([0,90,90])
        cylinder(h=joint_outer_r*2+joint_arm_thick*2, r=loose_pin_dia/2, center = true);
    }

}

module eyeball_joint_inner() {
    joint_outer_r=ball_dia/2-ball_thick-joint_gap;
    joint_inner_r=joint_outer_r-joint_arm_thick-joint_gap-joint_inner_len;
    joint_len=lid_arm_len;

    rotate((1-assemble)*[90,0,0])
    {
        translate([joint_inner_r,0,0])
        eyeball_joint_inner_arm();
        translate([-joint_inner_r,0,0])
        mirror([1,0,0])
        eyeball_joint_inner_arm();

        translate([0,0,-hinge_arm_len+joint_axel_dia/2])
        cube(size=[joint_inner_r*2+lid_arm_thick,joint_axel_dia,joint_axel_dia], center = true);

        // Mounting plate:
        translate([0,-joint_axel_dia/2,-hinge_arm_len+joint_axel_dia-plate_len/2]) {
            difference() {
                cube(size=[joint_inner_r*2+lid_arm_thick,joint_axel_dia,plate_len], center = true);
                // Bolt hole:
                translate([0,0,joint_axel_dia-plate_len/2])
                rotate([90,0,0])
                cylinder(h=lid_arm_thick*2+epsilon, r=bolt_dia/2, center = true);
            }
        }
    }
}

module eyeball_joint_inner_arm() {
    difference() {
        union() {
            rotate([0,90,0])
            translate([0,0,joint_inner_len/2])
            cylinder(h=lid_arm_thick+joint_inner_len, r=joint_axel_dia/2, center = true);
            translate([0,-joint_axel_dia/4,-joint_len/2])
            cube(size=[lid_arm_thick,joint_axel_dia*1.5,hinge_arm_len], center = true);
        }
        rotate([0,90,0])
        translate([0,0,joint_inner_len/2])
        cylinder(h=lid_arm_thick+joint_inner_len+epsilon, r=pin_dia/2, center = true);

        translate([0,-joint_axel_dia/2,0])
        rotate([-60,0,0])
        translate([0,-joint_axel_dia*1.5/2,-hinge_arm_len/2])
        cube(size=[lid_arm_thick+epsilon,joint_axel_dia*1.5,hinge_arm_len], center = true);
    }
}

module lid_upper() {
    mirror(reflect*[0,1,0])
    rotate(assemble*[90,-90,0])
    translate([0,0,axel_dia/2])
    rotate(assemble*[0,-lids_open*45,0])
    translate([0,0,-axel_dia/2])
    {
        difference() {
            sphere(r = lid_outer_dia/2);
            sphere(r = lid_inner_dia/2);

            // Lower side
            translate([0,0,-lid_outer_dia/2]) cube(size=lid_outer_dia, center = true);

            // Upper side
            translate([0,0,axel_dia])
            rotate([0,-45,0])
            translate([0,0,lid_outer_dia/2]) cube(size=lid_outer_dia, center = true);

            // To be replaced by cylinder:
            translate([-lid_outer_dia/2,0,-outer_dia/2]) cube(size=lid_outer_dia, center = true);
            //rotate([0,45,0])
            //translate([-lid_outer_dia/2,0,-outer_dia/2]) cube(size=lid_outer_dia, center = true);
        }

        // Outer axel:
        translate([0,lid_inner_dia/2+axel_len_outer+lid_thick,axel_dia/2])
        rotate([90,0,0]) cylinder(h=axel_len_outer+lid_thick, r=axel_dia/2);

        // Inner axel and arm:
        translate([0,-lid_inner_dia/2,axel_dia/2])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        rotate([0,90,0])
        translate([-axel_len/2-axel_dia/2,-lid_outer_dia/2-axel_len+lid_arm_thick/2,0]) {
            difference() {
                union() {
                    cube(size=[lid_arm_len,lid_arm_thick,axel_dia], center = true);
                    translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                    cylinder(h=lid_arm_thick, r=axel_dia/2, center = true);
                }
                translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                cylinder(h=lid_arm_thick+epsilon, r=control_rod_dia/2, center = true);
            }
        }
        translate([0,-lid_outer_dia/2-axel_len+lid_arm_thick/2,axel_dia/2])
        rotate([0,45,0])
        translate([-lid_arm_thick,0,0])
        cube(size=[lid_arm_thick*2,lid_arm_thick,axel_dia], center = true);
    }
}

module lid_lower() {
    mirror(reflect*[0,1,0])
    rotate((1-assemble)*[0,180,0])
    rotate(assemble*[90,-90,0])
    translate([0,0,-axel_dia/2])
    rotate(assemble*[0,lids_open*45,0])
    translate([0,0,axel_dia/2])
    {
        difference() {
            sphere(r = lid_outer_dia/2);
            sphere(r = lid_inner_dia/2);

            // Upper side
            translate([0,0,lid_outer_dia/2+axel_dia/2-axel_dia/2]) cube(size=lid_outer_dia, center = true);

            // Lower side
            translate([0,0,-axel_dia])
            rotate([0,45,0])
            translate([0,0,-lid_outer_dia/2])
            cube(size=lid_outer_dia, center = true);

            // To be replaced by cylinder:
            //translate([-lid_outer_dia/2,0,lid_outer_dia/2]) cube(size=lid_outer_dia, center = true);
            rotate([0,-45,0])
            translate([-lid_outer_dia/2,0,lid_outer_dia/2]) cube(size=lid_outer_dia, center = true);
        }

        // Outer axel:
        translate([0,lid_inner_dia/2+axel_len_outer+lid_thick,-axel_dia/2])
        rotate([90,0,0]) cylinder(h=axel_len_outer+lid_thick, r=axel_dia/2);

        // Inner axel and arm:
        translate([0,-lid_inner_dia/2,-axel_dia/2])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        rotate([0,-90,0])
        translate([-axel_len/2-axel_dia/2,-lid_outer_dia/2-axel_len+lid_arm_thick/2,0]) {
            difference() {
                union() {
                    cube(size=[lid_arm_len,lid_arm_thick,axel_dia], center = true);
                    translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                    cylinder(h=lid_arm_thick, r=axel_dia/2, center = true);
                }
                translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                cylinder(h=lid_arm_thick+epsilon, r=control_rod_dia/2, center = true);
            }
        }
        translate([0,-lid_outer_dia/2-axel_len+lid_arm_thick/2,-axel_dia/2])
        rotate([0,-45,0])
        translate([-lid_arm_thick,0,0])
        cube(size=[lid_arm_thick*2,lid_arm_thick,axel_dia], center = true);
    }
}

// ---------- Knuckles

module hinge_knuckle_outer() {
    mirror(reflect*[0,1,0])
    rotate((1-assemble)*[0,-90,0])
    translate(assemble*[-lid_outer_dia/2-knuckle_depth/2,0,0])
    {
        difference() {
            cube(size=[knuckle_depth,knuckle_height,knuckle_width], center = true);
            translate([0,axel_dia/2,0])
            rotate([0,90,0])
            cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+knuckle_axel_gap, center = true);

            translate([0,-axel_dia/2,0])
            rotate([0,90,0])
            cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+knuckle_axel_gap, center = true);
        }

        joint_outer_r=ball_dia/2-ball_thick-joint_arm_thick/2-joint_arm_thick/4-joint_gap;
        joint_inner_r=joint_outer_r-joint_arm_thick-joint_arm_thick/4-joint_arm_thick/4;
        placement=0;

        // Need to calc same z as inner joint:
        ledge_size=hinge_arm_len-knuckle_width/2;
        translate([placement,plate_thick/2,-knuckle_width/2-ledge_size/2])
        cube(size=[knuckle_depth,plate_thick,ledge_size], center = true);

        bolt_offset=bolt_head_dia/2-knuckle_depth/2;

        plat_len=bolt_to_edge+bolt_head_dia/2+plate_edge-knuckle_width/2;
        armp=-knuckle_width/2-plat_len/2;
        boltp=-plate_edge-bolt_to_edge;
        height=joint_arm_thick;

        translate([placement,-height/2,armp])
        difference() {
            union() {
                cube(size=[knuckle_depth,height,plat_len], center = true);
                translate([bolt_offset,0,boltp-armp])
                rotate([90,0,0])
                cylinder(h=height, r=bolt_head_dia/2, center = true);
            }
            // Bolt hole:
            translate([bolt_offset,0,boltp-armp])
            rotate([90,0,0])
            cylinder(h=height+epsilon, r=bolt_dia/2, center = true);
        }
    }
}

module hinge_knuckle_inner_top() {
    mirror(reflect*[0,1,0])
    rotate((assemble-1)*[0,-90,0])
    translate(assemble*[lid_outer_dia/2+knuckle_depth/2,0,0])
    difference() {
        hinge_knuckle_inner();

        translate([0,knuckle_height/2-axel_dia/2,0])
        cube(size=[knuckle_depth*5,knuckle_height,knuckle_width*5], center = true);
    }
}

module hinge_knuckle_inner_bottom() {
    mirror(reflect*[0,1,0])
    rotate((assemble-1)*[0,-90,0])
    translate(assemble*[lid_outer_dia/2+knuckle_depth/2,0,0])
    intersection() {
        hinge_knuckle_inner();

        translate([0,knuckle_height/2-axel_dia/2,0])
        cube(size=[knuckle_depth*5,knuckle_height,knuckle_width*5], center = true);
    }
}

module hinge_knuckle_inner() {
    difference() {
        cube(size=[knuckle_depth,knuckle_height,knuckle_width], center = true);
        translate([0,axel_dia/2,0])
        rotate([0,90,0])
        cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+knuckle_axel_gap, center = true);

        translate([0,-axel_dia/2,0])
        rotate([0,90,0])
        cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+knuckle_axel_gap, center = true);

        cube(size=[knuckle_depth+epsilon,axel_dia+2*knuckle_axel_gap,axel_dia+2*knuckle_axel_gap], center = true);
    }

    joint_outer_r=ball_dia/2-ball_thick-joint_arm_thick/2-joint_arm_thick/4-joint_gap;
    joint_inner_r=joint_outer_r-joint_arm_thick-joint_arm_thick/4-joint_arm_thick/4;
    placement=0;

    // Need to calc same z as inner joint:
    ledge_size=hinge_arm_len-knuckle_width/2;
    translate([placement,plate_thick/2,-knuckle_width/2-ledge_size/2])
    cube(size=[knuckle_depth,plate_thick,ledge_size], center = true);

    bolt_offset=-bolt_head_dia/2+knuckle_depth/2;

    plat_len=bolt_to_edge+bolt_head_dia/2+plate_edge-knuckle_width/2;
    armp=-knuckle_width/2-plat_len/2;
    boltp=-plate_edge-bolt_to_edge;
    height=2*joint_arm_thick;

    translate([placement,-height/2,armp])
    difference() {
        union() {
            cube(size=[knuckle_depth,height,plat_len], center = true);

            translate([bolt_offset,0,boltp-armp])
            rotate([90,0,0])
            cylinder(h=height, r=bolt_head_dia/2, center = true);
        }
        // Bolt hole:
        translate([bolt_offset,0,boltp-armp])
        rotate([90,0,0])
        cylinder(h=height+epsilon, r=bolt_dia/2, center = true);
    }
}
