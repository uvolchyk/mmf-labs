import random
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.animation import FuncAnimation
from matplotlib import collections as mc
import math
from util import *
from operator import itemgetter

matplotlib.use('TkAgg')

#https://en.wikipedia.org/wiki/Cyrus%E2%80%93Beck_algorithm

MAX_DIAM = 300
RADIAN = 57.295779513082

fig, ax = plt.subplots()
ax.axis([-1000, 1000, -1000, 1000])
numberOfPoints = 100


def pointOfIntersection(p1,p2,p3,p4):
    # p1,p2,p3,p4 = np.array(p1),np.array(p2),np.array(p3),np.array(p4)
    # normal = np.array([p4[1]-p3[1],-p4[0]+p3[0]])
    # param = -1 * np.dot(normal,(p1-p3))/np.dot(normal,(p2-p1))
    # return list(p1 + param*(p2-p1))
    a1 = p2[0] - p1[0]
    a2 = - p4[0] + p3[0]
    a3 = p3[0] - p1[0]
    b1 = p2[1] - p1[1]
    b2 = -p4[1] + p3[1]
    b3 = p3[1] - p1[1]
    t2 = (a3*b1 - b3*a1)/(a2*b1 - b2*a1)
    t1 = (a3 - t2*a2)/a1
    return t1


fPoly = np.random.randint(-800,800,size=(numberOfPoints,2,2))
sPoly = np.random.randint(-600,600,size=(numberOfPoints,2))
ch = jarvis(sPoly)


# ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
# ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
# ✨✨✨                        ✨✨✨
# ✨✨✨       MAGIC IS HERE    ✨✨✨
# ✨✨✨                        ✨✨✨
# ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
# ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

def doShit(lines,polygon):
    result = []

    for o,f in lines:
        curLine = f - o
        tA, tB = 0,1    
        for i in range(len(polygon) - 1):
            guide = np.array([polygon[i+1][0]-polygon[i][0],polygon[i+1][1]-polygon[i][1]])
            normal = [guide[1],-guide[0]]

            # param describing intersection of an cut-poly edge with a line
            tE = np.array(pointOfIntersection(o,f,polygon[i],polygon[i+1]))

            dotProd = np.dot(normal,curLine)
            if dotProd == 0:
                if rotate(polygon[i],polygon[i+1],o) < 0:
                    continue
            if dotProd < 0:
                tA = max(tA,tE)
            if dotProd > 0:
                tB = min(tB,tE)
        if tA <= tB:
            result.append([o + curLine*tA, o + curLine*tB])

    return result




# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
# 🔥🔥🔥
clipped = doShit(fPoly,ch)

lc = mc.LineCollection(fPoly,linewidths=1)
rc = mc.LineCollection(clipped,linewidths=1,colors='g')

# origin lines
ax.add_collection(lc)
# clipped lines
ax.add_collection(rc)

cx,cy = zip(*ch)
ax.plot(cx,cy,'r')

plt.show()