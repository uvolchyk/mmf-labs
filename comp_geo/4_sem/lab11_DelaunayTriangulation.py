import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import random
from math import pi
import math
from util import rotate
from operator import itemgetter

matplotlib.use('TkAgg')
fig, ax = plt.subplots()

MIN = -100
MAX = 100

triangulation = []


def didArrive(poly, point) -> bool:
    flag = True
    for item in poly:
        if item[0] == point[0] and item[1] == point[1]:
            flag = False
            break
    return flag


def generatePoints(size) -> list:
    k = []
    i = 0
    while i < size:
        q = np.random.randint(MIN,MAX,size=(size,2))[0]
        if didArrive(k, q):
            k.append(q)
        else:
            i -= 1
        i += 1
    return k


def baseLine(poly) -> list:
    min_angle = 2*pi
    second = []
    first = mostDownPoint(poly)
    for i in range(len(poly)):
        v = [poly[i][0]-first[0],poly[i][1]-first[1]]
        if angleBetween(v,[1,0]) < min_angle and ((poly[i][0] != first[0] and poly[i][1] != first[1])):
            min_angle = angleBetween(v,[1,0])
            second = poly[i]
    return [first,second]


def angleBetween(v1, v2) -> float:
    v1_u = v1 / np.linalg.norm(v1)
    v2_u = v2 / np.linalg.norm(v2)
    return np.arccos(np.clip(np.dot(v1_u, v2_u), -1.0, 1.0))


def mostDownPoint(poly) -> list:
    most_down = poly[0]
    for i in range(1,len(poly)):
        if most_down[1] > poly[i][1]:
            most_down = poly[i]
    return most_down


def byGreatestAngle(poly,q1,q2) -> list:
    angle = 0
    res = []
    for i in range(len(poly)):
        v1 = [q1[0]-poly[i][0],q1[1]-poly[i][1]]
        v2 = [q2[0]-poly[i][0],q2[1]-poly[i][1]]
        angb = angleBetween(v1,v2)
        if angb > angle and rotate(q1,q2,poly[i]) >= 0:
            angle = angb
            res = poly[i]
    return res


def isProperTriangle(trian) -> bool:
    flag = True
    key_triangle = sorted(trian, key=itemgetter(1))
    for i in range(len(triangulation)):
        cur_triangle = sorted(triangulation[i], key=itemgetter(1))
        if areEqual(cur_triangle, key_triangle):
            flag = False
            break
    return flag


def areEqual(ar1,ar2) -> bool:
    if len(ar1) != len(ar2):
        return False
    for i in range(len(ar1)):
        if ar1[i][0] != ar2[i][0] or ar1[i][1] != ar2[i][1]:
            return False
    return True


def findTriangulation(poly, q1, q2):
    new_point = byGreatestAngle(poly,q1,q2)

    if len(new_point) == 0:
        return
    else:
        if isProperTriangle([q1,new_point,q2]):
            triangulation.append([q1,new_point,q2])
            findTriangulation(poly,q1,new_point)
            findTriangulation(poly,new_point,q2)


def plotTriangulation(points: list):
    for triangle in points:
        x,y = zip(*triangle)
        plt.triplot(x,y, color='k', linewidth=0.5)
        

def main():
    print("Input points number")
    n = int(input("n: "))
    poly = generatePoints(n)
    b_line = baseLine(poly)
    findTriangulation(poly,b_line[0],b_line[1])
    plotTriangulation(triangulation)
    plt.show()


if __name__ == "__main__":
    main()