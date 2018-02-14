// https://www.thingiverse.com/thing:1645390/#files
use <Rack_and_pinion_v1.1_-with_backboard_endstops_flanges.scad>;

// fs: minimum size of a side, mm
$fs = 0.5;
// maximum number of sides per circle = 360/$fa
// 20 = 360/fa
// 20 * fa = 360
// fa = 360/20
$fa = 360/20;

material_height = 3;

mm_per_tooth = 3;
pressure_angle = 15;

// The minimum distances between a bolt hole and the nearest edge.
bolt_hole_margin = 2;

rack_section_bolt_d = 4;
bolt_hole_with_margins = rack_section_bolt_d + 2 * bolt_hole_margin;

// This is completely just a guess!  (And it's just a hair too high from a quick experiment, which is good enough.)
rack_tooth_height = mm_per_tooth;

rack_thickness = rack_tooth_height + bolt_hole_with_margins;

translate([mm_per_tooth/2, rack_thickness, material_height/2])
    gear(mm_per_tooth = mm_per_tooth, thickness = material_height, hole_diameter=0, pressure_angle = pressure_angle);


// To fit onto an A4 sheet, longwise, with healthy margin for misalignment.
//rack_width_appx = 295;
rack_width_appx=50;
rack_num_teeth = floor(rack_width_appx / mm_per_tooth);
rack_width = mm_per_tooth * rack_num_teeth;

rack_section();
translate([rack_width/2, 0, material_height])
    rack_section();

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

