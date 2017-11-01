/*
 * Head build plate for laser cutting.
 *
 * Copyright 2017 Matthew Bells
 * BSD3 license, see LICENSE.txt for details.
 */

// ---------- parameters ----------

head_dia=170;

stand_height=50;
stand_length1=40;
stand_length2=30;

eyelid_motor_space1=15;
eyelid_motor_space2=45;
eyelid_motor_pos=15;

eyeball_motor_space1=25;
eyeball_motor_space2=45;
eyeball_motor_pos=-35;

slot_thickness=3;
slot_length=30;

bolt_to_edge=10;
bolt_dia=4;
bolt_head_dia=8;

separation=3;

// From other model:
ball_dia=50;

ball_lid_gap=1;
lid_thick=2;

axel_dia=5;


// ----------

$fn=100;
epsilon=0.001;

// ---------- features
// Major aspects, calculated from parameters

lid_inner_dia=ball_dia+2*ball_lid_gap;
lid_outer_dia=lid_inner_dia+2*lid_thick;

knuckle_depth=axel_dia;

bolt_outer=-lid_outer_dia/2-knuckle_depth/2+bolt_head_dia/2-knuckle_depth/2;
bolt_inner=lid_outer_dia/2+knuckle_depth/2-bolt_head_dia/2+knuckle_depth/2;

// ---------- build

//platform();
stands();

module platform() {
    difference() {
        // Front is square, back is round;
        union() {
            circle(d=head_dia);
            translate([-head_dia/4,0])
            square(size=[head_dia/2,head_dia],center=true);
        }

        // Eyeball motors:
        motor9g(eyeball_motor_pos, -eyeball_motor_space1, 90);
        motor9g(eyeball_motor_pos,  eyeball_motor_space1, 90);

        motor9g(eyeball_motor_pos, -eyeball_motor_space2, 90);
        motor9g(eyeball_motor_pos,  eyeball_motor_space2, 90);

        // TODO move out
        // Eyelid motors:
        motorMG995(eyelid_motor_pos, -eyelid_motor_space1, 90);
        motorMG995(eyelid_motor_pos,  eyelid_motor_space1, 90);

        motorMG995(eyelid_motor_pos, -eyelid_motor_space2, 90);
        motorMG995(eyelid_motor_pos,  eyelid_motor_space2, 90);

        // Stand:
        stand_y=head_dia/2-stand_length2/2;
        translate([-45,stand_y])
        square(size=[slot_length,slot_thickness],center=true);
        translate([-45,-stand_y])
        square(size=[slot_length,slot_thickness],center=true);

        translate([head_dia/2-stand_length2/2,0])
        square(size=[slot_thickness,slot_length],center=true);

        // Eye mount:
        placement=head_dia/2+bolt_outer-2*bolt_dia;
        translate([-head_dia/2,-placement]) {
            eye_mount();
        }
        translate([-head_dia/2,placement]) {
            mirror([0,1,0])
            eye_mount();
        }

        // TODO RaspPi platform mount

        translate([-head_dia/4,0])
        circle(d=bolt_dia);
        translate([-head_dia/4+15,0])
        circle(d=bolt_dia);
    }
}

module eye_mount() {
    translate([bolt_to_edge,0]) {
        circle(d=bolt_dia, center = true);

        translate([0,bolt_outer])
        circle(d=bolt_dia, center = true);

        translate([0,bolt_inner])
        circle(d=bolt_dia, center = true);
    }
}

// ---------- Motor dimensions:

module motor9g(x, y, r) {
    translate([x,y])
    rotate([0,0,r]) {
        square(size=[12,24],center=true);

        bolt_dia=2;
        spacing=27.8;
        translate([0,spacing/2])
        circle(d=bolt_dia, center = true);
        translate([0,-spacing/2])
        circle(d=bolt_dia, center = true);
    }
}

module motorMG995(x, y, r) {
    translate([x,y])
    rotate([0,0,r]){
        square(size=[20.5,41],center=true);

        bolt_dia=3.7;
        spacing_long=49;
        spacing_side=10;
        translate([spacing_side/2,spacing_long/2])
        circle(d=bolt_dia, center = true);
        translate([spacing_side/2,-spacing_long/2])
        circle(d=bolt_dia, center = true);
        translate([-spacing_side/2,spacing_long/2])
        circle(d=bolt_dia, center = true);
        translate([-spacing_side/2,-spacing_long/2])
        circle(d=bolt_dia, center = true);
    }
}

// ---------- Stands:

module stands() {
    translate([head_dia,0]) {
        translate([0,-stand_length1/2-separation/2]) stand(true);
        translate([0,stand_length2/2+separation/2]) stand(false);

        offset=stand_height+slot_thickness+separation;
        translate([offset,-stand_length1/2-separation/2]) stand(true);
        translate([offset,stand_length2/2+separation/2]) stand(false);
    }
}

module stand(tab) {
    if(tab) {
        translate([-stand_height/2,0])
        square(size=[slot_thickness,slot_length],center=true);
    }
    difference()
    {
        if(tab) {
            square(size=[stand_height,stand_length1],center=true);
        } else {
            square(size=[stand_height,stand_length2],center=true);
        }

        translate([stand_height/4,0])
        square(size=[stand_height/2+epsilon,slot_thickness],center=true);
    }

}
