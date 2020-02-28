/**
A carriage, designed for running on angle aluminum.
Currently set up for 8x 686 bearings.
Could probably move opposing bearing to middle and use 6x instead.
Printed at -0.08mm horizontal extrusion (Cura).
*/

use <deps.link/BOSL/joiners.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/scadFluidics/common.scad>

$fn=60;

B_WIDTH = 5;
B_BORE = 6;
B_DIAM = 13;

ANGLE_SIZE = 27;
ANGLE_THICK = 1.5;

WALL_THICK = ANGLE_THICK * 15;
LIP = B_WIDTH*2;
WALL_HEIGHT = WALL_THICK*3;

//TODO Or should it envelop the angle-metal entirely?

/**
`size` is an array[3].
`nub_diam` is the diameter of the nub where it contacts the rest of the piece.
`nub_
The nub is on the face perpendicular to the first dimension of `size`.
*/
module bearingSlot(size, nub_diam, nub_scale=0.1, nub_stem=undef) {
  if (nub_stem == undef) {
    bearingSlot(size=size, nub_diam=nub_diam, nub_scale=nub_scale, nub_stem=0.0);
  } else {
    for (i = [0,1]) mirror([0,0,i])
      translate([0,0,size[2]/2]) rotate([0,45,0]) cube([sqrt(1/2)*size[0],size[1],sqrt(1/2)*size[0]],center=true);
    difference() {
      cube(size, center=true);
      for (i = [0,1]) mirror([i,0,0]) translate([nub_stem-size[0]/2,0,0]) {
        scale([nub_scale,1,1]) sphere(d=nub_diam);
        rotate([0,-90,0]) cylinder(d=nub_diam, h=nub_stem); //TODO Should there be a ledge to rest on, rather than a shaft?      
      }
      //OYp();
    }
  }
}

difference() {
  linear_extrude(height=WALL_HEIGHT)
    difference() {
      union() {
        channel([0,0],[0,ANGLE_SIZE],d=WALL_THICK, cap="square");
        channel([0,0],[WALL_THICK/2+LIP,0],d=WALL_THICK, cap="none");
      }
      channel([0,0],[0,ANGLE_SIZE],d=ANGLE_THICK*2, cap="square");
      channel([0,0],[WALL_THICK/2+LIP,0],d=ANGLE_THICK*2, cap="square");
    }
  SLOT_WIDTH = B_WIDTH+0.2;
  for (j=[0.25,0.75]) translate([0,ANGLE_SIZE*0.8,WALL_HEIGHT*j])
  for (i=[0,1]) mirror([i,0,0])
    translate([-B_DIAM/2-ANGLE_THICK/2,0,0]) rotate([0,0,90]) bearingSlot([SLOT_WIDTH,B_DIAM*1.1,B_DIAM*1.5], nub_diam=B_BORE*1.1, nub_stem=0.1);
  for (j=[0.25,0.75]) translate([WALL_THICK/2+SLOT_WIDTH/2,0,WALL_HEIGHT*j])
  for (i=[0,1]) mirror([0,i,0])
    translate([0,-B_DIAM/2-ANGLE_THICK/2,0]) bearingSlot([SLOT_WIDTH,B_DIAM*1.1,B_DIAM*1.5], nub_diam=B_BORE*1.1, nub_stem=0.1);
}

* difference() {
  cube([B_WIDTH*3,B_BORE*1.1,B_DIAM*3],center=true);
  bearingSlot([B_WIDTH+0.2,B_DIAM*1.1,B_DIAM*1.5], nub_diam=B_BORE*1.1, nub_stem=0.1);
}