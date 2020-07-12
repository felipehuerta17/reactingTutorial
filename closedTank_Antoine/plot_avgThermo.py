# Plot pressurization rate
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import pandas as pd

# Read p_average file produced by OpenFOAM functionObject
# into a pandas dataframe
p_df = pd.read_csv('postProcessing/p_average/0/volFieldValue.dat', skiprows=3, delimiter='\t' )
p_df.columns = ['t','p']
# Plotting routines
ax = p_df.plot(x='t', y='p', label='q = 42.2 W/$m^2$')
ax.ticklabel_format(useOffset=False)
plt.xlabel('Time / s')
plt.ylabel('Pressure / Pa')
plt.title('Self-pressurization of stored LN$_2$ driven by heat ingress')
plt.savefig('dpdt.png', bbox_inches='tight')

# Tempeature plot

# Read Tv_average file produced by OpenFOAM functionObject
# into a pandas dataframe
Tv_df = pd.read_csv('postProcessing/Tv_average/0/volFieldValue.dat', skiprows=3, delimiter='\t' )
Tv_df.columns = ['t','Tv']
# Plotting routines
ax = Tv_df.plot(x='t', y='Tv', label='q = 42.2 W/$m^2$')
ax.ticklabel_format(useOffset=False)
plt.xlabel('Time / s')
plt.ylabel('Vapour temperature / K')
plt.title('Vapour temperature build-up during the evaporation of LN$_2$')
plt.savefig('Tv.png', bbox_inches='tight')
