import numpy as np
import matplotlib.pyplot as plt
import random
from matplotlib.animation import FuncAnimation
from matplotlib import use

use('TkAgg')

fig, ax = plt.subplots()
numberOfDatapoints = 50
ships = np.random.randint(-40,40,size=(numberOfDatapoints,2))
# ships = [[-15,4], [4,-30], [10,20], [20,-26], [20,10]]

def createList(r1, r2): 
    return [item for item in range(r1, r2+1)]
ax.axis([-50,50,-50,50])
ax.set_aspect("equal")
x,y = zip(*ships)
point, = ax.plot(x,y,"o")
n = len(ships)
P = createList(0,n)
S = []

def rotate(A,B,C):
      return (B[0]-A[0])*(C[1]-B[1])-(B[1]-A[1])*(C[0]-B[0])

for i in range(1,n):
    if ships[P[i]][0] < ships[P[0]][0]: # если P[i]-ая точка лежит левее P[0]-ой точки
        P[i], P[0] = P[0], P[i] # меняем местами номера этих точек 
for i in range(2,n): # сортировка вставкой
    j = i
    while j>1 and (rotate(ships[P[0]], ships[P[j-1]], ships[P[j]])<0): 
        P[j], P[j-1] = P[j-1], P[j]
        j -= 1
        
S = [P[0],P[1]] # создаем стек

def update(i):
    print(i)
    points = [ships[i] for i in S]
    x,y = list(zip(*points))
    ax.plot(x,y)
        
    # for i in range(2,n):
    #     # ax.plot(S)
    while rotate(ships[S[-2]],ships[S[-1]],ships[P[i]])<0:
        ax.lines[-1].remove()
        del S[-1] # pop(S)
    S.append(P[i]) # push(S,P[i])

ani = FuncAnimation(fig, update, interval=400, frames=numberOfDatapoints, repeat=True)
plt.show()
