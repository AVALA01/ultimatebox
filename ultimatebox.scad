 storage_organizer();
 
$fn=24;
module storage_organizer(
    length=200,
    width=200,
    height=50,
    radius=3,
    thickness=2.4,
    num_divider_x=2,
    num_divider_y=2,
)
{
    label_length = 50;
    label_width  = 20;
    label_height = 20;
    
    minkowski() {
        translate(v=[(length-label_length)/2, thickness, height-label_height])
            polyhedron(
                points = [
                    [0, 0, label_height],
                    [label_length, 0, label_height], 
                    [label_length, 0, 0],
                    [0, 0, 0],
                    [0, label_width, label_height],
                    [label_length, label_width, label_height],
                ], 
                faces = [[0,3,2], [0,2,1], [3,0,4], [1,2,5], [0,5,4], [0,1,5],  [5,2,4], [4,2,3], ]);
    }
    
    difference() {
        cube_rounded([length, width, height + radius], radius);
        translate(v=[thickness, thickness, thickness])
            cube_rounded([length - thickness*2, width - thickness*2, height + radius], radius);
        translate(v=[-1000, -1000, height])
            cube([2000, 2000, radius]);
    }

    intersection() {
        union() {
            gap_x = length / (1 + num_divider_x);
            gap_y = width / (1 + num_divider_y);
            for (i = [1:num_divider_x]) {
                translate(v=[gap_x*i, 0, 0]) cube([thickness, width, height]);
            }
            for (i = [1:num_divider_y]) {
                translate(v=[0, gap_y*i, 0]) cube([length, thickness, height]);
            }
        }
        cube_rounded([length, width, height + radius], radius);
    }
}

module cube_rounded(v, radius, center=false)
{
    translate(v=[radius, radius, radius]) {
        minkowski() {
            cube([v[0] - 2*radius, v[1] - 2*radius, v[2] - 2*radius], center=center);
            sphere(radius);
        }
    }
}
