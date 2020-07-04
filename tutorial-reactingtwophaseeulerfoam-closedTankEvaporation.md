tutorial-reactingTwoPhaseEulerFoam

# Non-isobaric evaporation of liquid nitrogen in a closed vessel

In this tutorial, we examine the evaporation of liquid nitrogen during it's storage in a closed vessel. Liquid nitrogen is a cryogenic liquid which saturation temperature is 77.1K at 1 atm of pressure. Cryogenic liquids are normally stored in multi-layered insulated storage tanks, to minimize the heat ingress from the surroundings driven by the large temperature difference between the environment and the cryogenic liquid.

The heat ingress from the surroundings will heat and evaporate the liquid nitrogen. The liquid phase is heated through the walls, and the bottom, governed by an overall heat transfer coefficient, with a heat flux governed by an overall heat transfer coefficient.

`q_L = U_L (T_air- T_L)`

The vapour phase will be superheated with respect to the liquid and will act as an additional heat source. Additionally, as the liquid temperature increases it's density will decrease, producing a thermal expansion that will further increase the pressure of the tank decreasing the volume of the vapour.

The vapour phase is heated through the tank roof and walls by the same mechanism of the liquid, `q_V = U_L (T_air- T_V)`. The heat ingress will increase the pressure of the vapour. If the increase in saturation temperature of the system is quicker than the heating of the vapour close to the interface, some vapour will condense despite the fact that the whole system is being heated.

## Overview {closedTankEvaporation}

- Solver: reactingTwoPhaseEulerFoam
- Goals: 
  - Learn how to set up a multiphase simulation with thermally driven phase change under non-isobaric conditions
  - Understand the relevant submodels of drag, lift, heat and mass transfer on the constant/phaseProperties dictionary
  - 
  
- [Simulation](closedTankEvaporation)
  - example: pressure build-up during the evaporation of liquid nitrogen in a storage tank

## Workflow

1. Create the geometry
2. 
3.
4.

## Geometry

The geometry for this tutorial consists of a 2D cylinder. In OpenFOAM, 2D axisymmetrical cylinders are modelled as wedges. The mesh was created with gmsh.
