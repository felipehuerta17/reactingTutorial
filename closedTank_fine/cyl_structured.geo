//Inputs by Felipe Huerta (2018)
// Imperial College London
radius = 0.105;
height = 0.213;
gridsize = 0.01*radius;

Point(1) = {0,height/2,0,gridsize};
Point(2) = {0,-height/2,0,gridsize};
Point(3) = {radius,-height/2,0,gridsize};
Point(4) = {radius,height/2,0,gridsize};

Line(5) = {1,2};
Line(6) = {2,3};
Line(7) = {3,4};
Line(8) = {4,1};

// Make non-uniform mesh in R
Transfinite Line{6} = 100 Using Bump 0.05;
Transfinite Line{8} = 100 Using Bump 0.05;

Transfinite Line{7} = 200 Using Bump 0.025;
Transfinite Line{5} = 200 Using Bump 0.025;

Line Loop(9) = {5:8};
Plane Surface(10) = {9};
Transfinite Surface{10} = {1,2,3,4};

Rotate {{0,1,0},{0,0,0},2.5*Pi/180.0}
{
	Surface{10};
}

Recombine Surface{10};

new_entities[] = Extrude {{0,1,0},{0,0,0},-5*Pi/180.0}
{
	Surface{10};
	Layers{1};
	Recombine;
};

Physical Surface("wedge0") = {10};
Physical Surface("wedge1") = {new_entities[0]};
Physical Surface("bottom") = {new_entities[2]};
Physical Surface("tank_wall") = {new_entities[3]};
Physical Surface("interphase") = {new_entities[4]};

Physical Volume(1000) = {new_entities[1]};
