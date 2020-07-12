# Plot pressurization rate
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import pandas as pd

# Read p_average file produced by OpenFOAM functionObject
# into a pandas dataframe
p_df = pd.read_csv('closedTank_coarse/postProcessing/p_average/0/volFieldValue.dat', skiprows=3, delimiter='\t' )
p_df.columns = ['t','p']
p_ant = pd.read_csv('closedTank_Antoine/postProcessing/p_average/0/volFieldValue.dat', skiprows=3, delimiter='\t' )
p_ant.columns = ['t','p']

# Plotting routines
ax = p_df.plot(x='t', y='p', label='q = 42.2 W/m$^2$, constant $T_{sat}$', figsize=[6,5], color='red')
plt.plot(p_ant['t'], p_ant['p'], label='q = 42.2 W/m$^2$, Antoine', color='blue')
# ax = p_ant.plot(x='t', y='p', label='q = 42.2 W/$m^2$m, Antoine$')
ax.ticklabel_format(useOffset=False)
plt.xlabel('Time / s')
plt.xlim(p_df['t'].iloc[0],p_df['t'].iloc[-1] )
plt.ylabel('Pressure / Pa')
plt.title('Self-pressurization of stored LN$_2$ driven by heat ingress')
plt.legend()
plt.savefig('dpdt.png', bbox_inches='tight')

# Tempeature plot

# Read Tv_average file produced by OpenFOAM functionObject
# into a pandas dataframe
Tv_df = pd.read_csv('closedTank_coarse/postProcessing/Tv_average/0/volFieldValue.dat', skiprows=3, delimiter='\t' )
Tv_df.columns = ['t','Tv']
Tv_ant = pd.read_csv('closedTank_Antoine/postProcessing/Tv_average/0/volFieldValue.dat', skiprows=3, delimiter='\t' )
Tv_ant.columns = ['t','Tv']
# Plotting routines
ax = Tv_df.plot(x='t', y='Tv', label='q = 42.2 W/m$^2$, constant $T_{sat}$', color='red')
plt.plot(Tv_ant['t'], Tv_ant['Tv'], label='q = 42.2 W/m$^2$, Antoine', color='blue')
ax.ticklabel_format(useOffset=False)
plt.xlabel('Time / s')
plt.xlim(Tv_df['t'].iloc[0],Tv_df['t'].iloc[-1] )
plt.ylabel('Vapour temperature / K')
plt.title('Vapour temperature build-up during the evaporation of LN$_2$')
plt.legend()
plt.savefig('Tv.png', bbox_inches='tight')