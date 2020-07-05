// Generates a 2D wedge mesh of a cylindrical tank
// of radius R, height h, appropriate for studying
// Cryogenic storage applications

// Multiphase model, non-uniform mesh
// The valve will be an annulus
// The mesh will be uniform in principle

// Felipe Huerta (2019)
// 14th of November
// Imperial College London

// Model parameters
LF = 0.94;

// Tank properties
// Tank properties
radius = 0.802/10;
height = 3.95919;

// Create an annulus
r_in = radius*0.1;
r_out = radius*0.2;


// Mesh creation parameters
dr = 2e-3;
dz = 2e-3;
r = 1; //mesh refinement
vr = 2; //r_inefinement
r_bump = 0.2;
z_bump = 0.2;

p = 1; // progression coefficient for near wall refinement


// Calculation of the number of nodes
n_r = Round( (radius-r_out)/dr );
n_r_valve = vr* Round((r_out-r_in)/(dr));
n_r_in = vr*Round(r_in/dr);

n_z = Round(height*(1-LF)/dz);

Point(1) = {0, height*(1-LF)/2,0};
Point(2) = {0, -height*(1-LF)/2,0};
Point(3) = {r_in, -height*(1-LF)/2,0};
Point(4) = {r_out, -height*(1-LF)/2,0};
Point(5) = {radius, -height*(1-LF)/2,0};
Point(6) = {radius, height*(1-LF)/2,0};
Point(7) = {r_out, height*(1-LF)/2, 0};
Point(8) = {r_in, height*(1-LF)/2, 0};

// Wedge block 1
Line(7) = {1,2}; // cylinder axis
Line(8) = {2,3}; // axis-r_in
Line(9) = {3,8}; // Internal division 1
Line(10) = {8,1}; // roof_1

// Wedge block 2 valve

Line(11) = {8,3}; // Internal division 1
Line(12) = {3,4}; // bottom 2
Line(13) = {4,7}; // Internal division 2
Line(14) = {7,8}; // Outlet

// Wedge block 3
Line(15) = {7,4}; // Internal division 2
Line(16) = {4,5}; // bottom 3
Line(17) = {5,6}; // Wall
Line(18) = {6,7}; // roof_2

// Vertical meshing
Transfinite Line{7} = r * n_z Using Bump z_bump;
Transfinite Line{9} = r * n_z Using Bump z_bump;
Transfinite Line{11} = r * n_z Using Bump z_bump;
Transfinite Line{13} = r * n_z Using Bump z_bump;
Transfinite Line{15} = r * n_z Using Bump z_bump;
Transfinite Line{17} = r * n_z Using Bump z_bump;

// Radial meshing

// Bottom 1 & Roof 1
Transfinite Line{8} = r * n_r_in;
Transfinite Line{10} = r * n_r_in;

// Valve
Transfinite Line{12} = r * n_r_valve;
Transfinite Line{14} = r * n_r_valve;

// Bottom 2 & Roof 2
Transfinite Line{16} = r * n_r Using Bump r_bump;
Transfinite Line{18} = r * n_r Using Bump r_bump;


//Line Loop(12) = {6,7,8,9,10,11};
Line Loop(14) = {7,8,9,10};
Line Loop(15) = {11,12,13,14};
Line Loop(16) = {15,16,17,18};

Plane Surface(17) = {14}; // inlet domain
Plane Surface(18) = {15}; // outlet domain
Plane Surface(19) = {16}; // outlet domain

Transfinite Surface{17} = {1,2,3,8}; // Counterclockwise vertices defining Loop 14
Transfinite Surface{18} = {8,3,4,7};
Transfinite Surface{19} = {7,4,5,6};


Rotate {{0,1,0},{0,0,0},-1.25*Pi/180.0}
{
	Surface{17};
	Surface{18};
	Surface{19};
}

Recombine Surface{17,18,19};

new_entities[] = Extrude {{0,1,0},{0,0,0}, 2.5*Pi/180.0}
{
	Surface{17,18,19};
	Layers{1};
	Recombine;
};

Coherence;

// Wedge naming
Physical Surface("wedge_0") = {17};
Physical Surface("wedge_1") = {18};
Physical Surface("wedge_2") = {19};

Physical Surface("wedge_3") = {36};
Physical Surface("wedge_4") = {58};
Physical Surface("wedge_5") = {80};

// Outlet naming
Physical Surface("outlet") = {57};

// Roof naming
Physical Surface("roof_1") = {79};
Physical Surface("roof_2") = {35};

// Wall
Physical Surface("tank_wall") = {75};

Physical Surface("bottom_1") = {28};
Physical Surface("bottom_2") = {49};
Physical Surface("bottom_3") = {71};

// Physical Surface("internalFace") = {30};

Physical Volume("volume") = {2,1,3};
