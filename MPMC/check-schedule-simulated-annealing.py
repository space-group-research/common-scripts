#Written by Adam Hogan, Sept 28, 2024
#This script simulates whether a simulated annealing job will achieve the target temperature using the specified schedule value and an acceptance ratio of 1/20.
#You will need to adjust this script to your system's acceptance ratio.

import matplotlib.pyplot as plt
import numpy as np

steps = np.arange(0, 1000020, 20)

start_temp = 1000
target = 1
schedule = 0.9998

temps = []

for step in steps:

    if len(temps) == 0:
        temps.append(start_temp)
        continue

    temp = target + (temps[-1] - target) * schedule
    temps.append(temp)

temps = np.array(temps)

plt.plot(steps, temps)
plt.show()
