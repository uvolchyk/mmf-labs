# material about "sweep line" algorithm
# https://cyberleninka.ru/article/n/algoritmy-vychislitelnoy-geometrii-peresechenie-otrezkov-metod-zametaniya-ploskosti/viewer

import random
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.animation import FuncAnimation
import math
from util import *
from operator import itemgetter

matplotlib.use('TkAgg')

MAX_DIAM = 300
RADIAN = 57.295779513082

fig, ax = plt.subplots()
ax.axis([-1000, 1000, -1000, 1000])
numberOfPoints = 20

def doThings(sh1, sh2):
    flag = False
    sh1 = list(sh1)
    sh2 = list(sh2)
    shell1 = list.copy(sh1)
    shell2 = list.copy(sh2)
    result = []
    sh1 = sh1[:-1]
    sh2 = sh2[:-1]

    ai,aj = [0,0]
    for i in range(len(sh1)):
        for j in range(len(sh2)):
            if isIntersectQ(shell1[i],shell1[i+1],shell2[j],shell2[j+1]):
                result.append(pointOfIntersection(shell1[i],shell1[i+1],shell2[j],shell2[j+1]))
                # np.concatenate((result,pointOfIntersection(shell1[i],shell1[i+1],shell2[j],shell2[j+1])))
                flag = True
                break
        if flag:
            ai,aj = i,j
            break

    if not flag:
        return result

    shell1 = list(moveOriginTo(ai, sh1))
    shell2 = list(moveOriginTo(aj, sh2))
    shell1 = list(shell1 + shell1[:2])
    shell2 = list(shell2 + shell2[:2])

    i,j = 0,0
    while flag:
        if (len(shell1) < (i + 2)) or (len(shell2) < (j + 2)):
            break
        if isFirstToSecond(shell1[i],shell1[i+1],shell2[j],shell2[j+1]) \
        and isFirstToSecond(shell2[j],shell2[j+1],shell1[i],shell1[i+1]):
            if isOffScene(shell1[i], shell1[i+1],shell2[j],shell2[j+1]):
                i+=1
            else:
                j+=1
            continue
        if isFirstToSecond(shell1[i],shell1[i+1],shell2[j],shell2[j+1]) \
        and not isFirstToSecond(shell2[j],shell2[j+1],shell1[i],shell1[i+1]):
            if isOffScene(shell1[i], shell1[i+1],shell2[j],shell2[j+1]):
                i+=1
            else:
                result.append(shell1[i+1])
                i+=1
            continue
        if not isFirstToSecond(shell1[i],shell1[i+1],shell2[j],shell2[j+1]) \
        and isFirstToSecond(shell2[j],shell2[j+1],shell1[i],shell1[i+1]):
            if isOffScene(shell2[j], shell2[j+1],shell1[i],shell1[i+1]):
                j+=1
            else:
                result.append(shell2[j+1])
                j+=1
            continue
        if not isFirstToSecond(shell1[i],shell1[i+1],shell2[j],shell2[j+1]) \
        and not isFirstToSecond(shell2[j],shell2[j+1],shell1[i],shell1[i+1]):
            if not isIntersectQ(shell1[i],shell1[i+1],shell2[j],shell2[j+1]):
                if isOffScene(shell1[i], shell1[i+1],shell2[j],shell2[j+1]):
                    i+=1
                else:
                    j+=1
                continue
            if (len(shell1)<(i+2)) or (len(shell2)<(j+2)):
                break
            if isIntersectQ(shell1[i],shell1[i+1],shell2[j],shell2[j+1]):
                # result.append(intersection(line(shell1[i],shell1[i+1]), line(shell2[j],shell2[j+1])))
                # np.concatenate((result,pointOfIntersection(shell1[i],shell1[i+1],shell2[j],shell2[j+1])))
                result.append(pointOfIntersection(shell1[i],shell1[i+1],shell2[j],shell2[j+1]))
                if isOffScene(shell1[i], shell1[i+1],shell2[j],shell2[j+1]):
                    i+=1
                else:
                    j+=1
            continue
    return result



def isFirstToSecond(p1,p2,p3,p4):
    p1 = np.array(p1)
    p2 = np.array(p2)
    p3 = np.array(p3)
    p4 = np.array(p4)
    flag = False
    d1 = np.linalg.det([p4-p3,p2-p1])
    d2 = np.linalg.det([p4-p3,p2-p3])
    return True if ((d1 < 0) and (d2 > 0)) or ((d1 > 0) and (d2 < 0)) else False
    
def pointOfIntersection(p1,p2,p3,p4):
    p1,p2,p3,p4 = np.array(p1),np.array(p2),np.array(p3),np.array(p4)
    normal = np.array([-(p4[1]-p3[1]),p4[0]-p3[0]])
    param = -1 * np.dot(normal,(p1-p3))/np.dot(normal,(p2-p1))
    return list(p1 + param*(p2-p1))

def isIntersectSecondQ(p1,p2,p3,p4):
    p1=np.array(p1)
    p2=np.array(p2)
    p3=np.array(p3)
    p4=np.array(p4)
    # return True if rotate(p3,p4,p1)*rotate(p3,p4,p2)<=0 else False
    return True if np.linalg.det([p4-p3,p1-p3])*np.linalg.det([p4-p3,p2-p3]) < 0 else False

def isIntersectQ(p1,p2,p3,p4):
    p1 = np.array(p1)
    p2 = np.array(p2)
    p3 = np.array(p3)
    p4 = np.array(p4)
    return isIntersectSecondQ(p1,p2,p3,p4) if \
            np.linalg.det([p2-p1,p3-p1])*np.linalg.det([p2-p1,p4-p1]) <= 0 else False

def isOffScene(p1,p2,p3, p4):
    return True if ((p2[0]-p3[0])*(p4[1]-p3[1])-(p2[1]-p3[1])*(p4[0]-p3[0])) >= 0 else False
    # return True if isToLeft(p3,p4,p1) else False

fPoly = np.random.randint(-300,500,size=(numberOfPoints,2))
sPoly = np.random.randint(-500,200,size=(numberOfPoints,2))

# fPoly = sorted(fPoly, key=lambda p: p[0], reverse=True)
# sPoly = sorted(sPoly, key=lambda p: p[0], reverse=True)

# fPoly = sorted(fPoly, key=itemgetter(1))
# sPoly = sorted(sPoly, key=itemgetter(1))


# fConvex = fPoly
# sConvex = sPoly

fConvex = jarvis(fPoly)
sConvex = jarvis(sPoly)

def update(frame):
    global fConvex
    global sConvex

    result = doThings(sConvex, fConvex)

    fx,fy = zip(*fConvex)
    sx,sy = zip(*sConvex)

    fConvex = (np.array(fConvex) + np.array([0,-1]))
    sConvex = (np.array(sConvex) + np.array([0,1]))
    rx,ry = zip(*result) if result != [] else [[0],[0]]
    rx = list.copy(list(rx)) + list.copy(list(rx[:1]))
    ry = list.copy(list(ry)) + list.copy(list(ry[:1]))

    ptF, = ax.plot(fx,fy, 'r')
    ptS, = ax.plot(sx,sy, 'g')
    ptR, = ax.plot(rx,ry,'b')
    return ptF, ptS, ptR

ani = FuncAnimation(fig, update, interval=10, blit=True, repeat=True,frames=1)
plt.show()