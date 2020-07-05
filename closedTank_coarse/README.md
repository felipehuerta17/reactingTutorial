## LES_conduction_WHF
# Liquid BC: Multiphase fixed heat flux
# Vapour BC: Convection-conduction boundary condition

### Hypothesis:

At larger liquid lengths, a higher volume of bubbles is present near the wall and it increases
with height. The implementation of our boundary condition may be not appropriate, as it is not
considering the phase fractions (we assume that the fraction of bubbles near the wall is negligible).

fixedMultiphaseHeatFlux BC considers the phase fractions of each phase
