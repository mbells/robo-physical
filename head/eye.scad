/*
 * Large eye for 3D printing
 *
 * Copyright 2016-2017 Matthew Bells
 * BSD3 license, see LICENSE.txt for details.
 */

// ---------- parameters ----------

ball_dia=50;
ball_thick=3;
camera_dia=7+.5;
camera_inset=10;

ball_lid_gap=1;
lid_thick=2;

axel_dia=5;
axel_len=10;
axel_len_outer=5;
lid_arm_len=10;
lid_arm_thick=3;

joint_arm_thick=4;
joint_gap=0.5;

rod_dia=2;
bolt_dia=4;
bolt_head_dia=8;
bolt_pos=10;

hinge_arm_len=10;
plate_len=40;
knucle_thickness=4;

// ----------

lids_open=0;

// ----------

$fn=50;
epsilon=0.001;

// ---------- features
// Major aspects, calculated from parameters

lid_inner_dia=ball_dia+2*ball_lid_gap;
lid_outer_dia=lid_inner_dia+2*lid_thick;

knuckle_width=axel_dia+2*knucle_thickness;
knuckle_depth=axel_dia;
knuckle_height=axel_dia*2+2*knucle_thickness;
joint_len=lid_arm_len;

plate_edge=hinge_arm_len;

// ---------- build

