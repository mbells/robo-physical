/*
 * "Vertebrae" for a tentacle
 * Lays out disks in 2 rows for efficient cutting.
 *
 * Copyright 2016 Matthew Bells
 * BSD3 license, see LICENSE.txt for details.
 */

/*
// Far arm
disk_dia=50; // initial disk size
delta=1;      // difference between disks

cable_dia=1.7;
conduit_dia=6;
*/

// Near arm
disk_dia=52+.5*12; // initial disk size
delta=0.5;      // difference between disks

cable_dia=2.0;
conduit_dia=8;



row=6;       // number of disks in each row

// diameter of center hole
center_dia=3.2;

$fn=100;

/*
translate([-disk_dia-2,-disk_dia/2-2])
difference() {
    square([disk_dia*row+disk_dia/2+1, disk_dia*2-delta*row+1]);
    translate([0.5,0.5])
    square([disk_dia*row+disk_dia/2, disk_dia*2-delta*row]);
}
*/

for (i =[0:row-1])
{
  outer_dia = disk_dia - i*delta;
  dx = i*disk_dia - i*(i+1)/2*delta + i;
  dy = -i*delta;
  disk(dx,dy,outer_dia);
}

yo2=(disk_dia*sin(60)-(row-1)*delta*2)+2;
for (i =[0:row-1])
{
  outer_dia = disk_dia - row*delta - i*delta;
  ir = row-1-i;
  dx = (ir*disk_dia - ir*(ir+1)/2*delta + ir) - (disk_dia - ir*delta)/2;
  dy = yo2 + i*delta;
  disk(dx,dy,outer_dia);
}


module disk(x, y, outer_dia) {
  translate([x,y])
  difference() {
    circle(d=outer_dia);

    // center
    translate([0,0]) circle(d=center_dia);

    hole_center=0.8;
    // operating cords
    translate([outer_dia/2 * hole_center,0]) circle(d=cable_dia);
    translate([-outer_dia/2 * hole_center,0]) circle(d=cable_dia);
    translate([0,outer_dia/2 * hole_center]) circle(d=cable_dia);
    translate([0,-outer_dia/2 * hole_center]) circle(d=cable_dia);

    conduit_center=10/4 + conduit_dia / 10;
    // conduit holes
    translate([conduit_dia/2,center_dia * conduit_center]) circle(d=conduit_dia);
    translate([-conduit_dia/2,center_dia * conduit_center]) circle(d=conduit_dia);
    translate([0,center_dia * conduit_center]) square(size=conduit_dia,center=true);

    translate([conduit_dia/2,-center_dia * conduit_center]) circle(d=conduit_dia);
    translate([-conduit_dia/2,-center_dia * conduit_center]) circle(d=conduit_dia);
    translate([0,-center_dia * conduit_center]) square(size=conduit_dia,center=true);
  }
}
