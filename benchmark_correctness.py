#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 24 12:28:57 2021

@author: yingxue
"""
import Geodesics as Geo
import numpy as np


PEN=np.array([[0.1,0.2],[0.10,0.12],[0.15,0.25],[0.42,0.46]])
Q=np.array([[0,0.25,0.25,0.25,0.25],[0.25,0,0.25,0.25,0.25],[0.25,0.25,0,0.25,0.25],[0.25,0.25,0.25,0,0.25],[0.25,0.25,0.25,0.25,0]])
m=1/1000000
mesh=0.005
F=np.power([200,200,200,200,200],[1,1.08,1.1,1.11,1.12])




# check the one step cost from H to G.
# cost(H,G)=0.991566 
H=np.array([0.8,0.05,0.05,0.05,0.05])
G=np.array([0.1,0.1,0.2,0.5,0.1])
cost=Geo.OneStepCost(H,G,F,m,Q)
cost=round(cost,6)
print('the true value of OneStepCost(H,G,F,m,G) is 0.991566')
print('the actual computation of OneStepCost(H,G,F,m,G) is ' + str(cost))




    
# check the one step reverse geodesic. geo=[0.92719,0.01723,0.01799,0.01849,0.01910]
Tgeo=np.array([0.92719,0.01723,0.01799,0.01849,0.01910])
H=np.array([0.8,0.05,0.05,0.05,0.05])
G=np.array([0.6,0.1,0.1,0.1,0.1])
geo=Geo.OneStepGeo(H,G,F,m,Q)
print('the true value of OneStepGeo(H,G,F,m,G) is ' + str(Tgeo))
print('the actual computation of OneStepGeo(H,G,F,m,G) is ' + str(geo))





#check the reverse geodesic given the target histogram G and penultimate point pen
TTra=np.array([[0.1       , 0.1       , 0.2       , 0.5       , 0.1       ],
       [0.15      , 0.15      , 0.15      , 0.4       , 0.15      ],
       [0.21606355, 0.19535446, 0.10015551, 0.29133738, 0.1970891 ],
       [0.2957019 , 0.22712488, 0.05624891, 0.18638334, 0.23454098],
       [0.38130432, 0.23861582, 0.02369904, 0.09839179, 0.25798903],
       [0.46167621, 0.2281622 , 0.00553344, 0.0374996 , 0.26712854]])
Tcost_store = np.array([0.        , 0.03496608, 0.03709824, 0.04085406, 0.04640163, 0.05334294])
G=np.array([0.1,0.1,0.2,0.5,0.1])
pen=np.array([0.15,0.15,0.15,0.4,0.15])
Tra,cost_store=Geo.ReverseGeo(pen,G,F,m,Q,1)
print('the true value of geodesic of ReverseGeo(pen,G,F,m,Q,1) is \n ' + str(TTra))
print('the actual computation of geodesic of ReverseGeo(pen,G,F,m,Q,1) is \n' + str(Tra))
print('the true value of cost of ReverseGeo(pen,G,F,m,Q,1) is \n ' + str(Tcost_store))
print('the actual computation of cost of ReverseGeo(pen,G,F,m,Q,1) is \n' + str(cost_store))






# check the mean trajectory at step T+1 given H_{T}=H, 
# MT = [0.698503141532489   0.066700985870627   0.074157091702404   0.078192106586033   0.082446674308448]
TMT=np.array([0.698503141532489,   0.066700985870627,   0.074157091702404,   0.078192106586033,   0.082446674308448])
H=np.array([0.8,0.05,0.05,0.05,0.05])
MT=Geo.mean_traj(H,F,m,Q)
print('the true value of mean trajectory of mean_traj(H,F,m,G) is \n ' + str(TMT))
print('the actual computation of mean trajectory of mean_traj(H,F,m,G) is \n' + str(MT))




# check the function condition. 
Tflag=[0,4,2]
H=np.array([0.8,0.05,0.05,0.05,0.05])
HH=H
g=len(H)
Mean = np.zeros((15,g))
Mean[0] = H
Compare=100

for i in range(1,15,1):
        # this for loop computes the mean trajectory starting from H
    HH = Geo.mean_traj(HH,F,m,Q)
    Mean[i] = HH

G=np.array([0.1,0.1,0.2,0.5,0.1])
pen=np.array([0.15,0.15,0.15,0.4,0.15])
Tra,cost_store=Geo.ReverseGeo(pen,G,F,m,Q,1)

flag = Geo.condition(Mean,Tra,F,Q,m,0.01)
print('the true value of flag of condition(Mean,Tra,F,Q,m,0.01) is \n ' + str(Tflag))
print('the actual computation of flag of condition(Mean,Tra,F,Q,m,0.01) is \n' + str(flag))





# check function PENset, len(PENSET)=19640
PENSET=Geo.PENset(PEN,mesh,H)
print('the true value of len(PENSET) is 19640')
print('the actual computation of len(PENSET) is ' + str(len(PENSET)) )


# check function BrokenGeo
TTra1=np.array([[0.100000000000000 ,  0.100000000000000,   0.200000000000000 ,  0.500000000000000,   0.100000000000000],
   [0.150000000000000,   0.150000000000000,   0.150000000000000,   0.400000000000000,   0.150000000000000],
   [0.216063547019799  , 0.195354462331896 ,  0.100155513170237 ,  0.291337377523863,   0.197089099954205],
   [0.303110433031868 ,  0.103232074072192,   0.157723341955371 ,  0.194956059074037,   0.240978091866532]])
Tcost_store1=np.array([0, 0.034966076743870, 0.037098243259646, 0.151719400534661])
Tcomp= 0.151719400534661
G=np.array([0.1,0.1,0.2,0.5,0.1])
pen=np.array([0.15,0.15,0.15,0.4,0.15])
Tra,cost_store=Geo.ReverseGeo(pen,G,F,m,Q,1)
Tra1,cost_store1,comp=Geo.BrokenGeo(Tra,Mean,cost_store,F,Q,m,0.01)
print('the true value of Tra1 from function BrokenGeo is \n ' + str(TTra1))
print('the actual computation of Tra1 from function BrokenGeo is \n' + str(Tra1))
print('the true value of cost_store1 from function BrokenGeo is \n ' + str(Tcost_store1))
print('the actual computation of cost_store1 from function BrokenGeo is \n' + str(cost_store1))
print('the true value of comp from function BrokenGeo is \n ' + str(Tcomp))
print('the actual computation of comp from function BrokenGeo is \n' + str(comp))




# check function GeodesicAndCost
# the best path from H to G is
TGEO=np.array([[0.100000000000000,   0.100000000000000,   0.200000000000000 ,  0.500000000000000 ,  0.100000000000000],
   [0.155000000000000,   0.110000000000000,   0.195000000000000,   0.440000000000000,   0.100000000000000],
   [0.234849053516135  , 0.115792135762154  , 0.182454710533690  , 0.369900309266638 ,  0.097003790921383],
   [0.340521676016193,   0.115152382171905,   0.161609129296145,   0.292114840613217,   0.090601971902539],
   [0.464711709037279 ,  0.107000864411009 ,  0.133934785341879 ,  0.212995214399548 ,  0.081357426810285],
   [0.591922051418951,   0.092483152909209,   0.103330259201974 ,  0.141243080335780 ,  0.071021456134085],
   [0.704894259478820 ,  0.074685500306137,   0.074501357856887 ,  0.083922136211204  , 0.061996746146952],
   [0.800000000000000 ,  0.050000000000000 ,  0.050000000000000,   0.050000000000000  , 0.050000000000000]])

H=np.array([0.8,0.05,0.05,0.05,0.05])
G=np.array([0.1,0.1,0.2,0.5,0.1])
GEO,COST,GEO1,COST1,Total_COST,Count=Geo.GeodesicAndCost(H,G,PEN,mesh,F,m,Q)
I=Total_COST.index(min(Total_COST[0:Count]))
print('the true best path from H to G is \n ' + str(TGEO))
print('the actual computation of best path from H to G is \n' + str(GEO1[I]))


















