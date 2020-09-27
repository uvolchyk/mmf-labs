import random
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.animation import FuncAnimation
import math

matplotlib.use('TkAgg')
MAX_DIAM = 300
RADIAN = 57.295779513082

fig, ax = plt.subplots()
ax.axis([-200, 200, -200, 200])
numberOfPoints = 20

def det(p1,p2):
    return p1[0]*p2[1]-p2[0]*p1[0]

def distanceTo(p1,p2):
    return math.pow(p1[0]-p2[0],2) + math.pow(p1[1]-p2[1],2)

def rotate(A,B,C):
      return (B[0]-A[0])*(C[1]-B[1])-(B[1]-A[1])*(C[0]-B[0])

def triangleSquare(p1,p2,p3):
    a = math.sqrt(distanceTo(p1,p2))
    b = math.sqrt(distanceTo(p2,p3))
    c = math.sqrt(distanceTo(p1,p2))
    p = (a+b+c)/2
    return math.sqrt(abs(p*(p-a)*(p-b)*(p-c)))

def jarvis(A):
    n = len(A)
    P = [i for i in range(n)]
    
    # start point
    for i in range(1,n):
      if A[P[i]][0]<A[P[0]][0]: 
        P[i], P[0] = P[0], P[i]  
    H = [P[0]]
    del P[0]
    P.append(H[0])
    while True:
      right = 0
      for i in range(1,len(P)):
        if rotate(A[H[-1]],A[P[right]],A[P[i]])<0:
          right = i
      if P[right]==H[0]: 
        break
      else:
        H.append(P[right])
        del P[right]
    result = [A[i] for i in H]      
    result.append(result[0])
    return result

def genVelocity(angle):
    return np.array([
        math.cos(angle),
        math.sin(angle)
    ])

def diameter(points):
    size = len(points)
    i1 = 0
    i2 = 0
    itemp = 0
    end = 0
    d = 0
    dtemp = 0
    dmax = 0
    j = 1
    while(
        triangleSquare(points[0],points[size - 1], points[j])
        <
        triangleSquare(points[0],points[size - 1], points[j+1])
        ):
        j+=1
    start = j
    for i in range(size - 1):
        j = 0
        while(
            triangleSquare(points[i+1],points[i],points[(j+start-1)%size]) 
            < 
            triangleSquare(points[i+1],points[i],points[(j+start)%size])
            ):
            j+=1
        end = j + start
        itemp = (start-1) % size
        d = distanceTo(points[i],points[itemp])
        for j in range(start, end + 1):
            dtemp = distanceTo(points[i],points[(j-1)%size])
            if dtemp > d:
                d = dtemp
                itemp = (j-1)%size

        if d > dmax:
            dmax = d
            i1 = i
            i2 = itemp
        start = end
    return [i1,i2]

def invertedVector(p1,p2):
    return (np.array(p2) - np.array(p1))/(2*(np.linalg.norm(np.array(p2)-np.array(p1))))

def indexOfValue(value, points):
    for i in range(len(points)):
        if value[0] == points[i][0] and value[1] == points[i][1]:
            return i
    return 0

def genSpeed(size):
    result = []
    for _ in range(size):
        result.append(genVelocity(random.randint(0,360)))
    return result

velocity = genSpeed(numberOfPoints)
points = np.random.randint(-80,80, size=(numberOfPoints, 2))

def movePoints(param):
    global points
    shell = jarvis(points) 
    s1,s2 = diameter(shell)
    if distanceTo(shell[s1], shell[s2]) > math.pow(MAX_DIAM,2):
        velocity[indexOfValue(shell[s1], points)] = invertedVector(shell[s1], shell[s2])
        velocity[indexOfValue(shell[s2], points)] = -velocity[indexOfValue(shell[s1],points)]
    points = np.array(points) + np.array(velocity)

def update(frame):
    global points
    shell = jarvis(points)
    s1, s2 = diameter(shell)
    d1, d2 = shell[s1], shell[s2]
    pX,pY = zip(*shell)
    x,y = zip(*points)
    pts, = ax.plot(x,y,'bo')
    ptd, = ax.plot([d1[0],d2[0]],[d1[1],d2[1]], 'r')
    movePoints(frame)
    point, = ax.plot(pX, pY, 'g')
    return point, pts, ptd
    
ani = FuncAnimation(fig, update, interval=10, blit=True, repeat=True,frames=1)
plt.show()
