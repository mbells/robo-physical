/*
 * Large eye for 3D printing
 *
 * Copyright 2016 Matthew Bells
 * BSD3 license, see LICENSE.txt for details.
 */

$fn=50;

ball_dia=50;
cam_dia=7+.5;
cam_inset=10;

//translate([0,0,ball_dia/2-cam_inset]) cylinder(h = ball_dia/4, r1=0, r2=ball_dia/2);

difference() {
  sphere(r = 25);

  translate([0,0,ball_dia/2-cam_inset]) cylinder(h = ball_dia/4, r1=0, r2=ball_dia/2);

  // camera hole
  translate([0,0,-ball_dia]) cylinder(h = 100, r1=cam_dia/2);

  // back
  translate([0,0,-ball_dia*5/4]) cylinder(h = ball_dia, r=ball_dia/2);
}
