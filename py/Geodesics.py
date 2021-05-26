#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun May 23 14:41:42 2021

@author: yingxue
"""

import numpy as np
import itertools


def OneStepCost(H,G,F,m,Q):
    # this function compute the one step cost from H to G
    g=len(H)
    phi=np.zeros(g)
    U=np.zeros(g)
    pop=np.matmul(H,F.transpose())
    KL=0
    CC=0
    flag=0
    LL=np.array([0,0,0])
    LL1=np.array([0,0,0])
    if min(H)>0:
       LL=G/(F*H)
    else:
       flag=1
       
    if pop !=0 and max(LL)<710 and flag==0:
       phi = F * H / pop
       U = np.exp (LL)
       
    else:
       flag=1
    if min(phi)>0 and flag==0:
        LL1= G/phi
    else:
        flag=1
        
    if min(LL1)>0 and flag==0:
        KL=sum(G*np.log(LL1))
    else:
        flag=1
    if min(U)>0 and flag==0:
       for j in range(g):
           for k in range(g):
               CC=CC+m*F[j]*H[j]*Q[j][k]*(1-U[k]/U[j])
    else:
       flag=1
    if flag==1:
        CC=0
    else:
       CC=CC +KL
    return(CC)
    
    


    
def OneStepGeo(y,z,F,m,Q):
    # this function computes the reverse geodesic h_{T}=xx given h_{T+1}=y, and h_{T+2}=z 
    
    g = len(y)
    X = np.zeros(g)
    x = np.zeros(g)
    alpha = np.zeros(g)
    e = np.zeros((g,g))
    f = np.zeros((g,g))
    beta = np.zeros(g)
    pop = np.matmul(F,y.transpose())
    flag=0
    LL=F/pop-z / y
    if max(LL)<710:
       X= y/F * np.exp(F/pop-z / y)
    else:
       flag=1
    x= X/sum(X)
    
    for s in range(g):   
        for k in range(g):
            if -y[s] / (F[s] * x[s]) + y[k] / (F[k] * x[k])<710 and -z[s] / (F[s] * y[s]) + z[k] / (F[k] * y[k])<710 and flag==0:
                e[s,k] = np.exp(-y[s] / (F[s] * x[s]) + y[k] / (F[k] * x[k]) )
                f[s,k] = np.exp(-z[s] / (F[s] * y[s]) + z[k] / (F[k] * y[k]))
            else:
                flag=1
    
    for s in range(g):
        for k in range(g):
            if X[s] !=0 and y[s]!=0 and flag==0:
               alpha[s] = alpha[s] + Q[s,k]*e[s,k] - F[k]*X[k]*Q[k,s]*e[k,s]/(F[s]*X[s])
               beta[s] = beta[s]+F[s]*Q[s,k] - (F[s]+z[s]/y[s])*f[s,k]*Q[s,k] - z[s]/(F[s]*y[s]*y[s]) *F[k]*y[k]*Q[k,s]*f[k,s]
            else:
               flag=1
    if flag==0:    
       w = alpha + beta- np.inner(x, alpha+beta)
       xx = x + m*x*w
       
    else:
        xx=np.zeros(g)
        
    return(xx)
    
    
def ReverseGeo(pen,Y,F,m,Q,Compare):
    # given the penultimate point pen and the target point Y, this function computes a reverse geodesics 
    # if the cost of the first two steps of the reverse geodesic is bigger than Compare, return a zero array for Tra 
    y = pen
    g=len(Y)
    Tra = np.array([Y,y])
    cost_store = np.array([0, OneStepCost(y,Y,F,m,Q)])
    z = Y
    store = y
    y = OneStepGeo(y,z,F,m,Q)
    cc = OneStepCost(y,store,F,m,Q)
    Flag=1
    while min(y) > 0.001 and max(y) < 1 and cc > 0:
        Tra = np.append(Tra,[y],axis=0)
        cost_store = np.append(cost_store, cc)
        if len(cost_store)==3 and sum(cost_store)>Compare:
            Flag=0
            #print(1)
            break
                        
        z = store
        store = y
        y = OneStepGeo(y,z,F,m,Q)
        if not y.any():
            break
        else:
            cc = OneStepCost(y,store,F,m,Q)
            if cc==0:
                break
    if Flag==0:
        Tra=np.zeros(g)
        
    
    return Tra,cost_store
    

def mean_traj(H,F,m,Q):
    # this function computes the mean of step T+1 given H_T=H at step T, which is MT=E(H_{T+1}|H_T=H) 
     g = len(H)
     MT = np.zeros(g)
     pop = np.matmul(F,H.transpose())
     
     for j in range(g):
         MT[j] = F[j] * H[j] / pop
         for k in range(g):
             MT[j] = MT[j]- 1/pop* m * Q[j,k] * F[j] * H[j] + 1/pop *m * Q[k,j] * F[k] * H[k]
     return(MT)


def condition(Mean,geo,F,Q,m,eps):
    # Given the mean trajectory Mean and a reverse geodesic geo, this function returns flag=[a b c]
    # a=1 if geo is a complete reverse geodesic, which means geo enters a small zone of a histogram in Mean
    # a=0 if geo is a incomplete reverse geodesic, which means geo doesn't enter any zone around histograms in Mean
    # b is the index of a histogram in Mean, c is the index of a histogram in geo such that the jump from Mean_b to geo_a is the best jump.
    K = len(geo)
    dist = np.zeros((15,K))
    
    for i in range(15):
        for j in range(K):
            dist[i,j] = np.linalg.norm(Mean[i]-geo[j])
    
    a = np.min(dist)
    ind = np.unravel_index(np.argmin(dist, axis=None), dist.shape)
    if a < eps:
        flag = [1,ind[0],ind[1]]
    else:
        CC = np.zeros((15,K))
        for i in range(15):
            for j in range(K):
                CC[i,j] = OneStepCost(Mean[i],geo[j],F,m,Q)

        ind1 = np.unravel_index(np.argmin(CC, axis=None), CC.shape)
        flag = [0,ind1[0],ind1[1]]
    return flag

def PENset(PEN,mesh,H):
    # Given the np array PEN and mesh, this function returns all the penultimate points
    g=len(H)
    
    PEN_list=[None]*(g-1) 
    Leng=1
    for i in range(g-1):
        PEN_list[i]=[*range(int(PEN[i,1]/mesh),int(PEN[i,0]/mesh)-1,-1)]
        PEN_list[i] = [element * mesh for element in PEN_list[i]]
        Leng=Leng*len(PEN_list[i])
    
    PENset=np.zeros((Leng,g))
    i=0
    
    for element in itertools.product(*PEN_list):
       
        y=np.asarray(element)
        if sum(y)<0.999:
            PENset[i]= np.append(y,1-sum(y))
            i=i+1
    PENset=PENset[0:i]
    return PENset
 
def BrokenGeo(Tra,Mean,cost_store,F,Q,m,eps):
    # Given a reverse geodesic Tra, mean trajectory Mean, and the one step cost for every step in Tra
    # BrokenGeo returns a complete path from H to G by truncating Tra and connecting it to Mean.
    G = Tra
    C= cost_store
    comp = 100
    flag = condition(Mean,G,F,Q,m,eps)
    
    if flag[0] == 1 or flag[1]==0:
        J = flag[1]
        for j in range(min(flag[2]+2,len(G))-1,max(flag[2]-1,0)-1,-1):
            
            c1 = OneStepCost(Mean[J],G[j],F,m,Q)
            C1 = sum(C[0:j+1])+c1
            if C1<comp and c1>0 :
                comp = C1
                Tra1=np.append( G[0:j+1] , [Mean[J]] , axis=0)
                Cost1=np.append(C[0:j+1] , comp)
    else:
        J = flag[1]
        I = flag[2]
        comp = sum(C[0:I+1])+OneStepCost(Mean[J],G[I],F,m,Q)
        Tra1 = np.append(G[0:I+1],[Mean[J]],axis=0)
        Cost1 = np.append(C[0:I+1],comp)
    return Tra1,Cost1,comp
    
   


#import cProfile
#import pstats

def GeodesicAndCost(H,G,PEN,mesh,F,m,Q):
    # H is the starting histogram, G is the target histogram
    # PEN stores the intervals for penultimate histograms, 
    # mesh is the mesh size to discretize PEN
    # this function returns all the reverse geodesics and the complete reverse geodesics and their cost.
    
    g=len(H)
    #profile = cProfile.Profile()
    #profile.enable()
    PENSET=PENset(PEN,mesh,H)
    Leng=len(PENSET)
    GEO=[None]*Leng
    COST=[None]*Leng
    GEO1=[None]*Leng
    COST1=[None]*Leng
    Total_COST=[None]*Leng
    Y = G
    HH = H
    
    Count=0
    Mean = np.zeros((15,g))
    Mean[0] = H
    #Total_COST=[]
    Compare=100
    for i in range(1,15,1):
        # this for loop computes the mean trajectory starting from H
        HH = mean_traj(HH,F,m,Q)
        Mean[i] = HH
    
    for i in range(Leng):
        y = PENSET[i]
        Tra,cost_store=ReverseGeo(y,Y,F,m,Q,Compare)
        
        if Tra.any():
            Tra1,Cost1,comp=BrokenGeo(Tra,Mean,cost_store,F,Q,m,0.01)
            GEO[Count]=Tra
                        
            # GEO stores all the reverse geodesics which are not so costly
            COST[Count]=cost_store
            # COST stores the one step cost of each step of the reverse geodesics that are not too costly
            GEO1[Count]=Tra1
                        
            # GEO1 stores the trajectory from H to G using the reverse geodesics in GEO
            COST1[Count]=Cost1
            # COST1 stores the one step cost of each step of trajectoris in GEO1, the last element in the array stores the cost of the whole trajectory
            Total_COST[Count]=comp
            # Total_COST stores the total cost of the trajectory in GEO1
            Count=Count+1
            if Count % 100 ==0:
                # update Compare every 100 steps, so we can stop generateing more reverse geodesics with high cost
               Compare=min(Total_COST[0:Count-1])
                        
                        
    #profile.disable()
    #ps = pstats.Stats(profile)
    #ps.print_stats()                    
    return GEO,COST,GEO1,COST1,Total_COST, Count


        
        
        
        
    
    
        
        
    



