// bracket.scad - mounting bracket for string lights on concrete wall
// Andrew Ho <andrew@zeuscat.com>

wall_thickness = 200;    // Thickness of concrete wall bracket hangs on
bracket_thickness = 15;  // Thickness of bracket off top/front/back of wall
bracket_width = 20;      // Horizontal width of bracket when hung
bracket_height = 50;     // Vertical height of bracket overhang
corner_radius = 6;       // Round the top of the bracket
wire_diameter = 3;       // Thickness to reserve for the hanging wire

// Rendering parameters
e = 0.1;
e2 = e * 2;
$fn = 60;

// Basic strut shape, for manual dimensional comparison
module bracket_guide() {
  total_length = (bracket_thickness * 2) + wall_thickness;
  cube([total_length, bracket_thickness, bracket_width]);
  cube([bracket_thickness, bracket_height, bracket_width]);
  translate([bracket_thickness + wall_thickness, 0, 0]) {
    cube([bracket_thickness, bracket_height, bracket_width]);
  }
}

// Prusa MINI build plate size, for manual dimensional comparison
module build_plate_guide() {
  cube([180, 180, e]);
}

module bracket() {
  // The main bracket frame, without the wire cutout
  module bracket_frame() {
    total_length = (bracket_thickness * 2) + wall_thickness;

    module corner() {
      cylinder(r = corner_radius, h = bracket_width);
    }

    module top_strut() {
      hull() {
        translate([corner_radius, corner_radius, 0]) corner();
        translate([bracket_thickness, 0, 0]) {
          cube([wall_thickness, bracket_thickness, bracket_width]);
        }
        translate([total_length - corner_radius, corner_radius, 0]) corner();
      }
    }

    module front_strut() {
      hull() {
        translate([corner_radius, corner_radius, 0]) corner();
        translate([0, bracket_thickness, 0]) {
          cube([bracket_thickness, bracket_height - (2 * bracket_thickness),
                bracket_width]);
        }
        translate([corner_radius, bracket_height - corner_radius, 0]) corner();
        translate([bracket_thickness - e, bracket_height - e, 0]) {
          cube([e, e, bracket_width]);
        }
      }
    }

    module back_strut() {
      translate([total_length, 0, 0]) {
        mirror([1, 0, 0]) front_strut();
      }
    }

    top_strut();
    front_strut();
    back_strut();
  }

  // Cutout where the string light wire slots in
  module wire_cutout() {
    height = bracket_width + e2;
    hull() {
      translate([bracket_thickness * (2 / 5), bracket_thickness, -e]) {
        cylinder(d = wire_diameter, h = height);
      }
      translate([-wire_diameter / 2, bracket_thickness * (3 / 5), -e]) {
        cylinder(d = wire_diameter, h = height);
      }
    }
  }

  difference() {
    bracket_frame();
    wire_cutout();
  }
}

module build_plate_view() {
  #translate([0, 0, -e2]) {
    rotate(a = 45, v = [0, 0, 1]) build_plate_guide();
  }
  translate([-((wall_thickness / 2) + bracket_thickness), 100, 0]) {
    bracket();
  }
}

module bracket_comparison_view() {
  #translate([0, 0, -(bracket_width + 1)]) bracket_guide();
  bracket();
}

bracket();