eyeball();
eyeball_joint_outer();
eyeball_joint_inner();
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
                translate([ball_inner_dia/2,0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
                translate([-ball_inner_dia/2,0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
            }
        }
        // joint
        rotate([0,0,90]) {
            translate([ball_inner_dia/2,0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick+ball_thick, r=rod_dia/2, center = true);
            translate([-ball_inner_dia/2,0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick+ball_thick, r=rod_dia/2, center = true);
        }
    }
}

module eyeball_joint_outer() {
    joint_outer_r=ball_dia/2-ball_thick-joint_arm_thick/2-joint_arm_thick/4-joint_gap;

    difference() {
        union() {
            translate([0,0,-lid_arm_thick/2]) difference() {
                cylinder(h = lid_arm_thick, r=joint_outer_r, center = true);
                cylinder(h = lid_arm_thick+epsilon, r=joint_outer_r-lid_arm_thick, center = true);
            }
            translate([joint_outer_r-joint_arm_thick/2,0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
            translate([-(joint_outer_r-joint_arm_thick/2),0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);

            rotate([0,0,90]) {
                translate([joint_outer_r-lid_arm_thick+joint_arm_thick/2,0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
                translate([-(joint_outer_r-lid_arm_thick+joint_arm_thick/2),0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
            }
        }

        translate([joint_outer_r-joint_arm_thick/2,0,0]) rotate([0,90,0])
        cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);
        translate([-(joint_outer_r-joint_arm_thick/2),0,0]) rotate([0,90,0])
        cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);

        rotate([0,0,90]) {
            translate([joint_outer_r-lid_arm_thick+joint_arm_thick/2,0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);
            translate([-(joint_outer_r-lid_arm_thick+joint_arm_thick/2),0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);
        }
    }

}

module eyeball_joint_inner() {
    joint_outer_r=ball_dia/2-ball_thick-joint_arm_thick/2-joint_arm_thick/4-joint_gap;
    joint_inner_r=joint_outer_r-joint_arm_thick-joint_arm_thick/4-joint_arm_thick/4;
    joint_len=lid_arm_len;

    {
        translate([joint_inner_r,0,0])
        eyeball_joint_inner_arm();
        translate([-joint_inner_r,0,0])
        eyeball_joint_inner_arm();

        translate([0,0,-hinge_arm_len+axel_dia/2])
        cube(size=[joint_inner_r*2+lid_arm_thick,axel_dia,axel_dia], center = true);

        // Mounting plate:
        backset=bolt_pos/2;
        translate([0,-lid_arm_thick,-hinge_arm_len-bolt_pos+backset]) {
            difference() {
                union() {
                    translate([0,0,-backset])
                    rotate([90,0,0])
                    cylinder(h=axel_dia*.8, r=bolt_head_dia/2, center = true);
                    difference() {
                        cube(size=[joint_inner_r*2+lid_arm_thick,axel_dia,plate_len/2], center = true);


                        translate([0,0,plate_len/3-lid_arm_thick])
                        rotate([-45,0,0])
                        cube(size=[joint_inner_r*2+lid_arm_thick+epsilon,axel_dia,plate_len/2], center = true);

                        translate([0,-lid_arm_thick,-lid_arm_thick])
                        rotate([10,0,0])
                        cube(size=[joint_inner_r*2+lid_arm_thick+epsilon,axel_dia,plate_len/2], center = true);
                    }
                }
                // Bolt hole:
                translate([0,0,-backset])
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
            cylinder(h=lid_arm_thick, r=axel_dia/2, center = true);
            translate([0,0,-joint_len/2])
            cube(size=[lid_arm_thick,axel_dia,hinge_arm_len], center = true);
        }
        rotate([0,90,0])
        cylinder(h=lid_arm_thick+epsilon, r=rod_dia/2, center = true);
    }
}

module lid_upper() {
    rotate([90,-90,0])
    translate([0,0,axel_dia/2])
    rotate([0,-lids_open*45,0])
    {
        difference() {
            sphere(r = lid_outer_dia/2);
            sphere(r = lid_inner_dia/2);

            // Lower side
            translate([0,0,-lid_outer_dia/2-axel_dia/2]) cube(size=lid_outer_dia, center = true);

            // Upper side
            rotate([0,-45,0])
            translate([0,0,lid_outer_dia/2+axel_dia/2]) cube(size=lid_outer_dia, center = true);

            // To be replaced by cylinder:
            translate([-lid_outer_dia/2,0,-outer_dia/2]) cube(size=lid_outer_dia, center = true);
            rotate([0,45,0])
            translate([-lid_outer_dia/2,0,-outer_dia/2]) cube(size=lid_outer_dia, center = true);
        }

        translate([0,lid_inner_dia/2+axel_len_outer+lid_thick,0])
        rotate([90,0,0]) cylinder(h=axel_len_outer+lid_thick, r=axel_dia/2);

        translate([0,-lid_inner_dia/2,0])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        rotate([0,90,0])
        translate([-axel_len/2,-lid_outer_dia/2-axel_len+lid_arm_thick/2,0]) {
            difference() {
                union() {
                    cube(size=[lid_arm_len,lid_arm_thick,axel_dia], center = true);
                    translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                    cylinder(h=lid_arm_thick, r=axel_dia/2, center = true);
                }
                translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                cylinder(h=lid_arm_thick+epsilon, r=rod_dia/2, center = true);
            }
        }
        translate([0,-lid_outer_dia/2-axel_len+lid_arm_thick/2,0])
        rotate([0,45,0])
        translate([-lid_arm_thick,0,0])
        cube(size=[lid_arm_thick*2,lid_arm_thick,axel_dia], center = true);
    }
}

module lid_lower() {
    rotate([90,-90,0])
    translate([0,0,-axel_dia/2])
    rotate([0,lids_open*45,0])
    {
        difference() {
            sphere(r = lid_outer_dia/2);
            sphere(r = lid_inner_dia/2);

            // Upper side
            translate([0,0,lid_outer_dia/2+axel_dia/2]) cube(size=lid_outer_dia, center = true);

            // Lower side
            rotate([0,45,0])
            translate([0,0,-(lid_outer_dia/2+axel_dia/2)]) cube(size=lid_outer_dia, center = true);

            // To be replaced by cylinder:
            translate([-lid_outer_dia/2,0,lid_outer_dia/2]) cube(size=lid_outer_dia, center = true);
            rotate([0,-45,0])
            translate([-lid_outer_dia/2,0,lid_outer_dia/2]) cube(size=lid_outer_dia, center = true);
        }

        translate([0,lid_inner_dia/2+axel_len_outer+lid_thick,0])
        rotate([90,0,0]) cylinder(h=axel_len_outer+lid_thick, r=axel_dia/2);

        translate([0,-lid_inner_dia/2,0])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        rotate([0,-90,0])
        translate([-axel_len/2,-lid_outer_dia/2-axel_len+lid_arm_thick/2,0]) {
            difference() {
                union() {
                    cube(size=[lid_arm_len,lid_arm_thick,axel_dia], center = true);
                    translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                    cylinder(h=lid_arm_thick, r=axel_dia/2, center = true);
                }
                translate([-lid_arm_len/2,0,0]) rotate([90,0,0])
                cylinder(h=lid_arm_thick+epsilon, r=rod_dia/2, center = true);
            }
        }
        translate([0,-lid_outer_dia/2-axel_len+lid_arm_thick/2,0])
        rotate([0,-45,0])
        translate([-lid_arm_thick,0,0])
        cube(size=[lid_arm_thick*2,lid_arm_thick,axel_dia], center = true);
    }
}

// ---------- Knuckles

module hinge_knuckle_outer() {
    translate([-lid_outer_dia/2-knuckle_depth/2,0,0])
    difference() {
        cube(size=[knuckle_depth,knuckle_height,knuckle_width], center = true);
        translate([0,axel_dia/2,0])
        rotate([0,90,0])
        cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+joint_gap, center = true);

        translate([0,-axel_dia/2,0])
        rotate([0,90,0])
        cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+joint_gap, center = true);
    }

    joint_outer_r=ball_dia/2-ball_thick-joint_arm_thick/2-joint_arm_thick/4-joint_gap;
    joint_inner_r=joint_outer_r-joint_arm_thick-joint_arm_thick/4-joint_arm_thick/4;
    placement=-lid_outer_dia/2-knuckle_depth/2;

    // Need to calc same z as inner joint:
    ledge_size=hinge_arm_len-knuckle_width/2;
    translate([placement,0,-knuckle_width/2-ledge_size/2])
    cube(size=[knuckle_depth,joint_arm_thick,ledge_size], center = true);

    bolt_offset=bolt_head_dia/2-knuckle_depth/2;

    backset=bolt_head_dia/2;
    plat_len=hinge_arm_len+bolt_pos;

    translate([placement,-lid_arm_thick,-hinge_arm_len-bolt_pos+knuckle_width/2])
    difference() {
        union() {
            cube(size=[knuckle_depth,joint_arm_thick,plat_len], center = true);
            translate([bolt_offset,0,-plat_len/2+backset])
            rotate([90,0,0])
            cylinder(h=axel_dia*.8, r=bolt_head_dia/2, center = true);
        }
        // Bolt hole:
        translate([bolt_offset,0,-plat_len/2+backset])
        rotate([90,0,0])
        cylinder(h=lid_arm_thick*2+epsilon, r=bolt_dia/2, center = true);
    }
}

module hinge_knuckle_inner_top() {
    difference() {
        hinge_knuckle_inner();

        translate([lid_outer_dia/2+knuckle_depth/2,knuckle_height/2-axel_dia/2,0])
        cube(size=[knuckle_depth*5,knuckle_height,knuckle_width*5], center = true);
    }
}

module hinge_knuckle_inner_bottom() {
    intersection() {
        hinge_knuckle_inner();

        translate([lid_outer_dia/2+knuckle_depth/2,knuckle_height/2-axel_dia/2,0])
        cube(size=[knuckle_depth*5,knuckle_height,knuckle_width*5], center = true);
    }
}

module hinge_knuckle_inner() {
    translate([lid_outer_dia/2+knuckle_depth/2,0,0])
    difference() {
        cube(size=[knuckle_depth,knuckle_height,knuckle_width], center = true);
        translate([0,axel_dia/2,0])
        rotate([0,90,0])
        cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+joint_gap, center = true);

        translate([0,-axel_dia/2,0])
        rotate([0,90,0])
        cylinder(h=knuckle_depth+epsilon, r=axel_dia/2+joint_gap, center = true);

        cube(size=[knuckle_depth+epsilon,axel_dia+2*joint_gap,axel_dia+2*joint_gap], center = true);
    }

    joint_outer_r=ball_dia/2-ball_thick-joint_arm_thick/2-joint_arm_thick/4-joint_gap;
    joint_inner_r=joint_outer_r-joint_arm_thick-joint_arm_thick/4-joint_arm_thick/4;
    placement=lid_outer_dia/2+knuckle_depth/2;

    // Need to calc same z as inner joint:
    ledge_size=hinge_arm_len-knuckle_width/2;
    translate([placement,0,-knuckle_width/2-ledge_size/2])
    cube(size=[knuckle_depth,joint_arm_thick,ledge_size], center = true);

    bolt_offset=-bolt_head_dia/2+knuckle_depth/2;
    backset=bolt_head_dia/2;
    plat_len=hinge_arm_len+bolt_pos;

    translate([placement,-lid_arm_thick,-hinge_arm_len-bolt_pos+knuckle_width/2])
    difference() {
        union() {
            cube(size=[knuckle_depth,joint_arm_thick,plat_len], center = true);

            translate([0,-joint_arm_thick,0])
            cube(size=[knuckle_depth,joint_arm_thick,plat_len], center = true);

            translate([bolt_offset,0,-plat_len/2+backset])
            rotate([90,0,0])
            cylinder(h=axel_dia*.8, r=bolt_head_dia/2, center = true);

            translate([bolt_offset,-joint_arm_thick,-plat_len/2+backset])
            rotate([90,0,0])
            cylinder(h=axel_dia*.8, r=bolt_head_dia/2, center = true);
        }
        // Bolt hole:
        translate([bolt_offset,0,-plat_len/2+backset])
        rotate([90,0,0])
        cylinder(h=lid_arm_thick*4+epsilon, r=bolt_dia/2, center = true);

    }
}
