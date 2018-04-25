// https://www.thingiverse.com/thing:1645390/#files
use <Rack_and_pinion_v1.1_-with_backboard_endstops_flanges.scad>;

// fs: minimum size of a side, mm
$fs = 0.5;
// maximum number of sides per circle = 360/$fa
// 20 = 360/fa
// 20 * fa = 360
// fa = 360/20
$fa = 360/20;

magnet_xy = 10;
magnet_z = 3;

material_height = 3;

// FIXME: Only some values of mm_per_tooth line up correctly.  Why?  
// Do I want the two layers to line up, or be 180 degrees out of phase?
mm_per_tooth = 3;
pressure_angle = 15;

// The minimum distances between a bolt hole and the nearest edge.
bolt_hole_margin = 2;

rack_section_bolt_d = 4;
bolt_hole_with_margins = rack_section_bolt_d + 2 * bolt_hole_margin;

// This is a guess, plus an experimentally determined fudge factor ... an actual formula
// would probably be handy.
rack_tooth_height = mm_per_tooth - 0.6;

rack_thickness = rack_tooth_height + bolt_hole_with_margins;

gear_teeth = 20;

if (demo_mode) {
 plastic_parts();
 
 translate([mm_per_tooth/2, rack_thickness + pitch_radius(mm_per_tooth, gear_teeth), 0]) 
     color([0.5, 0.5, 0.5])
        magnet_and_pin();

 rack_section();
 translate([rack_width/2, 0, material_height])
    rack_section();

} else {
 projection(cut=true) {
  for (i = [0:5]) {
   translate([20, (rack_thickness + 1) * i, 0])
    rack_section();
  }
 
  translate([0, 0, -0.1])
   plastic_parts();

  translate([0, 25, -(material_height + 0.1)])
   plastic_parts();
 }
}

module magnet_and_pin() {
    magnet();
    cylinder(d=3, h=3*material_height);
}

module plastic_parts() {
    translate([mm_per_tooth/2, rack_thickness + pitch_radius(mm_per_tooth, gear_teeth), 0]) {
        difference() {
            translate([0, 0, material_height+0.001])
                gear(mm_per_tooth = mm_per_tooth, thickness = material_height*2, hole_diameter=0, pressure_angle = pressure_angle, number_of_teeth = gear_teeth);
            magnet_and_pin();
        }
    }
}


// To fit onto an A4 sheet, longwise, with healthy margin for misalignment.
//rack_width_appx = 295;
// For easy visualization / demo.
rack_width_appx=50;
rack_num_teeth = floor(rack_width_appx / mm_per_tooth);
rack_width = mm_per_tooth * rack_num_teeth;

module magnet() {
    x=magnet_xy;
    y=magnet_xy;
    z=3;
    translate([-x/2, -y/2, 0])
  color([0.5, 0.5, 0.5])
   cube([x, y, z]);
}

module rack_section() {
    rack_tooth_height = mm_per_tooth;
    
    rack_thickness = rack_tooth_height + bolt_hole_with_margins;
    
    difference() {
        // Just because I prefer to have my object mostly in +z
        translate([0, 0, material_height/2])
            InvoluteGear_rack(thickness = material_height, height = rack_thickness, mm_per_tooth = mm_per_tooth, number_of_teeth=rack_num_teeth, backboard_thickness = 0, left_stop_enable=0, right_stop_enable=0);

	// One just in from the left.
	translate([bolt_hole_with_margins/2, bolt_hole_with_margins/2, -1])
            cylinder(d=rack_section_bolt_d, h = material_height+2);
 
	// One to mate with the one just in from the left on the next one.
	translate([bolt_hole_with_margins/2 + rack_width/2, bolt_hole_with_margins/2, -1])
            cylinder(d=rack_section_bolt_d, h = material_height+2);

	// One just in from the right.
	translate([rack_width - (bolt_hole_with_margins/2), bolt_hole_with_margins/2, -1])
            cylinder(d=rack_section_bolt_d, h = material_height+2);
 
	// One to mate with the one just in from the right on the previous one.
	translate([rack_width - (bolt_hole_with_margins/2 + rack_width/2), bolt_hole_with_margins/2, -1])
            cylinder(d=rack_section_bolt_d, h = material_height+2);

    }
}

