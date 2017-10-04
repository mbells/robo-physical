/*
 * Head build plate for laser cutting.
 *
 * Copyright 2017 Matthew Bells
 * BSD3 license, see LICENSE.txt for details.
 */

head_dia=150;

stand_height=50;
stand_length=50;

eyelid_motor_space1=15;
eyelid_motor_space2=45;
eyelid_motor_pos=15;

eyeball_motor_space1=30;
eyeball_motor_space2=50;
eyeball_motor_pos=-30;

slot_thickness=3;
slot_length=40;

bolt_dia=4;

separation=3;

$fn=100;

stands();

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

    // Eyelid motors:
    motorMG995(eyelid_motor_pos, -eyelid_motor_space1, 90);
    motorMG995(eyelid_motor_pos,  eyelid_motor_space1, 90);

    motorMG995(eyelid_motor_pos, -eyelid_motor_space2, 90);
    motorMG995(eyelid_motor_pos,  eyelid_motor_space2, 90);

    // Stand:
    translate([-40,0])
    square(size=[slot_length,slot_thickness],center=true);

    translate([50,0]) 
    square(size=[slot_thickness,slot_length],center=true);

    // Eye mount:
    lid_arm_thick=3;
    plate_len=40;
    bolt_offset=plate_len/2-lid_arm_thick*2;
    translate([-head_dia/2+bolt_offset,0]) {
        translate([0,-head_dia/4])
        circle(d=bolt_dia, center = true);

        translate([0,head_dia/4])
        circle(d=bolt_dia, center = true);
    }
}

// ---------- Motor dimensions:

module motor9g(x, y, r) {
    translate([x,y])
    rotate([0,0,r])
    translate([0,-center_dia * conduit_center]) square(size=[12,24],center=true);
    // TODO bolt holes
}

module motorMG995(x, y, r) {
    translate([x,y])
    rotate([0,0,r])
    translate([0,-center_dia * conduit_center]) square(size=[20,41],center=true);
    // TODO bolt holes
}

// ---------- Stands:

module stands() {
    translate([head_dia,0]) {
        translate([0,-stand_length/2-separation/2]) stand(true);
        translate([0,stand_length/2+separation/2]) stand(false);

        offset=stand_height+slot_thickness+separation;
        translate([offset,-stand_length/2-separation/2]) stand(true);
        translate([offset,stand_length/2+separation/2]) stand(false);
    }
}

module stand(tab) {
    if(tab) {
        translate([-stand_height/2,0])
        square(size=[slot_thickness,slot_length],center=true);
    }
    difference()
    {
        square(size=[stand_height,stand_length],center=true);
        
        translate([stand_height/4,0])
        square(size=[stand_height/2,slot_thickness],center=true);
    }
    
}
