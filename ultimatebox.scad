storage_organizer();
 //bavel_label();
 //bavel_round_label();
 //round_label();
$fn=15;

module cube_rounded(v, radius, center=false)
{
    translate(v=[radius, radius, radius]) {
        minkowski() {
            cube([v[0] - 2*radius, v[1] - 2*radius, v[2] - 2*radius], center=center);
            sphere(radius);
        }
    }
}

module label(
    label_length = 50,
    label_width  = 10,
    label_height = 10,
){
    polyhedron(
        points = [
            [0, 0, label_height],
            [label_length, 0, label_height], 
            [label_length, 0, 0],
            [0, 0, 0],
            [0, label_width, label_height],
            [label_length, label_width, label_height],
        ], 
        faces = [[0,3,2], [0,2,1], [3,0,4], [1,2,5], [0,5,4], [0,1,5],  [5,2,4], [4,2,3]]
    );
}

module round_label(
    label_length = 50,
    label_width  = 10,
    label_height = 10,
    radius = 1,
){
    intersection() {
        label(label_length, label_width, label_height);
        minkowski() {
            translate([radius, 0, 0])
            label(label_length - 2*radius, label_width-radius, label_height);
            if (radius > 0)
                cylinder(h=1, r=radius, $fn=16);
        }
    }
}

module bavel_round_label(
    label_length = 50,
    label_width  = 10,
    label_height = 10,
    bavel = 5,
    radius = 0,
) {
    difference() {        
        translate([-bavel, 0, -bavel])
            cube([label_length + bavel * 2, label_width + bavel * 2, label_height + bavel]);
        minkowski() {
            difference() {
                translate(v=[-2*bavel, bavel, -bavel])
                    cube([label_length + bavel * 4, label_width + bavel * 4, label_height + bavel * 4]);
                minkowski() {
                    round_label(label_length, label_width, label_height, radius);
                    sphere(bavel);
                }
            }
            sphere(bavel);
        }
    }
}
 
module storage_organizer(
    length=200,
    width=200,
    height=50,
    radius=3,
    thickness_outer=2.4,
    thickness_inner=4.8,
    num_x=2,
    num_y=2,
    label_length = 50,
    label_width  = 15,
    label_height = 10,
    label_bavel = 3,
    label_radius = 0,
)
{
    unit_x = (length - thickness_outer * 2 - (num_x-1) * thickness_inner) / num_x;
    unit_y = (length - thickness_outer * 2 - (num_y-1) * thickness_inner) / num_y;        
    difference() {
        // mother cube
        cube_rounded([length, width, height + radius], radius);
        // trim top
        translate(v=[-1000, -1000, height])
            cube([2000, 2000, radius]);        
        // trim boxes
        for (i = [1:num_x]) for (j = [1:num_y])
            translate(v=[(unit_x + thickness_inner) * (i-1) + thickness_outer,
                         (unit_y + thickness_inner) * (j-1) + thickness_outer, thickness_outer])
            difference() {
                // storage
                cube_rounded([unit_x, unit_y, height*2], radius);
                // label holder
                translate([(unit_x - label_length) / 2, 0, height-label_height])
                    bavel_round_label(label_length, label_width, label_height, label_bavel, label_radius);
            }
    }
}
