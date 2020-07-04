// Generates a 2D wedge mesh of a cylindrical tank
// of radius R, height h, appropriate for studying
// Cryogenic storage applications

// Multiphase model, non-uniform mesh
// reactingTwoPhaseEulerfoam

// Felipe Huerta (2019)
// 24th of September
// Imperial College London

// Model parameters
LF = 0;

// Tank properties
radius = 0.802/40;
height = 3.9591/40;
valve_r = radius*0.1;
// Mesh creation parameters
dr = 1e-3;
dz = 1e-3;
r = 1; //valve_refinement
vr = 1; //valve_refinement
r_bump = 0.1;
z_bump = 1;


// Calculation of the number of nodes
n_r = Round( (radius-valve_r)/dr );
n_r_valve = vr*Round(valve_r/(2*dr*r_bump));
n_z = Round(height*(1-LF)/dz);

Point(1) = {0, height*(1-LF)/2,0};
Point(2) = {0, -height*(1-LF)/2,0};
Point(3) = {valve_r, -height*(1-LF)/2,0};
Point(4) = {radius, -height*(1-LF)/2,0};
Point(5) = {radius, height*(1-LF)/2,0};
Point(6) = {valve_r, height*(1-LF)/2, 0};

Line(7) = {1,2}; // cylinder axis
Line(8) = {2,3}; // bottom 1
Line(9) = {3,6}; // Internal division
Line(10) = {6,1}; // Outlet

Line(11) = {6,3}; // Internal division
Line(12) = {3,4}; // bottom 2
Line(13) = {4,5}; // wall
Line(14) = {5,6}; // top (roof/interphase)


// Vertical meshing
Transfinite Line{7} = r * n_z Using Bump z_bump;
Transfinite Line{9} = r * n_z Using Bump z_bump;
Transfinite Line{11} = r * n_z Using Bump z_bump;
Transfinite Line{13} = r * n_z Using Bump z_bump;

// Radial meshing
Transfinite Line{8} = r * n_r_valve;
Transfinite Line{12} = r * n_r Using Bump r_bump;
Transfinite Line{10} = r * n_r_valve;
Transfinite Line{14} = r * n_r Using Bump r_bump;

//Line Loop(12) = {6,7,8,9,10,11};
Line Loop(14) = {7,8,9,10};
Line Loop(15) = {11,12,13,14};

Plane Surface(16) = {14}; // inlet domain
Plane Surface(17) = {15}; // outlet domain
Transfinite Surface{16} = {1,2,3,6};
Transfinite Surface{17} = {6,3,4,5};

Rotate {{0,1,0},{0,0,0},-1.25*Pi/180.0}
{
	Surface{16};
	Surface{17};
}

Recombine Surface{16,17};

new_entities[] = Extrude {{0,1,0},{0,0,0}, 2.5*Pi/180.0}
{
	Surface{16,17};
	Layers{1};
	Recombine;
};
Coherence;

Physical Surface("wedge_0") = {16};
Physical Surface("wedge_1") = {17};
Physical Surface("wedge_2") = {34};
Physical Surface("wedge_3") = {56};

Physical Surface("outlet") = {33};
Physical Surface("roof") = {55};

Physical Surface("tank_wall") = {51};

Physical Surface("bottom_1") = {26};
Physical Surface("bottom_2") = {47};

// Physical Surface("internalFace") = {30};

Physical Volume("volume") = {2,1,3};
