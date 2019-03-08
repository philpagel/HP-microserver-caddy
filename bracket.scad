/* 
 SSD bracket 
 for mounting an SSD drive in the optical drive bay 
 of an HP ProLiant Microserver Gen8
*/


// size of baseplate/tray
tray_width = 128;
tray_length = 128;
tray_height = 9.5;
baseplate_height = 2.3;

// notch for positioning
notch_depth = 3;
notch_width = 14;
notch_xpos = 42;

// slot cover size 
slot_width = 98;
slot_recess = 60;

wall_diam = 1.5; // wall diameter
rail_diam = 4;	// rail diameter

// ssd size
ssd_width = 70;
ssd_length = 101.5;
ssd_xoffset = 40;
ssd_yoffset = tray_length - notch_depth - ssd_length - rail_diam;
connector_xpos = 17;
connector_width = 44;
// ssd screws
screwpos1 = 10.2;
screwpos2 = screwpos1 + 76.6;
screw_height = 3.2;
screw_diam = 3;

// front clip to snap in place
clip_xpos = 61;
clip_width = 32; 
clip_length = 10;
clip_hole_width = 12;
clip_hole_length = 6.5;

// notch for cable retainer
cable_slot_width = 13;
cable_slot_length = 40;

union() {
	// base plate
	difference(){
		union(){
			// base plate 
			cube([	tray_width, tray_length, baseplate_height]);

			// side rails
			cube([rail_diam, tray_length, tray_height]); 
			translate([tray_width-rail_diam, 0, 0]){
				cube([rail_diam, tray_length, tray_height]);
			}
		}

		// notch for positioning	
		translate([notch_xpos, tray_length-notch_depth, 0]) {
			cube([notch_width, notch_depth, tray_height]);
		}

		// front needs to be narrower to fit clip (110 max width)
		cube([(tray_width-slot_width)/2, slot_recess, tray_height]);
		translate([slot_width+(tray_width-slot_width)/2, 0, 0]) {
			cube([(tray_width-slot_width)/2, slot_recess, tray_height]);
		}

		// notch for cable retainer on the right
		translate([tray_width-cable_slot_width, tray_length-cable_slot_length, 0]) {
			cube([cable_slot_width, cable_slot_length, tray_height]);
		}


		// punch some holes in the baseplate order to save material
		for (y_off = [70:15:115]) {
			translate([12, y_off, 0]){
				cylinder(h=baseplate_height, r=5, center=false, $fn=45);
			}
		}
		for (y_off = [10:15:115]) {
			translate([26, y_off, 0]){
				cylinder(h=baseplate_height, r=5, center=false, $fn=45);
			}
		}
		for (x_off = [41:15:115]) {
			translate([x_off, 10, 0]){
				cylinder(h=baseplate_height, r=5, center=false, $fn=45);
			}
		}
		
		// more holes in the ssd cavity
		// a bit wider so you can easily push the ssd out
		assign(
			r = 8, 
			n_x = 3, 
			n_y = 5
		)
		assign(
			d_x = (ssd_width - 2*r*n_x)/(n_x+1),
			d_y = (ssd_length - 2*r*n_y)/(n_y+1)
		)
		translate([ssd_xoffset, ssd_yoffset, 0]){	
			for(i=[1:n_x]) {
				for(j=[1:n_y]){
					translate([
						i*(d_x+2*r)-r, 
						j*(d_y+2*r)-r, 
						0
					]){
						cylinder(h=baseplate_height, r=r, center=false, $fn=45);
					}
				}
			}
		}	
	}

	// front clip
	translate([clip_xpos, tray_length, 0]){
		difference(){
			cube([clip_width, clip_length, baseplate_height]);
			translate([(clip_width-clip_hole_width)/2, 0, 0]){
				cube([clip_hole_width, clip_hole_length, baseplate_height]);
			}
		}
	}


	// ssd
	translate([ssd_xoffset-wall_diam, ssd_yoffset-wall_diam, baseplate_height]){
		difference() {
			// wall
			cube([
				ssd_width + 2*wall_diam, 
				ssd_length + wall_diam + rail_diam, 
				tray_height-baseplate_height
			]);
			// holes for ssd mounting screws
			translate([0, screwpos1+wall_diam, screw_height]){
				rotate([0,90,0]){
					cylinder(h=ssd_width+2*wall_diam, d=screw_diam, center=false, $fn=90);
				}
			}
			translate([0, screwpos2+wall_diam, screw_height]){
				rotate([0,90,0]){
					cylinder(h=ssd_width+2*wall_diam, d=screw_diam, center=false, $fn=90);
				}
			}

			// cavity for ssd and cable
			translate([wall_diam, wall_diam, 0]){
				// ssd
				cube([ssd_width, ssd_length, tray_height-baseplate_height]);
				// space for connector
				translate([connector_xpos, ssd_length, 0]) {
					cube([connector_width, rail_diam, tray_height-baseplate_height]);
				}

			}
		}
	}

}
