#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 24 20:58:00 2021

@author: yingxue
"""

import Geodesics as Geo
import numpy as np
import time

PEN=np.array([[0.1,0.2],[0.10,0.12],[0.15,0.25],[0.42,0.46]])
Q=np.array([[0,0.25,0.25,0.25,0.25],[0.25,0,0.25,0.25,0.25],[0.25,0.25,0,0.25,0.25],[0.25,0.25,0.25,0,0.25],[0.25,0.25,0.25,0.25,0]])
m=1/1000000
mesh=0.005
F=np.power([200,200,200,200,200],[1,1.08,1.1,1.11,1.12])




# check the computing time for OneStepCost function
H=np.array([0.8,0.05,0.05,0.05,0.05])
G=np.array([0.1,0.1,0.2,0.5,0.1])
startTime = time.time()

for i in range(1000):
    Geo.OneStepCost(H,G,F,m,Q)

executionTime = (time.time() - startTime)
print('Execution time in seconds for OneStepCost function 1000 times: ' + str(executionTime))





    
# check the computing time for OneStepGeo function
H=np.array([0.8,0.05,0.05,0.05,0.05])
G=np.array([0.6,0.1,0.1,0.1,0.1])
startTime = time.time()

for i in range(1000):
    Geo.OneStepGeo(H,G,F,m,Q)

executionTime = (time.time() - startTime)
print('Execution time in seconds for OneStepGeo function 1000 times: ' + str(executionTime))








#check the computing time for ReverseGeo function

G=np.array([0.1,0.1,0.2,0.5,0.1])
pen=np.array([0.15,0.15,0.15,0.4,0.15])
startTime = time.time()

for i in range(1000):
    Geo.ReverseGeo(pen,G,F,m,Q,1)

executionTime = (time.time() - startTime)
print('Execution time in seconds for ReverseGeo function 1000 times: ' + str(executionTime))





# check the computing time for mean_traj function
H=np.array([0.8,0.05,0.05,0.05,0.05])

startTime = time.time()

for i in range(1000):
    MT=Geo.mean_traj(H,F,m,Q)

executionTime = (time.time() - startTime)
print('Execution time in seconds for mean_traj function 1000 times: ' + str(executionTime))






# check the computing time for mean_traj function
H=np.array([0.8,0.05,0.05,0.05,0.05])
HH=H
g=len(H)
Mean = np.zeros((15,g))
Mean[0] = H

for i in range(1,15,1):
        # this for loop computes the mean trajectory starting from H
    HH = Geo.mean_traj(HH,F,m,Q)
    Mean[i] = HH

G=np.array([0.1,0.1,0.2,0.5,0.1])
pen=np.array([0.15,0.15,0.15,0.4,0.15])
Tra,cost_store=Geo.ReverseGeo(pen,G,F,m,Q,1)
startTime = time.time()

for i in range(1000):
    Geo.condition(Mean,Tra,F,Q,m,0.01)

executionTime = (time.time() - startTime)
print('Execution time in seconds for the condition function 1000 times: ' + str(executionTime))





# check the computing time for PENset function
startTime = time.time()

for i in range(10):
    Geo.PENset(PEN,mesh,H)

executionTime = (time.time() - startTime)
print('Execution time in seconds for the PENset function 10 times: ' + str(executionTime))




# check the computing time for BrokenGeo function
G=np.array([0.1,0.1,0.2,0.5,0.1])
pen=np.array([0.15,0.15,0.15,0.4,0.15])
Tra,cost_store=Geo.ReverseGeo(pen,G,F,m,Q,1)
startTime = time.time()

for i in range(1000):
    Geo.BrokenGeo(Tra,Mean,cost_store,F,Q,m,0.01)

executionTime = (time.time() - startTime)
print('Execution time in seconds for the BrokenGeo function 1000 times: ' + str(executionTime))



# check the computing time for GeodesicAndCost function

H=np.array([0.8,0.05,0.05,0.05,0.05])
G=np.array([0.1,0.1,0.2,0.5,0.1])
startTime=time.time()
GEO,COST,GEO1,COST1,Total_COST,Count=Geo.GeodesicAndCost(H,G,PEN,mesh,F,m,Q)
executionTime = (time.time() - startTime)
print('Execution time in seconds for GeosesicAndCost function: ' + str(executionTime))







