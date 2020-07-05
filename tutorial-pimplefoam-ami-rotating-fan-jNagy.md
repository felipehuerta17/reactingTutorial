# Rotating mesh   {#tutorial-pimplefoam-ami-rotating-fan}

<!-----------------------------------------------------------------------------
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     |
    \\  /    A nd           | Copyright (C) 2019 OpenCFD Ltd.
     \\/     M anipulation  |
-------------------------------------------------------------------------------
                            | Copyright (C) 2019 Jozsef Nagy
-------------------------------------------------------------------------------
Documentation license
    This work is part of OpenFOAM, licensed under a Creative Commons
    Attribution-NonCommercial-NoDerivs 4.0 Unported License.
    See http://creativecommons.org/licenses/by-nc-nd/4.0/

--------------------------------------------------------------------------- -->

\pageGroup{#tutorials}

## Overview {#sec-tutorial-pimplefoam-ami-rotating-fan-overview}

- Solver: [pimpleFoam](\ref guide-applications-solvers-incompressible-pimpleFoam)
- Goals: Learn how to set up
  - [geometry](\ref sec-tutorial-pimplefoam-ami-rotating-fan-geometry)
  - [mesh](\ref sec-tutorial-pimplefoam-ami-rotating-fan-mesh)
  - case
- [Simulation](\ref sec-tutorial-pimplefoam-ami-rotating-fan-simulation) with rotating mesh
  - example: rotating fan in a room

Case files can be found here:
- \OFTUTDEV{incompressible/pimpleFoam/RAS/rotatingFanInRoom}

## Geometry {#sec-tutorial-pimplefoam-ami-rotating-fan-geometry}

The geometry for this tutorial consists of

- room with
  - door
  - window (outlet)
- desk
- rotating fan
- cylinder defining
  - rotating cells
  - the interpolation surfaces between rotating and non-rotating cells

![Geometry](tutorial-pimplefoam-ami-rotating-fan-geometry-600.png)

## Mesh {#sec-tutorial-pimplefoam-ami-rotating-fan-mesh}

The mesh is created with [snappyHexMesh](\ref guide-meshing-snappyhexmesh) using
STL surfaces located in the `constant/triSurface` directory.

    surfaceFeatureExtract

The process begins by extracting features from the STL files (dictionary can
be found in _system/surfaceFeatureExtractDict_).

    blockMesh

This command creates an initial block structured mesh with our starting mesh
resolution (dictionary can be found in _system/blockMeshDict_).

    snappyHexMesh -overwrite

This command refines the initial mesh at the STL surfaces as well as the
extruded features (dictionary can be found in _system/snappyHexMeshDict_).
Layer addition is not utilized in this tutorial for simplicity purposes.
Usual `snappyHexMesh` settings are utilized for a coarse mesh here. One important
entry can be found in the `refinementSurfaces` sub-dictionary:

    AMI
    {
        level     (2 2);
        faceType  boundary;
        cellZone  rotatingZone;
        faceZone  rotatingZone;
        cellZoneInside inside;
    }

This defines a cellZone called _rotatingZone_, which will later define the
rotating cells. Additionally we define a boundary, which will be later used to
define the interpolation faces between rotating and non-rotating regions.

    renumberMesh -overwrite

This commands restructures the mesh for better calculation performance.

    createPatch -overwrite

This command converts the boundary _AMI_ to an arbitrary mesh interface (hence
AMI), where during the simulation the interpolation of fields between rotating
and non-rotating cells will take place (dictionary can be found in
_system/createPatchDict_).

After these steps you can visualize your mesh in ParaView:

![Mesh](tutorial-pimplefoam-ami-rotating-fan-mesh-600.png)

\note
- Use higher refinement on AMI and fan for better mesh resolution.
- Use refinement region defined by AMI for uniform mesh resolution within
  rotating zone.
- This will however increase your calculation time.

Here you can see the rotating and non-rotating regions of the mesh:

![Close-up around moving part](tutorial-pimplefoam-ami-rotating-fan-mesh-close-up-600.png)

## Simulation {#sec-tutorial-pimplefoam-ami-rotating-fan-simulation}

Now we move from the folder _mesh_ to the folder _case_.

### Boundary conditions {#sec-tutorial-pimplefoam-ami-rotating-fan-boundary-conditions}

- Boundaries in the folder _0_ are defined the following way:
  - door: inlet
  - outlet (window): outlet
  - room: wall
  - desk: wall
  - fan: moving wall

- velocity **U**
  - door: \ref guide-bcs-fixed-value with -0.1 m/s
  - outlet (window): \ref guide-bcs-outlet-pressure-inlet-outlet
  - room: \ref guide-bcs-wall-no-slip
  - desk: \ref guide-bcs-wall-no-slip
  - fan: \ref guide-bcs-moving-mesh-moving-wall-velocity

- kinematic pressure **p**
  - door: `fixedFluxPressure`
  - outlet (window): \ref guide-bcs-fixed-value with atmospheric pressure
    at 0 Pa
  - room: `fixedFluxPressure`
  - desk: `fixedFluxPressure`
  - fan: `fixedFluxPressure`

- turbulent kinetic energy **k**
  - door: `turbulentIntensityKineticEnergyInlet` with 5% turbulence intensity
  - outlet (window): \ref guide-bcs-general-zero-gradient
    (alternative: \ref guide-bcs-outlet-inlet-outlet)
  - room: `kqRWallFunction`
  - desk: `kqRWallFunction`
  - fan: `kqRWallFunction`

- turbulent dissipation rate **omega**
  - door: `turbulentMixingLengthFrequencyInlet` with 1.2m mixing length
  - outlet (window): \ref guide-bcs-general-zero-gradient
    (alternative: \ref guide-bcs-outlet-inlet-outlet)
  - room: `omegaWallFunction`
  - desk: `omegaWallFunction`
  - fan: `omegaWallFunction`

- turbulent kinematic viscosity **nut**
  - door: \ref guide-bcs-general-zero-gradient
  - outlet (window): \ref guide-bcs-general-zero-gradient
    (alternative: \ref guide-bcs-outlet-inlet-outlet)
  - room: `nutkWallFunction`
  - desk: `nutkWallFunction`
  - fan: `nutkWallFunction`

### Definition of mesh movement {#sec-tutorial-pimplefoam-ami-rotating-fan-mesh-movement}

- Dictionary **dynamicMeshDict** can be found in constant.
- Important entries:
  - `cellZone    rotatingZone;` - This was defined in _snappyHexMeshDict_ to
    define the rotating cells.
	- `solidBodyMotionFunction rotatingMotion;` - rotating mesh movement
	- `origin      (-3 2 2.6);` - origin of the axis of rotation of cells (can
    be anywhere on the rotation axis of the fan)
	- `axis        (0 0 1);` - direction of the rotation axis (here: z-direction)
	- `omega       10;` - angular velocity of rotation in rad/s=
    (corresponds to ~95.5 rpm)

\note
- For a realistic fan movement use `omega 20;`

### Additional dictionaries in constant {#sec-tutorial-pimplefoam-ami-rotating-fan-constant}

- **g** - gravitational acceleration
- **transportProperties** - definition of kinematic viscosity
- **turbulenceProperties** - definition of turbulence model (here: \ref guide-turbulence-ras-k-omega-sst)

### Simulation settings {#sec-tutorial-pimplefoam-ami-rotating-fan-system}

- **controlDict** - runtime settings
  - endTime: 1 s  (approx. 0.64 s per revolution)
	- writeInterval: 0.1 s
	- maxCo: 1
- **decomposeParDict** - parallel setting
- **fvSchemes** - various discretisation schemes
- **fvSolution** - numeric settings (matrix solvers, tolerances, correctors)

### Running the simulation {#sec-tutorial-pimplefoam-ami-rotating-fan-running-the-simulation}

The simulation employs the _pimpleFoam_ application, in parallel.

    decomposePar

With this command you divide your mesh and your fields onto multiple processors.

    mpirun -np 4 pimpleFoam -parallel > log.pimpleFoam &

With this command you start your simulation on four cores. If you want to
use a different number of cores you have to change the number (here: 4) to
you choice. Also don't forget to change the settings in
_system/decomposeParDict_!

## Results {#sec-tutorial-pimplefoam-ami-rotating-fan-results}

Here you see the flow after _t_ = 0.64 s.

Velocity magnitude and vectors on a y-normal plane:

![Velocity magnitude and vectors](tutorial-pimplefoam-ami-rotating-fan-result4-600.png)

Close-up of velocity magnitude and vectors on a y-normal plane:

![Close-up velocity magnitude and vectors](tutorial-pimplefoam-ami-rotating-fan-result5-600.png)

\note
- For a more developed flow pattern run the simulation until 10-20s.

\contributors{jozsefNagy}
