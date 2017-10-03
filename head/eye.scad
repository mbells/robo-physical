/*
 * Large eye for 3D printing
 *
 * Copyright 2016 Matthew Bells
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
lid_arm_len=10;
lid_arm_thick=3;

joint_arm_thick=4;
joint_gap=0.5;

rod_dia=2;

plate_len=40;

lids_open=1;

// ----------

$fn=50;
epsilon=0.001;

lid_inner_dia=ball_dia+2*ball_lid_gap;
lid_outer_dia=lid_inner_dia+2*lid_thick;

eyeball();
eyeball_joint_outer();
eyeball_joint_inner();
//lid_upper();
//lid_lower();



module eyeball() {
    rotate([0,90,0])
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
}

module eyeball_joint_outer() {
    joint_outer_dia=ball_dia/2-ball_thick-1.5*ball_lid_gap;
    //rotate([0,90,0])
    //translate([0,0,-ball_dia*1/14])
    {
        difference() {
            union() {
                translate([0,0,-lid_arm_thick/2]) difference() {
                    cylinder(h = lid_arm_thick, r=joint_outer_dia, center = true);
                    cylinder(h = lid_arm_thick+epsilon, r=joint_outer_dia-lid_arm_thick, center = true);
                }
                translate([joint_outer_dia-joint_arm_thick/2,0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
                translate([-(joint_outer_dia-joint_arm_thick/2),0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);

                rotate([0,0,90]) {
                    translate([joint_outer_dia-lid_arm_thick+joint_arm_thick/2,0,0]) rotate([0,90,0])
                    cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
                    translate([-(joint_outer_dia-lid_arm_thick+joint_arm_thick/2),0,0]) rotate([0,90,0])
                    cylinder(h=joint_arm_thick, r=axel_dia/2, center = true);
                }
            }
            //translate([0,0,-lid_arm_thick/2])
            //cylinder(h = lid_arm_thick+epsilon, r=joint_outer_dia-lid_arm_thick, center = true);

            translate([joint_outer_dia-joint_arm_thick/2,0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);
            translate([-(joint_outer_dia-joint_arm_thick/2),0,0]) rotate([0,90,0])
            cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);

            rotate([0,0,90]) {
                translate([joint_outer_dia-lid_arm_thick+joint_arm_thick/2,0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);
                translate([-(joint_outer_dia-lid_arm_thick+joint_arm_thick/2),0,0]) rotate([0,90,0])
                cylinder(h=joint_arm_thick+1, r=rod_dia/2, center = true);
            }
        }
    }
}

module eyeball_joint_inner() {
    joint_outer_dia=ball_dia/2-ball_thick-1.5*ball_lid_gap;
    joint_inner_dia=joint_outer_dia-joint_arm_thick-joint_gap-lid_arm_thick/2;
    joint_len=lid_arm_len;

    {
        translate([joint_inner_dia,0,0]) {
            difference() {
                union() {
                    rotate([0,90,0])
                    cylinder(h=lid_arm_thick, r=axel_dia/2, center = true);
                    translate([0,0,-joint_len/2])
                    cube(size=[lid_arm_thick,axel_dia,joint_len], center = true);
                }
                rotate([0,90,0])
                cylinder(h=lid_arm_thick+epsilon, r=rod_dia/2, center = true);
            }
        }
        translate([-joint_inner_dia,0,0]) {
            difference() {
                union() {
                    rotate([0,90,0])
                    cylinder(h=lid_arm_thick, r=axel_dia/2, center = true);
                    translate([0,0,-joint_len/2])
                    cube(size=[lid_arm_thick,axel_dia,joint_len], center = true);
                }
                rotate([0,90,0])
                cylinder(h=lid_arm_thick+epsilon, r=rod_dia/2, center = true);
            }
        }
        translate([0,0,-joint_len])
        cube(size=[joint_inner_dia*2+lid_arm_thick,axel_dia,axel_dia], center = true);

        // Mounting plate:
        translate([0,-lid_arm_thick,-joint_len-plate_len/4+lid_arm_thick]) {
            difference() {
                union() {
                    rotate([90,0,0])
                    cylinder(h=lid_arm_thick, r=joint_arm_thick/2, center = true);
                    difference() {
                        cube(size=[joint_inner_dia*2+lid_arm_thick,axel_dia,plate_len/2], center = true);


                        translate([0,0,plate_len/3-lid_arm_thick])
                        rotate([-45,0,0])
                        cube(size=[joint_inner_dia*2+lid_arm_thick+epsilon,axel_dia,plate_len/2], center = true);

                        translate([0,-lid_arm_thick,-lid_arm_thick])
                        rotate([10,0,0])
                        cube(size=[joint_inner_dia*2+lid_arm_thick+epsilon,axel_dia,plate_len/2], center = true);
                    }
                }
                // Bolt hole:
                rotate([90,0,0])
                cylinder(h=lid_arm_thick*2+epsilon, r=rod_dia/2, center = true);
            }
        }
    }
}

module lid_upper() {

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

        translate([0,lid_inner_dia/2+axel_len+lid_thick,0])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        translate([0,-lid_inner_dia/2,0])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        rotate([0,45,0])
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
    }
}

module lid_lower() {
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

        translate([0,lid_inner_dia/2+axel_len+lid_thick,0])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        translate([0,-lid_inner_dia/2,0])
        rotate([90,0,0]) cylinder(h=axel_len+lid_thick, r=axel_dia/2);

        rotate([0,-45,0])
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
    }
}
